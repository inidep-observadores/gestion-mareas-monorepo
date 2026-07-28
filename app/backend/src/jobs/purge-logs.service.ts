import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PurgeLogsService {
    private readonly logger = new Logger(PurgeLogsService.name);

    constructor(
        private readonly prisma: PrismaService,
        private readonly configService: ConfigService
    ) {}

    // Ejecutar todos los días a las 3:00 AM
    @Cron(CronExpression.EVERY_DAY_AT_3AM)
    async purgeIgnoredEmails() {
        const retentionDaysStr = this.configService.get<string>('EMAIL_LOGS_RETENTION_DAYS');
        
        // Si no está definido, o es 0/nulo, se asume indefinido (no purgar)
        if (!retentionDaysStr) {
            this.logger.debug('Purga de logs ignorados está deshabilitada (EMAIL_LOGS_RETENTION_DAYS no configurado o nulo).');
            return;
        }

        const retentionDays = parseInt(retentionDaysStr, 10);
        if (isNaN(retentionDays) || retentionDays <= 0) {
            this.logger.debug('Purga de logs ignorados está deshabilitada (EMAIL_LOGS_RETENTION_DAYS = 0).');
            return;
        }

        this.logger.log(`Iniciando purga de logs de email IGNORADOS o SIN_NOVEDAD anteriores a ${retentionDays} días.`);
        
        const cutoffDate = new Date();
        cutoffDate.setDate(cutoffDate.getDate() - retentionDays);

        try {
            const result = await this.prisma.novedadesEmailLog.deleteMany({
                where: {
                    estado: { in: ['IGNORADO', 'SIN_NOVEDAD'] },
                    fechaProcesamiento: {
                        lt: cutoffDate
                    }
                }
            });

            if (result.count > 0) {
                this.logger.log(`Se eliminaron ${result.count} registros antiguos de logs de email ignorados.`);
            } else {
                this.logger.debug('No hay logs de email ignorados antiguos para purgar.');
            }
        } catch (error: any) {
            this.logger.error(`Error durante la purga de logs de email: ${error.message}`);
        }
    }
}
