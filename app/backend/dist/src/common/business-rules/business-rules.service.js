"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var BusinessRulesService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.BusinessRulesService = void 0;
const common_1 = require("@nestjs/common");
let BusinessRulesService = BusinessRulesService_1 = class BusinessRulesService {
    constructor() {
        this.logger = new common_1.Logger(BusinessRulesService_1.name);
        this.rules = {
            DIAS_NAVEGADOS_ANUALES: 180,
            DIAS_DESCANSO_POST_MAREA: 15,
            DIAS_EXCESO_TIERRA: 60,
            PLAZO_ENTREGA_DATOS: 15,
            PLAZO_CONFECCION_INFORME: 7,
            PLAZO_PROTOCOLIZACION: 15,
            PLAZO_RECHECK_CORTO: 3,
            PLAZO_RECHECK_MEDIO: 7,
            PLAZO_RECHECK_LARGO: 15,
            UMBRAL_FATIGA_ANUAL_PORCENTAJE: 0.9,
            ALERTA_DIAS_CORRIDOS: 60,
        };
    }
    getRules() {
        this.logger.log('Entrega de reglas de negocio (in-memory)');
        return this.rules;
    }
};
exports.BusinessRulesService = BusinessRulesService;
exports.BusinessRulesService = BusinessRulesService = BusinessRulesService_1 = __decorate([
    (0, common_1.Injectable)()
], BusinessRulesService);
//# sourceMappingURL=business-rules.service.js.map