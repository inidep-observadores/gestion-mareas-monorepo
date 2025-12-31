import { Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';

@Injectable()
export class ObservadoresService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createObservadorDto: CreateObservadorDto) {
        return await this.prisma.observador.create({
            data: createObservadorDto,
        });
    }

    async obtenerTodos() {
        try {
            return await this.prisma.observador.findMany({
                orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
            });
        } catch (error) {
            console.error(error);
            throw new InternalServerErrorException('Error al obtener observadores');
        }
    }

    async obtenerUno(id: string) {
        const observador = await this.prisma.observador.findUnique({
            where: { id },
            include: { pesquerias: true }
        });

        if (!observador) {
            throw new NotFoundException(`Observador con ID ${id} no encontrado`);
        }

        return observador;
    }

    async actualizar(id: string, updateObservadorDto: UpdateObservadorDto) {
        const observador = await this.obtenerUno(id);
        return await this.prisma.observador.update({
            where: { id: observador.id },
            data: updateObservadorDto,
        });
    }

    async eliminar(id: string) {
        const observador = await this.obtenerUno(id);
        await this.prisma.observador.delete({
            where: { id: observador.id },
        });
        return { mensaje: 'Observador eliminado correctamente' };
    }
}
