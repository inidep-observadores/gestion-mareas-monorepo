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
import { NovedadesEmailProcessor } from './processors/novedades-email.processor';
import { DateTime } from 'luxon';
import * as os from 'os';
import { NovedadesAiProcessor } from './processors/novedades-ai.processor';

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
        private readonly novedadesEmailProcessor: NovedadesEmailProcessor,
        private readonly novedadesAiProcessor: NovedadesAiProcessor,
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

            // Antes de procesar, limpiamos tareas que quedaron "colgadas" (ej. reinicio de servidor)
            await this.cleanupStaleJobs();

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
     * Busca tareas que quedaron en estado PROCESSING por más de un tiempo razonable
     * y las marca como fallidas para que el sistema pueda continuar.
     */
    private async cleanupStaleJobs() {
        const staleThresholdHours = parseInt(process.env.JOB_STALE_THRESHOLD_HOURS || '4', 10);
        const staleTime = new Date(Date.now() - staleThresholdHours * 60 * 60 * 1000);

        const staleJobs = await this.prisma.jobQueue.findMany({
            where: {
                status: JobStatus.PROCESSING,
                lastRunAt: { lte: staleTime },
            },
        });

        for (const job of staleJobs) {
            this.logger.warn(`Detectada tarea atascada (ID: ${job.id}, Tipo: ${job.type}). Marcando como FAILED por inactividad.`);
            await this.prisma.jobQueue.update({
                where: { id: job.id },
                data: {
                    status: JobStatus.FAILED,
                    errorMessage: `Tarea marcada como fallida automáticamente tras ${staleThresholdHours} horas en estado PROCESSING (posible hang o reinicio del servidor).`,
                },
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
                this.logger.log(`Disparando Sincronización PNA API automática (Intervalo rápido: ${config.pnaApi.intervalMinutes} min)`);
                const scheduled = await this.ensurePnaSyncJob(false);
                if (scheduled) await this.updateStatusDate(lastRunKey, now);
            }

            if (config.pnaApi.longIntervalMinutes) {
                const lastRunLongKey = 'LAST_PNA_API_SYNC_LONG_RUN';
                const lastRunLongStatus = await this.prisma.systemStatus.findUnique({ where: { key: lastRunLongKey } });
                const lastRunLong = lastRunLongStatus ? DateTime.fromISO(lastRunLongStatus.value) : DateTime.fromMillis(0);

                if (now.diff(lastRunLong, 'minutes').minutes >= config.pnaApi.longIntervalMinutes) {
                    this.logger.log(`Disparando Sincronización PNA API automática (Intervalo respaldo: ${config.pnaApi.longIntervalMinutes} min)`);
                    const scheduled = await this.ensurePnaSyncJob(true);
                    if (scheduled) await this.updateStatusDate(lastRunLongKey, now);
                }
            }
        }

        // 2. Sincronización de Tracking PNA
        if (config.pnaTracking.enabled) {
            const lastRunKey = 'LAST_PNA_TRACKING_SYNC_RUN';
            const lastRunStatus = await this.prisma.systemStatus.findUnique({ where: { key: lastRunKey } });
            const lastRun = lastRunStatus ? DateTime.fromISO(lastRunStatus.value) : DateTime.fromMillis(0);

            if (now.diff(lastRun, 'minutes').minutes >= config.pnaTracking.intervalMinutes) {
                this.logger.log(`Disparando Sincronización Tracking PNA automática (Intervalo rápido: ${config.pnaTracking.intervalMinutes} min)`);
                const res = await this.pnaTrackingService.scheduleSynchronization(undefined, undefined, false, false);
                if (res.success) await this.updateStatusDate(lastRunKey, now);
            }

            if (config.pnaTracking.longIntervalMinutes) {
                const lastRunLongKey = 'LAST_PNA_TRACKING_SYNC_LONG_RUN';
                const lastRunLongStatus = await this.prisma.systemStatus.findUnique({ where: { key: lastRunLongKey } });
                const lastRunLong = lastRunLongStatus ? DateTime.fromISO(lastRunLongStatus.value) : DateTime.fromMillis(0);

                if (now.diff(lastRunLong, 'minutes').minutes >= config.pnaTracking.longIntervalMinutes) {
                    this.logger.log(`Disparando Sincronización Tracking PNA automática (Intervalo respaldo: ${config.pnaTracking.longIntervalMinutes} min)`);
                    const res = await this.pnaTrackingService.scheduleSynchronization(undefined, undefined, false, true);
                    if (res.success) await this.updateStatusDate(lastRunLongKey, now);
                }
            }
        }

        // 3. Backup automático diario
        await this.handleDailyBackupSchedule(now);

        // 4. Novedades Email
        const novedadesConfig = await this.getNovedadesSyncConfig();
        if (novedadesConfig.enabled) {
            const lastRunKey = 'LAST_NOVEDADES_SYNC_RUN';
            const lastRunStatus = await this.prisma.systemStatus.findUnique({ where: { key: lastRunKey } });
            const lastRun = lastRunStatus ? DateTime.fromISO(lastRunStatus.value) : DateTime.fromMillis(0);

            if (novedadesConfig.mode === 'daily') {
                // Modo diario (hora local de Argentina)
                const nowLocal = now.setZone('America/Argentina/Buenos_Aires');
                const [configHour, configMinute] = (novedadesConfig.hour || '14:00').split(':').map(Number);
                const scheduledTime = nowLocal.set({ hour: configHour, minute: configMinute, second: 0, millisecond: 0 });

                // Si ya pasó la hora configurada hoy
                if (nowLocal >= scheduledTime) {
                    const startOfDay = nowLocal.startOf('day');
                    // Y no se ha ejecutado hoy
                    if (lastRun < startOfDay) {
                        this.logger.log(`Disparando Sincronización Novedades Email diaria automática (Hora local programada: ${novedadesConfig.hour || '14:00'})`);
                        const scheduled = await this.ensureNovedadesSyncJob();
                        if (scheduled) {
                            await this.updateStatusDate(lastRunKey, now);
                        }
                    }
                }
            } else {
                // Modo periódico (intervalo por minutos) - default
                const interval = novedadesConfig.intervalMinutes || 60;
                if (now.diff(lastRun, 'minutes').minutes >= interval) {
                    this.logger.log(`Disparando Sincronización Novedades Email automática (Intervalo: ${interval} min)`);
                    const scheduled = await this.ensureNovedadesSyncJob();
                    if (scheduled) {
                        await this.updateStatusDate(lastRunKey, now);
                    }
                }
            }
        }
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
            pnaApi: { enabled: true, intervalMinutes: 20, longIntervalMinutes: 240 },
            pnaTracking: { enabled: true, intervalMinutes: 20, longIntervalMinutes: 240 }
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

    async getNovedadesSyncConfig() {
        const key = 'NOVEDADES_SYNC_CONFIG';
        const status = await this.prisma.systemStatus.findUnique({ where: { key } });
        const defaultConfig = { 
            enabled: true, 
            mode: 'periodic', 
            intervalMinutes: 60,
            hour: '14:00'
        };
        if (!status?.value) return defaultConfig;
        try {
            const parsed = JSON.parse(status.value);
            // Asegurar retrocompatibilidad con campos faltantes
            return {
                enabled: parsed.enabled ?? defaultConfig.enabled,
                mode: parsed.mode ?? defaultConfig.mode,
                intervalMinutes: parsed.intervalMinutes ?? defaultConfig.intervalMinutes,
                hour: parsed.hour ?? defaultConfig.hour,
            };
        } catch (e) {
            return defaultConfig;
        }
    }

    async updateNovedadesSyncConfig(config: any) {
        const key = 'NOVEDADES_SYNC_CONFIG';
        await this.prisma.systemStatus.upsert({
            where: { key },
            update: { value: JSON.stringify(config), lastUpdate: new Date() },
            create: { key, value: JSON.stringify(config), lastUpdate: new Date() }
        });
        this.logger.log('Configuración de sincronización Novedades actualizada.');
    }

    /**
     * Asegura que siempre haya una tarea de sincronización de PNA programada (Llamado interno)
     */
    async ensurePnaSyncJob(isLongSync: boolean = false): Promise<boolean> {
        const staleThresholdHours = parseInt(process.env.JOB_STALE_THRESHOLD_HOURS || '4', 10);
        const staleTime = new Date(Date.now() - staleThresholdHours * 60 * 60 * 1000);

        const activeJob = await this.prisma.jobQueue.findFirst({
            where: {
                type: JobType.PNA_API_SYNC,
                OR: [
                    { status: JobStatus.PENDING },
                    {
                        status: JobStatus.PROCESSING,
                        lastRunAt: { gte: staleTime } // Solo consideramos bloqueante si NO es vieja
                    }
                ]
            },
        });

        if (!activeJob) {
            const lastSync = await this.pnaApiService.getLastSuccessfulSyncDate(isLongSync);
            // REGLA: Para automático usamos sincronización incremental
            const fromDate = lastSync ? lastSync : DateTime.now().minus({ days: 2 }).toJSDate();
            const toDate = new Date();

            this.logger.log(`Programando nueva tarea de sincronización de PNA API (${fromDate.toISOString()} -> ${toDate.toISOString()}) [Respaldo: ${isLongSync}]...`);
            await this.prisma.jobQueue.create({
                data: {
                    type: JobType.PNA_API_SYNC,
                    payload: {
                        fromDate: fromDate.toISOString(),
                        toDate: toDate.toISOString(),
                        isLongSync,
                    },
                    status: JobStatus.PENDING,
                    nextRunAt: new Date(),
                    priority: isLongSync ? 10 : 20,
                },
            });
            return true;
        }
        return false;
    }

    async ensureNovedadesSyncJob(): Promise<boolean> {
        const activeJob = await this.prisma.jobQueue.findFirst({
            where: {
                type: JobType.NOVEDADES_EMAIL_SYNC,
                status: { in: [JobStatus.PENDING, JobStatus.PROCESSING] }
            },
        });

        if (!activeJob) {
            this.logger.log(`Programando nueva tarea de Novedades Email...`);
            await this.prisma.jobQueue.create({
                data: {
                    type: JobType.NOVEDADES_EMAIL_SYNC,
                    payload: {},
                    status: JobStatus.PENDING,
                    nextRunAt: new Date(),
                    priority: 10,
                },
            });
            return true;
        }
        return false;
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

                if (isFinalFailure) {
                    // Definimos una interfaz para asegurar el tipo del payload esperado
                    interface PnaSyncPayload {
                        fromDate?: string;
                        toDate?: string;
                        isLongSync?: boolean;
                    }

                    const isPnaSyncPayload = (p: any): p is PnaSyncPayload => {
                        return p !== null && typeof p === 'object' && !Array.isArray(p);
                    };

                    if (job.type === JobType.PNA_API_SYNC || job.type === JobType.PNA_TRACKING_SYNC) {
                        if (isPnaSyncPayload(job.payload)) {
                            const toDateStr = job.payload.toDate;
                            const isLongSync = job.payload.isLongSync === true;
                            if (toDateStr) {
                                const toDate = DateTime.fromISO(toDateStr);
                                if (toDate.isValid) {
                                    let statusKey = '';
                                    if (job.type === JobType.PNA_API_SYNC) {
                                        statusKey = isLongSync ? 'LAST_PNA_SYNC_LONG' : 'LAST_PNA_SYNC';
                                    } else {
                                        statusKey = isLongSync ? 'LAST_PNA_TRACKING_SYNC_LONG' : 'LAST_PNA_TRACKING_SYNC';
                                    }
                                    const syncName = job.type === JobType.PNA_API_SYNC ? 'API PNA' : 'Tracking PNA';
                                    
                                    await this.updateStatusDate(statusKey, toDate);
                                    this.logger.warn(`[Hakuna Matata] Job ${job.id} de ${syncName} falló definitivamente. Avanzando ${statusKey} a ${toDateStr} para evitar bucle infinito en rango erróneo.`);
                                }
                            }
                        }
                    }
                }

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
            case JobType.NOVEDADES_EMAIL_SYNC:
                return await this.novedadesEmailProcessor.process(job.payload);
            case JobType.NOVEDADES_AI_PROCESS:
                return await this.novedadesAiProcessor.process(job.payload);
            default:
                throw new Error(`Unknown job type: ${job.type}`);
        }
    }


    private calculateNextRun(attempts: number): Date {
        const delayMinutes = Math.pow(2, attempts); // Backoff exponencial simple
        return new Date(Date.now() + delayMinutes * 60 * 1000);
    }
}
