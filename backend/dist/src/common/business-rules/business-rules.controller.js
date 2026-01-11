"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var BusinessRulesController_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.BusinessRulesController = void 0;
const common_1 = require("@nestjs/common");
const business_rules_service_1 = require("./business-rules.service");
let BusinessRulesController = BusinessRulesController_1 = class BusinessRulesController {
    constructor(businessRulesService) {
        this.businessRulesService = businessRulesService;
        this.logger = new common_1.Logger(BusinessRulesController_1.name);
    }
    getBusinessRules() {
        this.logger.log('Solicitud recibida: GET /config/reglas');
        try {
            const rules = this.businessRulesService.getRules();
            this.logger.log('Reglas de negocio entregadas correctamente');
            return rules;
        }
        catch (error) {
            this.logger.error('Error al obtener reglas de negocio', error);
            throw error;
        }
    }
};
exports.BusinessRulesController = BusinessRulesController;
__decorate([
    (0, common_1.Get)('reglas'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], BusinessRulesController.prototype, "getBusinessRules", null);
exports.BusinessRulesController = BusinessRulesController = BusinessRulesController_1 = __decorate([
    (0, common_1.Controller)('config'),
    __metadata("design:paramtypes", [business_rules_service_1.BusinessRulesService])
], BusinessRulesController);
//# sourceMappingURL=business-rules.controller.js.map