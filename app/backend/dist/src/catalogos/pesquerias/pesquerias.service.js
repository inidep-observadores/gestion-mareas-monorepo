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
exports.PesqueriasService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let PesqueriasService = class PesqueriasService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createPesqueriaDto) {
        try {
            return await this.prisma.pesqueria.create({
                data: createPesqueriaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async obtenerTodos() {
        return await this.prisma.pesqueria.findMany({
            orderBy: { orden: 'asc' },
        });
    }
    async obtenerUno(id) {
        const pesqueria = await this.prisma.pesqueria.findUnique({
            where: { id },
        });
        if (!pesqueria) {
            throw new common_1.NotFoundException(`Pesquería con ID ${id} no encontrada`);
        }
        return pesqueria;
    }
    async actualizar(id, updatePesqueriaDto) {
        try {
            const pesqueria = await this.obtenerUno(id);
            return await this.prisma.pesqueria.update({
                where: { id: pesqueria.id },
                data: updatePesqueriaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async eliminar(id) {
        const pesqueria = await this.obtenerUno(id);
        await this.prisma.pesqueria.delete({
            where: { id: pesqueria.id },
        });
        return { mensaje: 'Pesquería eliminada correctamente' };
    }
    handleDBErrors(error) {
        if (error.code === 'P2002') {
            throw new common_1.BadRequestException('Ya existe una pesquería con ese código');
        }
        console.error(error);
        throw new common_1.InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
};
exports.PesqueriasService = PesqueriasService;
exports.PesqueriasService = PesqueriasService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], PesqueriasService);
//# sourceMappingURL=pesquerias.service.js.map