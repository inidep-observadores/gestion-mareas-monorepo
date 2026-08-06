<template>
  <div class="flex flex-col xl:flex-row gap-6 h-[calc(100vh-14rem)] min-h-[600px]">
    <!-- Columna Izquierda: Lista de Observadores -->
    <div class="w-full xl:w-72 shrink-0 flex flex-col bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
      <div class="p-4 border-b border-border bg-surface-muted/30">
        <div class="relative">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Buscar observador..."
            class="w-full pl-10 pr-4 py-2.5 bg-surface border border-border rounded-xl text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all text-text"
          />
          <SearchIcon class="absolute left-3.5 top-3 w-4 h-4 text-text-muted" />
        </div>
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
      <div v-else class="flex-1 h-full calendar-container">
        <FullCalendar :options="calendarOptions" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { SearchIcon, CalendarIcon } from 'lucide-vue-next';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import esLocale from '@fullcalendar/core/locales/es';
import observadoresApi from '../services/observadores.service';
import type { Observador } from '../interfaces/observador.interface';
import type { Novedad } from '../interfaces/novedad.interface';

const props = defineProps<{
  novedades: Novedad[];
}>();

const emit = defineEmits<{
  (e: 'eventClick', novedad: Novedad): void;
}>();

const observadores = ref<Observador[]>([]);
const isLoadingObservadores = ref(false);
const searchQuery = ref('');
const selectedObservador = ref<string | null>(null);

// Cargar observadores activos
onMounted(async () => {
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

// Función auxiliar para sumar 1 día a la fecha final (exclusiva en FullCalendar)
const addOneDay = (dateStr: string) => {
  // Asegurarse de usar la fecha local sin problemas de zona horaria
  const [year, month, day] = dateStr.split('T')[0].split('-').map(Number);
  const d = new Date(year, month - 1, day);
  d.setDate(d.getDate() + 1);
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
};

const calendarEvents = computed(() => {
  return novedadesObservadorSeleccionado.value.map(novedad => {
    const startStr = novedad.fechaInicio.split('T')[0];
    let endStr = novedad.fechaFin ? novedad.fechaFin.split('T')[0] : null;

    // Si no hay fecha de fin, usar el 31 de diciembre del año de inicio como fin virtual
    if (!endStr) {
      const year = startStr.split('-')[0];
      endStr = `${year}-12-31`;
    }

    return {
      id: novedad.id,
      title: novedad.tipoNovedad?.descripcion || 'Novedad',
      start: startStr,
      // FullCalendar "end" es exclusivo. Si abarca varios días, sumamos 1 día.
      end: endStr && endStr !== startStr ? addOneDay(endStr) : undefined,
      allDay: true,
      classNames: ['novedad-calendar-event'],
      extendedProps: {
        novedad
      }
    };
  });
});

const handleEventClick = (info: any) => {
  const novedad = info.event.extendedProps.novedad;
  emit('eventClick', novedad);
};

const calendarOptions = ref({
  plugins: [dayGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth',
  locale: esLocale,
  events: calendarEvents.value,
  eventClick: handleEventClick,
  dayMaxEvents: 2, // Mostrar hasta 2 eventos antes del "+X más"
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: ''
  },
  height: '100%',
  eventClassNames: 'cursor-pointer rounded shadow-sm font-bold text-xs border-none',
  moreLinkClassNames: 'font-bold text-primary hover:underline bg-primary/10 rounded px-1',
});

// FullCalendar en Vue 3 sufre de glitches (como eventos que colapsan en hover) 
// si se usa un computed() para todo el objeto options. Lo correcto es actualizar la propiedad events reactivamente.
watch(calendarEvents, (newEvents) => {
  calendarOptions.value.events = newEvents;
}, { deep: true });

</script>

<style>
/* Personalización de FullCalendar para adaptarlo al theme de la aplicación */
.calendar-container {
  --fc-border-color: var(--color-border);
  --fc-button-bg-color: var(--color-surface);
  --fc-button-border-color: var(--color-border);
  --fc-button-text-color: var(--color-text);
  --fc-button-hover-bg-color: var(--color-surface-muted);
  --fc-button-hover-border-color: var(--color-primary);
  --fc-button-active-bg-color: var(--color-primary);
  --fc-button-active-border-color: var(--color-primary);
  --fc-button-active-text-color: white;
  --fc-event-bg-color: var(--color-primary);
  --fc-event-border-color: var(--color-primary);
  --fc-today-bg-color: rgba(var(--color-primary-rgb), 0.05);
  --fc-page-bg-color: var(--color-surface);
  --fc-neutral-bg-color: var(--color-surface);
  --fc-neutral-text-color: var(--color-text);
  --fc-theme-standard-border-color: var(--color-border);
}

.fc-theme-standard .fc-scrollgrid {
  border-radius: 0.5rem;
  overflow: hidden;
  border: 1px solid var(--color-border);
}

.fc .fc-button-primary:not(:disabled).fc-button-active, 
.fc .fc-button-primary:not(:disabled):active {
  background-color: var(--fc-button-active-bg-color, #000);
  border-color: var(--fc-button-active-border-color, #000);
}

.fc-daygrid-event {
  border-radius: 4px;
  padding: 2px 4px;
}

/* Colores idénticos a los de Presentismo */
.novedad-calendar-event,
.novedad-calendar-event:hover {
  background-color: #e0f2fe !important;
  color: black !important;
  border-color: #7dd3fc !important;
  border-width: 2px !important;
  border-style: solid !important;
  display: block !important;
  width: 100% !important;
  z-index: 1 !important; /* Previene el cambio de z-index de FullCalendar en hover que causa colapso en layout flex/grid */
}

.dark .novedad-calendar-event,
.dark .novedad-calendar-event:hover {
  background-color: rgba(14, 165, 233, 0.3) !important;
  color: #bae6fd !important;
  border-color: rgba(14, 165, 233, 0.5) !important;
}
</style>
