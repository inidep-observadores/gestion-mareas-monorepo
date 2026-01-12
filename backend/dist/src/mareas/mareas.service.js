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
const mail_service_1 = require("../mail/mail.service");
const alerts_service_1 = require("../alerts/alerts.service");
const mareas_constants_1 = require("./mareas.constants");
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
                buque: true,
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
        return marea;
    }
    async update(id, updateMareaDto) {
        const { etapas, artePrincipalId, arteId, pesqueriaId, observadorId, ...data } = updateMareaDto;
        await this.prisma.$transaction(async (tx) => {
            const updateData = { ...data };
            if (artePrincipalId)
                updateData.artePrincipalId = artePrincipalId;
            if (!artePrincipalId && arteId)
                updateData.artePrincipalId = arteId;
            if (updateData.fechaZarpadaEstimada)
                updateData.fechaZarpadaEstimada = new Date(updateData.fechaZarpadaEstimada);
            if (updateData.fechaInicioObservador)
                updateData.fechaInicioObservador = new Date(updateData.fechaInicioObservador);
            if (updateData.fechaFinObservador)
                updateData.fechaFinObservador = new Date(updateData.fechaFinObservador);
            if (updateData.fechaProtocolizacion)
                updateData.fechaProtocolizacion = new Date(updateData.fechaProtocolizacion);
            if (Object.keys(updateData).length > 0) {
                await tx.marea.update({
                    where: { id },
                    data: updateData
                });
            }
            if (etapas && etapas.length > 0) {
                for (const etapa of etapas) {
                    const { observadores, id: etapaId, ...rest } = etapa;
                    const etapaData = { ...rest };
                    let currentEtapaId = etapaId;
                    etapaData.puertoZarpadaId = this.sanitizeUuid(etapaData.puertoZarpadaId);
                    etapaData.puertoArriboId = this.sanitizeUuid(etapaData.puertoArriboId);
                    etapaData.pesqueriaId = this.sanitizeUuid(etapaData.pesqueriaId);
                    if (etapaData.fechaZarpada)
                        etapaData.fechaZarpada = new Date(etapaData.fechaZarpada);
                    if (etapaData.fechaArribo)
                        etapaData.fechaArribo = new Date(etapaData.fechaArribo);
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
        const prefix = m.tipoMarea === 'INSTITUCIONAL' || m.tipoMarea === 'CI' ? 'CI' : 'MC';
        const shortYear = String(m.anioMarea).slice(-2);
        return `${prefix}-${m.nroMarea}-${shortYear}`;
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
                { estadoActual: { codigo: { notIn: [mareas_constants_1.MareaEstado.PROTOCOLIZADA, mareas_constants_1.MareaEstado.CANCELADA] } } },
                {
                    estadoActual: { codigo: mareas_constants_1.MareaEstado.PROTOCOLIZADA },
                    anioProtocolizacion: operationalYear
                },
                {
                    estadoActual: { codigo: mareas_constants_1.MareaEstado.CANCELADA },
                    fechaFinObservador: {
                        gte: startOfYear,
                        lt: startOfNextYear
                    }
                }
            ]
        };
        return { operationalYear, mareaYearFilter };
    }
    async getDashboardOperativo(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const [estados, transiciones] = await Promise.all([
            this.prisma.estadoMarea.findMany({
                where: { activo: true, mostrarEnPanel: true },
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
        const kpis = kpisRaw.filter(k => k.value > 0);
        const mareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
                estadoActual: {
                    mostrarEnPanel: true
                }
            },
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
                buque: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        pesqueria: true,
                        observadores: {
                            where: { rol: 'PRINCIPAL' },
                            include: { observador: true },
                            take: 1
                        }
                    }
                }
            },
            orderBy: {
                fechaUltimaActualizacion: 'desc'
            },
            take: 50
        });
        const items = mareas.map((m) => {
            const etapaActual = m.etapas[0] || null;
            const primaryObs = etapaActual?.observadores[0]?.observador || null;
            const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === m.estadoActualId);
            const actionsAvailable = {};
            allowedTransitions.forEach(t => {
                actionsAvailable[t.accion] = {
                    enabled: true,
                    label: t.etiqueta,
                    toState: t.estadoDestinoId
                };
            });
            let progreso = 0;
            const estadoCodigo = m.estadoActual.codigo;
            if (estadoCodigo === mareas_constants_1.MareaEstado.DESIGNADA) {
                progreso = 0;
            }
            else if (estadoCodigo === mareas_constants_1.MareaEstado.EN_EJECUCION) {
                const fechaInicio = etapaActual?.fechaZarpada || m.fechaZarpadaEstimada;
                if (fechaInicio) {
                    const now = new Date();
                    const inicio = new Date(fechaInicio);
                    const diffTime = now.getTime() - inicio.getTime();
                    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24)) + 1;
                    const estimatedDuration = (m.diasEstimados && m.diasEstimados > 0) ? m.diasEstimados : 30;
                    progreso = Math.round((diffDays / estimatedDuration) * 100);
                }
            }
            else {
                const stageIntervals = m.etapas
                    .filter((e) => e.fechaZarpada && e.fechaArribo)
                    .map((e) => ({ inicio: new Date(e.fechaZarpada), fin: new Date(e.fechaArribo) }));
                let diasTrabajados = 0;
                if (m.fechaInicioObservador && m.fechaFinObservador) {
                    diasTrabajados = this.calculateUniqueDays([{
                            inicio: new Date(m.fechaInicioObservador),
                            fin: new Date(m.fechaFinObservador)
                        }]);
                }
                else if (stageIntervals.length > 0) {
                    diasTrabajados = this.calculateUniqueDays(stageIntervals);
                }
                const estimatedDuration = (m.diasEstimados && m.diasEstimados > 0) ? m.diasEstimados : 30;
                if (diasTrabajados > 0) {
                    progreso = Math.round((diasTrabajados / estimatedDuration) * 100);
                    if (progreso < 100)
                        progreso = 100;
                }
            }
            return {
                id: m.id,
                id_marea: this.formatMareaId(m),
                anio_marea: m.anioMarea,
                nro_marea: m.nroMarea,
                buque_nombre: m.buque.nombreBuque,
                puertoBaseId: m.buque.puertoBaseId,
                estado: m.estadoActual.nombre,
                estado_codigo: m.estadoActual.codigo,
                fecha_zarpada: etapaActual?.fechaZarpada || m.fechaZarpadaEstimada,
                puerto: etapaActual?.puertoArribo?.nombre || etapaActual?.puertoZarpada?.nombre || 'N/D',
                observador: primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : 'Sin asignar',
                progreso,
                alertas: [],
                actionsAvailable
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
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        pesqueria: true
                    }
                }
            }
        });
        const distributionMap = new Map();
        activeMareas.forEach((marea) => {
            const label = marea.etapas[0]?.pesqueria?.nombre ?? 'Sin pesquería';
            const vesselName = marea.buque.nombreBuque;
            const mareaCode = `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}`;
            const status = marea.estadoActual?.codigo ?? mareas_constants_1.MareaEstado.EN_EJECUCION;
            if (!distributionMap.has(label)) {
                distributionMap.set(label, { count: 0, vessels: new Map() });
            }
            const item = distributionMap.get(label);
            item.count++;
            item.vessels.set(vesselName, { mareaCode, status });
        });
        const distribution = Array.from(distributionMap.entries())
            .map(([label, data]) => ({
            label,
            count: data.count,
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
    async getCriticalDelays(year) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = new Date();
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
                    const primaryObs = lastStage.observadores[0]?.observador;
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
        const now = new Date();
        const limit = this.rules.PLAZO_CONFECCION_INFORME;
        const TARGET_STATES = [
            mareas_constants_1.MareaEstado.ENTREGADA_RECIBIDA,
            mareas_constants_1.MareaEstado.VERIFICACION_INICIAL,
            mareas_constants_1.MareaEstado.EN_CORRECCION,
            mareas_constants_1.MareaEstado.DELEGADA_EXTERNA,
            mareas_constants_1.MareaEstado.PENDIENTE_DE_INFORME
        ];
        const RECEPCION_EVENT = 'RECEPCION_DATOS_ORIGINALES';
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
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        observadores: {
                            where: { rol: 'PRINCIPAL' },
                            include: { observador: true }
                        }
                    }
                },
                movimientos: {
                    where: {
                        tipoEvento: RECEPCION_EVENT
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
                    const primaryObs = lastStage?.observadores[0]?.observador;
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
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        observadores: {
                            where: { rol: 'PRINCIPAL' },
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
            const mareaCode = `${m.tipoMarea}-${String(m.nroMarea).padStart(3, '0')}`;
            const buque = m.buque.nombreBuque;
            const obs = m.etapas[0]?.observadores[0]?.observador?.apellido || 'Sin Asignar';
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
    calculateUniqueDays(intervals) {
        if (!intervals.length)
            return 0;
        const sorted = [...intervals].sort((a, b) => a.inicio.getTime() - b.inicio.getTime());
        const merged = [];
        for (const interval of sorted) {
            if (!merged.length) {
                merged.push({ ...interval });
                continue;
            }
            const last = merged[merged.length - 1];
            if (interval.inicio.getTime() <= last.fin.getTime()) {
                if (interval.fin.getTime() > last.fin.getTime()) {
                    last.fin = interval.fin;
                }
            }
            else {
                merged.push({ ...interval });
            }
        }
        let totalDays = 0;
        merged.forEach((i) => {
            const diff = Math.floor((i.fin.getTime() - i.inicio.getTime()) / (1000 * 60 * 60 * 24)) + 1;
            totalDays += diff;
        });
        return totalDays;
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
                    include: { buque: true, estadoActual: true }
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
                if (!observerDataMap.has(o.observadorId)) {
                    observerDataMap.set(o.observadorId, {
                        nombre: `${o.observador.nombre} ${o.observador.apellido}`,
                        mareaGroups: new Map()
                    });
                }
                const obsData = observerDataMap.get(o.observadorId);
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
                group.stages.push({ inicio: clampedInicio, fin: clampedFin });
            });
        });
        const alerts = [];
        const THRESHOLD = Math.floor(this.rules.DIAS_NAVEGADOS_ANUALES * this.rules.UMBRAL_FATIGA_ANUAL_PORCENTAJE);
        observerDataMap.forEach((data, id) => {
            const allTripsIntervals = [];
            data.mareaGroups.forEach(g => allTripsIntervals.push(...g.stages));
            const alertDays = this.calculateUniqueDays(allTripsIntervals);
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
                        navigatedDays: this.calculateUniqueDays(group.stages)
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
                marea: { activo: true, ...mareaYearFilter },
                fechaZarpada: { not: null }
            },
            include: {
                marea: {
                    include: { estadoActual: true, buque: true }
                },
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
            if (fin < periodStart)
                return;
            etapa.observadores.forEach((o) => {
                const obs = o.observador;
                if (!obs?.activo)
                    return;
                obsConMareas.add(obs.id);
                const isNavigating = this.ESTADOS_NAVEGANDO.includes(etapa.marea.estadoActual?.codigo);
                if (isNavigating) {
                    activeNav.set(obs.id, {
                        start: inicio,
                        vessel: etapa.marea.buque.nombreBuque
                    });
                }
                if (finRaw) {
                    const prev = lastArrivalByObs.get(obs.id);
                    if (!prev || finRaw > prev) {
                        lastArrivalByObs.set(obs.id, finRaw);
                    }
                }
            });
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
            const lastArrival = lastArrivalByObs.get(obs.id);
            const daysSince = lastArrival ? Math.floor((now.getTime() - lastArrival.getTime()) / (1000 * 60 * 60 * 24)) : null;
            if (obsConMareas.has(obs.id) && !activeNav.has(obs.id) && lastArrival && daysSince !== null) {
                topDryCandidates.push({
                    id: obs.id,
                    name,
                    days: daysSince,
                    lastArrival: lastArrival.toISOString()
                });
            }
            const status = this.getObserverStatus(obs, activeNav.has(obs.id), lastArrival, now);
            switch (status) {
                case 'NAVEGANDO':
                    const navData = activeNav.get(obs.id);
                    const daysNav = navData ? Math.floor((now.getTime() - navData.start.getTime()) / (1000 * 60 * 60 * 24)) : 0;
                    listNavegando.push({
                        id: obs.id,
                        name,
                        vessel: navData?.vessel || 'Desconocido',
                        days: daysNav,
                        startDate: navData?.start?.toISOString() || ''
                    });
                    break;
                case 'IMPEDIDO':
                    listImpedidos.push({
                        id: obs.id,
                        name,
                        motivo: obs.motivoImpedimento || 'Sin motivo especificado'
                    });
                    break;
                case 'DESCANSO':
                    listDescanso.push({
                        id: obs.id,
                        name,
                        days: daysSince || 0,
                        lastArrival: lastArrival?.toISOString() || ''
                    });
                    break;
                case 'DISPONIBLE':
                    listDisponibles.push({
                        id: obs.id,
                        name,
                        days: daysSince || 0,
                        lastArrival: lastArrival?.toISOString() || ''
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
            const daysSince = Math.floor((now.getTime() - lastArrival.getTime()) / (1000 * 60 * 60 * 24));
            if (daysSince < this.rules.DIAS_DESCANSO_POST_MAREA) {
                return 'DESCANSO';
            }
        }
        if (obs.disponible)
            return 'DISPONIBLE';
        return 'OTRO';
    }
    async getMareaContext(id) {
        const [marea, transiciones] = (await Promise.all([
            this.prisma.marea.findUnique({
                where: { id },
                include: {
                    buque: true,
                    estadoActual: true,
                    etapas: {
                        orderBy: { nroEtapa: 'desc' },
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
            })
        ]));
        if (!marea)
            return null;
        const etapaActual = marea.etapas[0] || null;
        const mainObs = etapaActual?.observadores.find((o) => o.rol === 'PRINCIPAL')?.observador || null;
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
        const fechaZarpada = etapaActual?.fechaZarpada || marea.fechaZarpadaEstimada;
        const now = new Date();
        const codigoEstado = marea.estadoActual.codigo;
        let diasMarea = 0;
        let diasNavegados = 0;
        if (codigoEstado !== mareas_constants_1.MareaEstado.DESIGNADA && codigoEstado !== mareas_constants_1.MareaEstado.CANCELADA) {
            const startObs = marea.fechaInicioObservador ? new Date(marea.fechaInicioObservador) : null;
            const endObs = marea.fechaFinObservador ? new Date(marea.fechaFinObservador) : now;
            if (startObs) {
                const diffMs = endObs.getTime() - startObs.getTime();
                diasMarea = Math.floor(diffMs / (1000 * 60 * 60 * 24)) + 1;
                if (diasMarea < 0)
                    diasMarea = 0;
            }
            const stageIntervals = marea.etapas
                .filter((e) => e.fechaZarpada)
                .map((e) => ({
                inicio: new Date(e.fechaZarpada),
                fin: e.fechaArribo ? new Date(e.fechaArribo) : now
            }));
            diasNavegados = this.calculateUniqueDays(stageIntervals);
        }
        return {
            marea: {
                id: marea.id,
                id_marea: this.formatMareaId(marea),
                buque_nombre: marea.buque.nombreBuque,
                puertoBaseId: marea.buque.puertoBaseId,
                estado: marea.estadoActual.nombre,
                estado_codigo: marea.estadoActual.codigo,
                observador: mainObs ? `${mainObs.nombre} ${mainObs.apellido}` : 'No asignado',
                pesqueria: etapaActual?.pesqueria?.nombre || 'General',
                fecha_zarpada: fechaZarpada,
                fecha_zarpada_estimada: marea.fechaZarpadaEstimada,
                fechaInicioObservador: marea.fechaInicioObservador,
                fechaFinObservador: marea.fechaFinObservador,
                dias_marea: diasMarea,
                dias_navegados: diasNavegados,
                alertas: [],
                etapas: marea.etapas.map((e) => ({
                    id: e.id,
                    nroEtapa: e.nroEtapa,
                    pesqueriaId: e.pesqueriaId,
                    puertoZarpadaId: e.puertoZarpadaId,
                    puertoArriboId: e.puertoArriboId,
                    fechaZarpada: e.fechaZarpada,
                    fechaArribo: e.fechaArribo
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
        const orConditions = [
            { buque: { nombreBuque: { contains: query, mode: 'insensitive' } } },
            {
                etapas: {
                    some: {
                        observadores: {
                            some: {
                                observador: {
                                    OR: [
                                        { apellido: { contains: query, mode: 'insensitive' } },
                                        { nombre: { contains: query, mode: 'insensitive' } }
                                    ]
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
        return mareas.map(m => {
            const principalObs = m.etapas[0]?.observadores.find((o) => o.rol === 'PRINCIPAL')?.observador;
            const obsText = principalObs ? ` • ${principalObs.apellido}` : '';
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
                fechaZarpada: stg.fechaZarpada ? new Date(stg.fechaZarpada) : null,
                puertoArriboId: this.sanitizeUuid(stg.puertoArriboId),
                fechaArribo: stg.fechaArribo ? new Date(stg.fechaArribo) : null,
                pesqueriaId: this.sanitizeUuid(stg.pesqueriaId),
                tipoEtapa: stg.tipoEtapa || 'COMERCIAL',
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
                        tipoEtapa: 'COMERCIAL'
                    }
                });
                const firstStage = await tx.mareaEtapa.findFirst({
                    where: { mareaId: mareaId },
                    orderBy: { nroEtapa: 'asc' }
                });
                if (firstStage && firstStage.id !== newStage.id) {
                    const observersToCopy = await tx.mareaEtapaObservador.findMany({
                        where: { etapaId: firstStage.id }
                    });
                    for (const obsRel of observersToCopy) {
                        await tx.mareaEtapaObservador.create({
                            data: {
                                etapaId: newStage.id,
                                observadorId: obsRel.observadorId,
                                rol: obsRel.rol,
                                esDesignado: obsRel.esDesignado
                            }
                        });
                    }
                }
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
                const fechaInicioObs = payload.fechaInicioObservador ? new Date(payload.fechaInicioObservador) : marea.fechaInicioObservador;
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
                additionalMareaData.fechaInicioObservador = new Date(fechaIn);
                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }
            if (actionKey === 'REGISTRAR_ARRIBO') {
                const fechaFin = payload.fechaFinObservador;
                if (!fechaFin)
                    throw new Error('La fecha de fin del observador es requerida.');
                additionalMareaData.fechaFinObservador = new Date(fechaFin);
                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
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
            await tx.mareaMovimiento.create({
                data: {
                    mareaId: id,
                    fechaHora: new Date(),
                    usuarioId: user.id,
                    tipoEvento: 'CAMBIO_ESTADO',
                    estadoDesdeId: marea.estadoActualId,
                    estadoHastaId: transicion.estadoDestinoId,
                    detalle: actionKey === 'REGISTRAR_INICIO'
                        ? `Inicio Marea. Obs: ${new Date(additionalMareaData.fechaInicioObservador).toLocaleDateString('es-AR')}`
                        : actionKey === 'REGISTRAR_ARRIBO'
                            ? `Fin Marea. Obs: ${new Date(additionalMareaData.fechaFinObservador).toLocaleDateString('es-AR')}`
                            : `Acción: ${transicion.etiqueta}`
                }
            });
            return mareaUpdated;
        });
    }
    async create(createMareaDto, user) {
        const { buqueId, anioMarea, nroMarea, pesqueriaId, observadorId, arteId, fechaZarpadaEstimada, tipoMarea = 'MC', diasEstimados } = createMareaDto;
        const existing = await this.prisma.marea.findMany({
            where: {
                anioMarea, nroMarea, buqueId, tipoMarea
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
        return this.prisma.$transaction(async (tx) => {
            const marea = await tx.marea.create({
                data: {
                    anioMarea,
                    nroMarea,
                    buqueId,
                    estadoActualId: estadoInicial.id,
                    tipoMarea,
                    artePrincipalId: arteId,
                    fechaZarpadaEstimada: fechaZarpadaEstimada ? new Date(fechaZarpadaEstimada) : null,
                    diasEstimados,
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
            const buque = await tx.buque.findUnique({
                where: { id: buqueId },
                select: { puertoBaseId: true }
            });
            const etapa = await tx.mareaEtapa.create({
                data: {
                    mareaId: marea.id,
                    nroEtapa: 1,
                    pesqueriaId,
                    puertoZarpadaId: buque?.puertoBaseId || null,
                    tipoEtapa: tipoMarea === 'CI' ? 'INSTITUCIONAL' : 'COMERCIAL',
                    fechaZarpada: fechaZarpadaEstimada ? new Date(fechaZarpadaEstimada) : null,
                }
            });
            if (observadorId) {
                await tx.mareaEtapaObservador.create({
                    data: {
                        etapaId: etapa.id,
                        observadorId,
                        rol: 'PRINCIPAL',
                        esDesignado: true
                    }
                });
            }
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
                estado: 'PENDIENTE',
                prioridad: 'ALTA'
            });
        }
        for (const d of criticalDelays) {
            await this.alertsService.create({
                codigoUnico: `RETRASO_DATOS-${d.id}`,
                referenciaId: d.id,
                referenciaTipo: 'MAREA',
                metadata: { mareaCode: d.mareaId, vessel: d.vesselName, busDays: d.days },
                tipo: 'RETRASO_DATOS',
                titulo: 'Retraso en Entrega de Datos',
                descripcion: `Marea ${d.mareaId} (${d.vesselName}) - ${d.days} días de demora.`,
                estado: 'PENDIENTE',
                prioridad: 'ALTA'
            });
        }
        for (const d of reportDelays) {
            await this.alertsService.create({
                codigoUnico: `RETRASO_INFORME-${d.id}`,
                referenciaId: d.id,
                referenciaTipo: 'MAREA',
                metadata: { mareaCode: d.mareaId, vessel: d.vesselName, busDays: d.days },
                tipo: 'RETRASO_INFORME',
                titulo: 'Informe Demorado',
                descripcion: `Marea ${d.mareaId} (${d.vesselName}) - ${d.days} días desde recepción.`,
                estado: 'PENDIENTE',
                prioridad: 'MEDIA'
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
                data: { estado: 'VENCIDA' }
            });
            await this.alertsService.logEvent(alerta.id, 'CAMBIO_ESTADO', `Estado: SEGUIMIENTO -> VENCIDA. Notas: Re-check vencido el ${alerta.fechaVencimiento?.toLocaleDateString('es-AR') || 'N/D'}.`);
        }
    }
    async getInbox(year) {
        const { operationalYear, mareaYearFilter } = this.buildMareaYearFilter(year);
        await this.checkAlertRules(operationalYear);
        await this.expireFollowUps();
        const persistentAlertsRaw = await this.prisma.alerta.findMany({
            where: {
                estado: { in: ['PENDIENTE', 'SEGUIMIENTO', 'VENCIDA'] }
            },
            orderBy: {
                prioridad: 'asc',
            },
            include: {
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
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        observadores: {
                            where: { rol: 'PRINCIPAL' },
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
        const tasks = allMareas.map(m => {
            const etapaActual = m.etapas[0];
            const primaryObs = etapaActual?.observadores[0]?.observador;
            const mareaIdFormatted = this.formatMareaId(m);
            const observadorNombre = primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : null;
            let tab = null;
            let prioridad = 'media';
            const cod = m.estadoActual.codigo;
            const hasReportDelay = persistentAlerts.some(a => a.tipo === 'RETRASO_INFORME' &&
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