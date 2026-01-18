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
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                }
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
        const byObserver: Record<string, { id: string; name: string; mareas: number; days: number; active: boolean }> = {};

        for (const marea of mareas) {
            const overallStart = marea.fechaInicioObservador || marea.fechaZarpadaEstimada;
            if (!overallStart) continue;

            // Extract stage intervals
            const intervals = marea.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? new Date() : null)
            })).filter(i => i.start);

            // Calculate Unique Days
            const days = DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);

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
                        id: obsId,
                        name: obsName,
                        mareas: 0,
                        days: 0,
                        active: marea.observadorPrincipal.activo
                    };
                }
                byObserver[obsId].mareas++;
                byObserver[obsId].days += days;
            }

            // Monthly Trend (Starts)
            const startMonth = overallStart.getMonth();
            if (overallStart.getFullYear() === year) {
                mareasByMonth[startMonth]++;
            }

            // Distribute Days across months using merged intervals
            if (days > 0) {
                // We normalize/merge intervals for this marea to distribute accurately
                const normalized = intervals
                    .map(i => {
                        const s = new Date(i.start);
                        const e = i.end ? new Date(i.end) : new Date();
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

                // Distribute each merged interval by month (within the target year if CALENDAR mode)
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
        }

        return {
            year,
            mode,
            totalMareas,
            totalDaysNavigated,
            avgDaysPerMarea: totalMareas ? Math.round(totalDaysNavigated / totalMareas) : 0,
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
            const isUUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(filterValue);
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

            // Extract stage intervals
            const intervals = m.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : null)
            })).filter(i => i.start);

            // Calculate Unique Days
            const days = DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);

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
        includeProtocolizedOutOfPeriod = false,
        filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue?: string
    ): Promise<ExcelJS.Workbook> {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);

        if (filterType && filterValue) {
            if (filterType === 'FISHERY') {
                where.buque = { pesqueriaHabitual: { nombre: filterValue } };
            } else if (filterType === 'FLEET') {
                where.buque = { tipoFlota: { nombre: filterValue } };
            } else if (filterType === 'OBSERVER') {
                const isUUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(filterValue);
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
        const maxEtapas = mareas.reduce((max, m) => Math.max(max, m.etapas.length), 0);

        // Definir columnas base
        const columns = [
            { header: 'ID Marea', key: 'id_marea', width: 15 },
            { header: 'Buque', key: 'buque', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Pesquería', key: 'pesqueria', width: 20 },
            { header: 'Observador', key: 'observador', width: 25 },
            { header: 'Estado', key: 'estado', width: 20 },
            { header: 'Días Nav.', key: 'dias', width: 10 },
            { header: 'Inicio', key: 'inicio', width: 15 },
            { header: 'Fin', key: 'fin', width: 15 },
        ];

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

            // Extract stage intervals
            const intervals = m.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (m.estadoActualId === 'EN_EJECUCION' ? new Date() : null)
            })).filter(i => i.start);

            // Calculate Unique Days
            const days = DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);

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
