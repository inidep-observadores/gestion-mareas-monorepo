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
exports.ObservadoresService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
let ObservadoresService = class ObservadoresService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async crear(createObservadorDto) {
        if (createObservadorDto.conImpedimento === false) {
            createObservadorDto.motivoImpedimento = null;
        }
        return await this.prisma.observador.create({
            data: createObservadorDto,
        });
    }
    async obtenerTodos() {
        try {
            return await this.prisma.observador.findMany({
                orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
            });
        }
        catch (error) {
            console.error(error);
            throw new common_1.InternalServerErrorException('Error al obtener observadores');
        }
    }
    async obtenerUno(id) {
        const observador = await this.prisma.observador.findUnique({
            where: { id },
            include: { pesquerias: true }
        });
        if (!observador) {
            throw new common_1.NotFoundException(`Observador con ID ${id} no encontrado`);
        }
        return observador;
    }
    async actualizar(id, updateObservadorDto) {
        const observador = await this.obtenerUno(id);
        if (updateObservadorDto.conImpedimento === false) {
            updateObservadorDto.motivoImpedimento = null;
        }
        return await this.prisma.observador.update({
            where: { id: observador.id },
            data: updateObservadorDto,
        });
    }
    async eliminar(id) {
        const observador = await this.obtenerUno(id);
        await this.prisma.observador.delete({
            where: { id: observador.id },
        });
        return { mensaje: 'Observador eliminado correctamente' };
    }
};
exports.ObservadoresService = ObservadoresService;
exports.ObservadoresService = ObservadoresService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ObservadoresService);
//# sourceMappingURL=observadores.service.js.map