import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';
import { JobStatus, JobType } from './job-types';
import { VesselSyncProcessor } from './processors/vessel-sync.processor';
import { PnaApiSyncProcessor } from './processors/pna-api-sync.processor';
import { PnaTrackingSyncProcessor } from './processors/pna-tracking-sync.processor';
import { BackupAutoProcessor } from './processors/backup-auto.processor';
import { BackupService } from '../admin/backup/backup.service';
import { PnaTrackingService } from '../pna-api/pna-tracking.service';
import { PnaApiService } from '../pna-api/pna-api.service';
import { DateTime } from 'luxon';
import * as os from 'os';

@Injectable()
export class SchedulerService {
    private readonly logger = new Logger(SchedulerService.name);
    private isProcessing = false;
    private readonly workerId: string;

    constructor(
        private readonly prisma: PrismaService,
        private readonly vesselSyncProcessor: VesselSyncProcessor,
        private readonly pnaApiSyncProcessor: PnaApiSyncProcessor,
        private readonly pnaTrackingSyncProcessor: PnaTrackingSyncProcessor,
        private readonly backupAutoProcessor: BackupAutoProcessor,
        private readonly backupService: BackupService,
        private readonly pnaTrackingService: PnaTrackingService,
        private readonly pnaApiService: PnaApiService,
    ) {
        this.workerId = `${os.hostname()}-${process.pid}`;
    }

    @Cron(process.env.JOB_SCHEDULER_INTERVAL_CRON || CronExpression.EVERY_MINUTE)
    async handleCron() {
        if (this.isProcessing) {
            return;
        }

        const lockKey = 'JOB_SCHEDULER_LOCK';

        try {
            const now = new Date();
            const lockThreshold = new Date(now.getTime() - 5 * 60 * 1000);

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

    /**
     * Metrónomo de un minuto que verifica y dispara tareas programadas dinámicamente.
     */
    @Cron(CronExpression.EVERY_MINUTE)
    async handleAutoSchedule() {
        const config = await this.getAutoSyncConfig();
        const now = DateTime.now();

        // 1. Sincronización de PNA API (Eventos/Alertas)
        if (config.pnaApi.enabled) {
            const lastRunKey = 'LAST_PNA_API_SYNC_RUN';
            const lastRunStatus = await this.prisma.systemStatus.findUnique({ where: { key: lastRunKey } });
            const lastRun = lastRunStatus ? DateTime.fromISO(lastRunStatus.value) : DateTime.fromMillis(0);

            if (now.diff(lastRun, 'minutes').minutes >= config.pnaApi.intervalMinutes) {
                this.logger.log(`Disparando Sincronización PNA API automática (Intervalo: ${config.pnaApi.intervalMinutes} min)`);
                await this.ensurePnaSyncJob();
                await this.updateStatusDate(lastRunKey, now);
            }
        }

        // 2. Sincronización de Tracking PNA
        if (config.pnaTracking.enabled) {
            const lastRunKey = 'LAST_PNA_TRACKING_SYNC_RUN';
            const lastRunStatus = await this.prisma.systemStatus.findUnique({ where: { key: lastRunKey } });
            const lastRun = lastRunStatus ? DateTime.fromISO(lastRunStatus.value) : DateTime.fromMillis(0);

            if (now.diff(lastRun, 'minutes').minutes >= config.pnaTracking.intervalMinutes) {
                this.logger.log(`Disparando Sincronización Tracking PNA automática (Intervalo: ${config.pnaTracking.intervalMinutes} min)`);
                await this.pnaTrackingService.scheduleSynchronization();
                await this.updateStatusDate(lastRunKey, now);
            }
        }

        // 3. Backup automático diario
        await this.handleDailyBackupSchedule(now);
    }

    /**
     * Verifica si corresponde ejecutar el backup diario automático.
     *
     * Lógica robusta: encola el backup si la hora configurada ya pasó hoy
     * y no existe ni un backup del día en el filesystem ni un job pendiente en la cola.
     * De esta forma, no importa si el cron se ejecutó exactamente en el minuto exacto —
     * mientras llegue después de la hora configurada y no exista ya un backup, lo encolará.
     */
    private async handleDailyBackupSchedule(nowUtc: DateTime): Promise<void> {
        const config = await this.backupService.getAutoBackupConfig();
        if (!config.enabled) return;

        // Trabajar siempre en hora local de Argentina para la programación
        const nowLocal = nowUtc.setZone('America/Argentina/Buenos_Aires');
        const [configHour, configMinute] = config.hour.split(':').map(Number);
        const scheduledTime = nowLocal.set({ hour: configHour, minute: configMinute, second: 0, millisecond: 0 });

        // Aún no llegó la hora configurada hoy
        if (nowLocal < scheduledTime) return;

        // 1. Verificar si ya hay un job de backup diario PENDIENTE o EN PROCESO
        const pendingOrProcessingJob = await this.prisma.jobQueue.findFirst({
            where: {
                type: JobType.DAILY_BACKUP,
                status: { in: [JobStatus.PENDING, JobStatus.PROCESSING] },
            },
        });
        if (pendingOrProcessingJob) return;

        // 2. Verificar si ya se COMPLETÓ un job de backup hoy (evita re-encolar si se borró el archivo)
        const startOfDay = nowLocal.startOf('day').toJSDate();
        const completedToday = await this.prisma.jobQueue.findFirst({
            where: {
                type: JobType.DAILY_BACKUP,
                status: JobStatus.COMPLETED,
                lastRunAt: { gte: startOfDay },
            },
        });
        if (completedToday) return;

        // 3. Verificar físicamente el filesystem (por si se reinició el server o falló la DB)
        const todayBackupExists = await this.backupService.hasBackupForToday();
        if (todayBackupExists) return;

        this.logger.log(`Encolando backup automático diario (hora local: ${nowLocal.toFormat('HH:mm')}, configurado: ${config.hour}).`);
        await this.prisma.jobQueue.create({
            data: {
                type: JobType.DAILY_BACKUP,
                payload: {},
                status: JobStatus.PENDING,
                nextRunAt: new Date(),
                priority: 5,
            },
        });
    }

    private async updateStatusDate(key: string, date: DateTime) {
        await this.prisma.systemStatus.upsert({
            where: { key: key },
            update: { value: date.toISO() || '', lastUpdate: new Date() },
            create: { key: key, value: date.toISO() || '', lastUpdate: new Date() }
        });
    }

    async getAutoSyncConfig() {
        const key = 'PNA_SYNC_CONFIG';
        const status = await this.prisma.systemStatus.findUnique({ where: { key } });

        const defaultConfig = {
            pnaApi: { enabled: true, intervalMinutes: 60 },
            pnaTracking: { enabled: true, intervalMinutes: 120 }
        };

        if (!status?.value) return defaultConfig;

        try {
            return JSON.parse(status.value);
        } catch (e) {
            return defaultConfig;
        }
    }

    async updateAutoSyncConfig(config: any) {
        const key = 'PNA_SYNC_CONFIG';
        await this.prisma.systemStatus.upsert({
            where: { key },
            update: { value: JSON.stringify(config), lastUpdate: new Date() },
            create: { key, value: JSON.stringify(config), lastUpdate: new Date() }
        });
        this.logger.log('Configuración de sincronización PNA actualizada.');
    }

    /**
     * Asegura que siempre haya una tarea de sincronización de PNA programada (Llamado interno)
     */
    async ensurePnaSyncJob() {
        const existingJob = await this.prisma.jobQueue.findFirst({
            where: {
                type: JobType.PNA_API_SYNC,
                status: { in: [JobStatus.PENDING, JobStatus.PROCESSING] },
            },
        });

        if (!existingJob) {
            const lastSync = await this.pnaApiService.getLastSuccessfulSyncDate();
            const fromDate = lastSync ? lastSync : DateTime.now().minus({ days: 2 }).toJSDate();
            const toDate = new Date();

            this.logger.log(`Programando nueva tarea de sincronización de PNA API (${fromDate.toISOString()} -> ${toDate.toISOString()})...`);
            await this.prisma.jobQueue.create({
                data: {
                    type: JobType.PNA_API_SYNC,
                    payload: {
                        fromDate: fromDate.toISOString(),
                        toDate: toDate.toISOString(),
                    },
                    status: JobStatus.PENDING,
                    nextRunAt: new Date(),
                    priority: 20,
                },
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
            const startTime = Date.now();
            let result: any = null;
            let errorMessage: string | null = null;
            let stackTrace: string | null = null;

            try {
                await this.prisma.jobQueue.update({
                    where: { id: job.id },
                    data: {
                        status: JobStatus.PROCESSING,
                        lastRunAt: new Date(),
                        workerId: this.workerId,
                    },
                });

                result = await this.dispatchJob(job);
                const duration = Date.now() - startTime;

                await this.prisma.jobQueue.update({
                    where: { id: job.id },
                    data: {
                        status: JobStatus.COMPLETED,
                        result: result || null,
                        duration,
                    },
                });
            } catch (error) {
                this.logger.error(`Error processing job ${job.id}:`, error);

                const duration = Date.now() - startTime;
                const nextAttempts = job.attempts + 1;
                const isFinalFailure = nextAttempts >= job.maxAttempts;

                errorMessage = error.message || 'Unknown error';
                stackTrace = error.stack || null;

                await this.prisma.jobQueue.update({
                    where: { id: job.id },
                    data: {
                        status: isFinalFailure ? JobStatus.FAILED : JobStatus.PENDING,
                        attempts: nextAttempts,
                        errorMessage,
                        stackTrace,
                        duration,
                        nextRunAt: this.calculateNextRun(nextAttempts),
                    },
                });
            }
        }
    }

    private async dispatchJob(job: any): Promise<any> {
        switch (job.type) {
            case JobType.VESSEL_SYNC:
                return await this.vesselSyncProcessor.process(job.payload);
            case JobType.PNA_API_SYNC:
                return await this.pnaApiSyncProcessor.process(job.payload);
            case JobType.PNA_TRACKING_SYNC:
                return await this.pnaTrackingSyncProcessor.process(job.payload);
            case JobType.DAILY_BACKUP:
                return await this.backupAutoProcessor.process(job.payload);
            default:
                throw new Error(`Unknown job type: ${job.type}`);
        }
    }

    private calculateNextRun(attempts: number): Date {
        const delayMinutes = Math.pow(2, attempts); // Backoff exponencial simple
        return new Date(Date.now() + delayMinutes * 60 * 1000);
    }
}
