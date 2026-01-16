<template>
  <AdminLayout 
    title="Gestión de Flujo" 
    description="Gestión centralizada de mareas y estados operativos."
  >
    <div class="relative min-h-screen pb-20 animate-in fade-in duration-700">
      
      <!-- TOP ACTIONS & NAVIGATION -->
      <div class="mb-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-2xl bg-surface-muted border border-border flex items-center justify-center text-primary">
            <GridIcon v-if="viewMode === 'kanban'" class="w-6 h-6" />
            <ListIcon v-else class="w-6 h-6" />
          </div>
          <div>
            <h2 class="text-lg font-black text-text uppercase tracking-tighter leading-none">Gestión de Flujo</h2>
            <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-1">Arrastre las mareas para cambiar su estado</p>
          </div>
        </div>

        <ViewToggle v-model="viewMode" :options="viewOptions" />
      </div>

      <!-- ADVANCED FILTERS -->
      <FilterBar>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-6 items-end">
          <!-- Main Search -->
          <div class="lg:col-span-4">
            <label class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 block">Buscar Marea</label>
            <div class="relative group">
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Buque, código u observador..."
                class="w-full px-5 py-3 bg-surface-muted border border-border rounded-2xl text-xs font-black placeholder:text-text-muted/50 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none"
              />
              <SearchIcon class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted group-focus-within:text-primary transition-colors" />
            </div>
          </div>

          <!-- Selectors -->
          <div class="lg:col-span-2">
            <label class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 block">Flota</label>
            <SelectInput v-model="filters.fishery" :options="fisheryOptions" placeholder="Todas" />
          </div>
          <div class="lg:col-span-2">
            <label class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 block">Pesquería</label>
            <SelectInput v-model="filters.fishery2" :options="fishery2Options" placeholder="Todas" />
          </div>
          <div class="lg:col-span-2">
            <label class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 block">Observador</label>
            <SelectInput v-model="filters.observer" :options="observerOptions" placeholder="Cualquiera" />
          </div>

          <!-- Quick Actions -->
          <div class="lg:col-span-2 flex gap-2">
            <button class="flex-1 bg-text text-surface px-4 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:scale-[1.02] transition-all active:scale-95 shadow-lg shadow-text/10">
              Aplicar
            </button>
            <button @click="resetFilters" class="p-3 bg-surface-muted text-text-muted hover:text-text rounded-2xl transition-colors border border-border">
              <RefreshIcon class="w-5 h-5" />
            </button>
          </div>
        </div>
      </FilterBar>

      <!-- KANBAN VIEW -->
      <div v-if="viewMode === 'kanban'">
        <div
          v-if="loading"
          class="flex items-center justify-center h-[420px] bg-surface border border-border rounded-3xl"
        >
          <div class="flex flex-col items-center gap-3">
            <LoadingSpinner size="xl" class="text-primary" />
            <span class="text-xs font-bold text-text-muted uppercase tracking-[0.2em]">Cargando flujo...</span>
          </div>
        </div>

        <div
          v-else-if="columns.length === 0"
          class="flex items-center justify-center h-[420px] bg-surface border border-dashed border-border rounded-3xl text-center text-text-muted"
        >
          <div>
            <DocsIcon class="w-10 h-10 mx-auto mb-3 text-text-muted/20" />
            <p class="text-sm font-bold text-text">No hay mareas para mostrar.</p>
            <p class="text-xs text-text-muted mt-1">Ajuste filtros o registre una nueva marea.</p>
          </div>
        </div>

        <div v-else class="flex gap-6 overflow-x-auto pb-10 custom-scrollbar-h h-[calc(100vh-350px)] min-h-[500px]">
          <div v-for="(column, idx) in columns" :key="column.id" class="flex-shrink-0 w-[340px] flex flex-col group/col">
            <!-- Column Header -->
            <div class="mb-4 flex items-center justify-between px-2">
              <div class="flex items-center gap-3">
                <div class="w-2 h-2 rounded-full shadow-sm" :class="column.color"></div>
                <h3 class="text-xs font-black text-text uppercase tracking-widest">
                  {{ column.title }}
                </h3>
                <span class="text-[10px] font-black tabular-nums bg-surface-muted px-2.5 py-1 rounded-xl text-text-muted border border-border">
                  {{ column.tasks.length }}
                </span>
              </div>
              <button class="text-text-muted/40 hover:text-text opacity-0 group-hover/col:opacity-100 transition-opacity">
                <HorizontalDots class="w-4 h-4" />
              </button>
            </div>

            <!-- Draggable Container -->
            <div class="flex-1 bg-surface-muted/30 rounded-[2.5rem] border border-border p-3 overflow-y-auto custom-scrollbar active:bg-surface-muted/50 transition-colors">
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
                  class="group bg-surface p-6 rounded-[2rem] border border-border shadow-sm hover:shadow-xl hover:border-primary/30 transition-all duration-300 cursor-grab active:cursor-grabbing relative overflow-hidden"
                  @click="navigateToDetail(task.id)"
                >
                  <!-- Card Glow Backdrop -->
                  <div class="absolute -right-10 -top-10 w-24 h-24 bg-primary/5 blur-3xl rounded-full"></div>

                  <div class="flex justify-between items-start mb-4 relative z-10">
                    <div class="flex flex-col">
                      <span class="text-[9px] font-black text-primary uppercase tracking-widest mb-1">{{ task.code }}</span>
                      <h4 class="text-xs font-black text-text uppercase group-hover:text-primary transition-colors">{{ task.vessel }}</h4>
                    </div>
                    <div v-if="task.alert" class="w-2 h-2 rounded-full bg-error shadow-[0_0_10px_rgba(var(--error),0.5)] animate-pulse"></div>
                  </div>

                  <div class="space-y-4 relative z-10">
                    <div class="flex items-center gap-2 text-[10px] font-bold text-text-muted uppercase">
                      <CalenderIcon class="w-3.5 h-3.5" />
                      {{ task.date }}
                    </div>
                    <div class="flex items-center gap-2 text-[10px] font-bold text-text-muted uppercase">
                      <UserCircleIcon class="w-3.5 h-3.5" />
                      {{ task.observer || 'Sin observador' }}
                    </div>
                    
                    <div class="pt-4 border-t border-border flex items-center justify-between">
                      <span class="text-[9px] font-black text-text-muted uppercase tracking-tighter bg-surface-muted px-2 py-0.5 rounded-lg border border-border">
                        {{ task.port }}
                      </span>
                      <span class="text-[9px] font-black text-text-muted uppercase tracking-tighter bg-surface-muted px-2 py-0.5 rounded-lg border border-border">
                        {{ task.progress }}%
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
                    <DocsIcon class="w-8 h-8 mx-auto mb-2 text-text-muted/20" />
                    <span class="text-[10px] font-black text-text-muted uppercase tracking-widest italic">Vacío</span>
                  </div>
                </div>
              </VueDraggableNext>
            </div>
          </div>
        </div>
      </div>

      <!-- LIST VIEW -->
      <div v-else class="space-y-6 max-w-6xl mx-auto">
        <div
          v-if="loading"
          class="flex items-center justify-center h-48 bg-surface border border-border rounded-3xl"
        >
          <div class="flex flex-col items-center gap-3">
            <LoadingSpinner size="lg" class="text-primary" />
            <span class="text-xs font-bold text-text-muted uppercase tracking-[0.2em]">Cargando listado...</span>
          </div>
        </div>

        <div
          v-else-if="columns.length === 0"
          class="p-12 text-center bg-surface border border-dashed border-border rounded-3xl"
        >
          <p class="text-sm font-bold text-text">No hay mareas coincidentes.</p>
          <p class="text-xs text-text-muted mt-1">Revise los filtros o espere a nuevas asignaciones.</p>
        </div>

        <div
          v-else
          v-for="(statusGroup, idx) in columns"
          :key="statusGroup.id"
          class="bg-surface border border-border rounded-[2.5rem] overflow-hidden shadow-sm hover:shadow-lg transition-all"
        >
          <!-- Group Header -->
          <div
            class="px-8 py-5 flex items-center justify-between cursor-pointer hover:bg-surface-muted transition-colors border-b border-transparent"
            :class="{ 'border-border bg-surface-muted/30': statusGroup.expanded }"
            @click="statusGroup.expanded = !statusGroup.expanded"
          >
            <div class="flex items-center gap-4">
              <div class="w-2.5 h-2.5 rounded-full shadow-sm" :class="statusGroup.color"></div>
              <h2 class="text-sm font-black text-text uppercase tracking-widest">{{ statusGroup.title }}</h2>
              <span class="text-[10px] font-black bg-surface px-3 py-1 rounded-xl text-text-muted border border-border">
                {{ statusGroup.tasks.length }}
              </span>
            </div>
            <button class="w-8 h-8 flex items-center justify-center rounded-full border border-border hover:bg-surface transition-all shadow-sm" :class="{ 'rotate-180 bg-surface-muted': statusGroup.expanded }">
              <ChevronDownIcon class="w-4 h-4 text-text-muted" />
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
                class="p-5 hover:bg-surface-muted border border-transparent hover:border-border rounded-3xl transition-all cursor-pointer group/row relative overflow-hidden"
                @click="navigateToDetail(task.id)"
              >
                <!-- Row Glow -->
                <div class="absolute left-0 top-0 bottom-0 w-1 bg-primary scale-y-0 group-hover/row:scale-y-100 transition-transform origin-top"></div>

                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
                  <div class="flex items-center gap-6">
                    <!-- Drag Handle -->
                    <div class="drag-handle opacity-0 group-hover/row:opacity-100 transition-opacity p-2 -ml-2 text-text-muted/40 hover:text-primary cursor-grab active:cursor-grabbing">
                      <GripVerticalIcon class="w-5 h-5" />
                    </div>

                    <div class="w-14 h-14 rounded-2xl bg-surface-muted border border-border text-primary">
                      <DocsIcon class="w-7 h-7 opacity-60" />
                    </div>

                    <div>
                      <div class="flex items-center gap-3 mb-1.5">
                        <span class="text-[10px] font-black text-primary uppercase tracking-widest">{{ task.code }}</span>
                        <span v-if="task.alert" class="flex items-center gap-1 text-[8px] font-black uppercase bg-error/10 text-error px-2 py-1 rounded-lg border border-error/20">
                          <WarningIcon class="w-2.5 h-2.5" /> Alerta crítica
                        </span>
                      </div>
                      <h4 class="text-sm font-black text-text uppercase tracking-tight">{{ task.vessel }}</h4>
                      <div class="flex flex-wrap items-center gap-4 mt-3 text-[10px] font-black text-text-muted uppercase tracking-tighter">
                        <span class="flex items-center gap-1.5">
                          <CalenderIcon class="w-4 h-4 text-text-muted/40" /> {{ task.date }}
                        </span>
                        <span class="flex items-center gap-1.5">
                          <UserCircleIcon class="w-4 h-4 text-text-muted/40" /> {{ task.observer || 'Sin observador' }}
                        </span>
                        <span class="flex items-center gap-1.5">
                          <DocsIcon class="w-3 h-3 text-text-muted/40" /> {{ task.port }}
                        </span>
                      </div>
                    </div>
                  </div>
                  
                  <div class="flex items-center gap-4">
                    <span class="px-4 py-2 text-[10px] font-black uppercase tracking-widest border border-border text-text-muted rounded-2xl">
                      {{ task.progress }}%
                    </span>
                    <button
                      @click.stop="navigateToDetail(task.id)"
                      class="px-6 py-3 bg-primary text-primary-fg text-[10px] font-black uppercase tracking-widest rounded-2xl hover:bg-primary/90 shadow-xl shadow-primary/20 active:scale-95 transition-all"
                    >
                      Ver detalle
                    </button>
                  </div>
                </div>
              </div>

              <!-- Empty State inside Draggable -->
              <div v-if="statusGroup.tasks.length === 0" class="absolute inset-0 flex items-center justify-center p-8 opacity-40 pointer-events-none">
                <div class="text-center">
                  <span class="text-[10px] font-black text-text-muted uppercase tracking-widest italic">Sin mareas activas</span>
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
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { VueDraggableNext } from 'vue-draggable-next'
import { toast } from 'vue-sonner'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
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
import { useMareas } from '../composables/useMareas'
import type { MareaListItem } from '../services/mareas.service'

const router = useRouter()
const { loading, mareas, kpis, fetchDashboard, error } = useMareas()

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

const observerOptions = computed(() => {
  const unique = Array.from(new Set(mareas.value.map((m) => m.observador).filter((obs): obs is string => !!obs)))
  return unique.map((obs) => ({ value: obs, label: obs }))
})

const fishery2Options = [
  { value: 'langostino', label: 'Langostino' },
  { value: 'merluza', label: 'Merluza' },
  { value: 'calamar', label: 'Calamar' },
]

interface Task {
  id: string
  code: string
  vessel: string
  date: string
  observer: string | null
  port: string
  progress: number
  alert: boolean
  estado: string
  estadoCodigo: string
}

interface Column {
  id: string
  title: string
  color: string
  expanded: boolean
  tasks: Task[]
}

const statusColors: Record<string, string> = {
  DESIGNADA: 'bg-primary',
  EN_EJECUCION: 'bg-primary',
  ESPERANDO_ENTREGA: 'bg-warning',
  ENTREGADA_RECIBIDA: 'bg-success',
  VERIFICACION_INICIAL: 'bg-info',
  EN_CORRECCION: 'bg-warning',
  PENDIENTE_DE_INFORME: 'bg-info',
  ESPERANDO_REVISION: 'bg-info',
  ESPERANDO_PROTOCOLIZACION: 'bg-primary',
  PROTOCOLIZADA: 'bg-text-muted'
}

const columns = ref<Column[]>([])

const formatShortDate = (date?: string) => {
  if (!date) return 'Fecha pendiente'
  const parsed = new Date(date)
  if (Number.isNaN(parsed.getTime())) return 'Fecha pendiente'
  return parsed.toLocaleDateString('es-AR', { day: '2-digit', month: 'short' })
}

const toTask = (m: MareaListItem): Task => ({
  id: m.id,
  code: m.id_marea,
  vessel: m.buque_nombre,
  date: formatShortDate(m.fecha_zarpada),
  observer: m.observador || null,
  port: m.puerto,
  progress: m.progreso,
  alert: (m.alertas?.length || 0) > 0,
  estado: m.estado,
  estadoCodigo: m.estado_codigo,
})

const filteredMareas = computed(() => {
  const term = searchQuery.value.trim().toLowerCase()
  const observerFilter = filters.value.observer

  return mareas.value.filter((m) => {
    const matchesSearch = !term || m.buque_nombre.toLowerCase().includes(term) || m.id_marea.toLowerCase().includes(term) || m.observador?.toLowerCase()?.includes(term)
    const matchesObserver = !observerFilter || m.observador === observerFilter
    return matchesSearch && matchesObserver
  })
})

const buildColumns = (items: MareaListItem[]) => {
  const previousExpanded = new Map(columns.value.map((col) => [col.id, col.expanded]))
  const baseOrder = kpis.value.length ? kpis.value.map((k) => k.codigo) : []
  const map = new Map<string, Column>()

  const ensureColumn = (id: string, title: string) => {
    if (map.has(id)) return
    map.set(id, {
      id,
      title,
      color: statusColors[id] || 'bg-gray-400',
      expanded: previousExpanded.get(id) ?? true,
      tasks: []
    })
  }

  baseOrder.forEach((codigo) => {
    const label = kpis.value.find((k) => k.codigo === codigo)?.label || codigo
    ensureColumn(codigo, label)
  })

  items.forEach((item) => {
    ensureColumn(item.estado_codigo, item.estado)
    map.get(item.estado_codigo)?.tasks.push(toTask(item))
  })

  const ordered = [
    ...baseOrder
      .map((id) => map.get(id))
      .filter(Boolean) as Column[],
    ...Array.from(map.entries())
      .filter(([id]) => !baseOrder.includes(id))
      .map(([, col]) => col)
  ]

  columns.value = ordered
}

watch(filteredMareas, (items) => buildColumns(items), { immediate: true })

const loadDashboard = async () => {
  await fetchDashboard()
  if (error.value) {
    toast.error('No pudimos cargar las mareas. Por favor, intente nuevamente.')
  }
}

const onDragChange = (event: any, columnId: string) => {
  if (event.added) {
    const targetGroup = columns.value.find((col) => col.id === columnId)
    if (targetGroup && !targetGroup.expanded) {
      targetGroup.expanded = true
    }
  }
}

const navigateToDetail = (id: string) => {
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
  loadDashboard()
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
  background: var(--color-border);
  border-radius: 20px;
}

.custom-scrollbar-h::-webkit-scrollbar {
  height: 6px;
}
.custom-scrollbar-h::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar-h::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 20px;
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
  background: var(--color-primary) !important;
}
</style>
