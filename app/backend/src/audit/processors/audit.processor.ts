import { Process, Processor } from '@nestjs/bull';
import { Injectable, Logger } from '@nestjs/common';
import { Job } from 'bull';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
@Processor('audit')
export class AuditQueueProcessor {
    private readonly logger = new Logger(AuditQueueProcessor.name);

    constructor(private readonly prisma: PrismaService) { }

    private getModel(name: string) {
        const p = this.prisma as any;
        const camel = name.charAt(0).toLowerCase() + name.slice(1);
        const pascal = name.charAt(0).toUpperCase() + name.slice(1);

        const model = p[camel] || p[pascal];
        if (!model) {
            this.logger.error(`Prisma model NOT found in client: ${camel} or ${pascal}`);
        }
        return model;
    }

    @Process('log-api')
    async handleLogApi(job: Job) {
        try {
            const model = this.getModel('AuditoriaApi');
            if (model) await model.create({ data: job.data });
        } catch (error) {
            this.logger.error(`Failed to process audit API log: ${error.message}`, error.stack);
            throw error;
        }
    }

    @Process('log-evento')
    async handleLogEvento(job: Job) {
        try {
            const model = this.getModel('AuditoriaEvento');
            if (model) await model.create({ data: job.data });
        } catch (error) {
            this.logger.error(`Failed to process audit Event log: ${error.message}`, error.stack);
            throw error;
        }
    }

    @Process('log-entidad')
    async handleLogEntidad(job: Job) {
        try {
            const model = this.getModel('AuditoriaEntidad');
            if (model) await model.create({ data: job.data });
        } catch (error) {
            this.logger.error(`Failed to process audit Entity log: ${error.message}`, error.stack);
            throw error;
        }
    }

    @Process('log-navigation')
    async handleLogNavigation(job: Job) {
        try {
            const model = this.getModel('AuditoriaNavegacion');
            if (model) await model.create({ data: job.data });
        } catch (error) {
            this.logger.error(`Failed to process audit Navigation log: ${error.message}`, error.stack);
            throw error;
        }
    }
}
