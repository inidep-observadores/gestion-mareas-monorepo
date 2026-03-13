import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
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
import { MareaEtapaMetadata } from './interfaces/marea-etapa-metadata.interface';
import { DateUtils } from '../common/utils/date.utils';
import { MareaUtils } from '../common/utils/marea.utils';
import { ConfigService } from '@nestjs/config';
import * as ExcelJS from 'exceljs';
import { DateTime } from 'luxon';



@Injectable()
export class MareasService {
    private readonly logger = new Logger(MareasService.name);
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
        private readonly businessRulesService: BusinessRulesService,
        private readonly configService: ConfigService
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
            observaciones: marea.observaciones || '',
            id_marea: MareaUtils.formatCodigo(marea as any),
            etapas: marea.etapas.map(e => ({
                ...e,
                durationDays: MareaUtils.calculateStageDays(e)
            }))
        };
    }

    async update(id: string, updateMareaDto: UpdateMareaDto, user?: User) {
        const { etapas, artePrincipalId, arteId, pesqueriaId, observadorId, observadorPrincipalId, ...data } = updateMareaDto;

        // 1. Obtención inicial de marea para validaciones de integridad
        const mareaActual = await this.prisma.marea.findUnique({
            where: { id },
            include: { estadoActual: true }
        });

        if (!mareaActual) throw new NotFoundException('Marea no encontrada');

        // 2. Restricción de edición de datos básicos según estado (Regla de negocio crítica)
        const estadoCodigo = mareaActual.estadoActual.codigo;
        const esPreparatoria = estadoCodigo === MareaEstado.DESIGNADA || estadoCodigo === MareaEstado.A_REASIGNAR;

        const camposProtegidosModificados =
            (updateMareaDto.anioMarea !== undefined && updateMareaDto.anioMarea !== mareaActual.anioMarea) ||
            (updateMareaDto.nroMarea !== undefined && updateMareaDto.nroMarea !== mareaActual.nroMarea) ||
            (updateMareaDto.tipoMarea !== undefined && updateMareaDto.tipoMarea !== mareaActual.tipoMarea) ||
            (updateMareaDto.buqueId !== undefined && updateMareaDto.buqueId !== mareaActual.buqueId) ||
            (observadorPrincipalId !== undefined && observadorPrincipalId !== mareaActual.observadorPrincipalId) ||
            (pesqueriaId !== undefined && pesqueriaId !== mareaActual.pesqueriaId) ||
            (artePrincipalId !== undefined && artePrincipalId !== mareaActual.artePrincipalId);

        if (!esPreparatoria && camposProtegidosModificados) {
            throw new BadRequestException(`No se pueden modificar los datos de identidad, buque, observador, pesquería o arte de pesca una vez que la marea ha salido de los estados de planificación (DESIGNADA/A_REASIGNAR).`);
        }

        // 3. Validar impedimentos si cambia el observador principal
        const targetObsId = observadorPrincipalId || observadorId;
        if (targetObsId && targetObsId !== mareaActual.observadorPrincipalId) {
            const obs = await this.prisma.observador.findUnique({
                where: { id: targetObsId },
                select: { conImpedimento: true, motivoImpedimento: true }
            });
            if (obs?.conImpedimento) {
                throw new BadRequestException(`No se puede asignar el observador porque posee un impedimento: ${obs.motivoImpedimento || 'Sin motivo'}.`);
            }
        }

        await this.prisma.$transaction(async (tx) => {
            // Validaciones cruzadas de negocio

            // 1. Regla de Observador: Si hay un cambio en fechaFinObservador o fechaInicioObservador
            if (updateMareaDto.fechaFinObservador !== undefined || updateMareaDto.fechaInicioObservador !== undefined) {
                const current = await tx.marea.findUnique({
                    where: { id },
                    select: { fechaInicioObservador: true, fechaFinObservador: true }
                });

                const fin = updateMareaDto.fechaFinObservador !== undefined ? updateMareaDto.fechaFinObservador : current?.fechaFinObservador;
                const inicio = updateMareaDto.fechaInicioObservador !== undefined ? updateMareaDto.fechaInicioObservador : current?.fechaInicioObservador;

                // Solo validamos si hay un periodo (fin no es nulo)
                if (fin) {
                    if (!inicio) {
                        throw new BadRequestException('Si se especifica la fecha de fin del observador, la fecha de inicio es obligatoria.');
                    }
                    if (new Date(inicio as any) > new Date(fin as any)) {
                        throw new BadRequestException('La fecha de inicio del observador no puede ser posterior a la de fin.');
                    }

                    // Validación de integridad de estado: No se puede finalizar si está en curso/designada
                    const marea = await tx.marea.findUnique({
                        where: { id },
                        include: { estadoActual: true }
                    });
                    const codigoEstado = marea.estadoActual.codigo;
                    if (codigoEstado === MareaEstado.DESIGNADA || codigoEstado === MareaEstado.EN_EJECUCION) {
                        throw new BadRequestException(`No se puede establecer la fecha de fin del observador mientras la marea esté en estado ${marea.estadoActual.nombre}.`);
                    }

                    // No se puede indicar fecha_fin_observador si hay etapas sin arribo
                    const currentEtapas = updateMareaDto.etapas;
                    if (currentEtapas) {
                        const hasOpenStages = currentEtapas.some(e => !e.fechaArribo);
                        if (hasOpenStages) {
                            throw new BadRequestException('No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.');
                        }
                    } else {
                        const openStagesCount = await tx.mareaEtapa.count({
                            where: {
                                mareaId: id,
                                fechaArribo: null
                            }
                        });
                        if (openStagesCount > 0) {
                            throw new BadRequestException('No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.');
                        }
                    }
                }
            }

            // 2. Regla de Protocolización: Atómica (todos o ninguno)
            // Solo validamos si alguno de los campos de protocolización viene en el DTO (cambio intencional)
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
                    throw new BadRequestException('Los campos de protocolización (número, año y fecha) deben completarse todos juntos o permanecer todos vacíos.');
                }
            }

            const updateData: any = { ...data };

            // Procesamiento de campos con soporte para NULL
            const processDate = (val: any) => {
                if (val === undefined || val === null) return val;
                const d = new Date(val);
                return isNaN(d.getTime()) ? null : d;
            };

            if (artePrincipalId !== undefined) updateData.artePrincipalId = artePrincipalId;
            if (artePrincipalId === undefined && arteId !== undefined) updateData.artePrincipalId = arteId;

            if (updateMareaDto.fechaZarpadaEstimada !== undefined) updateData.fechaZarpadaEstimada = processDate(updateMareaDto.fechaZarpadaEstimada);
            if (updateMareaDto.fechaInicioObservador !== undefined) updateData.fechaInicioObservador = processDate(updateMareaDto.fechaInicioObservador);
            if (updateMareaDto.fechaFinObservador !== undefined) updateData.fechaFinObservador = processDate(updateMareaDto.fechaFinObservador);
            if (updateMareaDto.fechaProtocolizacion !== undefined) updateData.fechaProtocolizacion = processDate(updateMareaDto.fechaProtocolizacion);

            if (observadorPrincipalId !== undefined) updateData.observadorPrincipalId = observadorPrincipalId;
            if (pesqueriaId !== undefined) updateData.pesqueriaId = pesqueriaId;

            // Otros campos que pueden ser nulos
            if (updateMareaDto.diasZonaAustral !== undefined) updateData.diasZonaAustral = updateMareaDto.diasZonaAustral;
            if (updateMareaDto.nroProtocolizacion !== undefined) updateData.nroProtocolizacion = updateMareaDto.nroProtocolizacion;
            if (updateMareaDto.anioProtocolizacion !== undefined) updateData.anioProtocolizacion = updateMareaDto.anioProtocolizacion;
            if (updateMareaDto.diasEstimados !== undefined) updateData.diasEstimados = updateMareaDto.diasEstimados;
            if (updateMareaDto.tipoCalculoZonaAustral !== undefined) updateData.tipoCalculoZonaAustral = updateMareaDto.tipoCalculoZonaAustral;

            if (Object.keys(updateData).length > 0) {
                await tx.marea.update({
                    where: { id },
                    data: updateData
                });
            }

            if (etapas !== undefined) {
                // Eliminar etapas que no vienen en el payload (etapas borradas en el frontend)
                const payloadEtapaIds = etapas.map(e => e.id).filter(id => !!id);
                await tx.mareaEtapa.deleteMany({
                    where: {
                        mareaId: id,
                        id: { notIn: payloadEtapaIds as string[] }
                    }
                });

                this.validateStagesChronology(etapas);
                this.validateStagesIntegrity(etapas);

                // Bloquear creación de nuevas etapas si la última etapa (existente en BD) tiene la intención de cierre
                const [ultimaEtapaEnBd] = await tx.mareaEtapa.findMany({
                    where: { mareaId: id },
                    orderBy: { nroEtapa: 'desc' },
                    take: 1
                });

                if (ultimaEtapaEnBd) {
                    const ultimaEtapaAny: any = ultimaEtapaEnBd;
                    const metadata = (ultimaEtapaAny.metadata as any) as import('./interfaces/marea-etapa-metadata.interface').MareaEtapaMetadata;
                    if (metadata?.opcionesCierre?.finalizarMareaAlArribo === true) {
                        const nuevasEtapas = etapas.filter(e => !e.id);
                        if (nuevasEtapas.length > 0) {
                            throw new BadRequestException('No se pueden agregar nuevas etapas porque la etapa en curso está marcada para finalizar la marea al arribo.');
                        }
                    }

                    // Auditoría de cambio de intención de cierre diferido
                    const ultimaEtapaPayload = etapas[etapas.length - 1];
                    const intencionPrevia = metadata?.opcionesCierre?.finalizarMareaAlArribo || false;
                    const intencionNueva = (ultimaEtapaPayload?.metadata as any)?.opcionesCierre?.finalizarMareaAlArribo || false;

                    if (intencionPrevia !== intencionNueva) {
                        await tx.mareaMovimiento.create({
                            data: {
                                mareaId: id,
                                fechaHora: new Date(),
                                usuarioId: user?.id ?? null,
                                tipoEvento: 'EDICION_ESTRUCTURA',
                                detalle: `${intencionNueva ? 'Activada' : 'Desactivada'} intención de cierre de marea al arribo en etapa #${ultimaEtapaEnBd.nroEtapa} (Guardado diferido).`
                            }
                        });
                    }
                }
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

                        // Asegurar persistencia de metadata
                        if (etapa.metadata !== undefined) {
                            etapaData.metadata = etapa.metadata;
                        }

                        // Proteccion de fuentes: No permitir nulificar si no viene en el payload
                        if (etapa.fuentesZarpada !== undefined && etapa.fuentesZarpada !== null) {
                            etapaData.fuentesZarpada = etapa.fuentesZarpada;
                        }
                        if (etapa.fuentesArribo !== undefined && etapa.fuentesArribo !== null) {
                            etapaData.fuentesArribo = etapa.fuentesArribo;
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
                artePrincipalId: true,
                buque: {
                    select: {
                        id: true,
                        nombreBuque: true,
                        matricula: true,
                        puertoBaseId: true,
                        pesqueriaHabitual: true,
                        tipoFlota: {
                            select: {
                                nombre: true
                            }
                        }
                    }
                },
                observadorPrincipal: true,
                pesqueria: true,
                estadoActual: {
                    select: {
                        id: true,
                        codigo: true,
                        nombre: true,
                        categoria: true
                    }
                },
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    select: {
                        id: true,
                        nroEtapa: true,
                        fechaZarpada: true,
                        fechaArribo: true,
                        observaciones: true,
                        metadata: true,
                        puertoZarpada: { select: { nombre: true } },
                        puertoArribo: { select: { nombre: true } },
                        pesqueria: { select: { nombre: true } },
                        observadores: {
                            select: {
                                rol: true,
                                esDesignado: true,
                                observador: {
                                    select: {
                                        id: true,
                                        nombre: true,
                                        apellido: true
                                    }
                                }
                            }
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
            // Las etapas vienen ordenadas por nroEtapa ASC desde Prisma
            const etapasSorted = [...m.etapas].sort((a: any, b: any) => a.nroEtapa - b.nroEtapa);
            const etapaInicial = etapasSorted[0] || null;
            const etapaFinal = etapasSorted[etapasSorted.length - 1] || null;
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
                flota: m.buque.tipoFlota?.nombre || 'Indeterminada',
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
                intencion_cierre: m.estadoActual.codigo.trim().toUpperCase() === MareaEstado.EN_EJECUCION &&
                    (etapaFinal?.metadata as unknown as MareaEtapaMetadata)?.opcionesCierre?.finalizarMareaAlArribo === true,
                actionsAvailable,
                dias_estimados: m.diasEstimados,
                buqueId: m.buque.id,
                pesqueriaId: m.pesqueria?.id,
                artePrincipalId: (m as any).artePrincipalId, // Tipado seguro para Prisma
                observadorPrincipalId: m.observadorPrincipal?.id,
                fecha_zarpada_estimada_cruda: m.fechaZarpadaEstimada,
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
                        nombreBuque: true,
                        tipoFlota: true
                    }
                },
                pesqueria: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: { pesqueria: true }
                }
            } as any
        });

        const distributionMap = new Map<string, {
            vessels: Map<string, { id: string; name: string; status: string; tipoFlota: any }>;
            stats: Record<string, { count: number, nombre: string }>
        }>();

        activeMareas.forEach((marea: any) => {
            let label = 'Sin pesquería';

            if (marea.etapas && marea.etapas.length > 0) {
                // Priorizar la etapa más reciente (ordenadas por nroEtapa asc)
                const lastStage = marea.etapas[marea.etapas.length - 1];
                label = lastStage.pesqueria?.nombre || 'Sin pesquería';
            } else if (marea.pesqueria?.nombre) {
                label = marea.pesqueria.nombre;
            }

            const vesselName = marea.buque.nombreBuque;
            const mareaCode = `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}`;
            const status = marea.estadoActual?.codigo ?? MareaEstado.EN_EJECUCION;
            const tipoFlota = marea.buque.tipoFlota;
            const fleetCode = tipoFlota?.codigo || 'INDETERMINADO';
            const fleetName = tipoFlota?.nombre || 'Indeterminado';

            if (!distributionMap.has(label)) {
                distributionMap.set(label, { vessels: new Map(), stats: {} });
            }

            const item = distributionMap.get(label)!;
            // Usar mareaCode como llave para permitir múltiples mareas del mismo buque en la distribución
            item.vessels.set(mareaCode, { id: marea.id, name: vesselName, status, tipoFlota });

            if (!item.stats[fleetCode]) {
                item.stats[fleetCode] = { count: 0, nombre: fleetName };
            }
            item.stats[fleetCode].count++;
        });

        const distribution = Array.from(distributionMap.entries())
            .map(([label, data]) => ({
                label,
                count: data.vessels.size,
                stats: data.stats,
                vessels: Array.from(data.vessels.entries())
                    .map(([code, vesselData]) => ({ mareaCode: code, ...vesselData }))
                    .sort((a, b) => a.name.localeCompare(b.name))
            }))
            .sort((a, b) => b.count - a.count);

        return {
            total: activeMareas.length,
            distribution
        };
    }

    async getRecentMovements(days: number) {
        // Asegurar que days sea válido (por defecto 7)
        const daysToLookBack = days || 7;
        const now = DateUtils.getNow(); // getNow() returns start of day
        const limitDate = new Date(now);
        limitDate.setDate(limitDate.getDate() - daysToLookBack);
        // Reset a inicio del dia (ya viene truncado por getNow, pero por seguridad)
        limitDate.setHours(0, 0, 0, 0);

        // Buscar etapas con fecha de zarpada o arribo dentro del rango
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

        // Procesar y aplanar los eventos
        const events: any[] = [];

        for (const etapa of etapas) {
            const marea = etapa.marea;
            const primaryObs = marea.observadorPrincipal || etapa.observadores[0]?.observador;
            const obsName = primaryObs ? `${primaryObs.apellido}, ${primaryObs.nombre} ` : 'Sin Asignar';
            const mareaCode = MareaUtils.formatCodigo(marea as any);
            const buqueName = marea.buque.nombreBuque;

            // Agregar evento ZARPADA si aplica
            if (etapa.fechaZarpada && new Date(etapa.fechaZarpada) >= limitDate) {
                // Intentar extraer la fecha precisa de la metadata (eventDate es el estándar del sistema, fecha es alternativo)
                const metadataZarpada = etapa.fuentesZarpada as any;
                const preciseDateValue = metadataZarpada?.eventDate || metadataZarpada?.fecha;
                const preciseDate = preciseDateValue ? new Date(preciseDateValue) : etapa.fechaZarpada;

                events.push({
                    id: `zar - ${etapa.id} `,
                    buque: buqueName,
                    marea: mareaCode,
                    observador: obsName,
                    etapa: etapa.nroEtapa || 1,
                    tipo: 'ZARPADA',
                    fecha: preciseDate, // Usar la fecha precisa si existe, sino la de la DB
                    fechaDb: etapa.fechaZarpada, // Guardar la original para mostrar en UI si es necesario
                    puerto: (etapa as any).puertoZarpada?.nombre || 'N/D',
                    fuentes: etapa.fuentesZarpada,
                    vesselId: marea.buqueId,
                    mareaId: marea.id
                });
            }

            // Agregar evento ARRIBO si aplica
            if (etapa.fechaArribo && new Date(etapa.fechaArribo) >= limitDate) {
                // Intentar extraer la fecha precisa de la metadata (eventDate es el estándar del sistema, fecha es alternativo)
                const metadataArribo = etapa.fuentesArribo as any;
                const preciseDateValue = metadataArribo?.eventDate || metadataArribo?.fecha;
                const preciseDate = preciseDateValue ? new Date(preciseDateValue) : etapa.fechaArribo;

                events.push({
                    id: `arr - ${etapa.id} `,
                    buque: buqueName,
                    marea: mareaCode,
                    observador: obsName,
                    etapa: etapa.nroEtapa || 1,
                    tipo: 'ARRIBO',
                    fecha: preciseDate, // Usar la fecha precisa si existe, sino la de la DB
                    fechaDb: etapa.fechaArribo, // Guardar la original para mostrar en UI si es necesario
                    puerto: (etapa as any).puertoArribo?.nombre || 'N/D',
                    fuentes: etapa.fuentesArribo,
                    vesselId: marea.buqueId,
                    mareaId: marea.id
                });
            }
        }

        // Ordenar por fecha descendente (más reciente primero)
        const sortedEvents = events.sort((a, b) => new Date(b.fecha).getTime() - new Date(a.fecha).getTime());

        // Obtener la fecha de la última modificación en mareas_etapas
        const lastStageUpdate = await this.prisma.mareaEtapa.findFirst({
            orderBy: { updatedAt: 'desc' },
            select: { updatedAt: true }
        });

        return {
            events: sortedEvents,
            lastUpdate: lastStageUpdate?.updatedAt || null
        };
    }

    async getCriticalDelays(year?: number) {
        const { mareaYearFilter } = this.buildMareaYearFilter(year);
        const now = DateUtils.getNow(true);
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
                        obs: primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido} ` : 'Sin Asignar',
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
        const now = DateUtils.getNow(true);
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
                        obs: primaryObs ? `${primaryObs.nombre} ${primaryObs.apellido} ` : 'Sin Asignar',
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
                description: `Marea ${mareaCode} - Buque ${buque} - Observador ${obs} `
            };

            // 1. Designación (Fecha Inicio Observador)
            if (m.fechaInicioObservador) {
                events.push({
                    id: `des - ${m.id} `,
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
                        id: `zar - ${e.id} `,
                        title: `⛵ Zarpada ${mareaCode} - ${buque} `,
                        start: e.fechaZarpada,
                        type: 'zarpada',
                        ...commonProps
                    });
                }

                // 3. Arribo
                if (e.fechaArribo) {
                    events.push({
                        id: `arr - ${e.id} `,
                        title: `🚢 Arribo ${mareaCode} - ${buque} `,
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
                            id: `ven - ${e.id} `,
                            title: `⚠️ Vencimiento Datos ${mareaCode} `,
                            start: deadline,
                            type: 'alerta',
                            ...commonProps,
                            description: `Vencimiento de plazo para entrega de datos.Marea ${mareaCode}.`
                        });
                    }
                }
            });

            // 4. Movimientos (Informes y Validaciones)
            m.movimientos.forEach((mov: any) => {
                if (mov.tipoEvento === 'INFORME_PROTOCOLIZADO') {
                    events.push({
                        id: `inf - ${mov.id} `,
                        title: `📄 Informe Protocolizado ${mareaCode} `,
                        start: mov.fechaHora,
                        type: 'informe',
                        ...commonProps
                    });
                } else if (mov.tipoEvento === 'INFORME_APROBADO') {
                    events.push({
                        id: `val - ${mov.id} `,
                        title: `✅ Validación ${mareaCode} `,
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
            orderBy: { fechaZarpada: 'asc' },
            include: {
                marea: {
                    include: { estadoActual: true, buque: true, observadorPrincipal: true, pesqueria: true }
                },
                pesqueria: true,
                observadores: {
                    include: { observador: true }
                }
            } as any
        });

        // Obtener mareas en estado DESIGNADA (que no tienen etapas todavía)
        const mareasDesignadas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                estadoActual: { codigo: 'DESIGNADA' }
            },
            select: { observadorPrincipalId: true }
        });

        // Agrupar etapas por marea para contar el total
        const stageCountByMarea = new Map<string, number>();
        etapas.forEach((e: any) => {
            const mareaId = e.mareaId;
            stageCountByMarea.set(mareaId, (stageCountByMarea.get(mareaId) || 0) + 1);
        });

        const activeNav = new Map<string, { start: Date; vessel: string; mareaCode: string; fishery: string; enTierra: boolean; stageCount: number }>();
        const lastArrivalByObs = new Map<string, { date: Date; mareaCode: string; vessel: string; fishery: string }>();
        const designadosActivosByObs = new Set<string>();
        const obsConMareas = new Set<string>();

        // Poblar designados desde la consulta directa de mareas (estado DESIGNADA)
        mareasDesignadas.forEach(m => {
            if (m.observadorPrincipalId) designadosActivosByObs.add(m.observadorPrincipalId);
        });

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
                        vessel: etapa.marea.buque.nombreBuque,
                        mareaCode: MareaUtils.formatCodigo(etapa.marea),
                        fishery: etapa.pesqueria?.nombre || etapa.marea.pesqueria?.nombre || 'Desconocida',
                        enTierra: finRaw !== null,
                        stageCount: stageCountByMarea.get(etapa.mareaId) || 1
                    });
                }

                if (finRaw) {
                    const prev = lastArrivalByObs.get(obs.id);
                    if (!prev || finRaw > prev.date) {
                        lastArrivalByObs.set(obs.id, {
                            date: finRaw,
                            mareaCode: MareaUtils.formatCodigo(etapa.marea),
                            vessel: etapa.marea.buque.nombreBuque,
                            fishery: etapa.pesqueria?.nombre || etapa.marea.pesqueria?.nombre || 'Desconocida'
                        });
                    }
                }

                // Las designaciones ahora se manejan mediante la consulta directa a Marea al inicio
                // No obstante, si una etapa existe y es DESIGNADA, también la marcamos (por seguridad)
                if (etapa.marea.estadoActual?.codigo === 'DESIGNADA') {
                    designadosActivosByObs.add(obs.id);
                }
            };

            etapa.observadores.forEach((o: any) => processObs(o.observador));
            if (etapa.marea.observadorPrincipal) processObs(etapa.marea.observadorPrincipal);
        });

        const listDescanso: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode: string; vesselName: string; fishery: string; tipoObservador: string; sexo: string; eventual: boolean; tieneDesignacionActiva: boolean }> = [];
        const listImpedidos: Array<{ id: string; name: string; motivo: string; tipoObservador: string; sexo: string; eventual: boolean; tieneDesignacionActiva: boolean }> = [];
        const listDisponibles: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode: string; vesselName: string; fishery: string; tipoObservador: string; sexo: string; eventual: boolean; tieneDesignacionActiva: boolean }> = [];
        const listNavegando: Array<{ id: string; name: string; days: number; vessel: string; mareaCode: string; fishery: string; enTierra: boolean; startDate: string; tipoObservador: string, stageCount: number; sexo: string; eventual: boolean; tieneDesignacionActiva: boolean }> = [];
        const topDryCandidates: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode: string; vesselName: string; fishery: string; tipoObservador: string; sexo: string; eventual: boolean; tieneDesignacionActiva: boolean }> = [];

        observadores.forEach((obs) => {
            if (!obs.activo) return;

            const name = `${obs.apellido}, ${obs.nombre} `;
            const lastArrivalData = lastArrivalByObs.get(obs.id);
            const lastArrival = lastArrivalData?.date;

            const daysSince = lastArrival ? DateUtils.calculateInclusiveDays(lastArrival, now) - 1 : null;

            const status = this.getObserverStatus(obs, activeNav.has(obs.id), lastArrival, now);

            // Top Dry Check: Solo listar observadores genuinamente DISPONIBLES y de tipo OBSERVADOR
            if (obsConMareas.has(obs.id) && status === 'DISPONIBLE' && lastArrival && lastArrivalData && daysSince !== null && obs.tipoObservador === 'OBSERVADOR') {
                topDryCandidates.push({
                    id: obs.id,
                    name,
                    days: daysSince,
                    lastArrival: lastArrival.toISOString(),
                    mareaCode: lastArrivalData.mareaCode,
                    vesselName: lastArrivalData.vessel,
                    fishery: lastArrivalData.fishery,
                    tipoObservador: obs.tipoObservador,
                    sexo: obs.sexo,
                    eventual: obs.eventual,
                    tieneDesignacionActiva: designadosActivosByObs.has(obs.id)
                });
            }

            switch (status) {
                case 'NAVEGANDO':
                    const navData = activeNav.get(obs.id);
                    const daysNav = navData ? DateUtils.calculateInclusiveDays(navData.start, now) : 0;
                    listNavegando.push({
                        id: obs.id,
                        name,
                        vessel: navData?.vessel || 'Desconocido',
                        mareaCode: navData?.mareaCode || '',
                        fishery: navData?.fishery || '',
                        enTierra: navData?.enTierra || false,
                        days: daysNav,
                        startDate: navData?.start?.toISOString() || '',
                        tipoObservador: obs.tipoObservador,
                        stageCount: navData?.stageCount || 1,
                        sexo: obs.sexo,
                        eventual: obs.eventual,
                        tieneDesignacionActiva: designadosActivosByObs.has(obs.id)
                    });
                    break;
                case 'IMPEDIDO':
                    listImpedidos.push({
                        id: obs.id,
                        name,
                        motivo: obs.motivoImpedimento || 'Sin motivo especificado',
                        tipoObservador: obs.tipoObservador,
                        sexo: obs.sexo,
                        eventual: obs.eventual,
                        tieneDesignacionActiva: designadosActivosByObs.has(obs.id)
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
                        tipoObservador: obs.tipoObservador,
                        sexo: obs.sexo,
                        eventual: obs.eventual,
                        tieneDesignacionActiva: designadosActivosByObs.has(obs.id)
                    });
                    break;
                case 'DISPONIBLE':
                    listDisponibles.push({
                        id: obs.id,
                        name,
                        days: daysSince || 0, // 0 if never arrived (new observer?)
                        lastArrival: lastArrival?.toISOString() || '',
                        mareaCode: lastArrivalData?.mareaCode || '',
                        vesselName: lastArrivalData?.vessel || '',
                        fishery: lastArrivalData?.fishery || '',
                        tipoObservador: obs.tipoObservador,
                        sexo: obs.sexo,
                        eventual: obs.eventual,
                        tieneDesignacionActiva: designadosActivosByObs.has(obs.id)
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

        // Ejecutar chequeo de alertas optimizado (throttled)
        await this.runThrottledAlertCheck(operationalYear);

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
            const daysSince = DateUtils.calculateInclusiveDays(lastArrival, now) - 1;
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
                    buque: {
                        include: { puertoBase: true }
                    },
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
                where: { activo: true },
                include: { estadoDestino: true }
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

        // Acción especial para editar etapas en curso (no cambia estado) - AHORA PRIMERA
        if (marea.estadoActual.codigo === MareaEstado.EN_EJECUCION) {
            actions['EDITAR_ETAPAS'] = {
                enabled: true,
                label: 'Editar Etapas',
                claseBoton: 'btn-ghost'
            };
        }

        allowedTransitions.forEach(t => {
            actions[t.accion] = {
                enabled: true,
                label: t.etiqueta,
                toState: t.estadoDestinoId,
                toStateName: (t as any).estadoDestino?.nombre || 'Nuevo Estado',
                requiresNotes: (t as any).requiereObs || false,
                claseBoton: t.claseBoton
            };
        });


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
                puertoBaseNombre: marea.buque.puertoBase?.nombre || 'N/D',
                puertoBaseCodigo: marea.buque.puertoBase?.codigoExterno,
                estado: marea.estadoActual.nombre,
                estado_codigo: marea.estadoActual.codigo,
                observador: mainObs ? `${mainObs.nombre} ${mainObs.apellido} ` : 'No asignado',
                pesqueria: etapaFinal?.pesqueria?.nombre || 'General',
                fecha_zarpada: fechaZarpada,
                fecha_zarpada_estimada: marea.fechaZarpadaEstimada,
                fecha_inicio_observador: marea.fechaInicioObservador,
                fecha_fin_observador: marea.fechaFinObservador,
                dias_marea: diasMarea,
                dias_navegados: diasNavegados,
                progreso: progreso,
                id_pesqueria: marea.pesqueriaId,
                observaciones: marea.observaciones || '',
                alertas: activeAlerts,
                etapas: marea.etapas.map((e: any) => ({
                    id: e.id,
                    nroEtapa: e.nroEtapa,
                    pesqueriaId: e.pesqueriaId,
                    puertoZarpadaId: e.puertoZarpadaId,
                    puertoZarpadaNombre: e.puertoZarpada?.nombre,
                    puertoZarpadaCodigo: e.puertoZarpada?.codigoExterno,
                    puertoArriboId: e.puertoArriboId,
                    puertoArriboNombre: e.puertoArribo?.nombre,
                    puertoArriboCodigo: e.puertoArribo?.codigoExterno,
                    fechaZarpada: e.fechaZarpada,
                    fechaArribo: e.fechaArribo,
                    durationDays: MareaUtils.calculateStageDays(e),
                    metadata: e.metadata
                }))
            },
            actions,
            lastEvents: marea.movimientos.map((mov: any) => ({
                id: mov.id,
                titulo: mov.detalle || mov.tipoEvento,
                fecha: mov.fechaHora,
                usuario: mov.usuario?.fullName || 'Sistema',
                comentarios: mov.comentarios
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
            const obsText = principalObs ? ` • ${principalObs.nombre} ${principalObs.apellido} ` : '';

            return {
                id: m.id,
                title: `${m.buque.nombreBuque} (${m.tipoMarea} -${m.nroMarea} -${String(m.anioMarea).slice(-2)})`,
                subtitle: `${m.estadoActual.nombre}${obsText} `,
                type: 'marea'
            };
        });
    }

    async syncStages(tx: any, mareaId: string, incomingStages: any[]) {
        if (!incomingStages || !Array.isArray(incomingStages)) return;

        console.log('--- SYNC STAGES START ---');
        console.log('Incoming Stages in syncStages:', JSON.stringify(incomingStages, null, 2));

        // Validar cronología e integridad antes de sincronizar
        this.validateStagesChronology(incomingStages);
        this.validateStagesIntegrity(incomingStages);

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
                fuentesZarpada: stg.fuentesZarpada || null,
                fuentesArribo: stg.fuentesArribo || null,
                observaciones: stg.observaciones || '',
                metadata: stg.metadata ?? undefined
            };

            if (stg.id) {
                // Para actualizaciones, solo incluimos fuentes si vienen en el payload
                // de lo contrario Prisma ignorará el campo si es undefined
                const updateData: any = {
                    ...stageData,
                    fuentesZarpada: stg.fuentesZarpada ?? undefined,
                    fuentesArribo: stg.fuentesArribo ?? undefined
                };

                await tx.mareaEtapa.update({
                    where: { id: stg.id },
                    data: updateData
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
                        throw new Error(`Error en Etapa #${i + 1}: La fecha de zarpada no puede ser anterior al arribo de la etapa anterior(#${i}).`);
                    }
                }
            }
        }
    }

    private validateStagesIntegrity(stages: any[]) {
        for (let i = 0; i < stages.length; i++) {
            const current = stages[i];

            // 1. Zarpada: Fecha y Puerto Obligatorios
            if (!current.fechaZarpada || !current.puertoZarpadaId) {
                throw new BadRequestException(`Error en Etapa #${i + 1}: La fecha y el puerto de zarpada son obligatorios.`);
            }

            // 2. Arribo: Atómico (Ambos o Ninguno)
            const hasFechaArr = !!current.fechaArribo;
            const hasPuertoArr = !!current.puertoArriboId;

            if (hasFechaArr !== hasPuertoArr) {
                throw new BadRequestException(`Error en Etapa #${i + 1}: La fecha y el puerto de arribo deben completarse juntos o dejarse ambos vacíos.`);
            }
        }
    }

    private sanitizeUuid(val: any): string | null {
        if (typeof val !== 'string') return null;
        const trimmed = val.trim();
        return trimmed === '' ? null : trimmed;
    }

    /**
     * Evalúa si una marea debe darse por finalizada al registrarse un arribo.
     * Evalúa designaciones pendientes o intenciones manuales de cierre.
     */
    private async evaluarCierreAlArribar(mareaId: string, etapaId: string): Promise<'FORZADO_POR_DESIGNACION' | 'RECOMENDADO_POR_INTENCION' | 'NINGUNO'> {
        const [marea, etapa] = await Promise.all([
            this.prisma.marea.findUnique({
                where: { id: mareaId },
                include: {
                    buque: true,
                    estadoActual: true
                }
            }),
            this.prisma.mareaEtapa.findUnique({
                where: { id: etapaId }
            })
        ]);

        if (!marea || !etapa) return 'NINGUNO';

        // 1. Condición por designación activa (FORZADO)
        const tieneDesignacion = await this.prisma.marea.findFirst({
            where: {
                buqueId: marea.buqueId,
                activo: true,
                estadoActual: { codigo: MareaEstado.DESIGNADA }
            }
        });

        if (tieneDesignacion) {
            return 'FORZADO_POR_DESIGNACION';
        }

        // 2. Condición por metadata de la etapa (RECOMENDADO)
        const etapaAny: any = etapa;
        const metadata = etapaAny.metadata as import('./interfaces/marea-etapa-metadata.interface').MareaEtapaMetadata;
        if (metadata?.opcionesCierre?.finalizarMareaAlArribo === true) {
            return 'RECOMENDADO_POR_INTENCION';
        }

        return 'NINGUNO';
    }

    /**
     * Permite activar o desactivar la intención manual de cierre de marea para la etapa actual
     */
    async setIntencionCierreMarea(mareaId: string, etapaId: string, activar: boolean, user: User) {
        return await this.prisma.$transaction(async (tx) => {
            const marea = await tx.marea.findUnique({
                where: { id: mareaId },
                include: {
                    estadoActual: true,
                    etapas: { orderBy: { nroEtapa: 'desc' }, take: 1 }
                }
            });

            if (!marea) throw new NotFoundException('Marea no encontrada');

            // 1. Validar que la marea esté en ejecución
            if (!this.ESTADOS_NAVEGANDO.includes(marea.estadoActual.codigo as any)) {
                throw new BadRequestException(`No se puede modificar la intención de cierre.La marea no está en ejecución(Estado actual: ${marea.estadoActual.nombre}).`);
            }

            // 2. Validar que la etapa sea la última etapa de la marea
            const ultimaEtapa = marea.etapas[0];
            if (!ultimaEtapa || ultimaEtapa.id !== etapaId) {
                throw new BadRequestException('La intención de cierre solo puede modificarse sobre la etapa en curso (última etapa).');
            }

            // 3. Validar que la etapa esté activa (sin arribo)
            if (ultimaEtapa.fechaArribo) {
                throw new BadRequestException('No se puede modificar la intención de cierre porque la etapa ya cuenta con fecha de arribo.');
            }

            // 4. Conflicto con designaciones: advertir/bloquear si ya hay designación y se intenta activar
            if (activar) {
                const tieneDesignacion = await tx.marea.findFirst({
                    where: {
                        buqueId: marea.buqueId,
                        activo: true,
                        estadoActual: { codigo: MareaEstado.DESIGNADA }
                    }
                });

                if (tieneDesignacion) {
                    throw new BadRequestException('No es necesario activar esta opción. Ya existe una designación en curso para este buque que forzará el cierre de la marea al arribo.');
                }
            }

            const ultimaEtapaAny: any = ultimaEtapa;
            const currentMetadata = (ultimaEtapaAny.metadata as import('./interfaces/marea-etapa-metadata.interface').MareaEtapaMetadata) || {};

            let nuevaMetadata: import('./interfaces/marea-etapa-metadata.interface').MareaEtapaMetadata;

            if (activar) {
                nuevaMetadata = {
                    ...currentMetadata,
                    opcionesCierre: {
                        finalizarMareaAlArribo: true,
                        marcadoPorUsuarioId: user.id,
                        fechaMarca: new Date()
                    }
                };
            } else {
                nuevaMetadata = { ...currentMetadata };
                delete nuevaMetadata.opcionesCierre;
            }

            await tx.mareaEtapa.update({
                where: { id: etapaId },
                data: { metadata: nuevaMetadata } as any
            });

            await tx.mareaMovimiento.create({
                data: {
                    mareaId: mareaId,
                    fechaHora: new Date(),
                    usuarioId: user.id,
                    tipoEvento: 'EDICION_ESTRUCTURA',
                    detalle: activar
                        ? 'Se activó bandera de cierre de marea para el próximo arribo.'
                        : 'Se desactivó bandera de cierre de marea anticipado.'
                }
            });

            return { success: true, metadata: nuevaMetadata };
        });
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
                        tipoEvento: payload.tipoEvento || 'EDICION_ESTRUCTURA',
                        detalle: payload.motivoDetalle || `Edición manual de etapas y fechas de observador.`
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
            throw new Error(`Acción ${actionKey} no permitida para el estado ${marea.estadoActual.nombre} `);
        }

        // Ejecutar cambio de estado
        return await this.prisma.$transaction(async (tx) => {
            console.log('--- MAREAS UPDATE START ---');
            console.log('Payload Update Etapas RAW:', JSON.stringify(payload.etapas, null, 2));

            // Validate chronology first
            if (payload.etapas) {
                this.validateStagesChronology(payload.etapas);
            }

            let additionalMareaData: any = {};

            if (actionKey === 'REGISTRAR_INICIO') {
                const fechaIn = payload.fechaInicioObservador || payload.fechaInicio;
                if (!fechaIn) throw new Error('La fecha de inicio del observador es requerida.');

                additionalMareaData.fechaInicioObservador = DateUtils.parseToAppZone(fechaIn);

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

            if (actionKey === 'REGISTRAR_FINALIZACION') {
                const fechaIn = payload.fechaInicioObservador;
                const fechaFin = payload.fechaFinObservador;

                if (fechaIn) {
                    additionalMareaData.fechaInicioObservador = DateUtils.parseToAppZone(fechaIn);
                }
                additionalMareaData.fechaFinObservador = fechaFin ? DateUtils.parseToAppZone(fechaFin) : null;

                if (payload.etapas) {
                    await this.syncStages(tx, id, payload.etapas);
                }
            }

            if (actionKey === 'DESHACER_INICIO') {
                additionalMareaData.fechaInicioObservador = null;
                const stage1 = await tx.mareaEtapa.findFirst({
                    where: { mareaId: id, nroEtapa: 1 },
                    include: { lances: { take: 1 } }
                });

                if (stage1) {
                    if (stage1.lances && stage1.lances.length > 0) {
                        throw new BadRequestException('No se puede deshacer el inicio porque la marea ya tiene datos técnicos registrados (lances).');
                    }
                    await tx.mareaEtapaObservador.deleteMany({ where: { etapaId: stage1.id } });
                    await tx.mareaEtapa.delete({ where: { id: stage1.id } });
                }
            }

            if (actionKey === 'RECIBIR_DATOS') {
                const fechaRecepcion = payload.fechaRecepcion;
                const fechaInicioObs = payload.fechaInicioObservador ? DateUtils.parseToAppZone(payload.fechaInicioObservador) : (marea.fechaInicioObservador ? new Date(marea.fechaInicioObservador) : null);
                const fechaFinObs = payload.fechaFinObservador ? DateUtils.parseToAppZone(payload.fechaFinObservador) : (marea.fechaFinObservador ? new Date(marea.fechaFinObservador) : null);

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

            // Evaluación de fin de Marea por arribo automático a puerto en etapa "Final"
            let destinoEstadoId = transicion.estadoDestinoId;

            // Si la acción proviene de un avance o arribo de etapa mediante un flujo general (ej: CERRAR_ETAPA)
            // Evaluamos si esta etapa desencadena el fin de marea
            // Asumimos que si estamos en un estado de navegación y hay una etapa con arribo, evaluamos:
            if (this.ESTADOS_NAVEGANDO.includes(marea.estadoActual.codigo as any) && payload.etapas) {
                const ultimaEtapaRecibida = payload.etapas[payload.etapas.length - 1];
                if (ultimaEtapaRecibida?.fechaArribo && ultimaEtapaRecibida.id) {
                    const motivoCierre = await this.evaluarCierreAlArribar(id, ultimaEtapaRecibida.id);

                    if (motivoCierre === 'FORZADO_POR_DESIGNACION') {
                        const estadoFinalizacion = await tx.estadoMarea.findFirst({
                            where: { codigo: MareaEstado.ESPERANDO_ENTREGA }
                        });
                        if (estadoFinalizacion) {
                            destinoEstadoId = estadoFinalizacion.id;
                            actionKey = 'FINALIZAR_POR_ARRIBO'; // Sobrescribimos lógicamente la acción para el historial
                        }
                    } else if (motivoCierre === 'RECOMENDADO_POR_INTENCION' && actionKey !== 'FINALIZAR_POR_ARRIBO') {
                        // TODO: Si en el futuro se desea restaurar el comportamiento de solo alerta, 
                        // modificar aquí para usar alertsService.create y no cambiar el estado.
                        // Actualmente, RECOMENDADO_POR_INTENCION opera igual que FORZADO_POR_DESIGNACION.
                        const estadoFinalizacion = await tx.estadoMarea.findFirst({
                            where: { codigo: MareaEstado.ESPERANDO_ENTREGA }
                        });
                        if (estadoFinalizacion) {
                            destinoEstadoId = estadoFinalizacion.id;
                            actionKey = 'FINALIZAR_POR_ARRIBO'; // Sobrescribimos lógicamente la acción para el historial
                        }
                    }
                }
            }

            const mareaUpdated = await tx.marea.update({
                where: { id },
                data: {
                    estadoActualId: destinoEstadoId,
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
                    tipoEvento: payload.tipoEvento || 'CAMBIO_ESTADO',
                    estadoDesdeId: marea.estadoActualId,
                    estadoHastaId: destinoEstadoId,
                    cantidadMuestrasOtolitos: actionKey === 'RECIBIR_DATOS' ? (payload.cantidadOtolitos || null) : null,
                    detalle: payload.motivoDetalle || (actionKey === 'REGISTRAR_INICIO'
                        ? `Inicio Marea. Obs: ${new Date(additionalMareaData.fechaInicioObservador).toLocaleDateString('es-AR')}`
                        : actionKey === 'REGISTRAR_FINALIZACION'
                            ? `Fin Marea. Obs: ${additionalMareaData.fechaFinObservador ? new Date(additionalMareaData.fechaFinObservador).toLocaleDateString('es-AR') : 'Sin fecha definida'}`
                            : actionKey === 'FINALIZAR_POR_ARRIBO'
                                ? `Marea finalizada automáticamente por arribo a puerto (designación activa).`
                                : actionKey === 'RECIBIR_DATOS'
                                    ? `Recepción de datos. Otolitos: ${payload.cantidadOtolitos || 0}`
                                    : `Acción: ${transicion.etiqueta}`),
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

    async getNextMareaNumber(anio: number, tipo: TipoMarea): Promise<number> {
        const result = await this.prisma.marea.aggregate({
            where: {
                anioMarea: anio,
                tipoMarea: tipo,
                activo: true
            },
            _max: {
                nroMarea: true
            }
        });

        const max = result._max.nroMarea || 0;
        return max + 1;
    }

    async checkVesselAvailability(buqueId: string) {
        const marea = await this.prisma.marea.findFirst({
            where: {
                buqueId,
                activo: true,
                estadoActual: { codigo: MareaEstado.DESIGNADA }
            },
            select: {
                nroMarea: true, anioMarea: true, tipoMarea: true
            }
        });
        return {
            available: !marea,
            marea: marea ? MareaUtils.formatCodigo(marea as any) : null
        };
    }

    async checkObserverAvailability(observadorId: string) {
        const marea = await this.prisma.marea.findFirst({
            where: {
                observadorPrincipalId: observadorId,
                activo: true,
                estadoActual: { codigo: MareaEstado.DESIGNADA }
            },
            select: {
                nroMarea: true, anioMarea: true, tipoMarea: true, estadoActual: true
            }
        });
        return {
            available: !marea,
            marea: marea ? MareaUtils.formatCodigo(marea as any) : null,
            estado: marea?.estadoActual?.nombre
        };
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
            throw new BadRequestException(`La marea ${tipoMarea}-${nroMarea}-${anioMarea} ya está registrada en el sistema.`);
        }

        const estadoInicial = await this.prisma.estadoMarea.findFirst({
            where: { esInicial: true }
        });

        if (!estadoInicial) {
            throw new BadRequestException('No se encontró un estado inicial configurado para las mareas.');
        }

        // Validate year coherence
        if (fechaZarpadaEstimada) {
            const year = new Date(fechaZarpadaEstimada).getUTCFullYear();
            if (year !== anioMarea && year !== anioMarea + 1) {
                throw new BadRequestException(`El año de zarpada estimada (${year}) debe coincidir con el año de la marea (${anioMarea}) o el siguiente.`);
            }
        }
        if (fechaInicioObservador) {
            const year = new Date(fechaInicioObservador).getUTCFullYear();
            if (year !== anioMarea && year !== anioMarea + 1) {
                throw new BadRequestException(`El año de inicio del observador (${year}) debe coincidir con el año de la marea (${anioMarea}) o el siguiente.`);
            }
        }

        // Validate vessel availability (not already designated)
        const vesselOccupied = await this.prisma.marea.findFirst({
            where: {
                buqueId,
                activo: true,
                estadoActual: { codigo: MareaEstado.DESIGNADA }
            }
        });
        if (vesselOccupied) {
            throw new BadRequestException(`El buque ya tiene una marea designada (${MareaUtils.formatCodigo(vesselOccupied as any)}).`);
        }

        // Validate observer availability (not already designated or executing)
        if (observadorId) {
            const observerOccupied = await this.prisma.marea.findFirst({
                where: {
                    observadorPrincipalId: observadorId,
                    activo: true,
                    estadoActual: { codigo: MareaEstado.DESIGNADA }
                },
                include: { estadoActual: true }
            });
            if (observerOccupied) {
                throw new BadRequestException(`El observador ya tiene una marea designada para el futuro (${MareaUtils.formatCodigo(observerOccupied as any)}).`);
            }

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

    private async runThrottledAlertCheck(year: number) {
        const key = 'LAST_ALERT_CHECK';
        const intervalMinutes = parseInt(this.configService.get('ALERT_CHECK_INTERVAL_MINUTES') || '15');

        const lastCheck = await this.prisma.systemStatus.findUnique({
            where: { key }
        });

        const now = DateUtils.getNow(true);
        let shouldCheck = false;


        if (!lastCheck || !lastCheck.lastUpdate) {
            shouldCheck = true;
        } else {
            const diffMs = now.getTime() - lastCheck.lastUpdate.getTime();
            const diffMin = diffMs / (1000 * 60);
            if (diffMin >= intervalMinutes) {
                shouldCheck = true;
            }
        }

        if (shouldCheck) {
            this.logger.log(`Ejecutando chequeo de alertas (intervalo: ${intervalMinutes} min)...`);
            await this.checkAlertRules(year);
            await this.expireFollowUps();

            // Upsert system status
            await this.prisma.systemStatus.upsert({
                where: { key },
                update: { lastUpdate: now },
                create: { key, lastUpdate: now }
            });
        } else {
            // this.logger.debug('Chequeo de alertas omitido por throttling');
        }
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

        // Ejecutar motor de reglas con chequeo optimizado (throttled)
        await this.runThrottledAlertCheck(operationalYear);

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

    async getZonaAustralDays(mareaId: string) {
        const marea = await this.prisma.marea.findUnique({
            where: { id: mareaId },
            include: {
                etapas: {
                    orderBy: { nroEtapa: 'asc' }
                }
            }
        });

        if (!marea) throw new NotFoundException('Marea no encontrada');

        // 1. Preparar estructuras de las etapas
        const timezone = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';

        const stagesResult = marea.etapas
            .filter(e => e.fechaZarpada)
            .map(e => {
                // Normalizamos el inicio al comienzo del día (00:00:00) 
                // y el fin al final del día (23:59:59) en la zona horaria local
                // Esto garantiza que si hay puntos de trayectoria en cualquier momento 
                // de esos días calendario, sean incluidos en el cálculo.
                const start = DateTime.fromJSDate(new Date(e.fechaZarpada)).setZone(timezone).startOf('day').toJSDate();

                let endJS: Date;
                if (e.fechaArribo) {
                    endJS = DateTime.fromJSDate(new Date(e.fechaArribo)).setZone(timezone).endOf('day').toJSDate();
                } else {
                    // Si no tiene arribo, es una marea en curso. Usamos 'ahora'.
                    endJS = new Date();
                }

                return {
                    id: e.id,
                    nroEtapa: e.nroEtapa,
                    start,
                    end: endJS,
                    puntosPorDia: new Map<string, number>()
                };
            });

        if (stagesResult.length === 0) {
            return {
                mareaId,
                totalDiasMarea: 0,
                diasDetectadosMarea: [],
                etapas: []
            };
        }

        // 2. Obtener puntos de trayectoria del buque para el rango total
        const oldestStart = new Date(Math.min(...stagesResult.map(r => r.start.getTime())));
        const newestEnd = new Date(Math.max(...stagesResult.map(r => r.end.getTime())));

        const points = await this.prisma.buqueTrayectoriaPunto.findMany({
            where: {
                buqueId: marea.buqueId,
                timestamp: {
                    gte: oldestStart,
                    lte: newestEnd
                },
                lat: { lte: -50 } // Zona Austral: Latitud <= 50º Sur
            },
            orderBy: { timestamp: 'asc' }
        });

        // 3. Procesar puntos y asignarlos a la etapa correspondiente
        const globalDetectedDays = new Set<string>();

        for (const point of points) {
            const pointDate = point.timestamp;

            // Encontrar la etapa a la que pertenece el punto
            const stage = stagesResult.find(r => pointDate >= r.start && pointDate <= r.end);
            if (!stage) continue;

            const localDay = DateTime.fromJSDate(pointDate).setZone(timezone).toFormat('yyyy-MM-dd');
            stage.puntosPorDia.set(localDay, (stage.puntosPorDia.get(localDay) || 0) + 1);
        }

        // 4. Consolidar resultados
        const breakdownEtapas = stagesResult.map(s => {
            const detected = Array.from(s.puntosPorDia.entries())
                .filter(([_, count]) => count >= 2)
                .map(([day, _]) => day)
                .sort();

            detected.forEach(d => globalDetectedDays.add(d));

            return {
                etapaId: s.id,
                nroEtapa: s.nroEtapa,
                diasDetectados: detected,
                totalDias: detected.length
            };
        });

        return {
            mareaId,
            totalDiasMarea: globalDetectedDays.size,
            diasDetectadosMarea: Array.from(globalDetectedDays).sort(),
            etapas: breakdownEtapas
        };
    }
}
