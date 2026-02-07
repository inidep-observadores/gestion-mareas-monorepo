import httpClient from '@/config/http/http.client';
import type { JobQueue, JobQueueStats, JobPerformanceStats, JobTimeseriesData } from '../interfaces/job-queue.interface';

export class JobQueueService {
    private static instance: JobQueueService;

    private constructor() { }

    public static getInstance(): JobQueueService {
        if (!JobQueueService.instance) {
            JobQueueService.instance = new JobQueueService();
        }
        return JobQueueService.instance;
    }

    async getJobs(params: { page?: number; limit?: number; status?: string; type?: string; search?: string }) {
        const { data } = await httpClient.get('/jobs', { params });
        return data;
    }

    async getJobDetail(id: string): Promise<JobQueue> {
        const { data } = await httpClient.get(`/jobs/${id}`);
        return data;
    }

    async getSummaryStats(): Promise<JobQueueStats> {
        const { data } = await httpClient.get('/jobs/stats/summary');
        return data;
    }

    async getPerformanceStats(): Promise<JobPerformanceStats[]> {
        const { data } = await httpClient.get('/jobs/stats/performance');
        return data;
    }

    async getErrorStats() {
        const { data } = await httpClient.get('/jobs/stats/errors');
        return data;
    }

    async getTimeseriesStats(days = 7): Promise<JobTimeseriesData[]> {
        const { data } = await httpClient.get('/jobs/stats/timeseries', { params: { days } });
        return data;
    }

    async retryJob(id: string) {
        const { data } = await httpClient.post(`/jobs/${id}/retry`);
        return data;
    }

    async cancelJob(id: string) {
        const { data } = await httpClient.delete(`/jobs/${id}`);
        return data;
    }

    async triggerJob(type: string) {
        const { data } = await httpClient.post(`/jobs/trigger/${type}`);
        return data;
    }
}

export const jobQueueService = JobQueueService.getInstance();
