<template>
  <div class="inline-flex items-center">
    <Badge :color="resolvedColor" variant="light" size="sm"
      class="font-black text-[9px] uppercase tracking-tighter py-0.5 rounded-md cursor-pointer transition-all flex items-center active:scale-95 group"
      :class="[
        abbreviated ? 'px-1 gap-0.5' : 'px-1.5 gap-1',
        source === 'PNA' ? 'hover:bg-warning/20' : 'hover:bg-success/20'
      ]" @click.stop="openMap">
      <div v-if="!abbreviated"
        class="w-1.5 h-1.5 rounded-full animate-pulse group-hover:scale-125 transition-transform shrink-0"
        :class="normalizedSource === 'PNA' ? 'bg-warning' : 'bg-success'"></div>
      {{ resolvedLabel }}
    </Badge>

    <AlertTrajectoryMapModal v-if="vesselId && visualReferenceDate" :show="showMap" :vesselId="vesselId"
      :vesselName="vesselName" :referenceDate="visualReferenceDate" :endDate="visualEndDate || undefined"
      :mareaId="mareaId || undefined" :mareaCode="mareaCode || undefined" @close="showMap = false" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import Badge from '@/components/ui/Badge.vue'
import AlertTrajectoryMapModal from '@/modules/alerts/components/AlertTrajectoryMapModal.vue'
import { TrajectoryRangeUtils } from '@/modules/alerts/utils/trajectory-range.utils'

type BadgeColor = 'primary' | 'success' | 'error' | 'warning' | 'info' | 'purple' | 'light' | 'dark'
type TrajectorySource = 'TRACKING' | 'PNA' | 'TRK' | 'API_PNA' | 'TRACKING_CSV'

interface Props {
  vesselId: string | null | undefined
  vesselName: string
  referenceDate: string | Date | null | undefined
  endDate?: string | Date | null
  mareaId?: string | null
  mareaCode?: string | null
  label?: string
  color?: BadgeColor
  source?: TrajectorySource
  abbreviated?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  source: 'TRACKING',
  abbreviated: false
})

// Normalización de fuente para consistencia interna
const normalizedSource = computed((): TrajectorySource => {
  if (props.source === 'API_PNA') return 'PNA'
  if (props.source === 'TRACKING_CSV') return 'TRACKING'
  if (props.source === 'TRK') return 'TRACKING'
  return props.source
})

const showMap = ref(false)

const resolvedColor = computed(() => {
  if (props.color) return props.color
  return normalizedSource.value === 'PNA' ? 'warning' : 'success'
})

const resolvedLabel = computed(() => {
  if (props.label) return props.label
  if (props.abbreviated) {
    return normalizedSource.value === 'PNA' ? 'PNA' : 'TRK'
  }
  return normalizedSource.value === 'PNA' ? 'PNA' : 'TRACKING'
})

// Si no hay endDate (evento puntual), calculamos +/- 12h para ver el contexto
const visualReferenceDate = computed(() => {
  if (!props.referenceDate) return null
  const dates = TrajectoryRangeUtils.resolveAlertDates({ metadata: { eventDate: props.referenceDate, fechaArribo: props.endDate } })

  if (props.endDate) return dates.referenceDate

  // Para eventos puntuales, retroceder 12h
  const d = new Date(TrajectoryRangeUtils.normalize(dates.referenceDate))
  return new Date(d.getTime() - 12 * 60 * 60 * 1000).toISOString()
})

const visualEndDate = computed(() => {
  if (!props.referenceDate) return null
  const dates = TrajectoryRangeUtils.resolveAlertDates({ metadata: { eventDate: props.referenceDate, fechaArribo: props.endDate } })

  if (props.endDate) return dates.endDate

  // Para eventos puntuales, adelantar 12h
  const d = new Date(TrajectoryRangeUtils.normalize(dates.referenceDate))
  return new Date(d.getTime() + 12 * 60 * 60 * 1000).toISOString()
})

const openMap = () => {
  if (!props.vesselId || !props.referenceDate) return
  showMap.value = true
}
</script>
