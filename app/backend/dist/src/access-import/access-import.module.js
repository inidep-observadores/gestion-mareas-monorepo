"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccessImportModule = void 0;
const common_1 = require("@nestjs/common");
const access_import_controller_1 = require("./access-import.controller");
const access_import_service_1 = require("./access-import.service");
const access_reader_service_1 = require("./access-reader.service");
const prisma_module_1 = require("../prisma/prisma.module");
const alerts_module_1 = require("../alerts/alerts.module");
const error_logs_module_1 = require("../common/error-logs/error-logs.module");
const auth_module_1 = require("../auth/auth.module");
let AccessImportModule = class AccessImportModule {
};
exports.AccessImportModule = AccessImportModule;
exports.AccessImportModule = AccessImportModule = __decorate([
    (0, common_1.Module)({
        imports: [prisma_module_1.PrismaModule, alerts_module_1.AlertsModule, error_logs_module_1.ErrorLogsModule, auth_module_1.AuthModule],
        controllers: [access_import_controller_1.AccessImportController],
        providers: [access_import_service_1.AccessImportService, access_reader_service_1.AccessReaderService],
        exports: [access_import_service_1.AccessImportService],
    })
], AccessImportModule);
//# sourceMappingURL=access-import.module.js.map