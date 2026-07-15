import { Injectable, Logger, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateNovedadDto } from './dto/create-novedad.dto';
import { UpdateNovedadDto } from './dto/update-novedad.dto';
import { User } from '@prisma/client';
import { DateUtils } from '../../common/utils/date.utils';

@Injectable()
export class NovedadesService {
  private readonly logger = new Logger(NovedadesService.name);

  constructor(private readonly prisma: PrismaService) {}

  async findAll(observadorId?: string, estadoAprobacion?: string) {
    const where: any = {};
    if (observadorId) where.observadorId = observadorId;
    if (estadoAprobacion) where.estadoAprobacion = estadoAprobacion;

    return this.prisma.observadorNovedad.findMany({
      where,
      include: {
        observador: true,
        tipoNovedad: true,
        archivos: true,
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
        tipoNovedad: true,
        archivos: true,
        movimientos: {
          include: {
            usuario: { select: { id: true, email: true, fullName: true } }
          },
          orderBy: { fechaHora: 'desc' }
        },
        creadoPor: {
          select: { id: true, email: true, fullName: true }
        }
      },
    });

    if (!novedad) throw new NotFoundException(`Novedad con ID ${id} no encontrada`);
    return novedad;
  }

  async create(createNovedadDto: CreateNovedadDto, user?: User) {
    const observador = await this.prisma.observador.findUnique({
      where: { id: createNovedadDto.observadorId },
      select: { id: true, tipoContrato: true }
    });

    if (!observador) {
      throw new NotFoundException(`Observador con ID ${createNovedadDto.observadorId} no encontrado`);
    }

    const tipoNovedad = await this.prisma.tipoNovedad.findUnique({
      where: { id: createNovedadDto.tipoNovedadId }
    });

    if (!tipoNovedad) {
      throw new NotFoundException(`TipoNovedad con ID ${createNovedadDto.tipoNovedadId} no encontrado`);
    }

    if (!tipoNovedad.activo) {
      throw new BadRequestException('El tipo de novedad seleccionado no está activo');
    }

    if (tipoNovedad.tiposContratoPermitidos && tipoNovedad.tiposContratoPermitidos.length > 0) {
      if (!observador.tipoContrato || !tipoNovedad.tiposContratoPermitidos.includes(observador.tipoContrato)) {
        throw new BadRequestException(`El tipo de novedad no es aplicable para el contrato ${observador.tipoContrato}`);
      }
    }

    const start = DateUtils.parseToAppZone(createNovedadDto.fechaInicio);
    const end = createNovedadDto.fechaFin ? DateUtils.parseToAppZone(createNovedadDto.fechaFin) : start;

    const overlaps = await this.prisma.observadorNovedad.findFirst({
      where: {
        observadorId: createNovedadDto.observadorId,
        estadoAprobacion: { not: 'RECHAZADA' },
        AND: [
          { fechaInicio: { lte: end } },
          {
            OR: [
              { fechaFin: { gte: start } },
              { fechaFin: null, fechaInicio: { gte: start } }
            ]
          }
        ]
      }
    });

    if (overlaps) {
      throw new BadRequestException('El observador ya tiene una novedad registrada en estas fechas');
    }

    return this.prisma.observadorNovedad.create({
      data: {
        observadorId: createNovedadDto.observadorId,
        tipoNovedadId: createNovedadDto.tipoNovedadId,
        fechaInicio: DateUtils.parseToAppZone(createNovedadDto.fechaInicio),
        fechaFin: createNovedadDto.fechaFin ? DateUtils.parseToAppZone(createNovedadDto.fechaFin) : null,
        permiteUrgencia: createNovedadDto.permiteUrgencia || false,
        motivo: createNovedadDto.motivo,
        estadoAprobacion: 'APROBADA',
        origen: 'MANUAL',
        creadoPorId: user?.id,
        movimientos: {
          create: {
            tipoEvento: 'CREACION',
            estadoNuevo: 'APROBADA',
            usuarioId: user?.id,
          }
        }
      },
      include: { observador: true, tipoNovedad: true, archivos: true }
    });
  }

  async update(id: string, updateNovedadDto: UpdateNovedadDto, user?: User) {
    const existing = await this.findOne(id);
    
    const data: any = { ...updateNovedadDto };
    delete data.comentarioMovimiento; // No es parte de la entidad principal

    if (updateNovedadDto.fechaInicio) data.fechaInicio = DateUtils.parseToAppZone(updateNovedadDto.fechaInicio);
    if (updateNovedadDto.fechaFin !== undefined) {
      data.fechaFin = updateNovedadDto.fechaFin ? DateUtils.parseToAppZone(updateNovedadDto.fechaFin) : null;
    }

    const start = data.fechaInicio || existing.fechaInicio;
    const end = data.fechaFin !== undefined ? data.fechaFin : existing.fechaFin;
    const endCheck = end || start;

    // Si no estamos rechazando la novedad, verificar solapamiento
    if (updateNovedadDto.estadoAprobacion !== 'RECHAZADA') {
      const overlaps = await this.prisma.observadorNovedad.findFirst({
        where: {
          id: { not: id },
          observadorId: existing.observadorId,
          estadoAprobacion: { not: 'RECHAZADA' },
          AND: [
            { fechaInicio: { lte: endCheck } },
            {
              OR: [
                { fechaFin: { gte: start } },
                { fechaFin: null, fechaInicio: { gte: start } }
              ]
            }
          ]
        }
      });

      if (overlaps) {
        throw new BadRequestException('Las nuevas fechas se solapan con otra novedad existente del observador');
      }
    }

    let tipoEvento = 'EDICION';
    if (updateNovedadDto.estadoAprobacion && updateNovedadDto.estadoAprobacion !== existing.estadoAprobacion) {
      if (updateNovedadDto.estadoAprobacion === 'APROBADA') tipoEvento = 'APROBACION';
      if (updateNovedadDto.estadoAprobacion === 'RECHAZADA') tipoEvento = 'RECHAZO';
    }

    data.movimientos = {
      create: {
        tipoEvento,
        estadoAnterior: existing.estadoAprobacion,
        estadoNuevo: updateNovedadDto.estadoAprobacion || existing.estadoAprobacion,
        comentarios: updateNovedadDto.comentarioMovimiento || null,
        usuarioId: user?.id,
      }
    };

    return this.prisma.observadorNovedad.update({
      where: { id },
      data,
      include: { observador: true, tipoNovedad: true, archivos: true }
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.observadorNovedad.delete({
      where: { id },
    });
  }
}
