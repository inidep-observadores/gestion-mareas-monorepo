import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateAuditApiDto } from '../dto/create-audit-api.dto';
import { CreateAuditEventoDto } from '../dto/create-audit-evento.dto';
import { CreateAuditEntidadDto } from '../dto/create-audit-entidad.dto';
import { AuditLevel } from '../enums/audit.enums';
import { sanitizeObject } from '../utils/sanitize.util';

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
        this.isEnabled = this.configService.get<boolean>('audit.enabled', true);
        this.isAsync = this.configService.get<boolean>('audit.async', true);
        this.level = this.configService.get<AuditLevel>('audit.level', AuditLevel.ALL);
    }

    /**
     * Registra una auditoría de API (HTTP Request/Response)
     */
    async logApi(dto: CreateAuditApiDto) {
        if (!this.isEnabled) return;
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
                await (this.prisma as any).auditoriaApi.create({
                    data: sanitizedDto as any // Type cast necesario hasta que Prisma genere los tipos
                });
            }
        } catch (error) {
            this.logger.error(`Error logging API audit: ${error.message}`, error.stack);
        }
    }

    /**
     * Registra un evento de negocio específico
     */
    async logEvento(dto: CreateAuditEventoDto) {
        if (!this.isEnabled) return;

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
                    attempts: 3
                });
            } else {
                await (this.prisma as any).auditoriaEvento.create({
                    data: sanitizedDto as any
                });
            }
        } catch (error) {
            this.logger.error(`Error logging Event audit: ${error.message}`, error.stack);
        }
    }

    /**
     * Registra cambios en entidades (normalmente llamado desde interceptores o decorators)
     */
    async logEntidad(dto: CreateAuditEntidadDto) {
        if (!this.isEnabled) return;

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
                await (this.prisma as any).auditoriaEntidad.create({
                    data: sanitizedDto as any
                });
            }
        } catch (error) {
            this.logger.error(`Error logging Entity audit: ${error.message}`, error.stack);
        }
    }
}
