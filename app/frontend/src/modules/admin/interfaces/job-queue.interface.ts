export interface JobQueue {
    id: string;
    type: string;
    payload: any;
    status: 'PENDING' | 'PROCESSING' | 'COMPLETED' | 'FAILED' | 'CANCELLED';
    attempts: number;
    maxAttempts: number;
    nextRunAt: string | null;
    lastRunAt: string | null;
    priority: number;
    result: any;
    duration: number | null;
    stackTrace: string | null;
    errorMessage: string | null;
    workerId: string | null;
    createdAt: string;
    updatedAt: string;
}

export interface JobQueueStats {
    total: number;
    pending: number;
    processing: number;
    completed: number;
    failed: number;
    cancelled: number;
    successRate: number;
    avgDuration: number;
}

export interface JobPerformanceStats {
    type: string;
    count: number;
    avgDuration: number;
    minDuration: number;
    maxDuration: number;
}

export interface JobTimeseriesData {
    timestamp: string;
    completed: number;
    failed: number;
}
