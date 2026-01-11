"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.BusinessRulesModule = void 0;
const common_1 = require("@nestjs/common");
const business_rules_controller_1 = require("./business-rules.controller");
const business_rules_service_1 = require("./business-rules.service");
let BusinessRulesModule = class BusinessRulesModule {
};
exports.BusinessRulesModule = BusinessRulesModule;
exports.BusinessRulesModule = BusinessRulesModule = __decorate([
    (0, common_1.Module)({
        controllers: [business_rules_controller_1.BusinessRulesController],
        providers: [business_rules_service_1.BusinessRulesService],
        exports: [business_rules_service_1.BusinessRulesService],
    })
], BusinessRulesModule);
//# sourceMappingURL=business-rules.module.js.map