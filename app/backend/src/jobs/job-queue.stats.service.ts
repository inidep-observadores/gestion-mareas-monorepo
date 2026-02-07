import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';
import { JobStatus, JobType } from './job-types';

export interface JobStatsSummary {
    total: number;
    pending: number;
    processing: number;
    completed: number;
    failed: number;
    cancelled: number;
    successRate: number;
    avgDuration?: number;
}

export interface JobPerformanceStats {
    type: string;
    count: number;
    avgDuration: number;
    minDuration: number;
    maxDuration: number;
}

export interface JobTimeseriesData {
    timestamp: Date;
    completed: number;
    failed: number;
}

@Injectable()
export class JobQueueStatsService {
    constructor(private readonly prisma: PrismaService) { }

    async getSummaryStats(): Promise<JobStatsSummary> {
        const stats = await this.prisma.jobQueue.groupBy({
            by: ['status'],
            _count: {
                status: true,
            },
        });

        const counts = {
            total: 0,
            pending: 0,
            processing: 0,
            completed: 0,
            failed: 0,
            cancelled: 0,
        };

        stats.forEach((stat) => {
            counts.total += stat._count.status;
            switch (stat.status) {
                case JobStatus.PENDING:
                    counts.pending = stat._count.status;
                    break;
                case JobStatus.PROCESSING:
                    counts.processing = stat._count.status;
                    break;
                case JobStatus.COMPLETED:
                    counts.completed = stat._count.status;
                    break;
                case JobStatus.FAILED:
                    counts.failed = stat._count.status;
                    break;
                case JobStatus.CANCELLED:
                    counts.cancelled = stat._count.status;
                    break;
            }
        });

        // Calcular duración promedio de tareas completadas en las últimas 24h
        const yesterday = new Date();
        yesterday.setDate(yesterday.getDate() - 1);

        const durationAggr = await this.prisma.jobQueue.aggregate({
            _avg: {
                duration: true,
            },
            where: {
                status: JobStatus.COMPLETED,
                updatedAt: {
                    gte: yesterday,
                },
            },
        });

        const successRate = counts.total > 0
            ? ((counts.completed) / counts.total) * 100
            : 0;

        return {
            ...counts,
            successRate: parseFloat(successRate.toFixed(2)),
            avgDuration: (durationAggr._avg as any).duration || 0,
        };
    }

    async getPerformanceByType(): Promise<JobPerformanceStats[]> {
        const stats = await this.prisma.jobQueue.groupBy({
            by: ['type'],
            where: {
                status: JobStatus.COMPLETED,
            },
            _count: {
                type: true,
            },
            _avg: {
                duration: true,
            },
            _min: {
                duration: true,
            },
            _max: {
                duration: true,
            },
        });

        return stats.map(stat => ({
            type: stat.type,
            count: stat._count.type,
            avgDuration: Math.round(stat._avg.duration || 0),
            minDuration: stat._min.duration || 0,
            maxDuration: stat._max.duration || 0,
        })).sort((a, b) => b.avgDuration - a.avgDuration);
    }

    async getErrorStats(limit = 5) {
        // Obtenemos los errores más recientes para análisis manual
        // Nota: Prisma no soporta agrupar por columna JSON/Texto fácilmente sin raw query
        // Para simplificar, obtenemos los últimos fallos y su distribución por tipo

        const failedJobs = await this.prisma.jobQueue.groupBy({
            by: ['type'],
            where: {
                status: JobStatus.FAILED,
            },
            _count: {
                type: true,
            },
        });

        const recentErrors = await this.prisma.jobQueue.findMany({
            where: {
                status: JobStatus.FAILED,
            },
            select: {
                id: true,
                type: true,
                result: true,
                updatedAt: true,
            },
            orderBy: {
                updatedAt: 'desc',
            },
            take: limit,
        });

        return {
            distribution: failedJobs.map(f => ({ type: f.type, count: f._count.type })),
            recent: recentErrors.map((e: any) => ({
                id: e.id,
                type: e.type,
                result: e.result,
                updatedAt: e.updatedAt
            })),
        };
    }

    async getTimeseriesStats(days = 7): Promise<JobTimeseriesData[]> {
        const SinceDate = new Date();
        SinceDate.setDate(SinceDate.getDate() - days);
        SinceDate.setHours(0, 0, 0, 0);

        // Usamos raw query para agrupar por fecha/hora y tipo eficientemente
        // Nota: Ajustar sintaxis según motor DB (PostgreSQL)
        const rawStats = await this.prisma.$queryRaw`
            SELECT 
                DATE_TRUNC('hour', "updated_at") as timestamp,
                "type",
                SUM(CASE WHEN "status" = 'COMPLETED' THEN 1 ELSE 0 END) as completed,
                SUM(CASE WHEN "status" = 'FAILED' THEN 1 ELSE 0 END) as failed
            FROM "job_queue"
            WHERE "updated_at" >= ${SinceDate}
            GROUP BY DATE_TRUNC('hour', "updated_at"), "type"
            ORDER BY timestamp ASC, "type" ASC
        `;

        // Mapear BigInt a number si es necesario
        return (rawStats as any[]).map(row => ({
            timestamp: new Date(row.timestamp),
            type: row.type,
            completed: Number(row.completed),
            failed: Number(row.failed),
        }));
    }
}
