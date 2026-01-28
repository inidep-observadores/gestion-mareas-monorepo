import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';

@Injectable()
export class ObservadoresService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createObservadorDto: CreateObservadorDto) {
        if (createObservadorDto.disponible && createObservadorDto.conImpedimento) {
            throw new BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }

        if (createObservadorDto.conImpedimento === false) {
            createObservadorDto.motivoImpedimento = null;
        }

        // Si el email viene vacío o solo con espacios, ponerlo como null
        if (createObservadorDto.email && createObservadorDto.email.trim() === '') {
            createObservadorDto.email = null;
        } else if (createObservadorDto.email === '') {
            createObservadorDto.email = null;
        }

        return await this.prisma.observador.create({
            data: createObservadorDto as any,
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

        if (updateObservadorDto.disponible && updateObservadorDto.conImpedimento) {
            throw new BadRequestException('Un observador no puede estar disponible y tener impedimento al mismo tiempo');
        }

        if (updateObservadorDto.conImpedimento === false) {
            updateObservadorDto.motivoImpedimento = null;
        }

        // Si el email viene vacío o solo con espacios, ponerlo como null
        if (updateObservadorDto.email !== undefined) {
            if (updateObservadorDto.email === null || updateObservadorDto.email.trim() === '') {
                updateObservadorDto.email = null;
            }
        }

        return await this.prisma.observador.update({
            where: { id: observador.id },
            data: updateObservadorDto as any,
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
