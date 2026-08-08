<template>
  <div v-if="!observadorId" class="flex-1 flex flex-col items-center justify-center text-text-muted">
    <CalendarIcon class="w-16 h-16 mb-4 opacity-20" />
    <p class="font-medium">Seleccione un observador para ver su calendario de novedades y mareas</p>
  </div>
  <div v-else class="flex-1 h-full calendar-container overflow-hidden">
    <VCalendar
      :key="observadorId || 'default'"
      :attributes="calendarAttributes"
      expanded
      transparent
      borderless
      locale="es"
      :first-day-of-week="2"
      :columns="calendarColumns"
      :initial-page="initialPage"
      class="custom-v-calendar h-full w-full"
    >
      <template #day-popover="{ attributes }">
        <div class="p-2 min-w-[200px]">
          <div class="text-xs font-bold text-text-muted mb-2 uppercase tracking-wider">Eventos</div>
          <div class="flex flex-col gap-1.5">
            <button
              v-for="attr in attributes.filter((a: any) => a.customData)"
              :key="attr.key"
              @click="handleEventClick(attr.customData)"
              class="w-full text-left p-2.5 rounded-lg border transition-colors flex items-center justify-between group"
              :class="{
                'border-primary/20 bg-primary/5 hover:bg-primary/10': attr.customData.tipoEvento === 'NOVEDAD',
                'border-orange-500/20 bg-orange-500/5 hover:bg-orange-500/10': attr.customData.tipoEvento === 'MAREA'
              }"
            >
              <div class="flex flex-col">
                <span class="font-semibold text-sm transition-colors"
                  :class="attr.customData.tipoEvento === 'NOVEDAD' ? 'text-primary group-hover:text-primary-focus' : 'text-orange-500 group-hover:text-orange-600'">
                  {{ attr.customData.titulo }}
                </span>
                <span v-if="attr.customData.subtitulo" class="text-[10px] text-text-muted mt-0.5">
                  {{ attr.customData.subtitulo }}
                </span>
              </div>
              <span v-if="attr.customData.tipoEvento === 'NOVEDAD'" class="text-[10px] bg-primary/10 text-primary px-1.5 py-0.5 rounded ml-2 shrink-0">Ver</span>
            </button>
          </div>
        </div>
      </template>
    </VCalendar>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';
import { CalendarIcon } from 'lucide-vue-next';
import { Calendar as VCalendar } from 'v-calendar';
import 'v-calendar/style.css';
import type { Novedad } from '../interfaces/novedad.interface';
import mareasService from '../../mareas/services/mareas.service';

const props = defineProps<{
  observadorId: string | null;
  novedades?: Novedad[];
}>();

const emit = defineEmits<{
  (e: 'eventClick', eventData: any): void;
}>();

const mareas = ref<any[]>([]);

// Responsiveness for calendar columns
const windowWidth = ref(window.innerWidth);
const updateWidth = () => {
  windowWidth.value = window.innerWidth;
};

onMounted(() => {
  window.addEventListener('resize', updateWidth);
});

onUnmounted(() => {
  window.removeEventListener('resize', updateWidth);
});

const calendarColumns = computed(() => {
  if (windowWidth.value >= 1280) return 3; // xl
  if (windowWidth.value >= 1024) return 2; // lg
  return 1;
});

const initialPage = computed(() => {
  const date = new Date();
  if (calendarColumns.value === 3) {
    date.setMonth(date.getMonth() - 1);
  }
  return { month: date.getMonth() + 1, year: date.getFullYear() };
});

const loadMareas = async () => {
  mareas.value = [];
  if (!props.observadorId) {
    return;
  }
  const currentId = props.observadorId;
  try {
    const data = await mareasService.getMareasByObservador(currentId);
    if (props.observadorId === currentId) {
      mareas.value = data;
    }
  } catch (error) {
    console.error('Error al cargar mareas del observador:', error);
    if (props.observadorId === currentId) {
      mareas.value = [];
    }
  }
};

watch(() => props.observadorId, () => {
  loadMareas();
}, { immediate: true });

const handleEventClick = (customData: any) => {
  if (customData.tipoEvento === 'NOVEDAD') {
    emit('eventClick', customData.novedad);
  }
};

const formatMareaCode = (marea: any): string => {
  const tipo = marea.tipoMarea || 'MC';
  const nro = marea.nroMarea || 0;
  const anioStr = marea.anioMarea ? String(marea.anioMarea).slice(-2) : '00';
  return `${tipo}-${nro}-${anioStr}`;
};

const calendarAttributes = computed(() => {
  const attrs: any[] = [];
  const datesCount: Record<string, number> = {};
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  // 1. Mapear Novedades
  const novedadesActivas = (props.novedades || []).filter(n => 
    n.observador?.id === props.observadorId && n.estadoAprobacion !== 'RECHAZADA'
  );

  novedadesActivas.forEach(novedad => {
    const startStr = novedad.fechaInicio.split('T')[0];
    let endStr = novedad.fechaFin ? novedad.fechaFin.split('T')[0] : null;

    if (!endStr) {
      const year = startStr.split('-')[0];
      endStr = `${year}-12-31`;
    }
    
    const start = new Date(startStr + 'T00:00:00');
    const end = new Date(endStr + 'T00:00:00');

    // Registrar para conflicto
    let current = new Date(start);
    while (current <= end) {
      const dateStr = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
      datesCount[dateStr] = (datesCount[dateStr] || 0) + 1;
      current.setDate(current.getDate() + 1);
    }

    const code = novedad.tipoNovedad?.codigo?.toUpperCase() || '';
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
      key: `nov-${novedad.id}`,
      customData: {
        tipoEvento: 'NOVEDAD',
        novedad,
        titulo: novedad.tipoNovedad?.descripcion || 'Novedad'
      },
      dates: { start, end },
      highlight: {
        class: highlightClass,
        contentClass: textClass,
      },
      popover: { visibility: 'hover' as const, isInteractive: true }
    });
  });

  // 2. Mapear Mareas
  mareas.value.forEach(marea => {
    const baseCode = formatMareaCode(marea);
    const isDesignadaMarea = marea.estadoActual?.codigo === 'DESIGNADA' || marea.estadoActual?.codigo === 'ESPERANDO_ZARPADA';
    
    let etapasToMap = marea.etapas && marea.etapas.length > 0 ? marea.etapas : [];
    
    if (etapasToMap.length === 0) {
      // Fallback para marea sin etapas (ej: designada)
      etapasToMap = [{
        id: marea.id,
        isDummy: true
      }];
    }

    const hasMultipleEtapas = etapasToMap.length > 1;
    let prevEndStr: string | null = null;

    etapasToMap.forEach((etapa: any) => {
      const mareaStart = etapa.fechaZarpada || marea.fechaZarpadaEstimada || marea.fechaInicioObservador;
      
      if (!mareaStart) return; // Sin fecha de inicio no podemos graficar

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
        const duracion = marea.diasEstimados || 30; // default 30 si no hay dato
        end.setDate(end.getDate() + Math.max(duracion - 1, 0));
        prevEndStr = end.getFullYear() + '-' + String(end.getMonth() + 1).padStart(2, '0') + '-' + String(end.getDate()).padStart(2, '0');
      }

      const etapaLabel = hasMultipleEtapas && !etapa.isDummy ? ` E${etapa.nroEtapa}` : '';
      const titulo = `${baseCode}${etapaLabel}`;
      
      // Determinar estado final para el subtitulo
      let estadoLabel = marea.estadoActual?.nombre || '';
      if (etapa.fechaArribo || ['CERRADA', 'FINALIZADA', 'EVALUACION'].some(c => marea.estadoActual?.codigo?.includes(c))) {
        estadoLabel = 'Finalizada';
      }

      const subtitulo = `${marea.buque?.nombreBuque || ''} - ${estadoLabel}`;

      // Determinar clases CSS
      let normalClass = 'calendar-marea';
      let normalTextClass = 'calendar-marea-text';
      let estimadaClass = 'calendar-marea-estimada';
      let estimadaTextClass = 'calendar-marea-estimada-text';

      if (isDesignadaMarea) {
        normalClass = 'calendar-marea-designada';
        normalTextClass = 'calendar-marea-designada-text';
        estimadaClass = 'calendar-marea-designada-estimada';
        estimadaTextClass = 'calendar-marea-designada-estimada-text';
      }

      // Registrar para conflicto
      let current = new Date(start);
      while (current <= end) {
        const dateStr = current.getFullYear() + '-' + String(current.getMonth() + 1).padStart(2, '0') + '-' + String(current.getDate()).padStart(2, '0');
        datesCount[dateStr] = (datesCount[dateStr] || 0) + 1;
        current.setDate(current.getDate() + 1);
      }

      const customData = {
        tipoEvento: 'MAREA',
        marea,
        etapa,
        titulo,
        subtitulo
      };

      const customDataProyectado = {
        ...customData,
        subtitulo: `${marea.buque?.nombreBuque || ''} - Proyectado`
      };

      if (isEstimada && end >= today) {
        if (start < today) {
          const actualEnd = new Date(today);
          const futureStart = new Date(today);
          futureStart.setDate(futureStart.getDate() + 1);

          attrs.push({
            key: `mar-${etapa.id}-past`,
            customData,
            dates: { start, end: actualEnd },
            highlight: { class: normalClass, contentClass: normalTextClass },
            popover: { visibility: 'hover' as const, isInteractive: true }
          });

          if (futureStart <= end) {
            attrs.push({
              key: `mar-${etapa.id}-future`,
              customData: customDataProyectado,
              dates: { start: futureStart, end },
              highlight: { class: estimadaClass, contentClass: estimadaTextClass },
              popover: { visibility: 'hover' as const, isInteractive: true }
            });
          }
        } else {
          attrs.push({
            key: `mar-${etapa.id}`,
            customData: customDataProyectado,
            dates: { start, end },
            highlight: { class: estimadaClass, contentClass: estimadaTextClass },
            popover: { visibility: 'hover' as const, isInteractive: true }
          });
        }
      } else {
        attrs.push({
          key: `mar-${etapa.id}`,
          customData,
          dates: { start, end },
          highlight: { class: normalClass, contentClass: normalTextClass },
          popover: { visibility: 'hover' as const, isInteractive: true }
        });
      }
    });
  });

  const overlappingDates = Object.keys(datesCount).filter(date => datesCount[date] > 1);
  if (overlappingDates.length > 0) {
    attrs.push({
      key: 'overlaps-layer',
      dates: overlappingDates.map(d => new Date(d + 'T00:00:00')),
      highlight: {
        class: 'calendar-conflicto',
        contentClass: 'calendar-conflicto-text'
      }
    });
  }

  return attrs;
});
</script>

<style>
/* Personalización de v-calendar */
.calendar-container {
  height: 100%;
}

.custom-v-calendar .vc-container {
  height: 100%;
  font-family: inherit;
  --vc-font-family: inherit;
  --vc-color-sky-100: #e0f2fe;
  --vc-color-sky-800: #075985;
}

.dark .custom-v-calendar .vc-container {
  --vc-color-sky-100: rgba(14, 165, 233, 0.3);
  --vc-color-sky-800: #bae6fd;
}

/* NOVEDADES */
.custom-v-calendar .calendar-novedad {
  background-color: #e0f2fe !important;
  box-shadow: inset 0 0 0 1px #7dd3fc !important;
}
.custom-v-calendar .calendar-novedad-text {
  color: black !important;
  font-weight: 600 !important;
}

.custom-v-calendar .calendar-no-disponible {
  background-color: #f3f4f6 !important; 
  box-shadow: inset 0 0 0 1px #d1d5db !important; 
}
.custom-v-calendar .calendar-no-disponible-text {
  color: black !important;
  font-weight: 600 !important;
}

.custom-v-calendar .calendar-disponible {
  background-color: #dcfce7 !important; 
  box-shadow: inset 0 0 0 1px #86efac !important; 
}
.custom-v-calendar .calendar-disponible-text {
  color: black !important;
  font-weight: 600 !important;
}

.custom-v-calendar .calendar-franco {
  background-color: #e0f2fe !important;
  box-shadow: inset 0 0 0 2px #ef4444 !important; 
}
.custom-v-calendar .calendar-franco-text {
  color: black !important;
  font-weight: 600 !important;
}

/* MAREAS */
.custom-v-calendar .calendar-marea {
  background-color: #ffedd5 !important; /* orange-100 */
  box-shadow: inset 0 0 0 1px #fdba74 !important; /* orange-300 */
}
.custom-v-calendar .calendar-marea-text {
  color: #c2410c !important; /* orange-700 */
  font-weight: 800 !important;
}

.custom-v-calendar .calendar-marea-estimada {
  background-color: transparent !important; 
  box-shadow: inset 0 0 0 1px rgba(253, 186, 116, 0.5) !important; 
  background-image: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(253, 186, 116, 0.15) 5px, rgba(253, 186, 116, 0.15) 10px) !important;
}
.custom-v-calendar .calendar-marea-estimada-text {
  color: #c2410c !important; 
  font-weight: 700 !important;
  opacity: 0.6 !important;
}

/* CONFLICTO */
.custom-v-calendar .calendar-conflicto {
  background-color: #ef4444 !important;
  box-shadow: inset 0 0 0 1px #b91c1c !important;
}
.custom-v-calendar .calendar-conflicto-text {
  color: white !important;
  font-weight: 600 !important;
}

/* DARK MODE */
.dark .custom-v-calendar .calendar-novedad {
  background-color: rgba(14, 165, 233, 0.3) !important;
  box-shadow: inset 0 0 0 1px rgba(14, 165, 233, 0.5) !important;
}
.dark .custom-v-calendar .calendar-novedad-text {
  color: #bae6fd !important;
}

.dark .custom-v-calendar .calendar-no-disponible {
  background-color: rgba(107, 114, 128, 0.3) !important;
  box-shadow: inset 0 0 0 1px rgba(107, 114, 128, 0.5) !important;
}
.dark .custom-v-calendar .calendar-no-disponible-text {
  color: #d1d5db !important; 
}

.dark .custom-v-calendar .calendar-disponible {
  background-color: rgba(34, 197, 94, 0.2) !important;
  box-shadow: inset 0 0 0 1px rgba(34, 197, 94, 0.4) !important;
}
.dark .custom-v-calendar .calendar-disponible-text {
  color: #bbf7d0 !important; 
}

.dark .custom-v-calendar .calendar-franco {
  background-color: rgba(14, 165, 233, 0.3) !important;
  box-shadow: inset 0 0 0 2px #f87171 !important;
}
.dark .custom-v-calendar .calendar-franco-text {
  color: #bae6fd !important; 
}

/* DARK MODE MAREAS */
.dark .custom-v-calendar .calendar-marea {
  background-color: rgba(249, 115, 22, 0.2) !important; /* orange-500 @ 20% */
  box-shadow: inset 0 0 0 1px rgba(249, 115, 22, 0.5) !important;
}
.dark .custom-v-calendar .calendar-marea-text {
  color: #fdba74 !important; /* orange-300 */
  font-weight: 800 !important;
}

.dark .custom-v-calendar .calendar-marea-estimada {
  background-color: transparent !important;
  box-shadow: inset 0 0 0 1px rgba(249, 115, 22, 0.2) !important;
  background-image: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(249, 115, 22, 0.1) 5px, rgba(249, 115, 22, 0.1) 10px) !important;
}
.dark .custom-v-calendar .calendar-marea-estimada-text {
  color: #fdba74 !important; 
  font-weight: 700 !important;
  opacity: 0.6 !important;
}

.dark .custom-v-calendar .calendar-conflicto {
  background-color: #991b1b !important;
  box-shadow: inset 0 0 0 1px #7f1d1d !important;
}
.dark .custom-v-calendar .calendar-conflicto-text {
  color: white !important;
}

.custom-v-calendar .vc-weekday {
  color: var(--color-text-muted) !important;
  font-weight: 600 !important;
  padding-bottom: 0.5rem !important;
  border-bottom: 1px solid var(--color-border) !important;
}

.custom-v-calendar .vc-day {
  min-height: 80px;
  border-bottom: 1px solid var(--color-border);
  border-right: 1px solid var(--color-border);
  padding: 4px;
}

.custom-v-calendar .vc-day:nth-child(7n) {
  border-right: none;
}

.custom-v-calendar .vc-pane-layout {
  height: 100%;
  width: 100%;
}

.custom-v-calendar .vc-pane {
  min-width: 0;
  width: 100%;
}

/* DESIGNADAS */
.custom-v-calendar .calendar-marea-designada {
  background-color: rgba(254, 240, 138, 0.5) !important; /* yellow-200 */
  box-shadow: inset 0 0 0 1px #eab308 !important; /* yellow-500 */
}
.custom-v-calendar .calendar-marea-designada-text {
  color: #854d0e !important; /* yellow-800 */
  font-weight: 800 !important;
}
.dark .custom-v-calendar .calendar-marea-designada {
  background-color: rgba(234, 179, 8, 0.2) !important; /* yellow-500 @ 20% */
  box-shadow: inset 0 0 0 1px rgba(234, 179, 8, 0.5) !important;
}
.dark .custom-v-calendar .calendar-marea-designada-text {
  color: #fef08a !important; /* yellow-200 */
  font-weight: 800 !important;
}

/* DESIGNADAS ESTIMADAS */
.custom-v-calendar .calendar-marea-designada-estimada {
  background-color: transparent !important;
  box-shadow: inset 0 0 0 1px rgba(234, 179, 8, 0.5) !important; 
  background-image: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(234, 179, 8, 0.15) 5px, rgba(234, 179, 8, 0.15) 10px) !important;
}
.custom-v-calendar .calendar-marea-designada-estimada-text {
  color: #854d0e !important; 
  font-weight: 700 !important;
  opacity: 0.6 !important;
}
.dark .custom-v-calendar .calendar-marea-designada-estimada {
  background-color: transparent !important;
  box-shadow: inset 0 0 0 1px rgba(234, 179, 8, 0.3) !important;
  background-image: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(234, 179, 8, 0.1) 5px, rgba(234, 179, 8, 0.1) 10px) !important;
}
.dark .custom-v-calendar .calendar-marea-designada-estimada-text {
  color: #fef08a !important; 
  font-weight: 700 !important;
  opacity: 0.6 !important;
}
</style>
