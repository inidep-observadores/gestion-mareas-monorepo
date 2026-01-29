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
Object.defineProperty(exports, "__esModule", { value: true });
exports.MareasService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const business_rules_service_1 = require("../common/business-rules/business-rules.service");
const alerts_enums_1 = require("../alerts/alerts.enums");
const mail_service_1 = require("../mail/mail.service");
const alerts_service_1 = require("../alerts/alerts.service");
const mareas_constants_1 = require("./mareas.constants");
const date_utils_1 = require("../common/utils/date.utils");
const marea_utils_1 = require("../common/utils/marea.utils");
const ExcelJS = require("exceljs");
let MareasService = class MareasService {
    constructor(prisma, mailService, alertsService, businessRulesService) {
        this.prisma = prisma;
        this.mailService = mailService;
        this.alertsService = alertsService;
        this.businessRulesService = businessRulesService;
        this.ESTADOS_NAVEGANDO = [mareas_constants_1.MareaEstado.EN_EJECUCION];
        this.ESTADOS_REVISION = [
            mareas_constants_1.MareaEstado.ENTREGADA_RECIBIDA,
            mareas_constants_1.MareaEstado.VERIFICACION_INICIAL,
            mareas_constants_1.MareaEstado.EN_CORRECCION,
            mareas_constants_1.MareaEstado.PENDIENTE_DE_INFORME,
            mareas_constants_1.MareaEstado.ESPERANDO_REVISION
        ];
    }
    get rules() {
        return this.businessRulesService.getRules();
    }
    async findOne(id) {
        const marea = await this.prisma.marea.findUnique({
            where: { id },
            include: {
                buque: {
                    include: {
                        tipoFlota: true
                    }
                },
                observadorPrincipal: true,
                pesqueria: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        pesqueria: true,
                        observadores: {
                            include: { observador: true }
                        }
                    }
                },
                movimientos: {
                    orderBy: { fechaHora: 'desc' },
                    include: {
                        usuario: true,
                        estadoDesde: true,
                        estadoHasta: true
                    }
                },
                archivos: {
                    orderBy: { fechaSubida: 'desc' },
                    include: {
                        usuarioSubio: true,
                        movimientoOrigen: true
                    }
                }
            }
        });
        if (!marea)
            throw new common_1.NotFoundException('Marea no encontrada');
        return {
            ...marea,
            observaciones: marea.observaciones || '',
            id_marea: marea_utils_1.MareaUtils.formatCodigo(marea),
            etapas: marea.etapas.map(e => ({
                ...e,
                durationDays: marea_utils_1.MareaUtils.calculateStageDays(e)
            }))
        };
    }
    async update(id, updateMareaDto) {
        const { etapas, artePrincipalId, arteId, pesqueriaId, observadorId, observadorPrincipalId, ...data } = updateMareaDto;
        const targetObsId = observadorPrincipalId || observadorId;
        if (targetObsId) {
            const currentMarea = await this.prisma.marea.findUnique({
                where: { id },
                select: { observadorPrincipalId: true }
            });
            if (currentMarea && targetObsId !== currentMarea.observadorPrincipalId) {
                const obs = await this.prisma.observador.findUnique({
                    where: { id: targetObsId },
                    select: { conImpedimento: true, motivoImpedimento: true }
                });
                if (obs?.conImpedimento) {
                    throw new common_1.BadRequestException(`No se puede asignar el observador porque posee un impedimento: ${obs.motivoImpedimento || 'Sin motivo'}.`);
                }
            }
        }
        await this.prisma.$transaction(async (tx) => {
            if (updateMareaDto.fechaFinObservador !== undefined || updateMareaDto.fechaInicioObservador !== undefined) {
                const current = await tx.marea.findUnique({
                    where: { id },
                    select: { fechaInicioObservador: true, fechaFinObservador: true }
                });
                const fin = updateMareaDto.fechaFinObservador !== undefined ? updateMareaDto.fechaFinObservador : current?.fechaFinObservador;
                const inicio = updateMareaDto.fechaInicioObservador !== undefined ? updateMareaDto.fechaInicioObservador : current?.fechaInicioObservador;
                if (fin) {
                    if (!inicio) {
                        throw new common_1.BadRequestException('Si se especifica la fecha de fin del observador, la fecha de inicio es obligatoria.');
                    }
                    if (new Date(inicio) > new Date(fin)) {
                        throw new common_1.BadRequestException('La fecha de inicio del observador no puede ser posterior a la de fin.');
                    }
                    const currentEtapas = updateMareaDto.etapas;
                    if (currentEtapas) {
                        const hasOpenStages = currentEtapas.some(e => !e.fechaArribo);
                        if (hasOpenStages) {
                            throw new common_1.BadRequestException('No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.');
                        }
                    }
                    else {
                        const openStagesCount = await tx.mareaEtapa.count({
                            where: {
                                mareaId: id,
                                fechaArribo: null
                            }
                        });
                        if (openStagesCount > 0) {
                            throw new common_1.BadRequestException('No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.');
                        }
                    }
                }
            }
            if (updateMareaDto.nroProtocolizacion !== undefined ||
                updateMareaDto.anioProtocolizacion !== undefined ||
                updateMareaDto.fechaProtocolizacion !== undefined) {
                const current = await tx.marea.findUnique({
                    where: { id },
                    select: { nroProtocolizacion: true, anioProtocolizacion: true, fechaProtocolizacion: true }
                });
                const nro = updateMareaDto.nroProtocolizacion !== undefined ? updateMareaDto.nroProtocolizacion : current?.nroProtocolizacion;
                const anio = updateMareaDto.anioProtocolizacion !== undefined ? updateMareaDto.anioProtocolizacion : current?.anioProtocolizacion;
                const fecha = updateMareaDto.fechaProtocolizacion !== undefined ? updateMareaDto.fechaProtocolizacion : current?.fechaProtocolizacion;
                const values = [nro, anio, fecha];
                const someDefined = values.some(v => v !== null && v !== undefined);
                const allDefined = values.every(v => v !== null && v !== undefined);
                if (someDefined && !allDefined) {
                    throw new common_1.BadRequestException('Los campos de protocolización (número, año y fecha) deben completarse todos juntos o permanecer todos vacíos.');
                }
            }
            const updateData = { ...data };
            const processDate = (val) => (val === undefined || val === null) ? val : date_utils_1.DateUtils.truncateTime(val);
            if (artePrincipalId !== undefined)
                updateData.artePrincipalId = artePrincipalId;
            if (artePrincipalId === undefined && arteId !== undefined)
                updateData.artePrincipalId = arteId;
            if (updateMareaDto.fechaZarpadaEstimada !== undefined)
                updateData.fechaZarpadaEstimada = processDate(updateMareaDto.fechaZarpadaEstimada);
            if (updateMareaDto.fechaInicioObservador !== undefined)
                updateData.fechaInicioObservador = processDate(updateMareaDto.fechaInicioObservador);
            if (updateMareaDto.fechaFinObservador !== undefined)
                updateData.fechaFinObservador = processDate(updateMareaDto.fechaFinObservador);
            if (updateMareaDto.fechaProtocolizacion !== undefined)
                updateData.fechaProtocolizacion = processDate(updateMareaDto.fechaProtocolizacion);
            if (observadorPrincipalId !== undefined)
                updateData.observadorPrincipalId = observadorPrincipalId;
            if (pesqueriaId !== undefined)
                updateData.pesqueriaId = pesqueriaId;
            if (updateMareaDto.diasZonaAustral !== undefined)
                updateData.diasZonaAustral = updateMareaDto.diasZonaAustral;
            if (updateMareaDto.nroProtocolizacion !== undefined)
                updateData.nroProtocolizacion = updateMareaDto.nroProtocolizacion;
            if (updateMareaDto.anioProtocolizacion !== undefined)
                updateData.anioProtocolizacion = updateMareaDto.anioProtocolizacion;
            if (updateMareaDto.diasEstimados !== undefined)
                updateData.diasEstimados = updateMareaDto.diasEstimados;
            if (updateMareaDto.tipoCalculoZonaAustral !== undefined)
                updateData.tipoCalculoZonaAustral = updateMareaDto.tipoCalculoZonaAustral;
            if (Object.keys(updateData).length > 0) {
                await tx.marea.update({
                    where: { id },
                    data: updateData
                });
            }
            if (etapas && etapas.length > 0) {
                const payloadEtapaIds = etapas.map(e => e.id).filter(id => !!id);
                await tx.mareaEtapa.deleteMany({
                    where: {
                        mareaId: id,
                        id: { notIn: payloadEtapaIds }
                    }
                });
                this.validateStagesChronology(etapas);
                this.validateStagesIntegrity(etapas);
                for (const etapa of etapas) {
                    const { observadores, id: etapaId, ...rest } = etapa;
                    const etapaData = { ...rest };
                    let currentEtapaId = etapaId;
                    etapaData.puertoZarpadaId = this.sanitizeUuid(etapaData.puertoZarpadaId);
                    etapaData.puertoArriboId = this.sanitizeUuid(etapaData.puertoArriboId);
                    etapaData.pesqueriaId = this.sanitizeUuid(etapaData.pesqueriaId);
                    if (etapaData.fechaZarpada)
                        etapaData.fechaZarpada = date_utils_1.DateUtils.truncateTime(etapaData.fechaZarpada);
                    if (etapaData.fechaArribo)
                        etapaData.fechaArribo = date_utils_1.DateUtils.truncateTime(etapaData.fechaArribo);
                    if (currentEtapaId) {
                        const existing = await tx.mareaEtapa.findFirst({
                            where: { id: currentEtapaId, mareaId: id }
                        });
                        if (!existing) {
                            throw new common_1.NotFoundException('Etapa no encontrada para la marea.');
                        }
                        await tx.mareaEtapa.update({
                            where: { id: currentEtapaId },
                            data: etapaData
                        });
                    }
                    else {
                        const created = await tx.mareaEtapa.create({
                            data: {
                                mareaId: id,
                                ...etapaData
                            }
                        });
                        currentEtapaId = created.id;
                    }
                    if (observadores) {
                        await tx.mareaEtapaObservador.deleteMany({
                            where: { etapaId: currentEtapaId }
                        });
                        for (const obs of observadores) {
                            await tx.mareaEtapaObservador.create({
                                data: {
                                    etapaId: currentEtapaId,
                                    observadorId: obs.observadorId,
                                    rol: obs.rol,
                                    esDesignado: obs.esDesignado ?? true
                                }
                            });
                        }
                    }
                }
            }
        });
        return this.findOne(id);
    }
    formatMareaId(m) {
        return marea_utils_1.MareaUtils.formatCodigo(m);
    }
    resolveYear(year) {
        return year && !Number.isNaN(year) ? year : new Date().getFullYear();
    }
    buildMareaYearFilter(year) {
        const operationalYear = this.resolveYear(year);
        const startOfYear = new Date(operationalYear, 0, 1);
        const startOfNextYear = new Date(operationalYear + 1, 0, 1);
        const mareaYearFilter = {
            OR: [
                {
                    estadoActual: { codigo: { notIn: [mareas_constants_1.MareaEstado.PROTOCOLIZADA, mareas_constants_1.MareaEstado.CANCELADA] } },
                    anioMarea: { in: [operationalYear, operationalYear - 1] }
                },
                {
                    estadoActual: { codigo: mareas_constants_1.MareaEstado.PROTOCOLIZADA },
                    OR: [
                        { anioProtocolizacion: operationalYear },
                        { anioMarea: operationalYear }
                    ]
                },
                {
                    estadoActual: { codigo: mareas_constants_1.MareaEstado.CANCELADA },
                    OR: [
                        {
                            fechaFinObservador: {
                                gte: startOfYear,
                                lt: startOfNextYear
                            }
                        },
                        { anioMarea: operationalYear }
                    ]
                }
            ]
        };
        return { operationalYear, mareaYearFilter };
    }
    async getDashboardOperativo(year, showAll) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const estadosWhere = { activo: true };
        if (!showAll) {
            estadosWhere.mostrarEnPanel = true;
        }
        const [estados, transiciones] = await Promise.all([
            this.prisma.estadoMarea.findMany({
                where: estadosWhere,
                orderBy: { orden: 'asc' }
            }),
            this.prisma.transicionEstado.findMany({
                where: { activo: true }
            })
        ]);
        const kpisRaw = await Promise.all(estados.map(async (e) => ({
            label: e.nombre,
            value: await this.prisma.marea.count({
                where: { estadoActualId: e.id, activo: true, ...mareaYearFilter }
            }),
            codigo: e.codigo
        })));
        const kpis = kpisRaw.filter(k => showAll || k.value > 0);
        const mareasWhere = {
            activo: true,
            ...mareaYearFilter
        };
        if (!showAll) {
            mareasWhere.estadoActual = {
                mostrarEnPanel: true
            };
        }
        const mareas = await this.prisma.marea.findMany({
            where: mareasWhere,
            select: {
                id: true,
                nroMarea: true,
                anioMarea: true,
                tipoMarea: true,
                estadoActualId: true,
                diasEstimados: true,
                fechaZarpadaEstimada: true,
                fechaInicioObservador: true,
                fechaFinObservador: true,
                buque: {
                    include: {
                        pesqueriaHabitual: true
                    }
                },
                observadorPrincipal: true,
                pesqueria: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        pesqueria: true,
                        observadores: {
                            include: { observador: true },
                        }
                    }
                }
            },
            orderBy: [
                { anioMarea: 'desc' },
                { nroMarea: 'desc' }
            ]
        });
        const mareaIds = mareas.map(m => m.id);
        const activeAlerts = await this.prisma.alerta.findMany({
            where: {
                referenciaId: { in: mareaIds },
                estado: 'PENDIENTE'
            }
        });
        const items = mareas.map((m) => {
            const etapaInicial = m.etapas[0] || null;
            const etapaFinal = m.etapas[m.etapas.length - 1] || null;
            const primaryObs = m.observadorPrincipal || etapaFinal?.observadores[0]?.observador || null;
            const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === m.estadoActualId);
            const actionsAvailable = {};
            allowedTransitions.forEach(t => {
                actionsAvailable[t.accion] = {
                    enabled: true,
                    label: t.etiqueta,
                    toState: t.estadoDestinoId
                };
            });
            const progreso = this.calculateProgress(m);
            return {
                id: m.id,
                id_marea: this.formatMareaId(m),
                anio_marea: m.anioMarea,
                nro_marea: m.nroMarea,
                buque_nombre: m.buque.nombreBuque,
                puertoBaseId: m.buque.puertoBaseId,
                estado: m.estadoActual.nombre,
                estado_codigo: m.estadoActual.codigo,
                fecha_zarpada: etapaInicial?.fechaZarpada || m.fechaZarpadaEstimada,
                puerto: etapaFinal?.puertoArribo?.nombre || etapaFinal?.puertoZarpada?.nombre || 'N/D',
                puerto_zarpada: etapaInicial?.puertoZarpada?.nombre || 'N/D',
                puerto_arribo: etapaFinal?.puertoArribo?.nombre,
                fecha_arribo: etapaFinal?.fechaArribo,
                observador: primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : 'Sin asignar',
                progreso,
                en_tierra: m.estadoActual.codigo === mareas_constants_1.MareaEstado.EN_EJECUCION && etapaFinal?.fechaArribo !== null,
                total_etapas: etapaFinal?.nroEtapa || 1,
                dias_navegados: marea_utils_1.MareaUtils.calculateNavigatedDays(m),
                alertas: activeAlerts.filter((a) => a.referenciaId === m.id),
                actionsAvailable,
                dias_estimados: m.diasEstimados,
                pesquerias_nombres: Array.from(new Set([
                    m.pesqueria?.nombre,
                    ...m.etapas.map(e => e.pesqueria?.nombre)
                ].filter(Boolean)))
            };
        });
        return {
            kpis,
            items
        };
    }
    async getDashboardKpis(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const [buquesActivos, observadoresDisponibles, mareasDesignadas, listasParaProtocolizar, mareasEnRevision] = await Promise.all([
            this.prisma.marea.groupBy({
                by: ['buqueId'],
                where: {
                    activo: true,
                    ...mareaYearFilter,
                    buque: {
                        activo: true
                    },
                    estadoActual: {
                        codigo: { in: this.ESTADOS_NAVEGANDO }
                    }
                },
                _count: {
                    _all: true
                }
            }),
            this.prisma.observador.count({
                where: {
                    activo: true,
                    disponible: true
                }
            }),
            this.prisma.marea.count({
                where: {
                    activo: true,
                    ...mareaYearFilter,
                    estadoActual: {
                        codigo: mareas_constants_1.MareaEstado.DESIGNADA
                    }
                }
            }),
            this.prisma.marea.count({
                where: {
                    activo: true,
                    ...mareaYearFilter,
                    estadoActual: {
                        codigo: mareas_constants_1.MareaEstado.ESPERANDO_PROTOCOLIZACION
                    }
                }
            }),
            this.prisma.marea.count({
                where: {
                    activo: true,
                    ...mareaYearFilter,
                    estadoActual: {
                        codigo: { in: this.ESTADOS_REVISION }
                    }
                }
            })
        ]);
        return {
            flotaActiva: buquesActivos.length,
            observadoresDisponibles,
            mareasDesignadas,
            listasParaProtocolizar,
            enRevision: mareasEnRevision
        };
    }
    async getFleetDistributionByFishery(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const activeStates = [mareas_constants_1.MareaEstado.DESIGNADA, ...this.ESTADOS_NAVEGANDO];
        const activeMareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
                estadoActual: {
                    codigo: { in: activeStates }
                }
            },
            include: {
                estadoActual: true,
                buque: {
                    select: {
                        nombreBuque: true
                    }
                },
                observadorPrincipal: true,
                pesqueria: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true
                    }
                }
            }
        });
        const distributionMap = new Map();
        activeMareas.forEach((marea) => {
            let label = 'Sin pesquería';
            if (marea.etapas && marea.etapas.length > 0) {
                const daysByFishery = new Map();
                marea.etapas.forEach((etapa) => {
                    const fisheryName = etapa.pesqueria?.nombre || 'Sin pesquería';
                    const days = marea_utils_1.MareaUtils.calculateStageDays(etapa);
                    daysByFishery.set(fisheryName, (daysByFishery.get(fisheryName) || 0) + days);
                });
                let maxDays = -1;
                let bestFishery = 'Sin pesquería';
                daysByFishery.forEach((days, name) => {
                    if (days > maxDays) {
                        maxDays = days;
                        bestFishery = name;
                    }
                });
                label = bestFishery;
            }
            else if (marea.pesqueria?.nombre) {
                label = marea.pesqueria.nombre;
            }
            const vesselName = marea.buque.nombreBuque;
            const mareaCode = `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}`;
            const status = marea.estadoActual?.codigo ?? mareas_constants_1.MareaEstado.EN_EJECUCION;
            if (!distributionMap.has(label)) {
                distributionMap.set(label, { count: 0, vessels: new Map() });
            }
            const item = distributionMap.get(label);
            item.vessels.set(vesselName, { mareaCode, status });
        });
        const distribution = Array.from(distributionMap.entries())
            .map(([label, data]) => ({
            label,
            count: data.vessels.size,
            vessels: Array.from(data.vessels.entries())
                .map(([name, vesselData]) => ({ name, ...vesselData }))
                .sort((a, b) => a.name.localeCompare(b.name))
        }))
            .sort((a, b) => b.count - a.count);
        return {
            total: activeMareas.length,
            distribution
        };
    }
    async getRecentMovements(days) {
        const daysToLookBack = days || 7;
        const now = date_utils_1.DateUtils.getNow();
        const limitDate = new Date(now);
        limitDate.setDate(limitDate.getDate() - daysToLookBack);
        limitDate.setHours(0, 0, 0, 0);
        const etapas = await this.prisma.mareaEtapa.findMany({
            where: {
                OR: [
                    {
                        fechaZarpada: {
                            gte: limitDate
                        }
                    },
                    {
                        fechaArribo: {
                            gte: limitDate
                        }
                    }
                ]
            },
            include: {
                marea: {
                    include: {
                        buque: true,
                        observadorPrincipal: true
                    }
                },
                puertoZarpada: true,
                puertoArribo: true,
                observadores: {
                    where: { rol: 'PRINCIPAL' },
                    include: { observador: true }
                }
            }
        });
        const events = [];
        for (const etapa of etapas) {
            const marea = etapa.marea;
            const primaryObs = marea.observadorPrincipal || etapa.observadores[0]?.observador;
            const obsName = primaryObs ? `${primaryObs.apellido}, ${primaryObs.nombre}` : 'Sin Asignar';
            const mareaCode = marea_utils_1.MareaUtils.formatCodigo(marea);
            const buqueName = marea.buque.nombreBuque;
            if (etapa.fechaZarpada && new Date(etapa.fechaZarpada) >= limitDate) {
                events.push({
                    id: `zar-${etapa.id}`,
                    buque: buqueName,
                    marea: mareaCode,
                    observador: obsName,
                    etapa: etapa.nroEtapa || 1,
                    tipo: 'ZARPADA',
                    fecha: etapa.fechaZarpada,
                    puerto: etapa.puertoZarpada?.nombre || 'N/D'
                });
            }
            if (etapa.fechaArribo && new Date(etapa.fechaArribo) >= limitDate) {
                events.push({
                    id: `arr-${etapa.id}`,
                    buque: buqueName,
                    marea: mareaCode,
                    observador: obsName,
                    etapa: etapa.nroEtapa || 1,
                    tipo: 'ARRIBO',
                    fecha: etapa.fechaArribo,
                    puerto: etapa.puertoArribo?.nombre || 'N/D'
                });
            }
        }
        const sortedEvents = events.sort((a, b) => new Date(b.fecha).getTime() - new Date(a.fecha).getTime());
        const lastStageUpdate = await this.prisma.mareaEtapa.findFirst({
            orderBy: { updatedAt: 'desc' },
            select: { updatedAt: true }
        });
        return {
            events: sortedEvents,
            lastUpdate: lastStageUpdate?.updatedAt || null
        };
    }
    async getCriticalDelays(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = date_utils_1.DateUtils.getNow(true);
        const limit = this.rules.PLAZO_ENTREGA_DATOS;
        const mareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
                estadoActual: {
                    codigo: mareas_constants_1.MareaEstado.ESPERANDO_ENTREGA
                }
            },
            include: {
                buque: true,
                observadorPrincipal: true,
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        observadores: {
                            where: { rol: 'PRINCIPAL' },
                            include: { observador: true }
                        }
                    }
                }
            }
        });
        const delays = [];
        mareas.forEach((m) => {
            const lastStage = m.etapas[0];
            const arrivalDate = lastStage?.fechaArribo ? new Date(lastStage.fechaArribo) : null;
            if (arrivalDate) {
                const diffTime = now.getTime() - arrivalDate.getTime();
                const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
                if (diffDays > limit) {
                    const primaryObs = m.observadorPrincipal || lastStage.observadores[0]?.observador;
                    delays.push({
                        id: m.id,
                        mareaId: this.formatMareaId(m),
                        vesselName: m.buque.nombreBuque,
                        obs: primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : 'Sin Asignar',
                        email: primaryObs?.email || null,
                        observerId: primaryObs?.id,
                        arrivalDate: arrivalDate,
                        days: diffDays
                    });
                }
            }
        });
        return delays.sort((a, b) => b.days - a.days);
    }
    async getReportDelays(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = date_utils_1.DateUtils.getNow(true);
        const limit = this.rules.PLAZO_CONFECCION_INFORME;
        const TARGET_STATES = [
            mareas_constants_1.MareaEstado.ENTREGADA_RECIBIDA,
            mareas_constants_1.MareaEstado.VERIFICACION_INICIAL,
            mareas_constants_1.MareaEstado.EN_CORRECCION,
            mareas_constants_1.MareaEstado.DELEGADA_EXTERNA,
            mareas_constants_1.MareaEstado.PENDIENTE_DE_INFORME
        ];
        const estadoRecepcion = await this.prisma.estadoMarea.findFirst({
            where: { codigo: mareas_constants_1.MareaEstado.ENTREGADA_RECIBIDA }
        });
        const mareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
                estadoActual: {
                    codigo: { in: TARGET_STATES }
                }
            },
            include: {
                buque: true,
                observadorPrincipal: true,
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        observadores: {
                            include: { observador: true }
                        }
                    }
                },
                movimientos: {
                    where: estadoRecepcion ? {
                        tipoEvento: 'CAMBIO_ESTADO',
                        estadoHastaId: estadoRecepcion.id
                    } : {
                        tipoEvento: 'RECEPCION_DATOS_ORIGINALES'
                    },
                    orderBy: { fechaHora: 'asc' },
                    take: 1
                }
            }
        });
        const delays = [];
        mareas.forEach((m) => {
            let baseDate = null;
            if (m.movimientos.length > 0) {
                baseDate = new Date(m.movimientos[0].fechaHora);
            }
            else if (m.etapas[0]?.fechaArribo) {
                baseDate = new Date(m.etapas[0].fechaArribo);
            }
            if (baseDate) {
                const diffTime = now.getTime() - baseDate.getTime();
                const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
                if (diffDays > limit) {
                    const lastStage = m.etapas[0];
                    const primaryObs = m.observadorPrincipal || lastStage?.observadores[0]?.observador;
                    delays.push({
                        id: m.id,
                        mareaId: this.formatMareaId(m),
                        vesselName: m.buque.nombreBuque,
                        obs: primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : 'Sin Asignar',
                        baseDate: baseDate,
                        days: diffDays
                    });
                }
            }
        });
        return delays.sort((a, b) => b.days - a.days);
    }
    async getCalendarEvents(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const mareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter
            },
            include: {
                buque: true,
                observadorPrincipal: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        observadores: {
                            include: { observador: true }
                        }
                    }
                },
                movimientos: {
                    where: {
                        tipoEvento: {
                            in: ['INFORME_PROTOCOLIZADO', 'INFORME_APROBADO']
                        }
                    }
                }
            }
        });
        const events = [];
        mareas.forEach((m) => {
            const mareaCode = this.formatMareaId(m);
            const buque = m.buque.nombreBuque;
            const primaryObs = m.observadorPrincipal || m.etapas[0]?.observadores[0]?.observador;
            const obs = primaryObs?.apellido || 'Sin Asignar';
            const commonProps = {
                mareaId: m.id,
                vesselName: buque,
                description: `Marea ${mareaCode} - Buque ${buque} - Observador ${obs}`
            };
            if (m.fechaInicioObservador) {
                events.push({
                    id: `des-${m.id}`,
                    title: `📋 Designación ${mareaCode} - ${buque} (${obs})`,
                    start: m.fechaInicioObservador,
                    type: 'designacion',
                    ...commonProps
                });
            }
            m.etapas.forEach((e) => {
                if (e.fechaZarpada) {
                    events.push({
                        id: `zar-${e.id}`,
                        title: `⛵ Zarpada ${mareaCode} - ${buque}`,
                        start: e.fechaZarpada,
                        type: 'zarpada',
                        ...commonProps
                    });
                }
                if (e.fechaArribo) {
                    events.push({
                        id: `arr-${e.id}`,
                        title: `🚢 Arribo ${mareaCode} - ${buque}`,
                        start: e.fechaArribo,
                        type: 'arribo',
                        ...commonProps
                    });
                    if (m.estadoActual?.codigo === mareas_constants_1.MareaEstado.ESPERANDO_ENTREGA) {
                        const deadline = new Date(e.fechaArribo);
                        deadline.setDate(deadline.getDate() + this.rules.PLAZO_ENTREGA_DATOS);
                        events.push({
                            id: `ven-${e.id}`,
                            title: `⚠️ Vencimiento Datos ${mareaCode}`,
                            start: deadline,
                            type: 'alerta',
                            ...commonProps,
                            description: `Vencimiento de plazo para entrega de datos. Marea ${mareaCode}.`
                        });
                    }
                }
            });
            m.movimientos.forEach((mov) => {
                if (mov.tipoEvento === 'INFORME_PROTOCOLIZADO') {
                    events.push({
                        id: `inf-${mov.id}`,
                        title: `📄 Informe Protocolizado ${mareaCode}`,
                        start: mov.fechaHora,
                        type: 'informe',
                        ...commonProps
                    });
                }
                else if (mov.tipoEvento === 'INFORME_APROBADO') {
                    events.push({
                        id: `val-${mov.id}`,
                        title: `✅ Validación ${mareaCode}`,
                        start: mov.fechaHora,
                        type: 'validacion',
                        ...commonProps
                    });
                }
            });
        });
        return events;
    }
    calculateProgress(m) {
        const estadoCodigo = m.estadoActual?.codigo;
        if (estadoCodigo === mareas_constants_1.MareaEstado.DESIGNADA) {
            return 0;
        }
        const diasTrabajados = marea_utils_1.MareaUtils.calculateNavigatedDays(m);
        const estimatedDuration = (m.diasEstimados && m.diasEstimados > 0) ? m.diasEstimados : 30;
        let progreso = Math.round((diasTrabajados / estimatedDuration) * 100);
        if (estadoCodigo !== mareas_constants_1.MareaEstado.EN_EJECUCION && progreso < 100 && diasTrabajados > 0) {
            progreso = 100;
        }
        return Math.min(progreso, 100);
    }
    async getFatigueAlerts(year) {
        const operationalYear = this.resolveYear(year);
        const periodStart = new Date(operationalYear, 0, 1, 0, 0, 0, 0);
        const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);
        const etapas = await this.prisma.mareaEtapa.findMany({
            where: {
                marea: {
                    activo: true
                },
                AND: [
                    { fechaZarpada: { not: null, lte: periodEnd } },
                    {
                        OR: [
                            { fechaArribo: { gte: periodStart } },
                            { fechaArribo: null }
                        ]
                    }
                ]
            },
            include: {
                marea: {
                    include: { buque: true, estadoActual: true, observadorPrincipal: true }
                },
                observadores: {
                    include: { observador: true }
                }
            }
        });
        const now = new Date();
        const observerDataMap = new Map();
        etapas.forEach((etapa) => {
            const inicio = etapa.fechaZarpada ? new Date(etapa.fechaZarpada) : null;
            if (!inicio)
                return;
            const finRaw = etapa.fechaArribo ? new Date(etapa.fechaArribo) : null;
            const finCandidate = finRaw || now;
            const finNoFuture = finCandidate > now ? now : finCandidate;
            const fin = finNoFuture > periodEnd ? periodEnd : finNoFuture;
            const clampedInicio = inicio < periodStart ? periodStart : inicio;
            const clampedFin = fin;
            if (clampedFin < periodStart || clampedInicio > clampedFin)
                return;
            const m = etapa.marea;
            const mareaCode = this.formatMareaId(m);
            const vessel = m.buque.nombreBuque;
            etapa.observadores.forEach((o) => {
                if (!o.observador?.activo)
                    return;
                this.addObserverToMap(observerDataMap, o.observador, m, mareaCode, vessel, clampedInicio, clampedFin);
            });
            if (m.observadorPrincipal && m.observadorPrincipal.activo) {
                this.addObserverToMap(observerDataMap, m.observadorPrincipal, m, mareaCode, vessel, clampedInicio, clampedFin);
            }
        });
        const alerts = [];
        const THRESHOLD = Math.floor(this.rules.DIAS_NAVEGADOS_ANUALES * this.rules.UMBRAL_FATIGA_ANUAL_PORCENTAJE);
        observerDataMap.forEach((data, id) => {
            const allTripsIntervals = [];
            data.mareaGroups.forEach(g => allTripsIntervals.push(...g.stages));
            const alertDays = date_utils_1.DateUtils.calculateUniqueDays(allTripsIntervals.map(i => ({ start: i.inicio, end: i.fin })));
            if (alertDays > THRESHOLD) {
                const trips = [];
                let lastArrival = null;
                data.mareaGroups.forEach((group) => {
                    const sortedStages = [...group.stages].sort((a, b) => a.inicio.getTime() - b.inicio.getTime());
                    const firstDep = sortedStages[0].inicio;
                    const lastArr = sortedStages[sortedStages.length - 1].fin;
                    if (!lastArrival || lastArr > lastArrival) {
                        lastArrival = lastArr;
                    }
                    trips.push({
                        mareaCode: group.mareaCode,
                        nroMarea: group.nroMarea,
                        vessel: group.vessel,
                        departure: firstDep,
                        arrival: lastArr,
                        inExecution: group.inExecution,
                        navigatedDays: date_utils_1.DateUtils.calculateUniqueDays(group.stages.map((s) => ({ start: s.inicio, end: s.fin })))
                    });
                });
                trips.sort((a, b) => a.nroMarea - b.nroMarea);
                alerts.push({
                    id,
                    name: data.nombre,
                    days: alertDays,
                    lastArrival,
                    trips
                });
            }
        });
        return alerts;
    }
    async getWorkforceStatus(year) {
        const { operationalYear, mareaYearFilter } = this.buildMareaYearFilter(year);
        const periodStart = new Date(operationalYear, 0, 1, 0, 0, 0, 0);
        const now = new Date();
        const observadores = await this.prisma.observador.findMany({
            where: { activo: true }
        });
        const etapas = await this.prisma.mareaEtapa.findMany({
            where: {
                marea: {
                    activo: true,
                    anioMarea: { in: [operationalYear, operationalYear - 1] }
                },
                fechaZarpada: { not: null }
            },
            orderBy: { fechaZarpada: 'asc' },
            include: {
                marea: {
                    include: { estadoActual: true, buque: true, observadorPrincipal: true, pesqueria: true }
                },
                pesqueria: true,
                observadores: {
                    include: { observador: true }
                }
            }
        });
        const activeNav = new Map();
        const lastArrivalByObs = new Map();
        const obsConMareas = new Set();
        etapas.forEach((etapa) => {
            const inicio = etapa.fechaZarpada ? new Date(etapa.fechaZarpada) : null;
            if (!inicio)
                return;
            const finRaw = etapa.fechaArribo ? new Date(etapa.fechaArribo) : null;
            const fin = finRaw || now;
            const processObs = (obs) => {
                if (!obs?.activo)
                    return;
                obsConMareas.add(obs.id);
                const isNavigating = this.ESTADOS_NAVEGANDO.includes(etapa.marea.estadoActual?.codigo);
                if (isNavigating) {
                    activeNav.set(obs.id, {
                        start: inicio,
                        vessel: etapa.marea.buque.nombreBuque,
                        mareaCode: marea_utils_1.MareaUtils.formatCodigo(etapa.marea),
                        fishery: etapa.pesqueria?.nombre || etapa.marea.pesqueria?.nombre || 'Desconocida',
                        enTierra: finRaw !== null
                    });
                }
                if (finRaw) {
                    const prev = lastArrivalByObs.get(obs.id);
                    if (!prev || finRaw > prev.date) {
                        lastArrivalByObs.set(obs.id, {
                            date: finRaw,
                            mareaCode: marea_utils_1.MareaUtils.formatCodigo(etapa.marea),
                            vessel: etapa.marea.buque.nombreBuque,
                            fishery: etapa.pesqueria?.nombre || etapa.marea.pesqueria?.nombre || 'Desconocida'
                        });
                    }
                }
            };
            etapa.observadores.forEach((o) => processObs(o.observador));
            if (etapa.marea.observadorPrincipal)
                processObs(etapa.marea.observadorPrincipal);
        });
        const listDescanso = [];
        const listImpedidos = [];
        const listDisponibles = [];
        const listNavegando = [];
        const topDryCandidates = [];
        observadores.forEach((obs) => {
            if (!obs.activo)
                return;
            const name = `${obs.apellido}, ${obs.nombre}`;
            const lastArrivalData = lastArrivalByObs.get(obs.id);
            const lastArrival = lastArrivalData?.date;
            const daysSince = lastArrival ? date_utils_1.DateUtils.calculateInclusiveDays(lastArrival, now) - 1 : null;
            const status = this.getObserverStatus(obs, activeNav.has(obs.id), lastArrival, now);
            if (obsConMareas.has(obs.id) && status === 'DISPONIBLE' && lastArrival && lastArrivalData && daysSince !== null && obs.tipoObservador === 'OBSERVADOR') {
                topDryCandidates.push({
                    id: obs.id,
                    name,
                    days: daysSince,
                    lastArrival: lastArrival.toISOString(),
                    mareaCode: lastArrivalData.mareaCode,
                    vesselName: lastArrivalData.vessel,
                    fishery: lastArrivalData.fishery,
                    tipoObservador: obs.tipoObservador
                });
            }
            switch (status) {
                case 'NAVEGANDO':
                    const navData = activeNav.get(obs.id);
                    const daysNav = navData ? date_utils_1.DateUtils.calculateInclusiveDays(navData.start, now) : 0;
                    listNavegando.push({
                        id: obs.id,
                        name,
                        vessel: navData?.vessel || 'Desconocido',
                        mareaCode: navData?.mareaCode || '',
                        fishery: navData?.fishery || '',
                        enTierra: navData?.enTierra || false,
                        days: daysNav,
                        startDate: navData?.start?.toISOString() || '',
                        tipoObservador: obs.tipoObservador
                    });
                    break;
                case 'IMPEDIDO':
                    listImpedidos.push({
                        id: obs.id,
                        name,
                        motivo: obs.motivoImpedimento || 'Sin motivo especificado',
                        tipoObservador: obs.tipoObservador
                    });
                    break;
                case 'DESCANSO':
                    listDescanso.push({
                        id: obs.id,
                        name,
                        days: daysSince || 0,
                        lastArrival: lastArrival?.toISOString() || '',
                        mareaCode: lastArrivalData?.mareaCode || '',
                        vesselName: lastArrivalData?.vessel || '',
                        fishery: lastArrivalData?.fishery || '',
                        tipoObservador: obs.tipoObservador
                    });
                    break;
                case 'DISPONIBLE':
                    listDisponibles.push({
                        id: obs.id,
                        name,
                        days: daysSince || 0,
                        lastArrival: lastArrival?.toISOString() || '',
                        mareaCode: lastArrivalData?.mareaCode || '',
                        vesselName: lastArrivalData?.vessel || '',
                        fishery: lastArrivalData?.fishery || '',
                        tipoObservador: obs.tipoObservador
                    });
                    break;
            }
        });
        topDryCandidates.sort((a, b) => b.days - a.days);
        const topDry = topDryCandidates.slice(0, 5);
        listNavegando.sort((a, b) => b.days - a.days);
        listDescanso.sort((a, b) => b.days - a.days);
        listDisponibles.sort((a, b) => b.days - a.days);
        listImpedidos.sort((a, b) => a.name.localeCompare(b.name));
        return {
            totalActivos: observadores.length,
            navegando: listNavegando.length,
            descanso: listDescanso.length,
            disponibles: listDisponibles.length,
            impedidos: listImpedidos.length,
            licencia: 0,
            topDry,
            listNavegando,
            listDescanso,
            listDisponibles,
            listImpedidos
        };
    }
    getObserverStatus(obs, isNavigating, lastArrival, now) {
        if (isNavigating)
            return 'NAVEGANDO';
        if (obs.conImpedimento)
            return 'IMPEDIDO';
        if (lastArrival) {
            const daysSince = date_utils_1.DateUtils.calculateInclusiveDays(lastArrival, now) - 1;
            if (daysSince < this.rules.DIAS_DESCANSO_POST_MAREA) {
                return 'DESCANSO';
            }
        }
        if (obs.disponible)
            return 'DISPONIBLE';
        return 'OTRO';
    }
    async getMareaContext(id) {
        const [marea, transiciones, activeAlerts] = (await Promise.all([
            this.prisma.marea.findUnique({
                where: { id },
                include: {
                    buque: true,
                    observadorPrincipal: true,
                    estadoActual: true,
                    etapas: {
                        orderBy: { nroEtapa: 'asc' },
                        include: {
                            puertoZarpada: true,
                            puertoArribo: true,
                            pesqueria: true,
                            observadores: {
                                include: { observador: true }
                            }
                        }
                    },
                    movimientos: {
                        orderBy: { fechaHora: 'desc' },
                        take: 5,
                        include: {
                            usuario: true
                        }
                    }
                }
            }),
            this.prisma.transicionEstado.findMany({
                where: { activo: true }
            }),
            this.prisma.alerta.findMany({
                where: {
                    referenciaId: id,
                    estado: 'PENDIENTE'
                }
            })
        ]));
        if (!marea)
            return null;
        const etapaInicial = marea.etapas[0] || null;
        const etapaFinal = marea.etapas[marea.etapas.length - 1] || null;
        const mainObs = marea.observadorPrincipal || null;
        const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === marea.estadoActualId);
        const actions = {};
        allowedTransitions.forEach(t => {
            actions[t.accion] = {
                enabled: true,
                label: t.etiqueta,
                toState: t.estadoDestinoId,
                claseBoton: t.claseBoton
            };
        });
        if (marea.estadoActual.codigo === mareas_constants_1.MareaEstado.EN_EJECUCION) {
            actions['EDITAR_ETAPAS'] = {
                enabled: true,
                label: 'Editar Etapas',
                claseBoton: 'btn-ghost'
            };
        }
        const fechaZarpada = etapaInicial?.fechaZarpada || marea.fechaZarpadaEstimada;
        const now = new Date();
        const codigoEstado = marea.estadoActual.codigo;
        let diasMarea = 0;
        let diasNavegados = 0;
        if (codigoEstado !== mareas_constants_1.MareaEstado.DESIGNADA && codigoEstado !== mareas_constants_1.MareaEstado.CANCELADA) {
            if (marea.fechaInicioObservador) {
                diasMarea = date_utils_1.DateUtils.calculateInclusiveDays(marea.fechaInicioObservador, marea.fechaFinObservador);
            }
            diasNavegados = marea_utils_1.MareaUtils.calculateNavigatedDays(marea);
        }
        const progreso = this.calculateProgress(marea);
        return {
            marea: {
                id: marea.id,
                id_marea: this.formatMareaId(marea),
                buque_nombre: marea.buque.nombreBuque,
                puertoBaseId: marea.buque.puertoBaseId,
                estado: marea.estadoActual.nombre,
                estado_codigo: marea.estadoActual.codigo,
                observador: mainObs ? `${mainObs.nombre} ${mainObs.apellido}` : 'No asignado',
                pesqueria: etapaFinal?.pesqueria?.nombre || 'General',
                fecha_zarpada: fechaZarpada,
                fecha_zarpada_estimada: marea.fechaZarpadaEstimada,
                fechaInicioObservador: marea.fechaInicioObservador,
                fecha_fin_observador: marea.fechaFinObservador,
                dias_marea: diasMarea,
                dias_navegados: diasNavegados,
                progreso: progreso,
                id_pesqueria: marea.pesqueriaId,
                observaciones: marea.observaciones || '',
                alertas: activeAlerts,
                etapas: marea.etapas.map((e) => ({
                    id: e.id,
                    nroEtapa: e.nroEtapa,
                    pesqueriaId: e.pesqueriaId,
                    puertoZarpadaId: e.puertoZarpadaId,
                    puertoZarpadaNombre: e.puertoZarpada?.nombre,
                    puertoArriboId: e.puertoArriboId,
                    puertoArriboNombre: e.puertoArribo?.nombre,
                    fechaZarpada: e.fechaZarpada,
                    fechaArribo: e.fechaArribo,
                    durationDays: marea_utils_1.MareaUtils.calculateStageDays(e)
                }))
            },
            actions,
            lastEvents: marea.movimientos.map((mov) => ({
                id: mov.id,
                titulo: mov.detalle || mov.tipoEvento,
                fecha: mov.fechaHora,
                usuario: mov.usuario?.fullName || 'Sistema'
            })),
            etapas: marea.etapas
        };
    }
    async search(query) {
        if (!query || query.length < 2)
            return [];
        const isNumeric = !isNaN(Number(query));
        const queryParts = query.split(' ').filter(p => p.length > 0);
        const orConditions = [
            { buque: { nombreBuque: { contains: query, mode: 'insensitive' } } },
            {
                observadorPrincipal: {
                    AND: queryParts.map(part => ({
                        OR: [
                            { nombre: { contains: part, mode: 'insensitive' } },
                            { apellido: { contains: part, mode: 'insensitive' } }
                        ]
                    }))
                }
            },
            {
                etapas: {
                    some: {
                        observadores: {
                            some: {
                                observador: {
                                    AND: queryParts.map(part => ({
                                        OR: [
                                            { nombre: { contains: part, mode: 'insensitive' } },
                                            { apellido: { contains: part, mode: 'insensitive' } }
                                        ]
                                    }))
                                }
                            }
                        }
                    }
                }
            }
        ];
        if (isNumeric) {
            orConditions.push({ nroMarea: parseInt(query) });
        }
        const mareas = await this.prisma.marea.findMany({
            where: {
                OR: orConditions,
                activo: true
            },
            include: {
                buque: true,
                estadoActual: true,
                observadorPrincipal: true,
                etapas: {
                    include: {
                        observadores: {
                            include: { observador: true }
                        }
                    }
                }
            },
            take: 10
        });
        return mareas.map((m) => {
            const principalObs = m.observadorPrincipal;
            const obsText = principalObs ? ` • ${principalObs.nombre} ${principalObs.apellido}` : '';
            return {
                id: m.id,
                title: `${m.buque.nombreBuque} (${m.tipoMarea}-${m.nroMarea}-${String(m.anioMarea).slice(-2)})`,
                subtitle: `${m.estadoActual.nombre}${obsText}`,
                type: 'marea'
            };
        });
    }
    async syncStages(tx, mareaId, incomingStages) {
        if (!incomingStages || !Array.isArray(incomingStages))
            return;
        this.validateStagesChronology(incomingStages);
        this.validateStagesIntegrity(incomingStages);
        const incomingIds = incomingStages.filter((s) => s.id).map((s) => s.id);
        await tx.mareaEtapa.deleteMany({
            where: {
                mareaId: mareaId,
                id: { notIn: incomingIds }
            }
        });
        for (let i = 0; i < incomingStages.length; i++) {
            const stg = incomingStages[i];
            const stageData = {
                nroEtapa: i + 1,
                puertoZarpadaId: this.sanitizeUuid(stg.puertoZarpadaId),
                fechaZarpada: stg.fechaZarpada ? date_utils_1.DateUtils.truncateTime(stg.fechaZarpada) : null,
                puertoArriboId: this.sanitizeUuid(stg.puertoArriboId),
                fechaArribo: stg.fechaArribo ? date_utils_1.DateUtils.truncateTime(stg.fechaArribo) : null,
                pesqueriaId: this.sanitizeUuid(stg.pesqueriaId),
                tipoEtapa: stg.tipoEtapa || mareas_constants_1.TipoEtapa.MC,
                observaciones: stg.observaciones || ''
            };
            if (stg.id) {
                await tx.mareaEtapa.update({
                    where: { id: stg.id },
                    data: stageData
                });
            }
            else {
                const newStage = await tx.mareaEtapa.create({
                    data: {
                        mareaId: mareaId,
                        ...stageData,
                        tipoEtapa: mareas_constants_1.TipoEtapa.MC
                    }
                });
            }
        }
    }
    validateStagesChronology(stages) {
        for (let i = 0; i < stages.length; i++) {
            const current = stages[i];
            if (current.fechaZarpada && current.fechaArribo) {
                const zarpada = new Date(current.fechaZarpada);
                const arribo = new Date(current.fechaArribo);
                if (arribo < zarpada) {
                    throw new Error(`Error en Etapa #${i + 1}: La fecha de arribo no puede ser anterior a la de zarpada.`);
                }
            }
            if (i > 0) {
                const previous = stages[i - 1];
                if (current.fechaZarpada && previous.fechaArribo) {
                    const currentZarpada = new Date(current.fechaZarpada);
                    const prevArribo = new Date(previous.fechaArribo);
                    if (currentZarpada < prevArribo) {
                        throw new Error(`Error en Etapa #${i + 1}: La fecha de zarpada no puede ser anterior al arribo de la etapa anterior (#${i}).`);
                    }
                }
            }
        }
    }
    validateStagesIntegrity(stages) {
        for (let i = 0; i < stages.length; i++) {
            const current = stages[i];
            if (!current.fechaZarpada || !current.puertoZarpadaId) {
                throw new common_1.BadRequestException(`Error en Etapa #${i + 1}: La fecha y el puerto de zarpada son obligatorios.`);
            }
            const hasFechaArr = !!current.fechaArribo;
            const hasPuertoArr = !!current.puertoArriboId;
            if (hasFechaArr !== hasPuertoArr) {
                throw new common_1.BadRequestException(`Error en Etapa #${i + 1}: La fecha y el puerto de arribo deben completarse juntos o dejarse ambos vacíos.`);
            }
        }
    }
    sanitizeUuid(val) {
        if (typeof val !== 'string')
            return null;
        const trimmed = val.trim();
        return trimmed === '' ? null : trimmed;
    }
    async executeAction(id, actionKey, user, payload = {}) {
        const marea = await this.prisma.marea.findUnique({
            where: { id },
            include: { estadoActual: true, etapas: { orderBy: { nroEtapa: 'asc' } } }
        });
        if (!marea)
            throw new common_1.NotFoundException('Marea no encontrada');
        if (actionKey === 'EDITAR_ETAPAS') {
            return await this.prisma.$transaction(async (tx) => {
                const fechaInicioObs = payload.fechaInicioObservador ? date_utils_1.DateUtils.truncateTime(payload.fechaInicioObservador) : marea.fechaInicioObservador;
                await tx.marea.update({
                    where: { id },
                    data: {
                        fechaInicioObservador: fechaInicioObs,
                        fechaUltimaActualizacion: new Date()
                    }
                });
                await this.syncStages(tx, id, payload.etapas);
                await tx.mareaMovimiento.create({
                    data: {
                        mareaId: id,
                        fechaHora: new Date(),
                        usuarioId: user.id,
                        tipoEvento: 'EDICION_ESTRUCTURA',
                        detalle: `Edición manual de etapas y fechas de observador.`
                    }
                });
                return this.getMareaContext(id);
            });
        }
        const transicion = await this.prisma.transicionEstado.findFirst({
            where: {
                estadoOrigenId: marea.estadoActualId,
                accion: actionKey,
                activo: true
            }
        });
        if (!transicion) {
            throw new Error(`Acción ${actionKey} no permitida para el estado ${marea.estadoActual.nombre}`);
        }
        return await this.prisma.$transaction(async (tx) => {
            let additionalMareaData = {};
            if (actionKey === 'REGISTRAR_INICIO') {
                const fechaIn = payload.fechaInicioObservador || payload.fechaInicio;
                if (!fechaIn)
                    throw new Error('La fecha de inicio del observador es requerida.');
                additionalMareaData.fechaInicioObservador = date_utils_1.DateUtils.truncateTime(fechaIn);
                const existingStages = await tx.mareaEtapa.count({ where: { mareaId: id } });
                if (existingStages === 0) {
                    const buque = await tx.buque.findUnique({
                        where: { id: marea.buqueId },
                        select: { puertoBaseId: true }
                    });
                    await tx.mareaEtapa.create({
                        data: {
                            mareaId: id,
                            nroEtapa: 1,
                            pesqueriaId: payload.pesqueriaId || marea.pesqueriaId,
                            puertoZarpadaId: payload.puertoId || buque?.puertoBaseId,
                            tipoEtapa: marea.tipoMarea === mareas_constants_1.TipoMarea.CI ? mareas_constants_1.TipoEtapa.CI : mareas_constants_1.TipoEtapa.MC,
                            fechaZarpada: date_utils_1.DateUtils.truncateTime(fechaIn),
                        }
                    });
                }
                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }
            if (actionKey === 'REGISTRAR_ARRIBO') {
                const fechaFin = payload.fechaFinObservador;
                additionalMareaData.fechaFinObservador = fechaFin ? date_utils_1.DateUtils.truncateTime(fechaFin) : null;
                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }
            if (actionKey === 'RECIBIR_DATOS') {
                const fechaRecepcion = payload.fechaRecepcion;
                const fechaInicioObs = payload.fechaInicioObservador ? date_utils_1.DateUtils.truncateTime(payload.fechaInicioObservador) : (marea.fechaInicioObservador ? date_utils_1.DateUtils.truncateTime(marea.fechaInicioObservador) : null);
                const fechaFinObs = payload.fechaFinObservador ? date_utils_1.DateUtils.truncateTime(payload.fechaFinObservador) : (marea.fechaFinObservador ? date_utils_1.DateUtils.truncateTime(marea.fechaFinObservador) : null);
                if (!fechaInicioObs || !fechaFinObs) {
                    throw new Error('Las fechas de inicio y fin del observador son requeridas para la recepción.');
                }
                const stages = marea.etapas;
                if (stages.length > 0) {
                    const firstStageZarpada = stages[0].fechaZarpada ? new Date(stages[0].fechaZarpada) : null;
                    const lastStageArribo = stages[stages.length - 1].fechaArribo ? new Date(stages[stages.length - 1].fechaArribo) : null;
                    if (firstStageZarpada && fechaInicioObs > firstStageZarpada) {
                        throw new Error('La fecha de inicio del observador no puede ser posterior a la zarpada de la primera etapa.');
                    }
                    if (lastStageArribo && fechaFinObs < lastStageArribo) {
                        throw new Error('La fecha de fin del observador no puede ser anterior al arribo de la última etapa.');
                    }
                }
                if (!fechaRecepcion)
                    throw new Error('La fecha de recepción es requerida.');
                const dateRecepcion = new Date(fechaRecepcion);
                if (dateRecepcion < fechaFinObs) {
                    throw new Error('La fecha de recepción no puede ser anterior a la finalización del observador.');
                }
                additionalMareaData.fechaInicioObservador = fechaInicioObs;
                additionalMareaData.fechaFinObservador = fechaFinObs;
            }
            const mareaUpdated = await tx.marea.update({
                where: { id },
                data: {
                    estadoActualId: transicion.estadoDestinoId,
                    fechaUltimaActualizacion: new Date(),
                    ...additionalMareaData
                },
                include: { estadoActual: true }
            });
            let fechaMovimiento = new Date();
            if (actionKey === 'RECIBIR_DATOS' && payload.fechaRecepcion) {
                fechaMovimiento = new Date(payload.fechaRecepcion);
            }
            await tx.mareaMovimiento.create({
                data: {
                    mareaId: id,
                    fechaHora: fechaMovimiento,
                    usuarioId: user.id,
                    tipoEvento: 'CAMBIO_ESTADO',
                    estadoDesdeId: marea.estadoActualId,
                    estadoHastaId: transicion.estadoDestinoId,
                    cantidadMuestrasOtolitos: actionKey === 'RECIBIR_DATOS' ? (payload.cantidadOtolitos || null) : null,
                    detalle: actionKey === 'REGISTRAR_INICIO'
                        ? `Inicio Marea. Obs: ${new Date(additionalMareaData.fechaInicioObservador).toLocaleDateString('es-AR')}`
                        : actionKey === 'REGISTRAR_ARRIBO'
                            ? `Fin Marea. Obs: ${additionalMareaData.fechaFinObservador ? new Date(additionalMareaData.fechaFinObservador).toLocaleDateString('es-AR') : 'Sin fecha definida'}`
                            : actionKey === 'RECIBIR_DATOS'
                                ? `Recepción de datos. Otolitos: ${payload.cantidadOtolitos || 0}`
                                : `Acción: ${transicion.etiqueta}`,
                    comentarios: payload.comentarios,
                    archivos: (actionKey === 'RECIBIR_DATOS' && payload.archivosSnapshot) ? {
                        create: payload.archivosSnapshot.map((a) => ({
                            tipoArchivo: 'DIGITAL_ORIGINAL',
                            rutaArchivo: `received/${id}/${a.name}`,
                            descripcion: `Archivo recibido: ${a.name} (${(a.size / 1024).toFixed(2)} KB)`,
                            formato: a.name.split('.').pop()?.toUpperCase(),
                        }))
                    } : undefined
                }
            });
            return mareaUpdated;
        });
    }
    async create(createMareaDto, user) {
        const { buqueId, anioMarea, nroMarea, pesqueriaId, observadorId, arteId, fechaZarpadaEstimada, fechaInicioObservador, tipoMarea = mareas_constants_1.TipoMarea.MC, diasEstimados } = createMareaDto;
        const existing = await this.prisma.marea.findMany({
            where: {
                anioMarea, nroMarea, tipoMarea
            },
            take: 1
        });
        if (existing.length > 0) {
            throw new Error(`La marea ${tipoMarea}-${nroMarea}-${anioMarea} para este buque ya existe.`);
        }
        const estadoInicial = await this.prisma.estadoMarea.findFirst({
            where: { esInicial: true }
        });
        if (!estadoInicial) {
            throw new Error('No se encontró un estado inicial configurado para las mareas.');
        }
        if (observadorId) {
            const obs = await this.prisma.observador.findUnique({
                where: { id: observadorId },
                select: { conImpedimento: true, motivoImpedimento: true }
            });
            if (obs?.conImpedimento) {
                throw new common_1.BadRequestException(`El observador seleccionado posee un impedimento activo: ${obs.motivoImpedimento || 'Sin motivo especificado'}.`);
            }
        }
        return this.prisma.$transaction(async (tx) => {
            const marea = await tx.marea.create({
                data: {
                    anioMarea,
                    nroMarea,
                    buqueId,
                    pesqueriaId,
                    estadoActualId: estadoInicial.id,
                    tipoMarea,
                    artePrincipalId: arteId,
                    observadorPrincipalId: observadorId,
                    fechaZarpadaEstimada: fechaZarpadaEstimada ? date_utils_1.DateUtils.truncateTime(fechaZarpadaEstimada) : null,
                    fechaInicioObservador: fechaInicioObservador ? date_utils_1.DateUtils.truncateTime(fechaInicioObservador) : null,
                    diasEstimados,
                    observaciones: createMareaDto.observaciones || '',
                }
            });
            await tx.mareaMovimiento.create({
                data: {
                    mareaId: marea.id,
                    fechaHora: new Date(),
                    usuarioId: user.id,
                    tipoEvento: 'CREACION',
                    estadoHastaId: estadoInicial.id,
                    detalle: `Marea creada por ${user.fullName}`
                }
            });
            return marea;
        });
    }
    async sendClaim(dto, user) {
        const { to, body, mareaId, id } = dto;
        const html = body.replace(/\n/g, '<br>');
        await this.mailService.sendMail(to, `Reclamo de Documentación - Marea ${mareaId}`, html);
        await this.prisma.mareaMovimiento.create({
            data: {
                mareaId: id,
                fechaHora: new Date(),
                usuarioId: user.id,
                tipoEvento: 'RECLAMO_ENVIADO',
                detalle: `Reclamo de documentación enviado a ${to}`
            }
        });
        return { success: true };
    }
    async checkAlertRules(year) {
        const [fatigue, criticalDelays, reportDelays] = await Promise.all([
            this.getFatigueAlerts(year),
            this.getCriticalDelays(year),
            this.getReportDelays(year)
        ]);
        for (const f of fatigue) {
            await this.alertsService.create({
                codigoUnico: `FATIGA-${f.id}-${year}`,
                referenciaId: f.id,
                referenciaTipo: 'OBSERVADOR',
                metadata: { observerName: f.name, days: f.days },
                tipo: 'FATIGA',
                titulo: 'Fatiga Crítica Detectada',
                descripcion: `El observador ${f.name} ha navegado ${f.days} días en el año.`,
                estado: alerts_enums_1.AlertaEstado.PENDIENTE,
                prioridad: alerts_enums_1.AlertaPrioridad.ALTA
            });
        }
        for (const d of criticalDelays) {
            await this.alertsService.create({
                codigoUnico: `RETRASO_DATOS-${d.id}`,
                referenciaId: d.id,
                referenciaTipo: 'MAREA',
                metadata: { mareaCode: d.mareaId, vessel: d.vesselName, busDays: d.days, observerName: d.obs },
                tipo: 'RETRASO_DATOS',
                titulo: 'Retraso en Entrega de Datos',
                descripcion: `Marea ${d.mareaId} (${d.vesselName}) - ${d.days} días de demora.`,
                estado: alerts_enums_1.AlertaEstado.PENDIENTE,
                prioridad: alerts_enums_1.AlertaPrioridad.URGENTE
            });
        }
        for (const d of reportDelays) {
            await this.alertsService.create({
                codigoUnico: `RETRASO_INFORME-${d.id}`,
                referenciaId: d.id,
                referenciaTipo: 'MAREA',
                metadata: { mareaCode: d.mareaId, vessel: d.vesselName, busDays: d.days, observerName: d.obs },
                tipo: 'RETRASO_INFORME',
                titulo: 'Informe Demorado',
                descripcion: `Marea ${d.mareaId} (${d.vesselName}) - ${d.days} días desde recepción.`,
                estado: alerts_enums_1.AlertaEstado.PENDIENTE,
                prioridad: alerts_enums_1.AlertaPrioridad.MEDIA
            });
        }
    }
    async expireFollowUps() {
        const now = new Date();
        const vencidas = await this.prisma.alerta.findMany({
            where: {
                estado: 'SEGUIMIENTO',
                fechaVencimiento: {
                    not: null,
                    lte: now
                }
            },
            select: { id: true, fechaVencimiento: true }
        });
        for (const alerta of vencidas) {
            await this.prisma.alerta.update({
                where: { id: alerta.id },
                data: { estado: alerts_enums_1.AlertaEstado.VENCIDA }
            });
            await this.alertsService.logEvent(alerta.id, 'CAMBIO_ESTADO', `Estado: SEGUIMIENTO -> VENCIDA. Notas: Re-check vencido el ${alerta.fechaVencimiento?.toLocaleDateString('es-AR') || 'N/D'}.`);
        }
    }
    async getInbox(year, user) {
        const { operationalYear, mareaYearFilter } = this.buildMareaYearFilter(year);
        await this.checkAlertRules(operationalYear);
        await this.expireFollowUps();
        const whereAlerts = {
            estado: 'PENDIENTE'
        };
        if (user) {
            const isAdmin = user.roles.includes('admin');
            const isCoordinador = user.roles.includes('coordinador');
            if (!isAdmin && !isCoordinador) {
                whereAlerts.OR = [
                    { asignadoId: null },
                    { asignadoId: user.id }
                ];
            }
        }
        const persistentAlertsRaw = await this.prisma.alerta.findMany({
            where: whereAlerts,
            orderBy: {
                prioridad: 'asc',
            },
            include: {
                asignadoA: {
                    select: {
                        fullName: true,
                        avatarUrl: true
                    }
                },
                eventos: {
                    select: { detalle: true },
                    orderBy: { fechaHora: 'desc' },
                    take: 1
                }
            }
        });
        const persistentAlerts = persistentAlertsRaw.map((alerta) => ({
            ...alerta,
            notaGestion: this.extractNotaGestion(alerta.eventos?.[0]?.detalle || '')
        }));
        const allMareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
            },
            include: {
                buque: true,
                observadorPrincipal: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        observadores: {
                            include: { observador: true }
                        }
                    }
                },
                movimientos: {
                    where: { tipoEvento: 'CAMBIO_ESTADO' },
                    orderBy: { fechaHora: 'desc' },
                    take: 1
                }
            },
            orderBy: {
                fechaUltimaActualizacion: 'desc'
            }
        });
        const estadosPendientes = new Set([
            mareas_constants_1.MareaEstado.PENDIENTE_DE_INFORME,
            mareas_constants_1.MareaEstado.ESPERANDO_REVISION,
            mareas_constants_1.MareaEstado.PARA_PROTOCOLIZAR,
            mareas_constants_1.MareaEstado.ESPERANDO_PROTOCOLIZACION
        ]);
        const now = new Date();
        const tasks = allMareas.map((m) => {
            const etapaActual = m.etapas[0];
            const primaryObs = m.observadorPrincipal || etapaActual?.observadores[0]?.observador;
            const mareaIdFormatted = this.formatMareaId(m);
            const observadorNombre = primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : null;
            let tab = null;
            let prioridad = 'media';
            const cod = m.estadoActual.codigo;
            const hasReportDelay = persistentAlerts.some((a) => a.tipo === 'RETRASO_INFORME' &&
                (a.referenciaId === m.id || a.descripcion?.includes(mareaIdFormatted)));
            const lastStateChange = m.movimientos[0]?.fechaHora || m.fechaUltimaActualizacion;
            const daysInState = Math.floor((now.getTime() - new Date(lastStateChange).getTime()) / (1000 * 60 * 60 * 24));
            const isReviewOverdue = cod === mareas_constants_1.MareaEstado.ESPERANDO_REVISION && daysInState > this.rules.PLAZO_CONFECCION_INFORME;
            const isProtocolOverdue = (cod === mareas_constants_1.MareaEstado.PARA_PROTOCOLIZAR || cod === mareas_constants_1.MareaEstado.ESPERANDO_PROTOCOLIZACION) && daysInState > this.rules.PLAZO_PROTOCOLIZACION;
            const isUrgente = hasReportDelay || isReviewOverdue || isProtocolOverdue;
            const esFinal = Boolean(m.estadoActual?.esFinal);
            if (esFinal) {
                tab = 'historial';
                prioridad = 'baja';
            }
            else if (isUrgente) {
                tab = 'urgentes';
                prioridad = 'alta';
            }
            else if (estadosPendientes.has(cod)) {
                tab = 'pendientes';
                prioridad = 'media';
            }
            if (!tab)
                return null;
            return {
                id: m.id,
                buque: m.buque.nombreBuque,
                idMarea: mareaIdFormatted,
                observador: observadorNombre,
                hito: m.estadoActual.nombre,
                estadoDescripcion: m.estadoActual.descripcion,
                descripcion: m.observaciones || `Gestión de marea en estado ${m.estadoActual.nombre}`,
                fecha: m.fechaUltimaActualizacion.toLocaleString('es-AR'),
                prioridad,
                tab,
                actions: []
            };
        }).filter(Boolean);
        return {
            alerts: persistentAlerts,
            tasks
        };
    }
    extractNotaGestion(detalle) {
        if (!detalle)
            return null;
        const marker = 'Notas:';
        if (detalle.includes(marker)) {
            const parts = detalle.split(marker);
            return parts[parts.length - 1].trim() || null;
        }
        return detalle.trim() || null;
    }
    addObserverToMap(map, obs, m, mareaCode, vessel, inicio, fin) {
        if (!map.has(obs.id)) {
            map.set(obs.id, {
                nombre: `${obs.nombre} ${obs.apellido}`,
                mareaGroups: new Map()
            });
        }
        const obsData = map.get(obs.id);
        if (!obsData.mareaGroups.has(m.id)) {
            obsData.mareaGroups.set(m.id, {
                mareaCode,
                nroMarea: m.nroMarea,
                vessel,
                inExecution: this.ESTADOS_NAVEGANDO.includes(m.estadoActual?.codigo || ''),
                stages: []
            });
        }
        const group = obsData.mareaGroups.get(m.id);
        group.stages.push({ inicio, fin });
    }
    async exportToExcel(year, searchQuery, ids) {
        const where = { activo: true };
        if (year) {
            where.anioMarea = year;
        }
        if (ids && ids.length > 0) {
            where.id = { in: ids };
        }
        else if (searchQuery) {
            const query = searchQuery.toLowerCase().trim();
            where.OR = [
                { buque: { nombreBuque: { contains: query, mode: 'insensitive' } } },
                { observadorPrincipal: { nombre: { contains: query, mode: 'insensitive' } } },
                { observadorPrincipal: { apellido: { contains: query, mode: 'insensitive' } } },
                { nroProtocolizacion: !isNaN(Number(query)) ? Number(query) : undefined },
            ].filter(cond => cond.nroProtocolizacion !== undefined || Object.keys(cond).length > 0);
            if (query.includes('/')) {
                const [nro] = query.split('/');
                if (!isNaN(Number(nro))) {
                    where.OR.push({ nroMarea: Number(nro) });
                }
            }
        }
        const mareas = await this.prisma.marea.findMany({
            where,
            include: {
                buque: {
                    include: { tipoFlota: true }
                },
                observadorPrincipal: true,
                pesqueria: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true,
                        puertoZarpada: true,
                        puertoArribo: true
                    }
                }
            },
            orderBy: { nroMarea: 'asc' }
        });
        const workbook = new ExcelJS.Workbook();
        let maxEtapas = 0;
        mareas.forEach(m => {
            if (m.etapas.length > maxEtapas)
                maxEtapas = m.etapas.length;
        });
        const setupSheet = (name, data) => {
            const sheet = workbook.addWorksheet(name);
            const columns = [
                { header: 'DISPOSICION', key: 'disposicion', width: 12 },
                { header: 'OBSERVADOR', key: 'observador', width: 25 },
                { header: 'BUQUE', key: 'buque', width: 25 },
                { header: 'EMPRESA', key: 'empresa', width: 25 },
                { header: 'ZARPADA', key: 'zarpada', width: 15 },
                { header: 'Dias estimados', key: 'dias_estimados', width: 15 },
                { header: 'FLOTA', key: 'flota', width: 20 },
                { header: 'ESPECIE', key: 'especie', width: 20 },
                { header: 'CONTRATO', key: 'contrato', width: 20 },
                { header: 'ESTADO ACTUAL', key: 'estado', width: 20 },
                { header: 'DÍAS TOTALES', key: 'dias_totales', width: 15 },
                { header: 'DÍAS NAVEGADOS', key: 'dias_navegados', width: 15 },
                { header: 'ZONA AUSTRAL', key: 'zona_austral', width: 15 },
                { header: 'etapas', key: 'nro_etapas', width: 10 },
                { header: 'Novedades', key: 'novedades', width: 30 },
            ];
            for (let i = 1; i <= maxEtapas; i++) {
                columns.push({ header: `ETAPA ${i} Zarpada`, key: `etapa_${i}_zarpada`, width: 15 }, { header: `ETAPA ${i} Arribo`, key: `etapa_${i}_arribo`, width: 15 }, { header: `ETAPA ${i} Días`, key: `etapa_${i}_dias`, width: 10 });
            }
            sheet.columns = columns;
            sheet.getRow(1).font = { bold: true };
            sheet.getRow(1).fill = {
                type: 'pattern',
                pattern: 'solid',
                fgColor: { argb: 'FFE0E0E0' }
            };
            let lastGroupValue = null;
            data.forEach(m => {
                const zarpada = m.fechaInicioObservador || m.fechaZarpadaEstimada;
                const especie = m.pesqueria?.nombre || m.etapas[0]?.pesqueria?.nombre || '-';
                if (name === 'Por Especie' && lastGroupValue !== null && lastGroupValue !== especie) {
                    sheet.addRow({});
                }
                lastGroupValue = especie;
                const diasTotales = date_utils_1.DateUtils.calculateInclusiveDays(m.fechaInicioObservador, m.fechaFinObservador || (m.estadoActual.codigo === 'EN_EJECUCION' ? new Date() : null));
                const intervals = m.etapas.map(e => ({
                    start: e.fechaZarpada,
                    end: e.fechaArribo || (m.estadoActual.codigo === 'EN_EJECUCION' ? new Date() : null)
                }));
                const diasNavegados = date_utils_1.DateUtils.calculateUniqueDays(intervals);
                const rowData = {
                    disposicion: m.nroMarea,
                    observador: m.observadorPrincipal ? `${m.observadorPrincipal.apellido}, ${m.observadorPrincipal.nombre}` : 'Sin asignar',
                    buque: m.buque?.nombreBuque || '-',
                    empresa: m.buque?.empresaNombre || '-',
                    zarpada: date_utils_1.DateUtils.formatDate(zarpada),
                    dias_estimados: m.buque?.diasMareaEstimada || '-',
                    flota: m.buque?.tipoFlota?.nombre || '-',
                    especie: especie,
                    contrato: m.observadorPrincipal?.tipoContrato || '-',
                    estado: m.estadoActual?.nombre || '-',
                    dias_totales: diasTotales || '-',
                    dias_navegados: diasNavegados || '-',
                    zona_austral: m.diasZonaAustral && m.diasZonaAustral !== 0 ? m.diasZonaAustral : '',
                    nro_etapas: m.etapas.length,
                    novedades: m.observaciones || '',
                };
                m.etapas.forEach((e, idx) => {
                    const i = idx + 1;
                    rowData[`etapa_${i}_zarpada`] = date_utils_1.DateUtils.formatDate(e.fechaZarpada);
                    rowData[`etapa_${i}_arribo`] = date_utils_1.DateUtils.formatDate(e.fechaArribo);
                    rowData[`etapa_${i}_dias`] = date_utils_1.DateUtils.calculateInclusiveDays(e.fechaZarpada, e.fechaArribo);
                });
                sheet.addRow(rowData);
            });
        };
        setupSheet('Por Disposición', mareas);
        const sortedBySpecie = [...mareas].sort((a, b) => {
            const especieA = a.pesqueria?.nombre || a.etapas[0]?.pesqueria?.nombre || '';
            const especieB = b.pesqueria?.nombre || b.etapas[0]?.pesqueria?.nombre || '';
            if (especieA !== especieB)
                return especieA.localeCompare(especieB);
            return a.nroMarea - b.nroMarea;
        });
        setupSheet('Por Especie', sortedBySpecie);
        return workbook;
    }
};
exports.MareasService = MareasService;
exports.MareasService = MareasService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        mail_service_1.MailService,
        alerts_service_1.AlertsService,
        business_rules_service_1.BusinessRulesService])
], MareasService);
//# sourceMappingURL=mareas.service.js.map