import { Marea } from '@prisma/client';
import { TipoMarea } from '../../mareas/mareas.constants';
import { DateUtils } from './date.utils';

export class MareaUtils {
    /**
     * Formate el código de marea en el formato estándar: PREFIX-NUMBER-YY
     * Ejemplo: MC-12-24
     */
    static formatCodigo(marea: Partial<Marea>): string {
        const prefix = marea.tipoMarea === TipoMarea.CI ? 'CI' : 'MC';
        const shortYear = String(marea.anioMarea).slice(-2);
        return `${prefix}-${marea.nroMarea}-${shortYear}`;
    }

    /**
     * Calcula los días navegados de una etapa específica de forma inclusiva.
     */
    static calculateStageDays(etapa: { fechaZarpada?: Date | string | null, fechaArribo?: Date | string | null }): number {
        if (!etapa.fechaZarpada) return 0;
        return DateUtils.calculateInclusiveDays(etapa.fechaZarpada, etapa.fechaArribo);
    }

    /**
     * Calcula el total de días navegados de la marea sumando la duración de sus etapas.
     * Utiliza días únicos para evitar conteos dobles en caso de solapamiento.
     */
    static calculateNavigatedDays(marea: { etapas?: any[] }): number {
        if (!marea.etapas || marea.etapas.length === 0) return 0;

        const intervals = marea.etapas
            .filter(e => e.fechaZarpada)
            .map(e => ({
                start: e.fechaZarpada,
                end: e.fechaArribo // DateUtils maneja el null usando la fecha actual si es necesario (o normalizando)
            }));

        return DateUtils.calculateUniqueDays(intervals);
    }
}
