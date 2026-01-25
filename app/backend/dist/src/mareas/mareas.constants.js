"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TipoEtapa = exports.TipoMarea = exports.MareaEstado = void 0;
var MareaEstado;
(function (MareaEstado) {
    MareaEstado["DESIGNADA"] = "DESIGNADA";
    MareaEstado["EN_EJECUCION"] = "EN_EJECUCION";
    MareaEstado["ESPERANDO_ENTREGA"] = "ESPERANDO_ENTREGA";
    MareaEstado["ENTREGADA_RECIBIDA"] = "ENTREGADA_RECIBIDA";
    MareaEstado["VERIFICACION_INICIAL"] = "VERIFICACION_INICIAL";
    MareaEstado["EN_CORRECCION"] = "EN_CORRECCION";
    MareaEstado["DELEGADA_EXTERNA"] = "DELEGADA_EXTERNA";
    MareaEstado["PENDIENTE_DE_INFORME"] = "PENDIENTE_DE_INFORME";
    MareaEstado["ESPERANDO_REVISION"] = "ESPERANDO_REVISION";
    MareaEstado["PARA_PROTOCOLIZAR"] = "PARA_PROTOCOLIZAR";
    MareaEstado["ESPERANDO_PROTOCOLIZACION"] = "ESPERANDO_PROTOCOLIZACION";
    MareaEstado["PROTOCOLIZADA"] = "PROTOCOLIZADA";
    MareaEstado["CANCELADA"] = "CANCELADA";
})(MareaEstado || (exports.MareaEstado = MareaEstado = {}));
var TipoMarea;
(function (TipoMarea) {
    TipoMarea["MC"] = "MC";
    TipoMarea["CI"] = "CI";
})(TipoMarea || (exports.TipoMarea = TipoMarea = {}));
var TipoEtapa;
(function (TipoEtapa) {
    TipoEtapa["MC"] = "MC";
    TipoEtapa["CI"] = "CI";
})(TipoEtapa || (exports.TipoEtapa = TipoEtapa = {}));
//# sourceMappingURL=mareas.constants.js.map