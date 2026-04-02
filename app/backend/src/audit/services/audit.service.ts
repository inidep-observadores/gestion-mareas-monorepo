import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateAuditApiDto } from '../dto/create-audit-api.dto';
import { CreateAuditEventoDto } from '../dto/create-audit-evento.dto';
import { CreateAuditEntidadDto } from '../dto/create-audit-entidad.dto';
import { CreateAuditoriaNavegacionDto } from '../dto/create-auditoria-navegacion.dto';
import { AuditLevel } from '../enums/audit.enums';
import { sanitizeObject } from '../utils/sanitize.util';
import { AuditQueryDto } from '../dto/audit-query.dto';

@Injectable()
export class AuditService {
    private readonly logger = new Logger(AuditService.name);
    private readonly isEnabled: boolean;
    private readonly isAsync: boolean;
    private readonly level: AuditLevel;

    constructor(
        private readonly prisma: PrismaService,
        private readonly configService: ConfigService,
        @InjectQueue('audit') private readonly auditQueue: Queue
    ) {
        this.isAsync = this.configService.get<boolean>('audit.async.enabled', true);
        this.level = this.configService.get<AuditLevel>('audit.level', AuditLevel.ALL);

        const globalEnabled = this.configService.get<boolean>('audit.enabled', true);
        const apiEnabled = this.configService.get<boolean>('audit.api.enabled', true);
        const navEnabled = this.configService.get<boolean>('audit.navigation.enabled', true);

        this.logger.log(`AuditService Initialized (Async: ${this.isAsync}, Level: ${this.level})`);
    }

    private isTypeEnabled(type: 'api' | 'navigation' | 'entities' | 'events'): boolean {
        const globalEnabled = this.configService.get<boolean>('audit.enabled', true);
        if (!globalEnabled) return false;

        return this.configService.get<boolean>(`audit.${type}.enabled`, true);
    }

    /**
     * Helper para obtener el modelo de Prisma manejando posibles variaciones de nombre (camel vs Pascal)
     */
    private getPrismaModel(modelName: string) {
        const p = this.prisma as any;
        const camel = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const pascal = modelName.charAt(0).toUpperCase() + modelName.slice(1);

        const model = p[camel] || p[pascal];
        if (!model) {
            this.logger.error(`Prisma model NOT found in client: ${camel} or ${pascal}. Ensure 'npx prisma generate' was run.`);
        }
        return model;
    }

    /**
     * Registra una auditoría de API (HTTP Request/Response)
     */
    async logApi(dto: CreateAuditApiDto) {
        if (!this.isTypeEnabled('api')) return;
        if (this.level === AuditLevel.NONE) return;
        if (this.level === AuditLevel.CRITICAL && !dto.esCritico) return;

        // Sanitizar datos sensibles antes de guardar
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
            this.logger.error(`Error logging API audit: ${error.message}`, error.stack);
        }
    }

    /**
     * Registra un evento de negocio específico
     */
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
                this.logger.debug(`Adding event to Bull queue: ${dto.tipoEvento}`);
                await this.auditQueue.add('log-evento', sanitizedDto, {
                    removeOnComplete: true,
                    attempts: 3
                });
            } else {
                const model = this.getPrismaModel('AuditoriaEvento');
                if (model) {
                    this.logger.debug(`Saving event to DB synchronously: ${dto.tipoEvento}`);
                    await model.create({ data: sanitizedDto });
                }
            }
        } catch (error) {
            this.logger.error(`Error logging Event audit: ${error.message}`, error.stack);
        }
    }

    /**
     * Registra cambios en entidades (normalmente llamado desde interceptores o decorators)
     */
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
            this.logger.error(`Error logging Entity audit: ${error.message}`, error.stack);
        }
    }

    /**
     * Registra un evento de navegación del usuario
     */
    async logNavegacion(dto: CreateAuditoriaNavegacionDto) {
        if (!this.isTypeEnabled('navigation')) return;

        try {
            if (this.isAsync) {
                await this.auditQueue.add('log-navegacion', dto, {
                    removeOnComplete: true,
                    attempts: 3
                });
            } else {
                const model = this.getPrismaModel('AuditoriaNavegacion');
                if (model) await model.create({ data: dto });
            }
        } catch (error) {
            this.logger.error(`Error logging Navigation audit: ${error.message}`, error.stack);
        }
    }
    /**
     * Obtiene logs de API con filtrado y paginación
     */
    async findApiLogs(query: AuditQueryDto) {
        const where: any = {};

        if ((query.desde && query.desde.trim() !== '') || (query.hasta && query.hasta.trim() !== '')) {
            where.timestamp = {};
            if (query.desde && query.desde.trim() !== '') where.timestamp.gte = new Date(query.desde);
            if (query.hasta && query.hasta.trim() !== '') where.timestamp.lte = new Date(query.hasta);
        }

        if (query.usuarioId && query.usuarioId.trim() !== '') where.usuarioId = query.usuarioId;
        if (query.categoria && query.categoria.trim() !== '') where.categoria = query.categoria;
        if (query.soloErrores) where.esError = true;
        if (query.busqueda && query.busqueda.trim() !== '') {
            const search = query.busqueda.trim();
            where.OR = [
                { ruta: { contains: search, mode: 'insensitive' } },
                { usuarioEmail: { contains: search, mode: 'insensitive' } },
            ];
        }

        const model = this.getPrismaModel('AuditoriaApi');
        if (!model) return { total: 0, data: [], page: query.page, limit: query.limit };

        const [total, data] = await Promise.all([
            model.count({ where }),
            model.findMany({
                where,
                skip: query.skip,
                take: query.limit,
                orderBy: { timestamp: 'desc' },
            })
        ]);

        return { total, data, page: query.page, limit: query.limit };
    }

    /**
     * Obtiene logs de cambios en entidades
     */
    async findEntityLogs(query: AuditQueryDto) {
        const where: any = {};

        if ((query.desde && query.desde.trim() !== '') || (query.hasta && query.hasta.trim() !== '')) {
            where.timestamp = {};
            if (query.desde && query.desde.trim() !== '') where.timestamp.gte = new Date(query.desde);
            if (query.hasta && query.hasta.trim() !== '') where.timestamp.lte = new Date(query.hasta);
        }

        if (query.usuarioId && query.usuarioId.trim() !== '') where.usuarioId = query.usuarioId;
        if (query.tipo && query.tipo.trim() !== '') where.entidadTipo = query.tipo;
        if (query.entidadId && query.entidadId.trim() !== '') where.entidadId = query.entidadId;
        if (query.busqueda && query.busqueda.trim() !== '') {
            const search = query.busqueda.trim();
            where.OR = [
                { entidadTipo: { contains: search, mode: 'insensitive' } },
                { entidadId: { contains: search, mode: 'insensitive' } },
                { usuarioEmail: { contains: search, mode: 'insensitive' } },
            ];
        }

        const model = this.getPrismaModel('AuditoriaEntidad');
        if (!model) return { total: 0, data: [], page: query.page, limit: query.limit };

        const [total, data] = await Promise.all([
            model.count({ where }),
            model.findMany({
                where,
                skip: query.skip,
                take: query.limit,
                orderBy: { timestamp: 'desc' },
            })
        ]);

        return { total, data, page: query.page, limit: query.limit };
    }

    /**
     * Obtiene logs de eventos de negocio
     */
    async findEventLogs(query: AuditQueryDto) {
        const where: any = {};

        if ((query.desde && query.desde.trim() !== '') || (query.hasta && query.hasta.trim() !== '')) {
            where.timestamp = {};
            if (query.desde && query.desde.trim() !== '') where.timestamp.gte = new Date(query.desde);
            if (query.hasta && query.hasta.trim() !== '') where.timestamp.lte = new Date(query.hasta);
        }

        if (query.usuarioId && query.usuarioId.trim() !== '') where.usuarioId = query.usuarioId;
        if (query.categoria && query.categoria.trim() !== '') where.categoria = query.categoria;
        if (query.tipo && query.tipo.trim() !== '') where.tipoEvento = query.tipo;
        if (query.soloErrores) where.resultado = 'ERROR';
        if (query.busqueda && query.busqueda.trim() !== '') {
            const search = query.busqueda.trim();
            where.OR = [
                { tipoEvento: { contains: search, mode: 'insensitive' } },
                { descripcion: { contains: search, mode: 'insensitive' } },
                { usuarioEmail: { contains: search, mode: 'insensitive' } },
            ];
        }

        const model = this.getPrismaModel('AuditoriaEvento');
        if (!model) return { total: 0, data: [], page: query.page, limit: query.limit };

        const [total, data] = await Promise.all([
            model.count({ where }),
            model.findMany({
                where,
                skip: query.skip,
                take: query.limit,
                orderBy: { timestamp: 'desc' },
            })
        ]);

        return { total, data, page: query.page, limit: query.limit };
    }
    /**
     * Obtiene logs de navegación con filtrado y paginación
     */
    async findNavigationLogs(query: AuditQueryDto) {
        const where: any = {};

        if ((query.desde && query.desde.trim() !== '') || (query.hasta && query.hasta.trim() !== '')) {
            where.timestamp = {};
            if (query.desde && query.desde.trim() !== '') where.timestamp.gte = new Date(query.desde);
            if (query.hasta && query.hasta.trim() !== '') where.timestamp.lte = new Date(query.hasta);
        }

        if (query.usuarioId && query.usuarioId.trim() !== '') where.usuarioId = query.usuarioId;
        if (query.busqueda && query.busqueda.trim() !== '') {
            const search = query.busqueda.trim();
            where.OR = [
                { rutaDestino: { contains: search, mode: 'insensitive' } },
                { sessionId: { contains: search, mode: 'insensitive' } },
            ];
        }

        const model = this.getPrismaModel('AuditoriaNavegacion');
        if (!model) return { total: 0, data: [], page: query.page, limit: query.limit };

        const [total, data] = await Promise.all([
            model.count({ where }),
            model.findMany({
                where,
                skip: query.skip,
                take: query.limit,
                orderBy: { timestamp: 'desc' },
            })
        ]);

        return { total, data, page: query.page, limit: query.limit };
    }
}
