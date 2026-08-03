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

  async getExperienciaObservadores() {
    // 1. Obtener registros históricos
    const historico = await this.prisma.experienciaObservador.findMany({
      include: {
        observador: {
          select: { id: true, nombre: true, apellido: true }
        },
        pesqueria: {
          select: { id: true, nombre: true }
        }
      }
    });

    // 2. Obtener mareas "vivas" (finalizadas desde 2026-01-01)
    const fechaCorte = new Date('2026-01-01T00:00:00Z');
    
    // Obtenemos todas las mareas relevantes
    const mareasVivas = await this.prisma.marea.findMany({
      where: {
        fechaInicioObservador: { gte: fechaCorte },
        estadoActual: {
          codigo: {
            notIn: [
              MareaEstado.DESIGNADA,
              MareaEstado.A_REASIGNAR,
              MareaEstado.EN_EJECUCION,
              MareaEstado.CANCELADA,
              MareaEstado.DESESTIMADA,
            ]
          }
        }
      },
      select: {
        id: true,
        pesqueriaId: true,
        observadorPrincipalId: true,
        etapas: {
          select: {
            observadores: { select: { observadorId: true } }
          }
        }
      }
    });

    // Agrupar mareas vivas
    const agrupadoVivas: Record<string, number> = {};
    for (const marea of mareasVivas) {
      if (!marea.pesqueriaId) continue;
      
      const pesqueriaId = marea.pesqueriaId;
      
      const observadoresIds = new Set<string>();
      if (marea.observadorPrincipalId) {
        observadoresIds.add(marea.observadorPrincipalId);
      }
      for (const etapa of marea.etapas) {
        for (const obs of etapa.observadores) {
          observadoresIds.add(obs.observadorId);
        }
      }
      
      for (const obsId of observadoresIds) {
        const key = `${obsId}_${pesqueriaId}`;
        agrupadoVivas[key] = (agrupadoVivas[key] || 0) + 1;
      }
    }

    // 3. Fusionar datos
    const mapaResultado = new Map<string, any>();

    for (const h of historico) {
      const key = `${h.observadorId}_${h.pesqueriaId}`;
      const mareasVivasCount = agrupadoVivas[key] || 0;
      mapaResultado.set(key, {
        ...h,
        experienciaHistorica: h.experiencia || 0,
        mareasVivas: mareasVivasCount,
        experienciaTotal: (h.experiencia || 0) + mareasVivasCount,
      });
      delete agrupadoVivas[key]; // Ya lo procesamos
    }

    // Si quedaron mareas vivas para combinaciones que no tienen histórico
    if (Object.keys(agrupadoVivas).length > 0) {
      const missingObsIds = [...new Set(Object.keys(agrupadoVivas).map(k => k.split('_')[0]))];
      const missingPesqIds = [...new Set(Object.keys(agrupadoVivas).map(k => k.split('_')[1]))];
      
      const [obsList, pesqList] = await Promise.all([
        this.prisma.observador.findMany({ where: { id: { in: missingObsIds } }, select: { id: true, nombre: true, apellido: true } }),
        this.prisma.pesqueria.findMany({ where: { id: { in: missingPesqIds } }, select: { id: true, nombre: true } })
      ]);
      
      for (const key in agrupadoVivas) {
        const [obsId, pesqId] = key.split('_');
        const count = agrupadoVivas[key];
        
        mapaResultado.set(key, {
          id: `virtual_${key}`,
          observadorId: obsId,
          pesqueriaId: pesqId,
          valor: null,
          experiencia: 0,
          experienciaHistorica: 0,
          mareasVivas: count,
          experienciaTotal: count,
          fechaActualizacion: new Date(),
          observador: obsList.find(o => o.id === obsId),
          pesqueria: pesqList.find(p => p.id === pesqId)
        });
      }
    }

    return Array.from(mapaResultado.values());
  }

  /**
   * Devuelve la experiencia y valoración de TODOS los observadores activos
   * para una pesquería determinada.
   */
  async getExperienciaPorPesqueria(pesqueriaId: string) {
    // 1. Obtener todos los observadores activos
    const observadoresActivos = await this.prisma.observador.findMany({
      where: { activo: true },
      select: { id: true, nombre: true, apellido: true }
    });

    // 2. Obtener histórico para esta pesquería
    const historico = await this.prisma.experienciaObservador.findMany({
      where: { pesqueriaId },
      select: { observadorId: true, experiencia: true, valor: true }
    });
    const mapaHistorico = new Map(historico.map(h => [h.observadorId, h]));

    // 3. Obtener mareas "vivas" para esta pesquería
    const fechaCorte = new Date('2026-01-01T00:00:00Z');
    const mareasVivas = await this.prisma.marea.findMany({
      where: {
        pesqueriaId,
        fechaInicioObservador: { gte: fechaCorte },
        estadoActual: {
          codigo: {
            notIn: [
              MareaEstado.DESIGNADA,
              MareaEstado.A_REASIGNAR,
              MareaEstado.EN_EJECUCION,
              MareaEstado.CANCELADA,
              MareaEstado.DESESTIMADA,
            ]
          }
        }
      },
      select: {
        observadorPrincipalId: true,
        etapas: {
          select: {
            observadores: { select: { observadorId: true } }
          }
        }
      }
    });

    // Agrupar mareas vivas por observador
    const vivasPorObservador: Record<string, number> = {};
    for (const marea of mareasVivas) {
      const observadoresIds = new Set<string>();
      if (marea.observadorPrincipalId) observadoresIds.add(marea.observadorPrincipalId);
      for (const etapa of marea.etapas) {
        for (const obs of etapa.observadores) observadoresIds.add(obs.observadorId);
      }
      for (const obsId of observadoresIds) {
        vivasPorObservador[obsId] = (vivasPorObservador[obsId] || 0) + 1;
      }
    }

    // 4. Consolidar resultados para todos los observadores activos
    return observadoresActivos.map(obs => {
      const h = mapaHistorico.get(obs.id);
      const vivas = vivasPorObservador[obs.id] || 0;
      const hist = h?.experiencia || 0;
      
      return {
        observadorId: obs.id,
        observadorNombre: `${obs.nombre} ${obs.apellido}`,
        pesqueriaId,
        valor: h?.valor ?? null,
        experienciaHistorica: hist,
        mareasVivas: vivas,
        experienciaTotal: hist + vivas
      };
    });
  }

  /**
   * Actualiza el lote de experiencias. De ser necesario crear, actualizar o borrar
   */
  async upsertExperienciaObservadoresBatch(dto: BatchUpsertExperienciaDto) {
    const { experiencias } = dto;
    this.logger.log(`Iniciando actualización masiva de experiencia. Total items: ${experiencias.length}`);

    return this.prisma.$transaction(async (prisma) => {
      let upsertedCount = 0;
      let deletedCount = 0;

      for (const e of experiencias) {
        if (e.valor === null || e.valor === undefined) {
           // Limpiar valoración sin borrar de inmediato para preservar histórico
           await prisma.experienciaObservador.updateMany({
             where: {
               observadorId: e.observadorId,
               pesqueriaId: e.pesqueriaId
             },
             data: { valor: null }
           });
        } else {
           // Insertamos / Actualizamos la valoración (0 a 5)
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
               valor: e.valor,
               experiencia: 0 // Iniciar histórico en 0 para nuevas asignaciones
             }
           });
           upsertedCount++;
        }
      }

      // Cleanup: Eliminar registros sin valor Y sin historia
      const deleteResult = await prisma.experienciaObservador.deleteMany({
        where: {
          valor: null,
          OR: [
            { experiencia: null },
            { experiencia: 0 }
          ]
        }
      });
      deletedCount = deleteResult.count;

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
    const startOfRange = DateTime.fromObject(
      { year, month, day: 1 },
      { zone: process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires' }
    );
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
          isFinSemana,
          true // Planificación: incluir novedades que no afectan presentismo (ej: licencias)
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

  /**
   * Obtiene el detalle de las mareas de un observador en una pesquería y tipo de flota específicos.
   * Se incluyen todas las mareas históricas y "vivas" excluyendo estados iniciales/cancelados.
   */
  async getDetalleMareasExperiencia(observadorId: string, pesqueriaId: string) {
    const mareas = await this.prisma.marea.findMany({
      where: {
        pesqueriaId,
        estadoActual: {
          codigo: {
            notIn: [
              MareaEstado.DESIGNADA,
              MareaEstado.A_REASIGNAR,
              MareaEstado.EN_EJECUCION,
              MareaEstado.CANCELADA,
              MareaEstado.DESESTIMADA,
            ]
          }
        },
        OR: [
          { observadorPrincipalId: observadorId },
          { etapas: { some: { observadores: { some: { observadorId } } } } }
        ]
      },
      include: {
        estadoActual: true,
        buque: { include: { tipoFlota: true } },
        pesqueria: true,
        observadorPrincipal: true,
        etapas: {
          include: {
            observadores: { include: { observador: true } }
          }
        }
      },
      orderBy: {
        fechaInicioObservador: 'desc'
      }
    });

    return mareas.map(m => {
      // Determinar el observador que corresponde a esta fila (el consultado)
      let nombreObservador = '';
      if (m.observadorPrincipalId === observadorId) {
        nombreObservador = `${m.observadorPrincipal?.nombre} ${m.observadorPrincipal?.apellido}`;
      } else {
        // Buscarlo en las etapas
        for (const etapa of m.etapas) {
          const obsApoyo = etapa.observadores.find(o => o.observadorId === observadorId);
          if (obsApoyo) {
            nombreObservador = `${obsApoyo.observador.nombre} ${obsApoyo.observador.apellido}`;
            break;
          }
        }
      }

      const endDate = m.fechaFinObservador || new Date();
      let diasTotales = 0;
      if (m.fechaInicioObservador) {
        diasTotales = Math.max(1, Math.ceil((endDate.getTime() - m.fechaInicioObservador.getTime()) / (1000 * 3600 * 24)));
      }

      let fechaZarpada: Date | null = null;
      let fechaArribo: Date | null = null;

      if (m.etapas && m.etapas.length > 0) {
        const zarpadas = m.etapas.map((e: any) => e.fechaZarpada).filter((d: any) => d != null).sort((a: any, b: any) => a.getTime() - b.getTime());
        if (zarpadas.length > 0) fechaZarpada = zarpadas[0];

        const arribos = m.etapas.map((e: any) => e.fechaArribo).filter((d: any) => d != null).sort((a: any, b: any) => b.getTime() - a.getTime());
        if (arribos.length > 0) fechaArribo = arribos[0];
      }

      return {
        id: m.id,
        id_marea: `${m.tipoMarea}-${m.nroMarea}-${String(m.anioMarea).slice(-2)}`,
        buque: m.buque?.nombreBuque,
        flota: m.buque?.tipoFlota?.nombre,
        pesqueria: m.pesqueria?.nombre,
        observador: nombreObservador,
        fechaZarpada,
        fechaArribo,
        diasTotales,
        tipoMarea: m.tipoMarea
      };
    });
  }
}
