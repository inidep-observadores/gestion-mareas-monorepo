import { Injectable, Logger } from '@nestjs/common';
import { JobProcessor } from '../job-types';
import { VesselSyncService } from '../../catalogos/buques/vessel-sync.service';

@Injectable()
export class VesselSyncProcessor implements JobProcessor {
    private readonly logger = new Logger(VesselSyncProcessor.name);

    constructor(private readonly vesselSyncService: VesselSyncService) { }

    async process(payload: any): Promise<any> {
        const { id, nombreBuque, matricula } = payload;
        this.logger.log(`Processing vessel sync for ID: ${id}, Nombre: ${nombreBuque}, Matrícula: ${matricula || 'N/A'}`);

        // Aquí implementaremos el rate limiting si es necesario inyectando el config
        const rateLimit = parseInt(process.env.VESSEL_SYNC_RATE_LIMIT_MS || '1000', 10);
        if (rateLimit > 0) {
            await new Promise(resolve => setTimeout(resolve, rateLimit));
        }

        await this.vesselSyncService.executeVesselSync(id);

        // Retornar información sobre la sincronización ejecutada
        return {
            vesselId: id,
            vesselName: nombreBuque,
            matricula: matricula || null,
            syncedAt: new Date().toISOString(),
        };
    }
}
