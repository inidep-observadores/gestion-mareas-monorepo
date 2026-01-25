import { ConfigService } from '@nestjs/config';
import { Response } from 'express';
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
    createBackup(comment?: string): Promise<{
        message: string;
        filename: string;
        size: number;
        path: string;
    }>;
    listBackups(): Promise<{
        filename: string;
        size: number;
        createdAt: Date;
        comment: string;
    }[]>;
    restoreBackup(filename: string, confirmationPhrase: string): Promise<{
        message: string;
        filename: string;
        logFile: string;
    }>;
    deleteBackup(filename: string): Promise<{
        message: string;
    }>;
    createBackupZip(filename: string, res: Response): Promise<void>;
    uploadBackup(file: Express.Multer.File): Promise<{
        message: string;
        filename: string;
        size: number;
        createdAt: any;
        comment: any;
    }>;
    private calculateFileHash;
    private executeDumpCommand;
}
