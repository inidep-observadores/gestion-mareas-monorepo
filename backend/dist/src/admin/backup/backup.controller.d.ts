import { BackupService } from './backup.service';
export declare class BackupController {
    private readonly backupService;
    constructor(backupService: BackupService);
    createBackup(): Promise<{
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
    }[]>;
    restoreBackup(filename: string, confirmationPhrase: string): Promise<{
        message: string;
        filename: string;
    }>;
    deleteBackup(filename: string): Promise<{
        message: string;
    }>;
}
