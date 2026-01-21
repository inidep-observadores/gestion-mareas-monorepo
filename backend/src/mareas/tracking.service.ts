
import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { parse } from 'csv-parse/sync';
import { getDistance } from 'geolib';
import { DateTime } from 'luxon';

interface TrackingPoint {
    lat: number;
    lon: number;
    date: Date; // JS Date (UTC)
    speed: number;
    course: number;
}

@Injectable()
export class TrackingService {
    private readonly logger = new Logger(TrackingService.name);
    private readonly PORT_RADIUS_METERS = 5000;
    private readonly GAP_THRESHOLD_MINUTES = 240; // 4h
    private readonly OLD_DATA_THRESHOLD_HOURS = 48;
    private readonly CHECK_INTERVAL_HOURS = 1;
    private readonly TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';

    constructor(private prisma: PrismaService) { }

    /**
     * Called globally by the frontend to trigger periodic checks
     */
    async checkHeartbeat() {
        const KEY = 'TRACKING_CHECK';

        // Find or create status
        let status = await this.prisma.systemStatus.findUnique({ where: { key: KEY } });
        if (!status) {
            status = await this.prisma.systemStatus.create({
                data: { key: KEY, lastUpdate: new Date(0) } // Force check
            });
        }

        const last = DateTime.fromJSDate(status.lastUpdate);
        const now = DateTime.now();
        const diffHours = now.diff(last, 'hours').hours;

        if (diffHours >= this.CHECK_INTERVAL_HOURS) {
            // Fire and forget - don't await strictly for the HTTP response
            this.runAutomatedChecks().catch(e => this.logger.error('Error en verificación automática', e));

            // Update immediately
            await this.prisma.systemStatus.update({
                where: { key: KEY },
                data: { lastUpdate: new Date() }
            });
            return { status: 'Iniciado', timestamp: new Date() };
        }

        return { status: 'Omitido', timestamp: status.lastUpdate };
    }

    async runAutomatedChecks() {
        this.logger.log('Ejecutando verificaciones automáticas de seguimiento...');
        // 1. Get active trips
        const activeMareas = await this.prisma.marea.findMany({
            where: {
                estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } }
            },
            include: { buque: { include: { puertoBase: true } } }
        });

        for (const marea of activeMareas) {
            const buqueId = marea.buqueId;

            // Get last point
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                where: { buqueId },
                orderBy: { timestamp: 'desc' }
            });

            if (lastPoint) {
                const lastTime = DateTime.fromJSDate(lastPoint.timestamp); // Point date is UTC stored
                const now = DateTime.now(); // Server time

                // Alert: Old Data
                const hoursOld = now.diff(lastTime, 'hours').hours;
                if (hoursOld > this.OLD_DATA_THRESHOLD_HOURS) {
                    await this.createAlert(
                        buqueId,
                        'DATOS_DESACTUALIZADOS',
                        `Buque ${marea.buque.nombreBuque} sin reporte por ${Math.round(hoursOld)} horas`,
                        lastPoint.timestamp,
                        { mareaId: marea.id }
                    );
                }
            }
        }
        // Note: Zarpada/Arribo logic usually runs on NEW data import, not just periodic check,
        // but we could re-verify here if needed. For now, rely on Import.
    }

    async importTrackingData(fileBuffer: Buffer) {
        const records = parse(fileBuffer, {
            columns: true,
            skip_empty_lines: true,
            delimiter: [';', ','],
            trim: true,
        });

        let newPointsCount = 0;
        const buquesCache = new Map<string, string>();
        const pointsByShip: Record<string, any[]> = {};

        for (const record of records) {
            const buqueName = record['Buque']?.toUpperCase();
            if (!buqueName) continue;
            if (!pointsByShip[buqueName]) pointsByShip[buqueName] = [];
            pointsByShip[buqueName].push(record);
        }

        for (const [buqueName, points] of Object.entries(pointsByShip)) {
            // Resolve Buque ID
            let buqueId = buquesCache.get(buqueName);
            if (!buqueId) {
                const buque = await this.prisma.buque.findFirst({
                    where: {
                        OR: [
                            { nombreBuque: { contains: buqueName, mode: 'insensitive' } },
                            { matricula: points[0]['Matricula'] }
                        ]
                    }
                });
                if (buque) {
                    buqueId = buque.id;
                    buquesCache.set(buqueName, buque.id);
                } else {
                    continue;
                }
            }

            // Ensure Trajectory
            const tray = await this.prisma.buqueTrayectoria.upsert({
                where: { buqueId },
                update: {},
                create: { buqueId }
            });

            const pointsToInsert = points.map(p => {
                // Raw date from CSV (e.g. "2026-01-08 23:56:00")
                // If the CSV is UTC, `new Date("2026-01-08 23:56:00")` depends on server locale if no 'Z'.
                // User says "CSV is UTC".
                // Robust parsing:
                let dateStr = p['Fecha'];
                // Assume format 'YYYY-MM-DD HH:mm:ss'
                // Create a UTC date object manually to avoid local timezone interference
                const dt = DateTime.fromFormat(dateStr, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
                // Or if it fails try ISO
                const validDt = dt.isValid ? dt : DateTime.fromISO(dateStr, { zone: 'utc' });

                const lat = parseFloat(p['Latitud'].replace(',', '.'));
                const lon = parseFloat(p['Longitud'].replace(',', '.'));
                const speed = parseFloat(p['Velocidad'].replace(',', '.'));
                const course = parseInt(p['Rumbo']);

                return {
                    trayectoriaId: tray.id,
                    buqueId: buqueId,
                    timestamp: validDt.toJSDate(), // Store as native Date (Prisma handles as UTC usually)
                    lat,
                    lon,
                    velocidad: isNaN(speed) ? null : speed,
                    rumbo: isNaN(course) ? null : course,
                };
            }).filter(p => !isNaN(p.timestamp.getTime()) && !isNaN(p.lat) && !isNaN(p.lon));

            if (pointsToInsert.length > 0) {
                const result = await this.prisma.buqueTrayectoriaPunto.createMany({
                    data: pointsToInsert,
                    skipDuplicates: true,
                });
                newPointsCount += result.count;

                // Run analysis on this new batch
                await this.detectPortEvents(buqueId, pointsToInsert);
                await this.analyzeGaps(buqueId, pointsToInsert);
            }
        }

        return { processed: records.length, inserted: newPointsCount };
    }

    // --- Visuals & Data Retrieval ---

    async getLatestFleetPositions() {
        // 1. Get all active buques (those with active Mareas or just all active from Fleet)
        // Preference: Active Mareas first
        const activeMareas = await this.prisma.marea.findMany({
            where: { estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } } },
            include: { buque: true, artePrincipal: true }
        });

        const fleet = [];

        for (const marea of activeMareas) {
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                where: { buqueId: marea.buqueId },
                orderBy: { timestamp: 'desc' }
            });

            // Determine status color based on age
            let status = 'OK';
            if (lastPoint) {
                const hoursOld = DateTime.now().diff(DateTime.fromJSDate(lastPoint.timestamp), 'hours').hours;
                if (hoursOld > 48) status = 'OLD';
            }

            fleet.push({
                id: marea.buque.id,
                name: marea.buque.nombreBuque,
                matricula: marea.buque.matricula,
                type: marea.artePrincipal?.nombre || 'Pesquero',
                status, // 'OK' | 'OLD' | 'ALARM'
                lat: lastPoint?.lat || null,
                lon: lastPoint?.lon || null,
                course: lastPoint?.rumbo || 0,
                speed: lastPoint?.velocidad || 0,
                lastUpdate: lastPoint?.timestamp || null,
                mareaId: marea.id
            });
        }
        return fleet;
    }

    async getVesselHistory(buqueId: string, limit = 2000) {
        const points = await this.prisma.buqueTrayectoriaPunto.findMany({
            where: { buqueId },
            orderBy: { timestamp: 'asc' }, // Chronological for timeline
            take: limit // Safety limit, maybe filter by date range in future
        });

        return points.map(p => ({
            lat: p.lat,
            lon: p.lon,
            timestamp: p.timestamp,
            speed: p.velocidad || 0,
            course: p.rumbo || 0,
            // Calculated props for UI optimization if needed
            isFishing: (p.velocidad || 0) < 4.5 && (p.velocidad || 0) > 1.0 // Example logic
        }));
    }

    // --- Internal Logic ---

    private async detectPortEvents(buqueId: string, points: any[]) {
        const ports = await this.prisma.puerto.findMany({
            where: { activo: true, latitud: { not: null }, longitud: { not: null } }
        });
        if (ports.length === 0) return;

        // Sort chronological
        points.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime());

        // Get state before this batch
        let lastState = { inPort: false, portId: null as string | null };
        const prev = await this.prisma.buqueTrayectoriaPunto.findFirst({
            where: { buqueId, timestamp: { lt: points[0].timestamp } },
            orderBy: { timestamp: 'desc' }
        });
        if (prev) {
            lastState = this.checkPortStatus(prev.lat, prev.lon, ports);
        }

        for (const p of points) {
            const currentState = this.checkPortStatus(p.lat, p.lon, ports);

            if (lastState.inPort && !currentState.inPort) {
                const port = ports.find(x => x.id === lastState.portId);
                // ZARPADA
                const localTime = DateTime.fromJSDate(p.timestamp).setZone(this.TIMEZONE);
                await this.createAlert(buqueId, 'POSIBLE_ZARPADA',
                    `Posible zarpada desde ${port?.nombre} el ${localTime.toFormat('dd/MM HH:mm')}`,
                    p.timestamp);
            } else if (!lastState.inPort && currentState.inPort) {
                const port = ports.find(x => x.id === currentState.portId);
                // ARRIBO
                const localTime = DateTime.fromJSDate(p.timestamp).setZone(this.TIMEZONE);
                await this.createAlert(buqueId, 'POSIBLE_ARRIBO',
                    `Posible arribo a ${port?.nombre} el ${localTime.toFormat('dd/MM HH:mm')}`,
                    p.timestamp);
            }
            lastState = currentState;
        }
    }

    private checkPortStatus(lat: number, lon: number, ports: any[]) {
        for (const port of ports) {
            const dist = getDistance({ latitude: lat, longitude: lon }, { latitude: port.latitud!, longitude: port.longitud! });
            if (dist <= this.PORT_RADIUS_METERS) return { inPort: true, portId: port.id };
        }
        return { inPort: false, portId: null };
    }

    private async analyzeGaps(buqueId: string, sortedPoints: any[]) {
        for (let i = 1; i < sortedPoints.length; i++) {
            const prev = sortedPoints[i - 1];
            const curr = sortedPoints[i];
            const diffMin = (curr.timestamp.getTime() - prev.timestamp.getTime()) / 60000;
            if (diffMin > this.GAP_THRESHOLD_MINUTES) {
                const localTime = DateTime.fromJSDate(prev.timestamp).setZone(this.TIMEZONE);
                await this.createAlert(buqueId, 'GAP_DETECTED',
                    `Hueco de datos (> ${Math.round(diffMin / 60)}h) desde ${localTime.toFormat('dd/MM HH:mm')}`,
                    prev.timestamp);
            }
        }
    }

    private async createAlert(buqueId: string, type: string, titulo: string, date: Date, meta: any = {}) {
        const code = `${type}_${buqueId}_${date.getTime()}`;
        const exists = await this.prisma.alerta.findFirst({ where: { codigoUnico: code } });
        if (exists) return;

        await this.prisma.alerta.create({
            data: {
                codigoUnico: code,
                tipo: 'TRACKING_EVENT',
                titulo: titulo,
                descripcion: titulo,
                estado: 'PENDIENTE',
                prioridad: 'MEDIA',
                fechaDetectada: date,
                metadata: { ...meta, buqueId },
                visible: true
            }
        });
    }
}
