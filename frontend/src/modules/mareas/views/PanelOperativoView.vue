<template>
  <AdminLayout
    title="Panel Operativo de Mareas"
    description="Monitoreo en tiempo real de las operaciones activas."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">

      <!-- Filtros Compactos ( Airport Board Style ) -->
      <div class="flex flex-wrap items-center gap-3 mb-6">
        <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-2">
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

      <div class="flex flex-col xl:flex-row gap-6 overflow-hidden">
        <!-- Main Board -->
        <div class="flex-1 w-full min-w-0 transition-all duration-300">
          <div
            class="bg-surface border border-border rounded-2xl overflow-hidden shadow-sm"
          >
            <div
              class="py-3 px-5 border-b border-border flex flex-col sm:flex-row items-center justify-between gap-4 bg-surface-muted/30"
            >
              <h2 class="font-black text-text flex items-center gap-2">
                <div class="w-2 h-2 rounded-full bg-primary animate-pulse"></div>
                Mareas Activas
              </h2>
              <div class="flex flex-wrap items-center gap-3 w-full sm:w-auto">
                <SearchInput
                  v-model="searchQuery"
                  placeholder="Filtrar por buque o marea..."
                />
                <button
                  v-if="!isReadOnly"
                  @click="router.push('/mareas/nueva')"
                  class="flex items-center justify-center gap-2 px-4 py-2 bg-primary text-primary-fg rounded-xl text-sm font-bold hover:bg-primary-hover transition-all shadow-lg shadow-primary/20 active:scale-95"
                >
                  <PlusIcon class="w-4 h-4" />
                  Nueva Marea
                </button>
              </div>
            </div>

            <div class="flex-1 overflow-y-auto custom-scrollbar">
              <!-- Loading State -->
              <div v-if="loading" class="flex items-center justify-center h-full py-20 flex-col">
                <LoadingSpinner size="xl" class="text-primary" />
                <span class="mt-4 text-text-muted font-bold">Cargando operaciones...</span>
              </div>

              <template v-else-if="filteredMareas.length > 0">
                <!-- VISTA MÓVIL: TARJETAS COMPACTAS -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 p-4 xl:hidden">
                  <div
                    v-for="marea in filteredMareas"
                    :key="marea.id"
                    @click="openSidebar(marea)"
                    class="bg-surface border border-border rounded-2xl p-4 shadow-sm active:scale-[0.98] transition-all hover:border-primary/50"
                  >
                    <!-- Header Tarjeta -->
                    <div class="flex justify-between items-start mb-3">
                      <span class="text-[10px] font-mono font-black text-text-muted/60 uppercase tracking-widest bg-surface-muted px-2 py-0.5 rounded">
                        {{ marea.id_marea }}
                      </span>
                      <div class="flex flex-col items-end gap-1">
                        <div class="flex items-center gap-1">
                          <span v-if="marea.total_etapas > 1 && marea.estado_codigo === 'EN_EJECUCION'" class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[9px] font-black uppercase tracking-tighter border border-border">
                            Etapa {{ marea.total_etapas }}
                          </span>
                          <span
                            class="px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-tighter"
                            :class="getStatusClasses(marea.estado_codigo)"
                          >
                            {{ marea.estado }}
                          </span>
                        </div>
                        <span v-if="marea.en_tierra" class="px-2 py-0.5 bg-success/10 text-success rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap flex items-center gap-1 border border-success/20">
                          <div class="w-1 h-1 rounded-full bg-success animate-pulse"></div>
                          En Tierra
                        </span>
                      </div>
                    </div>

                    <!-- Datos Principales -->
                    <div class="mb-3">
                      <div class="flex items-center gap-2 mb-1">
                        <ShipIcon class="w-3.5 h-3.5 text-primary" />
                        <h4 class="text-sm font-black text-text">{{ marea.buque_nombre }}</h4>
                      </div>
                      <p class="text-xs font-bold text-text-muted truncate">{{ marea.observador || 'No asignado' }}</p>
                    </div>

                    <!-- Info Operativa -->
                    <div class="flex items-center justify-between gap-4 pt-3 border-t border-border">
                      <div class="flex-1">
                        <div class="flex justify-between items-center mb-1">
                          <span class="text-[9px] font-bold text-text-muted uppercase tracking-widest">Progreso</span>
                          <span class="text-[10px] font-black" :class="marea.progreso > 100 ? 'text-error' : 'text-primary'">{{ marea.progreso }}%</span>
                        </div>
                        <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
                          <div 
                            class="h-full transition-all duration-1000"
                            :class="marea.progreso > 100 ? 'bg-error' : 'bg-primary'"
                            :style="{ width: marea.progreso + '%' }"
                          ></div>
                        </div>
                      </div>
                      
                      <div v-if="marea.alertas?.length" class="flex items-center gap-1.5 px-2 py-1 bg-error/10 rounded-lg shrink-0">
                        <WarningIcon class="w-3 h-3 text-error" />
                        <span class="text-[10px] font-black text-error">{{ marea.alertas.length }}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- VISTA ESCRITORIO: TABLA (Oculta en móviles) -->
                <div class="hidden xl:block overflow-x-auto">
                  <table class="w-full text-left">
                    <thead class="bg-surface-muted/50 text-[10px] font-black uppercase tracking-widest text-text-muted border-b border-border">
                      <tr>
                        <th @click="toggleSort('id_marea')" class="px-4 py-2 w-28 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Marea
                            <ChevronDownIcon v-if="sortBy === 'id_marea'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('buque_nombre')" class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Buque
                            <ChevronDownIcon v-if="sortBy === 'buque_nombre'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('estado')" class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Estado Operativo
                            <ChevronDownIcon v-if="sortBy === 'estado'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('fecha_zarpada')" class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Zarpada
                            <ChevronDownIcon v-if="sortBy === 'fecha_zarpada'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('progreso')" class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Progreso
                            <ChevronDownIcon v-if="sortBy === 'progreso'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('alertas')" class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Alertas
                            <ChevronDownIcon v-if="sortBy === 'alertas'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="selectedMarea" @click="toggleSort('observador')" class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Observador
                            <ChevronDownIcon v-if="sortBy === 'observador'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th class="px-5 py-2 text-right">Acciones</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                      <tr
                        v-for="marea in filteredMareas"
                        :key="marea.id"
                        @click="openSidebar(marea)"
                        class="group odd:bg-surface-muted/30 hover:bg-primary/5 transition-all cursor-pointer border-l-4 border-l-transparent"
                        :class="{ 'bg-primary/10 !border-l-primary': selectedMarea?.id === marea.id }"
                      >
                        <td class="px-4 py-1.5 w-28 focus-within:ring-0">
                          <span class="text-[11px] font-mono font-bold text-text-muted uppercase leading-none">{{ marea.id_marea }}</span>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex items-center gap-2.5">
                            <div class="w-7 h-7 rounded-lg bg-surface-muted flex items-center justify-center text-text-muted group-hover:bg-primary/10 group-hover:text-primary transition-colors">
                              <ShipIcon class="w-3.5 h-3.5" />
                            </div>
                            <span class="text-sm font-bold text-text leading-none">{{ marea.buque_nombre }}</span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div class="flex items-center gap-2">
                            <span v-if="marea.total_etapas > 1 && marea.estado_codigo === 'EN_EJECUCION'" class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[10px] font-black uppercase tracking-tighter border border-border">
                              Etapa {{ marea.total_etapas }}
                            </span>
                            <span class="px-2 py-0.5 rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap" :class="getStatusClasses(marea.estado_codigo)">
                              {{ marea.estado }}
                            </span>
                            <span v-if="marea.en_tierra" class="px-2 py-0.5 bg-success/10 text-success rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap flex items-center gap-1 border border-success/20">
                              <div class="w-1 h-1 rounded-full bg-success animate-pulse"></div>
                              En Tierra
                            </span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div class="flex flex-col">
                            <span class="text-xs font-bold text-text leading-none">{{ formatDate(marea.fecha_zarpada) }}</span>
                            <span class="text-[10px] text-text-muted leading-none mt-1">{{ marea.puerto }}</span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div class="flex items-center gap-2">
                            <div class="w-16 h-1 bg-surface-muted rounded-full overflow-hidden">
                              <div class="h-full transition-all duration-1000" :class="marea.progreso > 100 ? 'bg-error' : 'bg-success'" :style="{ width: marea.progreso + '%' }"></div>
                            </div>
                            <span class="text-[10px] font-black text-text-muted">{{ marea.progreso }}%</span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div v-if="marea.alertas?.length" class="flex items-center gap-1.5 px-2 py-0.5 bg-error/10 rounded-lg w-fit">
                            <div class="w-1 h-1 rounded-full bg-error animate-pulse"></div>
                            <span class="text-[10px] font-black text-error">{{ marea.alertas.length }}</span>
                          </div>
                          <span v-else class="text-[10px] font-bold text-text-muted/40">Ninguna</span>
                        </td>
                        <td v-if="selectedMarea" class="px-5 py-1.5">
                          <span class="text-sm font-bold text-text-muted">{{ marea.observador || 'No asignado' }}</span>
                        </td>
                        <td class="px-5 py-1.5 text-right">
                          <div class="flex items-center justify-end gap-1 opacity-0 group-hover:opacity-100 transition-all">
                            <button class="p-1.5 hover:bg-surface rounded-lg text-text-muted hover:text-primary transition-all shadow-sm">
                              <HorizontalDots class="w-3.5 h-3.5" />
                            </button>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </template>

              <!-- Empty State -->
              <div v-else class="p-20 flex flex-col items-center justify-center text-center">
                <div class="w-20 h-20 bg-surface-muted rounded-full flex items-center justify-center mb-4">
                  <ShipIcon class="w-10 h-10 text-text-muted/40" />
                </div>
                <h3 class="text-lg font-bold text-text">No hay mareas activas</h3>
                <p class="text-text-muted text-sm mt-1 max-w-xs">No se encontraron operaciones en curso que coincidan con los filtros aplicados.</p>
              </div>
            </div>
          </div>
        </div>

        <!-- PANEL DE DETALLE LATERAL PERSISTENTE -->
        <Transition
          enter-active-class="transition duration-300 ease-out"
          enter-from-class="translate-x-4 opacity-0"
          enter-to-class="translate-x-0 opacity-100"
          leave-active-class="transition duration-200 ease-in"
          leave-from-class="translate-x-0 opacity-100"
          leave-to-class="translate-x-4 opacity-0"
        >
          <div 
            v-if="selectedMarea"
            class="w-full xl:w-[400px] shrink-0 sticky top-0 bg-surface border border-border rounded-2xl shadow-sm overflow-hidden self-start hidden xl:block z-10"
          >
            <MareaContextDetailContent 
              :marea="selectedMarea"
              :context="selectedMareaContext"
              :read-only="isReadOnly"
              @close="closeSidebar"
              @open-detalle="goToDetalle"
              @action="executeActionFromSidebar"
              @manage-alert="handleManageAlert"
            />
          </div>
        </Transition>
      </div>
    </div>

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

    <AlertManagementDialog
      :is-open="isAlertDialogOpen"
      :alert="selectedAlert"
      @close="isAlertDialogOpen = false"
      @refresh="fetchDashboard"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import MareaContextDetailContent from '../components/MareaContextDetailContent.vue'
import GestionEtapasMareaDialog from '../components/GestionEtapasMareaDialog.vue'
import RecibirArchivosDialog from '../components/RecibirArchivosDialog.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import StatusFilterChip from '../components/StatusFilterChip.vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useMareas } from '../composables/useMareas'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import {
  ShipIcon,
  SearchIcon,
  HorizontalDots,
  TaskIcon,
  HistoryIcon,
  ArchiveIcon,
  FileTextIcon,
  PlusIcon,
  ChevronDownIcon,
  WarningIcon,
  EditIcon
} from '@/icons'

import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

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
  return !roles.includes(ValidRoles.admin) && !roles.includes(ValidRoles.tecnico)
})

// UI State
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)
const showGestionDialog = ref(false)
const showRecibirDialog = ref(false)
const gestionMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('INICIAR')
const mareaToManage = ref<any>(null)

// Alerts UI State
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const handleManageAlert = (alert: any) => {
    selectedAlert.value = alert
    isAlertDialogOpen.value = true
}

// Map icons/colors to backend kpis
const getKpiMeta = (codigo: string) => {
  const meta: Record<string, any> = {
    'DESIGNADA': {
      icon: TaskIcon,
      color: 'text-info',
      border: 'border-info/30',
      bg: 'bg-info/10'
    },
    'EN_EJECUCION': {
      icon: ShipIcon,
      color: 'text-primary',
      border: 'border-primary/30',
      bg: 'bg-primary/10'
    },
    'ESPERANDO_ENTREGA': {
      icon: HistoryIcon,
      color: 'text-warning',
      border: 'border-warning/30',
      bg: 'bg-warning/10'
    },
    'ENTREGADA_RECIBIDA': {
      icon: ArchiveIcon,
      color: 'text-success',
      border: 'border-success/30',
      bg: 'bg-success/10'
    },
    'VERIFICACION_INICIAL': {
      icon: SearchIcon,
      color: 'text-info',
      border: 'border-info/30',
      bg: 'bg-info/10'
    },
    'EN_CORRECCION': {
      icon: EditIcon,
      color: 'text-warning',
      border: 'border-warning/30',
      bg: 'bg-warning/10'
    },
    'PENDIENTE_DE_INFORME': {
      icon: FileTextIcon,
      color: 'text-primary',
      border: 'border-primary/30',
      bg: 'bg-primary/10'
    },
  }
  return meta[codigo] || { icon: ShipIcon, color: 'text-text-muted', border: 'border-border', bg: 'bg-surface-muted/30' }
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
  if (window.innerWidth < 1280) {
    router.push({ name: 'MareaOperativaDetalle', params: { id: marea.id } })
    return
  }
  selectedMarea.value = marea
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
  if (!status) return 'bg-surface-muted text-text-muted'

  const s = status.toUpperCase()
  if (s === 'DESIGNADA')
    return 'bg-info/10 text-info'
  if (s === 'EN_EJECUCION' || s === 'NAVEGANDO')
    return 'bg-primary/10 text-primary'
  if (s === 'ESPERANDO_ENTREGA')
    return 'bg-warning/10 text-warning'
  if (s === 'ENTREGADA_RECIBIDA')
    return 'bg-success/10 text-success'
  if (s === 'VERIFICACION_INICIAL')
    return 'bg-info/10 text-info'
  if (s === 'EN_CORRECCION')
    return 'bg-warning/10 text-warning'
  if (s === 'PENDIENTE_DE_INFORME')
    return 'bg-primary/10 text-primary'

  return 'bg-surface-muted text-text-muted'
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
  background: var(--color-border);
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
}
</style>
