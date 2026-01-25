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
exports.TrackingController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const tracking_service_1 = require("./tracking.service");
let TrackingController = class TrackingController {
    constructor(trackingService) {
        this.trackingService = trackingService;
    }
    async uploadFile(file) {
        if (!file) {
            throw new common_1.UnprocessableEntityException('No se ha recibido ningún archivo');
        }
        console.log(`[TrackingController] Recibido: ${file.originalname}, Mime: ${file.mimetype}`);
        const allowedTypes = ['text/csv', 'application/vnd.ms-excel', 'text/plain', 'application/octet-stream'];
        const isCsv = file.originalname.toLowerCase().endsWith('.csv');
        if (!allowedTypes.includes(file.mimetype) && !isCsv) {
            throw new common_1.UnprocessableEntityException('El archivo debe ser un CSV válido');
        }
        try {
            return await this.trackingService.importTrackingData(file.buffer);
        }
        catch (error) {
            console.error('[TrackingController] Error al importar:', error);
            throw new common_1.UnprocessableEntityException('Error al procesar el contenido del CSV. Verifique el formato.');
        }
    }
    async heartbeat() {
        return this.trackingService.checkHeartbeat();
    }
    async getFleet() {
        return this.trackingService.getLatestFleetPositions();
    }
    async getHistory(buqueId, from, to) {
        return this.trackingService.getVesselHistory(buqueId, from, to);
    }
    async getMareaTrackingInfo(mareaId) {
        return this.trackingService.getMareaTrackingInfo(mareaId);
    }
};
exports.TrackingController = TrackingController;
__decorate([
    (0, common_1.Post)('upload'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('file')),
    __param(0, (0, common_1.UploadedFile)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], TrackingController.prototype, "uploadFile", null);
__decorate([
    (0, common_1.Get)('heartbeat'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], TrackingController.prototype, "heartbeat", null);
__decorate([
    (0, common_1.Get)('fleet'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], TrackingController.prototype, "getFleet", null);
__decorate([
    (0, common_1.Get)('history/:buqueId'),
    __param(0, (0, common_1.Param)('buqueId')),
    __param(1, (0, common_1.Query)('from')),
    __param(2, (0, common_1.Query)('to')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String]),
    __metadata("design:returntype", Promise)
], TrackingController.prototype, "getHistory", null);
__decorate([
    (0, common_1.Get)('marea/:mareaId'),
    __param(0, (0, common_1.Param)('mareaId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], TrackingController.prototype, "getMareaTrackingInfo", null);
exports.TrackingController = TrackingController = __decorate([
    (0, common_1.Controller)('tracking'),
    __metadata("design:paramtypes", [tracking_service_1.TrackingService])
], TrackingController);
//# sourceMappingURL=tracking.controller.js.map