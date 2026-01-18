import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';

@Injectable()
export class StatsService {
    constructor(private readonly prisma: PrismaService) { }

    async getDashboardStats(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
    ) {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        // 1. Build Where Clause
        const where: Prisma.MareaWhereInput = {
            activo: true, // Always active mareas
        };

        // Date Logic Filters
        // Activity overlap: Start <= YearEnd AND (End >= YearStart OR End is NULL)
        // We use fechaInicioObservador as the primary start date for "Observer Days", 
        // but for "Marea" generic stats we might look at fechaZarpadaEstimada if observer is null? 
        // Let's assume operationally we care about fechaInicioObservador for calculations involving observers, 
        // but the marea itself exists if fechaZarpadaEstimada or fechaInicioObservador is present.
        // Let's use fechaInicioObservador for consistency with "Days Navigated by Observer"
        // fallback to fechaZarpadaEstimada if needed.

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
                // Fallback for mareas without observer start date yet but existing?
                // Usually filtered out or treated as 0 days. 
                // Let's keep strict check on activity existence.
            ],
        };

        const protocolizedInYearCondition: Prisma.MareaWhereInput = {
            fechaProtocolizacion: {
                gte: yearStart,
                lte: yearEnd,
            },
        };

        // Protocolized Logic
        // If includeNonProtocolized is FALSE (meaning we ONLY want Protocolized):
        if (!includeNonProtocolized) {
            // Only Protocolized mareas
            if (includeProtocolizedOutOfPeriod) {
                // Scenario C: Strictly Protocolized in Year (regardless of activity)
                where.AND = protocolizedInYearCondition;
            } else {
                // Scenario B: Protocolized in Year AND Activity Overlap in Year
                where.AND = [
                    activityOverlapCondition,
                    protocolizedInYearCondition
                ];
            }
        } else {
            // Scenario A: Any marea active in year (Protocolized or not)
            // "includeNonProtocolized" = true implies we don't care about protocolization status filter.
            // So simply Activity Overlap.
            where.AND = activityOverlapCondition;
        }

        // 2. Fetch Data with Relations
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
                // Intersection of [Start, End] and [Jan 1, Dec 31]
                const effectiveStart = start < yearStart ? yearStart : start;
                const effectiveEnd = endDateOrNow > yearEnd ? yearEnd : endDateOrNow;

                if (effectiveStart <= effectiveEnd) {
                    const diffTime = Math.abs(effectiveEnd.getTime() - effectiveStart.getTime());
                    days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    // Math.ceil ensuring at least 1 day if partial, or use round? 
                    // Usually navigation days are counted as dates touched.
                    // Diff in millis / day_millis gives pure 24h chunks.
                    // Let's stick to standard diff + something or just ceil.
                }
            } else {
                // TOTAL Mode
                // Full duration if marea is in the set
                const diffTime = Math.abs(endDateOrNow.getTime() - start.getTime());
                days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
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
            // Usually means "Started in Month" or "Active in Month"?
            // "Mareas realizadas por mes": Often simple count of Starts.
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
}
