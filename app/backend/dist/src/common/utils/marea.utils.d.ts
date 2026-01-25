import { Marea } from '@prisma/client';
export declare class MareaUtils {
    static formatCodigo(marea: Partial<Marea>): string;
    static calculateStageDays(etapa: {
        fechaZarpada?: Date | string | null;
        fechaArribo?: Date | string | null;
    }): number;
    static calculateNavigatedDays(marea: {
        etapas?: any[];
    }): number;
}
