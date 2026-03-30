import { Injectable, Logger } from '@nestjs/common';
import { JobProcessor } from '../job-types';
import { PnaTrackingService } from '../../pna-api/pna-tracking.service';

@Injectable()
export class PnaTrackingSyncProcessor implements JobProcessor {
    private readonly logger = new Logger(PnaTrackingSyncProcessor.name);

    constructor(private readonly pnaTrackingService: PnaTrackingService) { }

    async process(payload: { fromDate: string; toDate: string; isLastBlock?: boolean; onlyIngest?: boolean }): Promise<any> {
        this.logger.log(`Iniciando fragmento de sincronización de tracking PNA: ${payload.fromDate} -> ${payload.toDate}`);

        try {
            const fromDate = new Date(payload.fromDate);
            const toDate = new Date(payload.toDate);
            const onlyIngest = payload?.onlyIngest === true;

            const result = await this.pnaTrackingService.syncTrackingData(fromDate, toDate, onlyIngest);

            return {
                success: true,
                result,
                timestamp: new Date().toISOString()
            };
        } catch (error) {
            this.logger.error('Error procesando fragmento de sincronización de tracking PNA:', error);
            throw error;
        }
    }
}
