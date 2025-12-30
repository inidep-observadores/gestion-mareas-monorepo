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
          <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-8 gap-3">
            <label
              v-for="eventType in eventTypes"
              :key="eventType.id"
              class="flex items-center gap-2 p-2 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800/50 cursor-pointer transition-colors"
            >
              <input
                type="checkbox"
                v-model="eventType.enabled"
                class="w-4 h-4 rounded border-gray-300 dark:border-gray-600 text-brand-500 focus:ring-2 focus:ring-brand-500/20 cursor-pointer"
              />
              <div class="flex items-center gap-1.5">
                <span class="text-lg">{{ eventType.emoji }}</span>
                <span class="text-xs font-medium text-gray-700 dark:text-gray-300">{{
                  eventType.label
                }}</span>
              </div>
            </label>
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
import { ref, computed, watch } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import FilterBar from '@/components/common/FilterBar.vue'
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import listPlugin from '@fullcalendar/list'
import esLocale from '@fullcalendar/core/locales/es'
import { CALENDAR_EVENT_COLORS } from '../config/calendarColors'

// Event type filters
const eventTypes = ref([
  {
    id: 'designacion',
    label: 'Designaciones',
    emoji: '📋',
    enabled: true,
    keywords: ['Designación'],
  },
  { id: 'zarpada', label: 'Zarpadas', emoji: '⛵', enabled: true, keywords: ['Zarpada'] },
  { id: 'arribo', label: 'Arribos', emoji: '🚢', enabled: true, keywords: ['Arribo'] },
  { id: 'informe', label: 'Informes', emoji: '📄', enabled: true, keywords: ['Informe'] },
  { id: 'validacion', label: 'Validaciones', emoji: '✅', enabled: true, keywords: ['Validación'] },
  { id: 'alerta', label: 'Alertas', emoji: '⚠️', enabled: true, keywords: ['Alerta'] },
  {
    id: 'reunion',
    label: 'Reuniones',
    emoji: '👥',
    enabled: true,
    keywords: ['Reunión', 'Capacitación', 'Taller'],
  },
  { id: 'navegacion', label: 'Navegación', emoji: '🌊', enabled: true, keywords: ['Navegación'] },
])

const allFiltersSelected = computed(() => eventTypes.value.every((type) => type.enabled))

const toggleAllFilters = () => {
  const newState = !allFiltersSelected.value
  eventTypes.value.forEach((type) => (type.enabled = newState))
}

// All events data
const allEvents = [
  // Designaciones (Púrpura/Brand)
  {
    title: '📋 Designación - BP ARGENTINO I',
    start: '2025-12-20',
    color: CALENDAR_EVENT_COLORS.designacion,
    type: 'designacion',
  },
  {
    title: '📋 Designación - BP MAR DEL SUR',
    start: '2025-12-21',
    color: CALENDAR_EVENT_COLORS.designacion,
    type: 'designacion',
  },
  {
    title: '📋 Designación - BP ATLANTICO II',
    start: '2025-12-28',
    color: CALENDAR_EVENT_COLORS.designacion,
    type: 'designacion',
  },
  {
    title: '📋 Designación - BP ESTRELLA II',
    start: '2026-01-15',
    color: CALENDAR_EVENT_COLORS.designacion,
    type: 'designacion',
  },
  {
    title: '📋 Designación - BP VICTORIA II',
    start: '2026-01-28',
    color: CALENDAR_EVENT_COLORS.designacion,
    type: 'designacion',
  },

  // Zarpadas (Azul)
  {
    title: '⛵ Zarpada - BP UNION',
    start: '2025-12-15',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },
  {
    title: '⛵ Zarpada - BP ESTRELLA',
    start: '2025-12-18',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },
  {
    title: '⛵ Zarpada - BP VICTORIA',
    start: '2025-12-19',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },
  {
    title: '⛵ Zarpada - BP PACIFICO',
    start: '2025-12-22',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },
  {
    title: '⛵ Zarpada - BP ATLANTICO',
    start: '2026-01-08',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },
  {
    title: '⛵ Zarpada - BP MAR DEL NORTE',
    start: '2026-01-16',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },
  {
    title: '⛵ Zarpada - BP PACIFICO',
    start: '2025-12-22T08:00:00',
    color: CALENDAR_EVENT_COLORS.zarpada,
    type: 'zarpada',
  },

  // Arribos (Verde)
  {
    title: '🚢 Arribo - BP ESTRELLA',
    start: '2025-12-22',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP VICTORIA',
    start: '2025-12-23',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP UNION',
    start: '2025-12-25',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP PACIFICO',
    start: '2025-12-30',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP ATLANTICO',
    start: '2026-01-18',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP MAR DEL NORTE',
    start: '2026-01-26',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP ESTRELLA',
    start: '2025-12-22T14:00:00',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },
  {
    title: '🚢 Arribo - BP VICTORIA',
    start: '2025-12-23T10:00:00',
    color: CALENDAR_EVENT_COLORS.arribo,
    type: 'arribo',
  },

  // Protocolización de Informes (Naranja)
  {
    title: '📄 Informe Protocolizado - MA-006',
    start: '2025-12-18',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },
  {
    title: '📄 Informe Protocolizado - MA-004',
    start: '2025-12-23',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },
  {
    title: '📄 Informe Protocolizado - MA-005',
    start: '2025-12-26',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },
  {
    title: '📄 Informe Protocolizado - MA-008',
    start: '2026-01-10',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },
  {
    title: '📄 Informe Protocolizado - MA-009',
    start: '2026-01-20',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },
  {
    title: '📄 Informe Protocolizado - MA-004',
    start: '2025-12-23T16:00:00',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },
  {
    title: '📄 Informe Protocolizado - MA-008',
    start: '2026-01-10T09:00:00',
    color: CALENDAR_EVENT_COLORS.informe,
    type: 'informe',
  },

  // Revisiones y Validaciones (Amarillo)
  {
    title: '✅ Validación de Datos - MA-003',
    start: '2025-12-17',
    color: CALENDAR_EVENT_COLORS.validacion,
    type: 'validacion',
  },
  {
    title: '✅ Validación de Datos - MA-007',
    start: '2025-12-24',
    color: CALENDAR_EVENT_COLORS.validacion,
    type: 'validacion',
  },
  {
    title: '✅ Validación de Datos - MA-010',
    start: '2026-01-12',
    color: CALENDAR_EVENT_COLORS.validacion,
    type: 'validacion',
  },
  {
    title: '✅ Validación de Datos - MA-011',
    start: '2026-01-25',
    color: CALENDAR_EVENT_COLORS.validacion,
    type: 'validacion',
  },

  // Alertas y Eventos Críticos (Rojo)
  {
    title: '⚠️ Alerta - Revisión Urgente MA-002',
    start: '2025-12-21',
    color: CALENDAR_EVENT_COLORS.alerta,
    type: 'alerta',
  },
  {
    title: '⚠️ Alerta - Datos Incompletos MA-006',
    start: '2025-12-27',
    color: CALENDAR_EVENT_COLORS.alerta,
    type: 'alerta',
  },
  {
    title: '⚠️ Alerta - Retraso en Informe MA-012',
    start: '2026-01-14',
    color: CALENDAR_EVENT_COLORS.alerta,
    type: 'alerta',
  },

  // Reuniones y Coordinación (Índigo)
  {
    title: '👥 Reunión de Coordinación',
    start: '2025-12-19',
    color: CALENDAR_EVENT_COLORS.reunion,
    type: 'reunion',
  },
  {
    title: '👥 Capacitación Observadores',
    start: '2025-12-26',
    color: CALENDAR_EVENT_COLORS.reunion,
    type: 'reunion',
  },
  {
    title: '👥 Reunión Técnica',
    start: '2026-01-09',
    color: CALENDAR_EVENT_COLORS.reunion,
    type: 'reunion',
  },
  {
    title: '👥 Taller de Actualización',
    start: '2026-01-22',
    color: CALENDAR_EVENT_COLORS.reunion,
    type: 'reunion',
  },
  {
    title: '👥 Reunión Técnica',
    start: '2026-01-10T15:00:00',
    color: CALENDAR_EVENT_COLORS.reunion,
    type: 'reunion',
  },

  // Eventos de múltiples días (Navegación)
  {
    title: '🌊 Navegación - BP UNION',
    start: '2025-12-15',
    end: '2025-12-25',
    color: CALENDAR_EVENT_COLORS.navegacionCyan,
    display: 'background',
    type: 'navegacion',
  },
  {
    title: '🌊 Navegación - BP PACIFICO',
    start: '2025-12-22',
    end: '2025-12-30',
    color: CALENDAR_EVENT_COLORS.navegacionPurple,
    display: 'background',
    type: 'navegacion',
  },
  {
    title: '🌊 Navegación - BP ATLANTICO',
    start: '2026-01-08',
    end: '2026-01-18',
    color: CALENDAR_EVENT_COLORS.navegacionCyan,
    display: 'background',
    type: 'navegacion',
  },
  {
    title: '🌊 Navegación - BP MAR DEL NORTE',
    start: '2026-01-16',
    end: '2026-01-26',
    color: CALENDAR_EVENT_COLORS.navegacionPurple,
    display: 'background',
    type: 'navegacion',
  },
]

// Filtered events based on selected types
const filteredEvents = computed(() => {
  const enabledTypes = eventTypes.value.filter((t) => t.enabled).map((t) => t.id)
  return allEvents.filter((event) => enabledTypes.includes(event.type))
})

const calendarOptions = ref({
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin, listPlugin],
  initialView: 'dayGridMonth',
  locale: esLocale,
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
  events: filteredEvents.value,
  editable: true,
  selectable: true,
  selectMirror: true,
  dayMaxEvents: true,
  height: 'auto',
  themeSystem: 'standard',
})

// Watch for filter changes and update calendar events
watch(
  filteredEvents,
  (newEvents) => {
    calendarOptions.value.events = newEvents
  },
  { deep: true },
)
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
