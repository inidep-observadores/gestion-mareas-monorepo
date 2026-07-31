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
            const fromDate = payload?.fromDate ? new Date(payload.fromDate) : undefined;
            const toDate = payload?.toDate ? new Date(payload.toDate) : undefined;
            const onlyIngest = payload?.onlyIngest === true;
            const isLongSync = payload?.isLongSync === true;

            const summary = await this.pnaApiService.processMovements(fromDate, toDate, onlyIngest, isLongSync);

            // Si la ejecución llegó hasta acá sin errores (catch), significa que consultó
            // exitosamente la API. Incluso si no hubo datos, el tiempo debe avanzar para evitar bucles.
            const targetDate = toDate || new Date();
            await this.pnaApiService.updateLastSuccessfulSyncDate(targetDate, isLongSync);

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
