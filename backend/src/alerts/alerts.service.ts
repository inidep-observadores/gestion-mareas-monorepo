import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';

@Injectable()
export class AlertsService {
    private readonly logger = new Logger(AlertsService.name);

    constructor(private prisma: PrismaService) { }

    async create(createAlertDto: CreateAlertDto, user?: any) {
        const { codigoUnico } = createAlertDto;

        // 1. Uniqueness check
        const existing = await this.prisma.alerta.findUnique({
            where: { codigoUnico }
        });

        if (existing) {
            if (['DESCARTADA', 'RESUELTA'].includes(existing.estado)) {
                this.logger.log(`Alerta ${codigoUnico} ignorada (está ${existing.estado})`);
                return existing;
            }
            if (['PENDIENTE', 'SEGUIMIENTO'].includes(existing.estado)) {
                // Update last seen?
                return existing;
            }
            // If any other state, maybe reactivate
            return this.prisma.alerta.update({
                where: { id: existing.id },
                data: {
                    estado: 'PENDIENTE',
                    fechaDetectada: new Date(), // Refresh detection date
                    fechaCierre: null,
                    prioridad: createAlertDto.prioridad // Update priority if changed
                }
            });
        }

        // 2. Create new
        const alert = await this.prisma.alerta.create({
            data: {
                ...createAlertDto,
                fechaDetectada: new Date(),
                creadoPorId: user?.id
            }
        });

        // 3. Log Event
        await this.logEvent(alert.id, 'CREACION', 'Alerta detectada/creada', user?.id);

        return alert;
    }

    async findAll(query: any) {
        const { refId, status, userId } = query;
        const where: any = {};

        if (refId) where.referenciaId = refId;
        if (status) where.estado = status;
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
                creadoPor: { select: { fullName: true } }
            }
        });

        this.logger.log(`findAll results count: ${results.length}`);
        return results;
    }

    async findOne(id: string) {
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

    async update(id: string, updateAlertDto: UpdateAlertDto, user: any) {
        const { comment, ...data } = updateAlertDto;

        const current = await this.prisma.alerta.findUnique({ where: { id } });
        if (!current) throw new Error('Alerta no encontrada');

        // Detect changes for event logging
        const changes = [];
        if (data.estado && data.estado !== current.estado) changes.push(`Estado: ${current.estado} -> ${data.estado}`);
        if (data.prioridad && data.prioridad !== current.prioridad) changes.push(`Prioridad: ${current.prioridad} -> ${data.prioridad}`);
        if (data.asignadoId && data.asignadoId !== current.asignadoId) changes.push('Asignación actualizada');

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
        } else if (comment) {
            await this.logEvent(id, 'COMENTARIO', finalDetail, user.id);
        }

        return updated;
    }

    async logEvent(alertaId: string, tipo: string, detalle: string, userId?: string) {
        return this.prisma.alertaEvento.create({
            data: {
                alertaId,
                tipoEvento: tipo,
                detalle,
                usuarioId: userId
            }
        });
    }
}
