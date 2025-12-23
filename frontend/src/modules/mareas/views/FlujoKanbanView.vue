<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">
            Flujo de Mareas (Kanban)
          </h1>
          <p class="text-gray-500 dark:text-gray-400">
            Seguimiento visual del ciclo de vida completo de las mareas. Arrastra las tarjetas para
            cambiar el estado.
          </p>
        </div>
      </div>

      <!-- Kanban Board Container -->
      <div
        class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm"
      >
        <div class="flex gap-6 overflow-auto custom-scrollbar px-6 pb-8 pt-0 h-[calc(100vh-250px)]">
          <div v-for="column in columns" :key="column.id" class="flex-shrink-0 w-80">
            <div
              class="sticky top-0 z-20 bg-white dark:bg-gray-900 pt-6 pb-4 mb-2 flex items-center justify-between"
            >
              <h3 class="font-bold text-gray-800 dark:text-gray-200 flex items-center gap-2">
                {{ column.title }}
                <span
                  class="px-2 py-0.5 bg-gray-100 dark:bg-gray-800 rounded text-xs text-gray-500"
                  >{{ column.tasks.length }}</span
                >
              </h3>
            </div>

            <div class="relative group">
              <VueDraggableNext
                v-model="column.tasks"
                group="mareas"
                class="space-y-4 min-h-[150px] p-2 bg-gray-50/50 dark:bg-gray-800/20 rounded-xl transition-colors border border-transparent group-hover:border-gray-100 dark:group-hover:border-gray-800"
                ghost-class="opacity-50"
                @change="onDragChange($event, column.id)"
              >
                <div
                  v-for="task in column.tasks"
                  :key="task.id"
                  class="bg-white dark:bg-gray-900 p-4 border border-gray-200 dark:border-gray-800 rounded-xl shadow-sm hover:shadow-md transition-shadow cursor-grab active:cursor-grabbing"
                >
                  <div class="flex justify-between items-start mb-2">
                    <span class="text-xs font-mono text-gray-500">{{ task.code }}</span>
                    <span v-if="task.alert" class="text-red-500">
                      <WarningIcon class="w-4 h-4" />
                    </span>
                  </div>
                  <h4 class="font-bold text-gray-800 dark:text-white mb-1">{{ task.vessel }}</h4>
                  <p class="text-xs text-gray-500 mb-3">{{ task.date }}</p>

                  <div class="flex items-center justify-between">
                    <div class="flex -space-x-2">
                      <div
                        class="w-6 h-6 rounded-full bg-brand-500 border-2 border-white dark:border-gray-900 flex items-center justify-center text-[10px] text-white"
                      >
                        JD
                      </div>
                    </div>
                    <div class="text-[10px] font-bold uppercase tracking-wider text-gray-400">
                      {{ task.timeInState || '3 días' }}
                    </div>
                  </div>
                </div>
              </VueDraggableNext>

              <div
                v-if="column.tasks.length === 0"
                class="absolute inset-0 pointer-events-none flex items-center justify-center p-4"
              >
                <div
                  class="w-full py-8 border-2 border-dashed border-gray-200 dark:border-gray-800 rounded-xl text-center text-sm text-gray-400"
                >
                  No hay mareas...
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { VueDraggableNext } from 'vue-draggable-next'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { WarningIcon } from '@/icons'

interface Task {
  id: number
  code: string
  vessel: string
  date: string
  alert: boolean
  timeInState?: string
}

interface Column {
  id: string
  title: string
  tasks: Task[]
}

const columns = ref<Column[]>([
  {
    id: 'designada',
    title: 'Designada',
    tasks: [
      { id: 1, code: 'MA-001', vessel: 'BP ARGENTINO I', date: '20 Dic', alert: false },
      { id: 2, code: 'MA-002', vessel: 'BP MAR DEL SUR', date: '21 Dic', alert: true },
    ],
  },
  {
    id: 'navegando',
    title: 'Navegando',
    tasks: [{ id: 3, code: 'MA-003', vessel: 'BP UNION', date: '15 Dic', alert: false }],
  },
  {
    id: 'arribada',
    title: 'Arribada',
    tasks: [
      { id: 4, code: 'MA-004', vessel: 'BP ESTRELLA', date: '22 Dic', alert: false },
      { id: 5, code: 'MA-005', vessel: 'BP VICTORIA', date: '23 Dic', alert: false },
    ],
  },
  {
    id: 'revision',
    title: 'En Revisión',
    tasks: [{ id: 6, code: 'MA-006', vessel: 'BP ATLANTICO', date: '18 Dic', alert: true }],
  },
  {
    id: 'finalizada',
    title: 'Finalizada',
    tasks: [{ id: 7, code: 'MA-007', vessel: 'BP PACIFICO', date: '10 Dic', alert: false }],
  },
])

const onDragChange = (event: any, columnId: string) => {
  if (event.added) {
    const task = event.added.element
    console.log(`Marea ${task.code} movida a ${columnId}`)
    task.timeInState = 'Recién movido'
  }
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 8px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e2e8f0;
  border-radius: 20px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #334155;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #cbd5e1;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #475569;
}
</style>
