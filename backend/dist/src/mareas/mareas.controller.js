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
exports.MareasController = void 0;
const common_1 = require("@nestjs/common");
const mareas_service_1 = require("./mareas.service");
const decorators_1 = require("../auth/decorators");
const create_marea_dto_1 = require("./dto/create-marea.dto");
const update_marea_dto_1 = require("./dto/update-marea.dto");
const claim_marea_dto_1 = require("./dto/claim-marea.dto");
let MareasController = class MareasController {
    constructor(mareasService) {
        this.mareasService = mareasService;
    }
    sendClaim(dto, user) {
        return this.mareasService.sendClaim(dto, user);
    }
    getDashboardOperativo(year) {
        return this.mareasService.getDashboardOperativo(year ? Number(year) : undefined);
    }
    getDashboardKpis(year) {
        return this.mareasService.getDashboardKpis(year ? Number(year) : undefined);
    }
    getInbox(year) {
        return this.mareasService.getInbox(year ? Number(year) : undefined);
    }
    getFleetDistribution(year) {
        return this.mareasService.getFleetDistributionByFishery(year ? Number(year) : undefined);
    }
    getWorkforceStatus(year) {
        return this.mareasService.getWorkforceStatus(year ? Number(year) : undefined);
    }
    getFatigueAlerts(year) {
        return this.mareasService.getFatigueAlerts(year ? Number(year) : undefined);
    }
    getCriticalDelays(year) {
        return this.mareasService.getCriticalDelays(year ? Number(year) : undefined);
    }
    getReportDelays(year) {
        return this.mareasService.getReportDelays(year ? Number(year) : undefined);
    }
    getCalendarEvents(year) {
        return this.mareasService.getCalendarEvents(year ? Number(year) : undefined);
    }
    search(q) {
        return this.mareasService.search(q);
    }
    findOne(id) {
        return this.mareasService.findOne(id);
    }
    update(id, updateMareaDto) {
        return this.mareasService.update(id, updateMareaDto);
    }
    getMareaContext(id) {
        return this.mareasService.getMareaContext(id);
    }
    executeAction(id, actionKey, user, payload) {
        return this.mareasService.executeAction(id, actionKey, user, payload);
    }
    createMarea(createMareaDto, user) {
        return this.mareasService.create(createMareaDto, user);
    }
};
exports.MareasController = MareasController;
__decorate([
    (0, common_1.Post)('claim'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, decorators_1.GetUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [claim_marea_dto_1.ClaimMareaDto, Object]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "sendClaim", null);
__decorate([
    (0, common_1.Get)('operativo'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getDashboardOperativo", null);
__decorate([
    (0, common_1.Get)('kpis'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getDashboardKpis", null);
__decorate([
    (0, common_1.Get)('inbox'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getInbox", null);
__decorate([
    (0, common_1.Get)('flota-por-pesqueria'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getFleetDistribution", null);
__decorate([
    (0, common_1.Get)('workforce/status'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getWorkforceStatus", null);
__decorate([
    (0, common_1.Get)('alertas/personal-fatiga'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getFatigueAlerts", null);
__decorate([
    (0, common_1.Get)('alertas/retrasos-criticos'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getCriticalDelays", null);
__decorate([
    (0, common_1.Get)('alertas/informes-demorados'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getReportDelays", null);
__decorate([
    (0, common_1.Get)('calendar/events'),
    __param(0, (0, common_1.Query)('year')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getCalendarEvents", null);
__decorate([
    (0, common_1.Get)('search'),
    __param(0, (0, common_1.Query)('q')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "search", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "findOne", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_marea_dto_1.UpdateMareaDto]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "update", null);
__decorate([
    (0, common_1.Get)(':id/context'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "getMareaContext", null);
__decorate([
    (0, common_1.Post)(':id/actions/:actionKey'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Param)('actionKey')),
    __param(2, (0, decorators_1.GetUser)()),
    __param(3, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object, Object]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "executeAction", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, decorators_1.GetUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_marea_dto_1.CreateMareaDto, Object]),
    __metadata("design:returntype", void 0)
], MareasController.prototype, "createMarea", null);
exports.MareasController = MareasController = __decorate([
    (0, common_1.Controller)('mareas'),
    (0, decorators_1.Auth)(),
    __metadata("design:paramtypes", [mareas_service_1.MareasService])
], MareasController);
//# sourceMappingURL=mareas.controller.js.map