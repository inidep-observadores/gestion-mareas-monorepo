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
exports.ErrorLogsController = void 0;
const common_1 = require("@nestjs/common");
const error_logs_service_1 = require("./error-logs.service");
const auth_decorator_1 = require("../../auth/decorators/auth.decorator");
const interfaces_1 = require("../../auth/interfaces");
let ErrorLogsController = class ErrorLogsController {
    constructor(errorLogsService) {
        this.errorLogsService = errorLogsService;
    }
    findAll() {
        return this.errorLogsService.findAll();
    }
    findOne(id) {
        return this.errorLogsService.findOne(id);
    }
};
exports.ErrorLogsController = ErrorLogsController;
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ErrorLogsController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ErrorLogsController.prototype, "findOne", null);
exports.ErrorLogsController = ErrorLogsController = __decorate([
    (0, common_1.Controller)('error-logs'),
    (0, auth_decorator_1.Auth)(interfaces_1.ValidRoles.admin),
    __metadata("design:paramtypes", [error_logs_service_1.ErrorLogsService])
], ErrorLogsController);
//# sourceMappingURL=error-logs.controller.js.map