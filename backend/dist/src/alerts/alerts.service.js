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
var AlertsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AlertsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let AlertsService = AlertsService_1 = class AlertsService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger(AlertsService_1.name);
    }
    async create(createAlertDto, user) {
        const { codigoUnico } = createAlertDto;
        const existing = await this.prisma.alerta.findUnique({
            where: { codigoUnico }
        });
        if (existing) {
            if (['DESCARTADA', 'RESUELTA'].includes(existing.estado)) {
                this.logger.log(`Alerta ${codigoUnico} ignorada (está ${existing.estado})`);
                return existing;
            }
            if (['PENDIENTE', 'SEGUIMIENTO'].includes(existing.estado)) {
                return existing;
            }
            return this.prisma.alerta.update({
                where: { id: existing.id },
                data: {
                    estado: 'PENDIENTE',
                    fechaDetectada: new Date(),
                    fechaCierre: null,
                    prioridad: createAlertDto.prioridad
                }
            });
        }
        const alert = await this.prisma.alerta.create({
            data: {
                ...createAlertDto,
                fechaDetectada: new Date(),
                creadoPorId: user?.id
            }
        });
        await this.logEvent(alert.id, 'CREACION', 'Alerta detectada/creada', user?.id);
        return alert;
    }
    async findAll(query) {
        const { refId, status, userId } = query;
        const where = {};
        if (refId)
            where.referenciaId = refId;
        if (status)
            where.estado = status;
        if (userId) {
            where.OR = [
                { asignadoId: userId },
                { creadoPorId: userId },
                { eventos: { some: { usuarioId: userId } } }
            ];
        }
        this.logger.log(`findAll query: ${JSON.stringify(where)}`);
        const results = await this.prisma.alerta.findMany({
            where,
            orderBy: { fechaDetectada: 'desc' },
            include: {
                asignadoA: { select: { fullName: true, avatarUrl: true } },
                creadoPor: { select: { fullName: true } },
                eventos: {
                    select: { detalle: true },
                    orderBy: { fechaHora: 'desc' },
                    take: 1
                }
            }
        });
        this.logger.log(`findAll results count: ${results.length}`);
        return results.map((alerta) => ({
            ...alerta,
            notaGestion: this.extractNotaGestion(alerta.eventos?.[0]?.detalle || '')
        }));
    }
    async findOne(id) {
        return this.prisma.alerta.findUnique({
            where: { id },
            include: {
                eventos: {
                    include: { usuario: { select: { fullName: true } } },
                    orderBy: { fechaHora: 'desc' }
                },
                asignadoA: true
            }
        });
    }
    async update(id, updateAlertDto, user) {
        const { comment, ...data } = updateAlertDto;
        const current = await this.prisma.alerta.findUnique({ where: { id } });
        if (!current)
            throw new Error('Alerta no encontrada');
        if (data.estado && ['SEGUIMIENTO', 'DESCARTADA', 'RESUELTA'].includes(data.estado) && !comment?.trim()) {
            throw new common_1.BadRequestException('Debe ingresar una nota de gestión para actualizar la alerta.');
        }
        const changes = [];
        if (data.estado && data.estado !== current.estado)
            changes.push(`Estado: ${current.estado} -> ${data.estado}`);
        if (data.prioridad && data.prioridad !== current.prioridad)
            changes.push(`Prioridad: ${current.prioridad} -> ${data.prioridad}`);
        if (data.asignadoId && data.asignadoId !== current.asignadoId)
            changes.push('Asignación actualizada');
        const updated = await this.prisma.alerta.update({
            where: { id },
            data: {
                ...data,
                fechaCierre: data.estado === 'RESUELTA' || data.estado === 'DESCARTADA' ? new Date() : undefined
            }
        });
        let finalDetail = changes.join(', ');
        if (comment) {
            finalDetail = finalDetail
                ? `${finalDetail}. Notas: ${comment}`
                : comment;
        }
        if (changes.length > 0) {
            await this.logEvent(id, 'CAMBIO_ESTADO', finalDetail, user.id);
        }
        else if (comment) {
            await this.logEvent(id, 'COMENTARIO', finalDetail, user.id);
        }
        return updated;
    }
    extractNotaGestion(detalle) {
        if (!detalle)
            return null;
        const marker = 'Notas:';
        if (detalle.includes(marker)) {
            const parts = detalle.split(marker);
            return parts[parts.length - 1].trim() || null;
        }
        return detalle.trim() || null;
    }
    async logEvent(alertaId, tipo, detalle, userId) {
        return this.prisma.alertaEvento.create({
            data: {
                alertaId,
                tipoEvento: tipo,
                detalle,
                usuarioId: userId
            }
        });
    }
};
exports.AlertsService = AlertsService;
exports.AlertsService = AlertsService = AlertsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AlertsService);
//# sourceMappingURL=alerts.service.js.map