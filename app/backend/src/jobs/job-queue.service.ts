import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';
import { JobStatus, JobType } from './job-types';

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
    async addJob(type: JobType, payload: any, priority = 0) {
        return this.prisma.jobQueue.create({
            data: {
                type,
                payload,
                priority,
                status: JobStatus.PENDING,
                nextRunAt: new Date(),
            },
        });
    }
}
