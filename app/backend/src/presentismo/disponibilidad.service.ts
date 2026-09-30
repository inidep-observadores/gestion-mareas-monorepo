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
          detalleBloqueoDoc = `Cédula vencida (${dtVtoCedula.toFormat('dd/MM/yyyy')})`;
        } else {
          primerBloqueoDoc = dtVtoMedico.plus({ days: 1 });
          detalleBloqueoDoc = `Apto médico vencido (${dtVtoMedico.toFormat('dd/MM/yyyy')})`;
        }
      } else if (dtVtoCedula) {
        primerBloqueoDoc = dtVtoCedula.plus({ days: 1 });
        detalleBloqueoDoc = `Cédula vencida (${dtVtoCedula.toFormat('dd/MM/yyyy')})`;
      } else if (dtVtoMedico) {
        primerBloqueoDoc = dtVtoMedico.plus({ days: 1 });
        detalleBloqueoDoc = `Apto médico vencido (${dtVtoMedico.toFormat('dd/MM/yyyy')})`;
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

        // Marea en ejecución: si el observador está afectado a una marea en curso
        const mareaEnEjecucion = obsMareasDelDia.find((m: any) => {
          if (!m.isEnEjecucion || !m.inicioMarea) return false;
          return currentDate >= m.inicioMarea && currentDate <= m.limiteFinProyeccion;
        });

        if (mareaEnEjecucion) {
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
                buqueNombre: mareaEnEjecucion.buque?.nombreBuque
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

        // 0. Bloqueo por documentación vencida (Cédula o Apto Médico)
        // Rige a partir del día siguiente al vencimiento y se extiende indefinidamente
        // a menos que el observador esté actualmente navegando (marea en curso)
        const docVencida = primerBloqueoDoc && currentDate >= primerBloqueoDoc;

        // Si el día está libre (sin mareas en curso ni licencias activas)
        if (estadoEvaluado.estado === 'LIBRE' || estadoEvaluado.estado === 'FIN_SEMANA') {
          if (docVencida) {
            // Documentación vencida bloquea la disponibilidad indefinidamente
            dailyStates.push({
              date: currentDate,
              estado: 'NOVEDAD',
              detalle: `Documentación vencida: ${detalleBloqueoDoc}`,
              codigoCorto: 'NO DISPONIBLE',
              flexible: false,
              isPast,
            });
          } else if (mareaDesignada) {
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
              buqueNombre: mareaDesignada.buque?.nombreBuque
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
          };
        } else {
          const currentSignature = `${currentBlock.estado}-${currentBlock.codigoCorto || ''}-${currentBlock.estadoSecundario || ''}-${currentBlock.flexible ? '1' : '0'}-${currentBlock.isPast ? '1' : '0'}-${currentBlock.detalle || ''}-${currentBlock.buqueId || ''}`;
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
              buqueId: currentBlock.buqueId,
              buqueNombre: currentBlock.buqueNombre,
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
