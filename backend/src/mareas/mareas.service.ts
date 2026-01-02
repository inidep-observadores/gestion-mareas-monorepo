import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';
import { UpdateMareaDto } from './dto/update-marea.dto';

@Injectable()
export class MareasService {
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
                // For other states: calculate actual days worked
                let diasTrabajados = 0;

                if (m.fechaInicioObservador && m.fechaFinObservador) {
                    // Use observer dates if available
                    const inicio = new Date(m.fechaInicioObservador);
                    const fin = new Date(m.fechaFinObservador);
                    const diffTime = fin.getTime() - inicio.getTime();
                    diasTrabajados = Math.floor(diffTime / (1000 * 60 * 60 * 24)) - 1; // -1 as per requirements
                } else {
                    // Fallback: use first stage departure and last stage arrival
                    const primeraEtapa = m.etapas[m.etapas.length - 1]; // etapas are ordered desc, so last is first
                    const ultimaEtapa = m.etapas[0];

                    if (primeraEtapa?.fechaZarpada && ultimaEtapa?.fechaArribo) {
                        const zarpada = new Date(primeraEtapa.fechaZarpada);
                        const arribo = new Date(ultimaEtapa.fechaArribo);
                        const diffTime = arribo.getTime() - zarpada.getTime();
                        diasTrabajados = Math.floor(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 as per requirements
                    }
                }

                // Calculate percentage based on diasEstimados
                if (m.diasEstimados && m.diasEstimados > 0 && diasTrabajados > 0) {
                    progreso = Math.min(Math.round((diasTrabajados / m.diasEstimados) * 100), 100);
                } else if (diasTrabajados > 0) {
                    progreso = 100; // If no estimate but has worked days, assume complete
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
        const [buquesActivos, observadoresDisponibles, mareasDesignadas, listasParaProtocolizar] = await Promise.all([
            this.prisma.marea.groupBy({
                by: ['buqueId'],
                where: {
                    activo: true,
                    anioMarea: operationalYear,
                    buque: {
                        activo: true
                    },
                    estadoActual: {
                        mostrarEnPanel: true
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
            })
        ]);

        return {
            flotaActiva: buquesActivos.length,
            observadoresDisponibles,
            mareasDesignadas,
            listasParaProtocolizar
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
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        pesqueria: true
                    }
                }
            }
        });

        const distributionMap = new Map<string, number>();

        activeMareas.forEach((marea) => {
            const label = marea.etapas[0]?.pesqueria?.nombre ?? 'Sin pesquería';
            distributionMap.set(label, (distributionMap.get(label) ?? 0) + 1);
        });

        const distribution = Array.from(distributionMap.entries())
            .map(([label, count]) => ({ label, count }))
            .sort((a, b) => b.count - a.count);

        return {
            total: activeMareas.length,
            distribution
        };
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
                fechaArribo: { not: null },
                OR: [
                    { fechaZarpada: { not: null, lte: periodEnd } },
                    { fechaArribo: { gte: periodStart } }
                ]
            },
            include: {
                observadores: {
                    include: { observador: true }
                }
            }
        });

        const observerIntervals = new Map<string, { nombre: string; tramos: Array<{ inicio: Date; fin: Date }> }>();

        etapas.forEach((etapa) => {
            const inicio = etapa.fechaZarpada ? new Date(etapa.fechaZarpada) : null;
            const fin = etapa.fechaArribo ? new Date(etapa.fechaArribo) : null;
            if (!inicio || !fin) return;

            // Recortar al rango del año operativo
            const clampedInicio = inicio < periodStart ? periodStart : inicio;
            const clampedFin = fin > periodEnd ? periodEnd : fin;
            if (clampedFin < periodStart || clampedInicio > periodEnd) return;

            etapa.observadores.forEach((o) => {
                if (!o.observador?.activo) return;
                const data = observerIntervals.get(o.observadorId) ?? {
                    nombre: `${o.observador.nombre} ${o.observador.apellido}`,
                    tramos: []
                };
                data.tramos.push({ inicio: clampedInicio, fin: clampedFin });
                observerIntervals.set(o.observadorId, data);
            });
        });

        const alerts: Array<{ id: string; name: string; days: number }> = [];
        const ANNUAL_STANDARD = 180;
        const THRESHOLD = Math.floor(ANNUAL_STANDARD * 0.9);

        const mergeIntervals = (tramos: Array<{ inicio: Date; fin: Date }>) => {
            const sorted = tramos.sort((a, b) => a.inicio.getTime() - b.inicio.getTime());
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
            return merged;
        };

        observerIntervals.forEach((info, id) => {
            const merged = mergeIntervals(info.tramos);
            let days = 0;
            merged.forEach((i) => {
                const diff = Math.floor((i.fin.getTime() - i.inicio.getTime()) / (1000 * 60 * 60 * 24)) + 1;
                days += diff;
            });
            if (days > THRESHOLD) {
                alerts.push({
                    id,
                    name: info.nombre,
                    days
                });
            }
        });

        return alerts;
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

        // Cálculo de días
        const now = new Date();
        const start = fechaZarpada ? new Date(fechaZarpada) : null;
        const diffTime = start ? Math.abs(now.getTime() - start.getTime()) : 0;
        const days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

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
