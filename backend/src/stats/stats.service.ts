import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DateUtils } from '../common/utils/date.utils';
import { Prisma } from '@prisma/client';
import { StatsDetailItem, DashboardStats } from './interfaces/dashboard.interface';
import { MareaUtils } from '../common/utils/marea.utils';
import * as ExcelJS from 'exceljs';

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
        daysCalculationMode: 'SHIP' | 'OBSERVER' = 'SHIP',
        includeCampaigns: boolean = true,
    ) {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);

        // Filter Campaigns
        if (!includeCampaigns) {
            where.tipoMarea = { not: 'CI' };
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
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
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
        const byFishery: Record<string, { name: string; mareas: number; days: number }> = {};
        const byFleet: Record<string, { name: string; mareas: number; days: number }> = {};
        const byObserver: Record<string, { id: string; name: string; mareas: number; days: number; active: boolean }> = {};

        for (const marea of mareas) {
            const overallStart = marea.fechaInicioObservador || marea.fechaZarpadaEstimada;
            if (!overallStart) continue;

            const intervals = marea.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? new Date() : null)
            })).filter(i => i.start);

            let days = 0;

            if (daysCalculationMode === 'SHIP') {
                // SHIP metric: Unique days of the vessel at sea
                days = DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);
            } else {
                // OBSERVER metric: Sum of days of ALL observers in ALL stages
                let totalObsDays = 0;
                // We need to iterate stages to get observers per stage
                marea.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada) return;
                    const stageStart = etapa.fechaZarpada;
                    const stageEnd = etapa.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? new Date() : null);

                    // Calculate days for this stage
                    // If CALENDAR mode, we clamp to year
                    let stageDays = 0;
                    if (mode === 'CALENDAR') {
                        stageDays = DateUtils.calculateDaysInYear(stageStart, stageEnd || new Date(), year);
                    } else {
                        stageDays = DateUtils.calculateInclusiveDays(stageStart, stageEnd);
                    }

                    // Multiply by number of observers in this stage
                    const obsCount = etapa.observadores.length || (marea.observadorPrincipal ? 1 : 0);
                    // Use actual observers count from relation if available, otherwise fallback to 1 (main) if relation empty but marea has main? 
                    // Actually, if marea_etapas_observadores is populated, we use that. 
                    // If strictly empty, we might fallback to marea.observadorPrincipal if logic dictates, but generally stages should have observers.
                    // Let's assume consistent data: if we want precise observer days, we trust the join table.
                    // Just in case, if count is 0 and we have a main observer, assume he was there?
                    // To be safe: if etapa.observadores is empty, assume Main Observer was there.
                    const finalObsCount = obsCount > 0 ? obsCount : (marea.observadorPrincipal ? 1 : 0);

                    totalObsDays += (stageDays * finalObsCount);
                });
                days = totalObsDays;
            }

            // Add to Totals
            totalMareas++;
            totalDaysCalculated += days;

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

            // Observer Aggregation
            // Logic: Who gets the credit?
            // If SHIP mode: Credit goes to Main Observer (traditional)
            // If OBSERVER mode: Credit should technically go to EACH observer involved.
            // For simplicity in this View (which lists "Mareas" per observer), we usually list Main Observer.
            // If we want to split credit, we would need to iterate all observers found.
            // Let's stick to: Main Observer gets the credit for the Marea, and the "Days" value = the calculated metric.
            // If Metric is "Observer Days", and Main Observer was alone, he gets X days.
            // If there were 2 observers, Main Observer gets "Total Observer Days" (X*2)? That seems misleading for a ranking.
            // Requirement says: "In the second case [Observer Days] we consider the sum of days of observers assigned to the marea".
            // AND "In the case of observer ranking, we should take them from a DIFFERENT ENDPOINT/QUERY... each sums separately".
            // So for THIS dashboard endpoint (General Summary), we can just aggregate under Main Observer for trends, 
            // OR we accept that "Observer Ranking" chart might need a different source if we want it perfect.
            // However, the user said "Observer ranking ... different endpoint". 
            // But this function `getDashboardStats` RETURNS the `observers` list used for that ranking chart.
            // So I SHOULD update this logic to properly attribute days for the Ranking.

            if (daysCalculationMode === 'SHIP') {
                if (marea.observadorPrincipal) {
                    const obsId = marea.observadorPrincipal.id;
                    if (!byObserver[obsId]) byObserver[obsId] = { id: obsId, name: `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}`, mareas: 0, days: 0, active: marea.observadorPrincipal.activo };
                    byObserver[obsId].mareas++;
                    byObserver[obsId].days += days;
                }
            } else {
                // OBSERVER MODE: Iterate ALL unique observers involved in this marea and attribute THEIR specific days.
                // This is complex because days are per stage.
                const observerMap: Record<string, number> = {}; // ObsID -> Days

                marea.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada) return;
                    // Days for this stage
                    let sDays = 0;
                    if (mode === 'CALENDAR') {
                        sDays = DateUtils.calculateDaysInYear(etapa.fechaZarpada, etapa.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? new Date() : null) || new Date(), year);
                    } else {
                        sDays = DateUtils.calculateInclusiveDays(etapa.fechaZarpada, etapa.fechaArribo);
                    }

                    if (etapa.observadores && etapa.observadores.length > 0) {
                        etapa.observadores.forEach(obsRel => {
                            if (obsRel.observador) {
                                observerMap[obsRel.observador.id] = (observerMap[obsRel.observador.id] || 0) + sDays;
                                // Add to global list if needed to ensure name availability
                                if (!byObserver[obsRel.observador.id]) {
                                    byObserver[obsRel.observador.id] = {
                                        id: obsRel.observador.id,
                                        name: `${obsRel.observador.nombre} ${obsRel.observador.apellido}`,
                                        mareas: 0,
                                        days: 0,
                                        active: obsRel.observador.activo
                                    };
                                }
                            }
                        });
                    } else if (marea.observadorPrincipal) {
                        // Fallback to main
                        const mainId = marea.observadorPrincipal.id;
                        observerMap[mainId] = (observerMap[mainId] || 0) + sDays;
                        if (!byObserver[mainId]) {
                            byObserver[mainId] = {
                                id: mainId,
                                name: `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}`,
                                mareas: 0,
                                days: 0,
                                active: marea.observadorPrincipal.activo
                            };
                        }
                    }
                });

                // Apply to aggregated map
                Object.entries(observerMap).forEach(([oId, d]) => {
                    byObserver[oId].days += d;
                    // Marea count? They participated in this marea.
                    // But if we count 1 marea for each observer, total mareas in "Observer Ranking" sum > Total Mareas.
                    // That is expected for "Observer Ranking".
                    byObserver[oId].mareas++;
                });
            }

            // Monthly Trend (Starts)
            const startMonth = overallStart.getMonth();
            if (overallStart.getFullYear() === year) {
                mareasByMonth[startMonth]++;
            }

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
                            s.setHours(0, 0, 0, 0);
                            e.setHours(0, 0, 0, 0);
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
                        const limitEnd = (mode === 'CALENDAR' && interval.end > yearEnd) ? yearEnd : interval.end;

                        while (cursor <= limitEnd) {
                            if (cursor.getFullYear() === year) {
                                daysByMonth[cursor.getMonth()]++;
                            }
                            cursor.setDate(cursor.getDate() + 1);
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
                    const e = etapa.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? new Date() : null) || new Date(s); // Fallback to start if historical missing

                    s.setHours(0, 0, 0, 0);
                    e.setHours(0, 0, 0, 0);

                    let cursor = new Date(s);
                    if (mode === 'CALENDAR') {
                        if (cursor < yearStart) cursor = new Date(yearStart);
                    }
                    const limitEnd = (mode === 'CALENDAR' && e > yearEnd) ? yearEnd : e;

                    while (cursor <= limitEnd) {
                        if (cursor.getFullYear() === year) {
                            daysByMonth[cursor.getMonth()] += count; // Add N days for this day
                        }
                        cursor.setDate(cursor.getDate() + 1);
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
        filterValue: string,
        daysCalculationMode: 'SHIP' | 'OBSERVER' = 'SHIP',
        includeCampaigns: boolean = true,
    ): Promise<StatsDetailItem[]> {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);

        if (!includeCampaigns) {
            where.tipoMarea = { not: 'CI' };
        }

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
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
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
            const overallStart = m.fechaInicioObservador || m.fechaZarpadaEstimada;

            let days = 0;

            if (daysCalculationMode === 'SHIP') {
                const intervals = m.etapas.map(e => ({
                    start: e.fechaZarpada,
                    end: e.fechaArribo || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : null)
                })).filter(i => i.start);
                days = DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);
            } else {
                // OBSERVER Days
                let totalObsDays = 0;
                m.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada) return;
                    let stageDays = 0;
                    const end = etapa.fechaArribo || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : null);
                    if (mode === 'CALENDAR') {
                        stageDays = DateUtils.calculateDaysInYear(etapa.fechaZarpada, end || new Date(), year);
                    } else {
                        stageDays = DateUtils.calculateInclusiveDays(etapa.fechaZarpada, end);
                    }

                    const count = (etapa.observadores && etapa.observadores.length > 0)
                        ? etapa.observadores.length
                        : (m.observadorPrincipal ? 1 : 0);

                    totalObsDays += (stageDays * count);
                });
                days = totalObsDays;
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
                fechaInicio: overallStart,
                fechaFin: m.fechaFinObservador
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
        filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue?: string
    ): Promise<ExcelJS.Workbook> {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);

        if (!includeCampaigns) {
            where.tipoMarea = { not: 'CI' };
        }

        if (filterType && filterValue) {
            if (filterType === 'FISHERY') {
                where.buque = { pesqueriaHabitual: { nombre: filterValue } };
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
                estadoActual: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
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

        const workbook = new ExcelJS.Workbook();
        const sheet = workbook.addWorksheet('Mareas');

        // Determinar max etapas para las columnas
        // Determinar max etapas y observadores adicionales
        let maxEtapas = 0;
        let maxExtraObservers = 0;

        mareas.forEach(m => {
            if (m.etapas.length > maxEtapas) maxEtapas = m.etapas.length;

            // Find extra observers in this marea
            const uniqueObserversInMarea = new Set<string>();
            if (m.observadorPrincipal) uniqueObserversInMarea.add(m.observadorPrincipal.id);

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

        // Definir columnas base
        const columns = [
            { header: 'ID Marea', key: 'id_marea', width: 15 },
            { header: 'Buque', key: 'buque', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Pesquería', key: 'pesqueria', width: 20 },
            { header: 'Observador Principal', key: 'observador', width: 25 },
        ];

        // Dynamic Extra Observers Columns
        for (let i = 1; i <= maxExtraObservers; i++) {
            columns.push({ header: `Observador Adic. ${i}`, key: `obs_adic_${i}`, width: 25 });
        }

        columns.push(
            { header: 'Estado', key: 'estado', width: 20 },
            { header: 'Días Nav.', key: 'dias', width: 10 },
            { header: 'Inicio', key: 'inicio', width: 15 },
            { header: 'Fin', key: 'fin', width: 15 },
        );

        // Columnas dinámicas de etapas
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
        sheet.getRow(1).font = { bold: true };
        sheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFE0E0E0' }
        };

        // Cargar Datos
        mareas.forEach(m => {
            const overallStart = m.fechaInicioObservador || m.fechaZarpadaEstimada;

            let days = 0;
            if (daysCalculationMode === 'SHIP') {
                const intervals = m.etapas.map(e => ({
                    start: e.fechaZarpada,
                    end: e.fechaArribo || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : null)
                })).filter(i => i.start);
                days = DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);
            } else {
                // OBSERVER Days Logic
                let totalObsDays = 0;
                m.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada) return;
                    let stageDays = 0;
                    const end = etapa.fechaArribo || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : null);
                    if (mode === 'CALENDAR') {
                        stageDays = DateUtils.calculateDaysInYear(etapa.fechaZarpada, end || new Date(), year);
                    } else {
                        stageDays = DateUtils.calculateInclusiveDays(etapa.fechaZarpada, end);
                    }
                    const count = (etapa.observadores && etapa.observadores.length > 0)
                        ? etapa.observadores.length
                        : (m.observadorPrincipal ? 1 : 0);
                    totalObsDays += (stageDays * count);
                });
                days = totalObsDays;
            }

            const rowData: any = {
                id_marea: MareaUtils.formatCodigo(m),
                buque: m.buque?.nombreBuque || 'Desconocido',
                flota: m.buque?.tipoFlota?.nombre || '-',
                pesqueria: m.buque?.pesqueriaHabitual?.nombre || '-',
                observador: m.observadorPrincipal ? `${m.observadorPrincipal.nombre} ${m.observadorPrincipal.apellido}` : 'Sin asignar',
                estado: m.estadoActual?.nombre || 'Desconocido',
                dias: days,
                inicio: overallStart ? overallStart.toLocaleDateString() : '-',
                fin: m.fechaFinObservador ? m.fechaFinObservador.toLocaleDateString() : (m.estadoActualId === 'EN_EJECUCION' ? 'En curso' : '-')
            };

            // Extra Observers
            const extraObservers = new Set<string>();
            m.etapas.forEach(e => {
                e.observadores.forEach(obsRel => {
                    const oid = obsRel.observadorId;
                    // Logic: If main observer is defined, exclude him from "Adicionales".
                    if (m.observadorPrincipal && oid === m.observadorPrincipal.id) return;
                    if (obsRel.observador) {
                        // Store Name
                        extraObservers.add(`${obsRel.observador.nombre} ${obsRel.observador.apellido}`);
                    }
                });
            });
            const extrasArray = Array.from(extraObservers);
            extrasArray.forEach((name, idx) => {
                rowData[`obs_adic_${idx + 1}`] = name;
            });


            // Etapas
            m.etapas.forEach((e, idx) => {
                const i = idx + 1;
                rowData[`etapa_${i}_nro`] = e.nroEtapa;
                rowData[`etapa_${i}_zarpada`] = e.fechaZarpada ? e.fechaZarpada.toLocaleDateString() : '-';
                rowData[`etapa_${i}_arribo`] = e.fechaArribo ? e.fechaArribo.toLocaleDateString() : '-';
                rowData[`etapa_${i}_dias`] = DateUtils.calculateInclusiveDays(e.fechaZarpada, e.fechaArribo);
            });

            sheet.addRow(rowData);
        });

        return workbook;
    }
}
