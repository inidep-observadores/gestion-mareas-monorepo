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
exports.BuquesController = void 0;
const common_1 = require("@nestjs/common");
const buques_service_1 = require("./buques.service");
const dto_1 = require("./dto");
const decorators_1 = require("../../auth/decorators");
const interfaces_1 = require("../../auth/interfaces");
let BuquesController = class BuquesController {
    constructor(buquesService) {
        this.buquesService = buquesService;
    }
    crear(createBuqueDto) {
        return this.buquesService.crear(createBuqueDto);
    }
    obtenerTodos() {
        return this.buquesService.obtenerTodos();
    }
    obtenerUno(id) {
        return this.buquesService.obtenerUno(id);
    }
    actualizar(id, updateBuqueDto) {
        return this.buquesService.actualizar(id, updateBuqueDto);
    }
    eliminar(id) {
        return this.buquesService.eliminar(id);
    }
};
exports.BuquesController = BuquesController;
__decorate([
    (0, common_1.Post)(),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateBuqueDto]),
    __metadata("design:returntype", void 0)
], BuquesController.prototype, "crear", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], BuquesController.prototype, "obtenerTodos", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], BuquesController.prototype, "obtenerUno", null);
__decorate([
    (0, common_1.Patch)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.UpdateBuqueDto]),
    __metadata("design:returntype", void 0)
], BuquesController.prototype, "actualizar", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], BuquesController.prototype, "eliminar", null);
exports.BuquesController = BuquesController = __decorate([
    (0, common_1.Controller)('catalogos/buques'),
    (0, decorators_1.Auth)(),
    __metadata("design:paramtypes", [buques_service_1.BuquesService])
], BuquesController);
//# sourceMappingURL=buques.controller.js.map