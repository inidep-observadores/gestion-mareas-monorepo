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
exports.ObservadoresService = void 0;
const common_1 = require("@nestjs/common");
const mareas_constants_1 = require("../../mareas/mareas.constants");
const date_utils_1 = require("../../common/utils/date.utils");
const marea_utils_1 = require("../../common/utils/marea.utils");
const prisma_service_1 = require("../../prisma/prisma.service");
let ObservadoresService = class ObservadoresService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createObservadorDto) {
        if (createObservadorDto.disponible && createObservadorDto.conImpedimento) {
            throw new common_1.BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }
        if (createObservadorDto.conImpedimento === false) {
            createObservadorDto.motivoImpedimento = null;
        }
        if (createObservadorDto.email && createObservadorDto.email.trim() === '') {
            createObservadorDto.email = null;
        }
        else if (createObservadorDto.email === '') {
            createObservadorDto.email = null;
        }
        return await this.prisma.observador.create({
            data: createObservadorDto,
        });
    }
    async obtenerTodos() {
        try {
            return await this.prisma.observador.findMany({
                orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
            });
        }
        catch (error) {
            console.error(error);
            throw new common_1.InternalServerErrorException('Error al obtener observadores');
        }
    }
    async obtenerUno(id) {
        const observador = await this.prisma.observador.findUnique({
            where: { id },
            include: { pesquerias: true }
        });
        if (!observador) {
            throw new common_1.NotFoundException(`Observador con ID ${id} no encontrado`);
        }
        return observador;
    }
    async actualizar(id, updateObservadorDto) {
        const observador = await this.obtenerUno(id);
        if (updateObservadorDto.disponible && updateObservadorDto.conImpedimento) {
            throw new common_1.BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }
        if (updateObservadorDto.conImpedimento === false) {
            updateObservadorDto.motivoImpedimento = null;
        }
        if (updateObservadorDto.email !== undefined) {
            if (updateObservadorDto.email === null || updateObservadorDto.email.trim() === '') {
                updateObservadorDto.email = null;
            }
        }
        return await this.prisma.observador.update({
            where: { id: observador.id },
            data: updateObservadorDto,
        });
    }
    async eliminar(id) {
        const observador = await this.obtenerUno(id);
        await this.prisma.observador.delete({
            where: { id: observador.id },
        });
        return { mensaje: 'Observador eliminado correctamente' };
    }
    async obtenerHistorial(id, operationalYear) {
        const startYear = operationalYear - 1;
        const periodStart = new Date(startYear, 0, 1, 0, 0, 0, 0);
        const periodEnd = new Date(operationalYear, 11, 31, 23, 59, 59, 999);
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
                    where: {
                        fechaZarpada: { not: null }
                    },
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        observadores: {
                            where: { observadorId: id }
                        }
                    }
                }
            },
            orderBy: { fechaInicioObservador: 'asc' }
        });
        const now = date_utils_1.DateUtils.getNow(true);
        const currentYear = now.getFullYear();
        const timeline = [];
        const years = [operationalYear, startYear].sort((a, b) => b - a);
        const trips = mareasRaw.map(m => {
            const mRaw = m;
            const start = mRaw.fechaInicioObservador || mRaw.fechaZarpadaEstimada;
            if (!start)
                return null;
            let finRaw = mRaw.fechaFinObservador;
            if (!finRaw && mRaw.etapas.length > 0) {
                const arrivals = mRaw.etapas
                    .map((e) => e.fechaArribo ? new Date(e.fechaArribo).getTime() : null)
                    .filter(Boolean);
                if (arrivals.length > 0) {
                    finRaw = new Date(Math.max(...arrivals));
                }
            }
            const isNavegando = mRaw.estadoActual.codigo === mareas_constants_1.MareaEstado.EN_EJECUCION;
            const isDesignada = mRaw.estadoActual.codigo === mareas_constants_1.MareaEstado.DESIGNADA;
            const end = finRaw || (isNavegando ? now : start);
            const totalDays = isDesignada ? 0 : date_utils_1.DateUtils.calculateInclusiveDays(start, end);
            const isPrincipal = mRaw.observadorPrincipalId === id;
            const relevantStages = mRaw.etapas.filter((e) => isPrincipal || e.observadores.length > 0);
            const navigatedDays = date_utils_1.DateUtils.calculateUniqueDays(relevantStages.map((e) => ({
                start: e.fechaZarpada,
                end: e.fechaArribo || (isNavegando ? now : null)
            })));
            return {
                id: mRaw.id,
                mareaCode: marea_utils_1.MareaUtils.formatCodigo(mRaw),
                vessel: mRaw.buque.nombreBuque,
                start,
                end,
                totalDays,
                navigatedDays,
                year: new Date(start).getFullYear(),
                isNavegando,
                ignoreStats: isDesignada
            };
        }).filter(Boolean);
        const sortedTrips = trips.sort((a, b) => b.start.getTime() - a.start.getTime());
        let tripIdx = 0;
        const refDate = operationalYear === currentYear ? now : new Date(operationalYear, 11, 31, 23, 59, 59, 999);
        for (const y of years) {
            timeline.push({
                type: 'YEAR_TOTAL',
                year: y,
                totalDays: this.calculateYearTotal(trips, y)
            });
            if (y === operationalYear && tripIdx === 0) {
                const firstTrip = sortedTrips[0];
                if (firstTrip && !firstTrip.isNavegando) {
                    const diffTierraActual = date_utils_1.DateUtils.calculateInclusiveDays(firstTrip.end, refDate) - 1;
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
            while (tripIdx < sortedTrips.length) {
                const trip = sortedTrips[tripIdx];
                const displayYear = trip.end.getFullYear();
                if (displayYear < y)
                    break;
                timeline.push({
                    type: 'TRIP',
                    ...trip
                });
                if (tripIdx + 1 < sortedTrips.length) {
                    const nextTrip = sortedTrips[tripIdx + 1];
                    const diffTierra = date_utils_1.DateUtils.calculateInclusiveDays(nextTrip.end, trip.start) - 2;
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
    calculateYearTotal(trips, year) {
        return trips.reduce((acc, trip) => {
            if (trip.ignoreStats)
                return acc;
            return acc + date_utils_1.DateUtils.calculateDaysInYear(trip.start, trip.end, year);
        }, 0);
    }
};
exports.ObservadoresService = ObservadoresService;
exports.ObservadoresService = ObservadoresService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ObservadoresService);
//# sourceMappingURL=observadores.service.js.map