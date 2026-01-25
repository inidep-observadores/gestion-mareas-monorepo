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
exports.StatsController = void 0;
const common_1 = require("@nestjs/common");
const stats_service_1 = require("./stats.service");
const decorators_1 = require("../auth/decorators");
const get_stats_dto_1 = require("./dto/get-stats.dto");
let StatsController = class StatsController {
    constructor(statsService) {
        this.statsService = statsService;
    }
    getDashboardStats(query) {
        return this.statsService.getDashboardStats(query.year, query.mode, query.includeNonProtocolized, query.includeProtocolizedOutOfPeriod, query.daysCalculationMode, query.includeCampaigns);
    }
    getDashboardStatsDetail(query) {
        return this.statsService.getDashboardStatsDetail(query.year, query.mode, query.includeNonProtocolized, query.includeProtocolizedOutOfPeriod, query.filterType, query.filterValue, query.daysCalculationMode, query.includeCampaigns);
    }
    async exportStats(res, query) {
        const workbook = await this.statsService.getExportWorkbook(query.year, query.mode, query.includeNonProtocolized, query.includeProtocolizedOutOfPeriod, query.daysCalculationMode, query.includeCampaigns, query.filterType, query.filterValue);
        const filename = query.customFilename ? `${query.customFilename}.xlsx` : `Estadisticas_Mareas_${query.year}.xlsx`;
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
        await workbook.xlsx.write(res);
        res.end();
    }
};
exports.StatsController = StatsController;
__decorate([
    (0, common_1.Get)('dashboard'),
    __param(0, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_stats_dto_1.GetStatsDto]),
    __metadata("design:returntype", void 0)
], StatsController.prototype, "getDashboardStats", null);
__decorate([
    (0, common_1.Get)('detail'),
    __param(0, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_stats_dto_1.GetStatsDto]),
    __metadata("design:returntype", void 0)
], StatsController.prototype, "getDashboardStatsDetail", null);
__decorate([
    (0, common_1.Get)('export'),
    __param(0, (0, common_1.Res)()),
    __param(1, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, get_stats_dto_1.GetStatsDto]),
    __metadata("design:returntype", Promise)
], StatsController.prototype, "exportStats", null);
exports.StatsController = StatsController = __decorate([
    (0, common_1.Controller)('stats'),
    (0, decorators_1.Auth)(),
    __metadata("design:paramtypes", [stats_service_1.StatsService])
], StatsController);
//# sourceMappingURL=stats.controller.js.map