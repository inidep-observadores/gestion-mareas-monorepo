import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreatePesqueriaDto, UpdatePesqueriaDto } from './dto';

@Injectable()
export class PesqueriasService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createPesqueriaDto: CreatePesqueriaDto) {
        try {
            return await this.prisma.pesqueria.create({
                data: createPesqueriaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async obtenerTodos() {
        return await this.prisma.pesqueria.findMany({
            orderBy: { orden: 'asc' },
        });
    }

    async obtenerUno(id: string) {
        const pesqueria = await this.prisma.pesqueria.findUnique({
            where: { id },
        });

        if (!pesqueria) {
            throw new NotFoundException(`Pesquería con ID ${id} no encontrada`);
        }

        return pesqueria;
    }

    async actualizar(id: string, updatePesqueriaDto: UpdatePesqueriaDto) {
        try {
            const pesqueria = await this.obtenerUno(id);
            return await this.prisma.pesqueria.update({
                where: { id: pesqueria.id },
                data: updatePesqueriaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async eliminar(id: string) {
        const pesqueria = await this.obtenerUno(id);
        await this.prisma.pesqueria.delete({
            where: { id: pesqueria.id },
        });
        return { mensaje: 'Pesquería eliminada correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe una pesquería con ese código');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
