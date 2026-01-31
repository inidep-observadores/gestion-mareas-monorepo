export class MareaUtils {
    /**
     * Formate el código de marea en el formato estándar: PREFIX-NUMBER-YY
     * Ejemplo: MC-12-24
     */
    static formatCodigo(marea: { tipoMarea: string; nroMarea: number; anioMarea: number }): string {
        const prefix = marea.tipoMarea === 'INSTITUCIONAL' || marea.tipoMarea === 'CI' ? 'CI' : 'MC';
        const shortYear = String(marea.anioMarea).slice(-2);
        return `${prefix}-${marea.nroMarea}-${shortYear}`;
    }
}
