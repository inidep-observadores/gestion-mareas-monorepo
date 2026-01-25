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
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetStatsDto = exports.FilterType = exports.DaysCalculationMode = exports.StatsMode = void 0;
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
var StatsMode;
(function (StatsMode) {
    StatsMode["CALENDAR"] = "CALENDAR";
    StatsMode["TOTAL"] = "TOTAL";
})(StatsMode || (exports.StatsMode = StatsMode = {}));
var DaysCalculationMode;
(function (DaysCalculationMode) {
    DaysCalculationMode["SHIP"] = "SHIP";
    DaysCalculationMode["OBSERVER"] = "OBSERVER";
})(DaysCalculationMode || (exports.DaysCalculationMode = DaysCalculationMode = {}));
var FilterType;
(function (FilterType) {
    FilterType["FISHERY"] = "FISHERY";
    FilterType["FLEET"] = "FLEET";
    FilterType["OBSERVER"] = "OBSERVER";
})(FilterType || (exports.FilterType = FilterType = {}));
class GetStatsDto {
    constructor() {
        this.mode = StatsMode.CALENDAR;
        this.includeNonProtocolized = false;
        this.includeProtocolizedOutOfPeriod = false;
        this.daysCalculationMode = DaysCalculationMode.SHIP;
        this.includeCampaigns = true;
    }
}
exports.GetStatsDto = GetStatsDto;
__decorate([
    (0, class_validator_1.IsInt)(),
    (0, class_transformer_1.Transform)(({ value }) => parseInt(value)),
    __metadata("design:type", Number)
], GetStatsDto.prototype, "year", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(StatsMode),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], GetStatsDto.prototype, "mode", void 0);
__decorate([
    (0, class_validator_1.IsBoolean)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_transformer_1.Transform)(({ value }) => value === 'true'),
    __metadata("design:type", Boolean)
], GetStatsDto.prototype, "includeNonProtocolized", void 0);
__decorate([
    (0, class_validator_1.IsBoolean)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_transformer_1.Transform)(({ value }) => value === 'true'),
    __metadata("design:type", Boolean)
], GetStatsDto.prototype, "includeProtocolizedOutOfPeriod", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(DaysCalculationMode),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], GetStatsDto.prototype, "daysCalculationMode", void 0);
__decorate([
    (0, class_validator_1.IsBoolean)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_transformer_1.Transform)(({ value }) => value === 'true'),
    __metadata("design:type", Boolean)
], GetStatsDto.prototype, "includeCampaigns", void 0);
__decorate([
    (0, class_validator_1.IsEnum)(FilterType),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], GetStatsDto.prototype, "filterType", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], GetStatsDto.prototype, "filterValue", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsOptional)(),
    __metadata("design:type", String)
], GetStatsDto.prototype, "customFilename", void 0);
//# sourceMappingURL=get-stats.dto.js.map