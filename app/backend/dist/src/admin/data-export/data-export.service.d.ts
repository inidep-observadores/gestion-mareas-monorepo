import { PrismaService } from '../../prisma/prisma.service';
import { ConfigService } from '@nestjs/config';
export declare class DataExportService {
    private prisma;
    private configService;
    private readonly logger;
    private readonly exportPath;
    constructor(prisma: PrismaService, configService: ConfigService);
    generateExport(comment?: string): Promise<unknown>;
    listExports(): Promise<{
        filename: string;
        size: number;
        createdAt: Date;
        comment: string;
    }[]>;
    getExportFilePath(filename: string): Promise<string>;
    private appendDataToArchive;
    private exportCatalogs;
    private exportBuques;
    private exportMareas;
    importData(filePath: string): Promise<{
        message: string;
    }>;
    private importCatalogs;
    private importBuques;
    private importMareas;
    deleteExport(filename: string): Promise<{
        message: string;
    }>;
    private deleteAllData;
}
