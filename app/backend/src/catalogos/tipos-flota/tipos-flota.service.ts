import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateTipoFlotaDto, UpdateTipoFlotaDto } from './dto';

@Injectable()
export class TiposFlotaService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createTipoFlotaDto: CreateTipoFlotaDto) {
        try {
            return await this.prisma.tipoFlota.create({
                data: createTipoFlotaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async obtenerTodos() {
        return await this.prisma.tipoFlota.findMany({
            orderBy: { orden: 'asc' },
        });
    }

    async obtenerUno(id: string) {
        const tipoFlota = await this.prisma.tipoFlota.findUnique({
            where: { id },
        });

        if (!tipoFlota) {
            throw new NotFoundException(`Tipo de flota con ID ${id} no encontrado`);
        }

        return tipoFlota;
    }

    async actualizar(id: string, updateTipoFlotaDto: UpdateTipoFlotaDto) {
        try {
            const tipoFlota = await this.obtenerUno(id);
            return await this.prisma.tipoFlota.update({
                where: { id: tipoFlota.id },
                data: updateTipoFlotaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async eliminar(id: string) {
        const tipoFlota = await this.obtenerUno(id);
        await this.prisma.tipoFlota.delete({
            where: { id: tipoFlota.id },
        });
        return { mensaje: 'Tipo de flota eliminado correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe un tipo de flota con ese código');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
