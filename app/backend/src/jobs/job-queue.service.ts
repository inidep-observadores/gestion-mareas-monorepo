import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';
import { JobStatus, JobType } from './job-types';
import { DateTime } from 'luxon';

export interface JobFilterParams {
    page: number;
    limit: number;
    status?: JobStatus;
    type?: JobType;
    search?: string;
}

@Injectable()
export class JobQueueService {
    private readonly logger = new Logger(JobQueueService.name);

    constructor(private readonly prisma: PrismaService) { }

    async findAll(params: JobFilterParams) {
        const { page, limit, status, type, search } = params;
        const skip = (page - 1) * limit;

        const where: Prisma.JobQueueWhereInput = {
            ...(status && { status }),
            ...(type && { type }),
            ...(search && {
                OR: [
                    { id: { contains: search, mode: 'insensitive' } },
                    // Si payload fuera texto, podríamos buscar ahí, pero es JSONB
                ],
            }),
        };

        const [data, total] = await Promise.all([
            this.prisma.jobQueue.findMany({
                where,
                skip,
                take: limit,
                orderBy: { createdAt: 'desc' },
            }),
            this.prisma.jobQueue.count({ where }),
        ]);

        return {
            data,
            meta: {
                total,
                page,
                limit,
                totalPages: Math.ceil(total / limit),
            },
        };
    }

    async findOne(id: string) {
        return this.prisma.jobQueue.findUnique({
            where: { id },
        });
    }

    async retryJob(id: string) {
        this.logger.log(`Reintentando tarea manual: ${id}`);
        return this.prisma.jobQueue.update({
            where: { id },
            data: {
                status: JobStatus.PENDING,
                attempts: 0,
                nextRunAt: new Date(),
                result: Prisma.DbNull,
                stackTrace: null,
                errorMessage: null,
            },
        });
    }

    async cancelJob(id: string) {
        this.logger.log(`Cancelando tarea: ${id}`);
        // Opción 1: Soft delete (Status CANCELLED)
        return this.prisma.jobQueue.update({
            where: { id },
            data: {
                status: JobStatus.CANCELLED,
            },
        });
        // Opción 2: Hard delete
        // return this.prisma.jobQueue.delete({ where: { id } });
    }

    /**
     * Crea una nueva tarea en la cola
     */
    async addJob(type: JobType, payload: any, priority = 10, nextRunAt?: Date) {
        return this.prisma.jobQueue.create({
            data: {
                type,
                payload,
                priority,
                status: JobStatus.PENDING,
                nextRunAt: nextRunAt || new Date(),
            },
        });
    }

    /**
     * Dispara una tarea por tipo si no hay una ya activa
     */
    async triggerJobByType(type: JobType, priority = 50) {
        const staleThresholdHours = parseInt(process.env.JOB_STALE_THRESHOLD_HOURS || '4', 10);
        const staleTime = new Date(Date.now() - staleThresholdHours * 60 * 60 * 1000);

        const activeJob = await this.prisma.jobQueue.findFirst({
            where: {
                type,
                OR: [
                    { status: JobStatus.PENDING },
                    {
                        status: JobStatus.PROCESSING,
                        lastRunAt: { gte: staleTime }
                    }
                ]
            }
        });

        if (activeJob) {

            return activeJob;
        }

        let payload = {};
        if (type === JobType.PNA_API_SYNC) {
            const lastSync = await this.prisma.systemStatus.findUnique({ where: { key: 'LAST_PNA_SYNC' } });
            const fromDate = lastSync?.value ? new Date(lastSync.value) : DateTime.now().minus({ days: 2 }).toJSDate();
            payload = {
                fromDate: fromDate.toISOString(),
                toDate: new Date().toISOString(),
            };
        }

        return this.addJob(type, payload, priority);
    }
}
