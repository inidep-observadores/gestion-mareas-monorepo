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
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataExportController = void 0;
const common_1 = require("@nestjs/common");
const data_export_service_1 = require("./data-export.service");
const platform_express_1 = require("@nestjs/platform-express");
const decorators_1 = require("../../auth/decorators");
const interfaces_1 = require("../../auth/interfaces");
let DataExportController = class DataExportController {
    constructor(dataExportService) {
        this.dataExportService = dataExportService;
    }
    async generateExport() {
        return this.dataExportService.generateExport();
    }
    async listExports() {
        return this.dataExportService.listExports();
    }
    async downloadExport(filename, res) {
        const filePath = await this.dataExportService.getExportFilePath(filename);
        res.download(filePath);
    }
    async importData(file) {
        if (!file)
            throw new common_1.BadRequestException('File is required');
        return this.dataExportService.importData(file.path);
    }
};
exports.DataExportController = DataExportController;
__decorate([
    (0, common_1.Post)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DataExportController.prototype, "generateExport", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DataExportController.prototype, "listExports", null);
__decorate([
    (0, common_1.Get)(':filename'),
    __param(0, (0, common_1.Param)('filename')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], DataExportController.prototype, "downloadExport", null);
__decorate([
    (0, common_1.Post)('import'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('file', { dest: './uploads/temp' })),
    __param(0, (0, common_1.UploadedFile)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], DataExportController.prototype, "importData", null);
exports.DataExportController = DataExportController = __decorate([
    (0, common_1.Controller)('admin/data-export'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __metadata("design:paramtypes", [data_export_service_1.DataExportService])
], DataExportController);
//# sourceMappingURL=data-export.controller.js.map