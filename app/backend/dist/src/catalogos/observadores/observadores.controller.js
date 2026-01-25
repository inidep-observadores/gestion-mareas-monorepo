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
exports.ObservadoresController = void 0;
const common_1 = require("@nestjs/common");
const observadores_service_1 = require("./observadores.service");
const dto_1 = require("./dto");
const decorators_1 = require("../../auth/decorators");
const interfaces_1 = require("../../auth/interfaces");
let ObservadoresController = class ObservadoresController {
    constructor(observadoresService) {
        this.observadoresService = observadoresService;
    }
    crear(createObservadorDto) {
        return this.observadoresService.crear(createObservadorDto);
    }
    obtenerTodos() {
        return this.observadoresService.obtenerTodos();
    }
    obtenerUno(id) {
        return this.observadoresService.obtenerUno(id);
    }
    actualizar(id, updateObservadorDto) {
        return this.observadoresService.actualizar(id, updateObservadorDto);
    }
    eliminar(id) {
        return this.observadoresService.eliminar(id);
    }
};
exports.ObservadoresController = ObservadoresController;
__decorate([
    (0, common_1.Post)(),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateObservadorDto]),
    __metadata("design:returntype", void 0)
], ObservadoresController.prototype, "crear", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ObservadoresController.prototype, "obtenerTodos", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ObservadoresController.prototype, "obtenerUno", null);
__decorate([
    (0, common_1.Patch)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, dto_1.UpdateObservadorDto]),
    __metadata("design:returntype", void 0)
], ObservadoresController.prototype, "actualizar", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, common_1.Param)('id', common_1.ParseUUIDPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ObservadoresController.prototype, "eliminar", null);
exports.ObservadoresController = ObservadoresController = __decorate([
    (0, common_1.Controller)('catalogos/observadores'),
    (0, decorators_1.Auth)(),
    __metadata("design:paramtypes", [observadores_service_1.ObservadoresService])
], ObservadoresController);
//# sourceMappingURL=observadores.controller.js.map