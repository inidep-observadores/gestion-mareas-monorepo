<template>
  <AdminLayout 
    title="Workflow Manager" 
    description="Gestión centralizada de misiones y estados operativos."
  >
    <div class="relative min-h-screen pb-20 animate-in fade-in duration-700">
      
      <!-- TOP ACTIONS & NAVIGATION -->
      <div class="mb-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-2xl bg-indigo-50 dark:bg-indigo-900/20 flex items-center justify-center text-indigo-600 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-800/50">
            <GridIcon v-if="viewMode === 'kanban'" class="w-6 h-6" />
            <ListIcon v-else class="w-6 h-6" />
          </div>
          <div>
            <h2 class="text-lg font-black text-gray-900 dark:text-white uppercase tracking-tighter leading-none">Gestión de Flujo</h2>
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Arrastre misiones para cambiar su estado</p>
          </div>
        </div>

        <ViewToggle v-model="viewMode" :options="viewOptions" />
      </div>

      <!-- ADVANCED FILTERS -->
      <FilterBar>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-6 items-end">
          <!-- Main Search -->
          <div class="lg:col-span-4">
            <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 block">Buscar Misión</label>
            <div class="relative group">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Buque u Observador..."
                class="w-full px-5 py-3 bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-700 rounded-2xl text-xs font-black placeholder:text-gray-400 focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all outline-none"
              />
              <SearchIcon class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 group-focus-within:text-indigo-500 transition-colors" />
            </div>
          </div>

          <!-- Selectors -->
          <div class="lg:col-span-2">
            <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 block">Flota</label>
            <SelectInput v-model="filters.fishery" :options="fisheryOptions" placeholder="Todas" />
          </div>
          <div class="lg:col-span-2">
            <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 block">Pesquería</label>
            <SelectInput v-model="filters.fishery2" :options="fishery2Options" placeholder="Todas" />
          </div>
          <div class="lg:col-span-2">
            <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2 block">Observador</label>
            <SelectInput v-model="filters.observer" :options="observerOptions" placeholder="Cualquiera" />
          </div>

          <!-- Quick Actions -->
          <div class="lg:col-span-2 flex gap-2">
            <button class="flex-1 bg-gray-900 dark:bg-white text-white dark:text-gray-900 px-4 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:scale-[1.02] transition-all active:scale-95 shadow-lg shadow-gray-500/10">
              Aplicar
            </button>
            <button @click="resetFilters" class="p-3 bg-gray-50 dark:bg-gray-800 text-gray-400 hover:text-gray-600 rounded-2xl transition-colors border border-gray-100 dark:border-gray-700">
              <RefreshIcon class="w-5 h-5" />
            </button>
          </div>
        </div>
      </FilterBar>

      <!-- KANBAN VIEW -->
      <div v-if="viewMode === 'kanban'" class="flex gap-6 overflow-x-auto pb-10 custom-scrollbar-h h-[calc(100vh-350px)] min-h-[500px]">
        <div v-for="(column, idx) in columns" :key="column.id" class="flex-shrink-0 w-[340px] flex flex-col group/col">
          <!-- Column Header -->
          <div class="mb-4 flex items-center justify-between px-2">
            <div class="flex items-center gap-3">
              <div class="w-2 h-2 rounded-full shadow-sm" :class="column.color"></div>
              <h3 class="text-xs font-black text-gray-900 dark:text-white uppercase tracking-widest">
                {{ column.title }}
              </h3>
              <span class="text-[10px] font-black tabular-nums bg-gray-100 dark:bg-gray-800 px-2.5 py-1 rounded-xl text-gray-500 border border-gray-100 dark:border-gray-700">
                {{ column.tasks.length }}
              </span>
            </div>
            <button class="text-gray-300 hover:text-gray-600 dark:hover:text-gray-400 opacity-0 group-hover/col:opacity-100 transition-opacity">
              <HorizontalDots class="w-4 h-4" />
            </button>
          </div>

          <!-- Draggable Container -->
          <div class="flex-1 bg-gray-50/50 dark:bg-gray-900/40 rounded-[2.5rem] border border-gray-100 dark:border-gray-800/50 p-3 overflow-y-auto custom-scrollbar active:bg-gray-100/30 dark:active:bg-gray-800/20 transition-colors">
            <VueDraggableNext
              v-model="columns[idx].tasks"
              group="mareas"
              :tag="'div'"
              class="space-y-4 min-h-[400px] pb-20"
              ghost-class="opacity-10"
              :animation="200"
              @change="onDragChange($event, column.id)"
            >
              <div
                v-for="task in column.tasks"
                :key="task.id"
                class="group bg-white dark:bg-gray-900 p-6 rounded-[2rem] border border-gray-50 dark:border-gray-800 shadow-sm hover:shadow-xl hover:border-indigo-100 dark:hover:border-indigo-900/30 transition-all duration-300 cursor-grab active:cursor-grabbing relative overflow-hidden"
                @click="navigateToDetail(task.id)"
              >
                <!-- Card Glow Backdrop -->
                <div class="absolute -right-10 -top-10 w-24 h-24 bg-indigo-500/5 blur-3xl rounded-full"></div>

                <div class="flex justify-between items-start mb-4 relative z-10">
                  <div class="flex flex-col">
                    <span class="text-[9px] font-black text-indigo-500 uppercase tracking-widest mb-1">{{ task.code }}</span>
                    <h4 class="text-xs font-black text-gray-900 dark:text-white uppercase group-hover:text-indigo-600 transition-colors">{{ task.vessel }}</h4>
                  </div>
                  <div v-if="task.alert" class="w-2 h-2 rounded-full bg-red-500 shadow-[0_0_10px_rgba(239,68,68,0.5)] animate-pulse"></div>
                </div>

                <div class="space-y-4 relative z-10">
                   <div class="flex items-center gap-2 text-[10px] font-bold text-gray-400 uppercase">
                      <CalenderIcon class="w-3.5 h-3.5" />
                      {{ task.date }}
                   </div>
                   
                   <div class="pt-4 border-t border-gray-50 dark:border-gray-800 flex items-center justify-between">
                      <div class="flex -space-x-1.5 text-indigo-500">
                        <div class="w-7 h-7 rounded-full bg-indigo-50 dark:bg-indigo-900/30 border-2 border-white dark:border-gray-900 flex items-center justify-center text-[8px] font-black uppercase">
                          JD
                        </div>
                      </div>
                      <span class="text-[9px] font-black text-gray-400 uppercase tracking-tighter bg-gray-50 dark:bg-gray-800 px-2 py-0.5 rounded-lg border border-gray-100 dark:border-gray-700/50">
                        {{ task.timeInState || '3 días' }}
                      </span>
                   </div>
                </div>
              </div>

              <!-- Empty State Overlay inside Draggable -->
              <div
                v-if="column.tasks.length === 0"
                class="absolute inset-0 flex items-center justify-center p-8 opacity-40 pointer-events-none"
              >
                <div class="text-center">
                  <DocsIcon class="w-8 h-8 mx-auto mb-2 text-gray-300" />
                  <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest italic">Vacío</span>
                </div>
              </div>
            </VueDraggableNext>
          </div>
        </div>
      </div>

      <!-- LIST VIEW -->
      <div v-else class="space-y-6 max-w-6xl mx-auto">
        <div v-for="(statusGroup, idx) in columns" :key="statusGroup.id" class="bg-white dark:bg-gray-900 border border-gray-50 dark:border-gray-800 rounded-[2.5rem] overflow-hidden shadow-sm hover:shadow-lg transition-all">
          <!-- Group Header -->
          <div
            class="px-8 py-5 flex items-center justify-between cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors border-b border-transparent"
            :class="{ 'border-gray-50 dark:border-gray-800 bg-gray-50/30 dark:bg-gray-800/20': statusGroup.expanded }"
            @click="statusGroup.expanded = !statusGroup.expanded"
          >
            <div class="flex items-center gap-4">
              <div class="w-2.5 h-2.5 rounded-full shadow-sm" :class="statusGroup.color"></div>
              <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest">{{ statusGroup.title }}</h2>
              <span class="text-[10px] font-black bg-white dark:bg-gray-800 px-3 py-1 rounded-xl text-gray-400 border border-gray-100 dark:border-gray-700">
                {{ statusGroup.tasks.length }}
              </span>
            </div>
            <button class="w-8 h-8 flex items-center justify-center rounded-full border border-gray-100 dark:border-gray-800 hover:bg-white dark:hover:bg-gray-700 transition-all shadow-sm" :class="{ 'rotate-180 bg-gray-100 dark:bg-gray-700': statusGroup.expanded }">
              <ChevronDownIcon class="w-4 h-4 text-gray-400" />
            </button>
          </div>

          <!-- Draggable Rows -->
          <div v-show="statusGroup.expanded" class="p-4 space-y-2 relative">
            <VueDraggableNext
              v-model="columns[idx].tasks"
              group="mareas"
              :tag="'div'"
              handle=".drag-handle"
              class="min-h-[100px] space-y-2 pb-4"
              ghost-class="opacity-5"
              :animation="200"
              @change="onDragChange($event, statusGroup.id)"
            >
              <div
                v-for="task in statusGroup.tasks"
                :key="task.id"
                class="p-5 hover:bg-gray-50 dark:hover:bg-white/[0.02] border border-transparent hover:border-gray-100 dark:hover:border-gray-800 rounded-3xl transition-all cursor-pointer group/row relative overflow-hidden"
                @click="navigateToDetail(task.id)"
              >
                <!-- Row Glow -->
                <div class="absolute left-0 top-0 bottom-0 w-1 bg-indigo-500 scale-y-0 group-hover/row:scale-y-100 transition-transform origin-top"></div>

                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
                  <div class="flex items-center gap-6">
                    <!-- Drag Handle -->
                    <div class="drag-handle opacity-0 group-hover/row:opacity-100 transition-opacity p-2 -ml-2 text-gray-300 hover:text-indigo-500 cursor-grab active:cursor-grabbing">
                      <GripVerticalIcon class="w-5 h-5" />
                    </div>

                    <div class="w-14 h-14 rounded-2xl bg-indigo-50 dark:bg-indigo-900/20 flex items-center justify-center border border-indigo-100/50 dark:border-indigo-800/30 text-indigo-500">
                       <DocsIcon class="w-7 h-7 opacity-60" />
                    </div>

                    <div>
                      <div class="flex items-center gap-3 mb-1.5">
                        <span class="text-[10px] font-black text-indigo-500 uppercase tracking-widest">{{ task.code }}</span>
                        <span v-if="task.alert" class="flex items-center gap-1 text-[8px] font-black uppercase bg-red-50 text-red-600 dark:bg-red-900/30 dark:text-red-400 px-2 py-1 rounded-lg border border-red-100 dark:border-red-800/30">
                          <WarningIcon class="w-2.5 h-2.5" /> Alerta Crítica
                        </span>
                      </div>
                      <h4 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-tight">{{ task.vessel }}</h4>
                      <div class="flex items-center gap-6 mt-3">
                         <div class="flex items-center gap-1.5 text-[10px] font-black text-gray-400 uppercase tracking-tighter">
                            <CalenderIcon class="w-4 h-4 text-gray-300" /> {{ task.date }}
                         </div>
                         <div class="flex items-center gap-1.5 text-[10px] font-black text-gray-400 uppercase tracking-tighter">
                            <UserCircleIcon class="w-4 h-4 text-gray-300" /> JD (Obs)
                         </div>
                      </div>
                    </div>
                  </div>
                  
                  <div class="flex items-center gap-4">
                    <button class="px-6 py-3 text-[10px] font-black uppercase tracking-widest border border-gray-100 dark:border-gray-800 text-gray-500 hover:bg-white dark:hover:bg-gray-800 rounded-2xl transition-all shadow-sm">
                      Detalles
                    </button>
                    <button class="px-6 py-3 bg-indigo-600 text-white text-[10px] font-black uppercase tracking-widest rounded-2xl hover:bg-indigo-700 shadow-xl shadow-indigo-500/20 active:scale-95 transition-all">
                      Continuar
                    </button>
                  </div>
                </div>
              </div>

              <!-- Empty State inside Draggable -->
              <div v-if="statusGroup.tasks.length === 0" class="absolute inset-0 flex items-center justify-center p-8 opacity-40 pointer-events-none">
                <div class="text-center">
                  <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest italic">Sin misiones activas</span>
                </div>
              </div>
            </VueDraggableNext>
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
  SearchIcon,
  HorizontalDots
} from '@/icons'

const router = useRouter()
const viewMode = ref<'kanban' | 'list'>('kanban')
const searchQuery = ref('')
const filters = ref({
  fishery: '',
  observer: '',
  fishery2: '',
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

const fishery2Options = [
  { value: 'langostino', label: 'Langostino' },
  { value: 'merluza', label: 'Merluza' },
  { value: 'calamar', label: 'Calamar' },
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
    color: 'bg-indigo-500',
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
    color: 'bg-emerald-500',
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
    color: 'bg-blue-500',
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
    color: 'bg-gray-400',
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
    const targetGroup = columns.value.find((col) => col.id === columnId)
    if (targetGroup && !targetGroup.expanded) {
      targetGroup.expanded = true
    }
  }
}

const navigateToDetail = (id: number) => {
  router.push({ name: 'MareaDetalle', params: { id } })
}

const resetFilters = () => {
  searchQuery.value = ''
  filters.value = { fishery: '', observer: '', fishery2: '' }
}

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
  width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 20px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1f2937;
}

.custom-scrollbar-h::-webkit-scrollbar {
  height: 6px;
}
.custom-scrollbar-h::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar-h::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 20px;
}
.dark .custom-scrollbar-h::-webkit-scrollbar-thumb {
  background: #1f2937;
}

.animate-in {
  animation-duration: 0.7s;
  animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
}
.fade-in {
  animation-name: fade-in;
}

@keyframes fade-in {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Draggable ghost styling */
.sortable-ghost {
  opacity: 0.1;
  background: #6366f1 !important;
}
</style>
