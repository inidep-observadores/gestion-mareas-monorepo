<template>
  <AdminLayout
    title="Panel Operativo de Mareas"
    description="Monitoreo en tiempo real de las operaciones activas."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">

      <!-- Filtros Compactos ( Airport Board Style ) -->
      <div class="flex flex-wrap items-center gap-3 mb-6">
        <span class="text-[10px] font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 mr-2">
          Filtrar por estado:
        </span>
        <StatusFilterChip
          v-for="kpi in kpis"
          :key="kpi.label"
          :label="kpi.label"
          :value="kpi.value"
          :icon="kpi.icon"
          :active="!hiddenStates.has(kpi.codigo)"
          :color-class="kpi.color"
          :bg-class="kpi.bg"
          :border-class="kpi.border"
          @click="toggleStateVisibility(kpi.codigo)"
        />
      </div>

      <div class="grid grid-cols-12 gap-6">
        <!-- Main Board -->
        <div class="col-span-12">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm transition-all"
            :class="{ 'mr-[400px]': isSidebarOpen }"
          >
            <div
              class="py-3 px-5 border-b border-gray-100 dark:border-gray-800 flex flex-col sm:flex-row items-center justify-between gap-4 bg-gray-50/30 dark:bg-gray-900/30"
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
                    v-model="searchQuery"
                    type="text"
                    placeholder="Filtrar por buque o marea..."
                    class="text-sm pl-9 pr-4 py-2 border border-gray-200 dark:border-gray-700 rounded-xl bg-white dark:bg-gray-800 focus:ring-2 focus:ring-brand-500/20 outline-none transition-all w-full sm:w-64"
                  />
                </div>
                <button
                  v-if="!isReadOnly"
                  @click="router.push('/mareas/nueva')"
                  class="flex items-center justify-center gap-2 px-4 py-2 bg-brand-500 text-white rounded-xl text-sm font-bold hover:bg-brand-600 transition-all shadow-lg shadow-brand-500/10 active:scale-95"
                >
                  <PlusIcon class="w-4 h-4" />
                  Nueva Marea
                </button>
              </div>
            </div>

            <div class="overflow-x-auto custom-scrollbar">
              <!-- Loading State -->
              <div v-if="loading && mareas.length === 0" class="p-20 flex flex-col items-center">
                <div class="loading loading-spinner loading-lg text-brand-500"></div>
                <span class="mt-4 text-gray-500 font-bold">Cargando operaciones...</span>
              </div>

              <table v-else class="w-full text-left">
                <thead
                  class="bg-gray-50/50 dark:bg-gray-800/50 text-[10px] font-black uppercase tracking-widest text-gray-400 dark:text-gray-500 border-b border-gray-100 dark:border-gray-800"
                >
                  <tr>
                    <th @click="toggleSort('id_marea')" class="px-4 py-2 w-28 cursor-pointer hover:text-brand-500 transition-colors group">
                      <div class="flex items-center gap-1">
                        Marea
                        <ChevronDownIcon 
                          v-if="sortBy === 'id_marea'"
                          class="w-3 h-3 text-brand-500 transition-transform duration-300" 
                          :class="{ 'rotate-180': sortOrder === 'asc' }"
                        />
                      </div>
                    </th>
                    <th @click="toggleSort('buque_nombre')" class="px-5 py-2 cursor-pointer hover:text-brand-500 transition-colors group">
                      <div class="flex items-center gap-1">
                        Buque
                        <ChevronDownIcon 
                          v-if="sortBy === 'buque_nombre'"
                          class="w-3 h-3 text-brand-500 transition-transform duration-300" 
                          :class="{ 'rotate-180': sortOrder === 'asc' }"
                        />
                      </div>
                    </th>
                    <th @click="toggleSort('estado')" class="px-5 py-2 cursor-pointer hover:text-brand-500 transition-colors group">
                      <div class="flex items-center gap-1">
                        Estado Operativo
                        <ChevronDownIcon 
                          v-if="sortBy === 'estado'"
                          class="w-3 h-3 text-brand-500 transition-transform duration-300" 
                          :class="{ 'rotate-180': sortOrder === 'asc' }"
                        />
                      </div>
                    </th>
                    <th @click="toggleSort('fecha_zarpada')" class="px-5 py-2 cursor-pointer hover:text-brand-500 transition-colors group">
                      <div class="flex items-center gap-1">
                        Zarpada
                        <ChevronDownIcon 
                          v-if="sortBy === 'fecha_zarpada'"
                          class="w-3 h-3 text-brand-500 transition-transform duration-300" 
                          :class="{ 'rotate-180': sortOrder === 'asc' }"
                        />
                      </div>
                    </th>
                    <th @click="toggleSort('progreso')" class="px-5 py-2 cursor-pointer hover:text-brand-500 transition-colors group">
                      <div class="flex items-center gap-1">
                        Progreso
                        <ChevronDownIcon 
                          v-if="sortBy === 'progreso'"
                          class="w-3 h-3 text-brand-500 transition-transform duration-300" 
                          :class="{ 'rotate-180': sortOrder === 'asc' }"
                        />
                      </div>
                    </th>
                    <th @click="toggleSort('alertas')" class="px-5 py-2 cursor-pointer hover:text-brand-500 transition-colors group">
                      <div class="flex items-center gap-1">
                        Alertas
                        <ChevronDownIcon 
                          v-if="sortBy === 'alertas'"
                          class="w-3 h-3 text-brand-500 transition-transform duration-300" 
                          :class="{ 'rotate-180': sortOrder === 'asc' }"
                        />
                      </div>
                    </th>
                    <th class="px-5 py-2 text-right">Acciones</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
                  <tr
                    v-for="marea in filteredMareas"
                    :key="marea.id"
                    @click="openSidebar(marea)"
                    class="group odd:bg-gray-100/60 dark:odd:bg-gray-800/40 hover:bg-brand-50/30 dark:hover:bg-brand-900/10 transition-all cursor-pointer border-l-4 border-l-transparent"
                    :class="{ 'bg-brand-50/50 dark:bg-brand-900/20 !border-l-brand-500': selectedMarea?.id === marea.id }"
                  >
                    <td class="px-4 py-1.5 w-28 focus-within:ring-0">
                      <span class="text-[11px] font-mono font-bold text-gray-500 dark:text-gray-400 uppercase leading-none">{{ marea.id_marea }}</span>
                    </td>
                    <td class="px-5 py-1.5">
                      <div class="flex items-center gap-2.5">
                        <div class="w-7 h-7 rounded-lg bg-gray-100 dark:bg-gray-800 flex items-center justify-center text-gray-500 group-hover:bg-brand-100 dark:group-hover:bg-brand-900/30 group-hover:text-brand-500 transition-colors">
                          <ShipIcon class="w-3.5 h-3.5" />
                        </div>
                        <span class="text-sm font-bold text-gray-900 dark:text-gray-100 leading-none">{{ marea.buque_nombre }}</span>
                      </div>
                    </td>
                    <td class="px-5 py-1.5">
                      <span
                        class="px-2 py-0.5 rounded-full text-[10px] font-black uppercase tracking-tighter"
                        :class="getStatusClasses(marea.estado_codigo)"
                      >
                        {{ marea.estado }}
                      </span>
                    </td>
                    <td class="px-5 py-1.5">
                      <div class="flex flex-col">
                        <span class="text-xs font-bold text-gray-700 dark:text-gray-300 leading-none">{{ formatDate(marea.fecha_zarpada) }}</span>
                        <span class="text-[10px] text-gray-400 leading-none mt-1">{{ marea.puerto }}</span>
                      </div>
                    </td>
                    <td class="px-5 py-1.5">
                      <div class="flex items-center gap-2">
                        <div class="w-16 h-1 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
                          <div
                            class="h-full transition-all duration-1000"
                            :class="marea.progreso > 100 ? 'bg-red-500' : 'bg-emerald-500'"
                            :style="{ width: marea.progreso + '%' }"
                          ></div>
                        </div>
                        <span class="text-[10px] font-black text-gray-500">{{ marea.progreso }}%</span>
                      </div>
                    </td>
                    <td class="px-5 py-1.5">
                      <div v-if="marea.alertas?.length" class="flex items-center gap-1.5 px-2 py-0.5 bg-red-50 dark:bg-red-500/10 rounded-lg w-fit">
                        <div class="w-1 h-1 rounded-full bg-red-500 animate-pulse"></div>
                        <span class="text-[10px] font-black text-red-600 dark:text-red-400">{{ marea.alertas.length }}</span>
                      </div>
                      <span v-else class="text-[10px] font-bold text-gray-300 dark:text-gray-700">Ninguna</span>
                    </td>
                    <td class="px-5 py-1.5 text-right">
                      <div class="flex items-center justify-end gap-1 opacity-0 group-hover:opacity-100 transition-all">
                        <button class="p-1.5 hover:bg-white dark:hover:bg-gray-800 rounded-lg text-gray-400 hover:text-brand-500 transition-all shadow-sm">
                          <HorizontalDots class="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>

              <!-- Empty State -->
              <div v-if="!loading && filteredMareas.length === 0" class="p-20 flex flex-col items-center justify-center text-center">
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

    <MareaContextSidebar
      :is-open="isSidebarOpen"
      :marea="selectedMarea"
      :context="selectedMareaContext"
      :read-only="isReadOnly"
      @close="closeSidebar"
      @open-detalle="goToDetalle"
      @action="executeActionFromSidebar"
    />

    <GestionEtapasMareaDialog
       :show="showGestionDialog"
       :mode="gestionMode"
       :marea="mareaToManage"
       :currentStages="mareaToManage?.etapas || []"
       :initialPortId="mareaToManage?.puertoBaseId"
       @close="handleGestionCancel"
       @confirm="handleGestionConfirm"
    />

    <RecibirArchivosDialog
       :show="showRecibirDialog"
       :marea="mareaToManage"
       @close="handleRecibirCancel"
       @confirm="handleRecibirConfirm"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import MareaContextSidebar from '../components/MareaContextSidebar.vue'
import GestionEtapasMareaDialog from '../components/GestionEtapasMareaDialog.vue'
import RecibirArchivosDialog from '../components/RecibirArchivosDialog.vue'
import StatusFilterChip from '../components/StatusFilterChip.vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useMareas } from '../composables/useMareas'
import {
  ShipIcon,
  SearchIcon,
  HorizontalDots,
  EditIcon,
  TaskIcon,
  HistoryIcon,
  ArchiveIcon,
  FileTextIcon,
  PlusIcon,
  ChevronDownIcon
} from '@/icons'

const router = useRouter()
const route = useRoute()
const {
  loading,
  kpis: rawKpis,
  mareas,
  fetchDashboard,
  fetchMareaContext,
  executeAction,
  selectedMareaContext,
  hiddenStates,
  searchQuery,
  sortBy,
  sortOrder,
  filteredMareas,
  toggleStateVisibility,
  setVisibleStates,
  toggleSort
} = useMareas()

const authStore = useAuthStore()
const isReadOnly = computed(() => {
  const roles = authStore.user?.roles || []
  return !roles.includes('admin') && !roles.includes('coordinador')
})

// UI State
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)
const showGestionDialog = ref(false)
const showRecibirDialog = ref(false)
const gestionMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('INICIAR')
const mareaToManage = ref<any>(null)

// Map icons/colors to backend kpis
const getKpiMeta = (codigo: string) => {
  const meta: Record<string, any> = {
    'DESIGNADA': { 
      icon: TaskIcon, 
      color: 'text-blue-500', 
      border: 'border-blue-500/50 dark:border-blue-400/30',
      bg: 'bg-blue-50 dark:bg-blue-900/20' 
    },
    'EN_EJECUCION': { 
      icon: ShipIcon, 
      color: 'text-indigo-500', 
      border: 'border-indigo-500/50 dark:border-indigo-400/30',
      bg: 'bg-indigo-50 dark:bg-indigo-900/20' 
    },
    'ESPERANDO_ENTREGA': { 
      icon: HistoryIcon, 
      color: 'text-amber-500', 
      border: 'border-amber-500/50 dark:border-amber-400/30',
      bg: 'bg-amber-50 dark:bg-amber-900/20' 
    },
    'ENTREGADA_RECIBIDA': { 
      icon: ArchiveIcon, 
      color: 'text-emerald-500', 
      border: 'border-emerald-500/50 dark:border-emerald-400/30',
      bg: 'bg-emerald-50 dark:bg-emerald-900/20' 
    },
    'VERIFICACION_INICIAL': { 
      icon: SearchIcon, 
      color: 'text-cyan-500', 
      border: 'border-cyan-500/50 dark:border-cyan-400/30',
      bg: 'bg-cyan-50 dark:bg-cyan-900/20' 
    },
    'EN_CORRECCION': { 
      icon: EditIcon, 
      color: 'text-orange-500', 
      border: 'border-orange-500/50 dark:border-orange-400/30',
      bg: 'bg-orange-50 dark:bg-orange-900/20' 
    },
    'PENDIENTE_DE_INFORME': { 
      icon: FileTextIcon, 
      color: 'text-purple-500', 
      border: 'border-purple-500/50 dark:border-purple-400/30',
      bg: 'bg-purple-50 dark:bg-purple-900/20' 
    },
  }
  return meta[codigo] || { icon: ShipIcon, color: 'text-gray-500', border: 'border-gray-200 dark:border-gray-800', bg: 'bg-gray-50 dark:bg-gray-900/20' }
}

const kpis = computed(() => {
  return rawKpis.value.map(k => ({
    ...k,
    ...getKpiMeta(k.codigo)
  }))
})

const applyFilter = async () => {
  await fetchDashboard()
  const estadoParam = route.query.estado as string | undefined
  if (estadoParam) {
    const allowed = estadoParam.split(',').map(s => s.trim()).filter(Boolean)
    if (allowed.length) {
      setVisibleStates(allowed)
      return
    }
  }
  setVisibleStates(rawKpis.value.map(k => k.codigo))
}

onMounted(() => {
  applyFilter()
})

watch(
  () => route.query.estado,
  () => {
    applyFilter()
  }
)

const openSidebar = async (marea: any) => {
  selectedMarea.value = marea
  isSidebarOpen.value = true
  await fetchMareaContext(marea.id)
}

const executeActionFromSidebar = async (actionKey: string) => {
  if (!selectedMarea.value) return

  const mareaContext = selectedMareaContext.value?.marea || selectedMarea.value

  if (actionKey === 'REGISTRAR_INICIO') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'INICIAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'EDITAR_ETAPAS') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'EDITAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'REGISTRAR_ARRIBO') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'FINALIZAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'RECIBIR_DATOS') {
    mareaToManage.value = mareaContext
    showRecibirDialog.value = true
    return
  }

  try {
    await executeAction(selectedMarea.value.id, actionKey)
    closeSidebar()
  } catch (err) {
    console.error('Action failed:', err)
  }
}

const handleGestionCancel = () => {
    showGestionDialog.value = false
    closeSidebar()
}

const handleGestionConfirm = async (payload: any) => {
    try {
        const actionKey = gestionMode.value === 'INICIAR' 
            ? 'REGISTRAR_INICIO' 
            : gestionMode.value === 'FINALIZAR' 
                ? 'REGISTRAR_ARRIBO' 
                : 'EDITAR_ETAPAS';

        await executeAction(mareaToManage.value.id, actionKey, payload)
        showGestionDialog.value = false
        mareaToManage.value = null
        closeSidebar()
        await fetchDashboard()
    } catch (err) {
        console.error("Error en gestión de marea:", err)
    }
}

const handleRecibirCancel = () => {
    showRecibirDialog.value = false
    closeSidebar()
}

const handleRecibirConfirm = async (payload: any) => {
    try {
        await executeAction(mareaToManage.value.id, 'RECIBIR_DATOS', payload)
        showRecibirDialog.value = false
        mareaToManage.value = null
        closeSidebar()
        await fetchDashboard()
    } catch (err) {
        console.error("Error en recepción de archivos:", err)
    }
}

const closeSidebar = () => {
  isSidebarOpen.value = false
  setTimeout(() => {
    selectedMarea.value = null
  }, 300)
}

const goToDetalle = () => {
  if (selectedMarea.value) {
    router.push({ name: 'MareaDetalle', params: { id: selectedMarea.value.id } })
  }
}

const getStatusClasses = (status?: string) => {
  if (!status) return 'bg-gray-50 text-gray-700 dark:bg-gray-800 dark:text-gray-400'

  const s = status.toUpperCase()
  if (s === 'DESIGNADA')
    return 'bg-blue-50 text-blue-700 dark:bg-blue-500/10 dark:text-blue-400'
  if (s === 'EN_EJECUCION' || s === 'NAVEGANDO')
    return 'bg-indigo-50 text-indigo-700 dark:bg-indigo-500/10 dark:text-indigo-400'
  if (s === 'ESPERANDO_ENTREGA')
    return 'bg-amber-50 text-amber-700 dark:bg-amber-500/10 dark:text-amber-400'
  if (s === 'ENTREGADA_RECIBIDA')
    return 'bg-emerald-50 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-400'
  if (s === 'VERIFICACION_INICIAL')
    return 'bg-cyan-50 text-cyan-700 dark:bg-cyan-500/10 dark:text-cyan-400'
  if (s === 'EN_CORRECCION')
    return 'bg-orange-50 text-orange-700 dark:bg-orange-500/10 dark:text-orange-400'
  if (s === 'PENDIENTE_DE_INFORME')
    return 'bg-purple-50 text-purple-700 dark:bg-purple-500/10 dark:text-purple-400'

  return 'bg-gray-50 text-gray-700 dark:bg-gray-800 dark:text-gray-400'
}

const formatDate = (date?: string) => {
  if (!date) return 'N/D'
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
