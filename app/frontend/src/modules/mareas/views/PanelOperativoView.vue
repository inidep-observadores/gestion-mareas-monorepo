<template>
  <AdminLayout title="Panel Operativo de Mareas" description="Monitoreo en tiempo real de las operaciones activas.">
    <div class="relative min-h-[calc(100vh-100px)] z-1">

      <!-- Filtros Compactos ( Airport Board Style ) -->
      <div class="flex flex-wrap items-center gap-3 mb-6">
        <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-2">
          Filtrar por estado:
        </span>
        <div class="flex flex-wrap items-center gap-2">
          <StatusFilterChip v-for="kpi in kpis" :key="kpi.label" :label="kpi.label" :value="kpi.value" :icon="kpi.icon"
            :active="!hiddenStates.has(kpi.codigo)" :color-class="kpi.color" :bg-class="kpi.bg" :border-class="kpi.border"
            @click="toggleStateVisibility(kpi.codigo)" />
        </div>

        <div class="flex items-center gap-2 ml-2 pl-4 border-l border-border/50">
          <button 
            @click="selectAllStates"
            class="text-[10px] font-black uppercase tracking-tight text-primary hover:text-primary-hover transition-all px-2 py-1 rounded-lg hover:bg-primary/5 active:scale-95"
          >
            Marcar todo
          </button>
          <button 
            @click="deselectAllStates"
            class="text-[10px] font-black uppercase tracking-tight text-text-muted hover:text-text transition-all px-2 py-1 rounded-lg hover:bg-surface-muted/50 active:scale-95"
          >
            Desmarcar todo
          </button>
        </div>
      </div>

      <div class="flex flex-col xl:flex-row gap-6 overflow-hidden">
        <!-- Main Board -->
        <div class="flex-1 min-w-0 transition-all duration-300">
          <div class="bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
            <div
              class="py-3 px-5 border-b border-border flex flex-col sm:flex-row items-center justify-between gap-4 bg-surface-muted/30">
              <h2 class="font-black text-text flex items-center gap-2">
                <div class="w-2 h-2 rounded-full bg-primary animate-pulse"></div>
                Mareas Activas
              </h2>
              <div class="flex flex-wrap items-center gap-3 w-full sm:w-auto">
                <div class="flex items-center gap-2 bg-surface border border-border rounded-xl px-3 py-1.5 focus-within:ring-2 focus-within:ring-primary/20 transition-all shadow-sm group">
                  <span class="text-text-muted group-focus-within:text-primary transition-colors">
                    <ShipIcon class="w-3.5 h-3.5" />
                  </span>
                  <select v-model="filterPesqueria"
                    class="bg-transparent border-none outline-none text-sm font-bold text-text-muted focus:text-text transition-colors cursor-pointer min-w-[140px] appearance-none pr-4">
                    <option value="">Todas las pesquerías</option>
                    <option v-for="pesqueria in availablePesquerias" :key="pesqueria" :value="pesqueria">
                      {{ pesqueria }}
                    </option>
                  </select>
                </div>
                <SearchInput v-model="searchQuery" class="md:w-96" placeholder="Buscar buque o marea..." />
                <ExportExcelButton 
                  :loading="exporting"
                  :label="searchQuery || filterPesqueria || hiddenStates.size > 0 ? 'Filtradas' : 'Excel'"
                  :title="searchQuery || filterPesqueria || hiddenStates.size > 0 ? 'Exportar mareas filtradas' : 'Exportar todas las mareas activas'"
                  @click="handleExport"
                />
                <button v-if="!isReadOnly" @click="router.push('/mareas/nueva')"
                  class="flex items-center justify-center gap-2 px-4 py-2 bg-primary text-primary-fg rounded-xl text-sm font-bold hover:bg-primary-hover transition-all shadow-lg shadow-primary/20 active:scale-95">
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
                  <div v-for="marea in filteredMareas" :key="marea.id" @click="openSidebar(marea)"
                    class="bg-surface border border-border rounded-2xl p-4 shadow-sm active:scale-[0.98] transition-all hover:border-primary/50">
                    <!-- Header Tarjeta -->
                    <div class="flex justify-between items-start mb-3">
                      <span
                        class="text-[10px] font-mono font-black text-text-muted/60 uppercase tracking-widest bg-surface-muted px-2 py-0.5 rounded">
                        {{ marea.id_marea }}
                      </span>
                      <div class="flex flex-col items-end gap-1">
                        <div class="flex items-center gap-1">
                          <span class="px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-tighter"
                            :class="getStatusClasses(marea.estado_codigo)">
                            {{ marea.estado }}
                          </span>
                          <span v-if="marea.total_etapas > 1 && marea.estado_codigo === 'EN_EJECUCION'"
                            class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[9px] font-black uppercase tracking-tighter border border-border">
                            Etapa {{ marea.total_etapas }}
                          </span>
                        </div>
                        <div class="flex flex-col items-end gap-1">
                          <span v-if="marea.intencion_cierre"
                            class="px-2 py-0.5 bg-error/10 text-error rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap flex items-center gap-1 border border-error/20">
                            <SportsScoreIcon class="w-4 h-4" />
                            A finalizar
                          </span>
                          <span v-if="marea.en_tierra"
                            class="px-2 py-0.5 bg-success/10 text-success rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap border border-success/20">
                            En Tierra
                          </span>
                          <span v-if="marea.en_prospeccion"
                            class="px-2 py-0.5 bg-purple-500/10 text-purple-600 rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap border border-purple-500/20">
                            Prospección
                          </span>
                        </div>
                      </div>
                    </div>

                    <!-- Datos Principales -->
                    <div class="mb-3">
                      <div class="flex items-center gap-2 mb-1">
                        <ShipIcon class="w-3.5 h-3.5 text-primary" />
                        <h4 class="text-sm font-black text-text">{{ marea.buque_nombre }}</h4>
                      </div>
                      <div class="flex flex-col gap-0.5 ml-5">
                        <p class="text-[10px] font-black text-text-muted uppercase tracking-tight">
                          {{ marea.pesquerias_nombres.join(' / ') || 'Sin pesquería' }}
                        </p>
                        <p class="text-[9px] font-bold text-text-muted/70 italic leading-none">
                          {{ marea.flota }}
                        </p>
                      </div>
                      <p class="text-xs font-bold text-text-muted truncate mt-1 ml-5">{{ marea.observador || 'No asignado' }}</p>
                    </div>

                    <!-- Info Operativa -->
                    <div class="flex items-center justify-between gap-4 pt-3 border-t border-border">
                      <div class="flex-1">
                        <div class="flex justify-between items-center mb-1">
                          <span class="text-[9px] font-bold text-text-muted uppercase tracking-widest">Progreso</span>
                          <span class="text-[10px] font-black"
                            :class="marea.progreso > 100 ? 'text-error' : 'text-primary'">{{ marea.progreso }}%</span>
                        </div>
                        <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
                          <div class="h-full transition-all duration-1000"
                            :class="marea.progreso > 100 ? 'bg-error' : 'bg-primary'"
                            :style="{ width: marea.progreso + '%' }"></div>
                        </div>
                      </div>

                      <div v-if="marea.alertas?.length"
                        class="flex items-center gap-1.5 px-2 py-1 bg-error/10 rounded-lg shrink-0">
                        <WarningIcon class="w-3 h-3 text-error" />
                        <span class="text-[10px] font-black text-error">{{ marea.alertas.length }}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- VISTA ESCRITORIO: TABLA (Oculta en móviles) -->
                <div class="hidden xl:block overflow-x-auto">
                  <table class="w-full text-left">
                    <thead
                      class="bg-surface-muted/50 text-[10px] font-black uppercase tracking-widest text-text-muted border-b border-border">
                      <tr>
                        <th @click="toggleSort('id_marea')"
                          class="px-4 py-2 w-28 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Marea
                            <ChevronDownIcon v-if="sortBy === 'id_marea'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('buque_nombre')"
                          class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Buque
                            <ChevronDownIcon v-if="sortBy === 'buque_nombre'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('pesquerias_nombres')"
                          class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Pesquería / Flota
                            <ChevronDownIcon v-if="sortBy === 'pesquerias_nombres'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('estado')"
                          class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Estado Operativo
                            <ChevronDownIcon v-if="sortBy === 'estado'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('fecha_zarpada')"
                          class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Zarpada
                            <ChevronDownIcon v-if="sortBy === 'fecha_zarpada'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('progreso')"
                          class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Progreso
                            <ChevronDownIcon v-if="sortBy === 'progreso'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('alertas')"
                          class="px-5 py-2 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Alertas
                            <ChevronDownIcon v-if="sortBy === 'alertas'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                      <tr v-for="marea in filteredMareas" :key="marea.id" @click="openSidebar(marea)"
                        class="group odd:bg-surface-muted/30 hover:bg-primary/5 transition-all cursor-pointer border-l-4 border-l-transparent"
                        :class="{ 'bg-primary/10 !border-l-primary': selectedMarea?.id === marea.id }">
                        <td class="px-4 py-1.5 w-28 focus-within:ring-0">
                          <span class="text-[11px] font-mono font-bold text-text-muted uppercase leading-none">{{
                            marea.id_marea }}</span>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex items-center gap-2.5">
                            <div
                              class="w-7 h-7 rounded-lg bg-surface-muted flex items-center justify-center text-text-muted group-hover:bg-primary/10 group-hover:text-primary transition-colors shrink-0">
                              <ShipIcon class="w-3.5 h-3.5" />
                            </div>
                            <div class="flex flex-col min-w-0">
                              <span class="text-sm font-bold text-text leading-tight truncate">{{ marea.buque_nombre
                              }}</span>
                              <span class="text-[10px] font-bold text-text-muted leading-tight truncate mt-0.5">{{
                                marea.observador || 'Sin asignar' }}</span>
                            </div>
                          </div>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex flex-col">
                            <span class="text-[11px] font-black text-text-muted uppercase tracking-tight leading-tight">
                              {{ marea.pesquerias_nombres.join('\n') || 'N/D' }}
                            </span>
                            <span class="text-[9px] font-bold text-primary/70 italic leading-none mt-0.5">
                              {{ marea.flota }}
                            </span>
                          </div>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex items-center gap-2">
                            <span
                              class="px-2 py-0.5 rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap"
                              :class="getStatusClasses(marea.estado_codigo)">
                              {{ marea.estado }}
                            </span>
                            <span v-if="marea.total_etapas > 1 && marea.estado_codigo === 'EN_EJECUCION'"
                              class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[10px] font-black uppercase tracking-tighter border border-border">
                              Etapa {{ marea.total_etapas }}
                            </span>
                            <span v-if="marea.en_tierra"
                              class="px-2 py-0.5 bg-success/10 text-success rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap border border-success/20">
                              En Tierra
                            </span>
                            <span v-if="marea.en_prospeccion"
                              class="px-2 py-0.5 bg-purple-500/10 text-purple-600 rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap border border-purple-500/20">
                              Prospección
                            </span>
                            <span v-if="marea.intencion_cierre"
                              class="px-2 py-0.5 bg-error/10 text-error rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap flex items-center gap-1 border border-error/20">
                              <SportsScoreIcon class="w-3 h-3" />
                              A finalizar
                            </span>
                          </div>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex flex-col">
                            <span class="text-xs font-bold text-text leading-none">{{ formatDate(marea.fecha_zarpada)
                            }}</span>
                            <span class="text-[10px] text-text-muted leading-none mt-1">{{ marea.puerto }}</span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div class="flex items-center gap-2">
                            <div class="w-16 h-1 bg-surface-muted rounded-full overflow-hidden">
                              <div class="h-full transition-all duration-1000"
                                :class="marea.progreso > 100 ? 'bg-error' : 'bg-success'"
                                :style="{ width: marea.progreso + '%' }"></div>
                            </div>
                            <span class="text-[10px] font-black text-text-muted">{{ marea.progreso }}%</span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div v-if="marea.alertas?.length"
                            class="flex items-center gap-1.5 px-2 py-0.5 bg-error/10 rounded-lg w-fit">
                            <span class="text-[10px] font-black text-error">{{ marea.alertas.length }}</span>
                          </div>
                          <span v-else class="text-[10px] font-bold text-text-muted/40">Ninguna</span>
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
                <p class="text-text-muted text-sm mt-1 max-w-xs">No se encontraron operaciones en curso que coincidan
                  con los filtros
                  aplicados.</p>
              </div>
            </div>
          </div>
        </div>

        <!-- PANEL DE DETALLE LATERAL PERSISTENTE -->
        <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="translate-x-4 opacity-0"
          enter-to-class="translate-x-0 opacity-100" leave-active-class="transition duration-200 ease-in"
          leave-from-class="translate-x-0 opacity-100" leave-to-class="translate-x-4 opacity-0">
          <div v-if="selectedMarea"
            class="w-full xl:w-[320px] 2xl:w-[400px] shrink-0 sticky top-0 bg-surface border border-border rounded-2xl shadow-sm overflow-hidden self-start hidden xl:block z-10">
            <MareaContextDetailContent :marea="selectedMarea" :context="selectedMareaContext" :read-only="isReadOnly"
              @close="closeSidebar" @open-detalle="goToDetalle" @view-trajectory="goToTrajectory"
              @action="executeActionFromSidebar" @manage-alert="handleManageAlert" />
          </div>
        </Transition>
      </div>
    </div>

    <GestionEtapasMareaDialog :show="showGestionDialog" :mode="gestionMode" :marea="mareaToManage"
      :currentStages="mareaToManage?.etapas || []" :initialPortId="mareaToManage?.puertoBaseId"
      @close="handleGestionCancel" @confirm="handleGestionConfirm" />

    <RecibirArchivosDialog :show="showRecibirDialog" :marea="mareaToManage" @close="handleRecibirCancel"
      @confirm="handleRecibirConfirm" />

    <CancelarMareaDialog :show="showCancelarDialog" :marea="mareaToManage" :loading="executingAction"
      @close="showCancelarDialog = false" @confirm="handleCancelarConfirm" />

    <MareaGenericActionDialog :show="showGenericDialog" :marea="mareaToManage" :actionKey="selectedActionKey"
      :actionData="selectedActionData" :loading="executingAction" @close="showGenericDialog = false"
      @confirm="handleGenericConfirm" />

    <FinalizarProtocolizacionDialog
      :show="showProtocolizacionDialog"
      :marea="mareaToManage"
      :loading="executingAction"
      @close="showProtocolizacionDialog = false"
      @confirm="handleProtocolizacionConfirm"
    />

    <AprobarInformeDialog
      :show="showAprobarInformeDialog"
      :marea="mareaToManage"
      :loading="executingAction"
      @close="showAprobarInformeDialog = false"
      @confirm="handleAprobarInformeConfirm"
    />

    <EditMareaDesignadaDialog 
      v-if="selectedMarea"
      :show="showEditDesignadaDialog" 
      :initial-data="selectedMarea" 
      :marea-id="selectedMarea.id"
      @close="showEditDesignadaDialog = false" 
      @success="handleEditSuccess" 
    />

    <AlertManagementDialog :is-open="isAlertDialogOpen" :alert="selectedAlert" @close="isAlertDialogOpen = false"
      @refresh="handleAlertRefresh" />
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
import CancelarMareaDialog from '../components/CancelarMareaDialog.vue'
import MareaGenericActionDialog from '../components/MareaGenericActionDialog.vue'
import FinalizarProtocolizacionDialog from '../components/FinalizarProtocolizacionDialog.vue'
import AprobarInformeDialog from '../components/AprobarInformeDialog.vue'
import EditMareaDesignadaDialog from '../components/EditMareaDesignadaDialog.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import StatusFilterChip from '../components/StatusFilterChip.vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useMareas } from '../composables/useMareas'
import mareasService from '../services/mareas.service'
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
  EditIcon,
  SportsScoreIcon,
  DownloadIcon
} from '@/icons'
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue';
import { useConfigStore } from '@/modules/shared/stores/config.store'

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
  filterPesqueria,
  availablePesquerias,
  sortBy,
  sortOrder,
  filteredMareas,
  toggleStateVisibility,
  setVisibleStates,
  toggleSort
} = useMareas()

const selectAllStates = () => {
  setVisibleStates(rawKpis.value.map(k => k.codigo))
}

const deselectAllStates = () => {
  setVisibleStates([])
}

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
const showCancelarDialog = ref(false)
const showGenericDialog = ref(false)
const showProtocolizacionDialog = ref(false)
const showAprobarInformeDialog = ref(false)
const selectedActionKey = ref<string | null>(null)
const selectedActionData = ref<any>(null)
const executingAction = ref(false)
const exporting = ref(false)
const configStore = useConfigStore()

const handleExport = async () => {
  try {
    exporting.value = true
    const params: any = {
      year: configStore.selectedYear
    }

    // Enviamos los IDs de las mareas visibles actualmente para respetar filtros
    if (filteredMareas.value.length > 0) {
      params.ids = filteredMareas.value.map(m => m.id)
    }

    const blob = await mareasService.exportToExcel(params)
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url

    const filename = `MAREAS_ACTIVAS_${configStore.selectedYear}.xlsx`

    link.setAttribute('download', filename)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
  } catch (err) {
    console.error('Error al exportar Excel:', err)
  } finally {
    exporting.value = false
  }
}

const gestionMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('INICIAR')
const mareaToManage = ref<any>(null)

// Alerts UI State
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const handleManageAlert = (alert: any) => {
  selectedAlert.value = null
  setTimeout(() => {
    selectedAlert.value = alert
    isAlertDialogOpen.value = true
  }, 0)
}

const handleAlertRefresh = async () => {
  await fetchDashboard()
  if (selectedMarea.value) {
    await fetchMareaContext(selectedMarea.value.id)
  }
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
    'A_REASIGNAR': {
      icon: ArchiveIcon,
      color: 'text-text-muted',
      border: 'border-border/60',
      bg: 'bg-surface-muted/50'
    }
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
  await fetchDashboard(false)
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

  if (actionKey === 'REGISTRAR_FINALIZACION') {
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

  if (actionKey === 'CANCELAR') {
    mareaToManage.value = mareaContext
    showCancelarDialog.value = true
    return
  }

  if (actionKey === 'FINALIZAR_PROTOCOLIZACION') {
    mareaToManage.value = mareaContext
    showProtocolizacionDialog.value = true
    return
  }

  if (actionKey === 'APROBAR_INFORME') {
    mareaToManage.value = mareaContext
    showAprobarInformeDialog.value = true
    return
  }

  // Si la acción tiene metadatos en el contexto y no es una de las especiales manejadas arriba, usar diálogo genérico
  const actionMetadata = selectedMareaContext.value?.actions[actionKey]
  if (actionMetadata) {
    mareaToManage.value = mareaContext
    selectedActionKey.value = actionKey
    selectedActionData.value = actionMetadata
    showGenericDialog.value = true
    return
  }

  try {
    await executeAction(selectedMarea.value.id, actionKey)
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error('Action failed:', err)
  }
}

const handleAprobarInformeConfirm = async (file: File, comentarios: string) => {
  if (!mareaToManage.value) return
  try {
    executingAction.value = true
    await mareasService.aprobarInforme(mareaToManage.value.id, file, comentarios)
    showAprobarInformeDialog.value = false
    mareaToManage.value = null
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error('Error aprobando informe:', err)
  } finally {
    executingAction.value = false
  }
}

const handleGenericConfirm = async (payload: any) => {
  if (!mareaToManage.value || !selectedActionKey.value) return

  try {
    executingAction.value = true
    await executeAction(mareaToManage.value.id, selectedActionKey.value, payload)
    showGenericDialog.value = false
    mareaToManage.value = null
    selectedActionKey.value = null
    selectedActionData.value = null
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error("Error en acción de marea:", err)
  } finally {
    executingAction.value = false
  }
}

const handleProtocolizacionConfirm = async (payload: any) => {
  if (!mareaToManage.value) return

  try {
    executingAction.value = true
    await executeAction(mareaToManage.value.id, 'FINALIZAR_PROTOCOLIZACION', payload)
    showProtocolizacionDialog.value = false
    mareaToManage.value = null
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error("Error en protocolización de marea:", err)
  } finally {
    executingAction.value = false
  }
}

const handleGestionCancel = () => {
  showGestionDialog.value = false
  mareaToManage.value = null
  closeSidebar()
}

const handleGestionConfirm = async (payload: any) => {
  try {
    const actionKey = gestionMode.value === 'INICIAR'
      ? 'REGISTRAR_INICIO'
      : gestionMode.value === 'FINALIZAR'
        ? 'REGISTRAR_FINALIZACION'
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

const handleCancelarConfirm = async (payload: any) => {
  try {
    executingAction.value = true
    await executeAction(mareaToManage.value.id, 'CANCELAR', payload)
    showCancelarDialog.value = false
    mareaToManage.value = null
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error("Error al cancelar marea:", err)
  } finally {
    executingAction.value = false
  }
}

const closeSidebar = () => {
  isSidebarOpen.value = false
  setTimeout(() => {
    selectedMarea.value = null
  }, 300)
}

const showEditDesignadaDialog = ref(false)

const goToDetalle = () => {
  if (selectedMarea.value) {
    if (selectedMarea.value.estado_codigo === 'DESIGNADA' && !isReadOnly.value) {
      showEditDesignadaDialog.value = true
    } else {
      router.push({ name: 'MareaDetalle', params: { id: selectedMarea.value.id } })
    }
  }
}

const handleEditSuccess = async () => {
  showEditDesignadaDialog.value = false
  if (selectedMarea.value) {
    await fetchMareaContext(selectedMarea.value.id)
  }
  await fetchDashboard()
}

const goToTrajectory = () => {
  if (selectedMarea.value) {
    router.push({ name: 'MareaTrajectory', params: { mareaId: selectedMarea.value.id } })
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
  if (s === 'A_REASIGNAR')
    return 'bg-surface-muted text-text-muted border border-border/50'

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
