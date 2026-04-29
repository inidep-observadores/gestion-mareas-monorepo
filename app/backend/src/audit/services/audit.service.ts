import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateAuditApiDto } from '../dto/create-audit-api.dto';
import { CreateAuditEventoDto } from '../dto/create-audit-evento.dto';
import { CreateAuditEntidadDto } from '../dto/create-audit-entidad.dto';
import { CreateAuditoriaNavegacionDto } from '../dto/create-auditoria-navegacion.dto';
import { AuditLevel, AuditResultado } from '../enums/audit.enums';
import { sanitizeObject } from '../utils/sanitize.util';
import { AuditQueryDto } from '../dto/audit-query.dto';

@Injectable()
export class AuditService {
    private readonly logger = new Logger(AuditService.name);
    private readonly isAsync: boolean;
    private readonly level: AuditLevel;

    constructor(
        private readonly prisma: PrismaService,
        private readonly configService: ConfigService,
        @InjectQueue('audit') private readonly auditQueue: Queue
    ) {
        this.isAsync = this.configService.get<boolean>('audit.async.enabled', true);
        this.level = this.configService.get<AuditLevel>('audit.level', AuditLevel.ALL);
        
        this.logger.log(`AuditService Initialized (Async: ${this.isAsync}, Level: ${this.level})`);
    }

    private isTypeEnabled(type: 'api' | 'navigation' | 'entities' | 'events'): boolean {
        const globalEnabled = this.configService.get<boolean>('audit.enabled', true);
        if (!globalEnabled) return false;

        return this.configService.get<boolean>(`audit.${type}.enabled`, true);
    }

    private getPrismaModel(modelName: string) {
        const p = this.prisma as any;
        const camel = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const pascal = modelName.charAt(0).toUpperCase() + modelName.slice(1);

        const model = p[camel] || p[pascal];
        if (!model) {
            this.logger.error(`Prisma model NOT found in client: ${camel} or ${pascal}`);
        }
        return model;
    }

    async logApi(dto: CreateAuditApiDto) {
        if (!this.isTypeEnabled('api')) return;
        if (this.level === AuditLevel.NONE) return;
        if (this.level === AuditLevel.CRITICAL && !dto.esCritico) return;

        const sanitizedDto = {
            ...dto,
            queryParams: sanitizeObject(dto.queryParams),
            requestBody: sanitizeObject(dto.requestBody),
            responseBody: sanitizeObject(dto.responseBody),
        };

        try {
            if (this.isAsync) {
                await this.auditQueue.add('log-api', sanitizedDto, {
                    removeOnComplete: true,
                    attempts: 3
                });
            } else {
                const model = this.getPrismaModel('AuditoriaApi');
                if (model) await model.create({ data: sanitizedDto });
            }
        } catch (error) {
            this.logger.error(`Error logging API audit: ${error.message}`);
        }
    }

    async logEvento(dto: CreateAuditEventoDto) {
        if (!this.isTypeEnabled('events')) return;

        // Sanitización exhaustiva para evitar fallos de serialización en Bull o tipos en Prisma
        const sanitizedDto = {
            ...dto,
            entidadPrincipal: sanitizeObject(dto.entidadPrincipal),
            entidadesRelacionadas: sanitizeObject(dto.entidadesRelacionadas),
            metadata: sanitizeObject(dto.metadata)
        };

        try {
            if (this.isAsync) {
                await this.auditQueue.add('log-evento', sanitizedDto, {
                    removeOnComplete: true,
                    attempts: 3,
                    backoff: 5000
                });
            } else {
                const model = this.getPrismaModel('AuditoriaEvento');
                if (model) await model.create({ data: sanitizedDto });
            }
        } catch (error) {
            this.logger.error(`Error logging Event audit (${dto.tipoEvento}): ${error.message}`);
            
            // Fallback: registrar el error en el log de errores del sistema
            try {
                await this.prisma.errorLog.create({
                    data: {
                        message: `FALLO AUDITORIA EVENTO: ${dto.tipoEvento}. Error: ${error.message}`,
                        stack: error.stack,
                        path: 'AuditService.logEvento',
                        method: 'LOG',
                        userId: dto.usuarioId,
                        detail: { originalDto: dto }
                    }
                });
            } catch (e) {
                // Si esto también falla, no hay mucho más que podamos hacer sin persistencia
                console.error('CRITICAL: Failed to log audit failure to ErrorLog', e);
            }
        }
    }

    async logEntidad(dto: CreateAuditEntidadDto) {
        if (!this.isTypeEnabled('entities')) return;

        const sanitizedDto = {
            ...dto,
            valoresAnteriores: sanitizeObject(dto.valoresAnteriores),
            valoresNuevos: sanitizeObject(dto.valoresNuevos),
            contexto: sanitizeObject(dto.contexto)
        };

        try {
            if (this.isAsync) {
                await this.auditQueue.add('log-entidad', sanitizedDto, {
                    removeOnComplete: true,
                    attempts: 3
                });
            } else {
                const model = this.getPrismaModel('AuditoriaEntidad');
                if (model) await model.create({ data: sanitizedDto });
            }
        } catch (error) {
            this.logger.error(`Error logging Entity audit: ${error.message}`);
        }
    }

    async logNavigation(dto: CreateAuditoriaNavegacionDto) {
        if (!this.isTypeEnabled('navigation')) return;

        const sanitizedDto = {
            ...dto,
            params: sanitizeObject(dto.params),
            query: sanitizeObject(dto.query),
            metadata: sanitizeObject(dto.metadata)
        };

        try {
            if (this.isAsync) {
                await this.auditQueue.add('log-navigation', sanitizedDto, {
                    removeOnComplete: true,
                    attempts: 3
                });
            } else {
                const model = this.getPrismaModel('AuditoriaNavegacion');
                if (model) await model.create({ data: sanitizedDto });
            }
        } catch (error) {
            this.logger.error(`Error logging Navigation audit: ${error.message}`);
        }
    }

    async getStats() {
        const [eventos, entidades, navegacion, api] = await Promise.all([
            (this.prisma as any).auditoriaEvento.count(),
            (this.prisma as any).auditoriaEntidad.count(),
            (this.prisma as any).auditoriaNavegacion.count(),
            (this.prisma as any).auditoriaApi.count(),
        ]);

        return { eventos, entidades, navegacion, api };
    }

    async getEventos(query: AuditQueryDto) {
        const { limit = 50, offset = 0, tipoEvento, categoria, usuarioId, resultado, fechaDesde, fechaHasta } = query;

        const where: any = {};
        if (tipoEvento) where.tipoEvento = tipoEvento;
        if (categoria) where.categoria = categoria;
        if (usuarioId) where.usuarioId = usuarioId;
        if (resultado) where.resultado = resultado;
        if (fechaDesde || fechaHasta) {
            where.timestamp = {};
            if (fechaDesde) where.timestamp.gte = new Date(fechaDesde);
            if (fechaHasta) where.timestamp.lte = new Date(fechaHasta);
        }

        const [items, total] = await Promise.all([
            (this.prisma as any).auditoriaEvento.findMany({
                where,
                take: limit,
                skip: offset,
                orderBy: { timestamp: 'desc' },
                include: { usuario: { select: { id: true, fullName: true, email: true } } }
            }),
            (this.prisma as any).auditoriaEvento.count({ where })
        ]);

        return { items, total };
    }
}
