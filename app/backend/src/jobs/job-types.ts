export enum JobType {
    VESSEL_SYNC = 'VESSEL_SYNC',
    TRAJECTORY_SYNC = 'TRAJECTORY_SYNC',
}

export enum JobStatus {
    PENDING = 'PENDING',
    PROCESSING = 'PROCESSING',
    COMPLETED = 'COMPLETED',
    FAILED = 'FAILED',
}

export interface JobProcessor {
    process(payload: any): Promise<void>;
}
