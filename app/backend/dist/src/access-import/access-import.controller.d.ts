import { AccessImportService } from './access-import.service';
export declare class AccessImportController {
    private readonly importService;
    private readonly logger;
    constructor(importService: AccessImportService);
    uploadFile(file: Express.Multer.File): Promise<{
        message: string;
        summary: import("./access-import.service").ProcessingSummary;
    }>;
}
