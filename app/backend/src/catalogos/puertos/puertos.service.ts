import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreatePuertoDto, UpdatePuertoDto } from './dto';

@Injectable()
export class PuertosService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createPuertoDto: CreatePuertoDto) {
        return await this.prisma.puerto.create({
            data: createPuertoDto,
        });
    }

    async obtenerTodos() {
        return await this.prisma.puerto.findMany({
            orderBy: { orden: 'asc' },
        });
    }

    async obtenerUno(id: string) {
        const puerto = await this.prisma.puerto.findUnique({
            where: { id },
        });

        if (!puerto) {
            throw new NotFoundException(`Puerto con ID ${id} no encontrado`);
        }

        return puerto;
    }

    async actualizar(id: string, updatePuertoDto: UpdatePuertoDto) {
        const puerto = await this.obtenerUno(id);
        return await this.prisma.puerto.update({
            where: { id: puerto.id },
            data: updatePuertoDto,
        });
    }

    async eliminar(id: string) {
        const puerto = await this.obtenerUno(id);
        await this.prisma.puerto.delete({
            where: { id: puerto.id },
        });
        return { mensaje: 'Puerto eliminado correctamente' };
    }
}
