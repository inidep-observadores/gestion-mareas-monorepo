"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StatsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const date_utils_1 = require("../common/utils/date.utils");
const marea_utils_1 = require("../common/utils/marea.utils");
const mareas_constants_1 = require("../mareas/mareas.constants");
const ExcelJS = require("exceljs");
let StatsService = class StatsService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod) {
        const where = {
            activo: true,
        };
        const activityOverlapCondition = {
            etapas: {
                some: {
                    AND: [
                        { fechaZarpada: { lte: yearEnd } },
                        {
                            OR: [
                                { fechaArribo: { gte: yearStart } },
                                { fechaArribo: null }
                            ]
                        }
                    ]
                }
            }
        };
        const protocolizedInYearCondition = {
            fechaProtocolizacion: {
                gte: yearStart,
                lte: yearEnd,
            },
        };
        if (!includeNonProtocolized) {
            if (includeProtocolizedOutOfPeriod) {
                where.AND = protocolizedInYearCondition;
            }
            else {
                where.AND = [
                    activityOverlapCondition,
                    protocolizedInYearCondition
                ];
            }
        }
        else {
            where.AND = activityOverlapCondition;
        }
        return where;
    }
    async getDashboardStats(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, daysCalculationMode = 'SHIP', includeCampaigns = true) {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));
        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);
        if (!includeCampaigns) {
            where.tipoMarea = { not: mareas_constants_1.TipoMarea.CI };
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
                        observadores: {
                            include: { observador: true }
                        }
                    }
                }
            },
        });
        let totalMareas = 0;
        let totalDaysCalculated = 0;
        const mareasByMonth = new Array(12).fill(0);
        const daysByMonth = new Array(12).fill(0);
        const byFishery = {};
        const byFleet = {};
        const byObserver = {};
        for (const marea of mareas) {
            const overallStart = marea.etapas[0]?.fechaZarpada;
            if (!overallStart)
                continue;
            const intervals = marea.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (marea.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null)
            })).filter(i => i.start);
            let days = 0;
            const totalMareaDays = date_utils_1.DateUtils.calculateUniqueDays(intervals, mode === 'CALENDAR' ? year : undefined);
            const mareaObserverMap = {};
            if (marea.observadorPrincipal) {
                mareaObserverMap[marea.observadorPrincipal.id] = totalMareaDays;
            }
            const additionalsMap = {};
            marea.etapas.forEach(etapa => {
                if (!etapa.fechaZarpada)
                    return;
                const start = etapa.fechaZarpada;
                const end = etapa.fechaArribo || (marea.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null);
                etapa.observadores.forEach(obsRel => {
                    if (obsRel.observador && obsRel.observador.id !== marea.observadorPrincipalId) {
                        if (!additionalsMap[obsRel.observador.id])
                            additionalsMap[obsRel.observador.id] = [];
                        additionalsMap[obsRel.observador.id].push({ start, end });
                    }
                });
            });
            Object.entries(additionalsMap).forEach(([obsId, obsIntervals]) => {
                mareaObserverMap[obsId] = date_utils_1.DateUtils.calculateUniqueDays(obsIntervals, mode === 'CALENDAR' ? year : undefined);
            });
            if (daysCalculationMode === 'SHIP') {
                days = totalMareaDays;
            }
            else {
                days = Object.values(mareaObserverMap).reduce((sum, d) => sum + d, 0);
            }
            totalMareas++;
            totalDaysCalculated += days;
            const fisheryName = marea.pesqueria?.nombre || marea.buque?.pesqueriaHabitual?.nombre || 'Desconocida';
            if (!byFishery[fisheryName])
                byFishery[fisheryName] = { name: fisheryName, mareas: 0, days: 0 };
            byFishery[fisheryName].mareas++;
            byFishery[fisheryName].days += days;
            const fleetName = marea.buque?.tipoFlota?.nombre || 'Desconocida';
            if (!byFleet[fleetName])
                byFleet[fleetName] = { name: fleetName, mareas: 0, days: 0 };
            byFleet[fleetName].mareas++;
            byFleet[fleetName].days += days;
            Object.entries(mareaObserverMap).forEach(([oId, d]) => {
                if (!byObserver[oId]) {
                    let obsObj = null;
                    if (marea.observadorPrincipalId === oId) {
                        obsObj = marea.observadorPrincipal;
                    }
                    else {
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
            const startMonth = overallStart.getMonth();
            if (overallStart.getFullYear() === year) {
                mareasByMonth[startMonth]++;
            }
            if (daysCalculationMode === 'SHIP') {
                if (days > 0) {
                    const normalized = intervals
                        .map(i => {
                        const s = new Date(i.start);
                        const e = i.end ? new Date(i.end) : new Date(s);
                        s.setHours(0, 0, 0, 0);
                        e.setHours(0, 0, 0, 0);
                        return { start: s, end: e };
                    })
                        .filter(i => !isNaN(i.start.getTime()) && !isNaN(i.end.getTime()) && i.end >= i.start)
                        .sort((a, b) => a.start.getTime() - b.start.getTime());
                    const merged = [];
                    if (normalized.length > 0) {
                        let curr = normalized[0];
                        for (let i = 1; i < normalized.length; i++) {
                            if (normalized[i].start.getTime() <= curr.end.getTime()) {
                                if (normalized[i].end.getTime() > curr.end.getTime())
                                    curr.end = normalized[i].end;
                            }
                            else {
                                merged.push(curr);
                                curr = normalized[i];
                            }
                        }
                        merged.push(curr);
                    }
                    for (const interval of merged) {
                        let cursor = new Date(interval.start);
                        if (mode === 'CALENDAR') {
                            if (cursor < yearStart)
                                cursor = new Date(yearStart);
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
            else {
                marea.etapas.forEach(etapa => {
                    if (!etapa.fechaZarpada)
                        return;
                    const count = (etapa.observadores && etapa.observadores.length > 0)
                        ? etapa.observadores.length
                        : (marea.observadorPrincipal ? 1 : 0);
                    if (count === 0)
                        return;
                    const s = new Date(etapa.fechaZarpada);
                    const e = etapa.fechaArribo || (marea.estadoActualId === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null) || new Date(s);
                    s.setHours(0, 0, 0, 0);
                    e.setHours(0, 0, 0, 0);
                    let cursor = new Date(s);
                    if (mode === 'CALENDAR') {
                        if (cursor < yearStart)
                            cursor = new Date(yearStart);
                    }
                    const limitEnd = (mode === 'CALENDAR' && e > yearEnd) ? yearEnd : e;
                    while (cursor <= limitEnd) {
                        if (cursor.getFullYear() === year) {
                            daysByMonth[cursor.getMonth()] += count;
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
    async getDashboardStatsDetail(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod = false, filterType, filterValue, daysCalculationMode = 'SHIP', includeCampaigns = true) {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));
        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);
        if (!includeCampaigns) {
            where.tipoMarea = { not: mareas_constants_1.TipoMarea.CI };
        }
        if (filterType === 'FISHERY') {
            where.OR = [
                { pesqueria: { nombre: filterValue } },
                {
                    AND: [
                        { pesqueriaId: null },
                        { buque: { pesqueriaHabitual: { nombre: filterValue } } }
                    ]
                }
            ];
        }
        else if (filterType === 'FLEET') {
            where.buque = {
                tipoFlota: { nombre: filterValue }
            };
        }
        else if (filterType === 'OBSERVER') {
            const isUUID = filterValue.length === 36 && /^[0-9a-f-]{36}$/i.test(filterValue);
            if (isUUID) {
                where.observadorPrincipalId = filterValue;
            }
            else {
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
                        observadores: { include: { observador: true } }
                    }
                }
            },
            orderBy: [
                { anioMarea: 'asc' },
                { nroMarea: 'asc' }
            ]
        });
        return mareas.map(m => {
            const overallStart = m.etapas[0]?.fechaZarpada;
            const overallEnd = m.etapas[m.etapas.length - 1]?.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null);
            let days = 0;
            let calendarDays = 0;
            let totalMareaDays = 0;
            const intervals = m.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null)
            })).filter(i => i.start);
            if (daysCalculationMode === 'SHIP') {
                calendarDays = date_utils_1.DateUtils.calculateUniqueDays(intervals, year);
                totalMareaDays = date_utils_1.DateUtils.calculateUniqueDays(intervals);
                days = mode === 'CALENDAR' ? calendarDays : totalMareaDays;
            }
            else {
                if (filterType === 'OBSERVER' && filterValue) {
                    let obsIntervals = [];
                    const isPrincipal = (m.observadorPrincipalId === filterValue);
                    if (isPrincipal) {
                        obsIntervals = intervals;
                    }
                    else {
                        m.etapas.forEach(etapa => {
                            const isAdditional = etapa.observadores.some(rel => rel.observadorId === filterValue);
                            if (isAdditional) {
                                obsIntervals.push({
                                    start: etapa.fechaZarpada,
                                    end: etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null)
                                });
                            }
                        });
                    }
                    calendarDays = date_utils_1.DateUtils.calculateUniqueDays(obsIntervals, year);
                    totalMareaDays = date_utils_1.DateUtils.calculateUniqueDays(obsIntervals);
                }
                else {
                    let effortCal = date_utils_1.DateUtils.calculateUniqueDays(intervals, year);
                    let effortTotal = date_utils_1.DateUtils.calculateUniqueDays(intervals);
                    const additionalsMap = {};
                    m.etapas.forEach(etapa => {
                        if (!etapa.fechaZarpada)
                            return;
                        const start = etapa.fechaZarpada;
                        const end = etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null);
                        etapa.observadores.forEach(obsRel => {
                            if (obsRel.observador && obsRel.observador.id !== m.observadorPrincipalId) {
                                if (!additionalsMap[obsRel.observador.id])
                                    additionalsMap[obsRel.observador.id] = [];
                                additionalsMap[obsRel.observador.id].push({ start, end });
                            }
                        });
                    });
                    Object.values(additionalsMap).forEach(obsIntervals => {
                        effortCal += date_utils_1.DateUtils.calculateUniqueDays(obsIntervals, year);
                        effortTotal += date_utils_1.DateUtils.calculateUniqueDays(obsIntervals);
                    });
                    calendarDays = effortCal;
                    totalMareaDays = effortTotal;
                }
                days = mode === 'CALENDAR' ? calendarDays : totalMareaDays;
            }
            return {
                id: m.id,
                id_marea: marea_utils_1.MareaUtils.formatCodigo(m),
                anioMarea: m.anioMarea,
                nroMarea: m.nroMarea,
                tipoMarea: m.tipoMarea,
                buque: m.buque?.nombreBuque || 'Desconocido',
                flota: m.buque?.tipoFlota?.nombre || '-',
                pesqueria: m.pesqueria?.nombre || m.buque?.pesqueriaHabitual?.nombre || '-',
                observador: m.observadorPrincipal ? `${m.observadorPrincipal.nombre} ${m.observadorPrincipal.apellido}` : 'Sin asignar',
                estado: m.estadoActual?.nombre || 'Desconocido',
                diasContabilizados: days,
                diasCalendario: calendarDays,
                diasTotales: totalMareaDays,
                fechaInicio: overallStart,
                fechaFin: overallEnd
            };
        });
    }
    async getExportWorkbook(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, daysCalculationMode = 'SHIP', includeCampaigns = true, filterType, filterValue) {
        const yearStart = new Date(Date.UTC(year, 0, 1, 0, 0, 0, 0));
        const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));
        const where = this.getSharedWhereClause(yearStart, yearEnd, includeNonProtocolized, includeProtocolizedOutOfPeriod);
        if (!includeCampaigns) {
            where.tipoMarea = { not: mareas_constants_1.TipoMarea.CI };
        }
        if (filterType && filterValue) {
            if (filterType === 'FISHERY') {
                where.OR = [
                    { pesqueria: { nombre: filterValue } },
                    {
                        AND: [
                            { pesqueriaId: null },
                            { buque: { pesqueriaHabitual: { nombre: filterValue } } }
                        ]
                    }
                ];
            }
            else if (filterType === 'FLEET') {
                where.buque = { tipoFlota: { nombre: filterValue } };
            }
            else if (filterType === 'OBSERVER') {
                const isUUID = filterValue.length === 36 && /^[0-9a-f-]{36}$/i.test(filterValue);
                if (isUUID) {
                    where.observadorPrincipalId = filterValue;
                }
                else {
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
        let maxEtapas = 0;
        let maxExtraObservers = 0;
        mareas.forEach(m => {
            if (m.etapas.length > maxEtapas)
                maxEtapas = m.etapas.length;
            const uniqueObserversInMarea = new Set();
            if (m.observadorPrincipal)
                uniqueObserversInMarea.add(m.observadorPrincipal.id);
            const extras = new Set();
            m.etapas.forEach(e => {
                e.observadores.forEach(obsRel => {
                    const oid = obsRel.observadorId;
                    if (oid && (!m.observadorPrincipal || oid !== m.observadorPrincipal.id)) {
                        extras.add(oid);
                    }
                });
            });
            if (extras.size > maxExtraObservers)
                maxExtraObservers = extras.size;
        });
        const columns = [
            { header: 'ID Marea', key: 'id_marea', width: 15 },
            { header: 'Buque', key: 'buque', width: 25 },
            { header: 'Flota', key: 'flota', width: 20 },
            { header: 'Pesquer�a', key: 'pesqueria', width: 20 },
            { header: 'Observador Principal', key: 'observador', width: 25 },
        ];
        for (let i = 1; i <= maxExtraObservers; i++) {
            columns.push({ header: `Observador Adic. ${i}`, key: `obs_adic_${i}`, width: 25 });
        }
        columns.push({ header: 'Estado', key: 'estado', width: 20 }, { header: 'D�as (Calendario)', key: 'dias_calendario', width: 15 }, { header: 'D�as (Total Marea)', key: 'dias_total', width: 15 }, { header: 'Inicio', key: 'inicio', width: 15 }, { header: 'Fin', key: 'fin', width: 15 });
        for (let i = 1; i <= maxEtapas; i++) {
            columns.push({ header: `Etapa ${i}: #`, key: `etapa_${i}_nro`, width: 10 }, { header: `Etapa ${i}: Zarpada`, key: `etapa_${i}_zarpada`, width: 15 }, { header: `Etapa ${i}: Arribo`, key: `etapa_${i}_arribo`, width: 15 }, { header: `Etapa ${i}: D�as`, key: `etapa_${i}_dias`, width: 10 });
        }
        sheet.columns = columns;
        sheet.getRow(1).font = { bold: true };
        sheet.getRow(1).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFE0E0E0' }
        };
        mareas.forEach(m => {
            const overallStart = m.etapas[0]?.fechaZarpada;
            const overallEnd = m.etapas[m.etapas.length - 1]?.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null);
            let calendarDays = 0;
            let totalMareaDays = 0;
            const intervals = m.etapas.map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null)
            })).filter(i => i.start);
            if (daysCalculationMode === 'SHIP') {
                calendarDays = date_utils_1.DateUtils.calculateUniqueDays(intervals, year);
                totalMareaDays = date_utils_1.DateUtils.calculateUniqueDays(intervals);
            }
            else {
                if (filterType === 'OBSERVER' && filterValue) {
                    let obsIntervals = [];
                    const isPrincipal = (m.observadorPrincipalId === filterValue);
                    if (isPrincipal) {
                        obsIntervals = intervals;
                    }
                    else {
                        m.etapas.forEach(etapa => {
                            const isAdditional = etapa.observadores.some(rel => rel.observadorId === filterValue);
                            if (isAdditional) {
                                obsIntervals.push({
                                    start: etapa.fechaZarpada,
                                    end: etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null)
                                });
                            }
                        });
                    }
                    calendarDays = date_utils_1.DateUtils.calculateUniqueDays(obsIntervals, year);
                    totalMareaDays = date_utils_1.DateUtils.calculateUniqueDays(obsIntervals);
                }
                else {
                    let effortCal = date_utils_1.DateUtils.calculateUniqueDays(intervals, year);
                    let effortTotal = date_utils_1.DateUtils.calculateUniqueDays(intervals);
                    const additionalsMap = {};
                    m.etapas.forEach(etapa => {
                        if (!etapa.fechaZarpada)
                            return;
                        const start = etapa.fechaZarpada;
                        const end = etapa.fechaArribo || (m.estadoActual?.codigo === 'EN_EJECUCION' ? date_utils_1.DateUtils.getNow() : null);
                        etapa.observadores.forEach(obsRel => {
                            if (obsRel.observador && obsRel.observador.id !== m.observadorPrincipalId) {
                                if (!additionalsMap[obsRel.observador.id])
                                    additionalsMap[obsRel.observador.id] = [];
                                additionalsMap[obsRel.observador.id].push({ start, end });
                            }
                        });
                    });
                    Object.values(additionalsMap).forEach(obsIntervals => {
                        effortCal += date_utils_1.DateUtils.calculateUniqueDays(obsIntervals, year);
                        effortTotal += date_utils_1.DateUtils.calculateUniqueDays(obsIntervals);
                    });
                    calendarDays = effortCal;
                    totalMareaDays = effortTotal;
                }
            }
            const rowData = {
                id_marea: marea_utils_1.MareaUtils.formatCodigo(m),
                buque: m.buque?.nombreBuque || 'Desconocido',
                flota: m.buque?.tipoFlota?.nombre || '-',
                pesqueria: m.pesqueria?.nombre || m.buque?.pesqueriaHabitual?.nombre || '-',
                observador: m.observadorPrincipal ? `${m.observadorPrincipal.nombre} ${m.observadorPrincipal.apellido}` : 'Sin asignar',
                estado: m.estadoActual?.nombre || 'Desconocido',
                dias_calendario: calendarDays,
                dias_total: totalMareaDays,
                inicio: date_utils_1.DateUtils.formatDate(overallStart),
                fin: overallEnd ? date_utils_1.DateUtils.formatDate(overallEnd) : (m.estadoActual?.codigo === 'EN_EJECUCION' ? 'En curso' : '-')
            };
            const extraObservers = new Set();
            m.etapas.forEach(e => {
                e.observadores.forEach(obsRel => {
                    const oid = obsRel.observadorId;
                    if (m.observadorPrincipal && oid === m.observadorPrincipal.id)
                        return;
                    if (obsRel.observador) {
                        extraObservers.add(`${obsRel.observador.nombre} ${obsRel.observador.apellido}`);
                    }
                });
            });
            const extrasArray = Array.from(extraObservers);
            extrasArray.forEach((name, idx) => {
                rowData[`obs_adic_${idx + 1}`] = name;
            });
            m.etapas.forEach((e, idx) => {
                const i = idx + 1;
                rowData[`etapa_${i}_nro`] = e.nroEtapa;
                rowData[`etapa_${i}_zarpada`] = date_utils_1.DateUtils.formatDate(e.fechaZarpada);
                rowData[`etapa_${i}_arribo`] = date_utils_1.DateUtils.formatDate(e.fechaArribo);
                rowData[`etapa_${i}_dias`] = date_utils_1.DateUtils.calculateInclusiveDays(e.fechaZarpada, e.fechaArribo);
            });
            sheet.addRow(rowData);
        });
        return workbook;
    }
};
exports.StatsService = StatsService;
exports.StatsService = StatsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], StatsService);
//# sourceMappingURL=stats.service.js.map