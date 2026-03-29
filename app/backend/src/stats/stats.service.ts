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

        if (filterType === 'AUDIT') {
            return this.getAuditExportWorkbook(
                year,
                mode,
                includeNonProtocolized,
                includeProtocolizedOutOfPeriod,
                includeCampaigns,
                startDate,
                endDate,
                protocolizationStartDate,
                protocolizationEndDate
            );
        }

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

        // Hoja Resumen Total por Observador
        this.buildObserverTotalSummarySheet(workbook, mareasFiltradas, {
            year,
            yearStart,
            yearEnd,
            mode,
            daysCalculationMode
        });

        // Inmovilizar primera fila en todas las hojas
        workbook.eachSheet((sheet) => {
            // Solo si tiene al menos una fila y no es la de resumen por pesquería que tiene un header especial
            if (sheet.name !== 'Resumen por Pesquería') {
                sheet.views = [
                    { state: 'frozen', xSplit: 0, ySplit: 1, topLeftCell: 'A2', activeCell: 'A2' }
                ];
            } else {
                // Para la hoja de resumen, inmovilizamos después del título de la tabla (fila 3 es el header)
                // Pero el usuario pidió "todos los excels que tengan los encabezados en la primera fila"
                // Así que mantenemos la lógica general. Si en el futuro se quiere algo diferente para el resumen se ajustará.
                sheet.views = [
                    { state: 'frozen', xSplit: 0, ySplit: 3, topLeftCell: 'A4', activeCell: 'A4' }
                ];
            }
        });

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
        headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF2563EB' } }; // Azul Corporativo (Primary)

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

        // Fila de Totales (Solo si hay datos)
        if (mareas.length > 0) {
            const totalRowNumber = mareas.length + 2;
            const totalRow = sheet.getRow(totalRowNumber);
            totalRow.getCell(1).value = 'TOTAL';

            // Determinar columnas de días
            let calCol = 10 + maxExtraObservers + 1;
            totalRow.getCell(calCol).value = { formula: `SUM(${sheet.getColumn(calCol).letter}2:${sheet.getColumn(calCol).letter}${totalRowNumber - 1})` };

            if (!isMonthlyDetail) {
                let totalCol = calCol + 1;
                totalRow.getCell(totalCol).value = { formula: `SUM(${sheet.getColumn(totalCol).letter}2:${sheet.getColumn(totalCol).letter}${totalRowNumber - 1})` };
            }

            // Estilo unificado
            const maxCol = columns.length;
            for (let c = 1; c <= maxCol; c++) {
                const cell = totalRow.getCell(c);
                cell.font = { bold: true };
                cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    right: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    bottom: { style: 'thin', color: { argb: 'FFD4D4D4' } }
                };
            }
        }
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
        headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF2563EB' } }; // Azul Corporativo (Primary)

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

        // Fila de Totales (Solo si hay datos)
        if (rowsReport.length > 0) {
            const totalRowNumber = rowsReport.length + 2;
            const totalRow = sheet.getRow(totalRowNumber);
            totalRow.getCell(1).value = 'TOTAL';
            // Columna G (7) es Cantidad Etapas, Columna H (8) es Días Navegados
            totalRow.getCell(7).value = { formula: `SUM(G2:G${totalRowNumber - 1})` };
            totalRow.getCell(8).value = { formula: `SUM(H2:H${totalRowNumber - 1})` };

            // Estilo unificado (de Resumen por Pesquería)
            const maxCol = columns.length;
            for (let c = 1; c <= maxCol; c++) {
                const cell = totalRow.getCell(c);
                cell.font = { bold: true };
                cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    right: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    bottom: { style: 'thin', color: { argb: 'FFD4D4D4' } }
                };
            }
        }
    }

    private buildObserverTotalSummarySheet(workbook: ExcelJS.Workbook, mareas: any[], options: any) {
        const sheet = workbook.addWorksheet('Resumen Total por Observador');

        const columns: Partial<ExcelJS.Column>[] = [
            { header: 'Observador', key: 'observador', width: 40 },
            { header: 'Días Navegados', key: 'dias_navegados', width: 25 },
        ];

        sheet.columns = columns;

        // Estilo cabecera
        const headerRow = sheet.getRow(1);
        headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF2563EB' } }; // Azul Corporativo (Primary)

        // Autofiltro
        sheet.autoFilter = {
            from: { row: 1, column: 1 },
            to: { row: 1, column: columns.length }
        };

        // Agrupar por observador (usando días del periodo)
        const observerMap = new Map<string, number>();

        mareas.forEach(m => {
            const rowData = this.calculateMareaRowData(m, options);
            const mainObserver = rowData.observador || 'Sin Observador';

            // Sumar días del observador principal
            const currentDays = observerMap.get(mainObserver) || 0;
            observerMap.set(mainObserver, currentDays + (rowData.dias_calendario || 0));

            // Sumar días para observadores adicionales si existen
            const extraObservers = new Set<string>();
            m.etapas.forEach(e => {
                e.observadoresAdicionales?.forEach(oa => {
                    const name = `${oa.observador.apellido}, ${oa.observador.nombre}`;
                    if (name !== mainObserver) extraObservers.add(name);
                });
            });

            extraObservers.forEach(name => {
                const currentExtraDays = observerMap.get(name) || 0;
                observerMap.set(name, currentExtraDays + (rowData.dias_calendario || 0));
            });
        });

        // Convertir a array para ordenar
        const list = Array.from(observerMap.entries()).map(([name, days]) => ({
            observador: name,
            dias_navegados: days
        }));

        // Ordenar alfabéticamente por Observador
        list.sort((a, b) => a.observador.localeCompare(b.observador));

        // Agregar filas
        list.forEach(row => sheet.addRow(row));

        // Fila de Totales (Solo si hay datos)
        if (list.length > 0) {
            const totalRowNumber = list.length + 2;
            const totalRow = sheet.getRow(totalRowNumber);
            totalRow.getCell(1).value = 'TOTAL';
            totalRow.getCell(2).value = { formula: `SUM(B2:B${totalRowNumber - 1})` };

            // Estilo unificado (de Resumen por Pesquería)
            const maxCol = columns.length;
            for (let c = 1; c <= maxCol; c++) {
                const cell = totalRow.getCell(c);
                cell.font = { bold: true };
                cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    right: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    bottom: { style: 'thin', color: { argb: 'FFD4D4D4' } }
                };
            }
        }
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
        sheet.getColumn(5).width = 20; // Días navegados

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
        const headers = ['Pesquería', 'Flota', 'Cantidad Mareas', 'Cantidad Etapas', 'Días navegados'];
        headers.forEach((h, i) => {
            const cell = sheet.getCell(headerRowIdx, i + 1);
            cell.value = h;
            cell.font = { bold: true, color: { argb: 'FFFFFF' } };
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: '2563EB' } };
            cell.alignment = { horizontal: 'center' };
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
            currentRowIdx++;
        });

        // Totals
        const totalRowIdx = currentRowIdx;
        const totalRow = sheet.getRow(totalRowIdx);
        totalRow.getCell(1).value = 'TOTALES';
        totalRow.getCell(3).value = { formula: `SUM(C${headerRowIdx + 1}:C${currentRowIdx - 1})` };
        totalRow.getCell(4).value = { formula: `SUM(D${headerRowIdx + 1}:D${currentRowIdx - 1})` };
        totalRow.getCell(5).value = { formula: `SUM(E${headerRowIdx + 1}:E${currentRowIdx - 1})` };

        const maxCol = headers.length;
        for (let c = 1; c <= maxCol; c++) {
            const cell = totalRow.getCell(c);
            cell.font = { bold: true };
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
            cell.border = {
                top: { style: 'thin' },
                left: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                right: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                bottom: { style: 'thin', color: { argb: 'FFD4D4D4' } }
            };
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
        headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF2563EB' } }; // Azul Corporativo (Primary)

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

        // Fila de Totales (Solo si hay datos)
        if (rowsReport.length > 0) {
            const totalRowNumber = rowsReport.length + 2;
            const totalRow = sheet.getRow(totalRowNumber);
            totalRow.getCell(1).value = 'TOTAL';
            // Columna D (4) es Cantidad Mareas, Columna E (5) es Cantidad Etapas, Columna F (6) es Cantidad Total de Días
            totalRow.getCell(4).value = { formula: `SUM(D2:D${totalRowNumber - 1})` };
            totalRow.getCell(5).value = { formula: `SUM(E2:E${totalRowNumber - 1})` };
            totalRow.getCell(6).value = { formula: `SUM(F2:F${totalRowNumber - 1})` };

            // Estilo unificado (de Resumen por Pesquería)
            const maxCol = columns.length;
            for (let c = 1; c <= maxCol; c++) {
                const cell = totalRow.getCell(c);
                cell.font = { bold: true };
                cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    right: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    bottom: { style: 'thin', color: { argb: 'FFD4D4D4' } }
                };
            }
        }
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
        headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
        headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF2563EB' } }; // Azul Corporativo (Primary)

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

        // Fila de Totales (Solo si hay datos)
        if (ciMareas.length > 0) {
            const totalRowNumber = ciMareas.length + 2;
            const totalRow = sheet.getRow(totalRowNumber);
            totalRow.getCell(1).value = 'TOTAL';
            // Columna F (6) es Navegado Periodo, Columna G (7) es Navegado Total
            totalRow.getCell(6).value = { formula: `SUM(F2:F${totalRowNumber - 1})` };
            totalRow.getCell(7).value = { formula: `SUM(G2:G${totalRowNumber - 1})` };

            // Estilo unificado
            const maxCol = columns.length;
            for (let c = 1; c <= maxCol; c++) {
                const cell = totalRow.getCell(c);
                cell.font = { bold: true };
                cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'EFF6FF' } };
                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    right: { style: 'thin', color: { argb: 'FFD4D4D4' } },
                    bottom: { style: 'thin', color: { argb: 'FFD4D4D4' } }
                };
            }
        }
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
            { header: 'CONTRATO', key: 'tipoContrato', width: 15 },
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
                tipoContrato: (item as any).tipoContrato || '',
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
        sheet.autoFilter = `A1:L${sheet.rowCount}`;

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

    private async getAuditExportWorkbook(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod = false,
        includeCampaigns = true,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ): Promise<ExcelJS.Workbook> {
        // 1. Obtener datos base
        const stats = await this.getDashboardStats(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, 'SHIP', includeCampaigns, startDate, endDate, protocolizationStartDate, protocolizationEndDate
        );

        // Obtener dotación activa (observadores no eliminados y activos)
        const dotacionActiva = await this.prisma.observador.count({
            where: {
                activo: true,
            }
        });

        // Obtener marea distribution (para intervalos y etapas)
        const mareas = await this.getMareaDistribution(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, includeCampaigns, startDate, endDate, protocolizationStartDate, protocolizationEndDate
        );

        // Obtener detalle de mareas para paridad exacta con el dashboard
        const detailItems = await this.getDashboardStatsDetail(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, null, '', 'SHIP', includeCampaigns, startDate, endDate, protocolizationStartDate, protocolizationEndDate
        );

        const workbook = new ExcelJS.Workbook();

        // Hoja 1: Estadísticas de Personal
        this.buildAuditPersonalSheet(workbook, stats, dotacionActiva);

        // Hoja 2: Estadísticas de Navegación
        this.buildAuditNavegacionSheet(workbook, mareas, detailItems, year, mode);

        // Hoja 3: Estadísticas por Pesquería
        this.buildAuditPesqueriaSheet(workbook, mareas, detailItems, year, mode);

        return workbook;
    }

    private buildAuditPersonalSheet(workbook: ExcelJS.Workbook, stats: any, dotacionActiva: number) {
        const sheet = workbook.addWorksheet('Personal');

        // Título
        sheet.mergeCells('A1', 'H1');
        const titleCell = sheet.getCell('A1');
        titleCell.value = 'Estadísticas de Personal - Auditoría';
        titleCell.font = { bold: true, size: 16 };
        titleCell.alignment = { horizontal: 'center' };

        // TABLA 1: KPIs DE AUDITORÍA (IZQUIERDA: A-C)
        const startRowKPI = 3;
        const headersKPI = ['Indicador', 'Valor', 'Metraje'];
        headersKPI.forEach((h, i) => {
            const cell = sheet.getCell(startRowKPI, i + 1);
            cell.value = h;
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00548B' } };
            cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
            cell.alignment = { horizontal: 'center' };
        });

        const obsAfectados = stats.observers.length;
        const dotacionRef = Math.max(dotacionActiva, obsAfectados);
        const totalMareasGlobal = stats.totalMareas;
        const cobertura = dotacionRef > 0 ? (totalMareasGlobal / dotacionRef) : 0;

        const kpis = [
            { label: 'Dotación Activa (Actual)', val: dotacionActiva, met: 'Obs. Activos' },
            { label: 'Observadores que navegaron', val: obsAfectados, met: 'Personal' },
            { label: 'Dotación de Referencia', val: dotacionRef, met: 'Mix' },
            { label: 'Total de Mareas', val: totalMareasGlobal, met: 'Mareas' },
            { label: '% Cobertura (Mareas/Dot)', val: (cobertura * 100).toFixed(1) + '%', met: 'Ratio' },
            { label: 'Promedio Mareas/Obs', val: (totalMareasGlobal / (obsAfectados || 1)).toFixed(2), met: 'Productividad' }
        ];

        kpis.forEach((kpi, index) => {
            const row = startRowKPI + 1 + index;
            sheet.getCell(row, 1).value = kpi.label;
            sheet.getCell(row, 2).value = kpi.val;
            sheet.getCell(row, 3).value = kpi.met;
            sheet.getCell(row, 1).font = { bold: true };
            sheet.getCell(row, 2).alignment = { horizontal: 'center' };
            sheet.getCell(row, 3).alignment = { horizontal: 'center' };
        });

        // TABLA 2: RANKING DE OBSERVADORES (DERECHA: E-H)
        const colOffsetRanking = 5; // Columna E
        const startRowRanking = 3;
        const headersRanking = ['Pos', 'Observador', 'Mareas', 'Días Navegados'];
        headersRanking.forEach((h, i) => {
            const cell = sheet.getCell(startRowRanking, colOffsetRanking + i);
            cell.value = h;
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00548B' } };
            cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
            cell.alignment = { horizontal: 'center' };
        });

        let currentRow = startRowRanking + 1;
        let totalMareasRanking = 0;
        let totalDiasRanking = 0;

        stats.observers.forEach((obs, index) => {
            sheet.getCell(currentRow, colOffsetRanking).value = index + 1;
            sheet.getCell(currentRow, colOffsetRanking + 1).value = obs.name;
            sheet.getCell(currentRow, colOffsetRanking + 2).value = obs.mareas;
            sheet.getCell(currentRow, colOffsetRanking + 3).value = obs.days;

            totalMareasRanking += obs.mareas;
            totalDiasRanking += obs.days;

            // Formato
            sheet.getCell(currentRow, colOffsetRanking).alignment = { horizontal: 'center' };
            sheet.getCell(currentRow, colOffsetRanking + 2).alignment = { horizontal: 'center' };
            sheet.getCell(currentRow, colOffsetRanking + 3).alignment = { horizontal: 'center' };

            currentRow++;
        });

        // Fila de TOTAL para Ranking
        const totalRowRanking = currentRow;
        sheet.getCell(totalRowRanking, colOffsetRanking).value = 'TOTAL';
        sheet.getCell(totalRowRanking, colOffsetRanking).font = { bold: true };
        sheet.getCell(totalRowRanking, colOffsetRanking + 2).value = totalMareasRanking;
        sheet.getCell(totalRowRanking, colOffsetRanking + 2).font = { bold: true };
        sheet.getCell(totalRowRanking, colOffsetRanking + 3).value = totalDiasRanking;
        sheet.getCell(totalRowRanking, colOffsetRanking + 3).font = { bold: true };
        sheet.getCell(totalRowRanking, colOffsetRanking + 2).alignment = { horizontal: 'center' };
        sheet.getCell(totalRowRanking, colOffsetRanking + 3).alignment = { horizontal: 'center' };
        sheet.getRow(totalRowRanking).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF5F5F5' } };

        // Nota aclaratoria
        const noteRow = totalRowRanking + 2;
        sheet.mergeCells(`A${noteRow}`, `H${noteRow}`);
        const noteCell = sheet.getCell(noteRow, 1);
        noteCell.value = 'Nota: La información de esta hoja incluye a todo el personal que haya registrado navegación en el período consultado, incluso aquellos que actualmente no pertenecen al plantel activo.';
        noteCell.font = { italic: true, size: 10, color: { argb: 'FF475569' } };
        noteCell.alignment = { horizontal: 'left' };

        // Ajustar anchos
        sheet.getColumn(1).width = 30;
        sheet.getColumn(2).width = 15;
        sheet.getColumn(3).width = 15;
        sheet.getColumn(4).width = 5; // Columna en blanco
        sheet.getColumn(5).width = 5;
        sheet.getColumn(6).width = 30;
        sheet.getColumn(7).width = 12;
        sheet.getColumn(8).width = 15;
    }

    private buildAuditNavegacionSheet(workbook: ExcelJS.Workbook, mareasDistribucion: any[], detailItems: any[], year: number, mode: 'CALENDAR' | 'TOTAL') {
        const sheet = workbook.addWorksheet('Navegación');

        // Título
        sheet.mergeCells('A1', 'I1');
        const titleCell = sheet.getCell('A1');
        titleCell.value = `Estadísticas de Navegación - Período ${year}`;
        titleCell.font = { bold: true, size: 16 };
        titleCell.alignment = { horizontal: 'center' };

        const headers = ['Marea', 'Tipo', 'Buque', 'Flota', 'Pesquería', 'Inicio', 'Fin', 'Días', 'Etapas'];
        headers.forEach((h, i) => {
            const cell = sheet.getCell(3, i + 1);
            cell.value = h;
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00548B' } };
            cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
            cell.alignment = { horizontal: 'center' };
        });

        // Mapa de etapas (mismo criterio que el frontend)
        const etapasPorMarea = new Map<string, number>();
        mareasDistribucion.forEach(item => {
            const key = item.id_marea;
            const current = etapasPorMarea.get(key) || 0;
            etapasPorMarea.set(key, Math.max(current, item.nroEtapa || 0));
        });


        // Usar detailItems como base (paridad total con la tabla de navegación web)
        const listMareas = detailItems.map(item => ({
            id: item.id_marea,
            tipo: item.id_marea.split('-')[0],
            buque: item.buque,
            flota: item.flota,
            pesqueria: item.pesqueria,
            fechaMin: item.fechaZarpada ? new Date(item.fechaZarpada) : null,
            fechaMax: item.fechaArribo ? new Date(item.fechaArribo) : new Date(),
            etapas: etapasPorMarea.get(item.id_marea) || 1, // Fallback a 1 como en el frontend
            dias: mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales
        }));

        // Custom Sorting (Tipo DESC, Año ASC, Nro ASC) - Mismo que en Frontend
        listMareas.sort((a, b) => {
            const regex = /^([A-Z]+)-(\d+)-(\d+)$/;
            const matchA = a.id.match(regex);
            const matchB = b.id.match(regex);

            if (matchA && matchB) {
                const [, typeA, numA, yearA] = matchA;
                const [, typeB, numB, yearB] = matchB;

                if (typeA !== typeB) return typeB.localeCompare(typeA);
                if (yearA !== yearB) return yearA.localeCompare(yearB);
                return parseInt(numA) - parseInt(numB);
            }
            return a.id.localeCompare(b.id);
        });

        let currentRow = 4;
        let totalDias = 0;
        let totalEtapas = 0;

        listMareas.forEach(m => {
            sheet.getCell(currentRow, 1).value = m.id;
            sheet.getCell(currentRow, 2).value = m.tipo;
            sheet.getCell(currentRow, 3).value = m.buque;
            sheet.getCell(currentRow, 4).value = m.flota;
            sheet.getCell(currentRow, 5).value = m.pesqueria;
            sheet.getCell(currentRow, 6).value = m.fechaMin;
            sheet.getCell(currentRow, 7).value = m.fechaMax;
            sheet.getCell(currentRow, 8).value = m.dias;
            sheet.getCell(currentRow, 9).value = m.etapas;

            sheet.getCell(currentRow, 6).numFmt = 'dd/mm/yyyy';
            sheet.getCell(currentRow, 7).numFmt = 'dd/mm/yyyy';

            totalDias += m.dias;
            totalEtapas += m.etapas;

            currentRow++;
        });

        // Fila de TOTAL para Navegación
        sheet.getCell(currentRow, 1).value = 'TOTAL';
        sheet.getCell(currentRow, 1).font = { bold: true };
        sheet.getCell(currentRow, 8).value = totalDias;
        sheet.getCell(currentRow, 8).font = { bold: true };
        sheet.getCell(currentRow, 9).value = totalEtapas;
        sheet.getCell(currentRow, 9).font = { bold: true };
        sheet.getRow(currentRow).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF5F5F5' } };

        sheet.columns.forEach((col, i) => {
            col.width = [15, 8, 30, 20, 25, 12, 12, 10, 10][i];
        });
    }

    private buildAuditPesqueriaSheet(workbook: ExcelJS.Workbook, mareasDistribucion: any[], detailItems: any[], year: number, mode: 'CALENDAR' | 'TOTAL') {
        const sheet = workbook.addWorksheet('Pesquería');

        const periodRange = mode === 'CALENDAR' ? {
            start: new Date(Date.UTC(year, 0, 1)),
            end: new Date(Date.UTC(year, 11, 31, 23, 59, 59))
        } : undefined;

        const calculationLimit = new Date(); // now

        // 1. Resumen por Pesquería (IZQUIERDA: A-C)
        const startRowResumen = 3;
        const headersResumen = ['Pesquería', 'Cant. Mareas', 'Total Días Naveg.'];
        headersResumen.forEach((h, i) => {
            const cell = sheet.getCell(startRowResumen, i + 1);
            cell.value = h;
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00548B' } };
            cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
            cell.alignment = { horizontal: 'center' };
        });

        const fisheryStats = new Map<string, { mareas: Set<string>, dias: number }>();

        // Mapa de etapas (mismo criterio que el frontend)
        const etapasPorMarea = new Map<string, number>();
        mareasDistribucion.forEach(item => {
            const key = item.id_marea;
            const current = etapasPorMarea.get(key) || 0;
            etapasPorMarea.set(key, Math.max(current, item.nroEtapa || 0));
        });

        // Agrupar intervalos de distribución por marea para cálculo de días
        const intervalosPorMarea = new Map<string, any[]>();
        mareasDistribucion.forEach(m => {
            const key = m.id_marea;
            if (!intervalosPorMarea.has(key)) intervalosPorMarea.set(key, []);
            intervalosPorMarea.get(key)!.push({
                start: m.fechaZarpada,
                end: m.fechaArribo || new Date()
            });
        });

        // Procesar detailItems para el resumen
        detailItems.forEach(item => {
            if (!fisheryStats.has(item.pesqueria)) {
                fisheryStats.set(item.pesqueria, { mareas: new Set(), dias: 0 });
            }
            const stats = fisheryStats.get(item.pesqueria)!;
            stats.mareas.add(item.id_marea);

            // Sumar directamente los días contabilizados (paridad con dashboard)
            const diasMarea = mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales;
            stats.dias += diasMarea;
        });

        let resRow = startRowResumen + 1;
        let totalDiasPesqueria = 0;
        let totalMareasPesqueria = 0;
        Array.from(fisheryStats.entries()).sort((a, b) => b[1].dias - a[1].dias).forEach(([name, data]) => {
            sheet.getCell(resRow, 1).value = name;
            sheet.getCell(resRow, 2).value = data.mareas.size;
            sheet.getCell(resRow, 2).alignment = { horizontal: 'center' };
            sheet.getCell(resRow, 3).value = data.dias;
            sheet.getCell(resRow, 3).alignment = { horizontal: 'center' };
            totalDiasPesqueria += data.dias;
            totalMareasPesqueria += data.mareas.size;
            resRow++;
        });

        // TOTAL Resumen (Abajo de la tabla resumen)
        sheet.getCell(resRow, 1).value = 'TOTAL';
        sheet.getCell(resRow, 1).font = { bold: true };
        sheet.getCell(resRow, 2).value = totalMareasPesqueria;
        sheet.getCell(resRow, 2).font = { bold: true };
        sheet.getCell(resRow, 2).alignment = { horizontal: 'center' };
        sheet.getCell(resRow, 3).value = totalDiasPesqueria;
        sheet.getCell(resRow, 3).font = { bold: true };
        sheet.getCell(resRow, 3).alignment = { horizontal: 'center' };
        sheet.getRow(resRow).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF5F5F5' } };

        // 2. Detalle de Mareas (DERECHA: E-L)
        const colOffsetDetalle = 5; // Columna E
        const headersDetalle = ['Pesquería', 'Marea', 'Buque', 'Flota', 'Inicio', 'Fin', 'Días', 'Etapas'];
        const headerRow = 3;
        headersDetalle.forEach((h, i) => {
            const cell = sheet.getCell(headerRow, colOffsetDetalle + i);
            cell.value = h;
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF00548B' } };
            cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
            cell.alignment = { horizontal: 'center' };
        });

        const listMareasDetalle = detailItems.map(item => ({
            pesqueria: item.pesqueria,
            id: item.id_marea,
            buque: item.buque,
            flota: item.flota,
            inicio: item.fechaZarpada ? new Date(item.fechaZarpada) : null,
            fin: item.fechaArribo ? new Date(item.fechaArribo) : new Date(),
            etapas: etapasPorMarea.get(item.id_marea) || 1,
            dias: mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales
        }));

        let detRow = headerRow + 1;
        let totalDiasDetalle = 0;
        let totalEtapasDetalle = 0;

        listMareasDetalle
            .sort((a, b) => {
                const pComp = a.pesqueria.localeCompare(b.pesqueria);
                if (pComp !== 0) return pComp;

                const regex = /^([A-Z]+)-(\d+)-(\d+)$/;
                const matchA = a.id.match(regex);
                const matchB = b.id.match(regex);

                if (matchA && matchB) {
                    const [, typeA, numA, yearA] = matchA;
                    const [, typeB, numB, yearB] = matchB;

                    if (typeA !== typeB) return typeB.localeCompare(typeA);
                    if (yearA !== yearB) return yearA.localeCompare(yearB);
                    return parseInt(numA) - parseInt(numB);
                }
                return a.id.localeCompare(b.id);
            })
            .forEach(d => {
                sheet.getCell(detRow, colOffsetDetalle).value = d.pesqueria;
                sheet.getCell(detRow, colOffsetDetalle + 1).value = d.id;
                sheet.getCell(detRow, colOffsetDetalle + 2).value = d.buque;
                sheet.getCell(detRow, colOffsetDetalle + 3).value = d.flota;
                sheet.getCell(detRow, colOffsetDetalle + 4).value = d.inicio;
                sheet.getCell(detRow, colOffsetDetalle + 5).value = d.fin;
                sheet.getCell(detRow, colOffsetDetalle + 6).value = d.dias;
                sheet.getCell(detRow, colOffsetDetalle + 7).value = d.etapas;

                sheet.getCell(detRow, colOffsetDetalle + 4).numFmt = 'dd/mm/yyyy';
                sheet.getCell(detRow, colOffsetDetalle + 5).numFmt = 'dd/mm/yyyy';
                sheet.getCell(detRow, colOffsetDetalle + 6).alignment = { horizontal: 'center' };
                sheet.getCell(detRow, colOffsetDetalle + 7).alignment = { horizontal: 'center' };

                totalDiasDetalle += d.dias;
                totalEtapasDetalle += d.etapas;
                detRow++;
            });

        // Fila de TOTAL Detalle
        sheet.getCell(detRow, colOffsetDetalle).value = 'TOTAL';
        sheet.getCell(detRow, colOffsetDetalle).font = { bold: true };
        sheet.getCell(detRow, colOffsetDetalle + 6).value = totalDiasDetalle;
        sheet.getCell(detRow, colOffsetDetalle + 6).font = { bold: true };
        sheet.getCell(detRow, colOffsetDetalle + 7).value = totalEtapasDetalle;
        sheet.getCell(detRow, colOffsetDetalle + 7).font = { bold: true };
        sheet.getCell(detRow, colOffsetDetalle + 6).alignment = { horizontal: 'center' };
        sheet.getCell(detRow, colOffsetDetalle + 7).alignment = { horizontal: 'center' };
        sheet.getRow(detRow).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF5F5F5' } };

        // Ajustar anchos
        sheet.getColumn(1).width = 25;
        sheet.getColumn(2).width = 15;
        sheet.getColumn(3).width = 15;
        sheet.getColumn(4).width = 5; // Blanco
        sheet.getColumn(5).width = 25;
        sheet.getColumn(6).width = 15;
        sheet.getColumn(7).width = 25;
        sheet.getColumn(8).width = 20;
        sheet.getColumn(9).width = 12;
        sheet.getColumn(10).width = 12;
        sheet.getColumn(11).width = 10;
        sheet.getColumn(12).width = 10;
    }
}
