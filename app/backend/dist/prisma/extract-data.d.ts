import { PrismaClient } from '@prisma/client';
export declare const MODELS: string[];
export declare class DataExporter {
    private prisma;
    constructor(prisma: PrismaClient);
    static serialize(item: any): string;
    exportModel(modelName: string, outputDir: string): Promise<number>;
    exportAll(outputDir: string): Promise<void>;
}
