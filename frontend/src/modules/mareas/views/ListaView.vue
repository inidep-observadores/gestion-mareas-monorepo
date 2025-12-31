<template>
  <AdminLayout 
    title="Lista de Mareas por Estado" 
    description="Vista agrupada y detallada del flujo de trabajo de mareas."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex justify-end">
        <div class="flex gap-3">
          <div class="relative">
            <input
              type="text"
              placeholder="Filtrar por buque..."
              class="px-4 py-2 border border-gray-200 dark:border-gray-700 rounded-lg bg-white dark:bg-gray-800 text-sm focus:outline-none focus:ring-2 focus:ring-brand-500/20"
            />
          </div>
        </div>
      </div>

      <!-- Grouped List -->
      <div class="space-y-6">
        <div
          v-for="group in groups"
          :key="group.id"
          class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm"
        >
          <div
            class="px-6 py-4 bg-gray-50 dark:bg-gray-800/50 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between cursor-pointer"
            @click="group.expanded = !group.expanded"
          >
            <div class="flex items-center gap-3">
              <div :class="['w-2 h-2 rounded-full', group.color]"></div>
              <h2 class="font-bold text-gray-800 dark:text-white">{{ group.title }}</h2>
              <span
                class="px-2 py-0.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded text-xs text-gray-500"
              >
                {{ group.tasks.length }}
              </span>
            </div>
            <button
              class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-transform"
              :class="{ 'rotate-180': !group.expanded }"
            >
              <ChevronDownIcon class="w-5 h-5" />
            </button>
          </div>

          <div v-show="group.expanded" class="divide-y divide-gray-50 dark:divide-gray-800">
            <div
              v-if="group.tasks.length === 0"
              class="p-8 text-center text-gray-400 text-sm italic"
            >
              No hay mareas registradas en este estado.
            </div>
            <div
              v-for="task in group.tasks"
              :key="task.id"
              class="p-6 hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-colors"
            >
              <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div class="flex items-start gap-4">
                  <div
                    class="w-12 h-12 rounded-xl bg-gray-100 dark:bg-gray-800 flex items-center justify-center flex-shrink-0"
                  >
                    <DocsIcon class="w-6 h-6 text-gray-400" />
                  </div>
                  <div>
                    <div class="flex items-center gap-2 mb-1">
                      <span class="text-xs font-mono font-bold text-brand-500">{{
                        task.code
                      }}</span>
                      <span
                        v-if="task.alert"
                        class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] bg-red-100 text-red-600 dark:bg-red-900/30 dark:text-red-400"
                      >
                        <WarningIcon class="w-3 h-3" />
                        Alerta
                      </span>
                    </div>
                    <h4 class="font-bold text-gray-800 dark:text-white text-lg">
                      {{ task.vessel }}
                    </h4>
                    <div class="flex items-center gap-4 mt-1 text-sm text-gray-500">
                      <span class="flex items-center gap-1">
                        <CalenderIcon class="w-4 h-4" />
                        {{ task.date }}
                      </span>
                      <span class="flex items-center gap-1">
                        <UserCircleIcon class="w-4 h-4" />
                        JD (Observador)
                      </span>
                    </div>
                  </div>
                </div>
                <div class="flex items-center gap-3">
                  <button
                    class="px-4 py-2 text-sm font-medium border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                  >
                    Ver Detalles
                  </button>
                  <button
                    class="px-4 py-2 text-sm font-medium bg-brand-500 text-white rounded-lg hover:bg-brand-600 transition-colors"
                  >
                    Continuar Flujo
                  </button>
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
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { ChevronDownIcon, DocsIcon, CalenderIcon, UserCircleIcon, WarningIcon } from '@/icons'

interface Task {
  id: number
  code: string
  vessel: string
  date: string
  alert: boolean
}

interface Group {
  id: string
  title: string
  color: string
  expanded: boolean
  tasks: Task[]
}

const groups = ref<Group[]>([
  {
    id: 'designada',
    title: 'Designada',
    color: 'bg-brand-500',
    expanded: true,
    tasks: [
      { id: 1, code: 'MA-001', vessel: 'BP ARGENTINO I', date: '20 Dic 2023', alert: false },
      { id: 2, code: 'MA-002', vessel: 'BP MAR DEL SUR', date: '21 Dic 2023', alert: true },
    ],
  },
  {
    id: 'navegando',
    title: 'Navegando',
    color: 'bg-blue-500',
    expanded: true,
    tasks: [{ id: 3, code: 'MA-003', vessel: 'BP UNION', date: '15 Dic 2023', alert: false }],
  },
  {
    id: 'arribada',
    title: 'Arribada',
    color: 'bg-green-500',
    expanded: false,
    tasks: [
      { id: 4, code: 'MA-004', vessel: 'BP ESTRELLA', date: '22 Dic 2023', alert: false },
      { id: 5, code: 'MA-005', vessel: 'BP VICTORIA', date: '23 Dic 2023', alert: false },
    ],
  },
  {
    id: 'revision',
    title: 'En Revisión',
    color: 'bg-orange-500',
    expanded: false,
    tasks: [{ id: 6, code: 'MA-006', vessel: 'BP ATLANTICO', date: '18 Dic 2023', alert: true }],
  },
  {
    id: 'finalizada',
    title: 'Finalizada',
    color: 'bg-gray-500',
    expanded: false,
    tasks: [{ id: 7, code: 'MA-007', vessel: 'BP PACIFICO', date: '10 Dic 2023', alert: false }],
  },
])
</script>
