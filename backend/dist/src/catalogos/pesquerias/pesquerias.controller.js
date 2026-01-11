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
exports.PesqueriasController = void 0;
const common_1 = require("@nestjs/common");
const pesquerias_service_1 = require("./pesquerias.service");
const dto_1 = require("./dto");
const decorators_1 = require("../../auth/decorators");
const interfaces_1 = require("../../auth/interfaces");
let PesqueriasController = class PesqueriasController {
    constructor(pesqueriasService) {
        this.pesqueriasService = pesqueriasService;
    }
    crear(createPesqueriaDto) {
        return this.pesqueriasService.crear(createPesqueriaDto);
    }
    obtenerTodos() {
        return this.pesqueriasService.obtenerTodos();
    }
    obtenerUno(id) {
        return this.pesqueriasService.obtenerUno(id);
    }
    actualizar(id, updatePesqueriaDto) {
        return this.pesqueriasService.actualizar(id, updatePesqueriaDto);
    }
    eliminar(id) {
        return this.pesqueriasService.eliminar(id);
    }
};
exports.PesqueriasController = PesqueriasController;
__decorate([
    (0, common_1.Post)(),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreatePesqueriaDto]),
    __metadata("design:returntype", void 0)
], PesqueriasController.prototype, "crear", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], PesqueriasController.prototype, "obtenerTodos", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], PesqueriasController.prototype, "obtenerUno", null);
__decorate([
    (0, common_1.Patch)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.UpdatePesqueriaDto]),
    __metadata("design:returntype", void 0)
], PesqueriasController.prototype, "actualizar", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], PesqueriasController.prototype, "eliminar", null);
exports.PesqueriasController = PesqueriasController = __decorate([
    (0, common_1.Controller)('catalogos/pesquerias'),
    (0, decorators_1.Auth)(),
    __metadata("design:paramtypes", [pesquerias_service_1.PesqueriasService])
], PesqueriasController);
//# sourceMappingURL=pesquerias.controller.js.map