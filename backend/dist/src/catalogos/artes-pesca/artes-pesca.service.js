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
exports.ArtesPescaService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let ArtesPescaService = class ArtesPescaService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createArtePescaDto) {
        try {
            return await this.prisma.artePesca.create({
                data: createArtePescaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async obtenerTodos() {
        return await this.prisma.artePesca.findMany({
            orderBy: { codigoNumerico: 'asc' },
        });
    }
    async obtenerUno(id) {
        const artePesca = await this.prisma.artePesca.findUnique({
            where: { id },
        });
        if (!artePesca) {
            throw new common_1.NotFoundException(`Arte de pesca con ID ${id} no encontrado`);
        }
        return artePesca;
    }
    async actualizar(id, updateArtePescaDto) {
        try {
            const artePesca = await this.obtenerUno(id);
            return await this.prisma.artePesca.update({
                where: { id: artePesca.id },
                data: updateArtePescaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async eliminar(id) {
        const artePesca = await this.obtenerUno(id);
        await this.prisma.artePesca.delete({
            where: { id: artePesca.id },
        });
        return { mensaje: 'Arte de pesca eliminado correctamente' };
    }
    handleDBErrors(error) {
        if (error.code === 'P2002') {
            throw new common_1.BadRequestException('Ya existe un arte de pesca con ese código numérico');
        }
        console.error(error);
        throw new common_1.InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
};
exports.ArtesPescaService = ArtesPescaService;
exports.ArtesPescaService = ArtesPescaService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ArtesPescaService);
//# sourceMappingURL=artes-pesca.service.js.map