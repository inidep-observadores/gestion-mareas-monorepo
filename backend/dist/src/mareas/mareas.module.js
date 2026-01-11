"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MareasModule = void 0;
const common_1 = require("@nestjs/common");
const mareas_service_1 = require("./mareas.service");
const mareas_controller_1 = require("./mareas.controller");
const prisma_module_1 = require("../prisma/prisma.module");
const auth_module_1 = require("../auth/auth.module");
const alerts_module_1 = require("../alerts/alerts.module");
const business_rules_module_1 = require("../common/business-rules/business-rules.module");
let MareasModule = class MareasModule {
};
exports.MareasModule = MareasModule;
exports.MareasModule = MareasModule = __decorate([
    (0, common_1.Module)({
        controllers: [mareas_controller_1.MareasController],
        providers: [mareas_service_1.MareasService],
        imports: [prisma_module_1.PrismaModule, auth_module_1.AuthModule, alerts_module_1.AlertsModule, business_rules_module_1.BusinessRulesModule],
        exports: [mareas_service_1.MareasService],
    })
], MareasModule);
//# sourceMappingURL=mareas.module.js.map