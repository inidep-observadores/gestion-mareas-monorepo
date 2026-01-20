import { Marea } from '@prisma/client';
import { TipoMarea } from '../../mareas/mareas.constants';

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
}
