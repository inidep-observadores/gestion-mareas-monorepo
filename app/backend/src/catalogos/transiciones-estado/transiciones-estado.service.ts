import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateTransicionEstadoDto, UpdateTransicionEstadoDto } from './dto';

const INCLUDE_ESTADOS = {
    estadoOrigen: { select: { id: true, codigo: true, nombre: true, categoria: true, orden: true } },
    estadoDestino: { select: { id: true, codigo: true, nombre: true, categoria: true, orden: true } },
};

@Injectable()
export class TransicionesEstadoService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(dto: CreateTransicionEstadoDto) {
        try {
            return await this.prisma.transicionEstado.create({
                data: dto,
                include: INCLUDE_ESTADOS,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async obtenerTodos() {
        return await this.prisma.transicionEstado.findMany({
            include: INCLUDE_ESTADOS,
            orderBy: [
                { estadoOrigen: { orden: 'asc' } },
                { accion: 'asc' },
            ],
        });
    }

    async obtenerUno(id: string) {
        const transicion = await this.prisma.transicionEstado.findUnique({
            where: { id },
            include: INCLUDE_ESTADOS,
        });

        if (!transicion) {
            throw new NotFoundException(`Transición de estado con ID ${id} no encontrada`);
        }

        return transicion;
    }

    async actualizar(id: string, dto: UpdateTransicionEstadoDto) {
        try {
            const transicion = await this.obtenerUno(id);
            return await this.prisma.transicionEstado.update({
                where: { id: transicion.id },
                data: dto,
                include: INCLUDE_ESTADOS,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async eliminar(id: string) {
        const transicion = await this.obtenerUno(id);
        await this.prisma.transicionEstado.delete({ where: { id: transicion.id } });
        return { mensaje: 'Transición de estado eliminada correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error instanceof NotFoundException) throw error;
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe una transición con ese origen, destino y acción');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
