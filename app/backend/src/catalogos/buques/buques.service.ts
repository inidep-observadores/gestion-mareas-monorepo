import { BadRequestException, HttpException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateBuqueDto, UpdateBuqueDto } from './dto';

@Injectable()
export class BuquesService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createBuqueDto: CreateBuqueDto) {
        try {
            this.validarCalificacionYObservaciones(createBuqueDto.calificacion, createBuqueDto.observaciones);
            return await this.prisma.buque.create({
                data: createBuqueDto,
            });
        } catch (error) {
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

    async obtenerUno(id: string) {
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
            throw new NotFoundException(`Buque con ID ${id} no encontrado`);
        }

        return buque;
    }

    async actualizar(id: string, updateBuqueDto: UpdateBuqueDto) {
        try {
            const buque = await this.obtenerUno(id);
            const calificacionFinal = updateBuqueDto.calificacion !== undefined ? updateBuqueDto.calificacion : buque.calificacion;
            const observacionesFinales = updateBuqueDto.observaciones !== undefined ? updateBuqueDto.observaciones : buque.observaciones;

            this.validarCalificacionYObservaciones(calificacionFinal, observacionesFinales);

            return await this.prisma.buque.update({
                where: { id: buque.id },
                data: updateBuqueDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    private validarCalificacionYObservaciones(calificacion?: number | null, observaciones?: string | null) {
        if (calificacion !== undefined && calificacion !== null && calificacion < 3) {
            if (!observaciones || observaciones.trim() === '') {
                throw new BadRequestException('Para buques con calificación menor a 3 estrellas, es obligatorio ingresar un detalle en Observaciones');
            }
        }
    }

    async eliminar(id: string) {
        const buque = await this.obtenerUno(id);
        await this.prisma.buque.delete({
            where: { id: buque.id },
        });
        return { mensaje: 'Buque eliminado correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error instanceof HttpException) {
            throw error;
        }
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe un buque con esa matrícula');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
