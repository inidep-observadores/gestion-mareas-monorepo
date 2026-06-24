import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateNovedadDto } from './dto/create-novedad.dto';
import { UpdateNovedadDto } from './dto/update-novedad.dto';

@Injectable()
export class NovedadesService {
  private readonly logger = new Logger(NovedadesService.name);

  constructor(private readonly prisma: PrismaService) {}

  async findAll(observadorId?: string) {
    const where = observadorId ? { observadorId } : {};
    return this.prisma.observadorNovedad.findMany({
      where,
      include: {
        observador: true,
        creadoPor: {
          select: { id: true, email: true, fullName: true }
        }
      },
      orderBy: { fechaInicio: 'desc' },
    });
  }

  async findOne(id: string) {
    const novedad = await this.prisma.observadorNovedad.findUnique({
      where: { id },
      include: {
        observador: true,
        creadoPor: {
          select: { id: true, email: true, fullName: true }
        }
      },
    });

    if (!novedad) throw new NotFoundException(`Novedad con ID ${id} no encontrada`);
    return novedad;
  }

  async create(createNovedadDto: CreateNovedadDto) {
    return this.prisma.observadorNovedad.create({
      data: {
        observadorId: createNovedadDto.observadorId,
        estadoDisponibilidad: createNovedadDto.estadoDisponibilidad,
        fechaInicio: new Date(createNovedadDto.fechaInicio),
        fechaFin: createNovedadDto.fechaFin ? new Date(createNovedadDto.fechaFin) : null,
        permiteUrgencia: createNovedadDto.permiteUrgencia || false,
        motivo: createNovedadDto.motivo,
        estadoAprobacion: 'APROBADA',
        origen: 'MANUAL',
      },
      include: { observador: true }
    });
  }

  async update(id: string, updateNovedadDto: UpdateNovedadDto) {
    await this.findOne(id);
    
    const data: any = { ...updateNovedadDto };
    if (updateNovedadDto.fechaInicio) data.fechaInicio = new Date(updateNovedadDto.fechaInicio);
    if (updateNovedadDto.fechaFin !== undefined) {
      data.fechaFin = updateNovedadDto.fechaFin ? new Date(updateNovedadDto.fechaFin) : null;
    }

    return this.prisma.observadorNovedad.update({
      where: { id },
      data,
      include: { observador: true }
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.observadorNovedad.delete({
      where: { id },
    });
  }
}
