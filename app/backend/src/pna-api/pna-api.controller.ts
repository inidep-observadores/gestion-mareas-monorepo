import { Controller, Post, Get, Body, BadRequestException } from '@nestjs/common';
import { DateTime } from 'luxon';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { PnaTrackingService } from './pna-tracking.service';
import { PnaApiService, ProcessingSummary } from './pna-api.service';
import { SchedulerService } from '../jobs/scheduler.service';
import { ConfigService } from '@nestjs/config';

@Controller('pna-api')
export class PnaApiController {
    constructor(
        private readonly pnaTrackingService: PnaTrackingService,
        private readonly pnaApiService: PnaApiService,
        private readonly schedulerService: SchedulerService,
        private readonly configService: ConfigService,
    ) { }

    @Get('config')
    @Auth(ValidRoles.admin)
    async getConfig() {
        return this.schedulerService.getAutoSyncConfig();
    }

    @Post('config')
    @Auth(ValidRoles.admin)
    async updateConfig(@Body() config: any) {
        return this.schedulerService.updateAutoSyncConfig(config);
    }

    @Post('sync-manual')
    @Auth(ValidRoles.admin)
    async triggerManualSync(@Body() body: { type: 'API' | 'TRACKING', fromDate: string, toDate: string, onlyIngest?: boolean }) {
        const { type, fromDate, toDate, onlyIngest = false } = body;

        if (!fromDate || !toDate) {
            throw new BadRequestException('fromDate and toDate are required');
        }

        // IMPORTANTE: El usuario introduce fechas en hora local (Argentina).
        // Las interpretamos correctamente antes de pasarlas al servicio.
        const timezone = 'America/Argentina/Buenos_Aires';
        const desde = DateTime.fromISO(fromDate, { zone: timezone }).toJSDate();
        const hasta = DateTime.fromISO(toDate, { zone: timezone }).toJSDate();

        if (type === 'API') {
            const differenceInDays = (hasta.getTime() - desde.getTime()) / (1000 * 3600 * 24);
            const safeRangeDays = parseInt(this.configService.get<string>('PNA_API_SYNC_SAFE_RANGE_DAYS') || '20', 10);

            if (differenceInDays > safeRangeDays) {
                return this.pnaApiService.scheduleManualSynchronization(desde, hasta, onlyIngest);
            } else {
                return this.pnaApiService.processMovements(desde, hasta, onlyIngest);
            }
        } else if (type === 'TRACKING') {
            return this.pnaTrackingService.scheduleSynchronization(desde, hasta, onlyIngest);
        } else {
            throw new BadRequestException('Invalid sync type');
        }
    }

    @Post('sync-tracking')
    @Auth(ValidRoles.admin)
    async triggerTrackingSync() {
        return this.pnaTrackingService.scheduleSynchronization();
    }
}
