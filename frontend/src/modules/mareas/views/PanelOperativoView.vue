<template>
  <AdminLayout 
    title="Panel Operativo de Mareas" 
    description="Monitoreo en tiempo real de las operaciones activas."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">

      <!-- Operational KPIs -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4 mb-6">
        <div
          v-for="kpi in kpis"
          :key="kpi.label"
          class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-4 rounded-2xl shadow-sm"
        >
          <div class="flex items-center justify-between mb-2">
            <span class="text-xs font-bold text-gray-400 uppercase tracking-wider">{{ kpi.label }}</span>
            <div :class="['p-2 rounded-xl', kpi.bg]">
              <component :is="kpi.icon" :class="['w-5 h-5', kpi.color]" />
            </div>
          </div>
          <div class="text-2xl font-black text-gray-800 dark:text-white">{{ kpi.value }}</div>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-6">
        <!-- Main Board -->
        <div class="col-span-12">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm transition-all"
            :class="{ 'mr-[400px]': isSidebarOpen }"
          >
            <div
              class="p-5 border-b border-gray-100 dark:border-gray-800 flex flex-col sm:flex-row items-center justify-between gap-4 bg-gray-50/30 dark:bg-gray-900/30"
            >
              <h2 class="font-black text-gray-800 dark:text-white flex items-center gap-2">
                <div class="w-2 h-2 rounded-full bg-brand-500 animate-pulse"></div>
                Mareas Activas
              </h2>
              <div class="flex flex-wrap items-center gap-3 w-full sm:w-auto">
                <div class="relative flex-1 sm:flex-none">
                  <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                    <SearchIcon class="w-4 h-4" />
                  </span>
                  <input
                    type="text"
                    placeholder="Filtrar por buque o ID..."
                    class="text-sm pl-9 pr-4 py-2.5 border border-gray-200 dark:border-gray-700 rounded-xl bg-white dark:bg-gray-800 focus:ring-2 focus:ring-brand-500/20 outline-none transition-all w-full sm:w-64"
                  />
                </div>
                <button 
                  @click="router.push('/mareas/nueva')"
                  class="flex items-center justify-center gap-2 px-4 py-2.5 bg-brand-500 text-white rounded-xl text-sm font-bold hover:bg-brand-600 transition-all shadow-lg shadow-brand-500/10 active:scale-95"
                >
                  <PlusIcon class="w-4 h-4" />
                  Nueva Marea
                </button>
              </div>
            </div>
            
            <div class="overflow-x-auto custom-scrollbar">
              <table class="w-full text-left">
                <thead
                  class="bg-gray-50/50 dark:bg-gray-800/50 text-[10px] font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 border-b border-gray-100 dark:border-gray-800"
                >
                  <tr>
                    <th class="px-6 py-4">Buque / Referencia</th>
                    <th class="px-6 py-4">Estado Operativo</th>
                    <th class="px-6 py-4">Zarpada</th>
                    <th class="px-6 py-4">Progreso</th>
                    <th class="px-6 py-4">Alertas</th>
                    <th class="px-6 py-4 text-right">Acciones</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
                  <tr
                    v-for="marea in mareas"
                    :key="marea.id"
                    @click="openSidebar(marea)"
                    class="group hover:bg-brand-50/30 dark:hover:bg-brand-900/10 transition-all cursor-pointer"
                    :class="{ 'bg-brand-50/50 dark:bg-brand-900/20 border-l-4 border-l-brand-500': selectedMarea?.id === marea.id }"
                  >
                    <td class="px-6 py-4">
                      <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-xl bg-gray-100 dark:bg-gray-800 flex items-center justify-center text-gray-500 group-hover:bg-brand-100 dark:group-hover:bg-brand-900/30 group-hover:text-brand-500 transition-colors">
                          <ShipIcon class="w-5 h-5" />
                        </div>
                        <div class="flex flex-col">
                          <span class="font-bold text-gray-900 dark:text-gray-100 leading-tight">{{ marea.buque_nombre }}</span>
                          <span class="text-[10px] font-mono text-gray-400 uppercase mt-0.5">{{ marea.id_marea }} • M{{ marea.nro_marea }}</span>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <span
                        class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-tighter"
                        :class="getStatusClasses(marea.estado)"
                      >
                        {{ marea.estado }}
                      </span>
                    </td>
                    <td class="px-6 py-4">
                      <div class="flex flex-col">
                        <span class="text-xs font-bold text-gray-700 dark:text-gray-300">{{ formatDate(marea.fecha_zarpada) }}</span>
                        <span class="text-[10px] text-gray-400">{{ marea.puerto || 'M. del Plata' }}</span>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <div class="flex items-center gap-3">
                        <div class="w-20 h-1.5 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
                          <div
                            class="h-full bg-brand-500 transition-all duration-1000"
                            :style="{ width: marea.progreso + '%' }"
                          ></div>
                        </div>
                        <span class="text-[10px] font-black text-gray-500">{{ marea.progreso }}%</span>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <div v-if="marea.alertas.length" class="flex items-center gap-1.5 px-2 py-1 bg-red-50 dark:bg-red-500/10 rounded-lg w-fit">
                        <div class="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse"></div>
                        <span class="text-[10px] font-black text-red-600 dark:text-red-400">{{ marea.alertas.length }}</span>
                      </div>
                      <span v-else class="text-[10px] font-bold text-gray-300">Ninguna</span>
                    </td>
                    <td class="px-6 py-4 text-right">
                      <div class="flex items-center justify-end gap-1 opacity-0 group-hover:opacity-100 transition-all">
                        <button class="p-2 hover:bg-white dark:hover:bg-gray-800 rounded-xl text-gray-400 hover:text-brand-500 transition-all shadow-sm">
                          <EditIcon class="w-4 h-4" />
                        </button>
                        <button class="p-2 hover:bg-white dark:hover:bg-gray-800 rounded-xl text-gray-400 hover:text-brand-500 transition-all shadow-sm">
                          <HorizontalDots class="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
              
              <!-- Empty State -->
              <div v-if="mareas.length === 0" class="p-20 flex flex-col items-center justify-center text-center">
                <div class="w-20 h-20 bg-gray-50 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4">
                  <ShipIcon class="w-10 h-10 text-gray-300" />
                </div>
                <h3 class="text-lg font-bold text-gray-800 dark:text-white">No hay mareas activas</h3>
                <p class="text-gray-500 text-sm mt-1 max-w-xs">No se encontraron operaciones en curso que coincidan con los filtros aplicados.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Context Sidebar -->
    <MareaContextSidebar 
      :is-open="isSidebarOpen"
      :marea="selectedMarea"
      @close="closeSidebar"
      @open-detalle="goToDetalle"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import MareaContextSidebar from '../components/MareaContextSidebar.vue'
import { 
  RefreshIcon, 
  PlusIcon, 
  DocsIcon, 
  WarningIcon, 
  CalenderIcon, 
  ShipIcon, 
  SearchIcon,
  HorizontalDots,
  EditIcon
} from '@/icons'

const router = useRouter()

// UI State
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)

const openSidebar = (marea: any) => {
  selectedMarea.value = marea
  isSidebarOpen.value = true
}

const closeSidebar = () => {
  isSidebarOpen.value = false
  setTimeout(() => {
    selectedMarea.value = null
  }, 300)
}

const goToDetalle = () => {
  if (selectedMarea.value) {
    router.push(`/mareas/${selectedMarea.value.id}`)
  }
}

// Mock Data
const kpis = [
  { label: 'Esperando Zarpada', value: 3, icon: CalenderIcon, color: 'text-amber-500', bg: 'bg-amber-50 dark:bg-amber-900/20' },
  { label: 'Navegando', value: 12, icon: RefreshIcon, color: 'text-blue-500', bg: 'bg-blue-50 dark:bg-blue-900/20' },
  { label: 'Designadas', value: 5, icon: PlusIcon, color: 'text-brand-500', bg: 'bg-brand-50 dark:bg-brand-900/20' },
  { label: 'En Revisión', value: 8, icon: DocsIcon, color: 'text-orange-500', bg: 'bg-orange-50 dark:bg-orange-900/20' },
  { label: 'Bloqueadas', value: 2, icon: WarningIcon, color: 'text-red-500', bg: 'bg-red-50 dark:bg-red-900/20' },
]

const mareas = ref(Array.from({ length: 12 }, (_, i) => ({
  id: i + 1,
  buque_nombre: i % 4 === 0 ? 'BP MARLIN azul' : i % 3 === 0 ? 'BP PESCADOR I' : 'BP ARGENTINO II',
  id_marea: `MA-24-0${10 + i}`,
  nro_marea: 120 + i,
  anio_marea: 2024,
  estado: i % 5 === 0 ? 'ESPERANDO ZARPADA' : i % 3 === 0 ? 'NAVEGANDO' : i % 4 === 0 ? 'BLOQUEADA' : 'ARRIBADA',
  fecha_zarpada: `2024-12-${10 + i}`,
  progreso: Math.min(Math.floor(Math.random() * 105), 100),
  alertas: i % 4 === 0 ? [{ id: 1, titulo: 'Inconsistencia detectada', descripcion: 'La zarpada real difiere de la estimada en más de 24hs.' }] : [],
  dias_marea: 15,
  dias_navegados: 10,
  puerto: i % 2 === 0 ? 'Mar del Plata' : 'Puerto Madryn'
})))

const getStatusClasses = (status: string) => {
  switch (status?.toUpperCase()) {
    case 'NAVEGANDO':
      return 'bg-blue-50 text-blue-700 dark:bg-blue-500/10 dark:text-blue-400'
    case 'ESPERANDO ZARPADA':
      return 'bg-amber-50 text-amber-700 dark:bg-amber-500/10 dark:text-amber-400'
    case 'BLOQUEADA':
      return 'bg-red-50 text-red-700 dark:bg-red-500/10 dark:text-red-400'
    case 'ARRIBADA':
      return 'bg-green-50 text-green-700 dark:bg-green-500/10 dark:text-green-400'
    default:
      return 'bg-gray-50 text-gray-700 dark:bg-gray-800 dark:text-gray-400'
  }
}

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('es-AR', { day: '2-digit', month: 'short' })
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e2e8f0;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1e293b;
}
</style>
