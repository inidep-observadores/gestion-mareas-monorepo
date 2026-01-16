import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { User } from '@prisma/client';
import { AlertaEstado, AlertaPrioridad } from '../alerts/alerts.enums';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';

import { MailService } from '../mail/mail.service';
import { ClaimMareaDto } from './dto/claim-marea.dto';
import { AlertsService } from '../alerts/alerts.service';
import { MareaEstado } from './mareas.constants';

@Injectable()
export class MareasService {
    // Fuentes únicas de verdad para estados operativos
    // Fuentes únicas de verdad para estados operativos
    private readonly ESTADOS_NAVEGANDO = [MareaEstado.EN_EJECUCION];
    private readonly ESTADOS_REVISION = [
        MareaEstado.ENTREGADA_RECIBIDA,
        MareaEstado.VERIFICACION_INICIAL,
        MareaEstado.EN_CORRECCION,
        MareaEstado.PENDIENTE_DE_INFORME,
        MareaEstado.ESPERANDO_REVISION
    ];

    constructor(
        private readonly prisma: PrismaService,
        private readonly mailService: MailService,
        private readonly alertsService: AlertsService,
        private readonly businessRulesService: BusinessRulesService
    ) { }

    private get rules() {
        return this.businessRulesService.getRules();
    }

    async findOne(id: string) {
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

        if (!marea) throw new NotFoundException('Marea no encontrada');
        return marea;
    }

    async update(id: string, updateMareaDto: UpdateMareaDto) {
        const { etapas, artePrincipalId, arteId, pesqueriaId, observadorId, ...data } = updateMareaDto;

        await this.prisma.$transaction(async (tx) => {
            const updateData: any = { ...data };
            if (artePrincipalId) updateData.artePrincipalId = artePrincipalId;
            if (!artePrincipalId && arteId) updateData.artePrincipalId = arteId;
            if (updateData.fechaZarpadaEstimada) updateData.fechaZarpadaEstimada = new Date(updateData.fechaZarpadaEstimada);
            if (updateData.fechaInicioObservador) updateData.fechaInicioObservador = new Date(updateData.fechaInicioObservador);
            if (updateData.fechaFinObservador) updateData.fechaFinObservador = new Date(updateData.fechaFinObservador);
            if (updateData.fechaProtocolizacion) updateData.fechaProtocolizacion = new Date(updateData.fechaProtocolizacion);

            if (Object.keys(updateData).length > 0) {
                await tx.marea.update({
                    where: { id },
                    data: updateData
                });
            }

            if (etapas && etapas.length > 0) {
                this.validateStagesChronology(etapas);
                for (const etapa of etapas) {
                    const { observadores, id: etapaId, ...rest } = etapa;
                    const etapaData: any = { ...rest };
                    let currentEtapaId = etapaId;

                    // Sanitize UUIDs
                    etapaData.puertoZarpadaId = this.sanitizeUuid(etapaData.puertoZarpadaId);
                    etapaData.puertoArriboId = this.sanitizeUuid(etapaData.puertoArriboId);
                    etapaData.pesqueriaId = this.sanitizeUuid(etapaData.pesqueriaId);

                    if (etapaData.fechaZarpada) etapaData.fechaZarpada = new Date(etapaData.fechaZarpada);
                    if (etapaData.fechaArribo) etapaData.fechaArribo = new Date(etapaData.fechaArribo);

                    if (currentEtapaId) {
                        const existing = await tx.mareaEtapa.findFirst({
                            where: { id: currentEtapaId, mareaId: id }
                        });
                        if (!existing) {
                            throw new NotFoundException('Etapa no encontrada para la marea.');
                        }
                        await tx.mareaEtapa.update({
                            where: { id: currentEtapaId },
                            data: etapaData
                        });
                    } else {
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

    private formatMareaId(m: { tipoMarea: string; nroMarea: number; anioMarea: number }): string {
        const prefix = m.tipoMarea === 'INSTITUCIONAL' || m.tipoMarea === 'CI' ? 'CI' : 'MC';
        const shortYear = String(m.anioMarea).slice(-2);
        return `${prefix}-${m.nroMarea}-${shortYear}`;
    }

    private resolveYear(year?: number): number {
        return year && !Number.isNaN(year) ? year : new Date().getFullYear();
    }

    private buildMareaYearFilter(year?: number) {
        const operationalYear = this.resolveYear(year);
        const startOfYear = new Date(operationalYear, 0, 1);
        const startOfNextYear = new Date(operationalYear + 1, 0, 1);

        // Regla unificada:
        // - incluir todas las no protocolizadas, excepto las canceladas
        // - incluir protocolizadas solo del anio seleccionado
        // - incluir canceladas solo si la fecha de fin del observador cae en el anio seleccionado
        const mareaYearFilter = {
            OR: [
                { estadoActual: { codigo: { notIn: [MareaEstado.PROTOCOLIZADA, MareaEstado.CANCELADA] } } },
                {
                    estadoActual: { codigo: MareaEstado.PROTOCOLIZADA },
                    anioProtocolizacion: operationalYear
                },
                {
                    estadoActual: { codigo: MareaEstado.CANCELADA },
                    fechaFinObservador: {
                        gte: startOfYear,
                        lt: startOfNextYear
                    }
                }
            ]
        };

        return { operationalYear, mareaYearFilter };
    }

    async getDashboardOperativo(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const [estados, transiciones] = await Promise.all([
            (this.prisma as any).estadoMarea.findMany({
                where: { activo: true, mostrarEnPanel: true },
                orderBy: { orden: 'asc' }
            }),
            (this.prisma as any).transicionEstado.findMany({
                where: { activo: true }
            })
        ]);

        const kpisRaw = await Promise.all(
            estados.map(async (e) => ({
                label: e.nombre,
                value: await (this.prisma as any).marea.count({
                    where: { estadoActualId: e.id, activo: true, ...mareaYearFilter }
                }),
                codigo: e.codigo
            }))
        );

        const kpis = kpisRaw.filter(k => k.value > 0);

        const mareas = await (this.prisma as any).marea.findMany({
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
            take: 50
        });

        // Fetch active alerts for these mareas
        const mareaIds = mareas.map(m => m.id);
        const activeAlerts = await this.prisma.alerta.findMany({
            where: {
                referenciaId: { in: mareaIds },
                estado: { in: ['PENDIENTE', 'SEGUIMIENTO', 'VENCIDA'] }
            }
        });

        const items = mareas.map((m: any) => {
            const etapaActual = m.etapas[0] || null;
            const primaryObs = etapaActual?.observadores[0]?.observador || null;
            const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === m.estadoActualId);

            const actionsAvailable: Record<string, any> = {};
            allowedTransitions.forEach(t => {
                actionsAvailable[t.accion] = {
                    enabled: true,
                    label: t.etiqueta,
                    toState: t.estadoDestinoId
                };
            });

            // Calculate progress based on state and dates
            let progreso = 0;
            const estadoCodigo = m.estadoActual.codigo;

            if (estadoCodigo === MareaEstado.DESIGNADA) {
                progreso = 0;
            } else if (estadoCodigo === MareaEstado.EN_EJECUCION) {
                // Days from departure date to now. Use actual date if available, else estimated.
                const fechaInicio = etapaActual?.fechaZarpada || m.fechaZarpadaEstimada;

                if (fechaInicio) {
                    const now = new Date();
                    const inicio = new Date(fechaInicio);
                    const diffTime = now.getTime() - inicio.getTime();
                    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 to include both initial and current day

                    // Calculate percentage based on diasEstimados or default SLE (30 days)
                    // Allow > 100% to visualize underestimated mareas
                    const estimatedDuration = (m.diasEstimados && m.diasEstimados > 0) ? m.diasEstimados : 30;
                    progreso = Math.round((diffDays / estimatedDuration) * 100);
                }
            } else {
                const stageIntervals = m.etapas
                    .filter((e: any) => e.fechaZarpada && e.fechaArribo)
                    .map((e: any) => ({ inicio: new Date(e.fechaZarpada), fin: new Date(e.fechaArribo) }));

                let diasTrabajados = 0;

                if (m.fechaInicioObservador && m.fechaFinObservador) {
                    diasTrabajados = this.calculateUniqueDays([{
                        inicio: new Date(m.fechaInicioObservador),
                        fin: new Date(m.fechaFinObservador)
                    }]);
                } else if (stageIntervals.length > 0) {
                    diasTrabajados = this.calculateUniqueDays(stageIntervals);
                }

                const estimatedDuration = (m.diasEstimados && m.diasEstimados > 0) ? m.diasEstimados : 30;

                if (diasTrabajados > 0) {
                    progreso = Math.round((diasTrabajados / estimatedDuration) * 100);
                    // For finished mareas, ensure at least 100% if it finished early
                    if (progreso < 100) progreso = 100;
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
                en_tierra: estadoCodigo === MareaEstado.EN_EJECUCION && (!etapaActual || etapaActual.fechaArribo !== null),
                total_etapas: etapaActual?.nroEtapa || 1,
                alertas: activeAlerts.filter((a: any) => a.referenciaId === m.id),
                actionsAvailable
            };
        });

        return {
            kpis,
            items
        };
    }

    async getDashboardKpis(year?: number) {
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
                        codigo: MareaEstado.DESIGNADA
                    }
                }
            }),
            this.prisma.marea.count({
                where: {
                    activo: true,
                    ...mareaYearFilter,
                    estadoActual: {
                        codigo: MareaEstado.ESPERANDO_PROTOCOLIZACION
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

    async getFleetDistributionByFishery(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        // Use strictly Active states (Designated + Navigating) to match Command Center KPIs
        const activeStates = [MareaEstado.DESIGNADA, ...this.ESTADOS_NAVEGANDO];

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

        const distributionMap = new Map<string, { count: number; vessels: Map<string, { mareaCode: string; status: string }> }>();

        activeMareas.forEach((marea) => {
            const label = marea.etapas[0]?.pesqueria?.nombre ?? 'Sin pesquería';
            const vesselName = marea.buque.nombreBuque;
            const mareaCode = `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}`;
            const status = marea.estadoActual?.codigo ?? MareaEstado.EN_EJECUCION;

            if (!distributionMap.has(label)) {
                distributionMap.set(label, { count: 0, vessels: new Map() });
            }

            const item = distributionMap.get(label)!;
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

    async getCriticalDelays(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = new Date();
        const limit = this.rules.PLAZO_ENTREGA_DATOS;

        const mareas = await (this.prisma as any).marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
                estadoActual: {
                    codigo: MareaEstado.ESPERANDO_ENTREGA
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

        const delays: any[] = [];

        mareas.forEach((m: any) => {
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

    async getReportDelays(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = new Date();
        const limit = this.rules.PLAZO_CONFECCION_INFORME;
        const TARGET_STATES = [
            MareaEstado.ENTREGADA_RECIBIDA,
            MareaEstado.VERIFICACION_INICIAL,
            MareaEstado.EN_CORRECCION,
            MareaEstado.DELEGADA_EXTERNA,
            MareaEstado.PENDIENTE_DE_INFORME
        ];
        const RECEPCION_EVENT = 'RECEPCION_DATOS_ORIGINALES';

        const mareas = await (this.prisma as any).marea.findMany({
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
                    orderBy: { fechaHora: 'asc' }, // Primer recepción
                    take: 1
                }
            }
        });

        const delays: any[] = [];

        mareas.forEach((m: any) => {
            let baseDate: Date | null = null;

            // 1. Try reception event
            if (m.movimientos.length > 0) {
                baseDate = new Date(m.movimientos[0].fechaHora);
            }
            // 2. Fallback to arrival date
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

    async getCalendarEvents(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const mareas = await (this.prisma as any).marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter
            },
            include: {
                buque: true,
                estadoActual: true,
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

        const events: any[] = [];

        mareas.forEach((m: any) => {
            const mareaCode = this.formatMareaId(m);
            const buque = m.buque.nombreBuque;
            const obs = m.etapas[0]?.observadores[0]?.observador?.apellido || 'Sin Asignar';
            const commonProps = {
                mareaId: m.id,
                vesselName: buque,
                description: `Marea ${mareaCode} - Buque ${buque} - Observador ${obs}`
            };

            // 1. Designación (Fecha Inicio Observador)
            if (m.fechaInicioObservador) {
                events.push({
                    id: `des-${m.id}`,
                    title: `📋 Designación ${mareaCode} - ${buque} (${obs})`,
                    start: m.fechaInicioObservador,
                    type: 'designacion',
                    ...commonProps
                });
            }

            m.etapas.forEach((e: any) => {
                // 2. Zarpada
                if (e.fechaZarpada) {
                    events.push({
                        id: `zar-${e.id}`,
                        title: `⛵ Zarpada ${mareaCode} - ${buque}`,
                        start: e.fechaZarpada,
                        type: 'zarpada',
                        ...commonProps
                    });
                }

                // 3. Arribo
                if (e.fechaArribo) {
                    events.push({
                        id: `arr-${e.id}`,
                        title: `🚢 Arribo ${mareaCode} - ${buque}`,
                        start: e.fechaArribo,
                        type: 'arribo',
                        ...commonProps
                    });

                    // 4.6 Alerta (Plazo Entrega Datos: Arribo + 15 dias)
                    // Solo mostrar si la marea está en estado ESPERANDO_ENTREGA
                    if (m.estadoActual?.codigo === MareaEstado.ESPERANDO_ENTREGA) {
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

            // 4. Movimientos (Informes y Validaciones)
            m.movimientos.forEach((mov: any) => {
                if (mov.tipoEvento === 'INFORME_PROTOCOLIZADO') {
                    events.push({
                        id: `inf-${mov.id}`,
                        title: `📄 Informe Protocolizado ${mareaCode}`,
                        start: mov.fechaHora,
                        type: 'informe',
                        ...commonProps
                    });
                } else if (mov.tipoEvento === 'INFORME_APROBADO') {
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

    private calculateUniqueDays(intervals: Array<{ inicio: Date; fin: Date }>): number {
        if (!intervals.length) return 0;

        const sorted = [...intervals].sort((a, b) => a.inicio.getTime() - b.inicio.getTime());
        const merged: Array<{ inicio: Date; fin: Date }> = [];

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
            } else {
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

    async getFatigueAlerts(year?: number) {
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
        const observerDataMap = new Map<string, {
            nombre: string;
            mareaGroups: Map<string, {
                mareaCode: string;
                nroMarea: number;
                vessel: string;
                inExecution: boolean;
                stages: Array<{ inicio: Date; fin: Date }>
            }>
        }>();

        etapas.forEach((etapa: any) => {
            const inicio = etapa.fechaZarpada ? new Date(etapa.fechaZarpada) : null;
            if (!inicio) return;

            const finRaw = etapa.fechaArribo ? new Date(etapa.fechaArribo) : null;
            // Si sigue navegando o el arribo es posterior, contamos hasta ahora y recortamos al fin de anio
            const finCandidate = finRaw || now;
            const finNoFuture = finCandidate > now ? now : finCandidate;
            const fin = finNoFuture > periodEnd ? periodEnd : finNoFuture;

            const clampedInicio = inicio < periodStart ? periodStart : inicio;
            const clampedFin = fin;
            if (clampedFin < periodStart || clampedInicio > clampedFin) return;

            const m = etapa.marea;
            const mareaCode = this.formatMareaId(m);
            const vessel = m.buque.nombreBuque;

            etapa.observadores.forEach((o: any) => {
                if (!o.observador?.activo) return;

                if (!observerDataMap.has(o.observadorId)) {
                    observerDataMap.set(o.observadorId, {
                        nombre: `${o.observador.nombre} ${o.observador.apellido}`,
                        mareaGroups: new Map()
                    });
                }

                const obsData = observerDataMap.get(o.observadorId)!;
                if (!obsData.mareaGroups.has(m.id)) {
                    obsData.mareaGroups.set(m.id, {
                        mareaCode,
                        nroMarea: m.nroMarea,
                        vessel,
                        inExecution: this.ESTADOS_NAVEGANDO.includes(m.estadoActual?.codigo || ''),
                        stages: []
                    });
                }

                const group = obsData.mareaGroups.get(m.id)!;
                group.stages.push({ inicio: clampedInicio, fin: clampedFin });
            });
        });

        const alerts: Array<{
            id: string;
            name: string;
            days: number;
            lastArrival: Date | null;
            trips: Array<{
                mareaCode: string;
                vessel: string;
                departure: Date;
                arrival: Date;
                inExecution: boolean;
                navigatedDays: number
            }>
        }> = [];

        const THRESHOLD = Math.floor(this.rules.DIAS_NAVEGADOS_ANUALES * this.rules.UMBRAL_FATIGA_ANUAL_PORCENTAJE);

        observerDataMap.forEach((data, id) => {
            const allTripsIntervals: Array<{ inicio: Date; fin: Date }> = [];
            data.mareaGroups.forEach(g => allTripsIntervals.push(...g.stages));

            const alertDays = this.calculateUniqueDays(allTripsIntervals);

            if (alertDays > THRESHOLD) {
                const trips: any[] = [];
                let lastArrival: Date | null = null;

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

    async getWorkforceStatus(year?: number) {
        const { operationalYear, mareaYearFilter } = this.buildMareaYearFilter(year);
        const periodStart = new Date(operationalYear, 0, 1, 0, 0, 0, 0);
        const now = new Date();

        // Observadores activos
        const observadores = await this.prisma.observador.findMany({
            where: { activo: true }
        });

        // Etapas del año operativo (incluye las que cruzan año)
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

        const activeNav = new Map<string, { start: Date; vessel: string }>();
        const lastArrivalByObs = new Map<string, Date>();
        const obsConMareas = new Set<string>();

        etapas.forEach((etapa) => {
            const inicio = etapa.fechaZarpada ? new Date(etapa.fechaZarpada) : null;
            if (!inicio) return;
            const finRaw = etapa.fechaArribo ? new Date(etapa.fechaArribo) : null;
            const fin = finRaw || now;
            if (fin < periodStart) return;

            etapa.observadores.forEach((o) => {
                const obs = o.observador;
                if (!obs?.activo) return;

                obsConMareas.add(obs.id);

                const isNavigating = this.ESTADOS_NAVEGANDO.includes(etapa.marea.estadoActual?.codigo as MareaEstado);
                if (isNavigating) {
                    // Si ya existe (ej: múltiples etapas activas?? poco probable), nos quedamos con la mas antigua o la actual?
                    // Asumimos 1 marea activa por obs.
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

        const listDescanso: Array<{ id: string; name: string; days: number; lastArrival: string }> = [];
        const listImpedidos: Array<{ id: string; name: string; motivo: string }> = [];
        const listDisponibles: Array<{ id: string; name: string; days: number; lastArrival: string }> = [];
        const listNavegando: Array<{ id: string; name: string; days: number; vessel: string; startDate: string }> = [];
        const topDryCandidates: Array<{ id: string; name: string; days: number; lastArrival: string }> = [];

        observadores.forEach((obs) => {
            if (!obs.activo) return;

            const name = `${obs.apellido}, ${obs.nombre}`;
            const lastArrival = lastArrivalByObs.get(obs.id);
            const daysSince = lastArrival ? Math.floor((now.getTime() - lastArrival.getTime()) / (1000 * 60 * 60 * 24)) : null;

            // Top Dry Check
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
                        days: daysSince || 0, // 0 if never arrived (new observer?)
                        lastArrival: lastArrival?.toISOString() || ''
                    });
                    break;
            }
        });

        topDryCandidates.sort((a, b) => b.days - a.days);
        const topDry = topDryCandidates.slice(0, 5);

        // Sorting Lists
        // 1-3: Ordenar por días descendente
        listNavegando.sort((a, b) => b.days - a.days);
        listDescanso.sort((a, b) => b.days - a.days);
        listDisponibles.sort((a, b) => b.days - a.days);

        // 4: Ordenar por apellido y nombre
        listImpedidos.sort((a, b) => a.name.localeCompare(b.name));

        return {
            totalActivos: observadores.length,
            navegando: listNavegando.length,
            descanso: listDescanso.length,
            disponibles: listDisponibles.length,
            impedidos: listImpedidos.length,
            licencia: 0,
            topDry,
            // Detailed Lists
            listNavegando,
            listDescanso,
            listDisponibles,
            listImpedidos
        };
    }

    /**
     * Determines the operational status of an observer based on business rules.
     * Priority: NAVIGATING > IMPEDED > RESTING > AVAILABLE
     */
    private getObserverStatus(
        obs: any,
        isNavigating: boolean,
        lastArrival: Date | undefined,
        now: Date
    ): 'NAVEGANDO' | 'IMPEDIDO' | 'DESCANSO' | 'DISPONIBLE' | 'OTRO' {

        if (isNavigating) return 'NAVEGANDO';

        if (obs.conImpedimento) return 'IMPEDIDO';

        if (lastArrival) {
            const daysSince = Math.floor((now.getTime() - lastArrival.getTime()) / (1000 * 60 * 60 * 24));
            if (daysSince < this.rules.DIAS_DESCANSO_POST_MAREA) {
                return 'DESCANSO';
            }
        }

        if (obs.disponible) return 'DISPONIBLE';

        return 'OTRO';
    }

    async getMareaContext(id: string) {
        const [marea, transiciones, activeAlerts] = (await Promise.all([
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
                    } as any,
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
                    estado: { in: ['PENDIENTE', 'SEGUIMIENTO', 'VENCIDA'] }
                }
            })
        ])) as [any, any[], any[]];

        if (!marea) return null;

        const etapaActual = marea.etapas[0] || null;
        const mainObs = etapaActual?.observadores.find((o: any) => o.rol === 'PRINCIPAL')?.observador || null;

        const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === marea.estadoActualId);
        const actions: Record<string, any> = {};

        allowedTransitions.forEach(t => {
            actions[t.accion] = {
                enabled: true,
                label: t.etiqueta,
                toState: t.estadoDestinoId,
                claseBoton: t.claseBoton
            };
        });

        // Acción especial para editar etapas en curso (no cambia estado)
        if (marea.estadoActual.codigo === MareaEstado.EN_EJECUCION) {
            actions['EDITAR_ETAPAS'] = {
                enabled: true,
                label: 'Editar Etapas',
                claseBoton: 'btn-ghost'
            };
        }

        const fechaZarpada = etapaActual?.fechaZarpada || marea.fechaZarpadaEstimada;

        // Cálculo de días consistentes
        const now = new Date();
        const codigoEstado = marea.estadoActual.codigo;
        let diasMarea = 0;
        let diasNavegados = 0;

        if (codigoEstado !== MareaEstado.DESIGNADA && codigoEstado !== MareaEstado.CANCELADA) {
            // 1. Días de Marea: Tiempo del observador (Inclusivo)
            const startObs = marea.fechaInicioObservador ? new Date(marea.fechaInicioObservador) : null;
            const endObs = marea.fechaFinObservador ? new Date(marea.fechaFinObservador) : now;

            if (startObs) {
                const diffMs = endObs.getTime() - startObs.getTime();
                diasMarea = Math.floor(diffMs / (1000 * 60 * 60 * 24)) + 1;
                if (diasMarea < 0) diasMarea = 0;
            }

            // 2. Días Navegados: Suma de etapas únicas
            const stageIntervals = marea.etapas
                .filter((e: any) => e.fechaZarpada)
                .map((e: any) => ({
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
                fecha_fin_observador: marea.fechaFinObservador,
                dias_marea: diasMarea,
                dias_navegados: diasNavegados,
                alertas: activeAlerts,
                etapas: marea.etapas.map((e: any) => ({
                    id: e.id,
                    nroEtapa: e.nroEtapa,
                    pesqueriaId: e.pesqueriaId,
                    puertoZarpadaId: e.puertoZarpadaId,
                    puertoZarpadaNombre: e.puertoZarpada?.nombre,
                    puertoArriboId: e.puertoArriboId,
                    puertoArriboNombre: e.puertoArribo?.nombre,
                    fechaZarpada: e.fechaZarpada,
                    fechaArribo: e.fechaArribo
                }))
            },
            actions,
            lastEvents: marea.movimientos.map((mov: any) => ({
                id: mov.id,
                titulo: mov.detalle || mov.tipoEvento,
                fecha: mov.fechaHora,
                usuario: mov.usuario?.fullName || 'Sistema'
            })),
            etapas: marea.etapas // Include stages for editing
        };
    }

    async search(query: string) {
        if (!query || query.length < 2) return [];

        const isNumeric = !isNaN(Number(query));
        const queryParts = query.split(' ').filter(p => p.length > 0);

        const orConditions: any[] = [
            { buque: { nombreBuque: { contains: query, mode: 'insensitive' } } },
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
            const principalObs = m.etapas[0]?.observadores.find((o: any) => o.rol === 'PRINCIPAL')?.observador;
            const obsText = principalObs ? ` • ${principalObs.nombre} ${principalObs.apellido}` : '';

            return {
                id: m.id,
                title: `${m.buque.nombreBuque} (${m.tipoMarea}-${m.nroMarea}-${String(m.anioMarea).slice(-2)})`,
                subtitle: `${m.estadoActual.nombre}${obsText}`,
                type: 'marea'
            };
        });
    }

    async syncStages(tx: any, mareaId: string, incomingStages: any[]) {
        if (!incomingStages || !Array.isArray(incomingStages)) return;

        // Validar cronología antes de sincronizar
        this.validateStagesChronology(incomingStages);

        const incomingIds = incomingStages.filter((s: any) => s.id).map((s: any) => s.id);

        // 1. Delete removed stages (that belong to this marea)
        await tx.mareaEtapa.deleteMany({
            where: {
                mareaId: mareaId,
                id: { notIn: incomingIds }
            }
        });

        // 2. Upsert stages
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
            } else {
                const newStage = await tx.mareaEtapa.create({
                    data: {
                        mareaId: mareaId,
                        ...stageData,
                        tipoEtapa: 'COMERCIAL'
                    }
                });

                // Copy observers from first stage to new ones
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

    private validateStagesChronology(stages: any[]) {
        for (let i = 0; i < stages.length; i++) {
            const current = stages[i];

            // 1. Internal Chronology: Arrival >= Departure
            if (current.fechaZarpada && current.fechaArribo) {
                const zarpada = new Date(current.fechaZarpada);
                const arribo = new Date(current.fechaArribo);
                if (arribo < zarpada) {
                    throw new Error(`Error en Etapa #${i + 1}: La fecha de arribo no puede ser anterior a la de zarpada.`);
                }
            }

            // 2. Inter-stage Chronology: Departure[i] >= Arrival[i-1]
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

    private sanitizeUuid(val: any): string | null {
        if (typeof val !== 'string') return null;
        const trimmed = val.trim();
        return trimmed === '' ? null : trimmed;
    }

    async executeAction(id: string, actionKey: string, user: User, payload: any = {}) {
        const marea = await this.prisma.marea.findUnique({
            where: { id },
            include: { estadoActual: true, etapas: { orderBy: { nroEtapa: 'asc' } } }
        });

        if (!marea) throw new NotFoundException('Marea no encontrada');

        // Acción especial que NO cambia el estado
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

        // Buscar si existe la transición permitida
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

        // Ejecutar cambio de estado
        return await this.prisma.$transaction(async (tx) => {
            let additionalMareaData: any = {};

            if (actionKey === 'REGISTRAR_INICIO') {
                const fechaIn = payload.fechaInicioObservador || payload.fechaInicio;
                if (!fechaIn) throw new Error('La fecha de inicio del observador es requerida.');

                additionalMareaData.fechaInicioObservador = new Date(fechaIn);

                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }

            if (actionKey === 'REGISTRAR_ARRIBO') {
                const fechaFin = payload.fechaFinObservador;
                if (!fechaFin) throw new Error('La fecha de fin del observador es requerida.');

                additionalMareaData.fechaFinObservador = new Date(fechaFin);

                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }

            if (actionKey === 'RECIBIR_DATOS') {
                const fechaRecepcion = payload.fechaRecepcion;
                if (!fechaRecepcion) throw new Error('La fecha de recepción es requerida.');

                const dateRecepcion = new Date(fechaRecepcion);
                if (marea.fechaFinObservador && dateRecepcion < new Date(marea.fechaFinObservador)) {
                    throw new Error('La fecha de recepción no puede ser anterior a la finalización del observador.');
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
                            : `Acción: ${transicion.etiqueta}`,
                    comentarios: payload.comentarios
                }
            });

            return mareaUpdated;
        });
    }

    async create(createMareaDto: CreateMareaDto, user: User) {
        const { buqueId, anioMarea, nroMarea, pesqueriaId, observadorId, arteId, fechaZarpadaEstimada, tipoMarea = 'MC', diasEstimados } = createMareaDto;

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
                await (tx as any).mareaEtapaObservador.create({
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

    async sendClaim(dto: ClaimMareaDto, user: User) {
        const { to, body, mareaId, id } = dto;
        const html = body.replace(/\n/g, '<br>');

        await this.mailService.sendMail(
            to,
            `Reclamo de Documentación - Marea ${mareaId}`,
            html
        );

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

    private async checkAlertRules(year: number) {
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
                estado: AlertaEstado.PENDIENTE,
                prioridad: AlertaPrioridad.ALTA
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
                estado: AlertaEstado.PENDIENTE,
                prioridad: AlertaPrioridad.URGENTE
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
                estado: AlertaEstado.PENDIENTE,
                prioridad: AlertaPrioridad.MEDIA
            });
        }
    }

    private async expireFollowUps() {
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
                data: { estado: AlertaEstado.VENCIDA }
            });
            await this.alertsService.logEvent(
                alerta.id,
                'CAMBIO_ESTADO',
                `Estado: SEGUIMIENTO -> VENCIDA. Notas: Re-check vencido el ${alerta.fechaVencimiento?.toLocaleDateString('es-AR') || 'N/D'}.`
            );
        }
    }

    async getInbox(year?: number) {
        const { operationalYear, mareaYearFilter } = this.buildMareaYearFilter(year);

        // Ejecutar motor de reglas (con unicidad garantizada por el servicio)
        await this.checkAlertRules(operationalYear);
        await this.expireFollowUps();

        // 1. Obtener Alertas Persistentes
        // Filtrar las que NO están resueltas ni descartadas (solo activas)
        // O incluir las 'EN_SEGUIMIENTO' también.
        // Prisma 'NOT' filter or explicitly IN ['PENDIENTE', 'SEGUIMIENTO', 'VENCIDA']
        const persistentAlertsRaw = await this.prisma.alerta.findMany({
            where: {
                estado: { in: ['PENDIENTE', 'SEGUIMIENTO', 'VENCIDA'] }
            },
            orderBy: {
                prioridad: 'asc', // ALTA < MEDIA ?? No, string sort might be tricky. 'ALTA' < 'BAJA'? 'A' < 'B'. So 'ALTA' comes first.
                // Better order by fechaDetectada desc? Or priority.
                // ALTA comes before MEDIA alphabetically? Yes. A < M.
            },
            include: {
                eventos: {
                    select: { detalle: true },
                    orderBy: { fechaHora: 'desc' },
                    take: 1
                }
            }
        });
        const persistentAlerts = persistentAlertsRaw.map((alerta: any) => ({
            ...alerta,
            notaGestion: this.extractNotaGestion(alerta.eventos?.[0]?.detalle || '')
        }));

        // 2. Obtener Mareas para las Pestañas
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
            MareaEstado.PENDIENTE_DE_INFORME,
            MareaEstado.ESPERANDO_REVISION,
            MareaEstado.PARA_PROTOCOLIZAR,
            MareaEstado.ESPERANDO_PROTOCOLIZACION
        ]);
        const now = new Date();

        const tasks: any[] = allMareas.map(m => {
            const etapaActual = m.etapas[0];
            const primaryObs = etapaActual?.observadores[0]?.observador;
            const mareaIdFormatted = this.formatMareaId(m);
            const observadorNombre = primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : null;

            let tab: string | null = null;
            let prioridad = 'media';

            // Lógica de clasificación por pestañas y prioridad
            const cod = m.estadoActual.codigo;

            const hasReportDelay = persistentAlerts.some(a =>
                a.tipo === 'RETRASO_INFORME' &&
                (a.referenciaId === m.id || a.descripcion?.includes(mareaIdFormatted))
            );

            const lastStateChange = m.movimientos[0]?.fechaHora || m.fechaUltimaActualizacion;
            const daysInState = Math.floor((now.getTime() - new Date(lastStateChange).getTime()) / (1000 * 60 * 60 * 24));

            const isReviewOverdue = cod === MareaEstado.ESPERANDO_REVISION && daysInState > this.rules.PLAZO_CONFECCION_INFORME;
            const isProtocolOverdue = (cod === MareaEstado.PARA_PROTOCOLIZAR || cod === MareaEstado.ESPERANDO_PROTOCOLIZACION) && daysInState > this.rules.PLAZO_PROTOCOLIZACION;
            const isUrgente = hasReportDelay || isReviewOverdue || isProtocolOverdue;

            const esFinal = Boolean(m.estadoActual?.esFinal);

            if (esFinal) {
                tab = 'historial';
                prioridad = 'baja';
            } else if (isUrgente) {
                tab = 'urgentes';
                prioridad = 'alta';
            } else if (estadosPendientes.has(cod as MareaEstado)) {
                tab = 'pendientes';
                prioridad = 'media';
            }

            if (!tab) return null;

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
                actions: [] // Las acciones se resuelven en el frontend según el estado
            };
        }).filter(Boolean);

        return {
            alerts: persistentAlerts,
            tasks
        };
    }

    private extractNotaGestion(detalle: string): string | null {
        if (!detalle) return null;
        const marker = 'Notas:';
        if (detalle.includes(marker)) {
            const parts = detalle.split(marker);
            return parts[parts.length - 1].trim() || null;
        }
        return detalle.trim() || null;
    }

}
