import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { User } from '@prisma/client';
import { AlertaEstado, AlertaPrioridad } from '../alerts/alerts.enums';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';

import { MailService } from '../mail/mail.service';
import { ClaimMareaDto } from './dto/claim-marea.dto';
import { AlertsService } from '../alerts/alerts.service';
import { MareaEstado, TipoEtapa, TipoMarea } from './mareas.constants';
import { DateUtils } from '../common/utils/date.utils';
import { MareaUtils } from '../common/utils/marea.utils';
import * as ExcelJS from 'exceljs';

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

        if (!marea) throw new NotFoundException('Marea no encontrada');
        return {
            ...marea,
            id_marea: MareaUtils.formatCodigo(marea as any),
            etapas: marea.etapas.map(e => ({
                ...e,
                durationDays: MareaUtils.calculateStageDays(e)
            }))
        };
    }

    async update(id: string, updateMareaDto: UpdateMareaDto) {
        const { etapas, artePrincipalId, arteId, pesqueriaId, observadorId, observadorPrincipalId, ...data } = updateMareaDto;

        // Validar impedimentos si cambia el observador principal
        const targetObsId = observadorPrincipalId || observadorId;
        if (targetObsId) {
            const currentMarea = await (this.prisma as any).marea.findUnique({
                where: { id },
                select: { observadorPrincipalId: true }
            });

            if (currentMarea && targetObsId !== (currentMarea as any).observadorPrincipalId) {
                const obs = await this.prisma.observador.findUnique({
                    where: { id: targetObsId },
                    select: { conImpedimento: true, motivoImpedimento: true }
                });
                if (obs?.conImpedimento) {
                    throw new BadRequestException(`No se puede asignar el observador porque posee un impedimento: ${obs.motivoImpedimento || 'Sin motivo'}.`);
                }
            }
        }

        await this.prisma.$transaction(async (tx) => {
            const updateData: any = { ...data };
            if (artePrincipalId) updateData.artePrincipalId = artePrincipalId;
            if (!artePrincipalId && arteId) updateData.artePrincipalId = arteId;
            if (updateData.fechaZarpadaEstimada) updateData.fechaZarpadaEstimada = new Date(updateData.fechaZarpadaEstimada);
            if (updateData.fechaInicioObservador) updateData.fechaInicioObservador = new Date(updateData.fechaInicioObservador);
            if (updateData.fechaFinObservador) updateData.fechaFinObservador = new Date(updateData.fechaFinObservador);
            if (updateData.fechaProtocolizacion) updateData.fechaProtocolizacion = new Date(updateData.fechaProtocolizacion);

            if (observadorPrincipalId) updateData.observadorPrincipalId = observadorPrincipalId;
            if (pesqueriaId) updateData.pesqueriaId = pesqueriaId;

            if (Object.keys(updateData).length > 0) {
                await tx.marea.update({
                    where: { id },
                    data: updateData
                });
            }

            if (etapas && etapas.length > 0) {
                // Eliminar etapas que no vienen en el payload (etapas borradas en el frontend)
                const payloadEtapaIds = etapas.map(e => e.id).filter(id => !!id);
                await tx.mareaEtapa.deleteMany({
                    where: {
                        mareaId: id,
                        id: { notIn: payloadEtapaIds as string[] }
                    }
                });

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

    private formatMareaId(m: { tipoMarea: TipoMarea; nroMarea: number; anioMarea: number }): string {
        return MareaUtils.formatCodigo(m);
    }

    private resolveYear(year?: number): number {
        return year && !Number.isNaN(year) ? year : new Date().getFullYear();
    }

    private buildMareaYearFilter(year?: number) {
        const operationalYear = this.resolveYear(year);
        const startOfYear = new Date(operationalYear, 0, 1);
        const startOfNextYear = new Date(operationalYear + 1, 0, 1);

        // Regla unificada:
        // - incluir no terminadas (no protocolizadas ni canceladas) solo si el anio_marea es igual o 1 anterior al operativo
        // - incluir protocolizadas solo del anio seleccionado
        // - incluir canceladas solo si la fecha de fin del observador cae en el anio seleccionado
        const mareaYearFilter = {
            OR: [
                {
                    estadoActual: { codigo: { notIn: [MareaEstado.PROTOCOLIZADA, MareaEstado.CANCELADA] } },
                    anioMarea: { in: [operationalYear, operationalYear - 1] }
                },
                {
                    estadoActual: { codigo: MareaEstado.PROTOCOLIZADA },
                    OR: [
                        { anioProtocolizacion: operationalYear },
                        { anioMarea: operationalYear }
                    ]
                },
                {
                    estadoActual: { codigo: MareaEstado.CANCELADA },
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

    async getDashboardOperativo(year?: number, showAll?: boolean) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);

        const estadosWhere: any = { activo: true };
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

        const kpisRaw = await Promise.all(
            estados.map(async (e) => ({
                label: e.nombre,
                value: await this.prisma.marea.count({
                    where: { estadoActualId: e.id, activo: true, ...mareaYearFilter }
                }),
                codigo: e.codigo
            }))
        );

        const kpis = kpisRaw.filter(k => showAll || k.value > 0);

        const mareasWhere: any = {
            activo: true,
            ...mareaYearFilter
        };

        if (!showAll) {
            mareasWhere.estadoActual = {
                mostrarEnPanel: true
            };
        }

        const mareas = await (this.prisma as any).marea.findMany({
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

        // Fetch active alerts for these mareas
        const mareaIds = mareas.map(m => m.id);
        const activeAlerts = await this.prisma.alerta.findMany({
            where: {
                referenciaId: { in: mareaIds },
                estado: 'PENDIENTE'
            }
        });

        const items = mareas.map((m: any) => {
            const etapaInicial = m.etapas[0] || null;
            const etapaFinal = m.etapas[m.etapas.length - 1] || null;
            const primaryObs = m.observadorPrincipal || etapaFinal?.observadores[0]?.observador || null;
            const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === m.estadoActualId);

            const actionsAvailable: Record<string, any> = {};
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
                en_tierra: m.estadoActual.codigo === MareaEstado.EN_EJECUCION && etapaFinal?.fechaArribo !== null,
                total_etapas: etapaFinal?.nroEtapa || 1,
                dias_navegados: MareaUtils.calculateNavigatedDays(m),
                alertas: activeAlerts.filter((a: any) => a.referenciaId === m.id),
                actionsAvailable,
                dias_estimados: m.diasEstimados,
                pesquerias_nombres: Array.from(new Set([
                    m.pesqueria?.nombre,
                    ...m.etapas.map(e => e.pesqueria?.nombre)
                ].filter(Boolean) as string[]))
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

        const activeMareas = await (this.prisma as any).marea.findMany({
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
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        pesqueria: true
                    }
                }
            } as any
        });

        const distributionMap = new Map<string, { count: number; vessels: Map<string, { mareaCode: string; status: string }> }>();

        activeMareas.forEach((marea: any) => {
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

        const mareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                ...mareaYearFilter,
                estadoActual: {
                    codigo: MareaEstado.ESPERANDO_ENTREGA
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

        const delays: any[] = [];

        mareas.forEach((m: any) => {
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

    async getReportDelays(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = new Date();
        const limit = this.rules.PLAZO_CONFECCION_INFORME;

        // Estados con orden >= 4 (ENTREGADA_RECIBIDA) y <= 8 (PENDIENTE_DE_INFORME)
        const TARGET_STATES = [
            MareaEstado.ENTREGADA_RECIBIDA,     // Orden 4
            MareaEstado.VERIFICACION_INICIAL,   // Orden 5
            MareaEstado.EN_CORRECCION,          // Orden 6
            MareaEstado.DELEGADA_EXTERNA,       // Orden 7
            MareaEstado.PENDIENTE_DE_INFORME    // Orden 8
        ];

        // Obtener el ID del estado ENTREGADA_RECIBIDA para buscar el movimiento exacto
        const estadoRecepcion = await this.prisma.estadoMarea.findFirst({
            where: { codigo: MareaEstado.ENTREGADA_RECIBIDA }
        });

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
                        tipoEvento: 'RECEPCION_DATOS_ORIGINALES' // Fallback
                    },
                    orderBy: { fechaHora: 'asc' }, // Primer recepción
                    take: 1
                }
            } as any
        });

        const delays: any[] = [];

        mareas.forEach((m: any) => {
            let baseDate: Date | null = null;

            // 1. Prioridad: Fecha del movimiento de cambio a ENTREGADA_RECIBIDA
            if (m.movimientos.length > 0) {
                baseDate = new Date(m.movimientos[0].fechaHora);
            }
            // 2. Fallback: Fecha de arribo de la última etapa conocida
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

    async getCalendarEvents(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const mareas = await (this.prisma as any).marea.findMany({
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
            } as any
        });

        const events: any[] = [];

        mareas.forEach((m: any) => {
            const mareaCode = this.formatMareaId(m);
            const buque = m.buque.nombreBuque;
            const primaryObs = m.observadorPrincipal || m.etapas[0]?.observadores[0]?.observador;
            const obs = primaryObs?.apellido || 'Sin Asignar';
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

    private calculateProgress(m: any): number {
        const estadoCodigo = m.estadoActual?.codigo;

        if (estadoCodigo === MareaEstado.DESIGNADA) {
            return 0;
        }

        const diasTrabajados = MareaUtils.calculateNavigatedDays(m);
        const estimatedDuration = (m.diasEstimados && m.diasEstimados > 0) ? m.diasEstimados : 30;

        let progreso = Math.round((diasTrabajados / estimatedDuration) * 100);

        if (estadoCodigo !== MareaEstado.EN_EJECUCION && progreso < 100 && diasTrabajados > 0) {
            progreso = 100;
        }

        return Math.min(progreso, 100);
    }

    async getFatigueAlerts(year?: number) {
        const operationalYear = this.resolveYear(year);
        const periodStart = new Date(operationalYear, 0, 1, 0, 0, 0, 0);
        const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);

        const etapas = await (this.prisma as any).mareaEtapa.findMany({
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
            } as any
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
                this.addObserverToMap(observerDataMap, o.observador, m, mareaCode, vessel, clampedInicio, clampedFin);
            });

            // Also check Marea.observadorPrincipal
            if (m.observadorPrincipal && m.observadorPrincipal.activo) {
                this.addObserverToMap(observerDataMap, m.observadorPrincipal, m, mareaCode, vessel, clampedInicio, clampedFin);
            }
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

            const alertDays = DateUtils.calculateUniqueDays(
                allTripsIntervals.map(i => ({ start: i.inicio, end: i.fin }))
            );

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
                        navigatedDays: DateUtils.calculateUniqueDays(
                            group.stages.map((s: any) => ({ start: s.inicio, end: s.fin }))
                        )
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

        // Etapas del año operativo y el anterior (para cálculo de días sin navegar)
        const etapas = await (this.prisma as any).mareaEtapa.findMany({
            where: {
                marea: {
                    activo: true,
                    anioMarea: { in: [operationalYear, operationalYear - 1] }
                },
                fechaZarpada: { not: null }
            },
            include: {
                marea: {
                    include: { estadoActual: true, buque: true, observadorPrincipal: true }
                },
                observadores: {
                    include: { observador: true }
                }
            } as any
        });

        const activeNav = new Map<string, { start: Date; vessel: string }>();
        const lastArrivalByObs = new Map<string, { date: Date; mareaCode: string; vessel: string }>();
        const obsConMareas = new Set<string>();

        etapas.forEach((etapa: any) => {
            const inicio = etapa.fechaZarpada ? new Date(etapa.fechaZarpada) : null;
            if (!inicio) return;
            const finRaw = etapa.fechaArribo ? new Date(etapa.fechaArribo) : null;
            const fin = finRaw || now;
            // if (fin < periodStart) return; <-- REMOVED to allow previous year mareas for lastArrival check

            // Helper to process observer logic
            const processObs = (obs: any) => {
                if (!obs?.activo) return;

                obsConMareas.add(obs.id);

                const isNavigating = this.ESTADOS_NAVEGANDO.includes(etapa.marea.estadoActual?.codigo as MareaEstado);
                if (isNavigating) {
                    activeNav.set(obs.id, {
                        start: inicio,
                        vessel: etapa.marea.buque.nombreBuque
                    });
                }

                if (finRaw) {
                    const prev = lastArrivalByObs.get(obs.id);
                    if (!prev || finRaw > prev.date) {
                        lastArrivalByObs.set(obs.id, {
                            date: finRaw,
                            mareaCode: MareaUtils.formatCodigo(etapa.marea),
                            vessel: etapa.marea.buque.nombreBuque
                        });
                    }
                }
            };

            etapa.observadores.forEach((o: any) => processObs(o.observador));
            if (etapa.marea.observadorPrincipal) processObs(etapa.marea.observadorPrincipal);
        });

        const listDescanso: Array<{ id: string; name: string; days: number; lastArrival: string; tipoObservador: string }> = [];
        const listImpedidos: Array<{ id: string; name: string; motivo: string; tipoObservador: string }> = [];
        const listDisponibles: Array<{ id: string; name: string; days: number; lastArrival: string; tipoObservador: string }> = [];
        const listNavegando: Array<{ id: string; name: string; days: number; vessel: string; startDate: string; tipoObservador: string }> = [];
        const topDryCandidates: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode: string; vesselName: string; tipoObservador: string }> = [];

        observadores.forEach((obs) => {
            if (!obs.activo) return;

            const name = `${obs.apellido}, ${obs.nombre}`;
            const lastArrivalData = lastArrivalByObs.get(obs.id);
            const lastArrival = lastArrivalData?.date;

            const daysSince = lastArrival ? Math.floor((now.getTime() - lastArrival.getTime()) / (1000 * 60 * 60 * 24)) : null;

            // Top Dry Check
            if (obsConMareas.has(obs.id) && !activeNav.has(obs.id) && lastArrival && lastArrivalData && daysSince !== null && !obs.conImpedimento) {
                topDryCandidates.push({
                    id: obs.id,
                    name,
                    days: daysSince,
                    lastArrival: lastArrival.toISOString(),
                    mareaCode: lastArrivalData.mareaCode,
                    vesselName: lastArrivalData.vessel,
                    tipoObservador: obs.tipoObservador
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
                        tipoObservador: obs.tipoObservador
                    });
                    break;
                case 'DISPONIBLE':
                    listDisponibles.push({
                        id: obs.id,
                        name,
                        days: daysSince || 0, // 0 if never arrived (new observer?)
                        lastArrival: lastArrival?.toISOString() || '',
                        tipoObservador: obs.tipoObservador
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
            (this.prisma as any).marea.findUnique({
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
                    } as any,
                    movimientos: {
                        orderBy: { fechaHora: 'desc' },
                        take: 5,
                        include: {
                            usuario: true
                        }
                    }
                } as any
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
        ])) as [any, any[], any[]];

        if (!marea) return null;

        const etapaInicial = marea.etapas[0] || null;
        const etapaFinal = marea.etapas[marea.etapas.length - 1] || null;
        const mainObs = marea.observadorPrincipal || null;

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

        const fechaZarpada = etapaInicial?.fechaZarpada || marea.fechaZarpadaEstimada;

        // Cálculo de días consistentes
        const now = new Date();
        const codigoEstado = marea.estadoActual.codigo;
        let diasMarea = 0;
        let diasNavegados = 0;

        if (codigoEstado !== MareaEstado.DESIGNADA && codigoEstado !== MareaEstado.CANCELADA) {
            // 1. Días de Marea: Tiempo del observador (Inclusivo)
            if (marea.fechaInicioObservador) {
                diasMarea = DateUtils.calculateInclusiveDays(marea.fechaInicioObservador, marea.fechaFinObservador);
            }

            // 2. Días Navegados: Suma de etapas únicas usando la utilidad centralizada
            diasNavegados = MareaUtils.calculateNavigatedDays(marea);
        }

        // Cálculo de progreso consistente (reutilizando la lógica centralizada)
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
                    fechaArribo: e.fechaArribo,
                    durationDays: MareaUtils.calculateStageDays(e)
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

        const mareas = await (this.prisma as any).marea.findMany({
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
            } as any,
            take: 10
        });

        return mareas.map((m: any) => {
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
                tipoEtapa: stg.tipoEtapa || TipoEtapa.MC,
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
                        tipoEtapa: TipoEtapa.MC
                    }
                });

                // Do not copy observers automatically. Principal is at Marea level.
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

                // Check and create Stage 1 if it doesn't exist
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
                            pesqueriaId: payload.pesqueriaId || (marea as any).pesqueriaId,
                            puertoZarpadaId: payload.puertoId || buque?.puertoBaseId,
                            tipoEtapa: marea.tipoMarea === TipoMarea.CI ? TipoEtapa.CI : TipoEtapa.MC,
                            fechaZarpada: new Date(fechaIn),
                            // No observer assignment here (implicit in Marea)
                        }
                    });
                }

                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }

            if (actionKey === 'REGISTRAR_ARRIBO') {
                const fechaFin = payload.fechaFinObservador;
                // if (!fechaFin) throw new Error('La fecha de fin del observador es requerida.'); // Eliminado por pedido del usuario

                additionalMareaData.fechaFinObservador = fechaFin ? new Date(fechaFin) : null;

                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }

            if (actionKey === 'RECIBIR_DATOS') {
                const fechaRecepcion = payload.fechaRecepcion;
                const fechaInicioObs = payload.fechaInicioObservador ? new Date(payload.fechaInicioObservador) : (marea.fechaInicioObservador ? new Date(marea.fechaInicioObservador) : null);
                const fechaFinObs = payload.fechaFinObservador ? new Date(payload.fechaFinObservador) : (marea.fechaFinObservador ? new Date(marea.fechaFinObservador) : null);

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

                if (!fechaRecepcion) throw new Error('La fecha de recepción es requerida.');

                const dateRecepcion = new Date(fechaRecepcion);
                if (dateRecepcion < fechaFinObs) {
                    throw new Error('La fecha de recepción no puede ser anterior a la finalización del observador.');
                }

                // Guardar las fechas confirmadas/corregidas en la marea
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

            // Determinar fecha del movimiento
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
                        create: payload.archivosSnapshot.map((a: any) => ({
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

    async create(createMareaDto: CreateMareaDto, user: User) {
        const { buqueId, anioMarea, nroMarea, pesqueriaId, observadorId, arteId, fechaZarpadaEstimada, fechaInicioObservador, tipoMarea = TipoMarea.MC, diasEstimados } = createMareaDto;

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

        // Validate observer impairment
        if (observadorId) {
            const obs = await this.prisma.observador.findUnique({
                where: { id: observadorId },
                select: { conImpedimento: true, motivoImpedimento: true }
            });
            if (obs?.conImpedimento) {
                throw new BadRequestException(`El observador seleccionado posee un impedimento activo: ${obs.motivoImpedimento || 'Sin motivo especificado'}.`);
            }
        }

        return this.prisma.$transaction(async (tx) => {
            const marea = await (tx as any).marea.create({
                data: {
                    anioMarea,
                    nroMarea,
                    buqueId,
                    pesqueriaId,
                    estadoActualId: estadoInicial.id,
                    tipoMarea,
                    artePrincipalId: arteId,
                    observadorPrincipalId: observadorId,
                    fechaZarpadaEstimada: fechaZarpadaEstimada ? new Date(fechaZarpadaEstimada) : null,
                    fechaInicioObservador: fechaInicioObservador ? new Date(fechaInicioObservador) : null,
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

            // NO creamos etapa ficticia. El observador está asignado a la marea.
            // La etapa 1 se creará al Registrar Inicio (Zarpar).

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
                metadata: { mareaCode: d.mareaId, vessel: d.vesselName, busDays: d.days, observerName: d.obs },
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
                metadata: { mareaCode: d.mareaId, vessel: d.vesselName, busDays: d.days, observerName: d.obs },
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

    async getInbox(year?: number, user?: User) {
        const { operationalYear, mareaYearFilter } = this.buildMareaYearFilter(year);

        // Ejecutar motor de reglas (con unicidad garantizada por el servicio)
        await this.checkAlertRules(operationalYear);
        await this.expireFollowUps();

        // 1. Obtener Alertas Persistentes
        // Filtrar las que NO están resueltas ni descartadas (solo activas)
        const whereAlerts: any = {
            estado: 'PENDIENTE'
        };

        // Si hay usuario y NO es admin/coordinador, aplicar filtro de visibilidad
        // (Visible para todos si no tiene responsable, o visible si soy yo el responsable)
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
                prioridad: 'asc', // ALTA < MEDIA ?? No, string sort might be tricky. 'ALTA' < 'BAJA'? 'A' < 'B'. So 'ALTA' comes first.
                // Better order by fechaDetectada desc? Or priority.
                // ALTA comes before MEDIA alphabetically? Yes. A < M.
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
        const persistentAlerts = persistentAlertsRaw.map((alerta: any) => ({
            ...alerta,
            notaGestion: this.extractNotaGestion(alerta.eventos?.[0]?.detalle || '')
        }));

        // 2. Obtener Mareas para las Pestañas
        const allMareas = await (this.prisma as any).marea.findMany({
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
            } as any,
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

        const tasks: any[] = allMareas.map((m: any) => {
            const etapaActual = m.etapas[0];
            const primaryObs = m.observadorPrincipal || etapaActual?.observadores[0]?.observador;
            const mareaIdFormatted = this.formatMareaId(m);
            const observadorNombre = primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido}` : null;

            let tab: string | null = null;
            let prioridad = 'media';

            // Lógica de clasificación por pestañas y prioridad
            const cod = m.estadoActual.codigo;

            const hasReportDelay = persistentAlerts.some((a: any) =>
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

    private addObserverToMap(map: Map<any, any>, obs: any, m: any, mareaCode: string, vessel: string, inicio: Date, fin: Date) {
        if (!map.has(obs.id)) {
            map.set(obs.id, {
                nombre: `${obs.nombre} ${obs.apellido}`,
                mareaGroups: new Map()
            });
        }

        const obsData = map.get(obs.id)!;
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
        group.stages.push({ inicio, fin });
    }

    async exportToExcel(year: number, searchQuery?: string, ids?: string[]) {
        const where: any = { activo: true };
        if (year) {
            where.anioMarea = year;
        }

        if (ids && ids.length > 0) {
            where.id = { in: ids };
        } else if (searchQuery) {
            const query = searchQuery.toLowerCase().trim();
            where.OR = [
                { buque: { nombreBuque: { contains: query, mode: 'insensitive' } } },
                { observadorPrincipal: { nombre: { contains: query, mode: 'insensitive' } } },
                { observadorPrincipal: { apellido: { contains: query, mode: 'insensitive' } } },
                { nroProtocolizacion: !isNaN(Number(query)) ? Number(query) : undefined },
            ].filter(cond => (cond as any).nroProtocolizacion !== undefined || Object.keys(cond).length > 0);

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
            if (m.etapas.length > maxEtapas) maxEtapas = m.etapas.length;
        });

        const setupSheet = (name: string, data: any[]) => {
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
                columns.push(
                    { header: `ETAPA ${i} Zarpada`, key: `etapa_${i}_zarpada`, width: 15 },
                    { header: `ETAPA ${i} Arribo`, key: `etapa_${i}_arribo`, width: 15 },
                    { header: `ETAPA ${i} Días`, key: `etapa_${i}_dias`, width: 10 }
                );
            }

            sheet.columns = columns;
            sheet.getRow(1).font = { bold: true };
            sheet.getRow(1).fill = {
                type: 'pattern',
                pattern: 'solid',
                fgColor: { argb: 'FFE0E0E0' }
            };

            let lastGroupValue: string | null = null;
            data.forEach(m => {
                const zarpada = m.fechaInicioObservador || m.fechaZarpadaEstimada;
                const especie = m.pesqueria?.nombre || m.etapas[0]?.pesqueria?.nombre || '-';

                // Si estamos en la hoja "Por Especie" y el valor cambió, agregamos fila vacía
                if (name === 'Por Especie' && lastGroupValue !== null && lastGroupValue !== especie) {
                    sheet.addRow({});
                }
                lastGroupValue = especie;

                const diasTotales = DateUtils.calculateInclusiveDays(
                    m.fechaInicioObservador,
                    m.fechaFinObservador || (m.estadoActual.codigo === 'EN_EJECUCION' ? new Date() : null)
                );

                const intervals = m.etapas.map(e => ({
                    start: e.fechaZarpada,
                    end: e.fechaArribo || (m.estadoActual.codigo === 'EN_EJECUCION' ? new Date() : null)
                }));
                const diasNavegados = DateUtils.calculateUniqueDays(intervals);

                const rowData: any = {
                    disposicion: m.nroMarea,
                    observador: m.observadorPrincipal ? `${m.observadorPrincipal.apellido}, ${m.observadorPrincipal.nombre}` : 'Sin asignar',
                    buque: m.buque?.nombreBuque || '-',
                    empresa: m.buque?.empresaNombre || '-',
                    zarpada: DateUtils.formatDate(zarpada),
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
                    rowData[`etapa_${i}_zarpada`] = DateUtils.formatDate(e.fechaZarpada);
                    rowData[`etapa_${i}_arribo`] = DateUtils.formatDate(e.fechaArribo);
                    rowData[`etapa_${i}_dias`] = DateUtils.calculateInclusiveDays(e.fechaZarpada, e.fechaArribo);
                });

                sheet.addRow(rowData);
            });
        };

        setupSheet('Por Disposición', mareas);

        const sortedBySpecie = [...mareas].sort((a, b) => {
            const especieA = a.pesqueria?.nombre || a.etapas[0]?.pesqueria?.nombre || '';
            const especieB = b.pesqueria?.nombre || b.etapas[0]?.pesqueria?.nombre || '';
            if (especieA !== especieB) return especieA.localeCompare(especieB);
            return a.nroMarea - b.nroMarea;
        });
        setupSheet('Por Especie', sortedBySpecie);

        return workbook;
    }
}
