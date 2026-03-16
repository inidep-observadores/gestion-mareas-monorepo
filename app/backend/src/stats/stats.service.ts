import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PlanificacionService } from '../planificacion/planificacion.service';
import { DateUtils } from '../common/utils/date.utils';
import { Prisma } from '@prisma/client';
import { StatsDetailItem, DashboardStats, MareaDistributionItem, UniqueVesselsResult } from './interfaces/dashboard.interface';
import { MareaUtils } from '../common/utils/marea.utils';
import { TipoMarea, MareaEstado } from '../mareas/mareas.constants';
import { FilterType } from './dto/get-stats.dto';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import * as ExcelJS from 'exceljs';
import { Sexo } from '@prisma/client';

import { MareasService } from '../mareas/mareas.service';

@Injectable()
export class StatsService {
    constructor(
        private readonly prisma: PrismaService,
        private readonly planificacion: PlanificacionService,
        private readonly businessRules: BusinessRulesService,
        private readonly mareasService: MareasService
    ) { }

    private getSharedWhereClause(
        activityStart: Date,
        activityEnd: Date,
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        protocolizationStart?: Date,
        protocolizationEnd?: Date
    ): Prisma.MareaWhereInput {
        const where: Prisma.MareaWhereInput = {
            activo: true,
            estadoActual: {
                codigo: {
                    notIn: ['A_REASIGNAR', 'CANCELADA']
                }
            }
        };

        const protStart = protocolizationStart || activityStart;
        const protEnd = protocolizationEnd || activityEnd;

        // Source of Truth: Stages (Etapas)
        // A marea is ACTIVE in the period if it has at least one stage overlapping the period.
        // Overlap Logic: Stage Start <= Period End AND (Stage End >= Period Start OR Stage End is NULL)
        // CRITICAL: We must also filter out activity that is in the future relative to "Now"
        const now = DateUtils.getNow(true);

        // If the period requested START after NOW, it's a future period.
        if (activityStart > now) {
            return { anioMarea: -1 }; // Prisma will return empty safely
        }

        const effectivePeriodEnd = activityEnd < now ? activityEnd : now;

        const activityOverlapCondition: Prisma.MareaWhereInput = {
            etapas: {
                some: {
                    AND: [
                        { fechaZarpada: { lte: effectivePeriodEnd } },
                        {
                            OR: [
                                { fechaArribo: { gte: activityStart } },
                                { fechaArribo: null }
                            ]
                        }
                    ]
                }
            }
        };

        const protocolizedInYearCondition: Prisma.MareaWhereInput = {
            fechaProtocolizacion: {
                gte: protStart,
                lte: protEnd,
            },
        };

        const finalActivityOverlapCondition = activityOverlapCondition;

        if (!includeNonProtocolized) {
            if (includeProtocolizedOutOfPeriod) {
                where.AND = protocolizedInYearCondition;
            } else {
                where.AND = [
                    finalActivityOverlapCondition,
                    protocolizedInYearCondition
                ];
            }
        } else {
            where.AND = finalActivityOverlapCondition;
        }

        return where;
    }

    async getDashboardStats(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod = false,
        daysCalculationMode: 'SHIP' | 'OBSERVER' = 'SHIP',
        includeCampaigns: boolean = true,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ) {
        const yearStart = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        if (startDate) yearStart.setUTCHours(0, 0, 0, 0);
        if (endDate) yearEnd.setUTCHours(23, 59, 59, 999);

        // Optional protocolization range
        let protStart: Date | undefined;
        let protEnd: Date | undefined;
        if (protocolizationStartDate) {
            protStart = new Date(protocolizationStartDate);
            protStart.setUTCHours(0, 0, 0, 0);
        }
        if (protocolizationEndDate) {
            protEnd = new Date(protocolizationEndDate);
            protEnd.setUTCHours(23, 59, 59, 999);
        }

        const where = this.getSharedWhereClause(
            yearStart,
            yearEnd,
            includeNonProtocolized,
            includeProtocolizedOutOfPeriod,
            protStart,
            protEnd
        );

        // Filter Campaigns
        if (!includeCampaigns) {
            where.tipoMarea = { not: TipoMarea.CI };
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
                pesqueria: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true,
                        observadores: {
                            include: { observador: true }
                        }
                    }
                }
            },
        });

        // 3. Process & Aggregate
        let totalMareas = 0;
        let totalDaysCalculated = 0;

        // Monthly aggregations
        const mareasByMonth = new Array(12).fill(0);
        const daysByMonth = new Array(12).fill(0);

        // Groupings
        const byFishery: Record<string, {
            name: string;
            mareas: number;
            days: number;
            vessels: Map<string, { code: string; nombre: string }> // VesselID -> FleetInfo
        }> = {};
        const byFleet: Record<string, { name: string; mareas: number; days: number }> = {};
        const byObserver: Record<string, { id: string; name: string; mareas: number; days: number; active: boolean }> = {};

        for (const marea of mareas) {
            // Source of Truth: Start with the first stage's departure
            const overallStart = marea.etapas[0]?.fechaZarpada;
            if (!overallStart) continue;

            const now = DateUtils.getNow(true);
            const intervals = marea.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (marea.estadoActual?.codigo === 'EN_EJECUCION' ? now : null)
            })).filter(i => i.start && i.start <= now);

            let days = 0;

            // 1. Calculate uniquely navigated days for the Principal Observer (the whole marea)
            // Limit the calculation to the MIN of (PeriodEnd, CurrentDate)
            const calculationLimit = yearEnd < now ? yearEnd : now;
            const periodRange = mode === 'CALENDAR' ? { start: yearStart, end: yearEnd } : undefined;
            const totalMareaDays = DateUtils.calculateUniqueDays(intervals, periodRange, calculationLimit);

            const mareaObserverMap: Record<string, number> = {}; // ObsID -> Days attributed in this marea

            if (marea.observadorPrincipal) {
                mareaObserverMap[marea.observadorPrincipal.id] = totalMareaDays;
            }

            // 2. Calculate unique days for EACH additional observer involved in stages
            const additionalsMap: Record<string, Array<{ start: Date, end: Date }>> = {};
            marea.etapas.forEach(etapa => {
                if (!etapa.fechaZarpada || etapa.fechaZarpada > now) return;
                const start = etapa.fechaZarpada;
                const end = etapa.fechaArribo || (marea.estadoActual?.codigo === 'EN_EJECUCION' ? now : null);

                etapa.observadores.forEach(obsRel => {
                    if (obsRel.observador && obsRel.observador.id !== marea.observadorPrincipalId) {
                        if (!additionalsMap[obsRel.observador.id]) additionalsMap[obsRel.observador.id] = [];
                        additionalsMap[obsRel.observador.id].push({ start, end });
                    }
                });
            });

            // Sum additional efforts
            Object.entries(additionalsMap).forEach(([obsId, obsIntervals]) => {
                mareaObserverMap[obsId] = DateUtils.calculateUniqueDays(obsIntervals, periodRange, calculationLimit);
            });

            if (daysCalculationMode === 'SHIP') {
                days = totalMareaDays;
            } else {
                // OBSERVER Mode Effort = Sum of all individual unique contributions
                days = Object.values(mareaObserverMap).reduce((sum, d) => sum + d, 0);
            }

            // Add to Totals
            totalMareas++;
            totalDaysCalculated += days;

            // Aggregations: Fishery & Fleet
            // Instead of one fishery per marea, we iterate stages
            // We group intervals by fishery within this marea to avoid double-counting days if stages of the SAME fishery overlap
            const mareaFisheries = new Set<string>();
            const fisheryIntervalsMap = new Map<string, Array<{ start: Date, end: Date }>>();

            marea.etapas.forEach(etapa => {
                const fisheryName = etapa.pesqueria?.nombre || marea.buque?.pesqueriaHabitual?.nombre || 'Desconocida';
                mareaFisheries.add(fisheryName);

                if (etapa.fechaZarpada && etapa.fechaZarpada <= now) {
                    const start = etapa.fechaZarpada;
                    const end = etapa.fechaArribo || (marea.estadoActual?.codigo === 'EN_EJECUCION' ? now : null);
                    
                    if (!fisheryIntervalsMap.has(fisheryName)) {
                        fisheryIntervalsMap.set(fisheryName, []);
                    }
                    fisheryIntervalsMap.get(fisheryName)!.push({ start, end });
                }
            });

            // Count marea only once per fishery it touched in the period (if it had days)
            fisheryIntervalsMap.forEach((intervals, fisheryName) => {
                // Calculate unique days for this specific fishery combining all stages within this marea
                const fisheryNavigatedDays = DateUtils.calculateUniqueDays(intervals, periodRange, calculationLimit);

                if (fisheryNavigatedDays > 0) {
                    if (!byFishery[fisheryName]) {
                        byFishery[fisheryName] = { name: fisheryName, mareas: 0, days: 0, vessels: new Map() };
                    }
                    byFishery[fisheryName].days += fisheryNavigatedDays;
                    byFishery[fisheryName].mareas++;

                    if (marea.buque) {
                        const fleetCode = marea.buque.tipoFlota?.codigo || 'INDETERMINADO';
                        const fleetName = marea.buque.tipoFlota?.nombre || 'Indeterminado';
                        byFishery[fisheryName].vessels.set(marea.buque.id, { code: fleetCode, nombre: fleetName });
                    }
                }
            });

            // Fleet: Keep global for the marea (the vessel belongs to a fleet)
            const fleetName = marea.buque?.tipoFlota?.nombre || 'Desconocida';
            if (!byFleet[fleetName]) byFleet[fleetName] = { name: fleetName, mareas: 0, days: 0 };
            byFleet[fleetName].mareas++;
            byFleet[fleetName].days += days;

            // Observer Ranking
            Object.entries(mareaObserverMap).forEach(([oId, d]) => {
                // Ensure observer exists in byObserver (names/active status)
                if (!byObserver[oId]) {
                    let obsObj = null;
                    if (marea.observadorPrincipalId === oId) {
                        obsObj = marea.observadorPrincipal;
                    } else {
                        for (const etapa of marea.etapas) {
                            const found = etapa.observadores.find(rel => rel.observador?.id === oId);
                            if (found) {
                                obsObj = found.observador;
                                break;
                            }
                        }
                    }
                    if (obsObj) {
                        byObserver[oId] = {
                            id: oId,
                            name: `${obsObj.nombre} ${obsObj.apellido}`,
                            mareas: 0,
                            days: 0,
                            active: obsObj.activo
                        };
                    }
                }

                if (byObserver[oId]) {
                    byObserver[oId].days += d;
                    byObserver[oId].mareas++;
                }
            });

            // Monthly Trend (Starts) - DEPRECATED
            // const startMonth = overallStart.getMonth();
            // if (overallStart.getFullYear() === year) {
            //     mareasByMonth[startMonth]++;
            // }

            // Distribute Days in Month
            if (daysCalculationMode === 'SHIP') {
                if (days > 0) {
                    // Existing logic for SHIP days distribution
                    // ... (merged logic) ...
                    const normalized = intervals
                        .map(i => {
                            const s = new Date(i.start);
                            // If end is null, we treat as open end (today?) or single day?
                            // For 'active' mareas, end is today. For historic missing, it's start.
                            // In this loop we already handled "intervals" construction correctly above with `marea.estadoActualId`.
                            const e = i.end ? new Date(i.end) : new Date(s);
                            if (e > now) e.setTime(now.getTime());
                            s.setUTCHours(0, 0, 0, 0);
                            e.setUTCHours(0, 0, 0, 0);
                            return { start: s, end: e };
                        })
                        .filter(i => !isNaN(i.start.getTime()) && !isNaN(i.end.getTime()) && i.end >= i.start)
                        .sort((a, b) => a.start.getTime() - b.start.getTime());

                    const merged: Array<{ start: Date; end: Date }> = [];
                    if (normalized.length > 0) {
                        let curr = normalized[0];
                        for (let i = 1; i < normalized.length; i++) {
                            if (normalized[i].start.getTime() <= curr.end.getTime()) {
                                if (normalized[i].end.getTime() > curr.end.getTime()) curr.end = normalized[i].end;
                            } else {
                                merged.push(curr);
                                curr = normalized[i];
                            }
                        }
                        merged.push(curr);
                    }

                    for (const interval of merged) {
                        let cursor = new Date(interval.start);
                        if (mode === 'CALENDAR') {
                            if (cursor < yearStart) cursor = new Date(yearStart);
                        }
                        const limitEndForDistribution = calculationLimit < interval.end ? calculationLimit : interval.end;

                        while (cursor <= limitEndForDistribution) {
                            if (cursor.getUTCFullYear() === year) {
                                daysByMonth[cursor.getUTCMonth()]++;
                            }
                            cursor.setUTCDate(cursor.getUTCDate() + 1);
                        }
                    }
                }
            } else {
                // OBSERVER MODE: Distribute DAYS * OBSERVERS
                // Iterate stages again?
                marea.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada) return;
                    const count = (etapa.observadores && etapa.observadores.length > 0)
                        ? etapa.observadores.length
                        : (marea.observadorPrincipal ? 1 : 0);

                    if (count === 0) return;

                    const s = new Date(etapa.fechaZarpada);
                    const e = etapa.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? now : null) || new Date(s); // Fallback to start if historical missing
                    if (e > now) e.setTime(now.getTime());

                    s.setUTCHours(0, 0, 0, 0);
                    e.setUTCHours(0, 0, 0, 0);

                    let cursor = new Date(s);
                    if (mode === 'CALENDAR') {
                        if (cursor < yearStart) cursor = new Date(yearStart);
                    }
                    const limitEnd = calculationLimit < e ? calculationLimit : e;

                    while (cursor <= limitEnd) {
                        if (cursor.getUTCFullYear() === year) {
                            daysByMonth[cursor.getUTCMonth()] += count; // Add N days for this day
                        }
                        cursor.setUTCDate(cursor.getUTCDate() + 1);
                    }
                });
            }
        }

        return {
            year,
            mode,
            totalMareas,
            totalDaysNavigated: totalDaysCalculated,
            avgDaysPerMarea: totalMareas ? Math.round(totalDaysCalculated / totalMareas) : 0,
            monthly: {
                mareas: mareasByMonth,
                days: daysByMonth,
            },
            fisheries: Object.values(byFishery).map(f => {
                const stats: Record<string, { count: number, nombre: string }> = {};
                f.vessels.forEach(v => {
                    if (!stats[v.code]) stats[v.code] = { count: 0, nombre: v.nombre };
                    stats[v.code].count++;
                });
                return {
                    name: f.name,
                    mareas: f.mareas,
                    days: f.days,
                    stats: Object.keys(stats).length > 0 ? stats : undefined
                };
            }).sort((a, b) => b.days - a.days),
            fleets: Object.values(byFleet).sort((a, b) => b.days - a.days),
            observers: Object.values(byObserver).sort((a, b) => b.days - a.days),
        };
    }

    async getDashboardStatsDetail(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod = false,
        filterType: FilterType,
        filterValue: string,
        daysCalculationMode: 'SHIP' | 'OBSERVER' = 'SHIP',
        includeCampaigns: boolean = true,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ): Promise<StatsDetailItem[]> {
        const yearStart = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        if (startDate) yearStart.setUTCHours(0, 0, 0, 0);
        if (endDate) yearEnd.setUTCHours(23, 59, 59, 999);

        // Optional protocolization range
        let protStart: Date | undefined;
        let protEnd: Date | undefined;
        if (protocolizationStartDate) {
            protStart = new Date(protocolizationStartDate);
            protStart.setUTCHours(0, 0, 0, 0);
        }
        if (protocolizationEndDate) {
            protEnd = new Date(protocolizationEndDate);
            protEnd.setUTCHours(23, 59, 59, 999);
        }

        const where = this.getSharedWhereClause(
            yearStart,
            yearEnd,
            includeNonProtocolized,
            includeProtocolizedOutOfPeriod,
            protStart,
            protEnd
        );

        if (!includeCampaigns) {
            where.tipoMarea = { not: TipoMarea.CI };
        }

        // Apply dynamic filter
        if (filterType === FilterType.FISHERY) {
            where.etapas = {
                some: {
                    pesqueria: { nombre: { contains: filterValue, mode: 'insensitive' } }
                }
            };
        } else if (filterType === FilterType.FLEET) {
            where.buque = {
                tipoFlota: { nombre: filterValue }
            };
        } else if (filterType === FilterType.OBSERVER) {
            // Robust UUID check: Length 36 and hex chars + dashes
            const isUUID = filterValue.length === 36 && /^[0-9a-f-]{36}$/i.test(filterValue);
            if (isUUID) {
                where.observadorPrincipalId = filterValue;
            } else {
                where.observadorPrincipal = {
                    OR: [
                        { nombre: { contains: filterValue, mode: 'insensitive' } },
                        { apellido: { contains: filterValue, mode: 'insensitive' } }
                    ]
                };
            }
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
                pesqueria: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true,
                        observadores: { include: { observador: true } }
                    }
                }
            },
            orderBy: [
                { anioMarea: 'asc' },
                { nroMarea: 'asc' }
            ]
        });

        // Format for list display
        return mareas.map(m => {
            const overallStart = m.etapas[0]?.fechaZarpada;
            const overallEnd = m.etapas[m.etapas.length - 1]?.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? DateUtils.getNow() : null);

            let calendarDays = 0;
            let totalMareaDays = 0;
            let diasPeriodo = 0;

            const now = DateUtils.getNow(true);

            // Filter stages by fishery if applicable
            const relevantStages = filterType === FilterType.FISHERY
? m.etapas.filter(e => {
                    const fName = e.pesqueria?.nombre || m.buque?.pesqueriaHabitual?.nombre || 'Desconocida';
                    return fName.toLowerCase() === filterValue.toLowerCase();
})
: m.etapas;

            const intervals = relevantStages.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null)
            })).filter(i => i.start && i.start <= now);

            const calculationLimit = yearEnd < now ? yearEnd : now;
            const periodRange = mode === 'CALENDAR' ? { start: yearStart, end: yearEnd } : undefined;
            const strictPeriodRange = { start: yearStart, end: yearEnd };

            if (daysCalculationMode === 'SHIP') {
                calendarDays = DateUtils.calculateUniqueDays(intervals, periodRange, calculationLimit);
                totalMareaDays = DateUtils.calculateUniqueDays(intervals, undefined, now);
                diasPeriodo = DateUtils.calculateUniqueDays(intervals, strictPeriodRange, calculationLimit);
            } else {
                // OBSERVER Mode
                // Case A: Filtered by a specific observer -> Show ONLY their individual contribution
                if (filterType === FilterType.OBSERVER && filterValue) {
                    let obsIntervals: Array<{ start: Date, end: Date }> = [];
                    const isPrincipal = (m.observadorPrincipalId === filterValue);

                    if (isPrincipal) {
                        obsIntervals = intervals; // Use the already filtered fishery intervals if applicable
                    } else {
                        // Find stages where they are additional (also respecting fishery filter)
                        relevantStages.forEach(etapa => {
                            const isAdditional = etapa.observadores.some(rel => rel.observadorId === filterValue);
                            if (isAdditional) {
                                obsIntervals.push({
                                    start: etapa.fechaZarpada,
                                    end: etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null)
                                });
                            }
                        });
                    }

                    calendarDays = DateUtils.calculateUniqueDays(obsIntervals, periodRange, calculationLimit);
                    totalMareaDays = DateUtils.calculateUniqueDays(obsIntervals, undefined, now);
                    diasPeriodo = DateUtils.calculateUniqueDays(obsIntervals, strictPeriodRange, calculationLimit);
                } else {
                    // Case B: General Detail (by Fishery/Fleet/All) -> Show total EFFORT (sum of all unique contributions)
                    let effortCal = DateUtils.calculateUniqueDays(intervals, periodRange, calculationLimit);
                    let effortTotal = DateUtils.calculateUniqueDays(intervals, undefined, now);
                    let effortPeriodo = DateUtils.calculateUniqueDays(intervals, strictPeriodRange, calculationLimit);

                    const additionalsMap: Record<string, Array<{ start: Date, end: Date }>> = {};
                    relevantStages.forEach(etapa => {
                        if (!etapa.fechaZarpada) return;
                        const start = etapa.fechaZarpada;
                        const end = etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null);

                        etapa.observadores.forEach(obsRel => {
                            if (obsRel.observador && obsRel.observador.id !== m.observadorPrincipalId) {
                                if (!additionalsMap[obsRel.observador.id]) additionalsMap[obsRel.observador.id] = [];
                                additionalsMap[obsRel.observador.id].push({ start, end });
                            }
                        });
                    });

                    Object.values(additionalsMap).forEach(obsInts => {
                        effortCal += DateUtils.calculateUniqueDays(obsInts, periodRange, calculationLimit);
                        effortTotal += DateUtils.calculateUniqueDays(obsInts, undefined, now);
                        effortPeriodo += DateUtils.calculateUniqueDays(obsInts, strictPeriodRange, calculationLimit);
                    });

                    calendarDays = effortCal;
                    totalMareaDays = effortTotal;
                    diasPeriodo = effortPeriodo;
                }
            }

            const days = mode === 'CALENDAR' ? calendarDays : totalMareaDays;

            return {
                id: m.id,
                id_marea: MareaUtils.formatCodigo(m),
                anioMarea: m.anioMarea,
                nroMarea: m.nroMarea,
                tipoMarea: m.tipoMarea,
                buque: m.buque?.nombreBuque || 'Desconocido',
                flota: m.buque?.tipoFlota?.nombre || '-',
                pesqueria: filterType === FilterType.FISHERY
                    ? filterValue
                    : (m.etapas[0]?.pesqueria?.nombre || m.buque?.pesqueriaHabitual?.nombre || '-'),
                observador: m.observadorPrincipal ? `${m.observadorPrincipal.nombre} ${m.observadorPrincipal.apellido}` : 'Sin asignar',
                estado: m.estadoActual?.nombre || 'Desconocido',
                diasContabilizados: days,
                diasCalendario: calendarDays,
                diasTotales: totalMareaDays,
                diasPeriodo: diasPeriodo,
                fechaInicio: overallStart,
                fechaFin: overallEnd
            };
        });
    }

    async getExportWorkbook(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        daysCalculationMode: 'SHIP' | 'OBSERVER' = 'SHIP',
        includeCampaigns: boolean = true,
        filterType?: FilterType,
        filterValue?: string,
        startDate?: string,
        endDate?: string,
        filterByStart: boolean = false,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string,
        includeSummaries = false,
    ): Promise<ExcelJS.Workbook> {
        if (filterType === FilterType.COVERAGE) {
            return this.getCoverageExportWorkbook(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, includeCampaigns, startDate, endDate, filterValue, protocolizationStartDate, protocolizationEndDate);
        }

        if (filterType === FilterType.WORKFORCE) {
            return this.getWorkforceExportWorkbook(filterValue);
        }

        if (filterType?.startsWith('CHART_')) {
            return this.getChartDataExportWorkbook(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, includeCampaigns, filterType, startDate, endDate, protocolizationStartDate, protocolizationEndDate);
        }

        const yearStart = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        if (startDate) yearStart.setUTCHours(0, 0, 0, 0);
        if (endDate) yearEnd.setUTCHours(23, 59, 59, 999);

        // Optional protocolization range
        let protStart: Date | undefined;
        let protEnd: Date | undefined;
        if (protocolizationStartDate) {
            protStart = new Date(protocolizationStartDate);
            protStart.setUTCHours(0, 0, 0, 0);
        }
        if (protocolizationEndDate) {
            protEnd = new Date(protocolizationEndDate);
            protEnd.setUTCHours(23, 59, 59, 999);
        }

        const where = this.getSharedWhereClause(
            yearStart,
            yearEnd,
            includeNonProtocolized,
            includeProtocolizedOutOfPeriod,
            protStart,
            protEnd
        );

        if (!includeCampaigns) {
            where.tipoMarea = { not: TipoMarea.CI };
        }

        if (filterType && filterValue) {
            if (filterType === 'FISHERY') {
                where.etapas = {
                    some: {
                        pesqueria: { nombre: { contains: filterValue, mode: 'insensitive' } }
                    }
                };
            } else if (filterType === 'FLEET') {
                where.buque = { tipoFlota: { nombre: filterValue } };
            } else if (filterType === 'OBSERVER') {
                const isUUID = filterValue.length === 36 && /^[0-9a-f-]{36}$/i.test(filterValue);
                if (isUUID) {
                    where.observadorPrincipalId = filterValue;
                } else {
                    where.observadorPrincipal = {
                        OR: [
                            { nombre: { contains: filterValue, mode: 'insensitive' } },
                            { apellido: { contains: filterValue, mode: 'insensitive' } }
                        ]
                    };
                }
            }
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
                pesqueria: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true,
                        puertoZarpada: true,
                        puertoArribo: true,
                        observadores: { include: { observador: true } }
                    }
                }
            },
            orderBy: [
                { anioMarea: 'asc' },
                { nroMarea: 'asc' }
            ]
        });

        // Filtrado global por estado: Solo EN_EJECUCION o posteriores (excluyendo CANCELADA)
        const mareasFiltradas = mareas.filter(m => {
            const estado = m.estadoActual?.codigo as MareaEstado;
            return estado && 
                   estado !== MareaEstado.DESIGNADA && 
                   estado !== MareaEstado.A_REASIGNAR && 
                   estado !== MareaEstado.CANCELADA;
        });

        const workbook = new ExcelJS.Workbook();
        
        // Hoja General
        this.buildGeneralSheet(workbook, mareasFiltradas, {
            year,
            yearStart,
            yearEnd,
            mode,
            daysCalculationMode,
            filterType,
            filterValue,
            startDate,
            endDate
        });

        // Hoja Resumen por Pesquería (Resumen General)
        if (includeSummaries) {
            const summaryMC = new Map<string, any>();
            const summaryCI = new Map<string, any>();

            mareasFiltradas.forEach(m => {
                const rowData = this.calculateMareaRowData(m, { yearStart, yearEnd, mode, daysCalculationMode, filterType, filterValue });
                const summaryMap = m.tipoMarea === TipoMarea.CI ? summaryCI : summaryMC;
                const key = `${rowData.pesqueria}|${rowData.flota}`;
                if (!summaryMap.has(key)) {
                    summaryMap.set(key, { pesqueria: rowData.pesqueria, flota: rowData.flota, mareas: 0, etapas: 0, dias: 0 });
                }
                const current = summaryMap.get(key)!;
                current.mareas += 1;
                current.etapas += m.etapas.length;
                current.dias += rowData.dias_calendario;
            });

            this.buildSummarySheet(workbook, summaryMC, summaryCI);
        }

        // Hoja Días por Observador - Comercial (Debe ir después de los resúmenes)
        this.buildObserverDaysSheet(workbook, 'Días por Observador - Comercial', mareasFiltradas, TipoMarea.MC, {
            yearStart,
            yearEnd,
            mode,
            daysCalculationMode,
            filterType,
            filterValue
        });

        // Hoja Días por Observador - Institucional (Solo si se incluyeron campañas)
        if (includeCampaigns) {
            this.buildObserverDaysSheet(workbook, 'Días por Observador - Institucional', mareasFiltradas, TipoMarea.CI, {
                yearStart,
                yearEnd,
                mode,
                daysCalculationMode,
                filterType,
                filterValue
            });
        }

        // Hoja Resumen Obs-Flota-Especie - Com
        this.buildObserverSummarySheet(workbook, 'Resumen Obs-Flota-Especie - Com', mareasFiltradas, TipoMarea.MC, {
            yearStart,
            yearEnd,
            mode,
            daysCalculationMode,
            filterType,
            filterValue
        });

        // Hoja Resumen Obs-Flota-Especie - Ins
        if (includeCampaigns) {
            this.buildObserverSummarySheet(workbook, 'Resumen Obs-Flota-Especie - Ins', mareasFiltradas, TipoMarea.CI, {
                yearStart,
                yearEnd,
                mode,
                daysCalculationMode,
                filterType,
                filterValue
            });
        }

        // Hoja Campañas Institucionales
        if (includeCampaigns) {
            this.buildInstitucionalesSheet(workbook, mareasFiltradas, {
                year,
                yearStart,
                yearEnd,
                mode,
                daysCalculationMode,
                filterType,
                filterValue
            });
        }

        return workbook;
    }

    private buildGeneralSheet(workbook: ExcelJS.Workbook, mareas: any[], options: any) {
        const sheet = workbook.addWorksheet('General');
        
        // Determinar max etapas y observadores adicionales
        let maxEtapas = 0;
        let maxExtraObservers = 0;

        mareas.forEach(m => {
            if (m.etapas.length > maxEtapas) maxEtapas = m.etapas.length;
            const extras = new Set<string>();
            m.etapas.forEach(e => {
                e.observadores.forEach(obsRel => {
                    const oid = obsRel.observadorId;
                    if (oid && (!m.observadorPrincipal || oid !== m.observadorPrincipal.id)) {
                        extras.add(oid);
                    }
                });
            });
            if (extras.size > maxExtraObservers) maxExtraObservers = extras.size;
        });

        // Determinar si es exportación mensual
        let isMonthlyDetail = false;
        let monthName = '';
        const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

        if (options.startDate && options.endDate) {
            const sDate = new Date(options.startDate);
            const eDate = new Date(options.endDate);
            if (sDate.getUTCFullYear() === eDate.getUTCFullYear() && sDate.getUTCMonth() === eDate.getUTCMonth()) {
                isMonthlyDetail = true;
                monthName = monthNames[sDate.getUTCMonth()];
            }
        }

        // Columnas
        const columns: Partial<ExcelJS.Column>[] = [
            { header: 'Tipo', key: 'tipo_marea', width: 10 },
            { header: 'Marea', key: 'nro_marea', width: 10 },
            { header: 'Año', key: 'anio_marea', width: 10 },
            { header: 'Buque', key: 'buque', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Pesquería', key: 'pesqueria', width: 20 },
            { header: 'Observador Principal', key: 'observador', width: 25 },
            { header: 'Contrato', key: 'contrato', width: 15 },
            { header: 'Tipo Obs.', key: 'tipo_observador', width: 15 },
        ];

        for (let i = 1; i <= maxExtraObservers; i++) {
            columns.push({ header: `Observador Adic. ${i}`, key: `obs_adic_${i}`, width: 25 });
        }

        columns.push({ header: 'Estado', key: 'estado', width: 20 });

        if (isMonthlyDetail) {
            columns.push({ header: `Días (${monthName})`, key: 'dias_calendario', width: 18 });
        } else {
            columns.push(
                { header: `Navegado en ${options.year}`, key: 'dias_calendario', width: 18 },
                { header: 'Navegado Total', key: 'dias_total', width: 18 },
                { header: 'Inicio', key: 'inicio', width: 15 },
                { header: 'Fin', key: 'fin', width: 15 },
            );
        }

        for (let i = 1; i <= maxEtapas; i++) {
            columns.push(
                { header: `Etapa ${i}: #`, key: `etapa_${i}_nro`, width: 10 },
                { header: `Etapa ${i}: Zarpada`, key: `etapa_${i}_zarpada`, width: 15 },
                { header: `Etapa ${i}: Arribo`, key: `etapa_${i}_arribo`, width: 15 },
                { header: `Etapa ${i}: Días`, key: `etapa_${i}_dias`, width: 10 }
            );
        }

        sheet.columns = columns;

        // Estilo cabecera
        const headerRow = sheet.getRow(1);
        headerRow.font = { bold: true };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E0E0' } };
        
        // Autofiltro
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: columns.length }
        };

        // Datos
        mareas.forEach(m => {
            const rowData = this.calculateMareaRowData(m, options);
            sheet.addRow({
                ...rowData,
                estado_label: m.estadoActual?.codigo === MareaEstado.EN_EJECUCION ? 'En ejecución' : 'Finalizada'
            });
        });
    }

    private calculateMareaRowData(m: any, options: any): any {
        const { yearStart, yearEnd, mode, daysCalculationMode, filterType, filterValue } = options;
        const now = DateUtils.getNow(true);
        const overallStart = m.etapas[0]?.fechaZarpada;
        const overallEnd = m.etapas[m.etapas.length - 1]?.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null);

        let calendarDays = 0;
        let totalMareaDays = 0;

        const intervals = m.etapas.map(e => ({
            start: e.fechaZarpada,
            end: e.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null)
        })).filter(i => i.start && i.start <= now);

        const calculationLimit = yearEnd < now ? yearEnd : now;
        const periodRange = mode === 'CALENDAR' ? { start: yearStart, end: yearEnd } : undefined;

        if (daysCalculationMode === 'SHIP') {
            calendarDays = DateUtils.calculateUniqueDays(intervals, periodRange, calculationLimit);
            totalMareaDays = DateUtils.calculateUniqueDays(intervals, undefined, now);
        } else {
            if (filterType === 'OBSERVER' && filterValue) {
                let obsIntervals: any[] = [];
                const isPrincipal = (m.observadorPrincipalId === filterValue);
                if (isPrincipal) {
                    obsIntervals = intervals;
                } else {
                    m.etapas.forEach(etapa => {
                        const isAdditional = etapa.observadores.some(rel => rel.observadorId === filterValue);
                        if (isAdditional) {
                            obsIntervals.push({
                                start: etapa.fechaZarpada,
                                end: etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null)
                            });
                        }
                    });
                }
                calendarDays = DateUtils.calculateUniqueDays(obsIntervals, periodRange, calculationLimit);
                totalMareaDays = DateUtils.calculateUniqueDays(obsIntervals, undefined, now);
            } else {
                let effortCal = DateUtils.calculateUniqueDays(intervals, periodRange, calculationLimit);
                let effortTotal = DateUtils.calculateUniqueDays(intervals, undefined, now);
                const additionalsMap: Record<string, any[]> = {};
                m.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada) return;
                    const start = etapa.fechaZarpada;
                    const end = etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? now : null);
                    etapa.observadores.forEach(obsRel => {
                        if (obsRel.observador && obsRel.observador.id !== m.observadorPrincipalId) {
                            if (!additionalsMap[obsRel.observador.id]) additionalsMap[obsRel.observador.id] = [];
                            additionalsMap[obsRel.observador.id].push({ start, end });
                        }
                    });
                });
                Object.values(additionalsMap).forEach(obsIntervals => {
                    effortCal += DateUtils.calculateUniqueDays(obsIntervals, periodRange, calculationLimit);
                    effortTotal += DateUtils.calculateUniqueDays(obsIntervals, undefined, now);
                });
                calendarDays = effortCal;
                totalMareaDays = effortTotal;
            }
        }

        const rowData: any = {
            tipo_marea: m.tipoMarea,
            nro_marea: m.nroMarea,
            anio_marea: m.anioMarea,
            buque: m.buque?.nombreBuque || 'Desconocido',
            flota: m.buque?.tipoFlota?.nombre || '-',
            pesqueria: filterType === FilterType.FISHERY
                ? filterValue
                : (m.etapas[0]?.pesqueria?.nombre || m.buque?.pesqueriaHabitual?.nombre || '-'),
            observador: m.observadorPrincipal ? `${m.observadorPrincipal.nombre} ${m.observadorPrincipal.apellido}` : 'Sin asignar',
            contrato: m.observadorPrincipal?.tipoContrato || '-',
            tipo_observador: m.observadorPrincipal?.tipoObservador || '-',
            estado: m.estadoActual?.nombre || 'Desconocido',
            dias_calendario: calendarDays,
            dias_total: totalMareaDays,
            inicio: DateUtils.formatDate(overallStart),
            fin: overallEnd ? DateUtils.formatDate(overallEnd) : (m.estadoActual?.codigo === 'EN_EJECUCION' ? 'En curso' : '-')
        };

        const extraObservers = new Set<string>();
        m.etapas.forEach(e => {
            e.observadores.forEach(obsRel => {
                const oid = obsRel.observadorId;
                if (m.observadorPrincipal && oid === m.observadorPrincipal.id) return;
                if (obsRel.observador) extraObservers.add(`${obsRel.observador.nombre} ${obsRel.observador.apellido}`);
            });
        });
        const extrasArray = Array.from(extraObservers);
        extrasArray.forEach((name, idx) => { rowData[`obs_adic_${idx + 1}`] = name; });

        m.etapas.forEach((e, idx) => {
            const i = idx + 1;
            rowData[`etapa_${i}_nro`] = e.nroEtapa;
            rowData[`etapa_${i}_zarpada`] = DateUtils.formatDate(e.fechaZarpada);
            rowData[`etapa_${i}_arribo`] = DateUtils.formatDate(e.fechaArribo);
            rowData[`etapa_${i}_dias`] = DateUtils.calculateInclusiveDays(e.fechaZarpada, e.fechaArribo);
        });

        return rowData;
    }

    private buildObserverDaysSheet(workbook: ExcelJS.Workbook, sheetName: string, mareas: any[], tipoMarea: TipoMarea, options: any) {
        const sheet = workbook.addWorksheet(sheetName);
        
        const columns: Partial<ExcelJS.Column>[] = [
            { header: 'Observador', key: 'observador', width: 30 },
            { header: 'Buque', key: 'buque', width: 25 },
            { header: 'Pesquería', key: 'pesqueria', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Año Marea', key: 'anio_marea', width: 12 },
            { header: 'Número Marea', key: 'nro_marea', width: 15 },
            { header: 'Cantidad Etapas', key: 'etapas_count', width: 15 },
            { header: 'Días Navegados', key: 'dias_navegados', width: 18 },
            { header: 'Estado', key: 'estado_label', width: 15 },
        ];

        sheet.columns = columns;

        // Estilo cabecera
        const headerRow = sheet.getRow(1);
        headerRow.font = { bold: true };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E0E0' } };

        // Autofiltro
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: columns.length }
        };

        // Filtrar por tipo y preparar datos
        const rowsReport: any[] = [];
        const filteredMareas = mareas.filter(m => m.tipoMarea === tipoMarea);

        filteredMareas.forEach(m => {
            const rowData = this.calculateMareaRowData(m, options);
            rowsReport.push({
                observador: rowData.observador,
                buque: rowData.buque,
                pesqueria: rowData.pesqueria,
                flota: rowData.flota,
                anio_marea: rowData.anio_marea,
                nro_marea: rowData.nro_marea,
                etapas_count: m.etapas.length,
                dias_navegados: rowData.dias_calendario,
                estado_label: m.estadoActual?.codigo === MareaEstado.EN_EJECUCION ? 'En ejecución' : 'Finalizada'
            });
        });

        // Ordenar alfabéticamente por Observador
        rowsReport.sort((a, b) => a.observador.localeCompare(b.observador));

        // Agregar filas
        rowsReport.forEach(row => sheet.addRow(row));
    }

    private buildSummarySheet(
        workbook: ExcelJS.Workbook,
        summaryMC: Map<string, { pesqueria: string; flota: string; mareas: number; etapas: number; dias: number }>,
        summaryCI: Map<string, { pesqueria: string; flota: string; mareas: number; etapas: number; dias: number }>
    ) {
        const sheet = workbook.addWorksheet('Resumen por Pesquería');
        sheet.getColumn(1).width = 30; // Pesquería
        sheet.getColumn(2).width = 30; // Flota
        sheet.getColumn(3).width = 20; // Cantidad Mareas
        sheet.getColumn(4).width = 20; // Cantidad Etapas
        sheet.getColumn(5).width = 20; // Total Días

        // Autofiltro para el resumen (cubriendo las primeras 2 columnas al menos)
        sheet.autoFilter = {
            from: { row: 3, column: 1 },
            to: { row: 3, column: 5 }
        };

        let currentRow = 2;
        if (summaryMC.size > 0) {
            currentRow = this.buildSummaryTable(sheet, 'Resumen de Mareas Comerciales (MC)', summaryMC, currentRow);
        }
        if (summaryCI.size > 0) {
            this.buildSummaryTable(sheet, 'Resumen de Campañas Institucionales (CI)', summaryCI, currentRow + 4);
        }
    }

    private buildSummaryTable(
        sheet: ExcelJS.Worksheet,
        title: string,
        data: Map<string, { pesqueria: string; flota: string; mareas: number; etapas: number; dias: number }>,
        startRow: number
    ): number {
        // Title
        sheet.mergeCells(startRow, 1, startRow, 5);
        const titleCell = sheet.getCell(startRow, 1);
        titleCell.value = title;
        titleCell.font = { bold: true, size: 14 };
        titleCell.alignment = { horizontal: 'center' };

        // Headers
        const headerRowIdx = startRow + 1;
        const headers = ['Pesquería', 'Flota', 'Cantidad Mareas', 'Cantidad Etapas', 'Total Días'];
        headers.forEach((h, i) => {
            const cell = sheet.getCell(headerRowIdx, i + 1);
            cell.value = h;
            cell.font = { bold: true, color: { argb: 'FFFFFF' } };
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: '2563EB' } };
            cell.alignment = { horizontal: 'center' };
            cell.border = { top: { style: 'thin' }, left: { style: 'thin' }, bottom: { style: 'thin' }, right: { style: 'thin' } };
        });

        // Aplicar autofiltro a la primera tabla encontrada
        if (startRow === 2) {
            sheet.autoFilter = {
                from: { row: headerRowIdx, column: 1 },
                to: { row: headerRowIdx, column: headers.length }
            };
        }

        // Rows
        let currentRowIdx = headerRowIdx + 1;
        const sortedData = Array.from(data.values()).sort((a, b) => {
            if (a.pesqueria !== b.pesqueria) return a.pesqueria.localeCompare(b.pesqueria);
            return a.flota.localeCompare(b.flota);
        });

        sortedData.forEach(row => {
            const r = sheet.getRow(currentRowIdx);
            r.values = [row.pesqueria, row.flota, row.mareas, row.etapas, row.dias];
            for (let c = 1; c <= 5; c++) {
                r.getCell(c).border = { top: { style: 'thin' }, left: { style: 'thin' }, bottom: { style: 'thin' }, right: { style: 'thin' } };
            }
            currentRowIdx++;
        });

        // Totals
        const totalRowIdx = currentRowIdx;
        const totalRow = sheet.getRow(totalRowIdx);
        totalRow.getCell(1).value = 'TOTALES';
        totalRow.getCell(3).value = { formula: `SUM(C${headerRowIdx + 1}:C${currentRowIdx - 1})` };
        totalRow.getCell(4).value = { formula: `SUM(D${headerRowIdx + 1}:D${currentRowIdx - 1})` };
        totalRow.getCell(5).value = { formula: `SUM(E${headerRowIdx + 1}:E${currentRowIdx - 1})` };

        for (let c = 1; c <= 5; c++) {
            const cell = totalRow.getCell(c);
            cell.font = { bold: true };
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
            cell.border = { top: { style: 'thin' }, left: { style: 'thin' }, bottom: { style: 'thin' }, right: { style: 'thin' } };
        }

        return totalRowIdx;
    }

    async getMareaDistribution(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean = true,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ): Promise<MareaDistributionItem[]> {
        const yearStart = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        if (startDate) yearStart.setUTCHours(0, 0, 0, 0);
        if (endDate) yearEnd.setUTCHours(23, 59, 59, 999);

        // Optional protocolization range
        let protStart: Date | undefined;
        let protEnd: Date | undefined;
        if (protocolizationStartDate) {
            protStart = new Date(protocolizationStartDate);
            protStart.setUTCHours(0, 0, 0, 0);
        }
        if (protocolizationEndDate) {
            protEnd = new Date(protocolizationEndDate);
            protEnd.setUTCHours(23, 59, 59, 999);
        }

        const where = this.getSharedWhereClause(
            yearStart,
            yearEnd,
            includeNonProtocolized,
            includeProtocolizedOutOfPeriod,
            protStart,
            protEnd
        );

        if (!includeCampaigns) {
            where.tipoMarea = { not: TipoMarea.CI };
        }

        const mareas = await this.prisma.marea.findMany({
            where,
            include: {
                buque: {
                    include: {
                        pesqueriaHabitual: true,
                        tipoFlota: true
                    }
                },
                pesqueria: true,
                observadorPrincipal: true,
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        pesqueria: true,
                        observadores: { include: { observador: true } }
                    }
                }
            }
        });

        const items: MareaDistributionItem[] = [];

        for (const marea of mareas) {
            for (const etapa of marea.etapas) {
                if (!etapa.fechaZarpada) continue;

                let zarpada = new Date(etapa.fechaZarpada);
                let arribo = etapa.fechaArribo ? new Date(etapa.fechaArribo) : (marea.estadoActual?.codigo === 'EN_EJECUCION' ? DateUtils.getNow() : null);

                // Si estamos en modo CALENDAR, recortamos los días fuera del año seleccionado
                if (mode === 'CALENDAR') {
                    if (zarpada < yearStart) zarpada = new Date(yearStart);
                    if (arribo && arribo > yearEnd) arribo = new Date(yearEnd);
                }

                // Verificar solapamiento tras recorte
                if (zarpada > yearEnd || (arribo && arribo < yearStart)) continue;

                items.push({
                    mareaId: marea.id,
                    id_marea: MareaUtils.formatCodigo(marea),
                    buque: marea.buque?.nombreBuque || 'Desconocido',
                    flota: marea.buque?.tipoFlota?.nombre || 'Desconocida',
                    pesqueria: etapa.pesqueria?.nombre || marea.pesqueria?.nombre || marea.buque?.pesqueriaHabitual?.nombre || 'Desconocida',
                    pesqueriaId: etapa.pesqueriaId || marea.pesqueriaId,
                    nroEtapa: etapa.nroEtapa,
                    fechaZarpada: zarpada,
                    fechaArribo: arribo,
                    observador: marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin asignar',
                    tipoMarea: marea.tipoMarea
                });
            }
        }

        // Ordenamiento: Por fecha de zarpada y luego por buque
        return items.sort((a, b) => {
            const dateA = new Date(a.fechaZarpada).getTime();
            const dateB = new Date(b.fechaZarpada).getTime();
            if (dateA !== dateB) return dateA - dateB;
            return a.buque.localeCompare(b.buque);
        });
    }

    async getUniqueVesselsCount(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean = true,
        startDate?: string,
        endDate?: string,
        fisheryName?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string,
    ): Promise<UniqueVesselsResult> {
        const yearStart = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        if (startDate) yearStart.setUTCHours(0, 0, 0, 0);
        if (endDate) yearEnd.setUTCHours(23, 59, 59, 999);

        // Optional protocolization range
        let protStart: Date | undefined;
        let protEnd: Date | undefined;
        if (protocolizationStartDate) {
            protStart = new Date(protocolizationStartDate);
            protStart.setUTCHours(0, 0, 0, 0);
        }
        if (protocolizationEndDate) {
            protEnd = new Date(protocolizationEndDate);
            protEnd.setUTCHours(23, 59, 59, 999);
        }

        const where = this.getSharedWhereClause(
            yearStart,
            yearEnd,
            includeNonProtocolized,
            includeProtocolizedOutOfPeriod,
            protStart,
            protEnd
        );

        if (!includeCampaigns) {
            where.tipoMarea = { not: TipoMarea.CI };
        }

        const mareas = await this.prisma.marea.findMany({
            where,
            include: {
                buque: {
                    include: { tipoFlota: true }
                },
                etapas: {
                    include: { pesqueria: true },
                    orderBy: { nroEtapa: 'asc' }
                },
                estadoActual: true
            }
        });

        const now = DateUtils.getNow(true);
        const uniqueVesselsTotal = new Set<string>();

        // Track vessels and days per month/fleet
        // monthlyVesselsMap[monthIndex][fleetName] = { vessels: Set<string>, days: number }
        const monthlyDataMap = new Array(12).fill(null).map(() => ({} as Record<string, { vessels: Set<string>, days: number }>));

        const effectivePeriodEnd = yearEnd < now ? yearEnd : now;

        for (const marea of mareas) {
            const fleetName = marea.buque?.tipoFlota?.nombre || 'Desconocida';

            for (const etapa of marea.etapas) {
                if (!etapa.fechaZarpada) continue;

                const zarpadaOriginal = new Date(etapa.fechaZarpada);
                const arriboOriginal = etapa.fechaArribo ? new Date(etapa.fechaArribo) : (marea.estadoActual?.codigo === 'EN_EJECUCION' ? now : null);

                let zarpada = new Date(zarpadaOriginal);
                let arribo = arriboOriginal ? new Date(arriboOriginal) : null;

                if (mode === 'CALENDAR') {
                    if (zarpada < yearStart) zarpada = new Date(yearStart);
                    if (arribo && arribo > yearEnd) arribo = new Date(yearEnd);
                }

                if (zarpada > effectivePeriodEnd || (arribo && arribo < yearStart)) continue;

                if (fisheryName) {
                    const etapaPesqueria = etapa.pesqueria?.nombre || 'Desconocida';
                    if (!etapaPesqueria.toUpperCase().includes(fisheryName.toUpperCase())) continue;
                }

                uniqueVesselsTotal.add(marea.buqueId);

                // Determine monthly activity and sum days
                const s = zarpada > yearStart ? zarpada : yearStart;
                const e = (arribo && arribo < effectivePeriodEnd) ? arribo : effectivePeriodEnd;

                let cursor = new Date(Date.UTC(s.getUTCFullYear(), s.getUTCMonth(), s.getUTCDate()));
                const last = new Date(Date.UTC(e.getUTCFullYear(), e.getUTCMonth(), e.getUTCDate()));

                while (cursor <= last) {
                    if (cursor.getUTCFullYear() === year) {
                        const monthIdx = cursor.getUTCMonth();
                        if (!monthlyDataMap[monthIdx][fleetName]) {
                            monthlyDataMap[monthIdx][fleetName] = { vessels: new Set<string>(), days: 0 };
                        }
                        monthlyDataMap[monthIdx][fleetName].vessels.add(marea.buqueId);
                        monthlyDataMap[monthIdx][fleetName].days++;
                    }
                    cursor.setUTCDate(cursor.getUTCDate() + 1);
                }
            }
        }

        return {
            count: uniqueVesselsTotal.size,
            monthly: monthlyDataMap.map((fleetMap, index) => {
                const monthlySet = new Set<string>();
                let totalMonthDays = 0;
                const fleetsArr = Object.entries(fleetMap).map(([name, data]) => {
                    data.vessels.forEach(id => monthlySet.add(id));
                    totalMonthDays += data.days;
                    return { name, count: data.vessels.size, days: data.days };
                });

                return {
                    month: index + 1,
                    count: monthlySet.size,
                    days: totalMonthDays,
                    fleets: fleetsArr.sort((a, b) => b.count - a.count)
                };
            })
        };
    }

    private async getCoverageExportWorkbook(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean = true,
        startDate?: string,
        endDate?: string,
        fisheryName?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string,
    ): Promise<ExcelJS.Workbook> {
        const coverage = await this.getUniqueVesselsCount(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, includeCampaigns, startDate, endDate, fisheryName, protocolizationStartDate, protocolizationEndDate
        );
        let requirements = await this.planificacion.getRequerimientosPorAnio(year);

        if (fisheryName) {
            requirements = requirements.filter(r => r.pesqueria?.nombre.toLowerCase().includes(fisheryName.toLowerCase()));
        }

        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet('Cobertura Mensual');

        sheet.columns = [
            { header: 'Mes', key: 'mes', width: 15 },
            { header: 'Flota', key: 'flota', width: 25 },
            { header: 'Buques Cubiertos', key: 'cubiertos', width: 20 },
            { header: 'Buques Requeridos', key: 'requeridos', width: 20 },
            { header: 'Diferencia', key: 'diferencia', width: 15 },
            { header: '% Cobertura', key: 'porcentaje', width: 15 },
            { header: 'Días de Marea', key: 'dias', width: 20 },
        ];

        sheet.getRow(1).font = { bold: true };
        sheet.getRow(1).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E0E0' } };

        const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

        coverage.monthly.forEach(month => {
            const monthName = monthNames[month.month - 1];
            
            // Si hay desglose por flota en los datos de cobertura
            if (month.fleets && month.fleets.length > 0) {
                month.fleets.forEach(fleet => {
                    const req = requirements.find(r => r.mes === month.month && r.tipoFlota?.nombre === fleet.name);
                    const requeridos = req?.cantidad || 0;
                    const diferencia = fleet.count - requeridos;
                    const porcentaje = requeridos > 0 ? (fleet.count / requeridos) * 100 : 0;

                    sheet.addRow({
                        mes: monthName,
                        flota: fleet.name,
                        cubiertos: fleet.count,
                        requeridos: requeridos,
                        diferencia: diferencia,
                        porcentaje: `${porcentaje.toFixed(1)}%`,
                        dias: fleet.days
                    });
                });
            } else {
                // Si no hay desglose, fila sumaria del mes
                const totalReq = requirements.filter(r => r.mes === month.month).reduce((acc, r) => acc + (r.cantidad || 0), 0);
                const diferencia = month.count - totalReq;
                const porcentaje = totalReq > 0 ? (month.count / totalReq) * 100 : 0;

                sheet.addRow({
                    mes: monthName,
                    flota: 'TODAS',
                    cubiertos: month.count,
                    requeridos: totalReq,
                    diferencia: diferencia,
                    porcentaje: `${porcentaje.toFixed(1)}%`,
                    dias: month.days
                });
            }
        });

        // Aplicar estilos condicionales a la columna de diferencia
        sheet.eachRow((row, rowNumber) => {
            if (rowNumber === 1) return;
            const diffCell = row.getCell('diferencia');
            const diffValue = diffCell.value as number;
            if (diffValue < 0) {
                diffCell.font = { color: { argb: 'FFFF0000' }, bold: true };
            } else if (diffValue > 0) {
                diffCell.font = { color: { argb: 'FF008000' }, bold: true };
            }
        });

        // Autofiltro
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: 7 }
        };

        return workbook;
    }

    private async getChartDataExportWorkbook(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean,
        chartType: string,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string,
    ): Promise<ExcelJS.Workbook> {
        const stats = await this.getDashboardStats(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, 'SHIP', includeCampaigns, startDate, endDate, protocolizationStartDate, protocolizationEndDate
        );

        let headers: { header: string; key: string; width: number }[] = [];
        let rows: any[] = [];
        let sheetName = 'Datos';

        switch (chartType) {
            case 'CHART_TREND':
                sheetName = 'Tendencia Mensual';
                headers = [
                    { header: 'Mes', key: 'label', width: 20 },
                    { header: 'Mareas Iniciadas', key: 'mareas', width: 20 },
                    { header: 'Días Navegados', key: 'days', width: 20 },
                ];
                const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
                rows = stats.monthly.mareas.map((count, i) => ({
                    label: monthNames[i],
                    mareas: count,
                    days: stats.monthly.days[i]
                }));
                break;

            case 'CHART_FLEET':
                sheetName = 'Distribución por Flota';
                headers = [
                    { header: 'Flota', key: 'name', width: 30 },
                    { header: 'Mareas', key: 'mareas', width: 15 },
                    { header: 'Días Navegados', key: 'days', width: 20 },
                ];
                rows = stats.fleets;
                break;

            case 'CHART_FISHERY':
            case 'CHART_FISHERY_DUAL':
                sheetName = 'Participación por Pesquería';
                headers = [
                    { header: 'Pesquería', key: 'name', width: 30 },
                    { header: 'Mareas', key: 'mareas', width: 15 },
                    { header: 'Días Navegados', key: 'days', width: 20 },
                ];
                rows = stats.fisheries;
                break;

            case 'CHART_OBSERVER':
                sheetName = 'Ranking Observadores';
                headers = [
                    { header: 'Observador', key: 'name', width: 40 },
                    { header: 'Mareas', key: 'mareas', width: 15 },
                    { header: 'Días Navegados', key: 'days', width: 20 },
                ];
                rows = stats.observers;
                break;
        }

        return this.createGenericWorkbook(sheetName, headers, rows);
    }

    private createGenericWorkbook(sheetName: string, headers: { header: string; key: string; width: number }[], rows: any[]): ExcelJS.Workbook {
        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet(sheetName);

        sheet.columns = headers;

        // Header Style
        sheet.getRow(1).font = { bold: true, color: { argb: 'FFFFFF' } };
        sheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: '4472C4' }
        };
        sheet.getRow(1).alignment = { horizontal: 'center' };

        // Add Rows
        rows.forEach(row => {
            sheet.addRow(row);
        });

        // Alternating row colors
        sheet.eachRow((row, rowNumber) => {
            if (rowNumber > 1 && rowNumber % 2 === 0) {
                row.fill = {
                    type: 'pattern',
                    pattern: 'solid',
                    fgColor: { argb: 'F2F2F2' }
                };
            }
        });

        // Auto filter
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: headers.length }
        };



        return workbook;
    }

    private buildObserverSummarySheet(workbook: ExcelJS.Workbook, sheetName: string, mareas: any[], tipoMarea: TipoMarea, options: any) {
        const sheet = workbook.addWorksheet(sheetName);
        
        const columns: Partial<ExcelJS.Column>[] = [
            { header: 'Observador', key: 'observador', width: 30 },
            { header: 'Pesquería', key: 'pesqueria', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Cantidad de mareas', key: 'mareas_count', width: 18 },
            { header: 'Cantidad etapas', key: 'etapas_count', width: 18 },
            { header: 'Cantidad total de días', key: 'total_dias', width: 20 },
            { header: 'Detalle mareas', key: 'detalle_mareas', width: 50 },
        ];

        sheet.columns = columns;

        // Estilo cabecera
        const headerRow = sheet.getRow(1);
        headerRow.font = { bold: true };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E0E0' } };

        // Autofiltro
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: columns.length }
        };

        // Agrupación y preparación de datos
        const summaryMap = new Map<string, any>();
        const filteredMareas = mareas.filter(m => m.tipoMarea === tipoMarea);

        filteredMareas.forEach(m => {
            const rowData = this.calculateMareaRowData(m, options);
            const key = `${rowData.observador}|${rowData.pesqueria}|${rowData.flota}`;
            
            if (!summaryMap.has(key)) {
                summaryMap.set(key, {
                    observador: rowData.observador,
                    pesqueria: rowData.pesqueria,
                    flota: rowData.flota,
                    mareas_count: 0,
                    etapas_count: 0,
                    total_dias: 0,
                    mareas_list: [] as { nro: number, anio: number }[]
                });
            }

            const current = summaryMap.get(key)!;
            current.mareas_count += 1;
            current.etapas_count += m.etapas.length;
            current.total_dias += rowData.dias_calendario;
            current.mareas_list.push({ nro: m.nroMarea, anio: m.anioMarea });
        });

        // Convertir Map a Array y procesar detalles
        const rowsReport = Array.from(summaryMap.values()).map(item => {
            // Ordenar mareas cronológicamente
            item.mareas_list.sort((a, b) => {
                if (a.anio !== b.anio) return a.anio - b.anio;
                return a.nro - b.nro;
            });

            const detalle = item.mareas_list
                .map(ml => `${String(ml.nro).padStart(2, '0')}/${ml.anio}`)
                .join(' - ');

            return {
                ...item,
                detalle_mareas: detalle
            };
        });

        // Ordenar alfabéticamente por Observador, Pesquería, Flota
        rowsReport.sort((a, b) => {
            const obsCompare = a.observador.localeCompare(b.observador);
            if (obsCompare !== 0) return obsCompare;
            const pesqCompare = a.pesqueria.localeCompare(b.pesqueria);
            if (pesqCompare !== 0) return pesqCompare;
            return a.flota.localeCompare(b.flota);
        });

        // Agregar filas
        rowsReport.forEach(row => sheet.addRow(row));
    }

    private buildInstitucionalesSheet(workbook: ExcelJS.Workbook, mareas: any[], options: any) {
        const sheet = workbook.addWorksheet('Campañas Institucionales');
        const ciMareas = mareas.filter(m => m.tipoMarea === TipoMarea.CI);

        // Determinar max etapas
        let maxEtapas = 0;
        ciMareas.forEach(m => {
            if (m.etapas.length > maxEtapas) maxEtapas = m.etapas.length;
        });

        // Columnas Base
        const columns: Partial<ExcelJS.Column>[] = [
            { header: 'Buque', key: 'buque', width: 25 },
            { header: 'Pesquería', key: 'pesqueria', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Año', key: 'anio_marea', width: 10 },
            { header: 'Marea', key: 'nro_marea', width: 10 },
            { header: `Navegado en ${options.year}`, key: 'dias_calendario', width: 18 },
            { header: 'Navegado Total', key: 'dias_total', width: 18 },
            { header: 'Estado', key: 'estado_label', width: 20 },
        ];

        // Columnas Dinámicas para Etapas
        for (let i = 1; i <= maxEtapas; i++) {
            columns.push(
                { header: `Etapa ${i}: #`, key: `etapa_${i}_nro`, width: 12 },
                { header: `Etapa ${i}: Días`, key: `etapa_${i}_dias`, width: 12 }
            );
        }

        sheet.columns = columns;

        // Estilo cabecera
        const headerRow = sheet.getRow(1);
        headerRow.font = { bold: true };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E0E0' } };

        // Autofiltro
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: columns.length }
        };

        // Ordenar CI cronológicamente (Año y Nro)
        const sortedCI = ciMareas.sort((a, b) => {
            if (a.anioMarea !== b.anioMarea) return a.anioMarea - b.anioMarea;
            return a.nroMarea - b.nroMarea;
        });

        // Datos
        sortedCI.forEach(m => {
            const rowData = this.calculateMareaRowData(m, options);
            sheet.addRow({
                ...rowData,
                estado_label: m.estadoActual?.codigo === MareaEstado.EN_EJECUCION ? 'En ejecución' : 'Finalizada'
            });
        });
    }

    private async getWorkforceExportWorkbook(filterValue?: string): Promise<ExcelJS.Workbook> {
        // 1. Obtener datos unificados desde MareasService (Misma fuente que el Dashboard)
        const workforce = await this.mareasService.getWorkforceStatus();

        // Filtrado dinámico de técnicos usando el parámetro filterValue existente
        // El frontend enviará 'ONLY_OBSERVERS' si el filtro de técnicos está desactivado
        if (filterValue === 'ONLY_OBSERVERS') {
            workforce.listNavegando = workforce.listNavegando.filter(obs => obs.tipoObservador !== 'TECNICO');
            workforce.listDescanso = workforce.listDescanso.filter(obs => obs.tipoObservador !== 'TECNICO');
            workforce.listDisponibles = workforce.listDisponibles.filter(obs => obs.tipoObservador !== 'TECNICO');
            workforce.listImpedidos = workforce.listImpedidos.filter(obs => obs.tipoObservador !== 'TECNICO');
        }

        // 2. Aplanar las listas para el reporte Excel
        // Combinamos las listas y asignamos etiquetas/órdenes específicos
        const rawData = [
            ...workforce.listNavegando.map(item => ({ ...item, status: 'NAVEGANDO', statusLabel: 'Navegando', order: 1 })),
            ...workforce.listDescanso.map(item => ({ ...item, status: 'DESCANSO', statusLabel: 'En Descanso', order: 2 })),
            ...workforce.listDisponibles.map(item => ({ ...item, status: 'DISPONIBLE', statusLabel: 'Disponible', order: 3 })),
            ...workforce.listImpedidos.map(item => ({ ...item, status: 'IMPEDIDO', statusLabel: 'Impedidos', order: 4, days: 0 as number }))
        ];

        // 3. Jerarquía interna: Titular Masc (1) > Femenino (2) > Eventual Masc (3)
        const getInternalOrder = (item: any) => {
            if (item.sexo === Sexo.Femenino) return 2;
            if (item.eventual === true) return 3;
            return 1;
        };

        // 4. Ordenar: Por estado (order) y luego por jerarquía interna, finalmente por nombre
        rawData.sort((a, b) => {
            if (a.order !== b.order) return a.order - b.order;
            const orderA = getInternalOrder(a);
            const orderB = getInternalOrder(b);
            if (orderA !== orderB) return orderA - orderB;
            return a.name.localeCompare(b.name);
        });

        // 5. Crear Excel
        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet('Dotación de Personal');

        sheet.columns = [
            { header: 'ESTADO', key: 'statusLabel', width: 15 },
            { header: 'CONDICIÓN', key: 'condicion', width: 15 },
            { header: 'APELLIDO Y NOMBRE', key: 'name', width: 35 },
            { header: 'TIPO', key: 'tipoObservador', width: 15 },
            { header: 'DÍAS NAVEGADOS', key: 'daysNav', width: 18 },
            { header: 'DÍAS INACTIVO', key: 'daysInact', width: 15 },
            { header: 'BUQUE', key: 'vessel', width: 25 },
            { header: 'MAREA', key: 'mareaCode', width: 15 },
            { header: 'PESQUERÍA', key: 'fishery', width: 25 },
            { header: 'SEXO', key: 'sexo', width: 12 },
            { header: 'OBSERVACIONES', key: 'observaciones', width: 40 },
        ];

        // Estilos de Cabecera (Deep Ocean / Professional Clean Style)
        sheet.getRow(1).font = { bold: true, color: { argb: 'FFFFFF' } };
        sheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: '1E293B' },
        };

        // 5. Agregar Filas con lógica de estilos
        rawData.forEach((item) => {
            const isNav = item.status === 'NAVEGANDO';
            const isDry = item.status === 'DESCANSO' || item.status === 'DISPONIBLE'; // Sin impedidos

            // Determinar texto condensado de condición
            const condiciones: string[] = [];
            if ((item as any).tieneDesignacionActiva) condiciones.push('Designado/a');
            if ((item as any).eventual) condiciones.push('Eventual');
            if ((item as any).sexo === Sexo.Femenino) condiciones.push('Mujer');

            const row = sheet.addRow({
                statusLabel: item.statusLabel,
                condicion: condiciones.join(' + '),
                name: item.name,
                tipoObservador: item.tipoObservador,
                daysNav: isNav ? item.days : '',
                daysInact: isDry ? item.days : '',
                vessel: (item as any).vessel || (item as any).vesselName || '',
                mareaCode: (item as any).mareaCode || '',
                fishery: (item as any).fishery || '',
                sexo: (item as any).sexo || '',
                observaciones: item.observaciones || '',
            });

            // Estilos de celda de estado
            const statusCell = row.getCell(1);
            let statusColor = 'F1F5F9'; // Default Gray
            if (item.status === 'NAVEGANDO') statusColor = 'E0F2FE'; // Celeste (Cian suave)
            if (item.status === 'DESCANSO') statusColor = 'F0FDF4';   // Verde menta suave
            if (item.status === 'DISPONIBLE') statusColor = 'DCFCE7'; // Verde esmeralda suave
            if (item.status === 'IMPEDIDO') statusColor = 'FECACA';   // Rojo más intenso (Red 200)

            statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: statusColor } };
            statusCell.font = { bold: true };

            // Resaltar observadores con impedimento (fila completa en rojo muy tenue)
            if (item.status === 'IMPEDIDO') {
                row.eachCell((cell) => {
                    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FEF2F2' } };
                });
            }

            // Resaltar DESIGNADOS (Toda la fila en cian suave si ya tienen buque/marea pero no están navegando)
            if ((item as any).tieneDesignacionActiva && item.status !== 'NAVEGANDO') {
                row.eachCell((cell) => {
                    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'E0F2FE' } };
                });
                statusCell.font = { bold: true, italic: true };
            }

            // Coloreado por género (Femenino: rosa tenue) o condición (Eventual: gris tenue)
            if ((item as any).sexo === Sexo.Femenino) {
                row.eachCell((cell, colNumber) => {
                    // No sobreescribir la columna de estado si ya tiene color específico
                    if (colNumber > 1) {
                         // Solo pintar si no tiene ya un color de impedimento/designado
                         if (cell.fill?.type !== 'pattern') {
                            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FDF2F8' } };
                         }
                    }
                });
            } else if ((item as any).eventual === true) {
                row.eachCell((cell, colNumber) => {
                    if (colNumber > 1) {
                         if (cell.fill?.type !== 'pattern') {
                            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'F1F5F9' } };
                         }
                    }
                });
            }

            // Estilo por género o condición aplicado anteriormente
        });

        // 6. Configuración final de la hoja - Rango completo para que funcione el filtro
        sheet.autoFilter = `A1:K${sheet.rowCount}`;

        // Bordes suaves
        sheet.eachRow((row) => {
            row.eachCell((cell) => {
                cell.border = {
                    top: { style: 'thin', color: { argb: 'E2E8F0' } },
                    left: { style: 'thin', color: { argb: 'E2E8F0' } },
                    bottom: { style: 'thin', color: { argb: 'E2E8F0' } },
                    right: { style: 'thin', color: { argb: 'E2E8F0' } }
                };
            });
        });

        // Inmovilizar cabecera
        sheet.views = [
            { state: 'frozen', xSplit: 0, ySplit: 1 }
        ];

        return workbook;
    }

}
