import {
    Controller,
    Get,
    Post,
    Delete,
    Param,
    Query,
    ParseIntPipe,
    NotFoundException,
    BadRequestException
} from '@nestjs/common';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { JobQueueService } from './job-queue.service';
import { JobQueueStatsService } from './job-queue.stats.service';
import { JobStatus, JobType } from '@prisma/client';

@Controller('jobs')
export class JobQueueController {
    constructor(
        private readonly jobService: JobQueueService,
        private readonly statsService: JobQueueStatsService,
    ) { }

    @Get()
    @Auth(ValidRoles.admin)
    async getJobs(
        @Query('page', new ParseIntPipe({ optional: true })) page = 1,
        @Query('limit', new ParseIntPipe({ optional: true })) limit = 20,
        @Query('status') status?: JobStatus,
        @Query('type') type?: JobType,
        @Query('search') search?: string,
    ) {
        return this.jobService.findAll({
            page,
            limit,
            status,
            type,
            search,
        });
    }

    @Get('stats/summary')
    @Auth(ValidRoles.admin)
    async getSummaryStats() {
        return this.statsService.getSummaryStats();
    }

    @Get('stats/performance')
    @Auth(ValidRoles.admin)
    async getPerformanceStats() {
        return this.statsService.getPerformanceByType();
    }

    @Get('stats/errors')
    @Auth(ValidRoles.admin)
    async getErrorStats() {
        return this.statsService.getErrorStats();
    }

    @Get('stats/timeseries')
    @Auth(ValidRoles.admin)
    async getTimeseriesStats(@Query('days', new ParseIntPipe({ optional: true })) days = 7) {
        return this.statsService.getTimeseriesStats(days);
    }

    @Get(':id')
    @Auth(ValidRoles.admin)
    async getJobDetail(@Param('id') id: string) {
        const job = await this.jobService.findOne(id);
        if (!job) throw new NotFoundException('Job not found');
        return job;
    }

    @Post(':id/retry')
    @Auth(ValidRoles.admin)
    async retryJob(@Param('id') id: string) {
        const job = await this.jobService.findOne(id);
        if (!job) throw new NotFoundException('Job not found');

        if (job.status !== JobStatus.FAILED && job.status !== JobStatus.CANCELLED) {
            throw new BadRequestException('Only failed or cancelled jobs can be retried');
        }

        return this.jobService.retryJob(id);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    async cancelJob(@Param('id') id: string) {
        return this.jobService.cancelJob(id);
    }
}
