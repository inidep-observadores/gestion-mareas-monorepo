<template>
  <AdminDashboardLayout
    title="Sincronización PNA"
    description="Configuración de procesos automáticos y herramientas de sincronización manual de movimientos y tracking"
  >
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      
      <!-- Panel de Configuración Automática -->
      <div class="flex flex-col gap-6 bg-surface p-6 rounded-xl border border-border shadow-sm">
        <div class="flex items-center gap-3 mb-2">
          <div class="p-2 bg-primary/10 rounded-lg text-primary">
            <SettingsIcon class="w-5 h-5" />
          </div>
          <h3 class="text-lg font-bold text-text">Ejecución Automática</h3>
        </div>
        
        <p class="text-sm text-text-muted mb-4">
          Configure la frecuencia y activación de las tareas programadas en segundo plano.
        </p>

        <div class="space-y-6">
          <!-- Config PNA API -->
          <div class="p-4 bg-surface-muted/30 rounded-lg border border-border">
            <div class="flex justify-between items-center mb-4">
              <div>
                <h4 class="font-bold text-text">PNA (Eventos y Alertas)</h4>
                <p class="text-xs text-text-muted">Detección automática de zarpadas y arribos.</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="config.pnaApi.enabled" class="sr-only peer">
                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
            <div class="flex flex-col gap-3">
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Intervalo Rápido:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="number" 
                    v-model.number="config.pnaApi.intervalMinutes"
                    class="w-20 bg-surface border border-border rounded px-2 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                  />
                  <span class="text-sm text-text-muted">minutos</span>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Intervalo Respaldo:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="number" 
                    v-model.number="config.pnaApi.longIntervalMinutes"
                    class="w-20 bg-surface border border-border rounded px-2 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                  />
                  <span class="text-sm text-text-muted">minutos</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Config PNA Tracking -->
          <div class="p-4 bg-surface-muted/30 rounded-lg border border-border">
            <div class="flex justify-between items-center mb-4">
              <div>
                <h4 class="font-bold text-text">PNA Tracking</h4>
                <p class="text-xs text-text-muted">Ingesta de posiciones históricas de buques.</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="config.pnaTracking.enabled" class="sr-only peer">
                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
            <div class="flex flex-col gap-3">
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Intervalo Rápido:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="number" 
                    v-model.number="config.pnaTracking.intervalMinutes"
                    class="w-20 bg-surface border border-border rounded px-2 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                  />
                  <span class="text-sm text-text-muted">minutos</span>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Intervalo Respaldo:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="number" 
                    v-model.number="config.pnaTracking.longIntervalMinutes"
                    class="w-20 bg-surface border border-border rounded px-2 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                  />
                  <span class="text-sm text-text-muted">minutos</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <button 
          @click="saveConfig"
          :disabled="isSaving"
          class="mt-4 w-full py-3 bg-primary text-primary-fg rounded-lg font-bold shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
        >
          <CheckIcon v-if="!isSaving" class="w-4 h-4" />
          <RefreshIcon v-else class="w-4 h-4 animate-spin" />
          {{ isSaving ? 'Guardando...' : 'Guardar Configuración' }}
        </button>
      </div>

      <!-- Panel de Sincronización Manual -->
      <div class="flex flex-col gap-6 bg-surface p-6 rounded-xl border border-border shadow-sm">
        <div class="flex items-center gap-3 mb-2">
          <div class="p-2 bg-info/10 rounded-lg text-info">
            <HistoryIcon class="w-5 h-5" />
          </div>
          <h3 class="text-lg font-bold text-text">Sincronización Manual</h3>
        </div>

        <p class="text-sm text-text-muted mb-4">
          Solicite datos de un rango de tiempo específico. Útil para cubrir baches de datos o reprocesar periodos.
        </p>

        <div class="space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div class="flex flex-col gap-1.5">
              <label class="text-xs font-bold text-text-muted uppercase">Desde:</label>
              <input 
                type="datetime-local" 
                v-model="manualRange.fromDate"
                class="bg-surface border border-border rounded-lg px-3 py-2 text-sm font-medium outline-none focus:ring-2 focus:ring-primary/20 transition-all"
              />
            </div>
            <div class="flex flex-col gap-1.5">
              <label class="text-xs font-bold text-text-muted uppercase">Hasta:</label>
              <input 
                type="datetime-local" 
                v-model="manualRange.toDate"
                class="bg-surface border border-border rounded-lg px-3 py-2 text-sm font-medium outline-none focus:ring-2 focus:ring-primary/20 transition-all"
              />
            </div>
          </div>

          <div class="flex items-center gap-3 p-3 bg-surface-muted/20 rounded-lg border border-border/50">
            <label class="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" v-model="validationsEnabled" class="sr-only peer">
              <div class="w-10 h-5 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-primary"></div>
            </label>
            <div>
              <span class="text-sm font-bold text-text">Realizar validaciones y alertas</span>
              <p class="text-[10px] text-text-muted leading-tight">Si está desactivado, solo se cargarán los datos históricos (más rápido).</p>
            </div>
          </div>

          <div class="grid grid-cols-1 gap-3 pt-4">
            <button 
              @click="runManualSync('API')"
              :disabled="isSyncingManual"
              class="py-3 bg-warning/10 border border-warning/20 text-warning rounded-lg font-bold hover:bg-warning/20 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
            >
              <BellIcon class="w-4 h-4" />
              Sincronizar Eventos (Alertas)
            </button>
            <button 
              @click="runManualSync('TRACKING')"
              :disabled="isSyncingManual"
              class="py-3 bg-success/10 border border-success/20 text-success rounded-lg font-bold hover:bg-success/20 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
            >
              <ShipIcon class="w-4 h-4" />
              Sincronizar Tracking Histórico
            </button>
          </div>

          <div v-if="manualSyncResult" class="mt-4 p-4 rounded-lg text-sm" :class="manualSyncResult.success ? 'bg-success/10 text-success' : 'bg-error/10 text-error'">
            <p class="font-bold mb-1">{{ manualSyncResult.message }}</p>
            <ul v-if="manualSyncResult.details" class="text-xs space-y-0.5 opacity-80">
              <li v-for="(val, key) in manualSyncResult.details" :key="key">
                {{ key }}: {{ val }}
              </li>
            </ul>
          </div>
        </div>
      </div>

    </div>
    </AdminDashboardLayout>

    <!-- Modal de Confirmación para Rangos Largos -->
    <ConfirmationDialog
      :show="showSyncConfirmModal"
      title="Sincronización de Rango Extendido"
      confirm-text="Continuar y Encolar"
      confirm-button-class="bg-primary hover:bg-primary/90 shadow-primary/20"
      @close="showSyncConfirmModal = false"
      @confirm="executeManualSync"
    >
      <div class="space-y-3">
        <p class="text-sm text-text">
          El rango solicitado es de <span class="font-bold">{{ Math.round(pendingSyncDiffDays) }} días</span>.
        </p>
        <div class="p-4 rounded-xl bg-primary/5 border border-primary/10 flex items-start gap-3">
          <InfoCircleIcon class="w-5 h-5 text-primary mt-0.5" />
          <p class="text-xs text-text-muted leading-relaxed">
            Al exceder el límite seguro de 20 días, el proceso se fragmentará automáticamente y se ejecutará en segundo plano a través de la cola de tareas para evitar saturar la API de PNA.
          </p>
        </div>
      </div>
    </ConfirmationDialog>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import alertsAdminApi from '../services/alerts.service'
import { toast } from 'vue-sonner'
import { 
  SettingsIcon, 
  HistoryIcon, 
  CheckIcon, 
  RefreshIcon, 
  BellIcon, 
  ShipIcon,
  InfoCircleIcon
} from '@/icons'

const config = reactive({
  pnaApi: { enabled: true, intervalMinutes: 20, longIntervalMinutes: 240 },
  pnaTracking: { enabled: true, intervalMinutes: 20, longIntervalMinutes: 240 }
})

const isSaving = ref(false)
const isSyncingManual = ref(false)
const manualRange = reactive({
  fromDate: '',
  toDate: ''
})
const validationsEnabled = ref(false)

// Estados para confirmación de rango largo
const showSyncConfirmModal = ref(false)
const pendingSyncType = ref<'API' | 'TRACKING' | null>(null)
const pendingSyncDiffDays = ref(0)

const manualSyncResult = ref<{ success: boolean; message: string; details?: any } | null>(null)

// Cargar configuración inicial
const loadConfig = async () => {
  try {
    const remoteConfig = await alertsAdminApi.getConfig()
    // Aseguramos que existan los valores por defecto si la base de datos devuelve una versión vieja
    const mergedConfig = {
      pnaApi: { 
        ...config.pnaApi,
        ...(remoteConfig.pnaApi || {})
      },
      pnaTracking: {
        ...config.pnaTracking,
        ...(remoteConfig.pnaTracking || {})
      }
    }
    Object.assign(config, mergedConfig)
  } catch (error) {
    toast.error('Error al cargar la configuración')
  }
}

// Guardar configuración
const saveConfig = async () => {
  if (config.pnaApi.intervalMinutes >= config.pnaApi.longIntervalMinutes) {
    toast.error('Error: El intervalo rápido de PNA API debe ser menor al intervalo de respaldo')
    return
  }
  
  if (config.pnaTracking.intervalMinutes >= config.pnaTracking.longIntervalMinutes) {
    toast.error('Error: El intervalo rápido de PNA Tracking debe ser menor al intervalo de respaldo')
    return
  }

  isSaving.value = true
  try {
    await alertsAdminApi.updateConfig(config)
    toast.success('Configuración guardada correctamente')
  } catch (error) {
    toast.error('Error al guardar la configuración')
  } finally {
    isSaving.value = false
  }
}

// Sincronización manual
const runManualSync = async (type: 'API' | 'TRACKING') => {
  if (!manualRange.fromDate || !manualRange.toDate) {
    toast.warning('Debe especificar un rango de fechas completo')
    return
  }

  isSyncingManual.value = true
  manualSyncResult.value = null
  
  const from = new Date(manualRange.fromDate)
  const to = new Date(manualRange.toDate)
  const diffDays = (to.getTime() - from.getTime()) / (1000 * 3600 * 24)
  const SAFE_LIMIT = 20

  if (diffDays > SAFE_LIMIT) {
    pendingSyncType.value = type
    pendingSyncDiffDays.value = diffDays
    showSyncConfirmModal.value = true
    return
  }

  executeManualSync(type)
}

const executeManualSync = async (typeOverride?: 'API' | 'TRACKING') => {
  const type = typeOverride || pendingSyncType.value
  if (!type) return

  showSyncConfirmModal.value = false
  isSyncingManual.value = true
  manualSyncResult.value = null
  
  const from = new Date(manualRange.fromDate)
  const to = new Date(manualRange.toDate)
  const diffDays = (to.getTime() - from.getTime()) / (1000 * 3600 * 24)
  const SAFE_LIMIT = 20
  
  try {
    const result = await alertsAdminApi.syncManual({
      type,
      fromDate: from.toISOString(),
      toDate: to.toISOString(),
      onlyIngest: !validationsEnabled.value
    })
    
    const isQueued = diffDays > SAFE_LIMIT || (type === 'TRACKING')
    
    manualSyncResult.value = {
      success: true,
      message: isQueued 
        ? `Sincronización ${type === 'API' ? 'de eventos' : 'de tracking'} programada en segundo plano.`
        : `Sincronización ${type === 'API' ? 'de eventos' : 'de tracking'} finalizada correctamente.`,
      details: type === 'API' && !isQueued ? result : { 
        'Tareas encoladas': result.queuedJobs || 'Procesando...',
        'Modo': validationsEnabled.value ? 'Validación Completa' : 'Solo Ingesta'
      }
    }
    toast.success(isQueued ? 'Sincronización programada' : 'Sincronización finalizada')
  } catch (error) {
    manualSyncResult.value = {
      success: false,
      message: 'Error al ejecutar la sincronización manual.'
    }
    toast.error('Error en sincronización manual')
  } finally {
    isSyncingManual.value = false
  }
}

onMounted(() => {
  loadConfig()
  
  // Rango manual por defecto: últimas 24 horas
  const now = new Date()
  const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000)
  
  // Format for datetime-local: YYYY-MM-DDThh:mm
  const formatForInput = (d: Date) => {
    const pad = (n: number) => n.toString().padStart(2, '0')
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`
  }
  
  manualRange.fromDate = formatForInput(yesterday)
  manualRange.toDate = formatForInput(now)
})
</script>
