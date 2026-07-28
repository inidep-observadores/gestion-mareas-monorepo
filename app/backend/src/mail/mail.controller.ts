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
    async getLogs(
        @Query('page') page: string = '1', 
        @Query('limit') limit: string = '50',
        @Query('search') search?: string,
        @Query('startDate') startDate?: string,
        @Query('endDate') endDate?: string,
        @Query('sortBy') sortBy: string = 'fechaRecepcion',
        @Query('sortOrder') sortOrder: 'asc' | 'desc' = 'desc'
    ) {
        const pageNum = parseInt(page, 10) || 1;
        const limitNum = parseInt(limit, 10) || 50;
        const skip = (pageNum - 1) * limitNum;

        const where: any = {};

        if (search) {
            where.OR = [
                { asunto: { contains: search, mode: 'insensitive' } },
                { remitente: { contains: search, mode: 'insensitive' } },
                { estado: { contains: search, mode: 'insensitive' } },
                { 
                    detalles: {
                        some: {
                            OR: [
                                { estado: { contains: search, mode: 'insensitive' } },
                                { errorDetalle: { contains: search, mode: 'insensitive' } },
                                { fuente: { contains: search, mode: 'insensitive' } }
                            ]
                        }
                    }
                }
            ];
        }

        if (startDate || endDate) {
            where.fechaRecepcion = {};
            if (startDate) {
                // Asegurar que comience a las 00:00:00
                const start = new Date(startDate);
                start.setHours(0, 0, 0, 0);
                where.fechaRecepcion.gte = start;
            }
            if (endDate) {
                // Asegurar que termine a las 23:59:59
                const end = new Date(endDate);
                end.setHours(23, 59, 59, 999);
                where.fechaRecepcion.lte = end;
            }
        }

        const orderBy: any = {};
        // Sanitizar el campo de ordenamiento para evitar inyecciones
        const validSortFields = ['fechaRecepcion', 'remitente', 'asunto', 'estado'];
        const finalSortBy = validSortFields.includes(sortBy) ? sortBy : 'fechaRecepcion';
        const finalSortOrder = sortOrder === 'asc' ? 'asc' : 'desc';
        orderBy[finalSortBy] = finalSortOrder;

        const [items, total] = await Promise.all([
            this.prisma.novedadesEmailLog.findMany({
                where,
                skip,
                take: limitNum,
                orderBy,
                include: {
                    detalles: {
                        include: {
                            novedad: {
                                include: {
                                    observador: true,
                                    tipoNovedad: true,
                                    archivos: true // Incluir archivos para visualizarlos
                                }
                            }
                        }
                    }
                }
            }),
            this.prisma.novedadesEmailLog.count({ where }),
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
