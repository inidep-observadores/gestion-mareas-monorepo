import { Injectable, Logger } from '@nestjs/common';
import { JobProcessor, JobType } from '../job-types';
import { PnaApiService } from '../../pna-api/pna-api.service';

@Injectable()
export class PnaApiSyncProcessor implements JobProcessor {
    private readonly logger = new Logger(PnaApiSyncProcessor.name);

    constructor(private readonly pnaApiService: PnaApiService) { }

    async process(payload: any): Promise<any> {
        this.logger.log('Iniciando sincronización de movimientos desde API PNA...');

        try {
            const summary = await this.pnaApiService.processMovements();

            // Solo si tuvo éxito (no lanzó error), actualizamos la fecha de última sincronización
            await this.pnaApiService.updateLastSuccessfulSyncDate(new Date());

            this.logger.log(`Sincronización finalizada exitosamente: ${JSON.stringify(summary)}`);

            return {
                success: true,
                summary,
                timestamp: new Date().toISOString()
            };
        } catch (error) {
            this.logger.error('Error procesando sincronización de PNA:', error);
            throw error;
        }
    }
}
