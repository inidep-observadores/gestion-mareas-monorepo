import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BatchUpsertRequerimientosDto } from './dto/requerimientos.dto';
import { BatchUpsertExperienciaDto } from './dto/experiencia.dto';

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

  /**
   * Obtiene todas las relaciones de experiencia configuradas entre 
   * observadores y pesquerías.
   */
  async getExperienciaObservadores() {
    return this.prisma.experienciaObservador.findMany({
      include: {
        observador: {
          select: { id: true, nombre: true, apellido: true }
        },
        pesqueria: {
          select: { id: true, nombre: true }
        }
      }
    });
  }

  /**
   * Actualiza el lote de experiencias. De ser necesario crear, actualizar o borrar
   */
  async upsertExperienciaObservadoresBatch(dto: BatchUpsertExperienciaDto) {
    const { experiencias } = dto;
    this.logger.log(`Iniciando actualización masiva de experiencia. Total items: ${experiencias.length}`);

    return this.prisma.$transaction(async (prisma) => {
      // Para simplificar la operación bulk sin upsert condicional uno por uno:
      // Eliminamos todas las experiencias actuales para los pares que se nos envíen (o podríamos simplemente limpiar todo)
      // Pero como la matriz envía TODO cada vez que guardan, limpiaremos y reinsertaremos la experiencia solo si el valor > 0.
      
      // Asumiendo que el Frontend manda toda la matriz de lo que ha sido modificado,
      // Una aproximación limpia: Vaciar toda la tabla e insertar lo nuevo (es pequeña matriz de configuración).
      // Sin embargo, si queremos preservar fechas, haríamos iteración.
      // Daremos preferencia a hacer upsert uno por uno con iteración rápida, ya que TypeORM y Prisma manejan transacciones eficientes.
      
      let upsertedCount = 0;
      let deletedCount = 0;

      for (const e of experiencias) {
        if (e.valor === null || e.valor === undefined) {
          // Si el valor viene nulo desde la vista, quiere decir que se limpia
          try {
             await prisma.experienciaObservador.delete({
               where: {
                 observadorId_pesqueriaId: {
                   observadorId: e.observadorId,
                   pesqueriaId: e.pesqueriaId
                 }
               }
             });
             deletedCount++;
          } catch(err) {
            // Ignorar el error si no existe el registro al intentar borrar
          }
        } else {
           // Insertamos / Actualizamos la experiencia (0 a 5)
           await prisma.experienciaObservador.upsert({
             where: {
               observadorId_pesqueriaId: {
                 observadorId: e.observadorId,
                 pesqueriaId: e.pesqueriaId
               }
             },
             update: {
               valor: e.valor
             },
             create: {
               observadorId: e.observadorId,
               pesqueriaId: e.pesqueriaId,
               valor: e.valor
             }
           });
           upsertedCount++;
        }
      }

      this.logger.log(`Actualización de experiencia completada. Modificados: ${upsertedCount}, Eliminados: ${deletedCount}`);
      return { count: upsertedCount };
    });
  }
}
