import { Controller, Post, Get, Body, BadRequestException } from '@nestjs/common';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { PnaTrackingService } from './pna-tracking.service';
import { PnaApiService, ProcessingSummary } from './pna-api.service';
import { SchedulerService } from '../jobs/scheduler.service';

@Controller('pna-api')
export class PnaApiController {
    constructor(
        private readonly pnaTrackingService: PnaTrackingService,
        private readonly pnaApiService: PnaApiService,
        private readonly schedulerService: SchedulerService
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
    async triggerManualSync(@Body() body: { type: 'API' | 'TRACKING', fromDate: string, toDate: string }) {
        const { type, fromDate, toDate } = body;

        if (!fromDate || !toDate) {
            throw new BadRequestException('fromDate and toDate are required');
        }

        const desde = new Date(fromDate);
        const hasta = new Date(toDate);

        if (type === 'API') {
            return this.pnaApiService.processMovements(desde, hasta);
        } else if (type === 'TRACKING') {
            return this.pnaTrackingService.scheduleSynchronization(desde, hasta);
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
