import { Controller, Post, Get, Body, Query } from '@nestjs/common';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { SchedulerService } from '../jobs/scheduler.service';
import { JobQueueService } from '../jobs/job-queue.service';
import { PrismaService } from '../prisma/prisma.service';
import { JobType } from '@prisma/client';

@Controller('mail-admin')
export class MailController {
    constructor(
        private readonly schedulerService: SchedulerService,
        private readonly jobQueueService: JobQueueService,
        private readonly prisma: PrismaService,
    ) { }

    @Get('logs')
    @Auth(ValidRoles.admin)
    async getLogs(@Query('page') page: string = '1', @Query('limit') limit: string = '50') {
        const pageNum = parseInt(page, 10) || 1;
        const limitNum = parseInt(limit, 10) || 50;
        const skip = (pageNum - 1) * limitNum;

        const [items, total] = await Promise.all([
            this.prisma.novedadesEmailLog.findMany({
                skip,
                take: limitNum,
                orderBy: { fechaProcesamiento: 'desc' },
                include: {
                    detalles: {
                        include: {
                            novedad: {
                                include: {
                                    observador: true,
                                    tipoNovedad: true,
                                }
                            }
                        }
                    }
                }
            }),
            this.prisma.novedadesEmailLog.count(),
        ]);

        return { items, total, page: pageNum, limit: limitNum };
    }


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
