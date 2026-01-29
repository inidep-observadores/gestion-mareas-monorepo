import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { MareaEstado, TipoEtapa, TipoMarea } from '../../mareas/mareas.constants';
import { DateUtils } from '../../common/utils/date.utils';
import { MareaUtils } from '../../common/utils/marea.utils';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';

@Injectable()
export class ObservadoresService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createObservadorDto: CreateObservadorDto) {
        if (createObservadorDto.disponible && createObservadorDto.conImpedimento) {
            throw new BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }

        if (createObservadorDto.conImpedimento === false) {
            createObservadorDto.motivoImpedimento = null;
        }

        // Si el email viene vacío o solo con espacios, ponerlo como null
        if (createObservadorDto.email && createObservadorDto.email.trim() === '') {
            createObservadorDto.email = null;
        } else if (createObservadorDto.email === '') {
            createObservadorDto.email = null;
        }

        return await this.prisma.observador.create({
            data: createObservadorDto as any,
        });
    }

    async obtenerTodos() {
        try {
            return await this.prisma.observador.findMany({
                orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
            });
        } catch (error) {
            console.error(error);
            throw new InternalServerErrorException('Error al obtener observadores');
        }
    }

    async obtenerUno(id: string) {
        const observador = await this.prisma.observador.findUnique({
            where: { id },
            include: { pesquerias: true }
        });

        if (!observador) {
            throw new NotFoundException(`Observador con ID ${id} no encontrado`);
        }

        return observador;
    }

    async actualizar(id: string, updateObservadorDto: UpdateObservadorDto) {
        const observador = await this.obtenerUno(id);

        if (updateObservadorDto.disponible && updateObservadorDto.conImpedimento) {
            throw new BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }

        if (updateObservadorDto.conImpedimento === false) {
            updateObservadorDto.motivoImpedimento = null;
        }

        // Si el email viene vacío o solo con espacios, ponerlo como null
        if (updateObservadorDto.email !== undefined) {
            if (updateObservadorDto.email === null || updateObservadorDto.email.trim() === '') {
                updateObservadorDto.email = null;
            }
        }

        return await this.prisma.observador.update({
            where: { id: observador.id },
            data: updateObservadorDto as any,
        });
    }

    async eliminar(id: string) {
        const observador = await this.obtenerUno(id);
        await this.prisma.observador.delete({
            where: { id: observador.id },
        });
        return { mensaje: 'Observador eliminado correctamente' };
    }

    async obtenerHistorial(id: string, operationalYear: number) {
        const startYear = operationalYear - 1;
        const periodStart = new Date(startYear, 0, 1, 0, 0, 0, 0);
        const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);

        // 1. Buscar todas las mareas donde el observador participa
        const mareasRaw = await this.prisma.marea.findMany({
            where: {
                activo: true,
                OR: [
                    { observadorPrincipalId: id },
                    {
                        etapas: {
                            some: {
                                observadores: { some: { observadorId: id } }
                            }
                        }
                    }
                ],
                AND: [
                    {
                        OR: [
                            { anioMarea: { in: [operationalYear, startYear] } },
                            { fechaInicioObservador: { gte: periodStart, lte: periodEnd } },
                            { fechaFinObservador: { gte: periodStart, lte: periodEnd } },
                            { fechaFinObservador: null, fechaInicioObservador: { lte: periodEnd } }
                        ]
                    }
                ]
            },
            include: {
                buque: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        observadores: true
                    }
                }
            } as any,
            orderBy: { fechaInicioObservador: 'asc' }
        });

        const now = DateUtils.getNow(true);
        const currentYear = now.getFullYear();
        const timeline: any[] = [];
        const years = [operationalYear, startYear].sort((a, b) => b - a);

        // Procesar viajes
        const trips = mareasRaw.map(m => {
            const mRaw = m as any;
            const start = mRaw.fechaInicioObservador || mRaw.fechaZarpadaEstimada;
            if (!start) return null;

            const isNavegando = mRaw.estadoActual.codigo === MareaEstado.EN_EJECUCION;
            const isDesignada = mRaw.estadoActual.codigo === MareaEstado.DESIGNADA;

            // Determinar fin: Preferir fechaFinObservador si es futura, sino basarse en etapas o estado actual
            let finRaw = mRaw.fechaFinObservador;

            // Si la marea está en ejecución, el final es 'ahora' a menos que haya una fecha de fin futuro (planificada)
            if (isNavegando) {
                if (!finRaw || finRaw < now) {
                    finRaw = now;
                }
            } else if (!finRaw && mRaw.etapas.length > 0) {
                const arrivals = mRaw.etapas
                    .map((e: any) => e.fechaArribo ? new Date(e.fechaArribo).getTime() : null)
                    .filter(Boolean);
                if (arrivals.length > 0) {
                    finRaw = new Date(Math.max(...(arrivals as number[])));
                }
            }

            const end = finRaw || (isNavegando ? now : start);

            // Días totales (rango de vinculación a la marea)
            // Si es DESIGNADA, son 0 días.
            // Si no, usamos 'end' calculado para evitar que calculateInclusiveDays use 'now' por defecto al recibir null.
            const totalDays = isDesignada ? 0 : DateUtils.calculateInclusiveDays(start, end);

            // Días navegados (solo si estuvo en etapas)
            const isPrincipal = mRaw.observadorPrincipalId === id;
            const relevantStages = mRaw.etapas.filter((e: any) =>
                isPrincipal || e.observadores.some((o: any) => o.observadorId === id)
            );

            const navigatedDays = DateUtils.calculateUniqueDays(
                relevantStages.map((e: any) => ({
                    start: e.fechaZarpada,
                    end: e.fechaArribo || (isNavegando ? now : null)
                }))
            );

            return {
                id: mRaw.id,
                mareaCode: MareaUtils.formatCodigo(mRaw),
                vessel: mRaw.buque.nombreBuque,
                start,
                end,
                totalDays,
                navigatedDays,
                year: new Date(start).getFullYear(),
                isNavegando,
                ignoreStats: isDesignada // Flag para excluir del total anual
            };
        }).filter(Boolean);

        // Construir Timeline con intercalado de tierra y cortes anuales
        const sortedTrips = trips.sort((a: any, b: any) => b.start.getTime() - a.start.getTime());
        let tripIdx = 0;

        const refDate = operationalYear === currentYear ? now : new Date(operationalYear, 11, 31, 23, 59, 59, 999);

        for (const y of years) {
            // 1. Agregar el total del año
            timeline.push({
                type: 'YEAR_TOTAL',
                year: y,
                totalDays: this.calculateYearTotal(trips, y)
            });

            // 2. Tierra actual (solo en el año operacional si no está navegando y es el inicio)
            if (y === operationalYear && tripIdx === 0) {
                const firstTrip = sortedTrips[0];
                if (firstTrip && !firstTrip.isNavegando) {
                    const diffTierraActual = DateUtils.calculateInclusiveDays(firstTrip.end, refDate) - 1;
                    if (diffTierraActual > 0) {
                        timeline.push({
                            type: 'LAND',
                            days: diffTierraActual,
                            start: firstTrip.end,
                            end: refDate,
                            isCurrent: true
                        });
                    }
                }
            }

            // 3. Agregar viajes que pertenecen a este año (terminan en y)
            while (tripIdx < sortedTrips.length) {
                const trip = sortedTrips[tripIdx];
                const displayYear = trip.end.getFullYear();

                if (displayYear < y) break; // Pertenece a un bloque anual posterior (más viejo)

                timeline.push({
                    type: 'TRIP',
                    ...trip
                });

                // Intercalado de tierra con el siguiente viaje (de cara al pasado)
                if (tripIdx + 1 < sortedTrips.length) {
                    const nextTrip = sortedTrips[tripIdx + 1];
                    const diffTierra = DateUtils.calculateInclusiveDays(nextTrip.end, trip.start) - 2;
                    if (diffTierra > 0) {
                        timeline.push({
                            type: 'LAND',
                            days: diffTierra,
                            start: nextTrip.end,
                            end: trip.start
                        });
                    }
                }

                tripIdx++;
            }
        }

        return timeline;
    }

    private calculateYearTotal(trips: any[], year: number): number {
        return trips.reduce((acc, trip) => {
            if (trip.ignoreStats) return acc;
            return acc + DateUtils.calculateDaysInYear(trip.start, trip.end, year);
        }, 0);
    }
}
