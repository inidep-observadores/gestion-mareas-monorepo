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
exports.EspeciesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let EspeciesService = class EspeciesService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createEspecieDto) {
        try {
            return await this.prisma.especie.create({
                data: createEspecieDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async obtenerTodos() {
        return await this.prisma.especie.findMany({
            orderBy: { nombreVulgar: 'asc' },
        });
    }
    async obtenerUno(id) {
        const especie = await this.prisma.especie.findUnique({
            where: { id },
        });
        if (!especie) {
            throw new common_1.NotFoundException(`Especie con ID ${id} no encontrada`);
        }
        return especie;
    }
    async actualizar(id, updateEspecieDto) {
        try {
            const especie = await this.obtenerUno(id);
            return await this.prisma.especie.update({
                where: { id: especie.id },
                data: updateEspecieDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async eliminar(id) {
        const especie = await this.obtenerUno(id);
        await this.prisma.especie.delete({
            where: { id: especie.id },
        });
        return { mensaje: 'Especie eliminada correctamente' };
    }
    handleDBErrors(error) {
        if (error.code === 'P2002') {
            throw new common_1.BadRequestException('Ya existe una especie con ese código');
        }
        console.error(error);
        throw new common_1.InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
};
exports.EspeciesService = EspeciesService;
exports.EspeciesService = EspeciesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EspeciesService);
//# sourceMappingURL=especies.service.js.map