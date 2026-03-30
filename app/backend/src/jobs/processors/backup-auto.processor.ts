import { Injectable, Logger } from '@nestjs/common';
import { BackupService } from '../../admin/backup/backup.service';
import { JobProcessor } from '../job-types';

@Injectable()
export class BackupAutoProcessor implements JobProcessor {
    private readonly logger = new Logger(BackupAutoProcessor.name);

    constructor(private readonly backupService: BackupService) {}

    async process(_payload: any): Promise<any> {
        const now = new Date().toLocaleString('es-AR', { timeZone: 'America/Argentina/Buenos_Aires', dateStyle: 'short', timeStyle: 'short' });
        const comment = `[AUTOMÁTICO] Respaldo diario del sistema generado automáticamente el ${now}`;

        this.logger.log(`Iniciando copia de seguridad automática diaria (esquema: public). Comentario: "${comment}"`);
        const result = await this.backupService.createBackup(comment, ['public']);
        this.logger.log(`Copia automática completada: ${result.filename}`);
        return result;
    }
}
