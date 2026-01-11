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
exports.BuquesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let BuquesService = class BuquesService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createBuqueDto) {
        try {
            return await this.prisma.buque.create({
                data: createBuqueDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async obtenerTodos() {
        return await this.prisma.buque.findMany({
            include: {
                tipoFlota: true,
                arteHabitual: true,
                pesqueriaHabitual: true,
                puertoBase: true,
            },
            orderBy: { nombreBuque: 'asc' },
        });
    }
    async obtenerUno(id) {
        const buque = await this.prisma.buque.findUnique({
            where: { id },
            include: {
                tipoFlota: true,
                arteHabitual: true,
                pesqueriaHabitual: true,
                puertoBase: true,
            },
        });
        if (!buque) {
            throw new common_1.NotFoundException(`Buque con ID ${id} no encontrado`);
        }
        return buque;
    }
    async actualizar(id, updateBuqueDto) {
        try {
            const buque = await this.obtenerUno(id);
            return await this.prisma.buque.update({
                where: { id: buque.id },
                data: updateBuqueDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async eliminar(id) {
        const buque = await this.obtenerUno(id);
        await this.prisma.buque.delete({
            where: { id: buque.id },
        });
        return { mensaje: 'Buque eliminado correctamente' };
    }
    handleDBErrors(error) {
        if (error.code === 'P2002') {
            throw new common_1.BadRequestException('Ya existe un buque con esa matrícula');
        }
        console.error(error);
        throw new common_1.InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
};
exports.BuquesService = BuquesService;
exports.BuquesService = BuquesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], BuquesService);
//# sourceMappingURL=buques.service.js.map