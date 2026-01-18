import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DateUtils } from '../common/utils/date.utils';
import { Prisma } from '@prisma/client';
import { StatsDetailItem, DashboardStats } from './interfaces/dashboard.interface';
import { MareaUtils } from '../common/utils/marea.utils';

@Injectable()
export class StatsService {
    constructor(private readonly prisma: PrismaService) { }

    private getSharedWhereClause(
        yearStart: Date,
        yearEnd: Date,
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean
    ): Prisma.MareaWhereInput {
        const where: Prisma.MareaWhereInput = {
            activo: true,
        };

        const activityOverlapCondition: Prisma.MareaWhereInput = {
            OR: [
                {
                    fechaInicioObservador: { lte: yearEnd },
                    AND: [
                        {
                            OR: [
                                { fechaFinObservador: { gte: yearStart } },
                                { fechaFinObservador: null },
                            ],
                        },
                    ],
                },
            ],
        };

        const protocolizedInYearCondition: Prisma.MareaWhereInput = {
            fechaProtocolizacion: {
                gte: yearStart,
                lte: yearEnd,
            },
        };

        if (!includeNonProtocolized) {
            if (includeProtocolizedOutOfPeriod) {
                where.AND = protocolizedInYearCondition;
            } else {
                where.AND = [
                    activityOverlapCondition,
                    protocolizedInYearCondition
                ];
            }
        } else {
            where.AND = activityOverlapCondition;
        }

        return where;
    }

    async getDashboardStats(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
    ) {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);

        const mareas = await this.prisma.marea.findMany({
            where,
            include: {
                buque: {
                    include: {
                        tipoFlota: true,
                        pesqueriaHabitual: true,
                    }
                },
                observadorPrincipal: true,
                // We might need Etapas later for more granular location data, but for now Marea level is enough
            },
        });

        // 3. Process & Aggregate
        let totalMareas = 0;
        let totalDaysNavigated = 0;

        // Monthly aggregations
        const mareasByMonth = new Array(12).fill(0);
        const daysByMonth = new Array(12).fill(0);

        // Groupings
        const byFishery: Record<string, { name: string; mareas: number; days: number }> = {};
        const byFleet: Record<string, { name: string; mareas: number; days: number }> = {};
        const byObserver: Record<string, { name: string; mareas: number; days: number; active: boolean }> = {};

        for (const marea of mareas) {
            // Determine Start/End for calculation
            const start = marea.fechaInicioObservador || marea.fechaZarpadaEstimada;
            const end = marea.fechaFinObservador || (marea.estadoActualId === 'EN_EJECUCION' ? new Date() : marea.fechaFinObservador);
            // Note: need to handle open ended mareas using Today if active

            if (!start) continue; // Skip bad data

            const endDateOrNow = end || new Date();

            // Calculate Days
            let days = 0;

            if (mode === 'CALENDAR') {
                days = DateUtils.calculateDaysInYear(start, endDateOrNow, year);
            } else {
                days = DateUtils.calculateInclusiveDays(start, endDateOrNow);
            }

            // Add to Totals
            totalMareas++;
            totalDaysNavigated += days;

            // Aggregations
            // Fishery
            const fisheryName = marea.buque?.pesqueriaHabitual?.nombre || 'Desconocida';
            if (!byFishery[fisheryName]) byFishery[fisheryName] = { name: fisheryName, mareas: 0, days: 0 };
            byFishery[fisheryName].mareas++;
            byFishery[fisheryName].days += days;

            // Fleet
            const fleetName = marea.buque?.tipoFlota?.nombre || 'Desconocida';
            if (!byFleet[fleetName]) byFleet[fleetName] = { name: fleetName, mareas: 0, days: 0 };
            byFleet[fleetName].mareas++;
            byFleet[fleetName].days += days;

            // Observer
            if (marea.observadorPrincipal) {
                const obsName = `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}`;
                const obsId = marea.observadorPrincipal.id;
                if (!byObserver[obsId]) {
                    byObserver[obsId] = {
                        name: obsName,
                        mareas: 0,
                        days: 0,
                        active: marea.observadorPrincipal.activo
                    };
                }
                byObserver[obsId].mareas++;
                byObserver[obsId].days += days;
            }

            // Monthly Trend (Based on Start Date for "Mareas Started" or distributed?)
            // User requirements: "cantidad de mareas realizadas por mes del año"
            // Often simple count of Starts.
            // If we want "Days per month", we distribute.
            // Let's do: Start Month for Marea Count, and Distributed Days for Days Count.

            const startMonth = start.getMonth(); // 0-11
            if (start.getFullYear() === year) {
                mareasByMonth[startMonth]++;
            } else if (mode === 'CALENDAR') {
                // If started previous year but active now, simple Marea count might be confusing if assigned to Jan?
                // Let's stick to "Started in this month of this year". 
                // If marea started in Dec 2024, it won't show in "Mareas by Month 2025" chart, but will contribute to "Days".
            }

            // Distribute Days across months (Complex for Calendar mode, simple for Total?)
            // For simplicity in this first pass, let's just log the 'Days' to the Start Month
            // OR better: if Mode=Calendar, distribute properly.

            if (mode === 'CALENDAR' && days > 0) {
                // We iterate days? No, too slow.
                // Simple heuristic: if full within one month, add.
                // If spans months, we need to split.
                // Let's do a loop over months of the year
                let currentCursor = new Date(start < yearStart ? yearStart : start);
                const endCursor = endDateOrNow > yearEnd ? yearEnd : endDateOrNow;

                while (currentCursor < endCursor) {
                    const m = currentCursor.getMonth();
                    // End of this month
                    const nextMonthStart = new Date(currentCursor.getFullYear(), m + 1, 1);
                    const limit = nextMonthStart < endCursor ? nextMonthStart : endCursor;

                    if (currentCursor.getFullYear() === year) {
                        const diff = Math.abs(limit.getTime() - currentCursor.getTime());
                        const daysInMonth = Math.ceil(diff / (1000 * 60 * 60 * 24));
                        daysByMonth[m] += daysInMonth;
                    }
                    currentCursor = nextMonthStart;
                }
            } else {
                // Total Mode: Assign all days to start month? Or distribute?
                // Generally dashboard charts for "Days / Month" expect distribution.
                // If "Total Marea" mode, it's weird to show "Days per Month" because days might be outside the year.
                // Let's keep Days distribution consistently calculated for the visible year.
                // And "Total Days" KPI shows the boosted value.
            }
        }

        return {
            year,
            mode,
            totalMareas,
            totalDaysNavigated,
            avgDaysPerMarea: totalMareas ? Math.round(totalDaysNavigated / totalMareas) : 0,
            monthly: {
                mareas: mareasByMonth,
                days: daysByMonth, // Note: Populated only in Calendar Loop above, might be 0 if logic skipped
            },
            fisheries: Object.values(byFishery).sort((a, b) => b.days - a.days),
            fleets: Object.values(byFleet).sort((a, b) => b.days - a.days),
            observers: Object.values(byObserver).sort((a, b) => b.days - a.days),
        };
    }

    async getDashboardStatsDetail(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod = false,
        filterType: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue: string
    ): Promise<StatsDetailItem[]> {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);

        // Apply dynamic filter
        if (filterType === 'FISHERY') {
            where.buque = {
                pesqueriaHabitual: { nombre: filterValue }
            };
        } else if (filterType === 'FLEET') {
            where.buque = {
                tipoFlota: { nombre: filterValue }
            };
        } else if (filterType === 'OBSERVER') {
            // filterValue can be ID or Name. Since dashboard groups by ID, let's assume it's ID.
            where.observadorPrincipalId = filterValue;
        }

        const mareas = await this.prisma.marea.findMany({
            where,
            include: {
                buque: {
                    include: {
                        tipoFlota: true,
                        pesqueriaHabitual: true,
                    }
                },
                observadorPrincipal: true,
                estadoActual: true,
            },
            orderBy: { fechaInicioObservador: 'desc' }
        });

        // Format for list display
        return mareas.map(m => {
            const start = m.fechaInicioObservador || m.fechaZarpadaEstimada;
            const end = m.fechaFinObservador || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : m.fechaFinObservador);
            const endDateOrNow = end || new Date();

            let days = 0;
            if (start) {
                if (mode === 'CALENDAR') {
                    days = DateUtils.calculateDaysInYear(start, endDateOrNow, year);
                } else {
                    days = DateUtils.calculateInclusiveDays(start, endDateOrNow);
                }
            }

            return {
                id: m.id,
                id_marea: MareaUtils.formatCodigo(m),
                anioMarea: m.anioMarea,
                nroMarea: m.nroMarea,
                tipoMarea: m.tipoMarea,
                buque: m.buque?.nombreBuque || 'Desconocido',
                flota: m.buque?.tipoFlota?.nombre || '-',
                pesqueria: m.buque?.pesqueriaHabitual?.nombre || '-',
                observador: m.observadorPrincipal ? `${m.observadorPrincipal.nombre} ${m.observadorPrincipal.apellido}` : 'Sin asignar',
                estado: m.estadoActual?.nombre || 'Desconocido',
                diasContabilizados: days,
                fechaInicio: start,
                fechaFin: m.fechaFinObservador
            };
        });
    }
}
