<template>
  <div v-if="!observadorId" class="flex-1 flex flex-col items-center justify-center text-text-muted">
    <CalendarIcon class="w-16 h-16 mb-4 opacity-20" />
    <p class="font-medium">Seleccione un observador para ver su calendario de novedades y mareas</p>
  </div>
  <div v-else class="flex-1 calendar-container overflow-y-auto" ref="calendarContainerRef">
    <VCalendar
      :key="observadorId || 'default'"
      :attributes="calendarAttributes"
      expanded
      transparent
      borderless
      locale="es"
      :first-day-of-week="2"
      :columns="1"
      :rows="calendarRange.rows"
      :initial-page="calendarRange.initialPage"
      class="custom-v-calendar w-full"
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
                  <!-- Si es novedad, usamos subtitulo normal -->
                  <span v-if="attr.customData.tipoEvento === 'NOVEDAD' && attr.customData.subtitulo" class="text-[10px] text-text-muted mt-0.5">
                    {{ attr.customData.subtitulo }}
                  </span>
                  
                  <!-- Si es marea, mostramos por lineas -->
                  <template v-else-if="attr.customData.tipoEvento === 'MAREA'">
                    <span v-if="attr.customData.buque" class="text-[10px] text-text-muted mt-0.5 font-medium">
                      {{ attr.customData.buque }}
                    </span>
                    <span v-if="attr.customData.pesqueriaFlota" class="text-[10px] text-text-muted mt-0.5">
                      {{ attr.customData.pesqueriaFlota }}
                    </span>
                    <span v-if="attr.customData.estadoLabel" class="text-[10px] text-text-muted mt-0.5">
                      {{ attr.customData.estadoLabel }}
                    </span>
                  </template>
              </div>
              <span v-if="attr.customData.tipoEvento === 'NOVEDAD'" class="text-[10px] bg-primary/10 text-primary px-1.5 py-0.5 rounded ml-2 shrink-0">Ver</span>
              <span v-else-if="attr.customData.tipoEvento === 'MAREA'" class="text-[10px] bg-orange-500/10 text-orange-500 px-1.5 py-0.5 rounded ml-2 shrink-0">Ver</span>
            </button>
          </div>
        </div>
      </template>
    </VCalendar>
  </div>

  <BaseModal
    v-if="props.detailMode === 'modal'"
    :show="showDetailModal"
    title="Detalle de Novedad"
    @close="handleModalClose"
    maxWidth="3xl"
  >
    <div class="p-0 bg-surface-muted/30 max-h-[80vh] overflow-y-auto">
      <NovedadContextDetailContent 
        v-if="selectedNovedadForModal" 
        :novedad="selectedNovedadForModal" 
        :readonly="true"
        @close="handleModalClose"
      />
    </div>
  </BaseModal>

  <!-- Modal de detalle de Marea -->
  <MareaQuickDetailModal
    :is-open="showMareaModal"
    :marea-id="selectedMareaId"
    @close="handleMareaModalClose"
  />
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue';
import { CalendarIcon } from 'lucide-vue-next';
import { Calendar as VCalendar } from 'v-calendar';
import 'v-calendar/style.css';
import type { Novedad } from '../interfaces/novedad.interface';
import mareasService from '../../mareas/services/mareas.service';
import { novedadesService } from '../services/novedades.service';
import BaseModal from '@/components/common/BaseModal.vue';
import NovedadContextDetailContent from './NovedadContextDetailContent.vue';
import { useConfigStore } from '@/modules/shared/stores/config.store';
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue';
import { buildObservadorEventos, toVCalendarAttributes } from '@/modules/shared/utils/observador-events-engine';

interface Props {
  observadorId: string | null;
  novedades?: Novedad[];
  detailMode?: 'modal' | 'emit';
}

const props = withDefaults(defineProps<Props>(), {
  detailMode: 'modal'
});

const emit = defineEmits<{
  (e: 'eventClick', eventData: any): void;
}>();

const calendarContainerRef = ref<HTMLElement | null>(null);

const configStore = useConfigStore();
const mareas = ref<any[]>([]);
const internalNovedades = ref<Novedad[]>([]);

const calendarRange = computed(() => {
  let minDate = new Date();
  let maxDate = new Date();
  
  // Iniciar desde el 1 de enero del año operativo seleccionado
  const operativeYear = configStore.selectedYear;
  minDate = new Date(operativeYear, 0, 1);
  maxDate.setMonth(maxDate.getMonth() + 1);

  const updateMinMax = (dateStr: string | null | undefined) => {
    if (!dateStr) return;
    const date = new Date(dateStr);
    if (!isNaN(date.getTime())) {
      if (date < minDate) minDate = new Date(date);
      if (date > maxDate) maxDate = new Date(date);
    }
  };

  const sourceNovedades = props.novedades && props.novedades.length > 0 ? props.novedades : internalNovedades.value;
  const novedadesActivas = sourceNovedades.filter(n => 
    n.observador?.id === props.observadorId && n.estadoAprobacion === 'APROBADA' && n.activo !== false
  );

  novedadesActivas.forEach(n => {
    updateMinMax(n.fechaInicio);
    updateMinMax(n.fechaFin);
  });

  mareas.value.forEach(m => {
    updateMinMax(m.fechaZarpada);
    updateMinMax(m.fechaZarpadaEstimada);
    updateMinMax(m.fechaArribo);
    updateMinMax(m.fechaArriboEstimada);
    if (m.etapas && Array.isArray(m.etapas)) {
      m.etapas.forEach((e: any) => {
        updateMinMax(e.fechaZarpada);
        updateMinMax(e.fechaArribo);
        updateMinMax(e.fechaZarpadaEstimada);
      });
    }
  });

  const minYear = minDate.getFullYear();
  const minMonth = minDate.getMonth();
  const maxYear = maxDate.getFullYear();
  const maxMonth = maxDate.getMonth();

  let totalMonths = (maxYear - minYear) * 12 + (maxMonth - minMonth) + 1;
  
  // Añadir 1 mes de margen arriba y abajo para UX
  const finalMinDate = new Date(minYear, minMonth - 1, 1);
  totalMonths += 2;
  
  if (totalMonths < 3) totalMonths = 3;

  return {
    rows: totalMonths,
    initialPage: { month: finalMinDate.getMonth() + 1, year: finalMinDate.getFullYear() }
  };
});

const scrollToToday = () => {
  nextTick(() => {
    setTimeout(() => {
      if (calendarContainerRef.value) {
        const todayEl = calendarContainerRef.value.querySelector('.is-today');
        if (todayEl) {
          todayEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      }
    }, 300); // 300ms to allow rendering large numbers of rows
  });
};

const loadMareas = async () => {
  mareas.value = [];
  internalNovedades.value = [];
  if (!props.observadorId) {
    return;
  }
  const currentId = props.observadorId;
  try {
    const [dataMareas, dataNovedades] = await Promise.all([
      mareasService.getMareasByObservador(currentId),
      (!props.novedades || props.novedades.length === 0) ? novedadesService.getAll(currentId) : Promise.resolve([])
    ]);
    
    if (props.observadorId === currentId) {
      mareas.value = dataMareas;
      internalNovedades.value = dataNovedades;
      scrollToToday();
    }
  } catch (error) {
    console.error('Error al cargar datos del observador:', error);
    if (props.observadorId === currentId) {
      mareas.value = [];
      internalNovedades.value = [];
    }
  }
};

watch(() => props.observadorId, () => {
  loadMareas();
}, { immediate: true });

const showDetailModal = ref(false);
const selectedNovedadForModal = ref<Novedad | null>(null);

const showMareaModal = ref(false);
const selectedMareaId = ref<string | null>(null);

const handleEventClick = (customData: any) => {
  if (customData.tipoEvento === 'NOVEDAD') {
    if (props.detailMode === 'emit') {
      emit('eventClick', customData.novedad);
    } else {
      selectedNovedadForModal.value = customData.novedad;
      showDetailModal.value = true;
    }
  } else if (customData.tipoEvento === 'MAREA') {
    selectedMareaId.value = customData.marea?.id || null;
    showMareaModal.value = true;
  }
};

const handleModalClose = () => {
  showDetailModal.value = false;
  selectedNovedadForModal.value = null;
};

const handleMareaModalClose = () => {
  showMareaModal.value = false;
  selectedMareaId.value = null;
};

const calendarAttributes = computed(() => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const sourceNovedades =
    props.novedades && props.novedades.length > 0
      ? props.novedades
      : internalNovedades.value;

  const novedadesActivas = sourceNovedades.filter(
    n =>
      n.observador?.id === props.observadorId &&
      n.estadoAprobacion === 'APROBADA' &&
      n.activo !== false
  );

  const eventos = buildObservadorEventos(novedadesActivas, mareas.value, today, props.observadorId);
  return toVCalendarAttributes(eventos);
});
</script>

<style>
/* Personalización de v-calendar */
.calendar-container {
  min-height: 100%;
}

.custom-v-calendar .vc-container {
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
  background-color: #fee2e2 !important; 
  box-shadow: inset 0 0 0 1px #fca5a5 !important; 
}
.custom-v-calendar .calendar-no-disponible-text {
  color: #991b1b !important;
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

.custom-v-calendar {
  font-family: inherit !important;
  background-color: transparent !important;
  touch-action: pan-y !important; /* Habilitar scroll en móviles */
}

/* Habilitar scroll en los contenedores internos de v-calendar */
.custom-v-calendar .vc-pane-layout,
.custom-v-calendar .vc-pane,
.custom-v-calendar .vc-header,
.custom-v-calendar .vc-weeks {
  touch-action: pan-y !important;
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
  background-color: rgba(239, 68, 68, 0.2) !important;
  box-shadow: inset 0 0 0 1px rgba(239, 68, 68, 0.4) !important;
}
.dark .custom-v-calendar .calendar-no-disponible-text {
  color: #fca5a5 !important; 
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

/* Ocultar flechas de navegación del header (saltan de a muchos años) */
.custom-v-calendar .vc-arrow {
  display: none !important;
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
