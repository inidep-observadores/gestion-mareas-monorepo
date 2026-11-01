import { Injectable, BadRequestException } from '@nestjs/common';
import * as ExcelJS from 'exceljs';
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
  constructor(private readonly prisma: PrismaService) { }

  async obtenerDisponibilidad(mesesHorizonte: number = 1): Promise<DisponibilidadResponseDto> {
    const horizon = Math.min(Math.max(mesesHorizonte || 1, 1), 12);
    const timezone = DateUtils.getTimezone();

    // Fecha actual al inicio del día
    const today = DateTime.fromJSDate(DateUtils.getNow(), { zone: timezone }).startOf('day');
    // Para contexto referencial previo, abarcamos 120 días hacia atrás (4 meses)
    const startDate = today.minus({ days: 120 }).startOf('day');
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
        vencimientoCedula: true,
        vencimientoAptoMedico: true,
      },
      orderBy: [{ apellido: 'asc' }, { nombre: 'asc' }],
    });

    // 2. Traer novedades aprobadas y activas que se solapen con el período (excluyendo trámites como ACTUALIZACION_CEDULA que no afectan disponibilidad)
    const novedadesDb = await this.prisma.observadorNovedad.findMany({
      where: {
        activo: true,
        estadoAprobacion: 'APROBADA',
        tipoNovedad: {
          codigo: { notIn: ['ACTUALIZACION_CEDULA'] },
        },
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
      // Filtrar novedades del observador (excluyendo trámites que no afectan disponibilidad)
      const obsNovedades = novedadesDb.filter(
        n => n.observadorId === obs.id && n.tipoNovedad?.codigo !== 'ACTUALIZACION_CEDULA'
      );

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
            } catch { }
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

          const isEnEjecucion = marea.estadoActual?.codigo === MareaEstado.EN_EJECUCION;

          // Código legible de la marea
          const anioStr = marea.anioMarea ? String(marea.anioMarea).slice(-2) : '00';
          const codigoMarea = `${marea.tipoMarea || 'MC'}-${marea.nroMarea || 0}-${anioStr}`;

          // Calcular fecha de inicio de referencia para la marea (fechaInicioObservador o zarpada estimada o zarpada primera etapa)
          const primeraEtapaZarpada = etapasFiltradas[0]?.fechaZarpada;
          const inicioMareaDate = marea.fechaInicioObservador || marea.fechaZarpadaEstimada || primeraEtapaZarpada;
          const inicioMarea = inicioMareaDate ? DateTime.fromJSDate(inicioMareaDate, { zone: 'utc' }).startOf('day') : null;
          const duracion = marea.diasEstimados || 30;

          // Referencia de inicio para calcular fin estimado original de la marea completa
          const finEstimadoOriginal = inicioMarea
            ? inicioMarea.plus({ days: Math.max(duracion - 1, 0) }).endOf('day')
            : null;

          // Si la marea está en ejecución y a la fecha de hoy ya superó la estimación original
          const superoEstimacionHoy = isEnEjecucion && !!finEstimadoOriginal && today > finEstimadoOriginal;

          // Límite de navegación física esperada:
          // Si está en ejecución, cubre al observador como afectado a marea al menos hasta finEstimadoOriginal (o hasta today si ya lo superó).
          let limiteFinNavegando: DateTime | null = finEstimadoOriginal;
          if (isEnEjecucion) {
            limiteFinNavegando = (finEstimadoOriginal && finEstimadoOriginal > today)
              ? finEstimadoOriginal
              : today.endOf('day');
          }

          // Ventana de proyección máxima:
          // La ventana móvil de 7 días solo se aplica si la marea actualmente lleva más tiempo del estimado (superoEstimacionHoy).
          // De lo contrario, la marea concluye en finEstimadoOriginal y NO se proyecta bloque de no disponibilidad.
          let limiteFinProyeccion: DateTime | null = finEstimadoOriginal;
          if (superoEstimacionHoy) {
            limiteFinProyeccion = today.plus({ days: 7 }).endOf('day');
          }

          // Adaptar etapas para evaluarEstadoDia:
          const etapasAdaptadas = etapasFiltradas.map((etapa: any) => {
            const e = { ...etapa };
            if (!e.fechaArribo && limiteFinNavegando) {
              e.fechaArribo = limiteFinNavegando.toJSDate();
            }
            return e;
          });

          return {
            ...marea,
            codigoMarea,
            isSecundario,
            isEnEjecucion,
            inicioMarea,
            inicioMareaDate,
            superoEstimacionHoy,
            etapas: etapasAdaptadas,
            finEstimadoOriginal,
            limiteFinNavegando,
            limiteFinProyeccion,
          };
        });

      // Calcular fecha de bloqueo por documentación vencida (cédula o apto médico)
      // Solo bloquea si las fechas existen y están vencidas. El bloqueo rige desde el día siguiente al vencimiento.
      const dtVtoCedula = obs.vencimientoCedula
        ? DateTime.fromJSDate(obs.vencimientoCedula, { zone: timezone }).startOf('day')
        : null;
      const dtVtoMedico = obs.vencimientoAptoMedico
        ? DateTime.fromJSDate(obs.vencimientoAptoMedico, { zone: timezone }).startOf('day')
        : null;

      let primerBloqueoDoc: DateTime | null = null;
      let detalleBloqueoDoc = '';

      if (dtVtoCedula && dtVtoMedico) {
        if (dtVtoCedula <= dtVtoMedico) {
          primerBloqueoDoc = dtVtoCedula.plus({ days: 1 });
          detalleBloqueoDoc = `Cédula vence (${dtVtoCedula.toFormat('dd/MM/yyyy')})`;
        } else {
          primerBloqueoDoc = dtVtoMedico.plus({ days: 1 });
          detalleBloqueoDoc = `Apto médico vence (${dtVtoMedico.toFormat('dd/MM/yyyy')})`;
        }
      } else if (dtVtoCedula) {
        primerBloqueoDoc = dtVtoCedula.plus({ days: 1 });
        detalleBloqueoDoc = `Cédula vence (${dtVtoCedula.toFormat('dd/MM/yyyy')})`;
      } else if (dtVtoMedico) {
        primerBloqueoDoc = dtVtoMedico.plus({ days: 1 });
        detalleBloqueoDoc = `Apto médico vence (${dtVtoMedico.toFormat('dd/MM/yyyy')})`;
      }

      // Mapear cada día evaluado
      const dailyStates: Array<{
        date: DateTime;
        estado: ObservadorDisponibilidadItemDto['estado'];
        estadoSecundario?: string;
        detalle?: string;
        codigoCorto?: string;
        flexible?: boolean;
        isPast: boolean;
        buqueId?: string;
        buqueNombre?: string;
        warningDocVencida?: string;
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

        // Filtrar mareas que aplican a este día: si la marea tiene límite de proyección y currentDate supera dicho límite, ya no aplica
        const obsMareasDelDia = obsMareas.filter((m: any) => {
          if (m.limiteFinProyeccion && currentDate > m.limiteFinProyeccion) {
            return false;
          }
          return true;
        });

        // Novedades para evaluar estado del día: se excluye DISPONIBLE para no generar falso conflicto con mareas
        const obsNovedadesSinAvisoDisp = obsNovedades.filter(n => n.tipoNovedad?.codigo !== 'DISPONIBLE');

        // Evaluar estado del día (en disponibilidad no evaluamos feriados para cortar disponibilidad)
        const estadoEvaluado = evaluarEstadoDia(
          currentDate,
          obsMareasDelDia,
          obsNovedadesSinAvisoDisp,
          null, // Sin feriados
          isFinSemana,
          true  // Incluir todas las novedades
        );

        // 0. Bloqueo por documentación vencida (Cédula o Apto Médico)
        // Rige a partir del día siguiente al vencimiento
        const docVencida = primerBloqueoDoc && currentDate >= primerBloqueoDoc;
        const warningString = docVencida ? detalleBloqueoDoc : undefined;

        // Marea en ejecución: si el observador está afectado a una marea en curso
        const mareaEnEjecucion = obsMareasDelDia.find((m: any) => {
          if (!m.isEnEjecucion || !m.inicioMarea) return false;
          return currentDate >= m.inicioMarea && currentDate <= m.limiteFinProyeccion;
        });

        if (mareaEnEjecucion) {
          const docVencidaAntesEjecucion = primerBloqueoDoc && primerBloqueoDoc <= mareaEnEjecucion.inicioMarea;
          if (docVencida && docVencidaAntesEjecucion) {
            dailyStates.push({
              date: currentDate,
              estado: 'CONFLICTO',
              detalle: `Solapamiento: Marea ${mareaEnEjecucion.codigoMarea || 'en curso'} vs Documentación vencida`,
              codigoCorto: 'CONFLICTO',
              flexible: false,
              isPast,
            });
            continue;
          }

          // Si está dentro de la duración estimada original
          if (mareaEnEjecucion.finEstimadoOriginal && currentDate <= mareaEnEjecucion.finEstimadoOriginal) {
            if (currentDate <= today) {
              // Navegando confirmado en curso
              dailyStates.push({
                date: currentDate,
                estado: 'NAVEGANDO',
                detalle: mareaEnEjecucion.codigoMarea,
                codigoCorto: 'NAVEGANDO',
                flexible: false,
                isPast,
                buqueId: mareaEnEjecucion.buqueId,
                buqueNombre: mareaEnEjecucion.buque?.nombreBuque
              });
            } else {
              // Navegando proyectado por los días previstos de marea (verde atenuado con borde punteado)
              dailyStates.push({
                date: currentDate,
                estado: 'NAVEGANDO',
                estadoSecundario: 'PROYECTADA',
                detalle: `${mareaEnEjecucion.codigoMarea} · Previsto por días estimados`,
                codigoCorto: 'NAVEGANDO',
                flexible: false,
                isPast: false,
                buqueId: mareaEnEjecucion.buqueId,
                buqueNombre: mareaEnEjecucion.buque?.nombreBuque,
                warningDocVencida: warningString
              });
            }
            continue;
          } else if (currentDate <= today) {
            // Marea en curso que superó la estimación original: hasta hoy inclusive sigue navegando
            dailyStates.push({
              date: currentDate,
              estado: 'NAVEGANDO',
              detalle: mareaEnEjecucion.codigoMarea,
              codigoCorto: 'NAVEGANDO',
              flexible: false,
              isPast,
              buqueId: mareaEnEjecucion.buqueId,
              buqueNombre: mareaEnEjecucion.buque?.nombreBuque
            });
            continue;
          } else if (mareaEnEjecucion.superoEstimacionHoy && currentDate <= mareaEnEjecucion.limiteFinProyeccion) {
            // Únicamente si la marea lleva actualmente más tiempo del estimado: ventana móvil de 7 días de no disponibilidad estimada
            dailyStates.push({
              date: currentDate,
              estado: 'NOVEDAD',
              estadoSecundario: 'PROYECTADA',
              detalle: `Proyección estimada: marea ${mareaEnEjecucion.codigoMarea} en curso (ventana móvil de 7 días)`,
              codigoCorto: 'NO DISP. (EST.)',
              flexible: false,
              isPast: false,
            });
            continue;
          }
        }

        // Novedades activas del día para comprobar flexibilidad y tipo
        const novedadesDelDia = obsNovedades.filter(n => {
          const ini = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          const fin = n.fechaFin
            ? DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day')
            : DateTime.now().endOf('year').plus({ years: 10 });
          return currentDate >= ini && currentDate <= fin;
        });

        // 1. Detectar si para esta fecha (o posterior) existe un aviso de DISPONIBLE que deba bloquear los días previos
        const proximoAvisoDisponible = obsNovedades.find(n => {
          if (n.tipoNovedad?.codigo !== 'DISPONIBLE') return false;
          const fechaDisp = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          return currentDate < fechaDisp;
        });

        // 2. Detectar si para esta fecha existe un aviso de DISPONIBLE vigente que confirme la disponibilidad
        // (y que no haya sido consumido por una marea posterior que ya zarpó)
        const tieneAvisoVigente = obsNovedades.some(n => {
          if (n.tipoNovedad?.codigo !== 'DISPONIBLE') return false;
          const iniAviso = DateTime.fromJSDate(n.fechaInicio, { zone: 'utc' }).startOf('day');
          if (currentDate < iniAviso) return false;
          if (n.fechaFin) {
            const finAviso = DateTime.fromJSDate(n.fechaFin, { zone: 'utc' }).endOf('day');
            if (currentDate > finAviso) return false;
          }
          // Si el observador zarpó en una marea posterior al aviso, dicho aviso ya fue cumplido
          const mareaPosterior = obsMareas.some((m: any) => {
            const inicioMarea = m.fechaInicioObservador || m.fechaZarpadaEstimada || m.etapas[0]?.fechaZarpada;
            if (!inicioMarea) return false;
            const zarpada = DateTime.fromJSDate(inicioMarea, { zone: 'utc' }).startOf('day');
            return zarpada >= iniAviso && zarpada <= currentDate;
          });
          return !mareaPosterior;
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

        // Si el día está libre (sin mareas en curso ni licencias activas)
        if (estadoEvaluado.estado === 'LIBRE' || estadoEvaluado.estado === 'FIN_SEMANA') {
          if (mareaDesignada) {
            const docVencidaAntesDesignacion = primerBloqueoDoc && primerBloqueoDoc <= mareaDesignada.inicioDesignada;
            if (docVencida && docVencidaAntesDesignacion) {
              dailyStates.push({
                date: currentDate,
                estado: 'CONFLICTO',
                detalle: `Solapamiento: Marea Designada vs Documentación vencida`,
                codigoCorto: 'CONFLICTO',
                flexible: false,
                isPast,
              });
            } else {
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
                buqueId: mareaDesignada.buqueId,
                buqueNombre: mareaDesignada.buque?.nombreBuque,
                warningDocVencida: warningString
              });
            }

          } else if (docVencida) {
            // Documentación vencida bloquea la disponibilidad indefinidamente
            dailyStates.push({
              date: currentDate,
              estado: 'NOVEDAD',
              detalle: `Documentación vencida: ${detalleBloqueoDoc}`,
              codigoCorto: 'NO DISPONIBLE',
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
          } else if (tieneAvisoVigente) {
            // Disponibilidad iniciada a partir de un aviso documentado: DISPONIBLE (Confirmada)
            dailyStates.push({
              date: currentDate,
              estado: 'DISPONIBLE',
              detalle: 'Disponible para embarque',
              codigoCorto: 'DISPONIBLE',
              flexible: false,
              isPast: false,
            });
          } else {
            // Futuro libre sin aviso documentado: DISPONIBILIDAD NO CONFIRMADA
            dailyStates.push({
              date: currentDate,
              estado: 'DISPONIBLE_NO_CONFIRMADA',
              detalle: 'Disponibilidad no confirmada (el observador no confirmó la disponibilidad)',
              codigoCorto: '¿DISPONIBLE?',
              flexible: false,
              isPast: false,
            });
          }
        } else {
          // Es un evento activo (Navegando, Puerto, Novedad, Viaje, Conflicto, Esperando Zarpada)
          let codCorto = estadoEvaluado.codigoCorto;
          if (codCorto === 'NO_DISPONIBLE' || codCorto === 'NO_DISP') {
            codCorto = 'NO DISPONIBLE';
          }

          dailyStates.push({
            date: currentDate,
            estado: estadoEvaluado.estado as any,
            estadoSecundario: estadoEvaluado.estadoSecundario,
            detalle: estadoEvaluado.detalle || estadoEvaluado.conflictoDetalle,
            codigoCorto: codCorto,
            flexible: isFlexible,
            isPast,
            buqueId: estadoEvaluado.buqueId,
            buqueNombre: estadoEvaluado.buqueNombre
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
        buqueId?: string;
        buqueNombre?: string;
        warningDocVencida?: string;
      } | null = null;

      for (let i = 0; i < dailyStates.length; i++) {
        const item = dailyStates[i] as any; // Cast to any to access buqueId since dailyStates type might not be fully typed in loop if inferred
        const signature = `${item.estado}-${item.codigoCorto || ''}-${item.estadoSecundario || ''}-${item.flexible ? '1' : '0'}-${item.isPast ? '1' : '0'}-${item.detalle || ''}-${item.buqueId || ''}`;

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
            buqueId: item.buqueId,
            buqueNombre: item.buqueNombre,
            warningDocVencida: item.warningDocVencida,
          };
        } else {
          const currentSignature = `${currentBlock.estado}-${currentBlock.codigoCorto || ''}-${currentBlock.estadoSecundario || ''}-${currentBlock.flexible ? '1' : '0'}-${currentBlock.isPast ? '1' : '0'}-${currentBlock.detalle || ''}-${currentBlock.buqueId || ''}`;
          const isConsecutive = item.date.diff(currentBlock.endDate, 'days').days === 1;

          if (signature === currentSignature && isConsecutive) {
            currentBlock.endDate = item.date;
            if (item.warningDocVencida) {
              currentBlock.warningDocVencida = item.warningDocVencida;
            }
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
              buqueId: currentBlock.buqueId,
              buqueNombre: currentBlock.buqueNombre,
              warningDocVencida: currentBlock.warningDocVencida,
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
              buqueId: item.buqueId,
              buqueNombre: item.buqueNombre,
              warningDocVencida: item.warningDocVencida,
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
          buqueId: currentBlock.buqueId,
          buqueNombre: currentBlock.buqueNombre,
          warningDocVencida: currentBlock.warningDocVencida,
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

  async exportarAExcel(
    fechaDesde: string,
    fechaHasta: string,
    observadorIds?: string[],
  ): Promise<ExcelJS.Workbook> {
    const timezone = DateUtils.getTimezone();
    const today = DateTime.fromJSDate(DateUtils.getNow(), { zone: timezone }).startOf('day');

    const cleanIni = fechaDesde.includes('T') ? fechaDesde.split('T')[0] : fechaDesde;
    const cleanFin = fechaHasta.includes('T') ? fechaHasta.split('T')[0] : fechaHasta;

    const inicioDate = DateTime.fromISO(cleanIni, { zone: timezone }).startOf('day');
    const finDate = DateTime.fromISO(cleanFin, { zone: timezone }).startOf('day');

    if (!inicioDate.isValid || !finDate.isValid || finDate < inicioDate) {
      throw new BadRequestException('El rango de fechas especificado es inválido');
    }

    // Calcular meses requeridos respecto a hoy para asegurar cobertura de datos
    const diffMonths = Math.ceil(Math.max(1, finDate.diff(today, 'months').months)) + 1;
    const horizon = Math.min(12, Math.max(1, diffMonths));

    const dispData = await this.obtenerDisponibilidad(horizon);

    // Filtrar y ordenar observadores según observadorIds si vienen especificados
    let filas: ObservadorDisponibilidadRowDto[] = [];
    if (observadorIds && observadorIds.length > 0) {
      const mapa = new Map(dispData.observadores.map((r) => [r.observador.id, r]));
      filas = observadorIds.map((id) => mapa.get(id)).filter(Boolean) as ObservadorDisponibilidadRowDto[];
    } else {
      filas = dispData.observadores;
    }

    // Generar array de días del rango
    const diasRango: DateTime[] = [];
    let cur = inicioDate;
    while (cur <= finDate) {
      diasRango.push(cur);
      cur = cur.plus({ days: 1 });
    }

    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'SIGMA - INIDEP';
    workbook.created = new Date();

    const sheet = workbook.addWorksheet('Disponibilidad', {
      views: [{ state: 'frozen', xSplit: 2, ySplit: 4 }]
    });

    // Fila 1: Título principal
    sheet.mergeCells(1, 1, 1, 2 + diasRango.length);
    const cellTitulo = sheet.getCell('A1');
    cellTitulo.value = 'SIGMA - DISPONIBILIDAD DE OBSERVADORES (INIDEP)';
    cellTitulo.font = { name: 'Calibri', size: 14, bold: true, color: { argb: 'FF1E3A8A' } };
    cellTitulo.alignment = { horizontal: 'left', vertical: 'middle' };
    sheet.getRow(1).height = 28;

    // Fila 2: Subtítulo con período y totales
    sheet.mergeCells(2, 1, 2, 2 + diasRango.length);
    const cellSubtitulo = sheet.getCell('A2');
    cellSubtitulo.value = `Período visualizado: ${inicioDate.toFormat('dd/MM/yyyy')} al ${finDate.toFormat('dd/MM/yyyy')} (${diasRango.length} días) | Observadores listados: ${filas.length}`;
    cellSubtitulo.font = { name: 'Calibri', size: 10, italic: true, color: { argb: 'FF4B5563' } };
    cellSubtitulo.alignment = { horizontal: 'left', vertical: 'middle' };
    sheet.getRow(2).height = 18;

    // Fila 3: Espacio separador
    sheet.getRow(3).height = 8;

    // Fila 4: Cabecera de Columnas
    const headers = [
      'LEGAJO',
      'OBSERVADOR',
      ...diasRango.map((d) => {
        let diaNom = d.setLocale('es').toFormat('ccc');
        diaNom = diaNom.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toUpperCase();
        return `${diaNom}\n${d.toFormat('dd/MM')}`;
      })
    ];

    const rowHeader = sheet.getRow(4);
    rowHeader.values = headers;
    rowHeader.height = 30;

    // Configuración de anchos de columna
    sheet.getColumn(1).width = 12; // LEGAJO
    sheet.getColumn(2).width = 30; // OBSERVADOR
    for (let i = 0; i < diasRango.length; i++) {
      sheet.getColumn(3 + i).width = 8;
    }

    // Estilo encabezados
    rowHeader.eachCell((cell, colNum) => {
      cell.font = { name: 'Calibri', size: 9, bold: true, color: { argb: 'FF1F2937' } };
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF3F4F6' } };
      cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
      cell.border = {
        top: { style: 'thin', color: { argb: 'FFD1D5DB' } },
        bottom: { style: 'medium', color: { argb: 'FF9CA3AF' } },
        left: { style: 'thin', color: { argb: 'FFE5E7EB' } },
        right: { style: 'thin', color: { argb: 'FFE5E7EB' } },
      };

      if (colNum > 2) {
        const dia = diasRango[colNum - 3];
        if (dia.weekday === 6 || dia.weekday === 7) {
          cell.font = { name: 'Calibri', size: 9, bold: true, color: { argb: 'FFDC2626' } };
          cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFEE2E2' } };
        }
      }
    });

    // Filas de datos
    filas.forEach((row) => {
      const rowData = [
        row.observador.codigoInterno || '-',
        `${row.observador.apellido}, ${row.observador.nombre}`,
      ];

      diasRango.forEach((d) => {
        const isoD = d.toISODate()!;
        const ev = row.eventos.find((e) => e.startDate <= isoD && e.endDate > isoD);

        let textoCelda = '';
        if (ev) {
          if (ev.estado === 'NAVEGANDO') {
            textoCelda = ev.estadoSecundario === 'PROYECTADA' ? 'NAV. EST' : 'NAVEG';
          } else if (ev.codigoCorto === 'NO DISP. (EST.)' || (ev.estadoSecundario === 'PROYECTADA' && ev.estado === 'NOVEDAD')) {
            textoCelda = 'NO DISP (E)';
          } else if (ev.estado === 'DISPONIBLE') {
            textoCelda = 'DISP';
          } else if (ev.estado === 'DISPONIBLE_NO_CONFIRMADA') {
            textoCelda = '¿DISP?';
          } else if (ev.estado === 'DESIGNADA') {
            textoCelda = 'DESIGN';
          } else if (ev.estado === 'IMPEDIMENTO') {
            textoCelda = 'IMPED';
          } else if (ev.estado === 'PUERTO') {
            textoCelda = 'PUERTO';
          } else if (ev.estado === 'VIAJE') {
            textoCelda = 'VIAJE';
          } else if (ev.estado === 'ESPERANDO_ZARPADA') {
            textoCelda = 'ESP. ZARP';
          } else if (ev.estado === 'NOVEDAD') {
            const cod = (ev.codigoCorto || '').toUpperCase();
            if (cod === 'NO DISPONIBLE' || cod === 'NO_DISP' || cod === 'NO_DISPONIBLE') {
              textoCelda = 'NO DISP';
            } else {
              textoCelda = ev.codigoCorto || 'NOV';
            }
          } else if (ev.estado === 'CONFLICTO') {
            textoCelda = 'CONFLICTO';
          } else {
            textoCelda = ev.codigoCorto || ev.estado || '';
          }
        }
        rowData.push(textoCelda);
      });

      const excelRow = sheet.addRow(rowData);
      excelRow.height = 20;

      // Columna Legajo
      const cellLegajo = excelRow.getCell(1);
      cellLegajo.alignment = { horizontal: 'center', vertical: 'middle' };
      cellLegajo.font = { name: 'Calibri', size: 9, bold: true };

      // Columna Observador
      const cellObs = excelRow.getCell(2);
      cellObs.alignment = { horizontal: 'left', vertical: 'middle' };
      cellObs.font = { name: 'Calibri', size: 10, bold: true };
      if (row.observador.conImpedimento) {
        cellObs.font = { name: 'Calibri', size: 10, bold: true, color: { argb: 'FFDC2626' } };
      }

      // Celdas de días con estilos exactos
      diasRango.forEach((d, dIdx) => {
        const colNum = 3 + dIdx;
        const cell = excelRow.getCell(colNum);
        const isoD = d.toISODate()!;
        const ev = row.eventos.find((e) => e.startDate <= isoD && e.endDate > isoD);

        cell.alignment = { horizontal: 'center', vertical: 'middle' };
        cell.font = { name: 'Calibri', size: 8, bold: true };

        cell.border = {
          top: { style: 'thin', color: { argb: 'FFE5E7EB' } },
          bottom: { style: 'thin', color: { argb: 'FFE5E7EB' } },
          left: { style: 'thin', color: { argb: 'FFE5E7EB' } },
          right: { style: 'thin', color: { argb: 'FFE5E7EB' } },
        };

        if (ev) {
          if (ev.estado === 'NAVEGANDO') {
            if (ev.estadoSecundario === 'PROYECTADA') {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFDCFCE7' } }; // Verde atenuado
              cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF15803D' } };
              cell.border = {
                top: { style: 'dashed', color: { argb: 'FF22C55E' } },
                bottom: { style: 'dashed', color: { argb: 'FF22C55E' } },
                left: { style: 'dashed', color: { argb: 'FF22C55E' } },
                right: { style: 'dashed', color: { argb: 'FF22C55E' } },
              };
              cell.note = `Navegación proyectada\n${ev.detalle || (ev.buqueNombre ? `Buque: ${ev.buqueNombre}` : '')}`.trim();
            } else {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF22C55E' } }; // Verde sólido
              cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FFFFFFFF' } };
              if (ev.detalle || ev.buqueNombre) {
                cell.note = `Navegación\n${ev.detalle || (ev.buqueNombre ? `Buque: ${ev.buqueNombre}` : '')}`.trim();
              }
            }
          } else if (ev.codigoCorto === 'NO DISP. (EST.)' || (ev.estadoSecundario === 'PROYECTADA' && ev.estado === 'NOVEDAD')) {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFE4E6' } }; // Rosa atenuado
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FFBE123C' } };
            cell.border = {
              top: { style: 'dashed', color: { argb: 'FFF43F5E' } },
              bottom: { style: 'dashed', color: { argb: 'FFF43F5E' } },
              left: { style: 'dashed', color: { argb: 'FFF43F5E' } },
              right: { style: 'dashed', color: { argb: 'FFF43F5E' } },
            };
            if (ev.detalle) cell.note = ev.detalle;
          } else if (ev.estado === 'DISPONIBLE') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFACC15' } }; // Amarillo
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF713F12' } };
          } else if (ev.estado === 'DISPONIBLE_NO_CONFIRMADA') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFEF9C3' } }; // Amarillo pastel
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF854D0E' } };
            cell.border = {
              top: { style: 'dashed', color: { argb: 'FFEAB308' } },
              bottom: { style: 'dashed', color: { argb: 'FFEAB308' } },
              left: { style: 'dashed', color: { argb: 'FFEAB308' } },
              right: { style: 'dashed', color: { argb: 'FFEAB308' } },
            };
            cell.note = 'Disponibilidad no confirmada';
          } else if (ev.estado === 'DESIGNADA') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFCFFAFE' } }; // Celeste cian
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF0E7490' } };
            cell.border = {
              top: { style: 'dashed', color: { argb: 'FF67E8F9' } },
              bottom: { style: 'dashed', color: { argb: 'FF67E8F9' } },
              left: { style: 'dashed', color: { argb: 'FF67E8F9' } },
              right: { style: 'dashed', color: { argb: 'FF67E8F9' } },
            };
            if (ev.detalle || ev.buqueNombre) {
              cell.note = `Marea Designada\n${ev.detalle || (ev.buqueNombre ? `Buque: ${ev.buqueNombre}` : '')}`.trim();
            }
          } else if (ev.estado === 'PUERTO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFEDD5' } };
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FFC2410C' } };
            if (ev.detalle) cell.note = ev.detalle;
          } else if (ev.estado === 'VIAJE') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E7FF' } };
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF4338CA' } };
            if (ev.detalle) cell.note = ev.detalle;
          } else if (ev.estado === 'ESPERANDO_ZARPADA') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFF3F4F6' } };
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF374151' } };
            if (ev.detalle) cell.note = ev.detalle;
          } else if (ev.estado === 'NOVEDAD') {
            const cod = (ev.codigoCorto || '').toUpperCase();
            if (cod === 'NO DISPONIBLE' || cod === 'NO_DISP' || cod === 'NO_DISPONIBLE') {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFEE2E2' } };
              cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF991B1B' } };
            } else {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0F2FE' } };
              cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FF0369A1' } };
            }
            if (ev.flexible) {
              cell.border = {
                top: { style: 'medium', color: { argb: 'FFF59E0B' } },
                bottom: { style: 'medium', color: { argb: 'FFF59E0B' } },
                left: { style: 'medium', color: { argb: 'FFF59E0B' } },
                right: { style: 'medium', color: { argb: 'FFF59E0B' } },
              };
            }
            if (ev.detalle) cell.note = `${ev.detalle}${ev.flexible ? '\n(Flexible ante urgencias)' : ''}`;
          } else if (ev.estado === 'IMPEDIMENTO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF991B1B' } };
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FFFFFFFF' } };
            if (ev.detalle) cell.note = ev.detalle;
          } else if (ev.estado === 'CONFLICTO') {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFDC2626' } };
            cell.font = { name: 'Calibri', size: 8, bold: true, color: { argb: 'FFFFFFFF' } };
            if (ev.detalle) cell.note = ev.detalle;
          }
        } else {
          if (d.weekday === 6 || d.weekday === 7) {
            cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFAFAFA' } };
          }
        }
      });
    });

    // Hoja 2: Referencias / Leyenda
    const refSheet = workbook.addWorksheet('Referencias');
    refSheet.columns = [
      { header: 'CÓDIGO', key: 'codigo', width: 16 },
      { header: 'ESTADO / SIGNIFICADO', key: 'descripcion', width: 45 },
    ];
    refSheet.getRow(1).font = { bold: true, size: 10 };
    refSheet.getRow(1).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE5E7EB' } };

    const referencias = [
      { codigo: 'DISP', descripcion: 'Disponible para embarque (con aviso confirmado)', fill: 'FFFACC15', font: 'FF713F12' },
      { codigo: '¿DISP?', descripcion: 'Período libre (disponibilidad no confirmada)', fill: 'FFFEF9C3', font: 'FF854D0E', borderDashed: true },
      { codigo: 'NAVEG', descripcion: 'Marea en ejecución (navegando)', fill: 'FF22C55E', font: 'FFFFFFFF' },
      { codigo: 'NAV. EST', descripcion: 'Navegación proyectada según duración estimada', fill: 'FFDCFCE7', font: 'FF15803D', borderDashed: true },
      { codigo: 'DESIGN', descripcion: 'Marea designada en planificación', fill: 'FFCFFAFE', font: 'FF0E7490', borderDashed: true },
      { codigo: 'NO DISP', descripcion: 'No disponible para embarque', fill: 'FFFEE2E2', font: 'FF991B1B' },
      { codigo: 'NO DISP (E)', descripcion: 'No disponible estimada (superó días estimados)', fill: 'FFFFE4E6', font: 'FFBE123C', borderDashed: true },
      { codigo: 'PUERTO', descripcion: 'En puerto (no local)', fill: 'FFFFEDD5', font: 'FFC2410C' },
      { codigo: 'VIAJE', descripcion: 'En tránsito / comisión de servicio', fill: 'FFE0E7FF', font: 'FF4338CA' },
      { codigo: 'ESP. ZARP', descripcion: 'Esperando zarpada en puerto', fill: 'FFF3F4F6', font: 'FF374151' },
      { codigo: 'FC / LIC / NOV', descripcion: 'Novedades / Licencias (borde dorado: flexible)', fill: 'FFE0F2FE', font: 'FF0369A1' },
      { codigo: 'IMPED', descripcion: 'Observador con impedimento activo', fill: 'FF991B1B', font: 'FFFFFFFF' },
    ];

    referencias.forEach((refItem) => {
      const r = refSheet.addRow({ codigo: refItem.codigo, descripcion: refItem.descripcion });
      const c1 = r.getCell(1);
      c1.alignment = { horizontal: 'center', vertical: 'middle' };
      c1.font = { bold: true, color: { argb: refItem.font } };
      c1.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: refItem.fill } };
      if (refItem.borderDashed) {
        c1.border = {
          top: { style: 'dashed', color: { argb: 'FF9CA3AF' } },
          bottom: { style: 'dashed', color: { argb: 'FF9CA3AF' } },
          left: { style: 'dashed', color: { argb: 'FF9CA3AF' } },
          right: { style: 'dashed', color: { argb: 'FF9CA3AF' } },
        };
      }
    });

    return workbook;
  }
}
