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
exports.EstadosMareaService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let EstadosMareaService = class EstadosMareaService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createEstadoMareaDto) {
        try {
            return await this.prisma.estadoMarea.create({
                data: createEstadoMareaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async obtenerTodos() {
        return await this.prisma.estadoMarea.findMany({
            orderBy: { orden: 'asc' },
        });
    }
    async obtenerUno(id) {
        const estadoMarea = await this.prisma.estadoMarea.findUnique({
            where: { id },
        });
        if (!estadoMarea) {
            throw new common_1.NotFoundException(`Estado de marea con ID ${id} no encontrado`);
        }
        return estadoMarea;
    }
    async actualizar(id, updateEstadoMareaDto) {
        try {
            const estadoMarea = await this.obtenerUno(id);
            return await this.prisma.estadoMarea.update({
                where: { id: estadoMarea.id },
                data: updateEstadoMareaDto,
            });
        }
        catch (error) {
            this.handleDBErrors(error);
        }
    }
    async eliminar(id) {
        const estadoMarea = await this.obtenerUno(id);
        await this.prisma.estadoMarea.delete({
            where: { id: estadoMarea.id },
        });
        return { mensaje: 'Estado de marea eliminado correctamente' };
    }
    handleDBErrors(error) {
        if (error.code === 'P2002') {
            throw new common_1.BadRequestException('Ya existe un estado de marea con ese código');
        }
        console.error(error);
        throw new common_1.InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
};
exports.EstadosMareaService = EstadosMareaService;
exports.EstadosMareaService = EstadosMareaService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EstadosMareaService);
//# sourceMappingURL=estados-marea.service.js.map