import { ConfigService } from '@nestjs/config';
export declare class BackupService {
    private configService;
    private readonly logger;
    private readonly backupPath;
    private readonly isConfigured;
    constructor(configService: ConfigService);
    getStatus(): {
        isConfigured: boolean;
        backupPath: string;
    };
    createBackup(): Promise<{
        message: string;
        filename: string;
        path: string;
    }>;
    listBackups(): Promise<{
        filename: string;
        size: number;
        createdAt: Date;
    }[]>;
    restoreBackup(filename: string, confirmationPhrase: string): Promise<{
        message: string;
        filename: string;
    }>;
    deleteBackup(filename: string): Promise<{
        message: string;
    }>;
}
