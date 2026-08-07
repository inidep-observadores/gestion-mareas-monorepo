<template>
  <div class="flex flex-col xl:flex-row gap-6 h-[calc(100vh-14rem)] min-h-[600px]">
    <!-- Columna Izquierda: Lista de Observadores -->
    <div class="w-full xl:w-72 shrink-0 flex flex-col bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
      <div class="p-4 border-b border-border bg-surface-muted/30">
        <SearchInput
          v-model="searchQuery"
          placeholder="Buscar observador..."
        />
      </div>
      
      <div class="flex-1 overflow-y-auto p-2">
        <div v-if="isLoadingObservadores" class="flex justify-center p-8">
          <div class="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
        </div>
        <div v-else-if="filteredObservadores.length === 0" class="text-center p-8 text-sm text-text-muted">
          No se encontraron observadores.
        </div>
        <div v-else class="space-y-1">
          <button
            v-for="obs in filteredObservadores"
            :key="obs.id"
            @click="selectedObservador = obs.id"
            class="w-full flex items-center gap-3 p-3 rounded-xl transition-all text-left"
            :class="selectedObservador === obs.id 
              ? 'bg-primary/10 text-primary font-bold' 
              : 'hover:bg-surface-muted/50 text-text'"
          >
            <div class="flex-1 min-w-0">
              <div class="truncate">{{ obs.apellido }}, {{ obs.nombre }}</div>
              <div class="text-[10px] opacity-70 truncate">{{ obs.codigoInterno }}</div>
            </div>
          </button>
        </div>
      </div>
    </div>

    <!-- Columna Derecha: Calendario -->
    <div class="flex-1 min-w-0 bg-surface border border-border rounded-2xl shadow-sm p-4 xl:p-6 overflow-hidden flex flex-col">
      <div v-if="!selectedObservador" class="flex-1 flex flex-col items-center justify-center text-text-muted">
        <CalendarIcon class="w-16 h-16 mb-4 opacity-20" />
        <p class="font-medium">Seleccione un observador para ver su calendario de novedades</p>
      </div>
      <div v-else-if="novedadesObservadorSeleccionado.length === 0" class="flex-1 flex flex-col items-center justify-center text-text-muted">
        <CalendarIcon class="w-16 h-16 mb-4 opacity-20" />
        <p class="font-medium text-lg text-text">Sin novedades registradas</p>
        <p class="text-sm mt-1">Este observador no tiene novedades cargadas en el sistema.</p>
      </div>
      <div v-else class="flex-1 h-full calendar-container overflow-hidden">
        <VCalendar
          :key="selectedObservador || 'default'"
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
              <div class="text-xs font-bold text-text-muted mb-2 uppercase tracking-wider">Novedades</div>
              <div class="flex flex-col gap-1.5">
                <button
                  v-for="attr in attributes"
                  :key="attr.key"
                  @click="handleEventClick(attr.customData)"
                  class="w-full text-left p-2.5 rounded-lg border border-primary/20 bg-primary/5 hover:bg-primary/10 transition-colors flex items-center justify-between group"
                >
                  <span class="font-semibold text-sm text-primary group-hover:text-primary-focus transition-colors">
                    {{ attr.customData.tipoNovedad?.descripcion || 'Novedad' }}
                  </span>
                  <span class="text-[10px] bg-primary/10 text-primary px-1.5 py-0.5 rounded ml-2">Ver</span>
                </button>
              </div>
            </div>
          </template>
        </VCalendar>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { CalendarIcon } from 'lucide-vue-next';
import SearchInput from '@/components/ui/SearchInput.vue';
import { Calendar as VCalendar } from 'v-calendar';
import 'v-calendar/style.css';
import observadoresApi from '../services/observadores.service';
import type { Observador } from '../interfaces/observador.interface';
import type { Novedad } from '../interfaces/novedad.interface';

const props = defineProps<{
  novedades: Novedad[];
}>();

const emit = defineEmits<{
  (e: 'eventClick', novedad: Novedad): void;
  (e: 'observerChanged'): void;
}>();

const observadores = ref<Observador[]>([]);
const isLoadingObservadores = ref(false);
const searchQuery = ref('');
const selectedObservador = ref<string | null>(null);

watch(selectedObservador, () => {
  emit('observerChanged');
});

const windowWidth = ref(window.innerWidth);
const updateWidth = () => {
  windowWidth.value = window.innerWidth;
};

// Cargar observadores activos
onMounted(async () => {
  window.addEventListener('resize', updateWidth);
  isLoadingObservadores.value = true;
  try {
    observadores.value = await observadoresApi.getObservadores(false);
    if (observadores.value.length > 0) {
      selectedObservador.value = observadores.value[0].id;
    }
  } catch (error) {
    console.error('Error cargando observadores:', error);
  } finally {
    isLoadingObservadores.value = false;
  }
});

onUnmounted(() => {
  window.removeEventListener('resize', updateWidth);
});

const calendarColumns = computed(() => {
  if (windowWidth.value >= 1280) return 3; // xl o mayor
  if (windowWidth.value >= 1024) return 2; // lg
  return 1;
});

const initialPage = computed(() => {
  const date = new Date();
  if (calendarColumns.value === 3) {
    // Si hay 3 columnas, centrar el mes actual (por lo tanto, el panel izquierdo es el mes anterior)
    date.setMonth(date.getMonth() - 1);
  }
  return { month: date.getMonth() + 1, year: date.getFullYear() };
});

const filteredObservadores = computed(() => {
  if (!searchQuery.value) return observadores.value;
  const q = searchQuery.value.toLowerCase();
  return observadores.value.filter(o => 
    o.nombre.toLowerCase().includes(q) || 
    o.apellido.toLowerCase().includes(q) ||
    o.codigoInterno?.toString().includes(q)
  );
});

const novedadesObservadorSeleccionado = computed(() => {
  if (!selectedObservador.value) return [];
  return props.novedades.filter(n => n.observador?.id === selectedObservador.value && n.estadoAprobacion !== 'RECHAZADA');
});

const calendarAttributes = computed(() => {
  return novedadesObservadorSeleccionado.value.map(novedad => {
    const startStr = novedad.fechaInicio.split('T')[0];
    let endStr = novedad.fechaFin ? novedad.fechaFin.split('T')[0] : null;

    // Si no hay fecha de fin, usar el 31 de diciembre del año de inicio como fin virtual
    if (!endStr) {
      const year = startStr.split('-')[0];
      endStr = `${year}-12-31`;
    }

    return {
      key: novedad.id,
      customData: novedad,
      dates: { start: new Date(startStr + 'T00:00:00'), end: new Date(endStr + 'T00:00:00') },
      highlight: {
        color: 'sky',
        fillMode: 'light' as const,
      },
      popover: {
        visibility: 'hover',
        isInteractive: true, // Permite clickear los elementos del popover
      }
    };
  });
});

const handleEventClick = (novedad: Novedad) => {
  emit('eventClick', novedad);
};
</script>

<style>
/* Personalización de v-calendar para adaptarlo al theme de la aplicación */
.calendar-container {
  /* Hacemos que ocupe todo el alto disponible */
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

/* Modificamos los estilos de highlight nativos de v-calendar para que parezcan nuestras novedades */
.custom-v-calendar .vc-highlight {
  border-width: 2px !important;
  border-style: solid !important;
  border-color: #7dd3fc !important;
  border-radius: 4px !important;
}

.dark .custom-v-calendar .vc-highlight {
  border-color: rgba(14, 165, 233, 0.5) !important;
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
  min-width: 0; /* Previene desbordamientos en flex container */
  width: 100%; /* Forzar estiramiento */
}
</style>
