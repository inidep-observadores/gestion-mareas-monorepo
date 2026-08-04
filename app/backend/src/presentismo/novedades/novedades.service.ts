import { Injectable, Logger, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateNovedadDto } from './dto/create-novedad.dto';
import { UpdateNovedadDto } from './dto/update-novedad.dto';
import { User } from '@prisma/client';
import { DateUtils } from '../../common/utils/date.utils';
import { DriveStorageService } from '../../files/drive-storage.service';

@Injectable()
export class NovedadesService {
    private readonly logger = new Logger(NovedadesService.name);

    constructor(
        private readonly prisma: PrismaService,
        private readonly driveStorageService: DriveStorageService
    ) {}

  async findAll(observadorId?: string, estadoAprobacion?: string) {
    const where: any = { activo: true };
    if (observadorId) where.observadorId = observadorId;
    if (estadoAprobacion) where.estadoAprobacion = estadoAprobacion;

    return this.prisma.observadorNovedad.findMany({
      where,
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

    if (!novedad || !novedad.activo) throw new NotFoundException(`Novedad con ID ${id} no encontrada`);
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
    let end: Date | null = createNovedadDto.fechaFin ? DateUtils.parseToAppZone(createNovedadDto.fechaFin) : null;
    let isInfinite = false;

    // Autocierre para eventos de un solo día conocidos
    if (['VIAJE_INICIO', 'VIAJE_FIN'].includes(tipoNovedad.codigo)) {
      if (!end) end = start;
    } else {
      if (!end) isInfinite = true;
    }

    const overlapConditions: any[] = [
      {
        OR: [
          { fechaFin: { gte: start } },
          { fechaFin: null }
        ]
      }
    ];

    if (!isInfinite) {
      overlapConditions.push({ fechaInicio: { lte: end } });
    }

    const overlaps = await this.prisma.observadorNovedad.findFirst({
      where: {
        observadorId: createNovedadDto.observadorId,
        tipoNovedadId: createNovedadDto.tipoNovedadId,
        estadoAprobacion: { not: 'RECHAZADA' },
        activo: true,
        AND: overlapConditions
      }
    });

    if (overlaps) {
      throw new BadRequestException('El observador ya tiene una novedad de este tipo registrada en estas fechas');
    }

    const created = await this.prisma.observadorNovedad.create({
      data: {
        observadorId: createNovedadDto.observadorId,
        tipoNovedadId: createNovedadDto.tipoNovedadId,
        fechaInicio: start,
        fechaFin: end,
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
        },
        archivos: createNovedadDto.archivo ? {
          create: {
            rutaArchivo: createNovedadDto.archivo.rutaArchivo,
            tipoArchivo: createNovedadDto.archivo.tipoArchivo,
            nombreOriginal: createNovedadDto.archivo.nombreOriginal,
            driveFileId: createNovedadDto.archivo.driveFileId,
          }
        } : undefined
      },
      include: { observador: true, tipoNovedad: true, archivos: true }
    });

    await this.procesarAutoValidacionMarea(created);
    return created;
  }

  async update(id: string, updateNovedadDto: UpdateNovedadDto, user?: User) {
    const existing = await this.findOne(id);
    
    const data: any = { ...updateNovedadDto };
    delete data.comentarioMovimiento;
    delete data.archivo;
    delete data.eliminarArchivoViejo;

    if (updateNovedadDto.fechaInicio) data.fechaInicio = DateUtils.parseToAppZone(updateNovedadDto.fechaInicio);
    if (updateNovedadDto.fechaFin !== undefined) {
      data.fechaFin = updateNovedadDto.fechaFin ? DateUtils.parseToAppZone(updateNovedadDto.fechaFin) : null;
    }

    const start = data.fechaInicio || existing.fechaInicio;
    let end = data.fechaFin !== undefined ? data.fechaFin : existing.fechaFin;
    let isInfinite = false;

    // Autocierre para eventos de un solo día en update
    if (['VIAJE_INICIO', 'VIAJE_FIN'].includes(existing.tipoNovedad.codigo)) {
      if (!end) {
        end = start;
        data.fechaFin = end;
      }
    } else {
      if (!end) isInfinite = true;
    }

    // Si no estamos rechazando la novedad, verificar solapamiento
    if (updateNovedadDto.estadoAprobacion !== 'RECHAZADA') {
      const overlapConditions: any[] = [
        {
          OR: [
            { fechaFin: { gte: start } },
            { fechaFin: null }
          ]
        }
      ];

      if (!isInfinite) {
        overlapConditions.push({ fechaInicio: { lte: end } });
      }

      const overlaps = await this.prisma.observadorNovedad.findFirst({
        where: {
          id: { not: id },
          observadorId: existing.observadorId,
          tipoNovedadId: data.tipoNovedadId !== undefined ? data.tipoNovedadId : existing.tipoNovedadId,
          estadoAprobacion: { not: 'RECHAZADA' },
          activo: true,
          AND: overlapConditions
        }
      });

      if (overlaps) {
        throw new BadRequestException('Las nuevas fechas se solapan con otra novedad del mismo tipo');
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

    // Manejo de archivos
    const archivoActual = existing.archivos?.[0];
    const tieneArchivoNuevo = !!updateNovedadDto.archivo;
    const debeEliminar = updateNovedadDto.eliminarArchivoViejo === true;

    if (tieneArchivoNuevo || debeEliminar) {
      if (archivoActual) {
        // Borrar el archivo viejo de la base de datos
        data.archivos = { deleteMany: { id: archivoActual.id } };
        // Borrar físicamente de Google Drive
        if (archivoActual.driveFileId) {
          await this.driveStorageService.deleteFile(archivoActual.driveFileId);
        }
      }

      if (tieneArchivoNuevo && updateNovedadDto.archivo) {
        data.archivos = {
          ...data.archivos, // Por si se agregó deleteMany arriba
          create: {
            rutaArchivo: updateNovedadDto.archivo.rutaArchivo,
            tipoArchivo: updateNovedadDto.archivo.tipoArchivo,
            nombreOriginal: updateNovedadDto.archivo.nombreOriginal,
            driveFileId: updateNovedadDto.archivo.driveFileId,
          }
        };
      }
    }

    const updated = await this.prisma.observadorNovedad.update({
      where: { id },
      data,
      include: { observador: true, tipoNovedad: true, archivos: true }
    });

    await this.procesarAutoValidacionMarea(updated);
    return updated;
  }

  private async procesarAutoValidacionMarea(novedad: any) {
    if (novedad.estadoAprobacion !== 'APROBADA') return;
    if (!novedad.tipoNovedad || !['VIAJE_INICIO', 'VIAJE_FIN'].includes(novedad.tipoNovedad.codigo)) return;

    const umbralDias = 5;
    const fechaNov = novedad.fechaInicio.getTime();

    // Buscar todas las mareas del observador (activas o recientes)
    const mareas = await this.prisma.marea.findMany({
      where: {
        observadorPrincipalId: novedad.observadorId,
        activo: true,
      },
      include: { etapas: { orderBy: { nroEtapa: 'asc' } } }
    });

    for (const marea of mareas) {
      if (novedad.tipoNovedad.codigo === 'VIAJE_INICIO') {
        const fechaReferencia = marea.etapas.length > 0 && marea.etapas[0].fechaZarpada
            ? marea.etapas[0].fechaZarpada.getTime()
            : marea.fechaZarpadaEstimada?.getTime();

        if (fechaReferencia) {
          const diffDays = Math.abs(fechaReferencia - fechaNov) / (1000 * 60 * 60 * 24);
          if (diffDays <= umbralDias) {
            await this.prisma.marea.update({
              where: { id: marea.id },
              data: { 
                inicioValidado: true,
                fechaInicioObservador: novedad.fechaInicio
              }
            });
            break; // Marea encontrada y actualizada
          }
        }
      } else if (novedad.tipoNovedad.codigo === 'VIAJE_FIN') {
        const ultimaEtapa = marea.etapas.length > 0 ? marea.etapas[marea.etapas.length - 1] : null;
        if (ultimaEtapa?.fechaArribo) {
          const diffDays = Math.abs(ultimaEtapa.fechaArribo.getTime() - fechaNov) / (1000 * 60 * 60 * 24);
          if (diffDays <= umbralDias) {
            await this.prisma.marea.update({
              where: { id: marea.id },
              data: { 
                finValidado: true,
                fechaFinObservador: novedad.fechaInicio
              }
            });
            break;
          }
        }
      }
    }
  }

  async remove(id: string, user?: User) {
    const existing = await this.findOne(id);
    return this.prisma.observadorNovedad.update({
      where: { id },
      data: {
        activo: false,
        movimientos: {
          create: {
            tipoEvento: 'BORRADO_LOGICO',
            estadoAnterior: existing.estadoAprobacion,
            estadoNuevo: existing.estadoAprobacion,
            usuarioId: user?.id,
          }
        }
      }
    });
  }
}
