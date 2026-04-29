import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { AlertaEstado, AlertaPrioridad } from './alerts.enums';
import { AlertAutomationService } from './alert-automation.service';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAlertDto } from './dto/create-alert.dto';
import { UpdateAlertDto } from './dto/update-alert.dto';
import { DateUtils } from '../common/utils/date.utils';

@Injectable()
export class AlertsService {
    private readonly logger = new Logger(AlertsService.name);

    constructor(
        private prisma: PrismaService,
        private automationService: AlertAutomationService
    ) { }

    async create(createAlertDto: CreateAlertDto, user?: any) {
        const { codigoUnico } = createAlertDto;

        // 1. Uniqueness check
        const existing = await this.prisma.alerta.findUnique({
            where: { codigoUnico }
        });

        if (existing) {
            if ([AlertaEstado.DESCARTADA, AlertaEstado.RESUELTA].includes(existing.estado as any)) {
                this.logger.log(`Alerta ${codigoUnico} ignorada (está ${existing.estado})`);
                return existing;
            }
            if ([AlertaEstado.PENDIENTE, AlertaEstado.SEGUIMIENTO].includes(existing.estado as any)) {
                // Update last seen?
                return existing;
            }
            // If any other state, maybe reactivate
            return this.prisma.alerta.update({
                where: { id: existing.id },
                data: {
                    estado: AlertaEstado.PENDIENTE,
                    fechaDetectada: DateUtils.getNow(true), // Refresh detection date
                    fechaCierre: null,
                    prioridad: createAlertDto.prioridad // Update priority if changed
                }
            });
        }

        // 2. Create new
        const alert = await this.prisma.alerta.create({
            data: {
                ...createAlertDto,
                fechaDetectada: createAlertDto.fechaDetectada || DateUtils.getNow(true),
                creadoPorId: user?.id
            } as any
        });

        // 3. Log Event
        await this.logEvent(alert.id, 'CREACION', 'Alerta detectada/creada', user?.id);

        return alert;
    }

    async findAll(query: any) {
        const { refId, status, userId, showHidden, type, busqueda } = query;
        const where: any = {};

        // Filter by visibility by default
        if (showHidden !== 'true') {
            where.visible = true;
        }

        if (refId) where.referenciaId = refId;
        if (status) {
            if (status.includes(',')) {
                where.estado = { in: status.split(',') };
            } else {
                where.estado = status;
            }
        }
        if (type) {
            if (type.includes(',')) {
                where.tipo = { in: type.split(',') };
            } else {
                where.tipo = type;
            }
        }
        if (userId) {
            where.OR = [
                { asignadoId: userId },
                { creadoPorId: userId },
                { eventos: { some: { usuarioId: userId } } }
            ];
        }

        if (busqueda) {
            const searchCondition = {
                OR: [
                    { titulo: { contains: busqueda, mode: 'insensitive' } },
                    { metadata: { path: ['vesselName'], string_contains: busqueda } },
                    { metadata: { path: ['mareaCode'], string_contains: busqueda } },
                    { metadata: { path: ['portName'], string_contains: busqueda } }
                ]
            };

            if (where.OR) {
                // Si ya había un OR (por userId), los combinamos en un AND
                const previousOr = where.OR;
                delete where.OR;
                where.AND = [{ OR: previousOr }, searchCondition];
            } else {
                where.OR = searchCondition.OR;
            }
        }

        this.logger.log(`findAll query: ${JSON.stringify(where)}`);

        // Pagination and Sorting
        const page = parseInt(query.page) || 1;
        const limit = parseInt(query.limit) || 20;
        const skip = (page - 1) * limit;

        const sortBy = query.sortBy || 'fechaDetectada';
        const sortOrder = query.sortOrder || 'desc';

        const [total, results] = await Promise.all([
            this.prisma.alerta.count({ where }),
            this.prisma.alerta.findMany({
                where,
                orderBy: { [sortBy]: sortOrder },
                take: limit,
                skip,
                include: {
                    asignadoA: { select: { fullName: true, avatarUrl: true } },
                    creadoPor: { select: { fullName: true } },
                    eventos: {
                        select: { detalle: true },
                        orderBy: { fechaHora: 'desc' },
                        take: 1
                    }
                }
            })
        ]);

        this.logger.log(`findAll results count: ${results.length}, total: ${total}`);

        const data = results.map((alerta: any) => ({
            ...alerta,
            notaGestion: this.extractNotaGestion(alerta.eventos?.[0]?.detalle || '')
        }));

        // Si se solicitó paginación explícitamente o es modo administrativo, devolvemos objeto estructurado
        if (query.page || query.limit) {
            return {
                data,
                total,
                page,
                limit
            };
        }

        return data; // Retrocompatibilidad
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
        if (data.estado && [AlertaEstado.SEGUIMIENTO, AlertaEstado.DESCARTADA, AlertaEstado.RESUELTA].includes(data.estado as any) && !comment?.trim()) {
            throw new BadRequestException('Debe ingresar una nota de gestión para actualizar la alerta.');
        }

        // Detect changes for event logging
        const changes = [];
        if (data.estado && data.estado !== current.estado) changes.push(`Estado: ${current.estado} -> ${data.estado}`);
        if (data.prioridad && data.prioridad !== current.prioridad) changes.push(`Prioridad: ${current.prioridad} -> ${data.prioridad}`);
        if (data.asignadoId && data.asignadoId !== current.asignadoId) changes.push('Asignación actualizada');

        const updated = await this.prisma.alerta.update({
            where: { id },
            data: {
                ...data,
                fechaCierre: data.estado === AlertaEstado.RESUELTA || data.estado === AlertaEstado.DESCARTADA ? DateUtils.getNow(true) : undefined
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

    private extractNotaGestion(detalle: string): string | null {
        if (!detalle) return null;
        const marker = 'Notas:';
        if (detalle.includes(marker)) {
            const parts = detalle.split(marker);
            return parts[parts.length - 1].trim() || null;
        }
        return detalle.trim() || null;
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

    /**
     * Add a validation source to an existing alert
     * Used when multiple detection systems confirm the same event
     */
    async addValidationSource(alertaId: string, sourceName: string, sourceData: any) {
        const alert = await this.prisma.alerta.findUnique({ where: { id: alertaId } });
        if (!alert) {
            throw new Error(`Alert ${alertaId} not found`);
        }

        // Get current metadata
        const metadata = (alert.metadata as any) || {};
        let sources = metadata.sources || [];

        // Si el array de fuentes está vacío, intentar recuperar la fuente original de metadata.source
        if (sources.length === 0 && metadata.source) {
            sources = [{
                name: metadata.source,
                detectedAt: alert.fechaDetectada?.toISOString(),
                data: { info: 'Fuente primaria original' }
            }];
        }

        // Check if source already exists
        const existingSource = sources.find((s: any) => s.name === sourceName);
        if (existingSource) {
            this.logger.log(`Source ${sourceName} already validated alert ${alertaId}`);
            return alert;
        }

        // Add new validation source
        sources.push({
            name: sourceName,
            detectedAt: new Date().toISOString(),
            data: sourceData,
        });

        // Update metadata
        const updatedAlert = await this.prisma.alerta.update({
            where: { id: alertaId },
            data: {
                metadata: {
                    ...metadata,
                    sources,
                },
            },
        });

        // Log event
        await this.logEvent(
            alertaId,
            'VALIDACION',
            `Alerta confirmada por fuente adicional: ${sourceName}`,
        );

        this.logger.log(`Added validation source ${sourceName} to alert ${alertaId}`);

        // Disparar proceso de automatización (sin esperar el resultado para no bloquear el flujo principal)
        this.automationService.processAlertAutomation(updatedAlert.id).catch(err => {
            this.logger.error(`Error en automatización de alerta ${alertaId}: ${err.message}`);
        });

        return updatedAlert;
    }
}
