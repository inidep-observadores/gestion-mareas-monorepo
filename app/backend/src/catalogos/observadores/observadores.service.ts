import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import * as ExcelJS from 'exceljs';
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

    async obtenerTodos(soloDisponibles: boolean = false, incluirInactivos: boolean = false) {
        try {
            const where: any = {};

            if (!incluirInactivos) {
                where.activo = true;
            }

            if (soloDisponibles) {
                where.activo = true; // Si pide solo disponibles, implícitamente solo activos
                // 1. Sin impedimento
                where.conImpedimento = false;

                // 2. No asignado a ninguna marea DESIGNADA activa
                where.mareasAsignadas = {
                    none: {
                        activo: true,
                        estadoActual: {
                            codigo: MareaEstado.DESIGNADA
                        }
                    }
                };
            }

            return await this.prisma.observador.findMany({
                where,
                orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
            });
        } catch (error) {
            console.error(error);
            throw new InternalServerErrorException('Error al obtener observadores');
        }
    }

    async exportToExcel(searchQuery?: string) {
        const where: any = {};

        if (searchQuery) {
            const query = searchQuery.toLowerCase().trim();
            where.OR = [
                { nombre: { contains: query, mode: 'insensitive' } },
                { apellido: { contains: query, mode: 'insensitive' } },
                { email: { contains: query, mode: 'insensitive' } },
                { motivoImpedimento: { contains: query, mode: 'insensitive' } },
            ];

            if (!isNaN(Number(query))) {
                where.OR.push({ codigoInterno: Number(query) });
            }
        }

        const observadores = await this.prisma.observador.findMany({
            where,
            orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
        });

        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet('Observadores');

        sheet.columns = [
            { header: 'CÓDIGO', key: 'codigoInterno', width: 10 },
            { header: 'APELLIDO', key: 'apellido', width: 20 },
            { header: 'NOMBRE', key: 'nombre', width: 20 },
            { header: 'DNI', key: 'dni', width: 15 },
            { header: 'CUIL', key: 'cuil', width: 20 },
            { header: 'TIPO', key: 'tipoObservador', width: 15 },
            { header: 'CONTRATO', key: 'tipoContrato', width: 20 },
            { header: 'ACTIVO', key: 'activo', width: 10 },
            { header: 'DISPONIBLE', key: 'disponible', width: 12 },
            { header: 'IMPEDIMENTO', key: 'conImpedimento', width: 12 },
            { header: 'MOTIVO IMPEDIMENTO', key: 'motivoImpedimento', width: 30 },
            { header: 'EMAIL', key: 'email', width: 25 },
            { header: 'TELÉFONO', key: 'telefonoPrincipal', width: 20 },
            { header: 'OBSERVACIONES', key: 'observaciones', width: 40 },
        ];

        sheet.getRow(1).font = { bold: true };
        sheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFE0E0E0' }
        };

        observadores.forEach(obs => {
            sheet.addRow({
                codigoInterno: obs.codigoInterno,
                apellido: obs.apellido,
                nombre: obs.nombre,
                dni: obs.dni || '-',
                cuil: obs.cuil || '-',
                tipoObservador: obs.tipoObservador,
                tipoContrato: obs.tipoContrato,
                activo: obs.activo ? 'SÍ' : 'NO',
                disponible: obs.disponible ? 'SÍ' : 'NO',
                conImpedimento: obs.conImpedimento ? 'SÍ' : 'NO',
                motivoImpedimento: obs.motivoImpedimento || '-',
                email: obs.email || '-',
                telefonoPrincipal: obs.telefonoPrincipal || '-',
                observaciones: obs.observaciones || '-',
            });
        });

        return workbook;
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
        const fetchAll = operationalYear === 0;
        let dateFilter: any[] = [];

        if (!fetchAll) {
            const startYear = operationalYear - 1;
            const periodStart = new Date(startYear, 0, 1, 0, 0, 0, 0);
            const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);
            dateFilter = [
                {
                    OR: [
                        { anioMarea: { in: [operationalYear, startYear] } },
                        { fechaInicioObservador: { gte: periodStart, lte: periodEnd } },
                        { fechaFinObservador: { gte: periodStart, lte: periodEnd } },
                        { fechaFinObservador: null, fechaInicioObservador: { lte: periodEnd } }
                    ]
                }
            ];
        }

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
                AND: dateFilter
            },
            include: {
                buque: {
                    include: {
                        tipoFlota: true
                    }
                },
                estadoActual: true,
                pesqueria: true,
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
                fishery: mRaw.pesqueria?.nombre,
                fleet: mRaw.buque.tipoFlota?.nombre,
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
        
        let years: number[] = [];
        if (fetchAll) {
            const tripYears = new Set(sortedTrips.map((t: any) => t.end.getFullYear()));
            tripYears.add(currentYear); // Asegurarse de tener el año actual para mostrar el tiempo en tierra
            years = Array.from(tripYears).sort((a: any, b: any) => b - a);
        } else {
            years = [operationalYear, operationalYear - 1].sort((a, b) => b - a);
        }

        let tripIdx = 0;
        const refDate = (fetchAll || operationalYear === currentYear) ? now : new Date(operationalYear, 11, 31, 23, 59, 59, 999);

        for (const y of years) {
            // 1. Agregar el total del año
            timeline.push({
                type: 'YEAR_TOTAL',
                year: y,
                totalDays: this.calculateYearTotal(trips, y)
            });

            // 2. Tierra actual (solo en el año operacional actual o si traemos todo y es el primer año)
            if ((fetchAll && y === currentYear && tripIdx === 0) || (!fetchAll && y === operationalYear && tripIdx === 0)) {
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
