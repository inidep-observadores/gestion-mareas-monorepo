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
exports.BackupController = void 0;
const common_1 = require("@nestjs/common");
const backup_service_1 = require("./backup.service");
const decorators_1 = require("../../auth/decorators");
const interfaces_1 = require("../../auth/interfaces");
let BackupController = class BackupController {
    constructor(backupService) {
        this.backupService = backupService;
    }
    createBackup() {
        return this.backupService.createBackup();
    }
    getStatus() {
        return this.backupService.getStatus();
    }
    listBackups() {
        return this.backupService.listBackups();
    }
    restoreBackup(filename, confirmationPhrase) {
        return this.backupService.restoreBackup(filename, confirmationPhrase);
    }
    deleteBackup(filename) {
        return this.backupService.deleteBackup(filename);
    }
};
exports.BackupController = BackupController;
__decorate([
    (0, common_1.Post)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], BackupController.prototype, "createBackup", null);
__decorate([
    (0, common_1.Get)('status'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], BackupController.prototype, "getStatus", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], BackupController.prototype, "listBackups", null);
__decorate([
    (0, common_1.Post)('restore/:filename'),
    __param(0, (0, common_1.Param)('filename')),
    __param(1, (0, common_1.Body)('confirmationPhrase')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], BackupController.prototype, "restoreBackup", null);
__decorate([
    (0, common_1.Delete)(':filename'),
    __param(0, (0, common_1.Param)('filename')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], BackupController.prototype, "deleteBackup", null);
exports.BackupController = BackupController = __decorate([
    (0, common_1.Controller)('admin/backup'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __metadata("design:paramtypes", [backup_service_1.BackupService])
], BackupController);
//# sourceMappingURL=backup.controller.js.map