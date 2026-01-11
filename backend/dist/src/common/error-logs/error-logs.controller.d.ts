import { ErrorLogsService } from './error-logs.service';
export declare class ErrorLogsController {
    private readonly errorLogsService;
    constructor(errorLogsService: ErrorLogsService);
    findAll(): Promise<{
        level: string;
        id: string;
        path: string | null;
        timestamp: Date;
        source: string;
        context: string | null;
        userId: string | null;
        userEmail: string | null;
        message: string;
        stack: string | null;
        detail: import("@prisma/client/runtime/client").JsonValue | null;
        method: string | null;
        ip: string | null;
    }[]>;
    findOne(id: string): Promise<{
        level: string;
        id: string;
        path: string | null;
        timestamp: Date;
        source: string;
        context: string | null;
        userId: string | null;
        userEmail: string | null;
        message: string;
        stack: string | null;
        detail: import("@prisma/client/runtime/client").JsonValue | null;
        method: string | null;
        ip: string | null;
    }>;
}
