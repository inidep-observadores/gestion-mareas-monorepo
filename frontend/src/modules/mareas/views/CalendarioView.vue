<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">Calendario de Mareas</h1>
          <p class="text-gray-500 dark:text-gray-400">
            Vista cronológica de designaciones, arribos y eventos clave.
          </p>
        </div>
      </div>

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
import { ref } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import listPlugin from '@fullcalendar/list'
import esLocale from '@fullcalendar/core/locales/es'

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
  events: [
    { title: 'MA-001 (Designada) - BP ARGENTINO I', start: '2023-12-20', color: '#5e5adb' },
    { title: 'MA-002 (Designada) - BP MAR DEL SUR', start: '2023-12-21', color: '#5e5adb' },
    {
      title: 'MA-003 (Navegando) - BP UNION',
      start: '2023-12-15',
      end: '2023-12-25',
      color: '#3b82f6',
    },
    { title: 'MA-004 (Arribada) - BP ESTRELLA', start: '2023-12-22', color: '#10b981' },
    { title: 'MA-005 (Arribada) - BP VICTORIA', start: '2023-12-23', color: '#10b981' },
    { title: 'MA-006 (Revisión) - BP ATLANTICO', start: '2023-12-18', color: '#f59e0b' },
    { title: 'MA-007 (Finalizada) - BP PACIFICO', start: '2023-12-10', color: '#6b7280' },
  ],
  editable: true,
  selectable: true,
  selectMirror: true,
  dayMaxEvents: true,
  height: 'auto',
  themeSystem: 'standard',
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
