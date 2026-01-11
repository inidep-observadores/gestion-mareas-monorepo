import { DataExportService } from './data-export.service';
import { Response } from 'express';
export declare class DataExportController {
    private readonly dataExportService;
    constructor(dataExportService: DataExportService);
    generateExport(): Promise<unknown>;
    listExports(): Promise<{
        filename: string;
        size: number;
        createdAt: Date;
    }[]>;
    downloadExport(filename: string, res: Response): Promise<void>;
    importData(file: Express.Multer.File): Promise<{
        message: string;
    }>;
}
