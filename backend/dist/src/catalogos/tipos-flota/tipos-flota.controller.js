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
exports.TiposFlotaController = void 0;
const common_1 = require("@nestjs/common");
const tipos_flota_service_1 = require("./tipos-flota.service");
const dto_1 = require("./dto");
const decorators_1 = require("../../auth/decorators");
const interfaces_1 = require("../../auth/interfaces");
let TiposFlotaController = class TiposFlotaController {
    constructor(tiposFlotaService) {
        this.tiposFlotaService = tiposFlotaService;
    }
    crear(createTipoFlotaDto) {
        return this.tiposFlotaService.crear(createTipoFlotaDto);
    }
    obtenerTodos() {
        return this.tiposFlotaService.obtenerTodos();
    }
    obtenerUno(id) {
        return this.tiposFlotaService.obtenerUno(id);
    }
    actualizar(id, updateTipoFlotaDto) {
        return this.tiposFlotaService.actualizar(id, updateTipoFlotaDto);
    }
    eliminar(id) {
        return this.tiposFlotaService.eliminar(id);
    }
};
exports.TiposFlotaController = TiposFlotaController;
__decorate([
    (0, common_1.Post)(),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateTipoFlotaDto]),
    __metadata("design:returntype", void 0)
], TiposFlotaController.prototype, "crear", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], TiposFlotaController.prototype, "obtenerTodos", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], TiposFlotaController.prototype, "obtenerUno", null);
__decorate([
    (0, common_1.Patch)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.UpdateTipoFlotaDto]),
    __metadata("design:returntype", void 0)
], TiposFlotaController.prototype, "actualizar", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], TiposFlotaController.prototype, "eliminar", null);
exports.TiposFlotaController = TiposFlotaController = __decorate([
    (0, common_1.Controller)('catalogos/tipos-flota'),
    (0, decorators_1.Auth)(),
    __metadata("design:paramtypes", [tipos_flota_service_1.TiposFlotaService])
], TiposFlotaController);
//# sourceMappingURL=tipos-flota.controller.js.map