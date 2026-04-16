
import { Injectable, Logger } from '@nestjs/common';
import { AlertsService } from '../alerts/alerts.service';
import { AlertMetadata } from '../alerts/interfaces/alert-metadata.interface';
import { PrismaService } from '../prisma/prisma.service';
import { parse } from 'csv-parse/sync';
import { getDistance } from 'geolib';
import { DateTime } from 'luxon';
import { MareaUtils } from '../common/utils/marea.utils';
import { DateUtils } from '../common/utils/date.utils';
import { VesselSyncService } from '../catalogos/buques/vessel-sync.service';
import { EventCorrelationService, EventDecisionAction } from '../common/services/event-correlation.service';
import * as crypto from 'crypto';
import { DbfWriter, DbfFieldType } from '../common/utils/dbf-writer';

interface TrackingPoint {
    lat: number;
    lon: number;
    date: Date; // JS Date (UTC)
    speed: number;
    course: number;
}

/**
 * Contrato normalizado para la ingestión de datos de tracking.
 * Permite que el motor sea agnóstico a la fuente (CSV, API, etc.).
 */
export interface VesselTrackingBatch {
    vesselInfo: {
        nombre: string;
        matricula?: string;
        matriculaSiop?: string;
        mmsi?: string;
    };
    onlyIngest?: boolean;
    points: {
        timestamp: Date;
        lat: number;
        lon: number;
        velocidad?: number;
        rumbo?: number;
    }[];
}

@Injectable()
export class TrackingService {
    private readonly logger = new Logger(TrackingService.name);
    private readonly PORT_RADIUS_METERS = 5000;
    private readonly GAP_THRESHOLD_MINUTES = 240; // 4h
    private readonly OLD_DATA_THRESHOLD_HOURS = 48;
    private readonly CHECK_INTERVAL_HOURS = 1;
    private readonly MAX_SPEED_KNOTS = 15;
    private readonly TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';

    constructor(
        private prisma: PrismaService,
        private vesselSyncService: VesselSyncService,
        private alertsService: AlertsService,
        private correlationService: EventCorrelationService,
    ) { }

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
                data: { lastUpdate: DateUtils.getNow(true) }
            });
            return { status: 'Iniciado', timestamp: DateUtils.getNow(true) };
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

        // 1. Agrupar puntos por buque (Adaptador específico de CSV)
        const pointsByShip: Record<string, any[]> = {};
        for (const record of records) {
            const buqueName = record['Buque']?.toUpperCase();
            if (!buqueName) continue;
            if (!pointsByShip[buqueName]) pointsByShip[buqueName] = [];
            pointsByShip[buqueName].push(record);
        }

        let totalProcessed = 0;
        let totalInserted = 0;
        let totalUpdatedShips = 0;
        let totalAlerts = 0;
        const allErrors: { vessel: string, reason: string }[] = [];

        // 2. Convertir a formato normalizado y procesar
        for (const [buqueName, points] of Object.entries(pointsByShip)) {
            const batch: VesselTrackingBatch = {
                vesselInfo: {
                    nombre: buqueName,
                    matricula: points[0]['Matricula']?.trim() || undefined,
                    matriculaSiop: points[0]['Matricula']?.trim() || undefined,
                    mmsi: points[0]['MMSI']?.trim() || undefined
                },
                points: points.map(p => {
                    let dateStr = p['Fecha'];
                    const dt = DateTime.fromFormat(dateStr, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
                    const validDt = dt.isValid ? dt : DateTime.fromISO(dateStr, { zone: 'utc' });

                    const lat = parseFloat(p['Latitud']?.replace(',', '.'));
                    const lon = parseFloat(p['Longitud']?.replace(',', '.'));
                    const speed = parseFloat(p['Velocidad']?.replace(',', '.'));
                    const course = parseInt(p['Rumbo']);

                    return {
                        timestamp: validDt.toJSDate(),
                        lat,
                        lon,
                        velocidad: isNaN(speed) ? undefined : speed,
                        rumbo: isNaN(course) ? undefined : course,
                    };
                }).filter(p => !isNaN(p.timestamp.getTime()) && !isNaN(p.lat) && !isNaN(p.lon))
            };

            const result = await this.processVesselBatch(batch);

            totalProcessed += points.length;
            totalInserted += result.inserted;
            totalUpdatedShips += result.updated ? 1 : 0;
            totalAlerts += result.alerts;
            if (result.error) {
                allErrors.push({ vessel: buqueName, reason: result.error });
            }
        }

        const result = {
            processed: totalProcessed,
            inserted: totalInserted,
            updated: totalUpdatedShips,
            alerts: totalAlerts,
            errors: allErrors
        };

        // Al finalizar, actualizar el estado global (Mantiene lógica original)
        await this.updateLastTrackingStatus();

        return result;
    }

    /**
     * Motor Core: Procesa un lote de puntos de un buque de forma agnóstica a la fuente.
     */
    async processVesselBatch(batch: VesselTrackingBatch) {
        let inserted = 0;
        let updated = false;
        let alerts = 0;
        let error: string | undefined;

        try {
            const { vesselInfo, points } = batch;
            if (points.length === 0) return { inserted, updated, alerts };

            // 1. Resolución de Buque
            const buqueId = await this.resolveBuqueId(vesselInfo);
            if (!buqueId) {
                return { inserted, updated, alerts };
            }

            // Sincronizar datos oficiales si es necesario
            await this.vesselSyncService.syncVesselIfNeeded({
                nombre: vesselInfo.nombre,
                mmsi: vesselInfo.mmsi
            });

            // 2. Asegurar Trayectoria y Persistir Puntos
            const tray = await this.prisma.buqueTrayectoria.upsert({
                where: { buqueId },
                update: {},
                create: { buqueId }
            });

            const pointsToInsert = points.map(p => ({
                trayectoriaId: tray.id,
                buqueId: buqueId,
                timestamp: p.timestamp,
                lat: p.lat,
                lon: p.lon,
                velocidad: p.velocidad ?? null,
                rumbo: p.rumbo ?? null,
            }));

            const dbResult = await this.prisma.buqueTrayectoriaPunto.createMany({
                data: pointsToInsert,
                skipDuplicates: true,
            });
            inserted = dbResult.count;

            if (inserted > 0 && !batch.onlyIngest) {
                // 3. Análisis de Eventos (Zarpadas/Arribos)
                alerts = await this.detectPortEvents(buqueId, pointsToInsert);

                // 4. Análisis de GAPs (si tiene marea activa)
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
            this.logger.error(`Error en processVesselBatch para ${batch.vesselInfo.nombre}:`, e);
            error = e.message;
        }

        return { inserted, updated, alerts, error };
    }

    private async resolveBuqueId(info: VesselTrackingBatch['vesselInfo']): Promise<string | null> {
        let buqueFound = null;

        const isNumeric = (val?: string) => val && /^\d+$/.test(val.trim());
        const normalizeNum = (val: string) => val.trim().replace(/^0+/, '');

        // Prioridad 1: Matrícula SIOP
        if (!buqueFound && info.matriculaSiop) {
            buqueFound = await this.prisma.buque.findUnique({
                where: { matriculaSiop: info.matriculaSiop }
            });
        }

        // Prioridad 2: Nombre (Insensitive)
        if (!buqueFound) {
            buqueFound = await this.prisma.buque.findFirst({
                where: { nombreBuque: { equals: info.nombre.trim(), mode: 'insensitive' } }
            });
        }

        // Prioridad 3: Matrícula Nacional (Con fallback numérico)
        if (!buqueFound && info.matricula) {
            // Intento búsqueda exacta primero
            buqueFound = await this.prisma.buque.findUnique({
                where: { matricula: info.matricula }
            });

            // Si no se encuentra y es numérica, intentamos normalizada
            if (!buqueFound && isNumeric(info.matricula)) {
                const normInput = normalizeNum(info.matricula);
                buqueFound = await this.prisma.buque.findFirst({
                    where: {
                        OR: [
                            { matricula: normInput },
                            { matricula: { endsWith: normInput } }
                        ]
                    }
                });

                if (buqueFound && !isNumeric(buqueFound.matricula)) {
                    buqueFound = null;
                }
            }
        }

        // Prioridad 4: MMSI (Internacional, más exacto)
        if (!buqueFound && info.mmsi) {
            buqueFound = await this.prisma.buque.findFirst({
                where: { mmsi: info.mmsi }
            });
        }

        // Auto-corrección de datos si se encontró el buque
        if (buqueFound) {
            const dataToUpdate: any = {};
            if (info.mmsi && buqueFound.mmsi !== info.mmsi) {
                dataToUpdate.mmsi = info.mmsi;
            }
            if (info.matriculaSiop && buqueFound.matriculaSiop !== info.matriculaSiop) {
                dataToUpdate.matriculaSiop = info.matriculaSiop;
            }

            if (Object.keys(dataToUpdate).length > 0) {
                buqueFound = await this.prisma.buque.update({
                    where: { id: buqueFound.id },
                    data: dataToUpdate
                });
            }
        }

        return buqueFound?.id || null;
    }

    async updateLastTrackingStatus() {
        try {
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                orderBy: { timestamp: 'desc' },
                select: { timestamp: true }
            });

            if (lastPoint) {
                const dateStr = DateTime.fromJSDate(lastPoint.timestamp)
                    .setZone(this.TIMEZONE)
                    .toFormat('dd/MM/yyyy HH:mm');
                await this.prisma.systemStatus.upsert({
                    where: { key: 'LAST_TRACKING_UPDATE' },
                    update: { value: dateStr, lastUpdate: new Date() },
                    create: { key: 'LAST_TRACKING_UPDATE', value: dateStr, lastUpdate: new Date() }
                });
            }
        } catch (e) {
            this.logger.error('Error al actualizar LAST_TRACKING_UPDATE:', e);
        }
    }

    // --- Visuals & Data Retrieval ---

    async getMareaTrackingInfo(mareaId: string) {
        const marea = await this.prisma.marea.findUnique({
            where: { id: mareaId },
            include: {
                buque: {
                    include: {
                        tipoFlota: true
                    }
                },
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true
                    }
                },
                observadorPrincipal: true,
                estadoActual: true,
                pesqueria: true
            }
        });

        if (!marea) throw new Error('Marea no encontrada');

        // Logic: prioritize first stage departure for voyage start
        let voyageStart: Date | null = null;
        if (marea.etapas.length > 0 && marea.etapas[0].fechaZarpada) {
            voyageStart = marea.etapas[0].fechaZarpada;
        } else {
            voyageStart = marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
        }

        let voyageEnd: Date | null = null;
        const lastStage = marea.etapas[marea.etapas.length - 1];
        const isActiveMarea = marea.estadoActual.codigo === 'EN_EJECUCION' || marea.estadoActual.codigo === 'DESIGNADA';

        if (isActiveMarea) {
            voyageEnd = new Date(); // Always show all points up to now for active mareas
        } else if (lastStage && lastStage.fechaArribo) {
            voyageEnd = lastStage.fechaArribo;
        } else {
            voyageEnd = new Date();
        }

        // Adjust hours strictly: 00:00 for start, 23:59:59 for end
        // Consider that voyageStart/End (from DB) are treated as being in the local timezone
        if (voyageStart) {
            voyageStart = DateTime.fromJSDate(voyageStart, { zone: 'utc' })
                .setZone(this.TIMEZONE)
                .set({ hour: 0, minute: 0, second: 0, millisecond: 0 })
                .toJSDate();
        }
        if (voyageEnd) {
            voyageEnd = DateTime.fromJSDate(voyageEnd, { zone: 'utc' })
                .setZone(this.TIMEZONE)
                .set({ hour: 23, minute: 59, second: 59, millisecond: 999 })
                .toJSDate();
        }

        const lastTrackingStatus = await this.prisma.systemStatus.findUnique({
            where: { key: 'LAST_TRACKING_UPDATE' }
        });

        const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
            where: { buqueId: marea.buqueId },
            orderBy: { timestamp: 'desc' }
        });

        return {
            id: marea.id,
            buqueId: marea.buqueId,
            name: marea.buque.nombreBuque,
            matricula: marea.buque.matricula,
            mareaCode: `${marea.nroMarea}/${marea.anioMarea}`,
            pesquerias_nombres: marea.etapas.length > 0
                ? marea.etapas.map(e => e.pesqueria?.nombre).filter(n => !!n)
                : (marea.pesqueria?.nombre ? [marea.pesqueria.nombre] : []),
            flota: marea.buque.tipoFlota?.nombre || 'Indeterminada',
            observer: marea.observadorPrincipal?.apellido ? `${marea.observadorPrincipal.apellido}, ${marea.observadorPrincipal.nombre}` : 'Sin asignar',
            voyageStart: voyageStart?.toISOString(),
            voyageEnd: voyageEnd?.toISOString(),
            lastUpdate: marea.fechaUltimaActualizacion,
            lastTrackingUpdate: lastTrackingStatus?.value || null,
            lat: lastPoint?.lat || null,
            lon: lastPoint?.lon || null,
            speed: lastPoint?.velocidad || 0,
            course: lastPoint?.rumbo || 0,
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
                buque: {
                    include: {
                        tipoFlota: true
                    }
                },
                artePrincipal: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true
                    }
                },
                observadorPrincipal: true,
                estadoActual: true,
                pesqueria: true
            }
        });

        const fleet = [];

        for (const marea of activeMareas) {
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                where: { buqueId: marea.buqueId },
                orderBy: { timestamp: 'desc' }
            });

            // Calculate Voyage Bounds
            // Start: prioritize first stage departure
            let voyageStart: Date | null = null;
            if (marea.etapas.length > 0 && marea.etapas[0].fechaZarpada) {
                voyageStart = marea.etapas[0].fechaZarpada;
            } else {
                voyageStart = marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
            }

            // End: Last stage arrival or Now (for active mareas, always use Now)
            let voyageEnd: Date | null = null;
            const lastStage = marea.etapas[marea.etapas.length - 1];
            const isActiveMarea = marea.estadoActual.codigo === 'EN_EJECUCION' || marea.estadoActual.codigo === 'DESIGNADA';

            if (isActiveMarea) {
                voyageEnd = new Date(); // Always show all points up to now for active mareas
            } else if (lastStage && lastStage.fechaArribo) {
                voyageEnd = lastStage.fechaArribo;
            } else {
                voyageEnd = new Date();
            }

            // Adjust hours as requested: 00:00 for start, 23:59:59 for end
            // Dates from Prisma are in UTC, we shift to local to set boundaries, then back to UTC (implicit in Date object)
            if (voyageStart) {
                voyageStart = DateTime.fromJSDate(voyageStart, { zone: 'utc' })
                    .setZone(this.TIMEZONE)
                    .set({ hour: 0, minute: 0, second: 0, millisecond: 0 })
                    .toJSDate();
            }
            if (voyageEnd) {
                voyageEnd = DateTime.fromJSDate(voyageEnd, { zone: 'utc' })
                    .setZone(this.TIMEZONE)
                    .set({ hour: 23, minute: 59, second: 59, millisecond: 999 })
                    .toJSDate();
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
                mareaStatus: marea.estadoActual?.codigo || 'EN_EJECUCION',
                mareaCode: `${marea.tipoMarea}-${marea.nroMarea}-${marea.anioMarea.toString().slice(-2)}`,
                pesquerias_nombres: marea.etapas.length > 0
                    ? marea.etapas.map(e => e.pesqueria?.nombre).filter(n => !!n)
                    : (marea.pesqueria?.nombre ? [marea.pesqueria.nombre] : []),
                flota: marea.buque.tipoFlota?.nombre || 'Indeterminada',
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

        const lastTrackingStatus = await this.prisma.systemStatus.findUnique({
            where: { key: 'LAST_TRACKING_UPDATE' }
        });

        return {
            fleet,
            lastUpdate: lastTrackingStatus?.value || null
        };
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

    async exportMareaTrackToDbase(mareaId: string) {
        const info = await this.getMareaTrackingInfo(mareaId);
        
        // Re-obtener marea completa para lógica de estados y fechas crudas
        const marea = await this.prisma.marea.findUnique({
            where: { id: mareaId },
            include: { estadoActual: true }
        });

        if (!marea) throw new Error('Marea no encontrada');

        // REPLICAR LOGICA DE VENTANAS DE TIEMPO DEL FRONTEND
        let from = info.voyageStart;
        let to = info.voyageEnd;

        // Comprobación de estado para ventana de 12h
        const isDesignada = info.mareaCode && info.mareaCode.includes('/') && await this.isMareaDesignada(mareaId);

        if (isDesignada) {
            const now = new Date();
            to = now.toISOString();
            from = new Date(now.getTime() - 12 * 60 * 60 * 1000).toISOString();
        } else {
            if (from) from = new Date(new Date(from).getTime() - 6 * 60 * 60 * 1000).toISOString();
            if (to) to = new Date(new Date(to).getTime() + 6 * 60 * 60 * 1000).toISOString();
        }

        const history = await this.getVesselHistory(info.buqueId, from, to);

        const dbf = new DbfWriter();
        dbf.addField({ name: 'Buque', type: DbfFieldType.Character, length: 50 });
        dbf.addField({ name: 'Matricula', type: DbfFieldType.Character, length: 20 });
        dbf.addField({ name: 'Fecha', type: DbfFieldType.Character, length: 19 });
        dbf.addField({ name: 'Latitud', type: DbfFieldType.Numeric, length: 18, decimal: 10 });
        dbf.addField({ name: 'Longitud', type: DbfFieldType.Numeric, length: 18, decimal: 10 });
        dbf.addField({ name: 'Velocidad', type: DbfFieldType.Numeric, length: 10, decimal: 2 });
        dbf.addField({ name: 'Rumbo', type: DbfFieldType.Numeric, length: 5, decimal: 0 });

        for (const point of history) {
            dbf.addRecord({
                'Buque': info.name,
                'Matricula': info.matricula,
                'Fecha': DateTime.fromJSDate(point.timestamp).toFormat('yyyy-MM-dd HH:mm:ss'),
                'Latitud': point.lat,
                'Longitud': point.lon,
                'Velocidad': point.speed,
                'Rumbo': point.course
            });
        }

        const buffer = dbf.build();

        const nro = info.mareaCode?.split('/')[0] || '0';
        const anioFull = info.mareaCode?.split('/')[1] || '00';
        const anio2 = anioFull.slice(-2);
        const filename = `T${nro}${anio2}.dbf`;

        return {
            buffer,
            filename
        };
    }

    private async isMareaDesignada(mareaId: string): Promise<boolean> {
        const marea = await this.prisma.marea.findUnique({
            where: { id: mareaId },
            include: { estadoActual: true }
        });
        return marea?.estadoActual?.codigo === 'DESIGNADA';
    }

    // --- Internal Logic ---

    private async detectPortEvents(buqueId: string, points: any[]) {
        // Encontrar rango de fechas de los puntos con un margen
        points.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime());
        const minDate = points[0].timestamp;
        const maxDate = points[points.length - 1].timestamp;
        const fromDate = DateTime.fromJSDate(minDate).minus({ days: 10 }).toJSDate();
        const toDate = DateTime.fromJSDate(maxDate).plus({ days: 10 }).toJSDate();

        // 1. Obtener marea en ejecución y designada (prioritarias) + mareas que se solapen temporalmente
        const mareas = await this.prisma.marea.findMany({
            where: {
                buqueId,
                OR: [
                    { estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } } },
                    {
                        etapas: {
                            some: {
                                OR: [
                                    { fechaZarpada: { gte: fromDate, lte: toDate } },
                                    { fechaArribo: { gte: fromDate, lte: toDate } }
                                ]
                            }
                        }
                    }
                ]
            },
            include: {
                etapas: true,
                buque: true,
                observadorPrincipal: true,
                estadoActual: true
            }
        });

        if (!mareas || mareas.length === 0) {
            return 0;
        }

        const ports = await this.prisma.puerto.findMany({
            where: { activo: true, latitud: { not: null }, longitud: { not: null } }
        });
        if (ports.length === 0) {
            return 0;
        }

        let alertsCreated = 0;

        // Get state before this batch
        let lastState = { inPort: false, portId: null as string | null, timestamp: null as Date | null, lat: null as number | null, lon: null as number | null };
        const prev = await this.prisma.buqueTrayectoriaPunto.findFirst({
            where: { buqueId, timestamp: { lt: points[0].timestamp } },
            orderBy: { timestamp: 'desc' }
        });
        if (prev) {
            const status = this.checkPortStatus(prev.lat, prev.lon, ports);
            lastState = { ...status, timestamp: prev.timestamp, lat: prev.lat, lon: prev.lon };
        } else if (points.length > 0) {
            // Si no hay previo, inicializamos con el primer punto para tener una referencia de puerto/posición
            const status = this.checkPortStatus(points[0].lat, points[0].lon, ports);
            lastState = { ...status, timestamp: points[0].timestamp, lat: points[0].lat, lon: points[0].lon };
        }

        for (const p of points) {
            const currentState = this.checkPortStatus(p.lat, p.lon, ports);

            if (lastState.inPort && !currentState.inPort) {
                // ZARPADA detectada al salir del puerto donde estábamos
                // VALIDACIÓN: Evitar saltos GPS ilógicos
                if (this.isValidMovement(lastState, { lat: p.lat, lon: p.lon, timestamp: p.timestamp })) {
                    const eventDate = lastState.timestamp || p.timestamp;
                    const created = await this.handleProcessedEvent(buqueId, 'ZARPADA', lastState.portId!, eventDate, mareas, ports);
                    if (created) alertsCreated++;
                } else {
                    this.logger.warn(`Zarpada ignorada para buque ${buqueId}: Salto GPS detectado (velocidad ilógica).`);
                }
            } else if (!lastState.inPort && currentState.inPort) {
                // ARRIBO detectado al entrar a un puerto
                // VALIDACIÓN: Evitar saltos GPS ilógicos
                if (this.isValidMovement(lastState, { lat: p.lat, lon: p.lon, timestamp: p.timestamp })) {
                    const created = await this.handleProcessedEvent(buqueId, 'ARRIBO', currentState.portId!, p.timestamp, mareas, ports);
                    if (created) alertsCreated++;
                } else {
                    this.logger.warn(`Arribo ignorado para buque ${buqueId}: Salto GPS detectado (velocidad ilógica).`);
                }
            }
            lastState = { ...currentState, timestamp: p.timestamp, lat: p.lat, lon: p.lon };
        }

        return alertsCreated;
    }

    /**
     * Valida si el movimiento entre dos puntos es físicamente posible para un buque.
     * Calcula la velocidad en nudos y la compara con un máximo razonable.
     */
    private isValidMovement(p1: { lat: number | null, lon: number | null, timestamp: Date | null }, p2: { lat: number, lon: number, timestamp: Date }): boolean {
        if (!p1.lat || !p1.lon || !p1.timestamp) return true; // No hay punto anterior para comparar

        const distanceMeters = getDistance(
            { latitude: p1.lat, longitude: p1.lon },
            { latitude: p2.lat, longitude: p2.lon }
        );

        const timeSeconds = Math.abs(p2.timestamp.getTime() - p1.timestamp.getTime()) / 1000;
        if (timeSeconds === 0) return true;

        const speedMps = distanceMeters / timeSeconds;
        const speedKnots = speedMps * 1.94384; // m/s to knots

        if (speedKnots > this.MAX_SPEED_KNOTS) {
            this.logger.debug(`Movimiento detectado a ${speedKnots.toFixed(2)} nudos - Excede el límite de ${this.MAX_SPEED_KNOTS}`);
            return false;
        }

        return true;
    }

    private async handleProcessedEvent(buqueId: string, type: 'ZARPADA' | 'ARRIBO', portId: string, date: Date, mareas: any[], ports: any[]) {
        const port = ports.find(x => x.id === portId);
        const eventDate = DateTime.fromJSDate(date).setZone(this.TIMEZONE);

        // 1) Asegurarse de no repetir detecciones idénticas (Snapshot técnico)
        const hashContent = `${buqueId}_${type}_${date.getTime()}_${portId}`;
        const hash = crypto.createHash('md5').update(hashContent).digest('hex');
        const snapshot = await (this.prisma as any).trackingEventSnapshot.findUnique({ where: { hash } });
        if (snapshot) {
            return false;
        }

        // 2) Evaluar contexto del evento usando el servicio centralizado
        const decision = await this.correlationService.evaluateEventContext(buqueId, type, date, portId, port?.nombre, ports);

        switch (decision.action) {
            case EventDecisionAction.VALIDATE_ALERT:
                this.logger.log(`Reforzando alerta existente ${decision.existingAlert.id} con detección de Tracking CSV`);
                await this.alertsService.addValidationSource(
                    decision.existingAlert.id,
                    'TRACKING_CSV',
                    {
                        fecha: eventDate.toISO(),
                        puerto: port?.nombre,
                        source: 'TRACKING_CSV'
                    }
                );
                await this.saveSnapshot(buqueId, type, date, portId, hash);
                return true;

            case EventDecisionAction.DISCREPANCY_PORT:
                return await this.createDiscrepancyAlert(buqueId, type, port, date, decision.marea, decision.stageMatch, ports, hash);

            case EventDecisionAction.DISCREPANCY_DATE:
                return await this.createDateInconsistencyAlert(buqueId, type, port, date, decision.marea, decision.stageMatch, hash);

            case EventDecisionAction.RECOMMEND_FIN_MAREA:
                return await this.createRecommendationFinMarea(buqueId, port, date, decision.marea, decision.mareaSiguiente, hash);

            case EventDecisionAction.CREATE_ALERT:
                return await this.createPossibleMovementAlert(buqueId, type, port, date, decision.marea, hash, decision.nroEtapa);

            case EventDecisionAction.IGNORE_OLD:
                this.logger.debug(`Ignorando evento antiguo/fuera de secuencia para buque ${buqueId}`);
                return false;

            case EventDecisionAction.NO_MATCH:
            default:
                return false;
        }

        return false;
    }

    private async createPossibleMovementAlert(buqueId: string, type: 'ZARPADA' | 'ARRIBO', port: any, date: Date, marea: any, hash: string, nroEtapa?: number) {
        const buqueNombre = marea.buque.nombreBuque;
        const yearSuffix = String(marea.anioMarea).slice(-2);
        const mareaLabel = marea.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${marea.nroMarea}-${yearSuffix}`;
        const dateStr = DateTime.fromJSDate(date).setZone(this.TIMEZONE).toFormat('dd/MM HH:mm');

        const alertType = type === 'ZARPADA' ? 'POSIBLE_ZARPADA' : 'POSIBLE_ARRIBO';
        const prep = type === 'ZARPADA' ? 'desde' : 'a';
        const alertTitle = `${buqueNombre}: Posible ${type.toLowerCase()} ${prep} ${port?.nombre} el ${dateStr} (${mareaLabel})`;

        const metadata: AlertMetadata = {
            mareaId: marea.id,
            mareaCode: mareaLabel,
            vesselName: buqueNombre,
            observerName: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin Observador',
            buqueId,
            portId: port.id,
            portName: port?.nombre,
            eventDate: date,
            type,
            subTipo: type,
            nroEtapa,
            source: 'TRACKING_CSV',
            externalData: {
                [type === 'ZARPADA' ? 'fechaZarpada' : 'fechaArribo']: date,
                [type === 'ZARPADA' ? 'puertoZarpadaId' : 'puertoArriboId']: port.id
            },
            // Compatibilidad con Source Stacking
            sources: [{
                name: 'TRACKING_CSV',
                detectedAt: date,
                data: {
                    puerto: port.nombre,
                    velocidad: null // En este punto ya procesamos el punto de puerto
                }
            }]
        };

        const created = await this.createAlert(buqueId, alertType, alertTitle, date, metadata, marea.id, 'MAREA', `${alertTitle}\n\nOrigen: Monitoreo satelital.`);
        if (created) {
            await this.saveSnapshot(buqueId, type, date, port.id, hash);
            return true;
        }
        return false;
    }

    private async createRecommendationFinMarea(buqueId: string, port: any, date: Date, mareaActual: any, mareaSiguiente: any, hash: string) {
        const buqueNombre = mareaActual.buque.nombreBuque;
        const dateStr = DateTime.fromJSDate(date).setZone(this.TIMEZONE).toFormat('dd/MM HH:mm');
        const alertTitle = `${buqueNombre}: Se recomienda FINALIZAR MAREA. Arribo detectado a ${port?.nombre} el ${dateStr}`;

        const yearSuffix = String(mareaActual.anioMarea).slice(-2);
        const mareaLabel = mareaActual.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${mareaActual.nroMarea}-${yearSuffix}`;
        const lastStage = [...mareaActual.etapas].sort((a, b) => b.nroEtapa - a.nroEtapa)[0];

        const metadata = {
            mareaId: mareaActual.id,
            mareaCode: mareaLabel,
            mareaSiguienteId: mareaSiguiente.id,
            vesselName: buqueNombre,
            observerName: mareaActual.observadorPrincipal ? `${mareaActual.observadorPrincipal.nombre} ${mareaActual.observadorPrincipal.apellido}` : 'Sin Observador',
            portId: port.id,
            portName: port.nombre,
            eventDate: date,
            type: 'ARRIBO',
            subTipo: 'FIN_MAREA',
            nroEtapa: lastStage?.nroEtapa,
            source: 'TRACKING_CSV',
            sources: [{
                name: 'TRACKING_CSV',
                detectedAt: date,
                data: {
                    puerto: port.nombre,
                    portId: port.id,
                    velocidad: null
                }
            }]
        };

        const descripcion = `${alertTitle}\n\nHay una marea DESIGNADA esperando (${mareaSiguiente.nroMarea}/${mareaSiguiente.anioMarea}). Se sugiere finalizar la marea actual en lugar de registrar un arribo intermedio.`;

        const created = await this.createAlert(buqueId, 'RECOMENDACION_FIN_MAREA', alertTitle, date, metadata, mareaActual.id, 'MAREA', descripcion);
        if (created) {
            await this.saveSnapshot(buqueId, 'ARRIBO', date, port.id, hash);
            return true;
        }

        return false;
    }

    private async createDateInconsistencyAlert(buqueId: string, type: 'ZARPADA' | 'ARRIBO', port: any, date: Date, marea: any, stageMatch: any, hash: string) {
        const registeredDate = type === 'ZARPADA' ? stageMatch.fechaZarpada : stageMatch.fechaArribo;
        const regStr = DateTime.fromJSDate(registeredDate).setZone(this.TIMEZONE).toFormat('dd/MM HH:mm');
        const detStr = DateTime.fromJSDate(date).setZone(this.TIMEZONE).toFormat('dd/MM HH:mm');

        const buqueNombre = marea.buque.nombreBuque;
        const alertTitle = `${buqueNombre}: Incongruencia de FECHA en ${type.toLowerCase()} (${port.nombre})`;

        const yearSuffix = String(marea.anioMarea).slice(-2);
        const mareaLabel = marea.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${marea.nroMarea}-${yearSuffix}`;

        const metadata = {
            mareaId: marea.id,
            mareaCode: mareaLabel,
            vesselName: buqueNombre,
            observerName: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin Observador',
            portId: port.id,
            portName: port.nombre,
            type,
            subTipo: 'EDITAR_ETAPA', // Sugerir edición
            nroEtapa: stageMatch.nroEtapa,
            source: 'TRACKING_CSV',
            externalData: { date: date },
            localData: { date: registeredDate }
        };

        const descripcion = `${alertTitle}\n\nDetectado: ${detStr}\nRegistrado: ${regStr}\n\nLa proximidad temporal sugiere que se trata del mismo evento. Se recomienda EDITAR LA ETAPA para corregir la fecha oficial.`;

        const created = await this.createAlert(buqueId, 'ERROR_FECHA_MOVIMIENTO', alertTitle, date, metadata, marea.id, 'MAREA', descripcion);
        if (created) {
            await this.saveSnapshot(buqueId, type, date, port.id, hash);
            return true;
        }
        return false;
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
            observerName: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin Observador',
            portId: port.id,
            portName: port.nombre,
            eventDate: date,
            type,
            subTipo: 'EDITAR_ETAPA', // Sugerir edición
            nroEtapa: stageMatch.nroEtapa,
            source: 'TRACKING_CSV',
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

        const descripcion = `${alertTitle}\n\nDetectado puerto ${port?.nombre} vs registrado ${puertoLocal}.\n\nSe sugiere EDITAR LA ETAPA para corregir el puerto oficial basado en el monitoreo satelital.`;

        const created = await this.createAlert(buqueId, 'ERROR_REGISTRO_PUERTO', alertTitle, date, metadata, marea.id, 'MAREA', descripcion);
        if (created) {
            await this.saveSnapshot(buqueId, type, date, port.id, hash);
            return true;
        }
        return false;
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

    private async createAlert(buqueId: string, type: string, titulo: string, date: Date, meta: any = {}, refId?: string, refTipo?: string, descripcion?: string): Promise<boolean> {
        const code = `${type}_${buqueId}_${date.getTime()}`;

        await this.alertsService.create({
            codigoUnico: code,
            tipo: type,
            titulo: titulo,
            descripcion: descripcion || titulo,
            estado: 'PENDIENTE' as any,
            prioridad: 'MEDIA' as any,
            fechaDetectada: date,
            referenciaId: refId,
            referenciaTipo: refTipo,
            metadata: { ...meta, buqueId, source: 'TRACKING_CSV' },
            visible: true
        });
        return true;
    }
}
