import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DateTime } from 'luxon';
import { MareaEstado } from '../mareas/mareas.constants';
import { evaluarEstadoDia } from '../utils/estado-observador.util';
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
        },
        tipoFlota: {
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
        if ((e.valor === null || e.valor === undefined) && (e.experiencia === null || e.experiencia === undefined)) {
          // Si ambos valores son nulos, eliminamos el registro para evitar basura
          try {
             await prisma.experienciaObservador.delete({
               where: {
                 observadorId_pesqueriaId_tipoFlotaId: {
                   observadorId: e.observadorId,
                   pesqueriaId: e.pesqueriaId,
                   tipoFlotaId: e.tipoFlotaId
                 }
               }
             });
             deletedCount++;
          } catch(err) {
            // Ignorar el error si no existe el registro al intentar borrar
          }
        } else {
           // Insertamos / Actualizamos la experiencia (0 a 5) y el entero de experiencias previas
           await prisma.experienciaObservador.upsert({
             where: {
               observadorId_pesqueriaId_tipoFlotaId: {
                 observadorId: e.observadorId,
                 pesqueriaId: e.pesqueriaId,
                 tipoFlotaId: e.tipoFlotaId
               }
             },
             update: {
               valor: e.valor,
               experiencia: e.experiencia
             },
             create: {
               observadorId: e.observadorId,
               pesqueriaId: e.pesqueriaId,
               tipoFlotaId: e.tipoFlotaId,
               valor: e.valor,
               experiencia: e.experiencia
             }
           });
           upsertedCount++;
        }
      }

      this.logger.log(`Actualización de experiencia completada. Modificados: ${upsertedCount}, Eliminados: ${deletedCount}`);
      return { count: upsertedCount };
    });
  }

  /**
   * Obtiene y evalúa los eventos (mareas, novedades, feriados) de los observadores
   * para representarlos en el Simulador de Cobertura (Timeline).
   * Genera bloques agrupados por estado continuo.
   */
  async obtenerEventosSimulador(year: number, month: number, horizonMonths: number = 6) {
    const startOfRange = DateTime.utc(year, month, 1);
    const endOfRange = startOfRange.plus({ months: horizonMonths }).minus({ seconds: 1 });

    const observadores = await this.prisma.observador.findMany({
      where: { activo: true },
      select: { id: true, nombre: true, apellido: true, codigoInterno: true },
      orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
    });

    const feriadosDb = await this.prisma.feriado.findMany({
      where: {
        fecha: {
          gte: startOfRange.toJSDate(),
          lte: endOfRange.toJSDate(),
        },
      },
    });
    const feriados: Record<string, string> = {};
    feriadosDb.forEach(f => {
      const fd = DateTime.fromJSDate(f.fecha, { zone: 'utc' });
      feriados[`${fd.year}-${fd.month}-${fd.day}`] = f.nombre;
    });

    const novedadesDb = await this.prisma.observadorNovedad.findMany({
      where: {
        estadoAprobacion: 'APROBADA',
        fechaInicio: { lte: endOfRange.toJSDate() },
        OR: [
          { fechaFin: { gte: startOfRange.toJSDate() } },
          { fechaFin: null },
        ],
      },
      include: { tipoNovedad: true }
    });

    const mareasDb = await this.prisma.marea.findMany({
      where: {
        activo: true,
        estadoActual: { codigo: { not: MareaEstado.CANCELADA } },
        OR: [
          { fechaInicioObservador: { lte: endOfRange.toJSDate() }, fechaFinObservador: { gte: startOfRange.toJSDate() } },
          { fechaInicioObservador: { lte: endOfRange.toJSDate() }, fechaFinObservador: null },
          {
            etapas: {
              some: {
                fechaZarpada: { lte: endOfRange.toJSDate() },
                OR: [
                  { fechaArribo: { gte: startOfRange.toJSDate() } },
                  { fechaArribo: null }
                ]
              }
            }
          }
        ]
      },
      include: {
        estadoActual: true,
        etapas: {
          orderBy: { nroEtapa: 'asc' },
          include: { puertoArribo: true, puertoZarpada: true, observadores: true }
        },
        observadorPrincipal: true
      }
    });

    const eventos: any[] = [];
    const diasTotal = endOfRange.diff(startOfRange, 'days').days + 1;

    for (const obs of observadores) {
      const obsNovedades = novedadesDb.filter(n => n.observadorId === obs.id);
      const obsMareas = mareasDb.filter(m => 
        m.observadorPrincipalId === obs.id || 
        m.etapas.some(e => e.observadores.some(eo => eo.observadorId === obs.id))
      );

      // Preprocesar proyección para planificacion (SRP: El dominio de planificación decide proyectar las mareas)
      const mareasAdaptadas = obsMareas.map(marea => {
        const m = { ...marea };
        if (m.estadoActual.codigo === MareaEstado.DESIGNADA || m.estadoActual.codigo === MareaEstado.EN_EJECUCION) {
          if (m.fechaInicioObservador && m.diasEstimados) {
             const inicioObs = DateTime.fromJSDate(m.fechaInicioObservador, { zone: 'utc' }).startOf('day');
             const finProyectado = inicioObs.plus({ days: m.diasEstimados - 1 }).endOf('day');
             
             // Inyectamos una pseudo-etapa que simula la navegación
             m.etapas = [
               {
                 id: `proyectada-${m.id}`,
                 fechaZarpada: inicioObs.toJSDate(),
                 fechaArribo: finProyectado.toJSDate(),
                 puertoZarpada: { id: 'dummy', esLocal: true },
                 puertoArribo: { id: 'dummy', esLocal: true },
               } as any
             ];
             m.inicioValidado = false;
             m.finValidado = false;
             m.fechaFinObservador = finProyectado.toJSDate(); 
          }
        }
        return m;
      });

      let currentState: string | null = null;
      let currentStartDate: Date | null = null;
      let currentData: any = null;

      for (let i = 0; i < Math.floor(diasTotal); i++) {
        const currentDate = startOfRange.plus({ days: i }).startOf('day');
        const feriadoNombre = feriados[`${currentDate.year}-${currentDate.month}-${currentDate.day}`] || null;
        const isFinSemana = currentDate.weekday === 6 || currentDate.weekday === 7;

        const estadoDto = evaluarEstadoDia(
          currentDate,
          mareasAdaptadas,
          obsNovedades,
          feriadoNombre,
          isFinSemana
        );

        if (!estadoDto || estadoDto.estado === 'LIBRE' || estadoDto.estado === 'FIN_SEMANA' || estadoDto.estado === 'FERIADO') {
          if (currentState && currentStartDate !== null && currentData) {
            eventos.push(this.crearEventoTimeline(obs.id, currentState, currentStartDate, startOfRange.plus({ days: i - 1 }).toJSDate(), currentData));
            currentState = null;
          }
          continue;
        }

        const signature = `${estadoDto.estado}-${estadoDto.codigoCorto || ''}-${estadoDto.referenciaId || ''}`;
        if (currentState !== signature) {
          if (currentState && currentStartDate !== null && currentData) {
             eventos.push(this.crearEventoTimeline(obs.id, currentState, currentStartDate, startOfRange.plus({ days: i - 1 }).toJSDate(), currentData));
          }
          currentState = signature;
          currentStartDate = currentDate.toJSDate();
          currentData = estadoDto;
          
          // Agregamos metadata extra para el timeline de simulación
          const originalMarea = obsMareas.find(m => m.id === estadoDto.referenciaId || m.etapas.some((e: any) => e.id === estadoDto.referenciaId) || (estadoDto.referenciaId?.startsWith('proyectada-') && estadoDto.referenciaId === `proyectada-${m.id}`));
          if (originalMarea) {
             currentData.mareaEstado = originalMarea.estadoActual.codigo;
             if (originalMarea.estadoActual.codigo === MareaEstado.DESIGNADA || originalMarea.estadoActual.codigo === MareaEstado.EN_EJECUCION) {
                currentData.isProyectada = true;
             }
          }
        }
      }

      if (currentState && currentStartDate !== null && currentData) {
        eventos.push(this.crearEventoTimeline(obs.id, currentState, currentStartDate, startOfRange.plus({ days: Math.floor(diasTotal) - 1 }).toJSDate(), currentData));
      }
    }

    return {
      observadores: observadores,
      eventos
    };
  }

  private crearEventoTimeline(obsId: string, signature: string, startDate: Date, endDate: Date, estadoDto: any) {
    return {
      id: `real-${obsId}-${startDate.getTime()}`,
      observadorId: obsId,
      startDate: startDate,
      endDate: endDate,
      estado: estadoDto.estado,
      detalle: estadoDto.detalle,
      codigoCorto: estadoDto.codigoCorto,
      isProyectada: estadoDto.isProyectada || false,
      mareaEstado: estadoDto.mareaEstado,
    };
  }
}
