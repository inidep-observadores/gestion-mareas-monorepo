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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var AccessImportController_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccessImportController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const access_import_service_1 = require("./access-import.service");
const auth_decorator_1 = require("../auth/decorators/auth.decorator");
const valid_roles_1 = require("../auth/interfaces/valid-roles");
let AccessImportController = AccessImportController_1 = class AccessImportController {
    constructor(importService) {
        this.importService = importService;
        this.logger = new common_1.Logger(AccessImportController_1.name);
    }
    async uploadFile(file) {
        if (!file) {
            throw new Error('No se ha subido ningún archivo.');
        }
        this.logger.log(`Recibido archivo para importación: ${file.originalname} (${file.size} bytes)`);
        const summary = await this.importService.processFile(file.buffer);
        return {
            message: 'Archivo procesado exitosamente',
            summary,
        };
    }
};
exports.AccessImportController = AccessImportController;
__decorate([
    (0, common_1.Post)('upload'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('file')),
    __param(0, (0, common_1.UploadedFile)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], AccessImportController.prototype, "uploadFile", null);
exports.AccessImportController = AccessImportController = AccessImportController_1 = __decorate([
    (0, common_1.Controller)('access-import'),
    (0, auth_decorator_1.Auth)(valid_roles_1.ValidRoles.admin),
    __metadata("design:paramtypes", [access_import_service_1.AccessImportService])
], AccessImportController);
//# sourceMappingURL=access-import.controller.js.map