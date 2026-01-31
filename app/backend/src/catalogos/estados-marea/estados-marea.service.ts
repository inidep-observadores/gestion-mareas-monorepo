import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateEstadoMareaDto, UpdateEstadoMareaDto } from './dto';

@Injectable()
export class EstadosMareaService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createEstadoMareaDto: CreateEstadoMareaDto) {
        try {
            return await this.prisma.estadoMarea.create({
                data: createEstadoMareaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async obtenerTodos() {
        return await this.prisma.estadoMarea.findMany({
            orderBy: { orden: 'asc' },
        });
    }

    async obtenerUno(id: string) {
        const estadoMarea = await this.prisma.estadoMarea.findUnique({
            where: { id },
        });

        if (!estadoMarea) {
            throw new NotFoundException(`Estado de marea con ID ${id} no encontrado`);
        }

        return estadoMarea;
    }

    async actualizar(id: string, updateEstadoMareaDto: UpdateEstadoMareaDto) {
        try {
            const estadoMarea = await this.obtenerUno(id);
            return await this.prisma.estadoMarea.update({
                where: { id: estadoMarea.id },
                data: updateEstadoMareaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async eliminar(id: string) {
        const estadoMarea = await this.obtenerUno(id);
        await this.prisma.estadoMarea.delete({
            where: { id: estadoMarea.id },
        });
        return { mensaje: 'Estado de marea eliminado correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe un estado de marea con ese código');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
