import { Process, Processor } from '@nestjs/bull';
import { Logger } from '@nestjs/common';
import { Job } from 'bull';
import { PrismaService } from '../../prisma/prisma.service';

@Processor('audit')
export class AuditQueueProcessor {
    private readonly logger = new Logger(AuditQueueProcessor.name);

    constructor(private readonly prisma: PrismaService) { }

    @Process('log-api')
    async handleLogApi(job: Job) {
        try {
            await (this.prisma as any).auditoriaApi.create({
                data: job.data
            });
            // this.logger.debug(`Audit API log processed for path: ${job.data.ruta}`);
        } catch (error) {
            this.logger.error(`Failed to process audit API log: ${error.message}`, error.stack);
            throw error; // Reintento automático por Bull
        }
    }

    @Process('log-evento')
    async handleLogEvento(job: Job) {
        try {
            await (this.prisma as any).auditoriaEvento.create({
                data: job.data
            });
        } catch (error) {
            this.logger.error(`Failed to process audit Event log: ${error.message}`, error.stack);
            throw error;
        }
    }

    @Process('log-entidad')
    async handleLogEntidad(job: Job) {
        try {
            await (this.prisma as any).auditoriaEntidad.create({
                data: job.data
            });
        } catch (error) {
            this.logger.error(`Failed to process audit Entity log: ${error.message}`, error.stack);
            throw error;
        }
    }
}
