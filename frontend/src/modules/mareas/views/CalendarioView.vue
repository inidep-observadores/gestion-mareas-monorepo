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
            <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300">
              Filtrar por Tipo de Evento
            </h3>
            <button
              @click="toggleAllFilters"
              class="text-xs font-medium text-brand-500 hover:text-brand-600 dark:text-brand-400 dark:hover:text-brand-300 transition-colors"
            >
              {{ allFiltersSelected ? 'Deseleccionar Todos' : 'Seleccionar Todos' }}
            </button>
          </div>
          <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-8 gap-2">
            <div
              v-for="eventType in eventTypes"
              :key="eventType.id"
              @click="eventType.enabled = !eventType.enabled"
              class="group relative flex flex-col p-3 rounded-2xl border transition-all cursor-pointer select-none bg-white dark:bg-black/20 overflow-hidden"
              :class="eventType.enabled 
                ? 'border-indigo-500/20 shadow-md shadow-indigo-500/5 ring-1 ring-indigo-500/5' 
                : 'border-gray-100 dark:border-white/5 opacity-50 grayscale-[0.8] hover:opacity-80'"
            >
              <!-- Label + Visibility -->
              <div class="flex items-center justify-between gap-2 mb-3">
                <span class="text-[8px] font-black uppercase tracking-[0.2em] text-gray-400 dark:text-gray-500 truncate">
                  {{ eventType.label }}
                </span>
                <component 
                  :is="eventType.enabled ? EyeIcon : EyeSlashIcon" 
                  class="w-3.5 h-3.5 transition-colors" 
                  :class="eventType.enabled ? 'text-indigo-500' : 'text-gray-400'"
                />
              </div>
              
              <!-- Count + Icon Badge -->
              <div class="flex items-end justify-between">
                <span class="text-2xl font-black text-gray-900 dark:text-gray-100 leading-none tabular-nums tracking-tighter">
                  {{ eventCounts[eventType.id] || 0 }}
                </span>
                
                <div 
                  class="w-8 h-8 flex items-center justify-center rounded-xl transition-all duration-300"
                  :class="eventType.enabled ? 'bg-indigo-500/10 text-indigo-500 border border-indigo-500/10' : 'bg-gray-100 dark:bg-white/5 text-gray-400 border border-transparent'"
                >
                  <component :is="eventType.icon" class="w-4 h-4" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </FilterBar>

      <!-- Calendar Container -->
      <div
        class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm"
      >
        <FullCalendar :options="calendarOptions" class="mareas-calendar" />
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
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
  DocsIcon
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
})

const fetchEvents = async () => {
    try {
        const events = await mareasService.getCalendarEvents()
        allEvents.value = events.map((e: CalendarEvent) => ({
            ...e,
            color: (CALENDAR_EVENT_COLORS as any)[e.type] || '#808080'
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
  --fc-border-color: #e2e8f0;
  --fc-button-bg-color: #5e5adb;
  --fc-button-border-color: #5e5adb;
  --fc-button-hover-bg-color: #4a46b1;
  --fc-button-active-bg-color: #4a46b1;
  --fc-today-bg-color: rgba(94, 90, 219, 0.05);
  --fc-page-bg-color: transparent;
}

.dark .mareas-calendar {
  --fc-border-color: #1e293b;
  --fc-text-color: #f1f5f9;
  --fc-neutral-bg-color: #0f172a;
  --fc-list-event-hover-bg-color: #1e293b;
}

.fc .fc-toolbar-title {
  font-size: 1.125rem;
  line-height: 1.75rem;
  font-weight: 700;
  color: #1f2937;
}

.dark .fc .fc-toolbar-title {
  color: rgba(255, 255, 255, 0.9);
}

.fc .fc-col-header-cell-cushion {
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  font-size: 0.875rem;
  line-height: 1.25rem;
  font-weight: 600;
  color: #6b7280;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.fc .fc-daygrid-day-number {
  padding: 0.5rem;
  font-size: 0.875rem;
  line-height: 1.25rem;
  color: #6b7280;
}

.dark .fc .fc-daygrid-day-number {
  color: #94a3b8;
}

.fc-theme-standard .fc-scrollgrid {
  border-color: #e2e8f0;
}

.dark .fc-theme-standard .fc-scrollgrid {
  border-color: #1e293b;
}

.fc-theme-standard td,
.fc-theme-standard th {
  border-color: #f1f5f9;
}

.dark .fc-theme-standard td,
.dark .fc-theme-standard th {
  border-color: #1e293b;
}
</style>
