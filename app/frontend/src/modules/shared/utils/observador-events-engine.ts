/**
 * Motor Unificado de Eventos de Observador
 *
 * Centraliza la lógica para procesar el historial de novedades y mareas de un
 * observador y producir intervalos de eventos normalizados que pueden adaptarse
 * a cualquier componente de visualización (v-calendar, vis-timeline, etc.).
 *
 * IMPORTANTE: La lógica fue extraída 1:1 de ObservadorCalendar.vue (computed
 * `calendarAttributes`) para garantizar comportamiento idéntico en ambas vistas.
 */

// ─── Tipos ────────────────────────────────────────────────────────────────────

/**
 * Describe un intervalo normalizado de evento para un observador.
 * Es la salida central del motor y la entrada a los adaptadores de UI.
 */
export interface EventoObservador {
  /** Identificador único del bloque */
  id: string;
  tipo:
    | 'NOVEDAD'
    | 'MAREA_FINALIZADA'
    | 'MAREA_EJECUCION'
    | 'MAREA_DESIGNADA'
    | 'VIRTUAL_NO_DISPONIBLE'
    | 'VIRTUAL_TRANSITO'
    | 'CONFLICTO';
  /** Código de la novedad (ej: 'FC', 'DISPONIBLE', 'NO_DISPONIBLE', 'VIAJE_INICIO', etc.) */
  codigoNovedad?: string;
  start: Date;
  end: Date;
  /** Etiqueta breve para mostrar en el bloque */
  label: string;
  /** Etiqueta secundaria o descriptiva */
  sublabel?: string;
  /** Objeto novedad original (si aplica) */
  novedad?: any;
  /** Objeto marea original (si aplica) */
  marea?: any;
  /** Objeto etapa original (si aplica) */
  etapa?: any;
  /** Indica que la fecha de fin de la marea era estimada (no hay arribo real) */
  isEstimada?: boolean;
  /** Indica que el bloque corresponde a la porción futura de una marea estimada */
  isFuturo?: boolean;
}

// ─── Motor principal ──────────────────────────────────────────────────────────

const MAX_HUECO_VIAJE_DIAS = 10;

/**
 * Función auxiliar: formatea el código de una marea (tipo-nro-anio).
 */
function formatMareaCode(marea: any): string {
  const tipo = marea.tipoMarea || 'MC';
  const nro = marea.nroMarea || 0;
  const anioStr = marea.anioMarea ? String(marea.anioMarea).slice(-2) : '00';
  return `${tipo}-${nro}-${anioStr}`;
}

/**
 * Función auxiliar: registra todos los días de un rango en un mapa contador,
 * usado para detectar solapamientos.
 */
function registrarDiasEnConteo(
  start: Date,
  end: Date,
  datesCount: Record<string, number>
) {
  let current = new Date(start);
  while (current <= end) {
    const dateStr =
      current.getFullYear() +
      '-' +
      String(current.getMonth() + 1).padStart(2, '0') +
      '-' +
      String(current.getDate()).padStart(2, '0');
    datesCount[dateStr] = (datesCount[dateStr] || 0) + 1;
    current.setDate(current.getDate() + 1);
  }
}

/**
 * Construye la lista de eventos normalizados para un observador a partir de
 * sus novedades y mareas aprobadas/activas.
 *
 * La lógica replica exactamente el computed `calendarAttributes` de
 * ObservadorCalendar.vue, garantizando comportamiento idéntico entre el
 * calendario individual y el simulador multi-observador.
 *
 * @param novedadesActivas - Novedades filtradas (aprobadas, activas) del observador.
 * @param mareas - Mareas del observador.
 * @param today - Fecha "hoy" para separar pasado de futuro en mareas estimadas.
 * @returns Lista de EventoObservador normalizados y listos para adaptarse a cualquier UI.
 */
export function buildObservadorEventos(
  novedadesActivas: any[],
  mareas: any[],
  today: Date = new Date(),
  observadorId?: string | null
): EventoObservador[] {
  const eventos: EventoObservador[] = [];
  const datesCount: Record<string, number> = {};
  const todayNorm = new Date(today);
  todayNorm.setHours(0, 0, 0, 0);

  // Eventos de disponibilidad que se usarán luego para generar huecos virtuales
  const disponibilidadEvents: Array<{ novedad: any; start: Date; end: Date }> = [];

  // ── 1. Novedades ────────────────────────────────────────────────────────────
  novedadesActivas.forEach(novedad => {
    const startStr = novedad.fechaInicio.split('T')[0];
    let endStr = novedad.fechaFin ? novedad.fechaFin.split('T')[0] : null;

    if (!endStr) {
      // Mismo comportamiento que ObservadorCalendar: extiende hasta fin del año
      // de inicio cuando no hay fechaFin.
      const year = startStr.split('-')[0];
      endStr = `${year}-12-31`;
    }

    const start = new Date(startStr + 'T00:00:00');
    let end = new Date(endStr + 'T00:00:00');

    const code = novedad.tipoNovedad?.codigo?.toUpperCase() || '';
    const isDisponible = code === 'DISPONIBLE';

    // DISPONIBLE sin fechaFin: el span visual se reduce al día de inicio
    // (mismo comportamiento que ObservadorCalendar)
    if (isDisponible && !novedad.fechaFin) {
      end = new Date(start);
    }

    if (isDisponible) {
      disponibilidadEvents.push({ novedad, start, end });
    }

    // Registrar para detección de conflictos
    registrarDiasEnConteo(start, end, datesCount);

    const isFranco = code === 'FC' || code.includes('FRANCO');
    const isNoDisponible = code === 'NO_DISPONIBLE';

    let tipoEvento: EventoObservador['tipo'] = 'NOVEDAD';

    eventos.push({
      id: `nov-${novedad.id}`,
      tipo: tipoEvento,
      codigoNovedad: code,
      start,
      end,
      label: novedad.tipoNovedad?.descripcion || 'Novedad',
      novedad,
      // isFranco / isDisponible / isNoDisponible se detectan en el adaptador
      // vía codigoNovedad para no acoplar lógica de renderizado al motor
    });
  });

  // ── 2. Mareas ───────────────────────────────────────────────────────────────
  mareas.forEach(marea => {
    const baseCode = formatMareaCode(marea);
    const isDesignada =
      marea.estadoActual?.codigo === 'DESIGNADA' ||
      marea.estadoActual?.codigo === 'ESPERANDO_ZARPADA';

    const isPrincipal = !observadorId || marea.observadorPrincipalId === observadorId;

    let etapasToMap: any[] = [];

    if (isPrincipal) {
      etapasToMap = marea.etapas && marea.etapas.length > 0 ? marea.etapas : [];
      if (etapasToMap.length === 0) {
        etapasToMap = [{ id: marea.id, isDummy: true }];
      }
    } else {
      // Es observador secundario: filtrar etapas correspondientes o planificadas
      const etapasParticipa = (marea.etapas || []).filter((e: any) =>
        (e.observadores || []).some((o: any) => (o.observadorId || o.id) === observadorId)
      );

      const rawMeta = marea.metadata;
      let planificados: any[] = [];
      if (rawMeta) {
        try {
          const parsed = typeof rawMeta === 'string' ? JSON.parse(rawMeta) : rawMeta;
          planificados = parsed.observadoresSecundariosPlanificados || [];
        } catch {
          planificados = [];
        }
      }
      if (planificados.length === 0 && marea.observadoresSecundariosPlanificados) {
        planificados = marea.observadoresSecundariosPlanificados;
      }

      const planificadoParaObs = planificados.filter(
        (p: any) => p.observadorId === observadorId
      );

      if (etapasParticipa.length > 0) {
        etapasToMap = etapasParticipa;
      } else if (planificadoParaObs.length > 0) {
        if (marea.etapas && marea.etapas.length > 0) {
          etapasToMap = marea.etapas.filter((e: any) => {
            const nro = e.nroEtapa || 1;
            return planificadoParaObs.some((p: any) => {
              const desde = p.etapaDesde ?? 1;
              const hasta = p.etapaHasta ?? Infinity;
              return nro >= desde && nro <= hasta;
            });
          });
        }
        if (etapasToMap.length === 0) {
          etapasToMap = [{ id: `${marea.id}-secundario`, isDummy: true }];
        }
      } else {
        // No participa en esta marea
        return;
      }
    }

    const hasMultipleEtapas = etapasToMap.length > 1;
    let prevEndStr: string | null = null;

    etapasToMap.forEach((etapa: any) => {
      const mareaStart =
        etapa.fechaZarpada || marea.fechaZarpadaEstimada || marea.fechaInicioObservador;

      if (!mareaStart) return; // Sin fecha de inicio no se puede graficar

      const startDateStr = mareaStart.split('T')[0];
      const start = new Date(startDateStr + 'T00:00:00');

      // Evitar solapamiento visual entre etapas de la misma marea
      if (prevEndStr === startDateStr) {
        start.setDate(start.getDate() + 1);
      }

      let end: Date;
      let isEstimada = false;

      if (etapa.fechaArribo) {
        end = new Date(etapa.fechaArribo.split('T')[0] + 'T00:00:00');
        prevEndStr = etapa.fechaArribo.split('T')[0];
      } else {
        isEstimada = true;
        end = new Date(start);
        const duracion = marea.diasEstimados || 30;
        end.setDate(end.getDate() + Math.max(duracion - 1, 0));
        prevEndStr =
          end.getFullYear() +
          '-' +
          String(end.getMonth() + 1).padStart(2, '0') +
          '-' +
          String(end.getDate()).padStart(2, '0');
      }

      const etapaLabel =
        hasMultipleEtapas && !etapa.isDummy ? ` E${etapa.nroEtapa}` : '';
      const label = `${baseCode}${etapaLabel}`;

      // Determinar estado del subtítulo
      const estadoCodigo = marea.estadoActual?.codigo || '';
      let sublabel = marea.estadoActual?.nombre || '';
      if (estadoCodigo === 'EN_EJECUCION') {
        sublabel = isPrincipal ? 'En ejecución' : 'En ejecución (Secundario)';
      } else if (
        etapa.fechaArribo ||
        ['CERRADA', 'FINALIZADA', 'EVALUACION'].some(c => estadoCodigo.includes(c))
      ) {
        sublabel = isPrincipal ? 'Finalizada' : 'Finalizada (Secundario)';
      } else if (isDesignada && !isPrincipal) {
        sublabel = 'Designada (Secundario)';
      }

      const pesqueria = etapa.pesqueria?.nombre || marea.pesqueria?.nombre || '';
      const flota = marea.buque?.tipoFlota?.nombre || '';
      const pesqueriaFlota = [pesqueria, flota].filter(Boolean).join(' - ');
      const buque = marea.buque?.nombreBuque || '';

      // Registrar para conflicto
      registrarDiasEnConteo(start, end, datesCount);

      // Determinar tipo de bloque de marea
      let tipo: EventoObservador['tipo'] = 'MAREA_FINALIZADA';
      if (isDesignada) {
        tipo = 'MAREA_DESIGNADA';
      } else if (estadoCodigo === 'EN_EJECUCION') {
        tipo = 'MAREA_EJECUCION';
      }

      // Mismo patrón que ObservadorCalendar: si la marea es estimada y llega al
      // futuro, se parte en pasado (color sólido) y futuro (color estimado/rayado)
      if (isEstimada && end >= todayNorm) {
        if (start < todayNorm) {
          // Parte pasada: sólido
          const actualEnd = new Date(todayNorm);
          eventos.push({
            id: `mar-${etapa.id}-past`,
            tipo,
            start,
            end: actualEnd,
            label,
            sublabel,
            novedad: undefined,
            marea,
            etapa,
            isEstimada: false,
            isFuturo: false,
          });

          // Parte futura: estimada
          const futureStart = new Date(todayNorm);
          futureStart.setDate(futureStart.getDate() + 1);
          if (futureStart <= end) {
            eventos.push({
              id: `mar-${etapa.id}-future`,
              tipo,
              start: futureStart,
              end,
              label,
              sublabel: 'Proyectado',
              novedad: undefined,
              marea,
              etapa,
              isEstimada: true,
              isFuturo: true,
            });
          }
        } else {
          // Todo en el futuro
          eventos.push({
            id: `mar-${etapa.id}`,
            tipo,
            start,
            end,
            label,
            sublabel: 'Proyectado',
            novedad: undefined,
            marea,
            etapa,
            isEstimada: true,
            isFuturo: true,
          });
        }
      } else {
        eventos.push({
          id: `mar-${etapa.id}`,
          tipo,
          start,
          end,
          label,
          sublabel,
          novedad: undefined,
          marea,
          etapa,
          isEstimada,
          isFuturo: false,
        });
      }
    });
  });

  // ── 2.5. Huecos virtuales de VIAJE (En tránsito) ────────────────────────────
  // Misma lógica que ObservadorCalendar: rellena el gap entre aviso de viaje
  // y la zarpada/arribo real si el hueco es ≤ MAX_HUECO_VIAJE_DIAS.
  novedadesActivas.forEach(novedad => {
    const code = novedad.tipoNovedad?.codigo?.toUpperCase() || '';

    if (code === 'VIAJE_INICIO') {
      const novedadEndStr = novedad.fechaFin
        ? novedad.fechaFin.split('T')[0]
        : novedad.fechaInicio.split('T')[0];
      const novedadEnd = new Date(novedadEndStr + 'T00:00:00');

      let nearestZarpada: Date | null = null;
      mareas.forEach((marea: any) => {
        const isPrincipal = !observadorId || marea.observadorPrincipalId === observadorId;
        const allEtapas: any[] = marea.etapas && marea.etapas.length > 0 ? marea.etapas : [];
        const etapas: any[] = isPrincipal
          ? allEtapas
          : allEtapas.filter((e: any) => (e.observadores || []).some((o: any) => (o.observadorId || o.id) === observadorId));

        const sortedEtapas = [...etapas].sort(
          (a, b) => (a.nroEtapa || 0) - (b.nroEtapa || 0)
        );
        const primeraEtapa = sortedEtapas[0];
        if (!primeraEtapa?.fechaZarpada) return;

        const zarpadaDate = new Date(primeraEtapa.fechaZarpada.split('T')[0] + 'T00:00:00');
        if (zarpadaDate <= novedadEnd) return;

        const diffDias = Math.round(
          (zarpadaDate.getTime() - novedadEnd.getTime()) / (1000 * 60 * 60 * 24)
        );
        if (diffDias > MAX_HUECO_VIAJE_DIAS + 1) return;

        if (!nearestZarpada || zarpadaDate < nearestZarpada) {
          nearestZarpada = zarpadaDate;
        }
      });

      if (nearestZarpada) {
        const gapStart = new Date(novedadEnd);
        gapStart.setDate(gapStart.getDate() + 1);
        const gapEnd = new Date(nearestZarpada as Date);
        gapEnd.setDate(gapEnd.getDate() - 1);

        if (gapStart <= gapEnd) {
          eventos.push({
            id: `viaje-inicio-gap-${novedad.id}`,
            tipo: 'VIRTUAL_TRANSITO',
            start: gapStart,
            end: gapEnd,
            label: 'En tránsito',
            sublabel: 'Período entre aviso de inicio y zarpada real',
            novedad,
          });
        }
      }
    } else if (code === 'VIAJE_FIN') {
      const novedadStartStr = novedad.fechaInicio.split('T')[0];
      const novedadStart = new Date(novedadStartStr + 'T00:00:00');

      let nearestArribo: Date | null = null;
      mareas.forEach((marea: any) => {
        const isPrincipal = !observadorId || marea.observadorPrincipalId === observadorId;
        const allEtapas: any[] = marea.etapas && marea.etapas.length > 0 ? marea.etapas : [];
        const etapas: any[] = isPrincipal
          ? allEtapas
          : allEtapas.filter((e: any) => (e.observadores || []).some((o: any) => (o.observadorId || o.id) === observadorId));

        const sortedEtapas = [...etapas].sort(
          (a, b) => (b.nroEtapa || 0) - (a.nroEtapa || 0)
        );
        const ultimaEtapa = sortedEtapas[0];
        if (!ultimaEtapa?.fechaArribo) return;

        const arriboDate = new Date(ultimaEtapa.fechaArribo.split('T')[0] + 'T00:00:00');
        if (arriboDate >= novedadStart) return;

        const diffDias = Math.round(
          (novedadStart.getTime() - arriboDate.getTime()) / (1000 * 60 * 60 * 24)
        );
        if (diffDias > MAX_HUECO_VIAJE_DIAS + 1) return;

        if (!nearestArribo || arriboDate > nearestArribo) {
          nearestArribo = arriboDate;
        }
      });

      if (nearestArribo) {
        const gapStart = new Date(nearestArribo as Date);
        gapStart.setDate(gapStart.getDate() + 1);
        const gapEnd = new Date(novedadStart);
        gapEnd.setDate(gapEnd.getDate() - 1);

        if (gapStart <= gapEnd) {
          eventos.push({
            id: `viaje-fin-gap-${novedad.id}`,
            tipo: 'VIRTUAL_TRANSITO',
            start: gapStart,
            end: gapEnd,
            label: 'En tránsito',
            sublabel: 'Período entre arribo real y aviso de fin de viaje',
            novedad,
          });
        }
      }
    }
  });

  // ── 3. Huecos virtuales de "No Disponible" ──────────────────────────────────
  // Misma lógica que ObservadorCalendar: si existe una novedad DISPONIBLE y hay
  // eventos anteriores con un hueco vacío, se genera un bloque "No Disponible"
  // virtual para cubrir ese hueco.
  disponibilidadEvents.forEach(disp => {
    let maxEnd = new Date(0);
    eventos.forEach(ev => {
      if (ev.start < disp.start) {
        if (ev.end > maxEnd) {
          maxEnd = new Date(ev.end);
        }
      }
    });

    if (maxEnd.getTime() > 0 && maxEnd < disp.start) {
      const gapStart = new Date(maxEnd);
      gapStart.setDate(gapStart.getDate() + 1);

      const gapEnd = new Date(disp.start);
      gapEnd.setDate(gapEnd.getDate() - 1);

      if (gapStart <= gapEnd) {
        eventos.push({
          id: `virtual-no-disp-${disp.novedad.id}`,
          tipo: 'VIRTUAL_NO_DISPONIBLE',
          start: gapStart,
          end: gapEnd,
          label: 'No Disponible',
          sublabel: 'Asumido automáticamente hasta disponibilidad',
          novedad: {
            ...disp.novedad,
            tipoNovedad: {
              ...disp.novedad.tipoNovedad,
              descripcion: 'No Disponible',
            },
          },
        });
      }
    }
  });

  // ── 4. Capa de Conflictos ────────────────────────────────────────────────────
  const overlappingDates = Object.keys(datesCount).filter(
    date => datesCount[date] > 1
  );
  if (overlappingDates.length > 0) {
    // Un único "evento de conflicto" que contiene todas las fechas solapadas.
    // Los adaptadores decidirán cómo representarlo (v-calendar: un atributo por
    // lista de fechas; vis-timeline: un item por fecha o rango contiguo).
    overlappingDates.forEach(dateStr => {
      const d = new Date(dateStr + 'T00:00:00');
      eventos.push({
        id: `conflicto-${dateStr}`,
        tipo: 'CONFLICTO',
        start: d,
        end: d,
        label: 'Conflicto',
      });
    });
  }

  return eventos;
}

// ─── Adaptador: V-Calendar ────────────────────────────────────────────────────

/**
 * Convierte la lista de EventoObservador en atributos de v-calendar.
 * La salida es idéntica a la que producía el computed `calendarAttributes` de
 * ObservadorCalendar.vue.
 *
 * NOTA: Los eventos de tipo CONFLICTO se agrupan en un único atributo al final
 * para preservar el comportamiento original (una sola capa de highlight rojo).
 */
export function toVCalendarAttributes(
  eventos: EventoObservador[]
): any[] {
  const attrs: any[] = [];
  const conflictDates: Date[] = [];

  for (const ev of eventos) {
    if (ev.tipo === 'CONFLICTO') {
      conflictDates.push(ev.start);
      continue;
    }

    if (ev.tipo === 'VIRTUAL_NO_DISPONIBLE') {
      attrs.push({
        key: ev.id,
        customData: {
          tipoEvento: 'NOVEDAD',
          novedad: ev.novedad,
          titulo: ev.label,
          subtitulo: ev.sublabel,
        },
        dates: { start: ev.start, end: ev.end },
        highlight: {
          class: 'calendar-no-disponible',
          contentClass: 'calendar-no-disponible-text',
        },
        popover: { visibility: 'hover' as const, isInteractive: true },
      });
      continue;
    }

    if (ev.tipo === 'VIRTUAL_TRANSITO') {
      attrs.push({
        key: ev.id,
        customData: {
          tipoEvento: 'NOVEDAD',
          novedad: ev.novedad,
          titulo: ev.label,
          subtitulo: ev.sublabel,
        },
        dates: { start: ev.start, end: ev.end },
        highlight: {
          class: 'calendar-novedad',
          contentClass: 'calendar-novedad-text',
        },
        popover: { visibility: 'hover' as const, isInteractive: true },
      });
      continue;
    }

    if (ev.tipo === 'NOVEDAD') {
      const code = ev.codigoNovedad || '';
      const isFranco = code === 'FC' || code.includes('FRANCO');
      const isDisponible = code === 'DISPONIBLE';
      const isNoDisponible = code === 'NO_DISPONIBLE';

      let highlightClass = 'calendar-novedad';
      let textClass = 'calendar-novedad-text';
      if (isFranco) {
        highlightClass = 'calendar-franco';
        textClass = 'calendar-franco-text';
      } else if (isDisponible) {
        highlightClass = 'calendar-disponible';
        textClass = 'calendar-disponible-text';
      } else if (isNoDisponible) {
        highlightClass = 'calendar-no-disponible';
        textClass = 'calendar-no-disponible-text';
      }

      attrs.push({
        key: ev.id,
        customData: {
          tipoEvento: 'NOVEDAD',
          novedad: ev.novedad,
          titulo: ev.novedad?.tipoNovedad?.descripcion || ev.label,
        },
        dates: { start: ev.start, end: ev.end },
        highlight: { class: highlightClass, contentClass: textClass },
        popover: { visibility: 'hover' as const, isInteractive: true },
      });
      continue;
    }

    // Mareas
    if (
      ev.tipo === 'MAREA_FINALIZADA' ||
      ev.tipo === 'MAREA_EJECUCION' ||
      ev.tipo === 'MAREA_DESIGNADA'
    ) {
      const isDesignada = ev.tipo === 'MAREA_DESIGNADA';

      let normalClass = 'calendar-marea';
      let normalTextClass = 'calendar-marea-text';
      let estimadaClass = 'calendar-marea-estimada';
      let estimadaTextClass = 'calendar-marea-estimada-text';

      if (isDesignada) {
        normalClass = 'calendar-marea-designada';
        normalTextClass = 'calendar-marea-designada-text';
        estimadaClass = 'calendar-marea-designada-estimada';
        estimadaTextClass = 'calendar-marea-designada-estimada-text';
      }

      const highlightClass = ev.isFuturo ? estimadaClass : normalClass;
      const textClass = ev.isFuturo ? estimadaTextClass : normalTextClass;

      const estadoCodigo = ev.marea?.estadoActual?.codigo || '';
      const pesqueria = ev.etapa?.pesqueria?.nombre || ev.marea?.pesqueria?.nombre || '';
      const flota = ev.marea?.buque?.tipoFlota?.nombre || '';
      const pesqueriaFlota = [pesqueria, flota].filter(Boolean).join(' - ');
      const buque = ev.marea?.buque?.nombreBuque || '';

      attrs.push({
        key: ev.id,
        customData: {
          tipoEvento: 'MAREA',
          marea: ev.marea,
          etapa: ev.etapa,
          titulo: ev.label,
          buque,
          pesqueriaFlota,
          estadoLabel: ev.sublabel,
        },
        dates: { start: ev.start, end: ev.end },
        highlight: { class: highlightClass, contentClass: textClass },
        popover: { visibility: 'hover' as const, isInteractive: true },
      });
      continue;
    }
  }

  // Añadir capa de conflicto (un único atributo con todas las fechas solapadas)
  if (conflictDates.length > 0) {
    attrs.push({
      key: 'overlaps-layer',
      dates: conflictDates,
      highlight: {
        class: 'calendar-conflicto',
        contentClass: 'calendar-conflicto-text',
      },
    });
  }

  return attrs;
}

// ─── Adaptador: Vis-Timeline ──────────────────────────────────────────────────

/**
 * Convierte la lista de EventoObservador en items de vis-timeline para un observador
 * específico dentro del Simulador de Cobertura.
 *
 * @param observadorId - ID del observador (usado como `group` en vis-timeline).
 * @param eventos - Salida de buildObservadorEventos().
 * @returns Array de items listos para DataSet de vis-timeline.
 */
export function toVisTimelineItems(
  observadorId: string,
  eventos: EventoObservador[]
): any[] {
  const items: any[] = [];
  // Prefijo para garantizar IDs únicos en el DataSet global (que combina
  // eventos de todos los observadores en un solo vis-timeline)
  const prefix = `obs-${observadorId}`;

  for (const ev of eventos) {
    if (ev.tipo === 'CONFLICTO') {
      // En vis-timeline el conflicto se representa como un item de 1 día por fecha solapada
      const endExclusive = new Date(ev.start);
      endExclusive.setDate(endExclusive.getDate() + 1);
      items.push({
        id: `${prefix}-${ev.id}`,
        group: observadorId,
        start: ev.start,
        end: endExclusive,
        content: 'Conflicto',
        className: 'vis-item-conflicto',
        editable: false,
        title: `<strong>Conflicto detectado:</strong> ${ev.start.toLocaleDateString('es-AR')}`,
      });
      continue;
    }

    if (ev.tipo === 'VIRTUAL_NO_DISPONIBLE') {
      const endExclusive = new Date(ev.end);
      endExclusive.setDate(endExclusive.getDate() + 1);
      items.push({
        id: `${prefix}-${ev.id}`,
        group: observadorId,
        start: ev.start,
        end: endExclusive,
        content: 'NO_DISP...',
        className: 'vis-item-no-disponible',
        editable: false,
        title: `<strong>${ev.label}</strong><br>${ev.sublabel || ''}`,
      });
      continue;
    }

    if (ev.tipo === 'VIRTUAL_TRANSITO') {
      const endExclusive = new Date(ev.end);
      endExclusive.setDate(endExclusive.getDate() + 1);
      items.push({
        id: `${prefix}-${ev.id}`,
        group: observadorId,
        start: ev.start,
        end: endExclusive,
        content: 'En tránsito',
        className: 'vis-item-novedad',
        editable: false,
        title: `<strong>${ev.label}</strong><br>${ev.sublabel || ''}`,
      });
      continue;
    }

    if (ev.tipo === 'NOVEDAD') {
      const code = ev.codigoNovedad || '';
      const isFranco = code === 'FC' || code.includes('FRANCO');
      const isDisponible = code === 'DISPONIBLE';
      const isNoDisponible = code === 'NO_DISPONIBLE';

      // En el simulador no graficamos los bloques de DISPONIBLE para mantener limpio el timeline
      // y dejar los espacios en blanco disponibles para ubicar mareas proyectadas.
      if (isDisponible) {
        continue;
      }

      let className = 'vis-item-novedad';
      let displayLabel = ev.label;

      if (isFranco) {
        className = 'vis-item-franco';
        displayLabel = 'FC';
      } else if (isNoDisponible) {
        className = 'vis-item-no-disponible';
        displayLabel = 'NO_DISP...';
      } else if (code.includes('VIAJE') || code === 'VIAJE_INICIO' || code === 'VIAJE_FIN') {
        className = 'vis-item-novedad';
        displayLabel = 'Viaje';
      } else {
        // Código corto (hasta ~6 chars) para novedades genéricas
        displayLabel = code ? code.substring(0, 6) : (ev.novedad?.tipoNovedad?.descripcion?.substring(0, 8) || 'Novedad');
      }

      const endExclusive = new Date(ev.end);
      endExclusive.setDate(endExclusive.getDate() + 1);

      items.push({
        id: `${prefix}-${ev.id}`,
        group: observadorId,
        start: ev.start,
        end: endExclusive,
        content: displayLabel,
        className,
        editable: false,
        title: `<strong>${ev.novedad?.tipoNovedad?.descripcion || ev.label}</strong><br>${ev.start.toLocaleDateString('es-AR')} – ${ev.end.toLocaleDateString('es-AR')}`,
      });
      continue;
    }

    // Mareas
    if (
      ev.tipo === 'MAREA_FINALIZADA' ||
      ev.tipo === 'MAREA_EJECUCION' ||
      ev.tipo === 'MAREA_DESIGNADA'
    ) {
      let className: string;
      if (ev.tipo === 'MAREA_DESIGNADA') {
        className = ev.isFuturo ? 'vis-item-navegando' : 'vis-item-designada';
      } else if (ev.tipo === 'MAREA_EJECUCION') {
        className = 'vis-item-ejecucion';
      } else {
        // MAREA_FINALIZADA - estimada futura usa vis-item-navegando (achurado)
        className = ev.isFuturo ? 'vis-item-navegando' : 'vis-item-navegando';
      }

      const durationDays =
        Math.round((ev.end.getTime() - ev.start.getTime()) / 86400000) + 1;
      const durStr = `[${durationDays}d]`;
      const content = `${ev.label} ${durStr} (${ev.sublabel || ''})`;

      const endExclusive = new Date(ev.end);
      endExclusive.setDate(endExclusive.getDate() + 1);

      items.push({
        id: `${prefix}-${ev.id}`,
        group: observadorId,
        start: ev.start,
        end: endExclusive,
        content,
        className,
        editable: false,
        title: `<strong>Inicio:</strong> ${ev.start.toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${ev.end.toLocaleDateString('es-AR')}`,
      });
      continue;
    }
  }

  return items;
}
