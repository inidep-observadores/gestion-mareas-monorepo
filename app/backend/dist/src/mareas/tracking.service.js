"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var TrackingService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.TrackingService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const sync_1 = require("csv-parse/sync");
const geolib_1 = require("geolib");
const luxon_1 = require("luxon");
const marea_utils_1 = require("../common/utils/marea.utils");
const crypto = require("crypto");
let TrackingService = TrackingService_1 = class TrackingService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(TrackingService_1.name);
        this.PORT_RADIUS_METERS = 5000;
        this.GAP_THRESHOLD_MINUTES = 240;
        this.OLD_DATA_THRESHOLD_HOURS = 48;
        this.CHECK_INTERVAL_HOURS = 1;
        this.TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';
    }
    async checkHeartbeat() {
        const KEY = 'TRACKING_CHECK';
        let status = await this.prisma.systemStatus.findUnique({ where: { key: KEY } });
        if (!status) {
            status = await this.prisma.systemStatus.create({
                data: { key: KEY, lastUpdate: new Date(0) }
            });
        }
        const last = luxon_1.DateTime.fromJSDate(status.lastUpdate);
        const now = luxon_1.DateTime.now();
        const diffHours = now.diff(last, 'hours').hours;
        if (diffHours >= this.CHECK_INTERVAL_HOURS) {
            this.runAutomatedChecks().catch(e => this.logger.error('Error en verificación automática', e));
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
        const activeMareas = await this.prisma.marea.findMany({
            where: {
                estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } }
            },
            include: { buque: { include: { puertoBase: true } } }
        });
        for (const marea of activeMareas) {
            const buqueId = marea.buqueId;
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                where: { buqueId },
                orderBy: { timestamp: 'desc' }
            });
            if (lastPoint) {
                const lastTime = luxon_1.DateTime.fromJSDate(lastPoint.timestamp);
                const now = luxon_1.DateTime.now();
                const hoursOld = now.diff(lastTime, 'hours').hours;
                if (hoursOld > this.OLD_DATA_THRESHOLD_HOURS) {
                    await this.createAlert(buqueId, 'DATOS_DESACTUALIZADOS', `Buque ${marea.buque.nombreBuque} sin reporte por ${Math.round(hoursOld)} horas`, lastPoint.timestamp, { mareaId: marea.id });
                }
            }
        }
    }
    async importTrackingData(fileBuffer) {
        const records = (0, sync_1.parse)(fileBuffer, {
            columns: true,
            skip_empty_lines: true,
            delimiter: [';', ','],
            trim: true,
        });
        let newPointsCount = 0;
        let updatedShipsCount = 0;
        let alertsCount = 0;
        const buquesCache = new Map();
        const pointsByShip = {};
        const errors = [];
        const allBuques = await this.prisma.buque.findMany({
            select: { id: true, matricula: true }
        });
        const numericMatriculaMap = new Map();
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
            if (!buqueName)
                continue;
            if (!pointsByShip[buqueName])
                pointsByShip[buqueName] = [];
            pointsByShip[buqueName].push(record);
        }
        for (const [buqueName, points] of Object.entries(pointsByShip)) {
            try {
                let buqueId = buquesCache.get(buqueName);
                if (!buqueId) {
                    const matriculaRaw = points[0]['Matricula'];
                    const matricula = matriculaRaw ? matriculaRaw.trim() : null;
                    let buqueFound = null;
                    if (matricula) {
                        buqueFound = await this.prisma.buque.findUnique({
                            where: { matricula }
                        });
                    }
                    if (!buqueFound) {
                        const nameToSearch = buqueName.trim();
                        buqueFound = await this.prisma.buque.findFirst({
                            where: {
                                nombreBuque: { equals: nameToSearch, mode: 'insensitive' }
                            }
                        });
                        if (buqueFound && matricula && buqueFound.matricula !== matricula) {
                            this.logger.log(`Auto-correcting matricula for ${buqueName}: ${buqueFound.matricula} -> ${matricula}`);
                            buqueFound = await this.prisma.buque.update({
                                where: { id: buqueFound.id },
                                data: { matricula: matricula }
                            });
                            updatedShipsCount++;
                        }
                    }
                    if (!buqueFound && matricula && /^\d+$/.test(matricula)) {
                        const matriculaNum = parseInt(matricula, 10);
                        const idFound = numericMatriculaMap.get(matriculaNum);
                        if (idFound) {
                            buqueFound = await this.prisma.buque.findUnique({ where: { id: idFound } });
                            if (buqueFound) {
                                this.logger.log(`Found buque by numeric matricula: ${buqueName} (${matricula}) -> ${buqueFound.nombreBuque} (${buqueFound.matricula})`);
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
                    }
                    else {
                        this.logger.debug(`Buque no encontrado en DB, ignorando: ${buqueName} (Matrícula: ${matricula || 'N/A'})`);
                        continue;
                    }
                }
                const tray = await this.prisma.buqueTrayectoria.upsert({
                    where: { buqueId },
                    update: {},
                    create: { buqueId }
                });
                const pointsToInsert = points.map(p => {
                    let dateStr = p['Fecha'];
                    const dt = luxon_1.DateTime.fromFormat(dateStr, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
                    const validDt = dt.isValid ? dt : luxon_1.DateTime.fromISO(dateStr, { zone: 'utc' });
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
                    const detectedAlerts = await this.detectPortEvents(buqueId, pointsToInsert);
                    alertsCount += detectedAlerts;
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
            }
            catch (e) {
                this.logger.error(`Error processing ship ${buqueName}:`, e);
                errors.push({ vessel: buqueName, reason: `Error interno: ${e.message}` });
            }
        }
        const result = {
            processed: records.length,
            inserted: newPointsCount,
            updated: updatedShipsCount,
            alerts: alertsCount,
            errors: errors
        };
        try {
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                orderBy: { timestamp: 'desc' },
                select: { timestamp: true }
            });
            if (lastPoint) {
                const dateStr = luxon_1.DateTime.fromJSDate(lastPoint.timestamp).setZone(this.TIMEZONE).toFormat('dd/MM/yyyy HH:mm');
                await this.prisma.systemStatus.upsert({
                    where: { key: 'LAST_TRACKING_UPDATE' },
                    update: { value: dateStr, lastUpdate: new Date() },
                    create: { key: 'LAST_TRACKING_UPDATE', value: dateStr, lastUpdate: new Date() }
                });
            }
        }
        catch (e) {
            this.logger.error('Error al actualizar LAST_TRACKING_UPDATE:', e);
        }
        return result;
    }
    async getMareaTrackingInfo(mareaId) {
        const marea = await this.prisma.marea.findUnique({
            where: { id: mareaId },
            include: {
                buque: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' }
                },
                observadorPrincipal: true,
                estadoActual: true
            }
        });
        if (!marea)
            throw new Error('Marea no encontrada');
        let voyageStart = null;
        if (marea.etapas.length > 0 && marea.etapas[0].fechaZarpada) {
            voyageStart = marea.etapas[0].fechaZarpada;
        }
        else {
            voyageStart = marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
        }
        let voyageEnd = null;
        const lastStage = marea.etapas[marea.etapas.length - 1];
        const isActiveMarea = marea.estadoActual.codigo === 'EN_EJECUCION' || marea.estadoActual.codigo === 'DESIGNADA';
        if (isActiveMarea) {
            voyageEnd = new Date();
        }
        else if (lastStage && lastStage.fechaArribo) {
            voyageEnd = lastStage.fechaArribo;
        }
        else {
            voyageEnd = new Date();
        }
        if (voyageStart) {
            voyageStart = luxon_1.DateTime.fromJSDate(voyageStart, { zone: 'utc' })
                .setZone(this.TIMEZONE)
                .set({ hour: 0, minute: 0, second: 0, millisecond: 0 })
                .toJSDate();
        }
        if (voyageEnd) {
            voyageEnd = luxon_1.DateTime.fromJSDate(voyageEnd, { zone: 'utc' })
                .setZone(this.TIMEZONE)
                .set({ hour: 23, minute: 59, second: 59, millisecond: 999 })
                .toJSDate();
        }
        const lastTrackingStatus = await this.prisma.systemStatus.findUnique({
            where: { key: 'LAST_TRACKING_UPDATE' }
        });
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
            lastTrackingUpdate: lastTrackingStatus?.value || null,
            totalDays: marea_utils_1.MareaUtils.calculateNavigatedDays(marea),
            etapas: marea.etapas.map(e => ({
                ...e,
                durationDays: marea_utils_1.MareaUtils.calculateStageDays(e)
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
                observadorPrincipal: true,
                estadoActual: true
            }
        });
        const fleet = [];
        for (const marea of activeMareas) {
            const lastPoint = await this.prisma.buqueTrayectoriaPunto.findFirst({
                where: { buqueId: marea.buqueId },
                orderBy: { timestamp: 'desc' }
            });
            let voyageStart = null;
            if (marea.etapas.length > 0 && marea.etapas[0].fechaZarpada) {
                voyageStart = marea.etapas[0].fechaZarpada;
            }
            else {
                voyageStart = marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
            }
            let voyageEnd = null;
            const lastStage = marea.etapas[marea.etapas.length - 1];
            const isActiveMarea = marea.estadoActual.codigo === 'EN_EJECUCION' || marea.estadoActual.codigo === 'DESIGNADA';
            if (isActiveMarea) {
                voyageEnd = new Date();
            }
            else if (lastStage && lastStage.fechaArribo) {
                voyageEnd = lastStage.fechaArribo;
            }
            else {
                voyageEnd = new Date();
            }
            if (voyageStart) {
                voyageStart = luxon_1.DateTime.fromJSDate(voyageStart, { zone: 'utc' })
                    .setZone(this.TIMEZONE)
                    .set({ hour: 0, minute: 0, second: 0, millisecond: 0 })
                    .toJSDate();
            }
            if (voyageEnd) {
                voyageEnd = luxon_1.DateTime.fromJSDate(voyageEnd, { zone: 'utc' })
                    .setZone(this.TIMEZONE)
                    .set({ hour: 23, minute: 59, second: 59, millisecond: 999 })
                    .toJSDate();
            }
            let status = 'OK';
            if (lastPoint) {
                const hoursOld = luxon_1.DateTime.now().diff(luxon_1.DateTime.fromJSDate(lastPoint.timestamp), 'hours').hours;
                if (hoursOld > 48)
                    status = 'OLD';
            }
            const totalDays = marea_utils_1.MareaUtils.calculateNavigatedDays(marea);
            fleet.push({
                id: marea.buque.id,
                name: marea.buque.nombreBuque,
                matricula: marea.buque.matricula,
                type: marea.artePrincipal?.nombre || 'Pesquero',
                status,
                lat: lastPoint?.lat || null,
                lon: lastPoint?.lon || null,
                course: lastPoint?.rumbo || 0,
                speed: lastPoint?.velocidad || 0,
                lastUpdate: lastPoint?.timestamp || null,
                mareaId: marea.id,
                mareaStatus: marea.estadoActual?.codigo || 'EN_EJECUCION',
                mareaCode: `${marea.tipoMarea}-${marea.nroMarea}-${marea.anioMarea.toString().slice(-2)}`,
                observer: marea.observadorPrincipal
                    ? `${marea.observadorPrincipal.apellido} ${marea.observadorPrincipal.nombre}`
                    : 'Sin asignar',
                voyageStart,
                voyageEnd,
                totalDays,
                etapas: marea.etapas.map(e => ({
                    ...e,
                    durationDays: marea_utils_1.MareaUtils.calculateStageDays(e)
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
    async getVesselHistory(buqueId, from, to, limit = 30000) {
        const where = { buqueId };
        if (from || to) {
            where.timestamp = {};
            if (from)
                where.timestamp.gte = new Date(from);
            if (to)
                where.timestamp.lte = new Date(to);
        }
        const points = await this.prisma.buqueTrayectoriaPunto.findMany({
            where,
            orderBy: { timestamp: 'desc' },
            take: limit
        });
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
    async detectPortEvents(buqueId, points) {
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
            return 0;
        }
        const ports = await this.prisma.puerto.findMany({
            where: { activo: true, latitud: { not: null }, longitud: { not: null } }
        });
        if (ports.length === 0) {
            return 0;
        }
        let alertsCreated = 0;
        points.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime());
        let lastState = { inPort: false, portId: null };
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
                const created = await this.handleProcessedEvent(buqueId, 'ZARPADA', lastState.portId, p.timestamp, mareasActivas, ports);
                if (created)
                    alertsCreated++;
            }
            else if (!lastState.inPort && currentState.inPort) {
                const created = await this.handleProcessedEvent(buqueId, 'ARRIBO', currentState.portId, p.timestamp, mareasActivas, ports);
                if (created)
                    alertsCreated++;
            }
            lastState = currentState;
        }
        return alertsCreated;
    }
    async handleProcessedEvent(buqueId, type, portId, date, mareas, ports) {
        const port = ports.find(x => x.id === portId);
        const eventDate = luxon_1.DateTime.fromJSDate(date).setZone(this.TIMEZONE);
        const dateKey = eventDate.toFormat('yyyy-MM-dd');
        const hashContent = `${buqueId}_${type}_${dateKey}_${portId}`;
        const hash = crypto.createHash('md5').update(hashContent).digest('hex');
        const snapshot = await this.prisma.trackingEventSnapshot.findUnique({ where: { hash } });
        if (snapshot) {
            return false;
        }
        for (const marea of mareas) {
            const stageMatch = marea.etapas.find(e => {
                const field = type === 'ZARPADA' ? e.fechaZarpada : e.fechaArribo;
                if (!field)
                    return false;
                const fieldDateKey = luxon_1.DateTime.fromJSDate(field).setZone(this.TIMEZONE).toFormat('yyyy-MM-dd');
                return fieldDateKey === dateKey;
            });
            if (stageMatch) {
                const matchedPortId = type === 'ZARPADA' ? stageMatch.puertoZarpadaId : stageMatch.puertoArriboId;
                if (matchedPortId === portId) {
                    return false;
                }
                else {
                    return await this.createDiscrepancyAlert(buqueId, type, port, date, marea, stageMatch, ports, hash);
                }
            }
        }
        const mareaTarget = mareas.find(m => m.estadoActual.codigo === 'EN_EJECUCION') || mareas[0];
        const buqueNombre = mareaTarget.buque.nombreBuque;
        const yearSuffix = String(mareaTarget.anioMarea).slice(-2);
        const mareaLabel = mareaTarget.tipoMarea === 'CI' ? `CI-${yearSuffix}` : `MC-${mareaTarget.nroMarea}-${yearSuffix}`;
        const dateStr = eventDate.toFormat('dd/MM HH:mm');
        let alertType = null;
        let alertSubTipo = null;
        let metadata = {
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
        }
        else {
            if (mareaTarget.estadoActual.codigo === 'DESIGNADA') {
                return false;
            }
            const lastStageOpen = [...mareaTarget.etapas].sort((a, b) => b.nroEtapa - a.nroEtapa).find(e => !e.fechaArribo);
            if (lastStageOpen && new Date(date) > new Date(lastStageOpen.fechaZarpada)) {
                alertType = 'POSIBLE_ARRIBO';
                alertSubTipo = 'ARRIBO';
                metadata.subTipo = alertSubTipo;
                metadata.nroEtapa = lastStageOpen.nroEtapa;
                metadata.externalData = { fechaArribo: date, puertoArriboId: portId };
            }
            else if (!lastStageOpen) {
                alertType = 'POSIBLE_ARRIBO';
                alertSubTipo = 'ARRIBO';
                metadata.subTipo = alertSubTipo;
            }
            else {
            }
        }
        if (alertType) {
            const tipoMov = type === 'ZARPADA' ? 'zarpada' : 'arribo';
            const prep = type === 'ZARPADA' ? 'desde' : 'a';
            const alertTitle = `${buqueNombre}: Posible ${tipoMov} ${prep} ${port?.nombre} el ${dateStr} (${mareaLabel})`;
            const created = await this.createAlert(buqueId, alertType, alertTitle, date, metadata, mareaTarget.id, 'MAREA', `${alertTitle}\n\nOrigen: Datos de monitoreo satelital.`);
            if (created) {
                await this.saveSnapshot(buqueId, type, date, portId, hash);
                return true;
            }
        }
        return false;
    }
    async createDiscrepancyAlert(buqueId, type, port, date, marea, stageMatch, ports, hash) {
        const eventDate = luxon_1.DateTime.fromJSDate(date).setZone(this.TIMEZONE);
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
        const created = await this.createAlert(buqueId, 'ERROR_REGISTRO_PUERTO', alertTitle, date, metadata, marea.id, 'MAREA', descripcion);
        if (created) {
            await this.saveSnapshot(buqueId, type, date, port.id, hash);
            return true;
        }
        return false;
    }
    async saveSnapshot(buqueId, eventType, timestamp, puertoId, hash) {
        await this.prisma.trackingEventSnapshot.create({
            data: { buqueId, eventType, timestamp, puertoId, hash }
        });
    }
    checkPortStatus(lat, lon, ports) {
        for (const port of ports) {
            const dist = (0, geolib_1.getDistance)({ latitude: lat, longitude: lon }, { latitude: port.latitud, longitude: port.longitud });
            if (dist <= this.PORT_RADIUS_METERS)
                return { inPort: true, portId: port.id };
        }
        return { inPort: false, portId: null };
    }
    async analyzeGaps(buqueId, sortedPoints, marea) {
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
                const localTime = luxon_1.DateTime.fromJSDate(prev.timestamp).setZone(this.TIMEZONE);
                const hours = Math.round(diffMin / 60);
            }
        }
    }
    async createAlert(buqueId, type, titulo, date, meta = {}, refId, refTipo, descripcion) {
        const code = `${type}_${buqueId}_${date.getTime()}`;
        const exists = await this.prisma.alerta.findFirst({ where: { codigoUnico: code } });
        if (exists)
            return false;
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
            }
        });
        return true;
    }
};
exports.TrackingService = TrackingService;
exports.TrackingService = TrackingService = TrackingService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], TrackingService);
//# sourceMappingURL=tracking.service.js.map