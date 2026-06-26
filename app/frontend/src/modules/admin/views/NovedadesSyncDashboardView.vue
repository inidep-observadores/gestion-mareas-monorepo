<template>
  <AdminDashboardLayout
    title="Novedades por Email"
    description="Configuración de lectura automática de emails e IA para registro de Novedades de Observadores"
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
          Configure la frecuencia del proceso de lectura automática de correos entrantes (IMAP) y su análisis mediante Inteligencia Artificial.
        </p>

        <div class="space-y-6">
          <div class="p-4 bg-surface-muted/30 rounded-lg border border-border">
            <div class="flex justify-between items-center mb-4">
              <div>
                <h4 class="font-bold text-text">Lectura IMAP e Inteligencia Artificial</h4>
                <p class="text-xs text-text-muted">Procesamiento automático de adjuntos y textos.</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="config.enabled" class="sr-only peer">
                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
            <div class="flex flex-col gap-3">
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Intervalo de chequeo:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="number" 
                    v-model.number="config.intervalMinutes"
                    class="w-20 bg-surface border border-border rounded px-2 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                    min="5"
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

      <!-- Panel de Ejecución Manual -->
      <div class="flex flex-col gap-6 bg-surface p-6 rounded-xl border border-border shadow-sm">
        <div class="flex items-center gap-3 mb-2">
          <div class="p-2 bg-info/10 rounded-lg text-info">
            <HistoryIcon class="w-5 h-5" />
          </div>
          <h3 class="text-lg font-bold text-text">Ejecución Manual</h3>
        </div>

        <p class="text-sm text-text-muted mb-4">
          Forzar la ejecución inmediata del proceso de lectura de bandeja de entrada IMAP, ignorando el intervalo programado.
        </p>

        <div class="space-y-4">
          <div class="grid grid-cols-1 gap-3 pt-4">
            <button 
              @click="runManualSync"
              :disabled="isSyncingManual"
              class="py-3 bg-warning/10 border border-warning/20 text-warning rounded-lg font-bold hover:bg-warning/20 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
            >
              <MailIcon class="w-4 h-4" />
              Sincronizar Emails Ahora
            </button>
          </div>

          <div v-if="manualSyncResult" class="mt-4 p-4 rounded-lg text-sm" :class="manualSyncResult.success ? 'bg-success/10 text-success' : 'bg-error/10 text-error'">
            <p class="font-bold mb-1">{{ manualSyncResult.message }}</p>
          </div>
        </div>
      </div>

    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import novedadesAdminApi from '../services/novedades-admin.service'
import { toast } from 'vue-sonner'
import { 
  SettingsIcon, 
  HistoryIcon, 
  CheckIcon, 
  RefreshIcon
} from '@/icons'
import MailIcon from '@/icons/MailIcon.vue' // Asegúrate de que exista o usar un genérico si no

const config = reactive({
  enabled: true,
  intervalMinutes: 60
})

const isSaving = ref(false)
const isSyncingManual = ref(false)
const manualSyncResult = ref<{ success: boolean; message: string } | null>(null)

// Cargar configuración inicial
const loadConfig = async () => {
  try {
    const remoteConfig = await novedadesAdminApi.getConfig()
    Object.assign(config, remoteConfig)
  } catch (error) {
    toast.error('Error al cargar la configuración de novedades')
  }
}

// Guardar configuración
const saveConfig = async () => {
  if (config.intervalMinutes < 5) {
    toast.error('Error: El intervalo mínimo es 5 minutos para evitar baneos de IMAP.')
    return
  }

  isSaving.value = true
  try {
    await novedadesAdminApi.updateConfig(config)
    toast.success('Configuración guardada correctamente')
  } catch (error) {
    toast.error('Error al guardar la configuración')
  } finally {
    isSaving.value = false
  }
}

// Sincronización manual
const runManualSync = async () => {
  isSyncingManual.value = true
  manualSyncResult.value = null
  
  try {
    await novedadesAdminApi.syncManual()
    
    manualSyncResult.value = {
      success: true,
      message: 'Sincronización encolada. El proceso de lectura se está ejecutando en segundo plano.',
    }
    toast.success('Sincronización encolada')
  } catch (error) {
    manualSyncResult.value = {
      success: false,
      message: 'Error al solicitar la sincronización manual.'
    }
    toast.error('Error en sincronización manual')
  } finally {
    isSyncingManual.value = false
  }
}

onMounted(() => {
  loadConfig()
})
</script>
