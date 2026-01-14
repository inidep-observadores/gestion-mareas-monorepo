<template>
  <div class="alert-history-tab py-4">
    <div v-if="loading" class="flex justify-center p-8">
        <span class="loading loading-spinner text-primary"></span>
    </div>

    <div v-else-if="alerts.length === 0" class="text-center py-10 text-base-content/60">
        <p>No hay alertas registradas para esta marea.</p>
    </div>

    <div v-else class="space-y-6">
        <div v-for="alert in alerts" :key="alert.id" class="collapse collapse-arrow bg-base-100 border border-base-content/10 rounded-box">
            <div class="collapse-title flex items-center gap-4">
                <span :class="['badge badge-sm', getBadgeClass(alert.estado)]">{{ alert.estado }}</span>
                <span class="font-medium">{{ alert.titulo }}</span>
                <span class="text-xs text-base-content/50 ml-auto">{{ formatDate(alert.fechaDetectada) }}</span>
            </div>
            <div class="collapse-content bg-base-200/30">
                <div class="pt-4 px-2">
                    <p class="text-sm mb-4">{{ alert.descripcion }}</p>
                    <AlertTimeline :eventos="alert.eventos || []" />
                </div>
            </div>
        </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { type Alerta, alertsService } from '../services/alerts.service'
import AlertTimeline from './AlertTimeline.vue'
import { toast } from 'vue-sonner'

const props = defineProps<{
  referenceId: string
}>()

const loading = ref(true)
const alerts = ref<Alerta[]>([])

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

const getBadgeClass = (status: string) => {
    switch (status) {
        case 'PENDIENTE': return 'badge-error' // Red
        case 'SEGUIMIENTO': return 'badge-warning' // Yellow
        case 'RESUELTA': return 'badge-success text-white' // Green
        case 'DESCARTADA': return 'badge-ghost' // Gray
        case 'VENCIDA': return 'badge-error badge-outline'
        default: return 'badge-ghost'
    }
}

const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString()
}
</script>
