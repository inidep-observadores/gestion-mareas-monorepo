import { DataExportService } from './data-export.service';
import { Response } from 'express';
export declare class DataExportController {
    private readonly dataExportService;
    constructor(dataExportService: DataExportService);
    generateExport(comment?: string): Promise<unknown>;
    listExports(): Promise<{
        filename: string;
        size: number;
        createdAt: Date;
        comment: string;
    }[]>;
    downloadExport(filename: string, res: Response): Promise<void>;
    importData(file: Express.Multer.File): Promise<{
        message: string;
    }>;
    deleteExport(filename: string): Promise<{
        message: string;
    }>;
}
