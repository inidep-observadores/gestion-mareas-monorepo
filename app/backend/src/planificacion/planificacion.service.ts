import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BatchUpsertRequerimientosDto } from './dto/requerimientos.dto';

@Injectable()
export class PlanificacionService {
  private readonly logger = new Logger(PlanificacionService.name);

  constructor(private readonly prisma: PrismaService) {}

  /**
   * Obtiene todos los requerimientos de un año operativo específico,
   * incluyendo la información de la pesquería y el tipo de flota.
   * Filtra aquellos que tienen cantidad nula o cero.
   */
  async getRequerimientosPorAnio(anio: number) {
    return this.prisma.requerimientoCobertura.findMany({
      where: {
        anioOperativo: anio,
        cantidad: {
          gt: 0,
        },
      },
      include: {
        pesqueria: {
          select: { id: true, nombre: true },
        },
        tipoFlota: {
          select: { id: true, nombre: true },
        },
      },
    });
  }

  /**
   * Recibe un lote (batch) de requerimientos para un año específico.
   * Elimina todos los requerimientos previos de ese año y luego inserta los nuevos.
   * Aquellos con cantidad nula o cero no se persistirán para mantener limpia la DB.
   */
  async upsertRequerimientosBatch(dto: BatchUpsertRequerimientosDto) {
    const { anioOperativo, requerimientos } = dto;

    this.logger.log(`Iniciando batch upsert de requerimientos para el anio: ${anioOperativo}`);

    // Filtramos los que tienen valores válidos (>0 o definidos)
    // Aquellos con null, undefined o 0 simplemente no se persisten.
    const requerimientosActivos = requerimientos.filter(req => req.cantidad && req.cantidad > 0);

    return this.prisma.$transaction(async (prisma) => {
      // 1. Limpiamos todo el año completo
      await prisma.requerimientoCobertura.deleteMany({
        where: { anioOperativo },
      });

      // 2. Si no hay nada que agregar, retornamos 0
      if (requerimientosActivos.length === 0) {
        return { count: 0 };
      }

      // 3. Insertamos masivamente los requerimientos activos
      const result = await prisma.requerimientoCobertura.createMany({
        data: requerimientosActivos.map((req) => ({
          anioOperativo: req.anioOperativo,
          mes: req.mes,
          cantidad: req.cantidad,
          pesqueriaId: req.pesqueriaId,
          tipoFlotaId: req.tipoFlotaId,
        })),
        skipDuplicates: true,
      });

      this.logger.log(`Upsert completado. Insertados: ${result.count}`);
      return result;
    });
  }
}
