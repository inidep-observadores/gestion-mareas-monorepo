<template>
  <div class="alert-history-tab py-4">
    <div v-if="loading" class="flex justify-center p-8">
        <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
    </div>

    <div v-if="alerts.length === 0" class="text-center py-10 text-text-muted">
        <p>No hay alertas registradas para esta marea.</p>
    </div>

    <div v-else class="space-y-4">
        <div 
          v-for="alert in alerts" 
          :key="alert.id" 
          class="bg-surface border border-border rounded-2xl overflow-hidden shadow-sm"
        >
            <button 
              @click="toggleAlert(alert.id)"
              class="w-full flex items-center gap-4 px-5 py-4 text-left hover:bg-surface-muted/30 transition-colors"
            >
                <Badge :color="getBadgeColor(alert.estado)" variant="light" size="sm">
                  {{ alert.estado }}
                </Badge>
                <span class="font-bold text-text uppercase tracking-tight text-sm">{{ alert.titulo }}</span>
                <span class="text-xs text-text-muted font-mono ml-auto">{{ formatDate(alert.fechaDetectada) }}</span>
                <svg 
                  xmlns="http://www.w3.org/2000/svg" 
                  class="w-4 h-4 text-text-muted transition-transform duration-300"
                  :class="{ 'rotate-180': expandedAlertId === alert.id }"
                  viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                >
                  <polyline points="6 9 12 15 18 9"/>
                </svg>
            </button>
            <Transition
              enter-active-class="transition-all duration-300 ease-out"
              enter-from-class="max-h-0 opacity-0"
              enter-to-class="max-h-[1000px] opacity-100"
              leave-active-class="transition-all duration-200 ease-in"
              leave-from-class="max-h-[1000px] opacity-100"
              leave-to-class="max-h-0 opacity-0"
            >
              <div v-if="expandedAlertId === alert.id" class="px-5 pb-5 border-t border-border bg-surface-muted/10">
                  <div class="pt-4 px-1">
                      <p class="text-sm text-text-muted leading-relaxed mb-6">{{ alert.descripcion }}</p>
                      <AlertTimeline :eventos="alert.eventos || []" />
                  </div>
              </div>
            </Transition>
        </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { type Alerta, alertsService } from '../services/alerts.service'
import AlertTimeline from './AlertTimeline.vue'
import Badge from '@/components/ui/Badge.vue'
import { toast } from 'vue-sonner'

const props = defineProps<{
  referenceId: string
}>()

const loading = ref(true)
const alerts = ref<Alerta[]>([])
const expandedAlertId = ref<string | null>(null)

const loadAlerts = async () => {
    if (!props.referenceId) return
    try {
        loading.value = true
        alerts.value = await alertsService.getAll({ refId: props.referenceId }) || []

        const detailsPromises = alerts.value.map(a => alertsService.getOne(a.id))
        alerts.value = await Promise.all(detailsPromises)

    } catch (e) {
        console.error(e)
        toast.error('Error al cargar el historial de alertas')
    } finally {
        loading.value = false
    }
}

onMounted(loadAlerts)

watch(() => props.referenceId, loadAlerts)

const toggleAlert = (id: string) => {
    expandedAlertId.value = expandedAlertId.value === id ? null : id
}

const getBadgeColor = (status: string) => {
    switch (status) {
        case 'PENDIENTE': return 'error'
        case 'SEGUIMIENTO': return 'warning'
        case 'RESUELTA': return 'success'
        case 'DESCARTADA': return 'light'
        case 'VENCIDA': return 'error'
        default: return 'light'
    }
}

const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString()
}
</script>
