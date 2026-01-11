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
exports.TiposFlotaService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let TiposFlotaService = class TiposFlotaService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createTipoFlotaDto) {
        try {
            return await this.prisma.tipoFlota.create({
                data: createTipoFlotaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async obtenerTodos() {
        return await this.prisma.tipoFlota.findMany({
            orderBy: { orden: 'asc' },
        });
    }
    async obtenerUno(id) {
        const tipoFlota = await this.prisma.tipoFlota.findUnique({
            where: { id },
        });
        if (!tipoFlota) {
            throw new common_1.NotFoundException(`Tipo de flota con ID ${id} no encontrado`);
        }
        return tipoFlota;
    }
    async actualizar(id, updateTipoFlotaDto) {
        try {
            const tipoFlota = await this.obtenerUno(id);
            return await this.prisma.tipoFlota.update({
                where: { id: tipoFlota.id },
                data: updateTipoFlotaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async eliminar(id) {
        const tipoFlota = await this.obtenerUno(id);
        await this.prisma.tipoFlota.delete({
            where: { id: tipoFlota.id },
        });
        return { mensaje: 'Tipo de flota eliminado correctamente' };
    }
    handleDBErrors(error) {
        if (error.code === 'P2002') {
            throw new common_1.BadRequestException('Ya existe un tipo de flota con ese código');
        }
        console.error(error);
        throw new common_1.InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
};
exports.TiposFlotaService = TiposFlotaService;
exports.TiposFlotaService = TiposFlotaService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], TiposFlotaService);
//# sourceMappingURL=tipos-flota.service.js.map