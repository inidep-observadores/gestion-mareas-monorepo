import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import * as ExcelJS from 'exceljs';
import { PrismaService } from '../prisma/prisma.service';
import { DateTime } from 'luxon';
import { MareaEstado } from '../mareas/mareas.constants';
import { evaluarEstadoDia } from '../utils/estado-observador.util';
import { BatchUpsertRequerimientosDto } from './dto/requerimientos.dto';
import { BatchUpsertExperienciaDto } from './dto/experiencia.dto';
import { CreateEscenarioDto, UpdateEscenarioDto, CloneEscenarioDto } from './dto/escenarios.dto';

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
        activo: true,
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

    // Construir índices raw por observador para que el motor de frontend
    // pueda procesarlos igual que ObservadorCalendar.vue (misma lógica).
    const novedadesRaw: Record<string, any[]> = {};
    const mareasRaw: Record<string, any[]> = {};

    for (const obs of observadores) {
      // Novedades: incluir solo las aprobadas y activas del observador
      const obsNovedades = novedadesDb.filter(n => n.observadorId === obs.id);
      novedadesRaw[obs.id] = obsNovedades.map(n => ({
        id: n.id,
        fechaInicio: n.fechaInicio.toISOString(),
        fechaFin: n.fechaFin ? n.fechaFin.toISOString() : null,
        estadoAprobacion: n.estadoAprobacion,
        activo: n.activo,
        motivo: n.motivo,
        tipoNovedad: {
          id: n.tipoNovedad.id,
          codigo: n.tipoNovedad.codigo,
          descripcion: n.tipoNovedad.descripcion,
          afectaPresentismo: n.tipoNovedad.afectaPresentismo,
        },
        // Espejo de la forma que usa ObservadorCalendar para el filtrado
        observador: { id: obs.id },
      }));

      // Mareas: incluir las del observador (principal, secundario en etapas o planificado en metadata)
      const obsMareas = mareasDb.filter(m => {
        if (m.observadorPrincipalId === obs.id) return true;
        if (m.etapas.some(e => e.observadores.some((eo: any) => eo.observadorId === obs.id))) return true;
        const meta = (m as any).metadata as any;
        const planificados = meta?.observadoresSecundariosPlanificados || [];
        return Array.isArray(planificados) && planificados.some((p: any) => p.observadorId === obs.id);
      });
      mareasRaw[obs.id] = obsMareas.map(m => ({
        id: m.id,
        tipoMarea: (m as any).tipoMarea,
        nroMarea: (m as any).nroMarea,
        anioMarea: (m as any).anioMarea,
        diasEstimados: (m as any).diasEstimados,
        fechaInicioObservador: m.fechaInicioObservador ? m.fechaInicioObservador.toISOString() : null,
        fechaFinObservador: m.fechaFinObservador ? m.fechaFinObservador.toISOString() : null,
        fechaZarpadaEstimada: (m as any).fechaZarpadaEstimada ? (m as any).fechaZarpadaEstimada.toISOString() : null,
        inicioValidado: (m as any).inicioValidado ?? false,
        finValidado: (m as any).finValidado ?? false,
        metadata: (m as any).metadata,
        observadoresSecundariosPlanificados: ((m as any).metadata as any)?.observadoresSecundariosPlanificados || [],
        estadoActual: {
          codigo: m.estadoActual.codigo,
          nombre: (m.estadoActual as any).nombre,
        },
        buque: null,
        pesqueria: null,
        etapas: m.etapas.map((e: any) => ({
          id: e.id,
          nroEtapa: e.nroEtapa,
          fechaZarpada: e.fechaZarpada ? e.fechaZarpada.toISOString() : null,
          fechaArribo: e.fechaArribo ? e.fechaArribo.toISOString() : null,
          puertoZarpada: e.puertoZarpada,
          puertoArribo: e.puertoArribo,
          observadores: (e.observadores || []).map((eo: any) => ({
            observadorId: eo.observadorId,
            rol: eo.rol,
            esDesignado: eo.esDesignado
          })),
          pesqueria: null,
        })),
      }));
    }

    return {
      observadores,
      eventos,
      novedadesRaw,
      mareasRaw,
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

  // --- Escenarios de Simulación ---

  async getEscenariosPorAnio(anioOperativo: number) {
    return this.prisma.escenarioSimulacion.findMany({
      where: { anioOperativo },
      orderBy: { updatedAt: 'desc' },
      select: {
        id: true,
        nombre: true,
        descripcion: true,
        estado: true,
        anioOperativo: true,
        createdAt: true,
        updatedAt: true,
      }
    });
  }

  async getEscenario(id: string) {
    const escenario = await this.prisma.escenarioSimulacion.findUnique({
      where: { id },
    });
    if (!escenario) {
      throw new NotFoundException(`Escenario con ID ${id} no encontrado`);
    }
    return escenario;
  }

  async createEscenario(dto: CreateEscenarioDto) {
    return this.prisma.escenarioSimulacion.create({
      data: {
        nombre: dto.nombre,
        descripcion: dto.descripcion,
        anioOperativo: dto.anioOperativo,
        items: dto.items || [],
        estado: 'BORRADOR',
      },
    });
  }

  async updateEscenario(id: string, dto: UpdateEscenarioDto) {
    const data: any = {};
    if (dto.nombre !== undefined) data.nombre = dto.nombre;
    if (dto.descripcion !== undefined) data.descripcion = dto.descripcion;
    if (dto.estado !== undefined) data.estado = dto.estado;
    if (dto.items !== undefined) data.items = dto.items;

    try {
      return await this.prisma.escenarioSimulacion.update({
        where: { id },
        data,
      });
    } catch (error) {
      throw new NotFoundException(`Escenario con ID ${id} no encontrado`);
    }
  }

  async cloneEscenario(id: string, dto: CloneEscenarioDto) {
    const source = await this.getEscenario(id);
    return this.prisma.escenarioSimulacion.create({
      data: {
        nombre: dto.nombre,
        descripcion: dto.descripcion !== undefined ? dto.descripcion : source.descripcion,
        anioOperativo: source.anioOperativo,
        items: source.items,
        estado: 'BORRADOR',
      },
    });
  }

  async deleteEscenario(id: string) {
    try {
      return await this.prisma.escenarioSimulacion.delete({
        where: { id },
      });
    } catch (error) {
      throw new NotFoundException(`Escenario con ID ${id} no encontrado`);
    }
  }

  async exportarEscenarioExcel(id: string, dto: any): Promise<Buffer> {
    const escenario = await this.getEscenario(id);
    const fechaDesde = new Date(dto.fechaDesde);
    fechaDesde.setHours(0, 0, 0, 0);
    const fechaHasta = new Date(dto.fechaHasta);
    fechaHasta.setHours(23, 59, 59, 999);
    const soloPlanificadas = dto.soloPlanificadas ?? true;

    // 1. Obtener mareas simuladas
    const simuladasRaw = (escenario.items as any[]) || [];
    const simuladas = simuladasRaw.filter(sim => {
      const start = new Date(sim.fechaZarpada);
      const end = new Date(sim.fechaArribo);
      return start <= fechaHasta && end >= fechaDesde;
    });

    // 2. Obtener mareas reales del periodo
    const mareasReales = await this.prisma.marea.findMany({
      where: {
        activo: true,
        estadoActual: { codigo: { notIn: ['CANCELADA', 'DESESTIMADA'] } },
        OR: [
          { fechaInicioObservador: { lte: fechaHasta }, fechaFinObservador: { gte: fechaDesde } },
          { fechaInicioObservador: { lte: fechaHasta }, fechaFinObservador: null },
        ]
      },
      include: {
        estadoActual: true,
        buque: true,
        pesqueria: true,
        observadorPrincipal: true,
        etapas: {
          include: { observadores: { include: { observador: true } } }
        }
      }
    });

    const allObs = await this.prisma.observador.findMany({ select: { id: true, nombre: true, apellido: true } });
    const obsMap = new Map(allObs.map(o => [o.id, `${o.apellido}, ${o.nombre}`]));

    // Unificar filas
    const filas: any[] = [];

    // Agregar simuladas
    for (const sim of simuladas) {
      filas.push({
        buqueId: sim.buqueId,
        buqueNombre: sim.buqueNombre || 'Sin Buque',
        observadorId: sim.observadorId,
        observadorNombre: sim.observadorId ? obsMap.get(sim.observadorId) || 'Desconocido' : 'Sin Asignar',
        pesqueriaNombre: sim.pesqueriaNombre || '-',
        codigoMarea: '-', // Simuladas no tienen código
        inicio: new Date(sim.fechaZarpada),
        fin: new Date(sim.fechaArribo),
        tipo: 'Planificada',
        esSimulada: true
      });
    }

    // Agregar reales
    for (const m of mareasReales) {
      const inicio = m.fechaInicioObservador || new Date();
      let fin = m.fechaFinObservador;
      let esProyectada = false;

      // Calcular fecha de finalización estimada si no tiene fin o está en ejecución
      if ((!fin || m.estadoActual.codigo === 'EN_EJECUCION' || m.estadoActual.codigo === 'DESIGNADA') && m.fechaInicioObservador && m.diasEstimados) {
        const startDate = new Date(m.fechaInicioObservador);
        startDate.setHours(0, 0, 0, 0);
        fin = new Date(startDate.getTime() + (m.diasEstimados - 1) * 86400000);
        esProyectada = true;
      }
      
      fin = fin || new Date(); // Fallback
      
      const anioStr = m.anioMarea ? String(m.anioMarea).slice(-2) : '--';
      const nroStr = m.nroMarea ? String(m.nroMarea).padStart(3, '0') : '000';
      const mareaStr = `${m.tipoMarea || 'MC'}-${nroStr}-${anioStr}`;
      const tipoStr = `Real${esProyectada ? ' - Proyectada' : ''}`;
      
      const observadoresIds = new Set<string>();
      if (m.observadorPrincipalId) observadoresIds.add(m.observadorPrincipalId);
      for (const e of m.etapas) {
        for (const eo of e.observadores) observadoresIds.add(eo.observadorId);
      }

      for (const obsId of observadoresIds) {
        filas.push({
          buqueId: m.buqueId,
          buqueNombre: m.buque?.nombreBuque || 'Sin Buque',
          observadorId: obsId,
          observadorNombre: obsMap.get(obsId) || 'Desconocido',
          pesqueriaNombre: m.pesqueria?.nombre || '-',
          codigoMarea: mareaStr,
          inicio,
          fin,
          tipo: tipoStr,
          esSimulada: false
        });
      }
    }

    // Filtrar recursos según soloPlanificadas
    const buquesConSimuladas = new Set(simuladas.filter(s => s.buqueId).map(s => s.buqueId));
    const obsConSimuladas = new Set(simuladas.filter(s => s.observadorId).map(s => s.observadorId));

    // Generar Excel
    const wb = new ExcelJS.Workbook();
    
    // Hoja 1: Por Buque
    const wsBuque = wb.addWorksheet('Por Buque');
    wsBuque.columns = [
      { header: 'Buque', key: 'buque', width: 25 },
      { header: 'Observador', key: 'observador', width: 25 },
      { header: 'Pesquería', key: 'pesqueria', width: 20 },
      { header: 'Marea', key: 'marea', width: 15 },
      { header: 'Inicio', key: 'inicio', width: 15 },
      { header: 'Fin', key: 'fin', width: 15 },
      { header: 'Tipo', key: 'tipo', width: 35 }
    ];
    wsBuque.getRow(1).font = { bold: true };

    const filasPorBuque = [...filas].sort((a, b) => a.buqueNombre.localeCompare(b.buqueNombre) || a.inicio.getTime() - b.inicio.getTime());
    for (const f of filasPorBuque) {
      if (soloPlanificadas && f.buqueId && !buquesConSimuladas.has(f.buqueId)) continue;
      
      const row = wsBuque.addRow({
        buque: f.buqueNombre,
        observador: f.observadorNombre,
        pesqueria: f.pesqueriaNombre,
        marea: f.codigoMarea,
        inicio: f.inicio.toLocaleDateString('es-AR'),
        fin: f.fin.toLocaleDateString('es-AR'),
        tipo: f.tipo
      });
      if (f.esSimulada) {
        row.eachCell(c => c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFD9EAD3' } });
      }
    }

    // Hoja 2: Por Observador
    const wsObs = wb.addWorksheet('Por Observador');
    wsObs.columns = [
      { header: 'Observador', key: 'observador', width: 25 },
      { header: 'Buque', key: 'buque', width: 25 },
      { header: 'Pesquería', key: 'pesqueria', width: 20 },
      { header: 'Marea', key: 'marea', width: 15 },
      { header: 'Inicio', key: 'inicio', width: 15 },
      { header: 'Fin', key: 'fin', width: 15 },
      { header: 'Tipo', key: 'tipo', width: 35 }
    ];
    wsObs.getRow(1).font = { bold: true };

    const filasPorObs = [...filas].sort((a, b) => a.observadorNombre.localeCompare(b.observadorNombre) || a.inicio.getTime() - b.inicio.getTime());
    for (const f of filasPorObs) {
      if (soloPlanificadas && f.observadorId && !obsConSimuladas.has(f.observadorId)) continue;
      
      const row = wsObs.addRow({
        observador: f.observadorNombre,
        buque: f.buqueNombre,
        pesqueria: f.pesqueriaNombre,
        marea: f.codigoMarea,
        inicio: f.inicio.toLocaleDateString('es-AR'),
        fin: f.fin.toLocaleDateString('es-AR'),
        tipo: f.tipo
      });
      if (f.esSimulada) {
        row.eachCell(c => c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFD9EAD3' } });
      }
    }

    return (await wb.xlsx.writeBuffer()) as unknown as Buffer;
  }
}
