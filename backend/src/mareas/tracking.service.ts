
import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { parse } from 'csv-parse/sync';
import { getDistance } from 'geolib';
import { DateTime } from 'luxon';
import { MareaUtils } from '../common/utils/marea.utils';
import * as crypto from 'crypto';

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
        let updatedShipsCount = 0;
        const buquesCache = new Map<string, string>();
        const pointsByShip: Record<string, any[]> = {};
        const errors: { vessel: string, reason: string }[] = [];

        // Pre-load numeric matriculas for fallback search
        const allBuques = await this.prisma.buque.findMany({
            select: { id: true, matricula: true }
        });
        const numericMatriculaMap = new Map<number, string>();
        for (const b of allBuques) {
            if (b.matricula && /^\d+$/.test(b.matricula.trim())) {
                const val = parseInt(b.matricula.trim(), 10);
                if (!numericMatriculaMap.has(val)) {
                    numericMatriculaMap.set(val, b.id);
                }
            }
        }

        for (const record of records) {
            const buqueName = record['Buque']?.toUpperCase();
            if (!buqueName) continue;
            if (!pointsByShip[buqueName]) pointsByShip[buqueName] = [];
            pointsByShip[buqueName].push(record);
        }

        for (const [buqueName, points] of Object.entries(pointsByShip)) {
            try {
                // 1. Resolve Buque ID sequentially
                let buqueId = buquesCache.get(buqueName);
                if (!buqueId) {
                    const matriculaRaw = points[0]['Matricula'];
                    const matricula = matriculaRaw ? matriculaRaw.trim() : null;
                    let buqueFound = null;

                    // Priority 1: Exact Matricula
                    if (matricula) {
                        buqueFound = await this.prisma.buque.findUnique({
                            where: { matricula }
                        });
                    }

                    // Priority 2: Name Fallback (with TRIM on DB value via insensitive + trim on input)
                    if (!buqueFound) {
                        // Note: Prisma insensitive mode handles casing, but we need to be careful with spaces.
                        // We'll search by name and then manually verify or trust the lenient match.
                        // For best results, we try exact match insensitive.
                        const nameToSearch = buqueName.trim();
                        buqueFound = await this.prisma.buque.findFirst({
                            where: {
                                nombreBuque: { equals: nameToSearch, mode: 'insensitive' }
                            }
                        });

                        // Auto-correct Matricula if found by name but not matricula
                        if (buqueFound && matricula && buqueFound.matricula !== matricula) {
                            this.logger.log(`Auto-correcting matricula for ${buqueName}: ${buqueFound.matricula} -> ${matricula}`);
                            buqueFound = await this.prisma.buque.update({
                                where: { id: buqueFound.id },
                                data: { matricula: matricula }
                            });
                            updatedShipsCount++;
                        }
                    }

                    // Priority 3: Numeric Matricula Match (if strict string and name failed)
                    if (!buqueFound && matricula && /^\d+$/.test(matricula)) {
                        const matriculaNum = parseInt(matricula, 10);
                        const idFound = numericMatriculaMap.get(matriculaNum);
                        if (idFound) {
                            buqueFound = await this.prisma.buque.findUnique({ where: { id: idFound } });
                            if (buqueFound) {
                                this.logger.log(`Found buque by numeric matricula: ${buqueName} (${matricula}) -> ${buqueFound.nombreBuque} (${buqueFound.matricula})`);

                                // Auto-correct Matricula to match CSV format (as per user request)
                                if (buqueFound.matricula !== matricula) {
                                    this.logger.log(`Auto-correcting matricula (numeric match) for ${buqueName}: ${buqueFound.matricula} -> ${matricula}`);
                                    buqueFound = await this.prisma.buque.update({
                                        where: { id: buqueFound.id },
                                        data: { matricula: matricula }
                                    });
                                    updatedShipsCount++;
                                }
                            }
                        }
                    }

                    if (buqueFound) {
                        buqueId = buqueFound.id;
                        buquesCache.set(buqueName, buqueFound.id);
                    } else {
                        const reason = `Buque no encontrado: ${buqueName} (Matrícula: ${matricula || 'N/A'})`;
                        this.logger.warn(reason);
                        errors.push({ vessel: buqueName, reason: 'Buque no encontrado en base de datos' });
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
                    let dateStr = p['Fecha'];
                    const dt = DateTime.fromFormat(dateStr, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
                    const validDt = dt.isValid ? dt : DateTime.fromISO(dateStr, { zone: 'utc' });

                    const lat = parseFloat(p['Latitud'].replace(',', '.'));
                    const lon = parseFloat(p['Longitud'].replace(',', '.'));
                    const speed = parseFloat(p['Velocidad'].replace(',', '.'));
                    const course = parseInt(p['Rumbo']);

                    return {
                        trayectoriaId: tray.id,
                        buqueId: buqueId,
                        timestamp: validDt.toJSDate(),
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

                    // Solo analizar GAPs si tiene marea activa (mismo criterio que movimientos de puerto)
                    const mareaActiva = await this.prisma.marea.findFirst({
                        where: {
                            buqueId,
                            estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } }
                        },
                        include: { buque: true, observadorPrincipal: true }
                    });

                    if (mareaActiva) {
                        await this.analyzeGaps(buqueId, pointsToInsert, mareaActiva);
                    }
                }
            } catch (e) {
                this.logger.error(`Error processing ship ${buqueName}:`, e);
                errors.push({ vessel: buqueName, reason: `Error interno: ${e.message}` });
            }
        }

        return {
            processed: records.length,
            inserted: newPointsCount,
            updated: updatedShipsCount,
            errors: errors
        };
    }

    // --- Visuals & Data Retrieval ---

    async getMareaTrackingInfo(mareaId: string) {
        const marea = await this.prisma.marea.findUnique({
            where: { id: mareaId },
            include: {
                buque: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' }
                },
                observadorPrincipal: true
            }
        });

        if (!marea) throw new Error('Marea no encontrada');

        // Logic reused from getLatestFleetPositions
        let voyageStart: Date | null = marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
        if (marea.etapas.length > 0 && marea.etapas[0].fechaZarpada) {
            if (!voyageStart || marea.etapas[0].fechaZarpada < voyageStart) {
                voyageStart = marea.etapas[0].fechaZarpada;
            }
        }

        let voyageEnd: Date | null = null;
        const lastStage = marea.etapas[marea.etapas.length - 1];
        if (lastStage && lastStage.fechaArribo) {
            voyageEnd = lastStage.fechaArribo;
        } else {
            voyageEnd = new Date();
        }

        // Adjust hours
        if (voyageStart) {
            voyageStart = DateTime.fromJSDate(voyageStart).setZone(this.TIMEZONE).set({ hour: 0, minute: 0, second: 0, millisecond: 0 }).toJSDate();
        }
        if (voyageEnd) {
            voyageEnd = DateTime.fromJSDate(voyageEnd).setZone(this.TIMEZONE).set({ hour: 23, minute: 50, second: 0, millisecond: 0 }).toJSDate();
        }

        return {
            id: marea.id,
            buqueId: marea.buqueId,
            name: marea.buque.nombreBuque,
            matricula: marea.buque.matricula,
            mareaCode: `${marea.nroMarea}/${marea.anioMarea}`,
            observer: marea.observadorPrincipal?.apellido ? `${marea.observadorPrincipal.apellido}, ${marea.observadorPrincipal.nombre}` : 'Sin asignar',
            voyageStart: voyageStart?.toISOString(),
            voyageEnd: voyageEnd?.toISOString(),
            lastUpdate: marea.fechaUltimaActualizacion,
            totalDays: MareaUtils.calculateNavigatedDays(marea),
            etapas: marea.etapas.map(e => ({
                ...e,
                durationDays: MareaUtils.calculateStageDays(e)
            }))
        };
    }

    async getLatestFleetPositions() {
        const activeMareas = await this.prisma.marea.findMany({
            where: { estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } } },
            include: {
                buque: true,
                artePrincipal: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' }
                },
                observadorPrincipal: true
            }
        });

        const fleet = [];

        for (const marea of activeMareas) {
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                where: { buqueId: marea.buqueId },
                orderBy: { timestamp: 'desc' }
            });

            // Calculate Voyage Bounds
            // Start: Estimated departure, observer start, or first stage departure
            let voyageStart: Date | null = marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
            if (marea.etapas.length > 0 && marea.etapas[0].fechaZarpada) {
                if (!voyageStart || marea.etapas[0].fechaZarpada < voyageStart) {
                    voyageStart = marea.etapas[0].fechaZarpada;
                }
            }

            // End: Last stage arrival or Now
            let voyageEnd: Date | null = null;
            const lastStage = marea.etapas[marea.etapas.length - 1];
            if (lastStage && lastStage.fechaArribo) {
                voyageEnd = lastStage.fechaArribo;
            } else {
                voyageEnd = new Date();
            }

            // Adjust hours as per user request: 00:00 for start, 23:50 for end
            if (voyageStart) {
                const dtStart = DateTime.fromJSDate(voyageStart).setZone(this.TIMEZONE).set({ hour: 0, minute: 0, second: 0, millisecond: 0 });
                voyageStart = dtStart.toJSDate();
            }
            if (voyageEnd) {
                const dtEnd = DateTime.fromJSDate(voyageEnd).setZone(this.TIMEZONE).set({ hour: 23, minute: 50, second: 0, millisecond: 0 });
                voyageEnd = dtEnd.toJSDate();
            }

            // Determine status color based on age
            let status = 'OK';
            if (lastPoint) {
                const hoursOld = DateTime.now().diff(DateTime.fromJSDate(lastPoint.timestamp), 'hours').hours;
                if (hoursOld > 48) status = 'OLD';
            }

            const totalDays = MareaUtils.calculateNavigatedDays(marea);

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
                mareaId: marea.id,
                mareaCode: `${marea.tipoMarea}-${marea.nroMarea}-${marea.anioMarea.toString().slice(-2)}`,
                observer: marea.observadorPrincipal
                    ? `${marea.observadorPrincipal.apellido} ${marea.observadorPrincipal.nombre}`
                    : 'Sin asignar',
                voyageStart,
                voyageEnd,
                totalDays,
                etapas: marea.etapas.map(e => ({
                    ...e,
                    durationDays: MareaUtils.calculateStageDays(e)
                }))
            });
        }
        return fleet;
    }

    async getVesselHistory(buqueId: string, from?: string, to?: string, limit = 30000) {
        const where: any = { buqueId };

        if (from || to) {
            where.timestamp = {};
            if (from) where.timestamp.gte = new Date(from);
            if (to) where.timestamp.lte = new Date(to);
        }

        // We take the LATEST points up to the limit
        const points = await this.prisma.buqueTrayectoriaPunto.findMany({
            where,
            orderBy: { timestamp: 'desc' },
            take: limit
        });

        // Re-sort ascending for the map rendering (chronological)
        return points
            .sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime())
            .map(p => ({
                lat: p.lat,
                lon: p.lon,
                timestamp: p.timestamp,
                speed: p.velocidad || 0,
                course: p.rumbo || 0,
                isFishing: (p.velocidad || 0) < 4.5 && (p.velocidad || 0) > 1.0
            }));
    }

    // --- Internal Logic ---

    private async detectPortEvents(buqueId: string, points: any[]) {
        // 1. Monitorear buques que tienen mareas activas (designada o en ejecución)
        const mareasActivas = await this.prisma.marea.findMany({
            where: {
                buqueId,
                estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } }
            },
            include: {
                etapas: true,
                buque: true,
                observadorPrincipal: true,
                estadoActual: true
            }
        });

        if (mareasActivas.length === 0) {
            return;
        }

        const ports = await this.prisma.puerto.findMany({
            where: { activo: true, latitud: { not: null }, longitud: { not: null } }
        });
        if (ports.length === 0) {
            return;
        }


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
                await this.handleProcessedEvent(buqueId, 'ZARPADA', lastState.portId!, p.timestamp, mareasActivas, ports);
            } else if (!lastState.inPort && currentState.inPort) {
                await this.handleProcessedEvent(buqueId, 'ARRIBO', currentState.portId!, p.timestamp, mareasActivas, ports);
            }
            lastState = currentState;
        }
    }

    private async handleProcessedEvent(buqueId: string, type: 'ZARPADA' | 'ARRIBO', portId: string, date: Date, mareas: any[], ports: any[]) {
        const port = ports.find(x => x.id === portId);
        const eventDate = DateTime.fromJSDate(date).setZone(this.TIMEZONE);
        const dateKey = eventDate.toFormat('yyyy-MM-dd');


        // 1) Asegurarse de no repetir alertas (usando snapshots)
        const hashContent = `${buqueId}_${type}_${dateKey}_${portId}`;
        const hash = crypto.createHash('md5').update(hashContent).digest('hex');
        const snapshot = await (this.prisma as any).trackingEventSnapshot.findUnique({ where: { hash } });
        if (snapshot) {
            return;
        }

        // 2) Iterar sobre las mareas para encontrar la correcta (SHORT-CIRCUIT)
        for (const marea of mareas) {
            const stageMatch = marea.etapas.find(e => {
                const field = type === 'ZARPADA' ? e.fechaZarpada : e.fechaArribo;
                if (!field) return false;
                const fieldDateKey = DateTime.fromJSDate(field).setZone(this.TIMEZONE).toFormat('yyyy-MM-dd');
                return fieldDateKey === dateKey;
            });

            if (stageMatch) {
                const matchedPortId = type === 'ZARPADA' ? stageMatch.puertoZarpadaId : stageMatch.puertoArriboId;
                if (matchedPortId === portId) {
                    return;
                } else {
                    await this.createDiscrepancyAlert(buqueId, type, port, date, marea, stageMatch, ports, hash);
                    return;
                }
            }
        }

        // 3) Si ninguna marea coincide en fecha, sugerimos un nuevo evento para la marea más relevante
        const mareaTarget = mareas.find(m => m.estadoActual.codigo === 'EN_EJECUCION') || mareas[0];
        const buqueNombre = mareaTarget.buque.nombreBuque;
        const yearSuffix = String(mareaTarget.anioMarea).slice(-2);
        const mareaLabel = mareaTarget.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${mareaTarget.nroMarea}-${yearSuffix}`;
        const dateStr = eventDate.toFormat('dd/MM HH:mm');


        let alertType: string | null = null;
        let alertSubTipo: string | null = null;
        let metadata: any = {
            mareaId: mareaTarget.id,
            mareaCode: mareaLabel,
            vesselName: buqueNombre,
            portId: portId,
            portName: port?.nombre,
            eventDate: date,
            type
        };

        if (type === 'ZARPADA') {
            alertType = 'POSIBLE_ZARPADA';
            alertSubTipo = 'NUEVA_ETAPA';
            metadata.subTipo = alertSubTipo;
            metadata.externalData = { fechaZarpada: date, puertoZarpadaId: portId };
        } else {
            // ARRIBO: Buscar etapa abierta
            const lastStageOpen = [...mareaTarget.etapas].sort((a, b) => b.nroEtapa - a.nroEtapa).find(e => !e.fechaArribo);

            // VALIDACIÓN: El arribo detectado debe ser posterior a la zarpada registrada
            if (lastStageOpen && new Date(date) > new Date(lastStageOpen.fechaZarpada)) {
                alertType = 'POSIBLE_ARRIBO';
                alertSubTipo = 'ARRIBO';
                metadata.subTipo = alertSubTipo;
                metadata.nroEtapa = lastStageOpen.nroEtapa;
                metadata.externalData = { fechaArribo: date, puertoArriboId: portId };
            } else if (!lastStageOpen) {
                alertType = 'POSIBLE_ARRIBO';
                alertSubTipo = 'ARRIBO';
                metadata.subTipo = alertSubTipo;
            } else {
                // Silently skip if date not after departure
            }
        }

        if (alertType) {
            const tipoMov = type === 'ZARPADA' ? 'zarpada' : 'arribo';
            const prep = type === 'ZARPADA' ? 'desde' : 'a';
            const alertTitle = `${buqueNombre}: Posible ${tipoMov} ${prep} ${port?.nombre} el ${dateStr} (${mareaLabel})`;
            

            await this.createAlert(buqueId, alertType, alertTitle, date, metadata, mareaTarget.id, 'MAREA', `${alertTitle}\n\nOrigen: Datos de monitoreo satelital.`);
            await this.saveSnapshot(buqueId, type, date, portId, hash);
        }
    }

    private async createDiscrepancyAlert(buqueId: string, type: 'ZARPADA' | 'ARRIBO', port: any, date: Date, marea: any, stageMatch: any, ports: any[], hash: string) {
        const eventDate = DateTime.fromJSDate(date).setZone(this.TIMEZONE);
        const dateStr = eventDate.toFormat('dd/MM HH:mm');
        const buqueNombre = marea.buque.nombreBuque;
        const yearSuffix = String(marea.anioMarea).slice(-2);
        const mareaLabel = marea.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${marea.nroMarea}-${yearSuffix}`;

        const matchedPortId = type === 'ZARPADA' ? stageMatch.puertoZarpadaId : stageMatch.puertoArriboId;
        const puertoLocal = ports.find(p => p.id === matchedPortId)?.nombre || 'N/D';
        const tipoMov = type === 'ZARPADA' ? 'zarpada' : 'arribo';
        const alertTitle = `${buqueNombre}: Discrepancia en puerto de ${tipoMov} el ${dateStr} (${mareaLabel})`;

        const metadata = {
            mareaId: marea.id,
            mareaCode: mareaLabel,
            vesselName: buqueNombre,
            portId: port.id,
            portName: port.nombre,
            eventDate: date,
            type,
            subTipo: 'INCONGRUENCIA',
            nroEtapa: stageMatch.nroEtapa,
            externalData: {
                [type === 'ZARPADA' ? 'fechaZarpada' : 'fechaArribo']: date,
                [type === 'ZARPADA' ? 'puertoZarpadaId' : 'puertoArriboId']: port.id,
                [type === 'ZARPADA' ? 'puertoZarpadaNombre' : 'puertoArriboNombre']: port.nombre
            },
            localData: {
                [type === 'ZARPADA' ? 'fechaZarpada' : 'fechaArribo']: type === 'ZARPADA' ? stageMatch.fechaZarpada : stageMatch.fechaArribo,
                [type === 'ZARPADA' ? 'puertoZarpadaId' : 'puertoArriboId']: matchedPortId,
                [type === 'ZARPADA' ? 'puertoZarpadaNombre' : 'puertoArriboNombre']: puertoLocal
            }
        };

        const descripcion = `${alertTitle}\n\nOrigen: Datos de monitoreo satelital.\nDetalle: Puerto real detectado ${port?.nombre} vs registrado ${puertoLocal}`;

        await this.createAlert(buqueId, 'ERROR_REGISTRO_PUERTO', alertTitle, date, metadata, marea.id, 'MAREA', descripcion);
        await this.saveSnapshot(buqueId, type, date, port.id, hash);
    }

    private async saveSnapshot(buqueId: string, eventType: string, timestamp: Date, puertoId: string, hash: string) {
        await (this.prisma as any).trackingEventSnapshot.create({
            data: { buqueId, eventType, timestamp, puertoId, hash }
        });
    }
    private checkPortStatus(lat: number, lon: number, ports: any[]) {
        for (const port of ports) {
            const dist = getDistance({ latitude: lat, longitude: lon }, { latitude: port.latitud!, longitude: port.longitud! });
            if (dist <= this.PORT_RADIUS_METERS) return { inPort: true, portId: port.id };
        }
        return { inPort: false, portId: null };
    }

    private async analyzeGaps(buqueId: string, sortedPoints: any[], marea: any) {
        const buqueNombre = marea.buque.nombreBuque;
        const mareaLabel = `${marea.nroMarea}/${marea.anioMarea}`;
        const obsLabel = marea.observadorPrincipal
            ? `${marea.observadorPrincipal.apellido}, ${marea.observadorPrincipal.nombre}`
            : 'Sin asignar';

        for (let i = 1; i < sortedPoints.length; i++) {
            const prev = sortedPoints[i - 1];
            const curr = sortedPoints[i];
            const diffMin = (curr.timestamp.getTime() - prev.timestamp.getTime()) / 60000;
            if (diffMin > this.GAP_THRESHOLD_MINUTES) {
                const localTime = DateTime.fromJSDate(prev.timestamp).setZone(this.TIMEZONE);
                const hours = Math.round(diffMin / 60);

                /* 
                await this.createAlert(
                    buqueId,
                    'GAP_DETECTED',
                    `${buqueNombre}: Hueco de datos > ${hours}h (${mareaLabel})`,
                    prev.timestamp,
                    {
                        mareaId: marea.id,
                        mareaCode: mareaLabel,
                        observerName: obsLabel,
                        vesselName: buqueNombre,
                        gapMinutes: diffMin,
                        gapHours: hours
                    },
                    marea.id,
                    'MAREA'
                ); 
                */
            }
        }
    }

    private async createAlert(buqueId: string, type: string, titulo: string, date: Date, meta: any = {}, refId?: string, refTipo?: string, descripcion?: string) {
        const code = `${type}_${buqueId}_${date.getTime()}`;
        const exists = await this.prisma.alerta.findFirst({ where: { codigoUnico: code } });
        if (exists) return;

        await this.prisma.alerta.create({
            data: {
                codigoUnico: code,
                tipo: 'TRACKING_EVENT',
                titulo: titulo,
                descripcion: descripcion || titulo,
                estado: 'PENDIENTE',
                prioridad: 'MEDIA',
                fechaDetectada: date,
                referenciaId: refId,
                referenciaTipo: refTipo,
                metadata: { ...meta, buqueId },
                visible: true
            } as any
        });
    }
}
