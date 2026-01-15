<template>
  <AdminLayout
    title="Calendario de Mareas"
    description="Vista cronológica de designaciones, arribos y eventos clave."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">

      <!-- Event Type Filters -->
      <FilterBar class="mb-4">
        <div class="flex flex-col gap-4">
          <div class="flex items-center justify-between">
            <h3 class="text-xs font-black uppercase tracking-widest text-text">
              Filtrar por Tipo de Evento
            </h3>
            <button
              @click="toggleAllFilters"
              class="text-xs font-black uppercase tracking-widest text-primary hover:text-primary-hover transition-all active:scale-95"
            >
              {{ allFiltersSelected ? 'Deseleccionar Todos' : 'Seleccionar Todos' }}
            </button>
          </div>
          <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-8 gap-2">
            <div
              v-for="eventType in eventTypes"
              :key="eventType.id"
              @click="eventType.enabled = !eventType.enabled"
              class="group relative flex flex-col p-3 rounded-2xl border transition-all cursor-pointer select-none bg-surface-muted overflow-hidden"
              :class="eventType.enabled
                ? 'border-primary/20 shadow-md shadow-primary/5 ring-1 ring-primary/5'
                : 'border-border opacity-50 grayscale-[0.8] hover:opacity-80'"
            >
              <!-- Label + Visibility -->
              <div class="flex items-center justify-between gap-2 mb-3">
                <span class="text-[8px] font-black uppercase tracking-[0.2em] text-text-muted opacity-60 truncate">
                  {{ eventType.label }}
                </span>
                <component
                  :is="eventType.enabled ? EyeIcon : EyeSlashIcon"
                  class="w-3.5 h-3.5 transition-colors"
                  :class="eventType.enabled ? 'text-primary' : 'text-text-muted'"
                />
              </div>

              <!-- Count + Icon Badge -->
              <div class="flex items-end justify-between">
                <span class="text-2xl font-black text-text leading-none tabular-nums tracking-tighter">
                  {{ eventCounts[eventType.id] || 0 }}
                </span>

                <div
                  class="w-8 h-8 flex items-center justify-center rounded-xl transition-all duration-300"
                  :class="eventType.enabled ? 'bg-primary/10 text-primary border border-primary/20 shadow-theme-xs shadow-primary/10' : 'bg-surface text-text-muted border border-border'"
                >
                  <component :is="eventType.icon" class="w-4 h-4" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </FilterBar>

      <!-- Calendar + Sidebar Container -->
      <div class="flex flex-col lg:flex-row gap-6 relative items-start">

        <div
          class="flex-1 min-w-0 bg-surface border border-border rounded-2xl p-6 shadow-sm transition-all duration-300 relative z-0 overflow-hidden"
        >
          <FullCalendar ref="calendarRef" :options="calendarOptions" class="mareas-calendar">
            <template #eventContent="arg">
              <div class="group relative w-full h-full p-1 cursor-pointer overflow-visible">
                <!-- Event Title -->
                <div class="truncate fc-event-title-container">
                  <span class="fc-event-time">{{ arg.timeText }}</span>
                  <span class="fc-event-title">{{ arg.event.title }}</span>
                </div>

                <!-- Custom Tooltip -->
                <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-1.5 px-2.5 py-1.5 text-[11px] text-primary-fg bg-text rounded-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 whitespace-normal min-w-[180px] max-w-[240px] z-[9999] shadow-theme-lg pointer-events-none backdrop-blur-sm bg-opacity-95">
                  <div class="font-black uppercase tracking-tight border-b border-primary-fg/10 mb-1 pb-1">
                    {{ arg.event.title }}
                  </div>
                  <div class="leading-relaxed opacity-90 font-medium">
                    {{ arg.event.extendedProps.description }}
                  </div>
                  <!-- Arrow -->
                  <div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-text"></div>
                </div>
              </div>
            </template>
          </FullCalendar>
        </div>

        <!-- Event Details Sidebar -->
        <Transition name="slide-in-right">
          <div
            v-if="selectedEvent"
            class="w-full lg:w-96 shrink-0 bg-surface border border-border rounded-2xl shadow-2xl sticky top-6 z-30"
          >
            <!-- Sidebar Header -->
            <div class="p-6 border-b border-border flex items-start justify-between">
              <div>
                <span
                  class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium uppercase tracking-wide mb-3"
                  :style="{
                    backgroundColor: `color-mix(in srgb, ${(CALENDAR_EVENT_COLORS as any)[selectedEvent.extendedProps?.type] || 'var(--color-text-muted)'} 10%, transparent)`,
                    color: (CALENDAR_EVENT_COLORS as any)[selectedEvent.extendedProps?.type] || 'var(--color-text-muted)'
                  }"
                >
                  <component :is="eventTypes.find(t => t.id === selectedEvent.extendedProps?.type)?.icon || FileTextIcon" class="w-3.5 h-3.5" />
                  {{ eventTypes.find(t => t.id === selectedEvent.extendedProps?.type)?.label || 'Evento' }}
                </span>
                <h3 class="text-lg font-black text-text leading-tight uppercase tracking-tight">
                  {{ selectedEvent.title }}
                </h3>
              </div>
              <button
                @click="selectedEvent = null"
                class="text-text-muted hover:text-text p-1 rounded-lg hover:bg-surface-muted transition-colors transition-all"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
              </button>
            </div>

            <!-- Sidebar Content -->
            <div class="p-6 space-y-6">
              <!-- Date -->
              <div>
                <p class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-1">Fecha y Hora</p>
                <div class="flex items-center gap-2 text-text font-black uppercase">
                  <CalenderIcon class="w-4 h-4 text-primary" />
                  <span>
                    {{ selectedEvent.start?.toLocaleDateString('es-AR', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) }}
                  </span>
                </div>
                <!-- Time is omitted as full day usually, but can assume it's relevant if provided -->
              </div>

              <!-- Vessel (if applicable) -->
              <div v-if="selectedEvent.extendedProps?.vesselName">
                <p class="text-xs font-black uppercase tracking-widest text-text-muted mb-1">Buque</p>
                <div class="flex items-center gap-2 text-text font-black uppercase">
                  <ShipIcon class="w-4 h-4 text-primary" />
                  <span>{{ selectedEvent.extendedProps?.vesselName }}</span>
                </div>
              </div>

              <!-- Description -->
               <div>
                <p class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-1">Detalle</p>
                <p class="text-xs text-text leading-relaxed font-medium">
                   {{ selectedEvent.extendedProps?.description || 'Sin descripción adicional disponible.' }}
                </p>
              </div>
            </div>

            <!-- Sidebar Footer -->
            <div class="p-6 bg-surface-muted border-t border-border rounded-b-2xl">
               <button
                  v-if="selectedEvent.extendedProps?.mareaId"
                  @click="navigateToMarea"
                  class="w-full flex items-center justify-center gap-2 px-4 py-3 text-xs font-black uppercase tracking-widest text-primary-fg bg-primary hover:bg-primary-hover rounded-lg transition-all shadow-theme-xs shadow-primary/20 active:scale-95"
                >
                  <EyeIcon class="w-4 h-4" />
                  Ver Marea
                </button>
                <p v-else class="text-center text-xs text-text-muted font-bold uppercase tracking-widest opacity-60">
                  Sin enlace a marea
                </p>
            </div>
          </div>
        </Transition>
      </div>
    </div>

    <!-- Event Detail Modal (Removed) -->
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import FilterBar from '@/components/common/FilterBar.vue'
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import listPlugin from '@fullcalendar/list'
import esLocale from '@fullcalendar/core/locales/es'
import { CALENDAR_EVENT_COLORS } from '../config/calendarColors'
import mareasService, { type CalendarEvent } from '../services/mareas.service'

import {
  EyeIcon,
  EyeSlashIcon,
  FileTextIcon,
  ShipIcon,
  CheckIcon,
  WarningIcon,
  UserGroupIcon,
  WaveIcon,
  DocsIcon,
  CalenderIcon
} from '@/icons'

// Event type filters (Removed 'navegacion' and 'reunion')
const eventTypes = ref([
  {
    id: 'designacion',
    label: 'Designadas',
    icon: DocsIcon,
    enabled: true,
    keywords: ['Designación'],
  },
  { id: 'zarpada', label: 'Zarpadas', icon: ShipIcon, enabled: true, keywords: ['Zarpada'] },
  { id: 'arribo', label: 'Arribos', icon: ShipIcon, enabled: true, keywords: ['Arribo'] },
  { id: 'informe', label: 'Informes', icon: FileTextIcon, enabled: true, keywords: ['Informe'] },
  { id: 'validacion', label: 'Validadas', icon: CheckIcon, enabled: true, keywords: ['Validación'] },
  { id: 'alerta', label: 'Alertas', icon: WarningIcon, enabled: true, keywords: ['Alerta'] },
])

const allFiltersSelected = computed(() => eventTypes.value.every((type) => type.enabled))

// Calculate counts by event type
const eventCounts = computed(() => {
  const counts: Record<string, number> = {}
  allEvents.value.forEach((event) => {
    counts[event.type] = (counts[event.type] || 0) + 1
  })
  return counts
})

const toggleAllFilters = () => {
  const newState = !allFiltersSelected.value
  eventTypes.value.forEach((type) => (type.enabled = newState))
}

// All events data (Reactive)
const allEvents = ref<any[]>([])
const router = useRouter()

// Sidebar State (replaced Modal)
const selectedEvent = ref<any>(null)
const calendarRef = ref<any>(null)

// Update calendar size when sidebar opens/closes
watch(selectedEvent, () => {
  setTimeout(() => {
    calendarRef.value?.getApi().updateSize()
  }, 350) // Wait for sidebar transition to finish
})

const handleEventClick = (clickInfo: any) => {
  clickInfo.jsEvent.preventDefault()

  // Extract event data
  const event = clickInfo.event
  const clickedEventId = event.id

  // Toggle Logic
  if (selectedEvent.value?.id === clickedEventId) {
    selectedEvent.value = null // Close sidebar
  } else {
    // Open sidebar with new event
    selectedEvent.value = {
      id: event.id,
      title: event.title,
      start: event.start,
      end: event.end,
      extendedProps: event.extendedProps,
      allDay: event.allDay // Ensure this is captured
    }
  }
}


const navigateToMarea = () => {
  if (selectedEvent.value?.extendedProps?.mareaId) {
    router.push({
      name: 'marea-detalle',
      params: { id: selectedEvent.value.extendedProps.mareaId }
    })
  }
}


// Filtered events based on selected types
const filteredEvents = computed(() => {
  const enabledTypes = eventTypes.value.filter((t) => t.enabled).map((t) => t.id)
  return allEvents.value.filter((event) => enabledTypes.includes(event.type))
})

const calendarOptions = ref({
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin, listPlugin],
  initialView: 'dayGridMonth',
  locale: esLocale,
  firstDay: 0, // 0 = Domingo
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth',
  },
  buttonText: {
    today: 'Hoy',
    month: 'Mes',
    week: 'Semana',
    day: 'Día',
    list: 'Agenda',
  },
  events: filteredEvents.value, // Initial bind
  editable: false, // Read only for now
  selectable: true,
  selectMirror: true,
  dayMaxEvents: true,
  height: 'auto',
  themeSystem: 'standard',
  eventClick: handleEventClick,
})

const fetchEvents = async () => {
    try {
        const events = await mareasService.getCalendarEvents()
        allEvents.value = events.map((e: CalendarEvent) => ({
            ...e,
            color: (CALENDAR_EVENT_COLORS as any)[e.type] || '#94a3b8',
            textColor: 'var(--color-background)'
        }))
    } catch (error) {
        console.error('Error fetching calendar events:', error)
    }
}

// Watch for filter changes and update calendar events
watch(
  filteredEvents,
  (newEvents) => {
    calendarOptions.value.events = newEvents
  },
  { deep: true },
)

onMounted(() => {
    fetchEvents()
})
</script>

<style>
/* Estilos personalizados para integrar con el tema */
.mareas-calendar {
  --fc-border-color: var(--color-border);
  --fc-button-bg-color: var(--color-primary);
  --fc-button-border-color: var(--color-primary);
  --fc-button-hover-bg-color: var(--color-primary);
  --fc-button-active-bg-color: var(--color-primary);
  --fc-today-bg-color: var(--color-primary-muted, rgba(37, 99, 235, 0.05));
  --fc-page-bg-color: transparent;
  font-family: var(--font-outfit);
  --fc-text-color: var(--color-text);
}

.dark .mareas-calendar {
  --fc-border-color: var(--color-border);
  --fc-text-color: var(--color-text);
  --fc-neutral-bg-color: var(--color-surface);
  --fc-list-event-hover-bg-color: var(--color-surface-muted);
}

.fc .fc-toolbar-title {
  font-size: 1.125rem;
  line-height: 1.75rem;
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: -0.025em;
  color: var(--color-text);
}

.dark .fc .fc-toolbar-title {
  color: var(--color-white);
}

.fc .fc-col-header-cell-cushion {
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  font-size: 0.75rem;
  line-height: 1rem;
  font-weight: 700;
  color: var(--color-gray-500);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.fc .fc-daygrid-day-number {
  padding: 0.5rem;
  font-size: 0.875rem;
  line-height: 1.25rem;
  color: var(--color-gray-500);
}

.dark .fc .fc-daygrid-day-number {
  color: var(--color-gray-400);
}

.fc-theme-standard .fc-scrollgrid {
  border-color: var(--color-gray-200);
}

.dark .fc-theme-standard .fc-scrollgrid {
  border-color: var(--color-gray-800);
}

.fc-theme-standard td,
.fc-theme-standard th {
  border-color: var(--color-gray-200);
}

.dark .fc-theme-standard td,
.dark .fc-theme-standard th {
  border-color: var(--color-gray-800);
}

.mareas-calendar .fc-event {
  cursor: pointer;
}

.mareas-calendar .fc-event-title,
.mareas-calendar .fc-event-time,
.mareas-calendar .fc-list-event-title,
.mareas-calendar .fc-list-event-time {
  color: var(--color-text);
  font-weight: 800;
  text-transform: uppercase;
  font-size: 9px;
  letter-spacing: -0.01em;
}

/* Sidebar Transition */
.slide-in-right-enter-active,
.slide-in-right-leave-active {
  transition: all 0.3s ease-out;
}

.slide-in-right-enter-from,
.slide-in-right-leave-to {
  transform: translateX(20px);
  opacity: 0;
}

/* Asegurar que el tooltip sea visible pero sin romper la contención del calendario */
.fc .fc-view-harness {
  z-index: 1;
}

.fc-daygrid-body {
  z-index: 1 !important;
}

/* En vista semanal y mensual, elevamos los eventos al pasar el mouse */
.fc-timegrid-event-harness:hover,
.fc-daygrid-event-harness:hover {
  z-index: 99 !important;
  position: relative;
}

/* El encabezado debe tener una prioridad controlada para no tapar los tooltips elevados */
.fc-scrollgrid-section-header,
.fc .fc-col-header {
  z-index: 10 !important;
  position: relative;
}

/* Pero el cuerpo del calendario (donde están los eventos) debe poder estar por encima en hover */
.fc-scrollgrid-section-body {
  z-index: 20 !important;
  position: relative;
}

.fc-event {
  overflow: visible !important;
}

.fc-daygrid-event-harness {
  overflow: visible !important;
}

.mareas-calendar .fc-event-main {
  overflow: visible !important;
}

/* Fix específico para que el tooltip no se esconda bajo la toolbar superior */
.fc .fc-toolbar {
  position: relative;
  z-index: 5; /* Por debajo de los eventos elevados (20+) */
}
</style>
