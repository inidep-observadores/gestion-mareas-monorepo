import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateEspecieDto, UpdateEspecieDto } from './dto';

@Injectable()
export class EspeciesService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createEspecieDto: CreateEspecieDto) {
        try {
            return await this.prisma.especie.create({
                data: createEspecieDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async obtenerTodos() {
        return await this.prisma.especie.findMany({
            orderBy: { nombreVulgar: 'asc' },
        });
    }

    async obtenerUno(id: string) {
        const especie = await this.prisma.especie.findUnique({
            where: { id },
        });

        if (!especie) {
            throw new NotFoundException(`Especie con ID ${id} no encontrada`);
        }

        return especie;
    }

    async actualizar(id: string, updateEspecieDto: UpdateEspecieDto) {
        try {
            const especie = await this.obtenerUno(id);
            return await this.prisma.especie.update({
                where: { id: especie.id },
                data: updateEspecieDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async eliminar(id: string) {
        const especie = await this.obtenerUno(id);
        await this.prisma.especie.delete({
            where: { id: especie.id },
        });
        return { mensaje: 'Especie eliminada correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe una especie con ese código');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
