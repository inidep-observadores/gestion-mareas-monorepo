import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateArtePescaDto, UpdateArtePescaDto } from './dto';

@Injectable()
export class ArtesPescaService {
    constructor(private readonly prisma: PrismaService) { }

    async crear(createArtePescaDto: CreateArtePescaDto) {
        try {
            return await this.prisma.artePesca.create({
                data: createArtePescaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async obtenerTodos() {
        return await this.prisma.artePesca.findMany({
            orderBy: { codigoNumerico: 'asc' },
        });
    }

    async obtenerUno(id: string) {
        const artePesca = await this.prisma.artePesca.findUnique({
            where: { id },
        });

        if (!artePesca) {
            throw new NotFoundException(`Arte de pesca con ID ${id} no encontrado`);
        }

        return artePesca;
    }

    async actualizar(id: string, updateArtePescaDto: UpdateArtePescaDto) {
        try {
            const artePesca = await this.obtenerUno(id);
            return await this.prisma.artePesca.update({
                where: { id: artePesca.id },
                data: updateArtePescaDto,
            });
        } catch (error) {
            this.handleDBErrors(error);
        }
    }

    async eliminar(id: string) {
        const artePesca = await this.obtenerUno(id);
        await this.prisma.artePesca.delete({
            where: { id: artePesca.id },
        });
        return { mensaje: 'Arte de pesca eliminado correctamente' };
    }

    private handleDBErrors(error: any): never {
        if (error.code === 'P2002') {
            throw new BadRequestException('Ya existe un arte de pesca con ese código numérico');
        }
        console.error(error);
        throw new InternalServerErrorException('Error inesperado, revise los logs del servidor');
    }
}
