import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';
import { JobStatus, JobType } from './job-types';
import { VesselSyncProcessor } from './processors/vessel-sync.processor';

@Injectable()
export class SchedulerService {
    private readonly logger = new Logger(SchedulerService.name);
    private isProcessing = false;

    constructor(
        private readonly prisma: PrismaService,
        private readonly vesselSyncProcessor: VesselSyncProcessor,
    ) { }

    @Cron(process.env.JOB_SCHEDULER_INTERVAL_CRON || CronExpression.EVERY_MINUTE)
    async handleCron() {
        if (this.isProcessing) {
            return;
        }

        const lockKey = 'job_scheduler_lock';

        try {
            // Intento de bloqueo distribuido simple usando system_status
            const now = new Date();
            const lockThreshold = new Date(now.getTime() - 5 * 60 * 1000); // 5 minutos timeout

            const lock = await this.prisma.systemStatus.findUnique({ where: { key: lockKey } });

            if (lock && lock.value === 'LOCKED' && lock.lastUpdate > lockThreshold) {
                return;
            }

            await this.prisma.systemStatus.upsert({
                where: { key: lockKey },
                update: { value: 'LOCKED', lastUpdate: now },
                create: { key: lockKey, value: 'LOCKED', lastUpdate: now },
            });

            this.isProcessing = true;
            await this.processQueue();
        } catch (error) {
            this.logger.error('Error in scheduler cron:', error);
        } finally {
            this.isProcessing = false;
            await this.prisma.systemStatus.update({
                where: { key: lockKey },
                data: { value: 'UNLOCKED' },
            });
        }
    }

    private async processQueue() {
        const jobs = await this.prisma.jobQueue.findMany({
            where: {
                status: JobStatus.PENDING,
                nextRunAt: { lte: new Date() },
            },
            orderBy: { priority: 'desc' },
            take: 10,
        });

        for (const job of jobs) {
            try {
                await this.prisma.jobQueue.update({
                    where: { id: job.id },
                    data: { status: JobStatus.PROCESSING, lastRunAt: new Date() },
                });

                await this.dispatchJob(job);

                await this.prisma.jobQueue.update({
                    where: { id: job.id },
                    data: { status: JobStatus.COMPLETED },
                });
            } catch (error) {
                this.logger.error(`Error processing job ${job.id}:`, error);

                const nextAttempts = job.attempts + 1;
                const isFinalFailure = nextAttempts >= job.maxAttempts;

                await this.prisma.jobQueue.update({
                    where: { id: job.id },
                    data: {
                        status: isFinalFailure ? JobStatus.FAILED : JobStatus.PENDING,
                        attempts: nextAttempts,
                        lastError: error.message,
                        nextRunAt: this.calculateNextRun(nextAttempts),
                    },
                });
            }
        }
    }

    private async dispatchJob(job: any) {
        switch (job.type) {
            case JobType.VESSEL_SYNC:
                await this.vesselSyncProcessor.process(job.payload);
                break;
            default:
                throw new Error(`Unknown job type: ${job.type}`);
        }
    }

    private calculateNextRun(attempts: number): Date {
        const delayMinutes = Math.pow(2, attempts); // Backoff exponencial simple
        return new Date(Date.now() + delayMinutes * 60 * 1000);
    }
}
