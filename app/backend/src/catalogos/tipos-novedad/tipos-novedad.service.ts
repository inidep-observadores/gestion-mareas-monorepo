import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateTipoNovedadDto } from './dto/create-tipo-novedad.dto';
import { UpdateTipoNovedadDto } from './dto/update-tipo-novedad.dto';

@Injectable()
export class TiposNovedadService {
    constructor(private prisma: PrismaService) {}

    async create(createTipoNovedadDto: CreateTipoNovedadDto) {
        return this.prisma.tipoNovedad.create({
            data: createTipoNovedadDto,
        });
    }

    async findAll() {
        return this.prisma.tipoNovedad.findMany({
            orderBy: { codigo: 'asc' },
        });
    }

    async findActivos() {
        return this.prisma.tipoNovedad.findMany({
            where: { activo: true },
            orderBy: { descripcion: 'asc' },
        });
    }

    async findOne(id: string) {
        const tipoNovedad = await this.prisma.tipoNovedad.findUnique({
            where: { id },
        });

        if (!tipoNovedad) {
            throw new NotFoundException(`TipoNovedad con ID ${id} no encontrado`);
        }

        return tipoNovedad;
    }

    async update(id: string, updateTipoNovedadDto: UpdateTipoNovedadDto) {
        // Verificar existencia
        await this.findOne(id);

        return this.prisma.tipoNovedad.update({
            where: { id },
            data: updateTipoNovedadDto,
        });
    }

    async remove(id: string) {
        // Verificar existencia
        await this.findOne(id);

        // Eliminado lógico
        return this.prisma.tipoNovedad.update({
            where: { id },
            data: { activo: false },
        });
    }
}
