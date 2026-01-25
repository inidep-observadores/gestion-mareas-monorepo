import { Response } from 'express';
import { BackupService } from './backup.service';
export declare class BackupController {
    private readonly backupService;
    constructor(backupService: BackupService);
    createBackup(comment?: string): Promise<{
        message: string;
        filename: string;
        size: number;
        path: string;
    }>;
    getStatus(): {
        isConfigured: boolean;
        backupPath: string;
    };
    listBackups(): Promise<{
        filename: string;
        size: number;
        createdAt: Date;
        comment: string;
    }[]>;
    downloadBackup(filename: string, res: Response): Promise<void>;
    uploadBackup(file: Express.Multer.File): Promise<{
        message: string;
        filename: string;
        size: number;
        createdAt: any;
        comment: any;
    }>;
    restoreBackup(filename: string, confirmationPhrase: string): Promise<{
        message: string;
        filename: string;
        logFile: string;
    }>;
    deleteBackup(filename: string): Promise<{
        message: string;
    }>;
}
