import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DateTime } from 'luxon';
import { DateUtils } from '../common/utils/date.utils';
import { MareaEstado } from '../mareas/mareas.constants';
import { evaluarEstadoDia } from '../utils/estado-observador.util';
import {
  DisponibilidadResponseDto,
  ObservadorDisponibilidadRowDto,
  ObservadorDisponibilidadItemDto,
} from './dto/disponibilidad-response.dto';

@Injectable()
export class DisponibilidadService {
  constructor(private readonly prisma: PrismaService) {}

  async obtenerDisponibilidad(mesesHorizonte: number = 1): Promise<DisponibilidadResponseDto> {
    const horizon = Math.min(Math.max(mesesHorizonte || 1, 1), 12);
    const timezone = DateUtils.getTimezone();
    
    // Fecha actual al inicio del día
    const today = DateTime.fromJSDate(DateUtils.getNow(), { zone: timezone }).startOf('day');
    // Para contexto referencial previo, abarcamos 1 mes hacia atrás
    const startDate = today.minus({ months: 1 }).startOf('day');
    // Horizonte futuro
    const endDate = today.plus({ months: horizon }).endOf('day');

    // 1. Obtener observadores activos, disponibles y sin impedimento
    const observadores = await this.prisma.observador.findMany({
      where: {
        activo: true,
        conImpedimento: false,
        disponible: true,
      },
      select: {
        id: true,
        nombre: true,
        apellido: true,
        codigoInterno: true,
        tipoObservador: true,
        tipoContrato: true,
        conImpedimento: true,
        motivoImpedimento: true,
        disponible: true,
      },
      orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
    });

    // 2. Traer novedades aprobadas y activas que se solapen con el período
    const novedadesDb = await this.prisma.observadorNovedad.findMany({
      where: {
        activo: true,
        estadoAprobacion: 'APROBADA',
        fechaInicio: { lte: endDate.toJSDate() },
        OR: [
          { fechaFin: { gte: startDate.toJSDate() } },
          { fechaFin: null },
        ],
      },
      include: {
        tipoNovedad: true,
      },
    });

    // 3. Traer mareas que se solapen con el período (excluyendo canceladas y a reasignar)
    const mareasDb = await this.prisma.marea.findMany({
      where: {
        activo: true,
        estadoActual: { codigo: { notIn: [MareaEstado.CANCELADA, 'A_REASIGNAR'] } },
        OR: [
          { fechaInicioObservador: { lte: endDate.toJSDate() }, fechaFinObservador: { gte: startDate.toJSDate() } },
          { fechaInicioObservador: { lte: endDate.toJSDate() }, fechaFinObservador: null },
          { fechaZarpadaEstimada: { lte: endDate.toJSDate() }, fechaFinObservador: null },
          { estadoActual: { codigo: 'DESIGNADA' } },
          {
            etapas: {
              some: {
                fechaZarpada: { lte: endDate.toJSDate() },
                OR: [
                  { fechaArribo: { gte: startDate.toJSDate() } },
                  { fechaArribo: null },
                ],
              },
            },
          },
          {
            fechaFinObservador: { gte: startDate.toJSDate() },
            etapas: {
              some: {
                fechaZarpada: { lte: endDate.toJSDate() },
              },
            },
          },
        ],
      },
      include: {
        buque: { select: { nombreBuque: true } },
        pesqueria: { select: { nombre: true } },
        estadoActual: true,
        etapas: {
          orderBy: { nroEtapa: 'asc' },
          include: {
            puertoArribo: true,
            puertoZarpada: true,
            observadores: true,
          },
        },
        observadorPrincipal: true,
      },
    });

    const rows: ObservadorDisponibilidadRowDto[] = [];
    const totalDays = Math.ceil(endDate.diff(startDate, 'days').days) + 1;

    for (const obs of observadores) {
      // Filtrar novedades del observador
      const obsNovedades = novedadesDb.filter(n => n.observadorId === obs.id);

      // Mareas designadas del observador (previsto pero no confirmado)
      const mareasDesignadasObs = mareasDb
        .filter(m => {
          const isDesig = m.estadoActual?.codigo === 'DESIGNADA';
          if (!isDesig) return false;
          if (m.observadorPrincipalId === obs.id) return true;
          if (m.etapas?.some((e: any) => e.observadores?.some((eo: any) => eo.observadorId === obs.id))) return true;
          if ((m as any).metadata) {
            try {
              const meta = typeof (m as any).metadata === 'string' ? JSON.parse((m as any).metadata) : (m as any).metadata;
              const planificados = meta.observadoresSecundariosPlanificados || [];
              if (planificados.some((p: any) => p.observadorId === obs.id)) return true;
            } catch {}
          }
          return false;
        })
        .map(m => {
          const inicioDate = m.fechaZarpadaEstimada || m.fechaInicioObservador || m.etapas[0]?.fechaZarpada;
          if (!inicioDate) return null;
          const inicioRef = DateTime.fromJSDate(inicioDate, { zone: 'utc' }).startOf('day');
          const duracion = m.diasEstimados || 30;
          const finRef = inicioRef.plus({ days: Math.max(duracion - 1, 0) }).endOf('day');
          const isSecundario = m.observadorPrincipalId !== obs.id;
          return {
            ...m,
            inicioDesignada: inicioRef,
            finDesignada: finRef,
            isSecundario,
          };
        })
        .filter(Boolean);

      // Mareas en ejecución/reales del observador adaptadas con límite a fecha estimada de arribo
      const obsMareas = mareasDb
        .filter(m => {
          const isDesig = m.estadoActual?.codigo === 'DESIGNADA';
          if (isDesig) return false;
          return (
            m.observadorPrincipalId === obs.id ||
            m.etapas.some(e => e.observadores.some((eo: any) => eo.observadorId === obs.id))
          );
        })
        .map(marea => {
          const isSecundario = marea.observadorPrincipalId !== obs.id;
          const etapasFiltradas = isSecundario
            ? marea.etapas.filter((e: any) => e.observadores.some((eo: any) => eo.observadorId === obs.id))
            : marea.etapas;

          // Calcular fecha de inicio de referencia para la marea (fechaInicioObservador o zarpada estimada o zarpada primera etapa)
          const primeraEtapaZarpada = etapasFiltradas[0]?.fechaZarpada;
          const inicioMareaDate = marea.fechaInicioObservador || marea.fechaZarpadaEstimada || primeraEtapaZarpada;
          let limiteFinEstimado: DateTime | null = null;

          // Adaptar etapas: si no tienen fechaArribo real, limitar a la fecha estimada de arribo (inicio + diasEstimados - 1)
          const etapasAdaptadas = etapasFiltradas.map((etapa: any) => {
            const e = { ...etapa };
            if (!e.fechaArribo && (e.fechaZarpada || inicioMareaDate)) {
              const inicioRef = DateTime.fromJSDate(e.fechaZarpada || inicioMareaDate, { zone: 'utc' }).startOf('day');
              const duracion = marea.diasEstimados || 30;
              const finEstimado = inicioRef.plus({ days: Math.max(duracion - 1, 0) }).endOf('day');
              e.fechaArribo = finEstimado.toJSDate();
              limiteFinEstimado = finEstimado;
            }
            return e;
          });

          // Si fechaFinObservador no existe pero hay límite estimado, proyectar fechaFinObservador
          let fechaFinObs = marea.fechaFinObservador;
          if (!fechaFinObs && limiteFinEstimado) {
            fechaFinObs = (limiteFinEstimado as DateTime).toJSDate();
          }

          const m = {
            ...marea,
            isSecundario,
            etapas: etapasAdaptadas,
            fechaFinObservador: fechaFinObs,
            limiteFinEstimado,
          };

          return m;
        });

      // Mapear cada día evaluado
      const dailyStates: Array<{
        date: DateTime;
        estado: 'DISPONIBLE' | 'NAVEGANDO' | 'PUERTO' | 'NOVEDAD' | 'VIAJE' | 'ESPERANDO_ZARPADA' | 'CONFLICTO' | 'IMPEDIMENTO' | 'DESIGNADA';
        estadoSecundario?: string;
        detalle?: string;
        codigoCorto?: string;
        flexible?: boolean;
        isPast: boolean;
      }> = [];

      for (let i = 0; i < totalDays; i++) {
        const currentDate = startDate.plus({ days: i }).startOf('day');
        if (currentDate > endDate) break;

        const isPast = currentDate < today;
        const isFinSemana = currentDate.weekday === 6 || currentDate.weekday === 7;

        // Si es a futuro y el observador tiene impedimento o no está disponible
        if (!isPast && (obs.conImpedimento || !obs.disponible)) {
          const motivo = obs.conImpedimento
            ? (obs.motivoImpedimento || 'Observador con impedimento')
            : 'Observador marcado como no disponible';

          dailyStates.push({
            date: currentDate,
            estado: 'IMPEDIMENTO',
            detalle: motivo,
            codigoCorto: 'IMPEDIMENTO',
            flexible: false,
            isPast: false,
          });
          continue;
        }

        // Filtrar mareas que aplican a este día: si la marea fue limitada por fecha estimada de arribo y currentDate > limiteFinEstimado, ya no aplica
        const obsMareasDelDia = obsMareas.filter((m: any) => {
          if (m.limiteFinEstimado && currentDate > m.limiteFinEstimado) {
            return false;
          }
          return true;
        });

        // Evaluar estado del día (en disponibilidad no evaluamos feriados para cortar disponibilidad)
        const estadoEvaluado = evaluarEstadoDia(
          currentDate,
          obsMareasDelDia,
          obsNovedades,
          null, // Sin feriados
          isFinSemana,
          true  // Incluir todas las novedades
        );

        // Novedades activas del día para comprobar flexibilidad y tipo
        const novedadesDelDia = obsNovedades.filter(n => {
          const ini = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          const fin = n.fechaFin
            ? DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day')
            : DateTime.now().endOf('year').plus({ years: 10 });
          return currentDate >= ini && currentDate <= fin;
        });

        // 1. Detectar si el evento del día es un aviso de DISPONIBLE
        const tieneNovedadDisponible = novedadesDelDia.some(n => n.tipoNovedad?.codigo === 'DISPONIBLE');

        // 2. Detectar si para esta fecha (o posterior) existe un aviso de DISPONIBLE que deba bloquear los días previos
        const proximoAvisoDisponible = obsNovedades.find(n => {
          if (n.tipoNovedad?.codigo !== 'DISPONIBLE') return false;
          const fechaDisp = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          return currentDate < fechaDisp;
        });

        // 3. Detectar si para esta fecha existe una marea designada para el observador
        const mareaDesignada = mareasDesignadasObs.find(m => {
          return currentDate >= m!.inicioDesignada && currentDate <= m!.finDesignada;
        });

        // Determinar si es flexible
        let isFlexible = false;
        if (estadoEvaluado.estado === 'NOVEDAD') {
          isFlexible = novedadesDelDia.some(
            n => n.tipoNovedad?.codigo === 'FC' || n.permiteUrgencia === true
          );
        }

        // Si el estado es LIBRE o FIN_SEMANA, o si es la novedad DISPONIBLE propiamente dicha (no la pintamos como bloque positivo)
        if (estadoEvaluado.estado === 'LIBRE' || estadoEvaluado.estado === 'FIN_SEMANA' || tieneNovedadDisponible) {
          if (mareaDesignada) {
            // Marea en estado DESIGNADA: bloque previsto de color verde atenuado con borde punteado
            const buque = mareaDesignada.buque?.nombreBuque || 'Buque sin asignar';
            const pesqueria = mareaDesignada.pesqueria?.nombre ? ` - ${mareaDesignada.pesqueria.nombre}` : '';
            const duracion = `${mareaDesignada.diasEstimados || 30} días est.`;
            const rol = mareaDesignada.isSecundario ? ' (Secundario)' : '';
            const anioStr = mareaDesignada.anioMarea ? String(mareaDesignada.anioMarea).slice(-2) : '00';
            const codigoMarea = `${mareaDesignada.tipoMarea || 'MC'}-${mareaDesignada.nroMarea || 0}-${anioStr}`;

            dailyStates.push({
              date: currentDate,
              estado: 'DESIGNADA',
              detalle: `Marea ${codigoMarea}${rol} · ${buque}${pesqueria} (${duracion})`,
              codigoCorto: 'DESIGNADA',
              flexible: false,
              isPast,
            });
          } else if (isPast) {
            // Pasado libre: se deja como vacío/hueco
            continue;
          } else if (proximoAvisoDisponible) {
            // Hay un aviso de disponibilidad futuro: los días libres previos se consideran y pintan como "No disponible"
            const fechaDispStr = DateTime.fromJSDate(proximoAvisoDisponible.fechaInicio, { zone: 'utc' }).toFormat('dd/MM/yyyy');
            dailyStates.push({
              date: currentDate,
              estado: 'NOVEDAD',
              detalle: `Disponible a partir del ${fechaDispStr} (aviso registrado)`,
              codigoCorto: 'NO DISPONIBLE',
              flexible: false,
              isPast: false,
            });
          } else {
            // Futuro libre sin aviso que lo preceda: ¡DISPONIBLE PARA EMBARQUE! (Bloque amarillo)
            dailyStates.push({
              date: currentDate,
              estado: 'DISPONIBLE',
              detalle: 'Disponible para embarque',
              codigoCorto: 'DISPONIBLE',
              flexible: false,
              isPast: false,
            });
          }
        } else {
          // Es un evento activo (Navegando, Puerto, Novedad, Viaje, Conflicto, Esperando Zarpada)
          dailyStates.push({
            date: currentDate,
            estado: estadoEvaluado.estado as any,
            estadoSecundario: estadoEvaluado.estadoSecundario,
            detalle: estadoEvaluado.detalle || estadoEvaluado.conflictoDetalle,
            codigoCorto: estadoEvaluado.codigoCorto,
            flexible: isFlexible,
            isPast,
          });
        }
      }

      // Agrupar días contiguos en bloques para optimizar Vis-Timeline
      const eventos: ObservadorDisponibilidadItemDto[] = [];
      let currentBlock: {
        startDate: DateTime;
        endDate: DateTime;
        estado: any;
        estadoSecundario?: string;
        detalle?: string;
        codigoCorto?: string;
        flexible?: boolean;
        isPast: boolean;
      } | null = null;

      for (let i = 0; i < dailyStates.length; i++) {
        const item = dailyStates[i];
        const signature = `${item.estado}-${item.codigoCorto || ''}-${item.flexible ? '1' : '0'}-${item.isPast ? '1' : '0'}-${item.detalle || ''}`;

        if (!currentBlock) {
          currentBlock = {
            startDate: item.date,
            endDate: item.date,
            estado: item.estado,
            estadoSecundario: item.estadoSecundario,
            detalle: item.detalle,
            codigoCorto: item.codigoCorto,
            flexible: item.flexible,
            isPast: item.isPast,
          };
        } else {
          const currentSignature = `${currentBlock.estado}-${currentBlock.codigoCorto || ''}-${currentBlock.flexible ? '1' : '0'}-${currentBlock.isPast ? '1' : '0'}-${currentBlock.detalle || ''}`;
          const isConsecutive = item.date.diff(currentBlock.endDate, 'days').days === 1;

          if (signature === currentSignature && isConsecutive) {
            currentBlock.endDate = item.date;
          } else {
            // Guardar bloque anterior
            eventos.push({
              id: `${obs.id}-${currentBlock.startDate.toISODate()}-${currentBlock.estado}`,
              startDate: currentBlock.startDate.toISODate()!,
              endDate: currentBlock.endDate.plus({ days: 1 }).toISODate()!, // Vis-Timeline end exclusivo
              estado: currentBlock.estado,
              estadoSecundario: currentBlock.estadoSecundario,
              detalle: currentBlock.detalle,
              codigoCorto: currentBlock.codigoCorto,
              flexible: currentBlock.flexible,
              isPast: currentBlock.isPast,
            });

            currentBlock = {
              startDate: item.date,
              endDate: item.date,
              estado: item.estado,
              estadoSecundario: item.estadoSecundario,
              detalle: item.detalle,
              codigoCorto: item.codigoCorto,
              flexible: item.flexible,
              isPast: item.isPast,
            };
          }
        }
      }

      if (currentBlock) {
        eventos.push({
          id: `${obs.id}-${currentBlock.startDate.toISODate()}-${currentBlock.estado}`,
          startDate: currentBlock.startDate.toISODate()!,
          endDate: currentBlock.endDate.plus({ days: 1 }).toISODate()!,
          estado: currentBlock.estado,
          estadoSecundario: currentBlock.estadoSecundario,
          detalle: currentBlock.detalle,
          codigoCorto: currentBlock.codigoCorto,
          flexible: currentBlock.flexible,
          isPast: currentBlock.isPast,
        });
      }

      rows.push({
        observador: obs,
        eventos,
      });
    }

    return {
      fechaInicio: startDate.toISODate()!,
      fechaFin: endDate.toISODate()!,
      fechaHoy: today.toISODate()!,
      observadores: rows,
    };
  }
}
