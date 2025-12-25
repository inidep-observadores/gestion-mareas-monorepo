<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <!-- Header & Filters -->
      <div class="mb-6 space-y-4">
        <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 class="text-2xl text-gray-800 dark:text-white/90">Flujo de Trabajo de Mareas</h1>
            <p class="text-gray-500 dark:text-gray-400">
              Gestión centralizada de estados y operativas.
            </p>
          </div>

          <!-- View Toggle -->
          <ViewToggle v-model="viewMode" :options="viewOptions" />
        </div>

        <!-- Advanced Filter Bar -->
        <FilterBar>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
            <!-- Search -->
            <div class="relative lg:col-span-1">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Buscar marea/buque..."
                class="w-full px-4 py-2.5 border rounded-xl text-sm font-medium transition-all duration-200 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600 focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 placeholder:text-gray-400 dark:placeholder:text-gray-500"
              />
            </div>

            <!-- Filters -->
            <SelectInput
              v-model="filters.fishery"
              :options="fisheryOptions"
              placeholder="Pesquería (Todas)"
            />
            <SelectInput
              v-model="filters.observer"
              :options="observerOptions"
              placeholder="Observador (Todos)"
            />
            <SelectInput
              v-model="filters.alert"
              :options="alertOptions"
              placeholder="Alertas (Todas)"
            />

            <!-- Actions -->
            <div class="flex items-center gap-2">
              <button
                class="flex-1 px-4 py-2.5 bg-brand-500 text-white text-sm font-medium rounded-xl hover:bg-brand-600 active:bg-brand-700 transition-all duration-200 shadow-sm hover:shadow-md"
              >
                Filtrar
              </button>
              <button
                class="p-2.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-xl transition-all duration-200"
                title="Limpiar filtros"
              >
                <RefreshIcon class="w-5 h-5" />
              </button>
            </div>
          </div>
        </FilterBar>
      </div>

      <!-- Main Content Area -->
      <div
        v-if="viewMode === 'kanban'"
        class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm"
      >
        <div class="flex gap-6 overflow-auto custom-scrollbar px-6 pb-8 pt-0 h-[calc(100vh-320px)]">
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
                  class="bg-white dark:bg-gray-900 p-4 border border-gray-200 dark:border-gray-800 rounded-xl shadow-sm hover:shadow-md transition-shadow cursor-pointer active:cursor-grabbing group/card"
                  @click="navigateToDetail(task.id)"
                >
                  <div class="flex justify-between items-start mb-2">
                    <span
                      class="text-xs font-mono text-gray-500 group-hover/card:text-brand-500 transition-colors"
                      >{{ task.code }}</span
                    >
                    <span v-if="task.alert" class="text-red-500"
                      ><WarningIcon class="w-4 h-4"
                    /></span>
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

      <!-- List Mode -->
      <div v-else class="space-y-6">
        <div
          v-for="group in columns"
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
                >{{ group.tasks.length }}</span
              >
            </div>
            <button
              class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-transform"
              :class="{ 'rotate-180': !group.expanded }"
            >
              <ChevronDownIcon class="w-5 h-5" />
            </button>
          </div>

          <!-- Drop zone for collapsed groups -->
          <VueDraggableNext
            v-if="!group.expanded"
            v-model="group.tasks"
            group="mareas"
            class="min-h-[60px] border-2 border-dashed border-gray-200 dark:border-gray-700 rounded-xl m-4 flex items-center justify-center text-sm text-gray-400 hover:border-brand-300 dark:hover:border-brand-700 hover:bg-brand-50/30 dark:hover:bg-brand-500/5 transition-all"
            ghost-class="opacity-50"
            @change="onDragChange($event, group.id)"
          >
            <div class="pointer-events-none">Soltar marea aquí para mover a {{ group.title }}</div>
          </VueDraggableNext>

          <div v-show="group.expanded" class="divide-y divide-gray-50 dark:divide-gray-800">
            <VueDraggableNext
              v-model="group.tasks"
              group="mareas"
              class="min-h-[50px]"
              handle=".drag-handle"
              ghost-class="opacity-50"
              @change="onDragChange($event, group.id)"
            >
              <div
                v-for="task in group.tasks"
                :key="task.id"
                class="p-6 hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-colors cursor-pointer group/row"
                @click="navigateToDetail(task.id)"
              >
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                  <div class="flex items-start gap-4">
                    <!-- Drag Handle -->
                    <div
                      class="drag-handle p-1 -ml-2 text-gray-300 hover:text-brand-500 cursor-grab active:cursor-grabbing transition-colors rounded-md hover:bg-gray-100 dark:hover:bg-gray-800 shrink-0 self-center"
                      @click.stop
                    >
                      <GripVerticalIcon class="w-5 h-5" />
                    </div>

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
                          <WarningIcon class="w-3 h-3" /> Alerta
                        </span>
                      </div>
                      <h4 class="font-bold text-gray-800 dark:text-white text-lg">
                        {{ task.vessel }}
                      </h4>
                      <div class="flex items-center gap-4 mt-1 text-sm text-gray-500">
                        <span class="flex items-center gap-1"
                          ><CalenderIcon class="w-4 h-4" /> {{ task.date }}</span
                        >
                        <span class="flex items-center gap-1"
                          ><UserCircleIcon class="w-4 h-4" /> JD (Observador)</span
                        >
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center gap-3">
                    <button
                      class="px-4 py-2 text-sm font-medium border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                      @click.stop="navigateToDetail(task.id)"
                    >
                      Ver Detalles
                    </button>
                    <button
                      class="px-4 py-2 text-sm font-medium bg-brand-500 text-white rounded-lg hover:bg-brand-600 transition-colors"
                      @click.stop
                    >
                      Continuar Flujo
                    </button>
                  </div>
                </div>
              </div>
            </VueDraggableNext>
            <div
              v-if="group.tasks.length === 0"
              class="p-8 text-center text-gray-400 text-sm italic bg-gray-50/20 dark:bg-gray-800/5"
            >
              No hay mareas registradas en este estado.
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { VueDraggableNext } from 'vue-draggable-next'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import ViewToggle from '@/components/common/ViewToggle.vue'
import FilterBar from '@/components/common/FilterBar.vue'
import SelectInput from '@/components/common/SelectInput.vue'
import {
  ChevronDownIcon,
  DocsIcon,
  CalenderIcon,
  UserCircleIcon,
  WarningIcon,
  GridIcon,
  ListIcon,
  RefreshIcon,
  GripVerticalIcon,
} from '@/icons'

const router = useRouter()
const viewMode = ref<'kanban' | 'list'>('kanban')
const searchQuery = ref('')
const filters = ref({
  fishery: '',
  observer: '',
  alert: '',
})

const viewOptions = [
  { value: 'kanban', label: 'Tablero', icon: GridIcon, hideTextOnMobile: true },
  { value: 'list', label: 'Lista', icon: ListIcon, hideTextOnMobile: true },
]

const fisheryOptions = [
  { value: 'congeladores', label: 'Congeladores' },
  { value: 'fresqueros', label: 'Fresqueros' },
]

const observerOptions = [
  { value: 'jd', label: 'Juan Díaz' },
  { value: 'am', label: 'Ana Martínez' },
]

const alertOptions = [
  { value: 'with', label: 'Con Alerta' },
  { value: 'without', label: 'Sin Alerta' },
]

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
  color: string
  expanded: boolean
  tasks: Task[]
}

const columns = ref<Column[]>([
  {
    id: 'designada',
    title: 'Designada',
    color: 'bg-brand-500',
    expanded: true,
    tasks: [
      {
        id: 1,
        code: 'MA-001',
        vessel: 'BP ARGENTINO I',
        date: '20 Dic 2023',
        alert: false,
        timeInState: '2 días',
      },
      {
        id: 2,
        code: 'MA-002',
        vessel: 'BP MAR DEL SUR',
        date: '21 Dic 2023',
        alert: true,
        timeInState: '1 día',
      },
    ],
  },
  {
    id: 'navegando',
    title: 'Navegando',
    color: 'bg-blue-500',
    expanded: true,
    tasks: [
      {
        id: 3,
        code: 'MA-003',
        vessel: 'BP UNION',
        date: '15 Dic 2023',
        alert: false,
        timeInState: '6 días',
      },
    ],
  },
  {
    id: 'arribada',
    title: 'Arribada',
    color: 'bg-green-500',
    expanded: false,
    tasks: [
      {
        id: 4,
        code: 'MA-004',
        vessel: 'BP ESTRELLA',
        date: '22 Dic 2023',
        alert: false,
        timeInState: 'hace 5h',
      },
      {
        id: 5,
        code: 'MA-005',
        vessel: 'BP VICTORIA',
        date: '23 Dic 2023',
        alert: false,
        timeInState: 'hace 2h',
      },
    ],
  },
  {
    id: 'revision',
    title: 'En Revisión',
    color: 'bg-orange-500',
    expanded: false,
    tasks: [
      {
        id: 6,
        code: 'MA-006',
        vessel: 'BP ATLANTICO',
        date: '18 Dic 2023',
        alert: true,
        timeInState: '3 días',
      },
    ],
  },
  {
    id: 'finalizada',
    title: 'Finalizada',
    color: 'bg-gray-500',
    expanded: false,
    tasks: [
      {
        id: 7,
        code: 'MA-007',
        vessel: 'BP PACIFICO',
        date: '10 Dic 2023',
        alert: false,
        timeInState: '8 días',
      },
    ],
  },
])

const onDragChange = (event: any, columnId: string) => {
  if (event.added) {
    console.log(`Marea agregada a ${columnId}:`, event.added.element.vessel)
    // Auto-expand the group when an item is added
    const targetGroup = columns.value.find((col) => col.id === columnId)
    if (targetGroup && !targetGroup.expanded) {
      targetGroup.expanded = true
    }
  }
}

const navigateToDetail = (id: number) => {
  router.push({ name: 'MareaDetalle', params: { id } })
}

// Responsive Logic
const handleResize = () => {
  if (window.innerWidth < 1024) {
    viewMode.value = 'list'
  }
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
  handleResize()
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 8px;
  width: 8px;
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
