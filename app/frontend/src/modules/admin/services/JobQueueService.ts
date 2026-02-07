import axios from 'axios';
import type { JobQueue, JobQueueStats, JobPerformanceStats, JobTimeseriesData } from '../interfaces/job-queue.interface';

const API_URL = import.meta.env.VITE_API_URL || '/api';

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
        const { data } = await axios.get(`${API_URL}/jobs`, { params });
        return data;
    }

    async getJobDetail(id: string): Promise<JobQueue> {
        const { data } = await axios.get(`${API_URL}/jobs/${id}`);
        return data;
    }

    async getSummaryStats(): Promise<JobQueueStats> {
        const { data } = await axios.get(`${API_URL}/jobs/stats/summary`);
        return data;
    }

    async getPerformanceStats(): Promise<JobPerformanceStats[]> {
        const { data } = await axios.get(`${API_URL}/jobs/stats/performance`);
        return data;
    }

    async getErrorStats() {
        const { data } = await axios.get(`${API_URL}/jobs/stats/errors`);
        return data;
    }

    async getTimeseriesStats(days = 7): Promise<JobTimeseriesData[]> {
        const { data } = await axios.get(`${API_URL}/jobs/stats/timeseries`, { params: { days } });
        return data;
    }

    async retryJob(id: string) {
        const { data } = await axios.post(`${API_URL}/jobs/${id}/retry`);
        return data;
    }

    async cancelJob(id: string) {
        const { data } = await axios.delete(`${API_URL}/jobs/${id}`);
        return data;
    }
}

export const jobQueueService = JobQueueService.getInstance();
