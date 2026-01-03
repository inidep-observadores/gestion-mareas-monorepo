import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';

@Injectable()
export class MareasService {
    // Fuentes únicas de verdad para estados operativos
    private readonly ESTADOS_NAVEGANDO = ['EN_EJECUCION'];
    private readonly ESTADOS_REVISION = [
        'ENTREGADA_RECIBIDA',
        'VERIFICACION_INICIAL',
        'EN_CORRECCION',
        'PENDIENTE_DE_INFORME',
        'ESPERANDO_REVISION'
    ];

    // Constantes de Reglas de Negocio (SLE)
    private readonly DIAS_NAVEGADOS_ANUALES = 180;
    private readonly DIAS_DESCANSO_POST_MAREA = 15;
    private readonly PLAZO_ENTREGA_DATOS = 15;
    private readonly PLAZO_CONFECCION_INFORME = 7;
    private readonly UMBRAL_FATIGA_ANUAL_PORCENTAJE = 0.9;
    private readonly ALERTA_DIAS_CORRIDOS = 60;

    constructor(private readonly prisma: PrismaService) { }

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
                }
            }
        });

        if (!marea) throw new NotFoundException('Marea no encontrada');
        return marea;
    }

    async update(id: string, updateMareaDto: UpdateMareaDto) {
        const { etapas, ...data } = updateMareaDto;

        await this.prisma.marea.update({
            where: { id },
            data: data
        });

        return this.findOne(id);
    }

    private resolveYear(year?: number): number {
        return year && !Number.isNaN(year) ? year : new Date().getFullYear();
    }

    async getDashboardOperativo(year?: number) {
        const operationalYear = this.resolveYear(year);
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
                    where: { estadoActualId: e.id, activo: true, anioMarea: operationalYear }
                }),
                codigo: e.codigo
            }))
        );

        const kpis = kpisRaw.filter(k => k.value > 0);

        const mareas = await (this.prisma as any).marea.findMany({
            where: {
                activo: true,
                anioMarea: operationalYear,
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

            if (estadoCodigo === 'DESIGNADA') {
                progreso = 0;
            } else if (estadoCodigo === 'EN_EJECUCION') {
                // Days from estimated departure date to now
                const fechaEstimada = m.fechaZarpadaEstimada;
                if (fechaEstimada) {
                    const now = new Date();
                    const estimada = new Date(fechaEstimada);
                    const diffTime = now.getTime() - estimada.getTime();
                    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 to include both initial and current day

                    // Calculate percentage based on diasEstimados if available
                    if (m.diasEstimados && m.diasEstimados > 0) {
                        progreso = Math.min(Math.round((diffDays / m.diasEstimados) * 100), 100);
                    } else {
                        progreso = diffDays > 0 ? Math.min(diffDays * 10, 100) : 0; // Fallback: 10% per day
                    }
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

                if (m.diasEstimados && m.diasEstimados > 0 && diasTrabajados > 0) {
                    progreso = Math.min(Math.round((diasTrabajados / m.diasEstimados) * 100), 100);
                } else if (diasTrabajados > 0) {
                    progreso = 100;
                }
            }

            return {
                id: m.id,
                id_marea: `${m.tipoMarea}-${String(m.nroMarea).padStart(3, '0')}-${String(m.anioMarea).slice(-2)}`,
                buque_nombre: m.buque.nombreBuque,
                estado: m.estadoActual.nombre,
                estado_codigo: m.estadoActual.codigo,
                fecha_zarpada: etapaActual?.fechaZarpada || m.fechaZarpadaEstimada,
                puerto: etapaActual?.puertoZarpada?.nombre || 'N/D',
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

    async getDashboardKpis(year?: number) {
        const operationalYear = this.resolveYear(year);

        const [buquesActivos, observadoresDisponibles, mareasDesignadas, listasParaProtocolizar, mareasEnRevision] = await Promise.all([
            this.prisma.marea.groupBy({
                by: ['buqueId'],
                where: {
                    activo: true,
                    anioMarea: operationalYear,
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
                    anioMarea: operationalYear,
                    estadoActual: {
                        codigo: 'DESIGNADA'
                    }
                }
            }),
            this.prisma.marea.count({
                where: {
                    activo: true,
                    anioMarea: operationalYear,
                    estadoActual: {
                        codigo: 'ESPERANDO_PROTOCOLIZACION'
                    }
                }
            }),
            this.prisma.marea.count({
                where: {
                    activo: true,
                    anioMarea: operationalYear,
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
        const operationalYear = this.resolveYear(year);
        const activeMareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                anioMarea: operationalYear,
                estadoActual: {
                    mostrarEnPanel: true
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
            const status = marea.estadoActual?.codigo ?? 'EN_EJECUCION';

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
                    activo: true,
                    anioMarea: operationalYear
                },
                OR: [
                    { fechaZarpada: { not: null, lte: periodEnd } },
                    { fechaArribo: { gte: periodStart } },
                    {
                        AND: [
                            { fechaZarpada: { not: null } },
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
            // Si sigue navegando o el arribo es posterior, contamos hasta ahora (sin cortar al 31/12)
            const finCandidate = finRaw || now;
            const fin = finCandidate > now ? now : finCandidate;

            const clampedInicio = inicio < periodStart ? periodStart : inicio;
            const clampedFin = fin;
            if (clampedFin < periodStart || clampedInicio > clampedFin) return;

            const m = etapa.marea;
            const mareaCode = `${m.tipoMarea}-${String(m.nroMarea).padStart(3, '0')}-${String(m.anioMarea).slice(-2)}`;
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

        const THRESHOLD = Math.floor(this.DIAS_NAVEGADOS_ANUALES * this.UMBRAL_FATIGA_ANUAL_PORCENTAJE);

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
        const operationalYear = this.resolveYear(year);
        const periodStart = new Date(operationalYear, 0, 1, 0, 0, 0, 0);
        const now = new Date();

        // Observadores activos
        const observadores = await this.prisma.observador.findMany({
            where: { activo: true }
        });

        // Etapas del año operativo (incluye las que cruzan año)
        const etapas = await this.prisma.mareaEtapa.findMany({
            where: {
                marea: { activo: true, anioMarea: operationalYear },
                fechaZarpada: { not: null }
            },
            include: {
                marea: {
                    include: { estadoActual: true }
                },
                observadores: {
                    include: { observador: true }
                }
            }
        });

        const activeNav = new Set<string>();
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

                const isNavigating = this.ESTADOS_NAVEGANDO.includes(etapa.marea.estadoActual?.codigo || '');
                if (isNavigating) {
                    activeNav.add(obs.id);
                }

                if (finRaw) {
                    const prev = lastArrivalByObs.get(obs.id);
                    if (!prev || finRaw > prev) {
                        lastArrivalByObs.set(obs.id, finRaw);
                    }
                }
            });
        });

        const descansoIds = new Set<string>();
        const topDryCandidates: Array<{ id: string; name: string; days: number; lastArrival: string }> = [];

        observadores.forEach((obs) => {
            if (!obs.activo) return;
            if (!obsConMareas.has(obs.id)) return; // en stand-by sin embarques en el año
            if (activeNav.has(obs.id)) return; // si está navegando no cuenta para descanso/top dry
            const lastArrival = lastArrivalByObs.get(obs.id);
            if (!lastArrival) return;
            const daysSince = Math.floor((now.getTime() - lastArrival.getTime()) / (1000 * 60 * 60 * 24));
            if (daysSince < this.DIAS_DESCANSO_POST_MAREA) {
                descansoIds.add(obs.id);
            }
            topDryCandidates.push({
                id: obs.id,
                name: `${obs.nombre} ${obs.apellido}`.trim(),
                days: daysSince,
                lastArrival: lastArrival.toISOString()
            });
        });

        topDryCandidates.sort((a, b) => b.days - a.days);
        const topDry = topDryCandidates.slice(0, 5);

        // Denominador: solo los que tuvieron embarques en el año
        const totalActivosFinal = Array.from(obsConMareas).length;

        const navegando = activeNav.size;
        const descanso = descansoIds.size;
        const disponiblesRaw = observadores.filter(o => o.disponible && obsConMareas.has(o.id)).length;
        const disponibles = Math.max(disponiblesRaw - descanso, 0);

        return {
            totalActivos: totalActivosFinal,
            navegando,
            descanso,
            disponibles,
            licencia: 0,
            topDry
        };
    }

    async getMareaContext(id: string) {
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
            })
        ])) as [any, any[]];

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

        const fechaZarpada = etapaActual?.fechaZarpada || marea.fechaZarpadaEstimada;

        // Cálculo de días consistentes
        const now = new Date();
        const stageIntervals = marea.etapas
            .filter((e: any) => e.fechaZarpada)
            .map((e: any) => ({
                inicio: new Date(e.fechaZarpada),
                fin: e.fechaArribo ? new Date(e.fechaArribo) : now
            }));

        const uniqueNavigatedDays = this.calculateUniqueDays(stageIntervals);
        const days = uniqueNavigatedDays;

        return {
            marea: {
                id: marea.id,
                id_marea: `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}`,
                buque_nombre: marea.buque.nombreBuque,
                estado: marea.estadoActual.nombre,
                estado_codigo: marea.estadoActual.codigo,
                observador: mainObs ? `${mainObs.nombre} ${mainObs.apellido}` : 'No asignado',
                pesqueria: etapaActual?.pesqueria?.nombre || 'General',
                fecha_zarpada: fechaZarpada,
                dias_marea: days, // Días desde inicio/zarpada
                dias_navegados: marea.estadoActual.codigo === 'NAVEGANDO' ? days : 0,
                alertas: [] // Placeholder para futuras alertas
            },
            actions,
            lastEvents: marea.movimientos.map((mov: any) => ({
                id: mov.id,
                titulo: mov.detalle || mov.tipoEvento,
                fecha: mov.fechaHora,
                usuario: mov.usuario?.fullName || 'Sistema'
            }))
        };
    }

    async search(query: string) {
        if (!query || query.length < 2) return [];

        const mareas = await this.prisma.marea.findMany({
            where: {
                OR: [
                    { buque: { nombreBuque: { contains: query, mode: 'insensitive' } } },
                    // { id: { contains: query, mode: 'insensitive' } }, // El UUID no soporta contains
                ],
                activo: true
            },
            include: { buque: true, estadoActual: true },
            take: 10
        });

        return mareas.map(m => ({
            id: m.id,
            title: `${m.buque.nombreBuque} (${m.tipoMarea}-${m.nroMarea}-${String(m.anioMarea).slice(-2)})`,
            subtitle: m.estadoActual.nombre,
            type: 'marea'
        }));
    }

    async executeAction(id: string, actionKey: string, user: User, payload: any = {}) {
        const marea = await this.prisma.marea.findUnique({
            where: { id },
            include: { estadoActual: true, etapas: { orderBy: { nroEtapa: 'asc' } } }
        });

        if (!marea) throw new NotFoundException('Marea no encontrada');

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
            let additionalMareaData = {};

            // Logic for REGISTRAR_INICIO
            if (actionKey === 'REGISTRAR_INICIO') {
                if (!payload.fechaInicio) throw new Error('La fecha de inicio es requerida para iniciar la marea.');
                const fechaInicio = new Date(payload.fechaInicio);

                // Prepare global marea update data
                additionalMareaData = { fechaInicioObservador: fechaInicio };

                // Update First Stage Departure
                const etapa1 = marea.etapas[0];
                if (etapa1) {
                    const updateData: any = { fechaZarpada: fechaInicio };
                    if (payload.puertoId) updateData.puertoZarpadaId = payload.puertoId;

                    await tx.mareaEtapa.update({
                        where: { id: etapa1.id },
                        data: updateData
                    });
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
                    detalle: `Acción: ${transicion.etiqueta}`
                }
            });

            return mareaUpdated;
        });
    }

    async create(createMareaDto: CreateMareaDto, user: User) {
        const { buqueId, anioMarea, nroMarea, pesqueriaId, observadorId, arteId, fechaZarpadaEstimada, tipoMarea = 'MC', titulo, descripcion, diasEstimados } = createMareaDto;

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
                    titulo,
                    descripcion,
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

            const etapa = await tx.mareaEtapa.create({
                data: {
                    mareaId: marea.id,
                    nroEtapa: 1,
                    pesqueriaId,
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

}
