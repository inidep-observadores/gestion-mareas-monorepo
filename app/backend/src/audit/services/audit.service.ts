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
            
            try {
                // Convertir DTO a un objeto plano compatible con Prisma Json
                const detail = JSON.parse(JSON.stringify({ originalDto: dto }));
                
                await this.prisma.errorLog.create({
                    data: {
                        level: 'ERROR',
                        source: 'AUDIT_SERVICE',
                        message: `FALLO AUDITORIA EVENTO: ${dto.tipoEvento}. Error: ${error.message}`,
                        stack: error.stack,
                        path: 'AuditService.logEvento',
                        method: 'LOG',
                        userId: dto.usuarioId,
                        detail
                    }
                });
            } catch (e) {
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
            // Nota: El DTO usa 'parametros', no 'params/query' directamente
            parametros: sanitizeObject(dto.parametros),
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

    // Alias para compatibilidad con el controlador antiguo
    async logNavegacion(dto: CreateAuditoriaNavegacionDto) {
        return this.logNavigation(dto);
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

    // Métodos de consulta requeridos por el controlador
    async findApiLogs(query: AuditQueryDto) {
        const { limit = 50, skip, usuarioId, desde, hasta } = query;
        const where: any = {};
        if (usuarioId) where.usuarioId = usuarioId;
        if (desde || hasta) {
            where.timestamp = {};
            if (desde) where.timestamp.gte = new Date(desde);
            if (hasta) where.timestamp.lte = new Date(hasta);
        }

        const [items, total] = await Promise.all([
            (this.prisma as any).auditoriaApi.findMany({
                where,
                take: limit,
                skip,
                orderBy: { timestamp: 'desc' },
                include: { usuario: { select: { id: true, fullName: true, email: true } } }
            }),
            (this.prisma as any).auditoriaApi.count({ where })
        ]);
        return { data: items, total };
    }

    async findEntityLogs(query: AuditQueryDto) {
        const { limit = 50, skip, usuarioId, desde, hasta, tipo, entidadId } = query;
        const where: any = {};
        if (usuarioId) where.usuarioId = usuarioId;
        if (tipo) where.entidadTipo = tipo;
        if (entidadId) where.entidadId = entidadId;
        if (desde || hasta) {
            where.timestamp = {};
            if (desde) where.timestamp.gte = new Date(desde);
            if (hasta) where.timestamp.lte = new Date(hasta);
        }

        const [items, total] = await Promise.all([
            (this.prisma as any).auditoriaEntidad.findMany({
                where,
                take: limit,
                skip,
                orderBy: { timestamp: 'desc' },
                include: { usuario: { select: { id: true, fullName: true, email: true } } }
            }),
            (this.prisma as any).auditoriaEntidad.count({ where })
        ]);
        return { data: items, total };
    }

    async findEventLogs(query: AuditQueryDto) {
        const { limit = 50, skip, usuarioId, desde, hasta, tipo, categoria } = query;
        const where: any = {};
        if (usuarioId) where.usuarioId = usuarioId;
        if (tipo) where.tipoEvento = tipo;
        if (categoria) where.categoria = categoria;
        if (desde || hasta) {
            where.timestamp = {};
            if (desde) where.timestamp.gte = new Date(desde);
            if (hasta) where.timestamp.lte = new Date(hasta);
        }

        const [items, total] = await Promise.all([
            (this.prisma as any).auditoriaEvento.findMany({
                where,
                take: limit,
                skip,
                orderBy: { timestamp: 'desc' },
                include: { usuario: { select: { id: true, fullName: true, email: true } } }
            }),
            (this.prisma as any).auditoriaEvento.count({ where })
        ]);
        return { data: items, total };
    }

    async findNavigationLogs(query: AuditQueryDto) {
        const { limit = 50, skip, usuarioId, desde, hasta } = query;
        const where: any = {};
        if (usuarioId) where.usuarioId = usuarioId;
        if (desde || hasta) {
            where.timestamp = {};
            if (desde) where.timestamp.gte = new Date(desde);
            if (hasta) where.timestamp.lte = new Date(hasta);
        }

        const [items, total] = await Promise.all([
            (this.prisma as any).auditoriaNavegacion.findMany({
                where,
                take: limit,
                skip,
                orderBy: { timestamp: 'desc' },
                include: { usuario: { select: { id: true, fullName: true, email: true } } }
            }),
            (this.prisma as any).auditoriaNavegacion.count({ where })
        ]);
        return { data: items, total };
    }
}
