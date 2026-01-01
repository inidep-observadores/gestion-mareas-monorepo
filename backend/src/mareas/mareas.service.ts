import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';
import { CreateMareaDto } from './dto/create-marea.dto';

@Injectable()
export class MareasService {
    constructor(private readonly prisma: PrismaService) { }

    async getDashboardOperativo() {
        const [estados, transiciones] = await Promise.all([
            this.prisma.estadoMarea.findMany({
                where: { activo: true, mostrarEnPanel: true },
                orderBy: { orden: 'asc' }
            }),
            this.prisma.transicionEstado.findMany({
                where: { activo: true }
            })
        ]);

        const kpisRaw = await Promise.all(
            estados.map(async (e) => ({
                label: e.nombre,
                value: await this.prisma.marea.count({ where: { estadoActualId: e.id, activo: true } }),
                codigo: e.codigo
            }))
        );

        const kpis = kpisRaw.filter(k => k.value > 0);

        const mareas = await this.prisma.marea.findMany({
            where: {
                activo: true,
                estadoActual: {
                    mostrarEnPanel: true
                }
            },
            include: {
                buque: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'desc' },
                    take: 1,
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        pesqueria: true
                    }
                }
            },
            orderBy: {
                fechaUltimaActualizacion: 'desc'
            },
            take: 50
        });

        const items = mareas.map(m => {
            const etapaActual = m.etapas[0] || null;
            const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === m.estadoActualId);

            const actionsAvailable: Record<string, any> = {};
            allowedTransitions.forEach(t => {
                actionsAvailable[t.accion] = {
                    enabled: true,
                    label: t.etiqueta,
                    toState: t.estadoDestinoId
                };
            });

            return {
                id: m.id,
                id_marea: `${m.tipoMarea}-${String(m.nroMarea).padStart(3, '0')}-${String(m.anioMarea).slice(-2)}`,
                buque_nombre: m.buque.nombreBuque,
                estado: m.estadoActual.nombre,
                estado_codigo: m.estadoActual.codigo,
                fecha_zarpada: etapaActual?.fechaZarpada || m.fechaZarpadaEstimada,
                puerto: etapaActual?.puertoZarpada?.nombre || 'N/D',
                progreso: m.estadoActual.codigo === 'NAVEGANDO' ? 75 : 0,
                alertas: [],
                actionsAvailable
            };
        });

        return {
            kpis,
            items
        };
    }

    async getMareaContext(id: string) {
        const [marea, transiciones] = await Promise.all([
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
                            pesqueria: true
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
            this.prisma.transicionEstado.findMany({ where: { activo: true } })
        ]);

        if (!marea) throw new NotFoundException('Marea no encontrada');

        const allowedTransitions = transiciones.filter(t => t.estadoOrigenId === marea.estadoActualId);
        const actions: Record<string, any> = {};
        allowedTransitions.forEach(t => {
            actions[t.accion] = {
                enabled: true,
                label: t.etiqueta,
                toState: t.estadoDestinoId
            };
        });

        return {
            marea: {
                id: marea.id,
                id_marea: `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}`,
                buque_nombre: marea.buque.nombreBuque,
                estado: marea.estadoActual.nombre,
                estado_codigo: marea.estadoActual.codigo,
                dias_marea: 15, // TODO: Implementar cálculo real
                dias_navegados: 10, // TODO: Implementar cálculo real
            },
            actions,
            lastEvents: marea.movimientos.map(mov => ({
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

    async executeAction(id: string, actionKey: string, user: User) {
        const marea = await this.prisma.marea.findUnique({
            where: { id },
            include: { estadoActual: true }
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
            const mareaUpdated = await tx.marea.update({
                where: { id },
                data: {
                    estadoActualId: transicion.estadoDestinoId,
                    fechaUltimaActualizacion: new Date()
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
        const { buqueId, anioMarea, nroMarea, pesqueriaId, observadorId, arteId, fechaZarpadaEstimada, tipoMarea = 'MC', titulo, descripcion } = createMareaDto;

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

            await tx.mareaEtapa.create({
                data: {
                    mareaId: marea.id,
                    nroEtapa: 1,
                    pesqueriaId,
                    tipoEtapa: tipoMarea === 'CI' ? 'INSTITUCIONAL' : 'COMERCIAL',
                    fechaZarpada: fechaZarpadaEstimada ? new Date(fechaZarpadaEstimada) : null,
                }
            });

            return marea;
        });
    }

}
