import { PrismaService } from 'src/prisma/prisma.service';
export declare class ErrorLogsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    create(data: {
        level: string;
        source: string;
        context?: string;
        userId?: string;
        userEmail?: string;
        message: string;
        stack?: string;
        detail?: any;
        path?: string;
        method?: string;
        ip?: string;
    }): Promise<{
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
