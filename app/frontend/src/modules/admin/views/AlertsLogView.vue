<template>
  <AdminDashboardLayout title="Gestión y Auditoría de Alertas"
    description="Supervisión de notificaciones automáticas y procesos de conciliación de movimientos">
    <div class="flex flex-col gap-6">
      <!-- Header de Acciones -->
      <div
        class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 bg-surface p-6 rounded-xl border border-border shadow-sm">
        <div>
          <h3 class="text-lg font-semibold text-text mb-1">Alertas de Movimientos</h3>
          <p class="text-sm text-text-muted">Filtre y gestione las alertas detectadas por el sistema de monitoreo.</p>
        </div>
        <div class="flex gap-3">
          <button @click="runBatchAutomation" :disabled="isProcessingBatch"
            class="px-5 py-2.5 bg-primary text-primary-fg rounded-lg text-sm font-semibold shadow-lg shadow-primary/20 flex items-center gap-2 disabled:opacity-50 transition-all active:scale-95">
            <RefreshIcon v-if="isProcessingBatch" class="w-4 h-4 animate-spin" />
            <SettingsIcon v-else class="w-4 h-4" />
            {{ isProcessingBatch ? 'Procesando...' : 'Autoconfirmación Masiva' }}
          </button>
        </div>
      </div>

      <!-- Filtros -->
      <div
        class="bg-surface-muted/30 p-4 border border-border rounded-xl flex flex-col md:flex-row gap-4 items-center justify-between">
        <div class="flex flex-1 flex-col md:flex-row gap-4 w-full">
          <div class="relative group flex-1">
            <SearchIcon
              class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted group-focus-within:text-primary transition-colors" />
            <input v-model="filters.busqueda" @keyup.enter="refreshLogs" placeholder="Buscar buque, marea o puerto..."
              class="w-full bg-surface border border-border rounded-lg py-2 pl-10 pr-4 text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 transition-all outline-none" />
          </div>
          <select v-model="filters.status" @change="refreshLogs"
            class="bg-surface border border-border rounded-lg py-2 px-4 text-sm font-medium outline-none focus:outline-none focus:ring-2 focus:ring-primary/20">
            <option value="">Todos los estados</option>
            <option value="PENDIENTE">Solo Pendientes</option>
            <option value="RESUELTA">Solo Resueltas</option>
            <option value="DESCARTADA">Solo Descartadas</option>
          </select>
        </div>
        <button @click="refreshLogs"
          class="flex items-center justify-center gap-2 bg-surface border border-border rounded-lg px-4 py-2 font-semibold text-sm hover:bg-surface-muted transition-all shadow-sm text-text">
          <RefreshIcon class="w-4 h-4" :class="{ 'animate-spin': isLoading }" />
          Actualizar
        </button>
      </div>

      <!-- Tabla de Logs -->
      <div class="bg-surface rounded-xl border border-border shadow-sm overflow-hidden min-h-[500px]">
        <div class="overflow-x-auto">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr
                class="bg-surface-muted/50 text-text-muted text-xs uppercase tracking-wider font-semibold border-b border-border">
                <th @click="toggleSort('fechaDetectada')"
                  class="p-4 cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center gap-2">
                    Fecha / Hora
                    <SortIcon v-if="filters.sortBy === 'fechaDetectada'" :order="filters.sortOrder"
                      class="w-3 h-3 text-primary" />
                  </div>
                </th>
                <th v-if="filters.status !== 'PENDIENTE'" @click="toggleSort('fechaCierre')"
                  class="p-4 cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center gap-2">
                    Resolución
                    <SortIcon v-if="filters.sortBy === 'fechaCierre'" :order="filters.sortOrder"
                      class="w-3 h-3 text-primary" />
                  </div>
                </th>
                <th @click="toggleSort('tipo')" class="p-4 cursor-pointer hover:text-primary transition-colors">
                  <div class="flex items-center gap-2">
                    Alerta
                    <SortIcon v-if="filters.sortBy === 'tipo'" :order="filters.sortOrder"
                      class="w-3 h-3 text-primary" />
                  </div>
                </th>
                <th class="p-4">Marea / Buque</th>
                <th class="p-4">Fuentes</th>
                <th class="p-4">Modo</th>
                <th @click="toggleSort('estado')"
                  class="p-4 text-center cursor-pointer hover:text-primary transition-colors">
                  <div class="flex items-center justify-center gap-2">
                    Estado
                    <SortIcon v-if="filters.sortBy === 'estado'" :order="filters.sortOrder"
                      class="w-3 h-3 text-primary" />
                  </div>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border">
              <tr v-if="isLoading" v-for="i in 5" :key="i" class="animate-pulse">
                <td :colspan="filters.status !== 'PENDIENTE' ? 7 : 6" class="p-5">
                  <div class="h-4 bg-surface-muted rounded w-full"></div>
                </td>
              </tr>
              <tr v-else-if="alerts.length === 0" class="text-center">
                <td :colspan="filters.status !== 'PENDIENTE' ? 7 : 6" class="p-20">
                  <div class="flex flex-col items-center opacity-40">
                    <BellIcon class="w-12 h-12 mb-4" />
                    <p class="text-sm font-bold">No se encontraron alertas registradas</p>
                  </div>
                </td>
              </tr>
              <tr v-for="alert in alerts" :key="alert.id" class="hover:bg-surface-muted/50 transition-colors group">
                <td class="px-6 py-4">
                  <div class="flex flex-col">
                    <span class="text-sm font-semibold text-text">{{ formatDate(alert.fechaDetectada) }}</span>
                    <span class="text-[10px] font-mono text-text-muted">{{ alert.id.split('-')[0] }}</span>
                  </div>
                </td>
                <td v-if="filters.status !== 'PENDIENTE'" class="px-6 py-4">
                  <div class="flex flex-col" v-if="alert.fechaCierre">
                    <span class="text-sm font-semibold text-text">{{ formatDate(alert.fechaCierre) }}</span>
                    <span class="text-[10px] text-text-muted">{{ getTimeDifference(alert.fechaDetectada,
                      alert.fechaCierre) }}</span>
                  </div>
                  <span v-else class="text-sm text-text-muted">-</span>
                </td>
                <td class="px-6 py-4">
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 shadow-sm"
                      :class="getAlertIconClass(alert.tipo)">
                      <ShipIcon class="w-4 h-4" />
                    </div>
                    <span class="text-sm font-semibold text-text leading-tight max-w-[200px]">{{ alert.titulo }}</span>
                  </div>
                </td>
                <td class="px-6 py-4">
                  <div class="flex flex-col">
                    <span class="text-sm font-bold text-primary hover:underline cursor-pointer">{{ getMareaCode(alert)
                      }}</span>
                    <span class="text-[11px] font-medium text-text-muted">{{ metadataValue(alert, 'vesselName') || 'N/D'
                      }}</span>
                  </div>
                </td>
                <td class="px-6 py-4">
                  <div class="flex gap-1.5 flex-wrap">
                    <template v-for="source in getSources(alert)" :key="source">
                      <TrajectorySourceBadge v-if="source === 'TRK' || source === 'PNA' || source === 'API_PNA'"
                        :source="source" :vesselId="alert.metadata?.vesselId || alert.metadata?.buqueId"
                        :vesselName="alert.metadata?.vesselName || 'Buque'"
                        :referenceDate="TrajectoryRangeUtils.resolveAlertDates(alert).referenceDate"
                        :endDate="TrajectoryRangeUtils.resolveAlertDates(alert).endDate"
                        :mareaCode="alert.metadata?.mareaCode" :abbreviated="true" />
                      <span v-else class="px-2 py-0.5 rounded text-[10px] font-bold border uppercase tracking-wider"
                        :class="getSourceStyle(source)">
                        {{ source }}
                      </span>
                    </template>
                  </div>
                </td>
                <td class="px-6 py-4">
                  <template v-if="alert.estado !== 'PENDIENTE'">
                    <span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border"
                      :class="alert.metadata?.isAuto ? 'bg-purple-100 text-purple-700 border-purple-200 dark:bg-purple-900/30 dark:text-purple-400' : 'bg-surface-muted text-text-muted border-border'">
                      {{ alert.metadata?.isAuto ? 'Auto' : 'Manual' }}
                    </span>
                  </template>
                </td>
                <td class="px-6 py-4 text-center">
                  <span
                    class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold uppercase tracking-wider border"
                    :class="getStatusStyle(alert.estado)">
                    {{ alert.estado }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Paginación -->
        <div class="p-4 bg-surface-muted/30 border-t border-border flex justify-between items-center">
          <span class="text-[11px] font-semibold uppercase tracking-wider text-text-muted">
            Página {{ pagination.page }} | Total: {{ totalAlerts }} alertas
          </span>
          <div class="flex gap-2">
            <button @click="changePage(pagination.page - 1)" :disabled="pagination.page <= 1"
              class="p-1.5 rounded-lg bg-surface border border-border hover:border-primary/50 disabled:opacity-30 transition-all hover:bg-surface-muted">
              <ArrowLeftIcon class="w-5 h-5" />
            </button>
            <button @click="changePage(pagination.page + 1)" :disabled="alerts.length < pagination.limit"
              class="p-1.5 rounded-lg bg-surface border border-border hover:border-primary/50 disabled:opacity-30 transition-all hover:bg-surface-muted">
              <ArrowRightIcon class="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>
      <BatchProcessDialog :visible="batchDialogVisible" :is-processing="isProcessingBatch" :results="batchResults"
        @close="closeBatchDialog" />
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { Activity } from 'lucide-vue-next'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import alertsAdminApi, { type AlertLogEntry } from '../services/alerts.service'
import { jobQueueService } from '../services/JobQueueService'
import { toast } from 'vue-sonner'
import SortIcon from '@/components/shared/icons/SortIcon.vue'
import BatchProcessDialog from '../components/BatchProcessDialog.vue'
import TrajectorySourceBadge from '@/modules/alerts/components/TrajectorySourceBadge.vue'
import { TrajectoryRangeUtils } from '@/modules/alerts/utils/trajectory-range.utils'
import {
  RefreshIcon,
  SettingsIcon,
  SearchIcon,
  BellIcon,
  ArrowLeftIcon,
  ArrowRightIcon
} from '@/icons'

const alerts = ref<AlertLogEntry[]>([])
const isLoading = ref(false)
const isProcessingBatch = ref(false)
const totalAlerts = ref(0)
const batchDialogVisible = ref(false)
const batchResults = ref<{
  total: number;
  processed: number;
  details: Array<{
    id: string;
    titulo: string;
    status: 'CONFIRMED' | 'SKIPPED' | 'ERROR';
    reason?: string;
  }>;
} | null>(null)

const filters = reactive({
  busqueda: '',
  status: 'PENDIENTE',
  type: 'ZARPADA,ARRIBO,POSIBLE_ZARPADA,POSIBLE_ARRIBO,RECOMENDACION_FIN_MAREA',
  sortBy: 'fechaDetectada',
  sortOrder: 'desc' as 'asc' | 'desc'
})

const pagination = reactive({
  page: 1,
  limit: 20
})

const refreshLogs = async () => {
  isLoading.value = true
  try {
    const response = await alertsAdminApi.getAlertsLog({
      ...filters,
      page: pagination.page,
      limit: pagination.limit
    })
    alerts.value = response.data
    totalAlerts.value = response.total
  } catch (error) {
    toast.error('Error al cargar logs de alertas')
  } finally {
    isLoading.value = false
  }
}

const toggleSort = (column: string) => {
  if (filters.sortBy === column) {
    filters.sortOrder = filters.sortOrder === 'asc' ? 'desc' : 'asc'
  } else {
    filters.sortBy = column
    filters.sortOrder = 'desc'
  }
  refreshLogs()
}

const runBatchAutomation = async () => {
  isProcessingBatch.value = true
  batchDialogVisible.value = true
  batchResults.value = null

  try {
    const result = await alertsAdminApi.processBatchAutomation()
    batchResults.value = result // { total, processed }
    await refreshLogs()
  } catch (error) {
    toast.error('Error al ejecutar autoconfirmación masiva')
    batchDialogVisible.value = false
  } finally {
    isProcessingBatch.value = false
  }
}



const closeBatchDialog = () => {
  batchDialogVisible.value = false
  batchResults.value = null
}

const changePage = (page: number) => {
  pagination.page = page
  refreshLogs()
}

// Helpers
const formatDate = (date: string) => {
  return new Date(date).toLocaleString('es-AR', {
    day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit'
  })
}

const getTimeDifference = (start: string, end: string) => {
  const diff = new Date(end).getTime() - new Date(start).getTime()
  const minutes = Math.floor(diff / 60000)
  if (minutes < 60) return `${minutes}m`
  const hours = Math.floor(minutes / 60)
  return `${hours}h ${minutes % 60}m`
}

const getMareaCode = (alert: AlertLogEntry) => {
  return alert.metadata?.mareaCode || alert.referenciaId?.split('-')[0] || 'N/D'
}

const metadataValue = (alert: AlertLogEntry, key: string) => alert.metadata?.[key]



const getSources = (alert: AlertLogEntry): string[] => {
  const sources = alert.metadata?.sources || []
  return sources.map((s: any) => {
    if (s.name === 'API_PNA') return 'PNA'
    if (s.name === 'TRACKING_CSV') return 'TRK'
    return s.name
  })
}

const getSourceStyle = (source: string) => {
  switch (source) {
    case 'PNA': return 'bg-orange-500/10 border-orange-500/20 text-orange-600 dark:text-orange-400'
    case 'TRK': return 'bg-success/10 border-success/20 text-success'
    default: return 'bg-gray-100 text-gray-700 border-gray-200'
  }
}

const getAlertIconClass = (tipo: string) => {
  switch (tipo) {
    case 'ZARPADA':
    case 'POSIBLE_ZARPADA':
      return 'bg-blue-100 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400'
    case 'ARRIBO':
    case 'POSIBLE_ARRIBO':
      return 'bg-amber-100 text-amber-600 dark:bg-amber-900/30 dark:text-amber-400'
    case 'RECOMENDACION_FIN_MAREA':
      return 'bg-purple-100 text-purple-600 dark:bg-purple-900/30 dark:text-purple-400'
    default:
      return 'bg-gray-100 text-gray-600 dark:bg-gray-900/30 dark:text-gray-400'
  }
}

const getStatusStyle = (status: string) => {
  switch (status) {
    case 'PENDIENTE': return 'bg-warning/20 text-warning border border-warning/30'
    case 'RESUELTA': return 'bg-success/20 text-success border border-success/30'
    case 'DESCARTADA': return 'bg-error/20 text-error border border-error/30'
    default: return 'bg-surface-muted text-text-muted'
  }
}

onMounted(() => {
  refreshLogs()
})
</script>
