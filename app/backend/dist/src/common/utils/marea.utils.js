"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MareaUtils = void 0;
const mareas_constants_1 = require("../../mareas/mareas.constants");
const date_utils_1 = require("./date.utils");
class MareaUtils {
    static formatCodigo(marea) {
        const prefix = marea.tipoMarea === mareas_constants_1.TipoMarea.CI ? 'CI' : 'MC';
        const shortYear = String(marea.anioMarea).slice(-2);
        return `${prefix}-${marea.nroMarea}-${shortYear}`;
    }
    static calculateStageDays(etapa) {
        if (!etapa.fechaZarpada)
            return 0;
        return date_utils_1.DateUtils.calculateInclusiveDays(etapa.fechaZarpada, etapa.fechaArribo);
    }
    static calculateNavigatedDays(marea) {
        if (!marea.etapas || marea.etapas.length === 0)
            return 0;
        const intervals = marea.etapas
            .filter(e => e.fechaZarpada)
            .map(e => ({
            start: e.fechaZarpada,
            end: e.fechaArribo
        }));
        return date_utils_1.DateUtils.calculateUniqueDays(intervals);
    }
}
exports.MareaUtils = MareaUtils;
//# sourceMappingURL=marea.utils.js.map