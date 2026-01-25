"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AlertaPrioridad = exports.AlertaEstado = void 0;
var AlertaEstado;
(function (AlertaEstado) {
    AlertaEstado["PENDIENTE"] = "PENDIENTE";
    AlertaEstado["SEGUIMIENTO"] = "SEGUIMIENTO";
    AlertaEstado["RESUELTA"] = "RESUELTA";
    AlertaEstado["DESCARTADA"] = "DESCARTADA";
    AlertaEstado["VENCIDA"] = "VENCIDA";
})(AlertaEstado || (exports.AlertaEstado = AlertaEstado = {}));
var AlertaPrioridad;
(function (AlertaPrioridad) {
    AlertaPrioridad["URGENTE"] = "URGENTE";
    AlertaPrioridad["ALTA"] = "ALTA";
    AlertaPrioridad["MEDIA"] = "MEDIA";
    AlertaPrioridad["BAJA"] = "BAJA";
})(AlertaPrioridad || (exports.AlertaPrioridad = AlertaPrioridad = {}));
//# sourceMappingURL=alerts.enums.js.map