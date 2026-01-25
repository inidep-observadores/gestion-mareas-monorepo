import { PrismaClient } from '@prisma/client';
export declare const LOAD_ORDER: string[];
export declare class DataLoader {
    private prisma;
    constructor(prisma: PrismaClient);
    private transformationRules;
    addTransformation(modelName: string, rule: (item: any) => any): void;
    transform(modelName: string, item: any): any;
    cleanAll(): Promise<void>;
    loadModel(modelName: string, dataDir: string): Promise<number>;
    loadAll(dataDir: string): Promise<void>;
}
