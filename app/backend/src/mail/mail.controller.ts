import { Controller, Post, Get, Body } from '@nestjs/common';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { SchedulerService } from '../jobs/scheduler.service';
import { JobQueueService } from '../jobs/job-queue.service';
import { JobType } from '@prisma/client';

@Controller('mail-admin')
export class MailController {
    constructor(
        private readonly schedulerService: SchedulerService,
        private readonly jobQueueService: JobQueueService,
    ) { }

    @Get('config')
    @Auth(ValidRoles.admin)
    async getConfig() {
        return this.schedulerService.getNovedadesSyncConfig();
    }

    @Post('config')
    @Auth(ValidRoles.admin)
    async updateConfig(@Body() config: any) {
        return this.schedulerService.updateNovedadesSyncConfig(config);
    }

    @Post('sync-manual')
    @Auth(ValidRoles.admin)
    async triggerManualSync() {
        return this.jobQueueService.triggerJobByType(JobType.NOVEDADES_EMAIL_SYNC);
    }
}
