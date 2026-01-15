<template>
  <div class="space-y-4">
    <!-- Telemetry Card -->
    <div
      class="bg-surface/60 backdrop-blur-xl border border-border/50 rounded-2xl p-5 shadow-2xl"
    >
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-xs font-black uppercase tracking-widest text-primary">Telemetría</h3>
        <span class="px-2 py-0.5 rounded-lg text-[10px] font-black uppercase" :class="statusClass">
          {{ point.status }}
        </span>
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div class="bg-surface-muted p-2.5 rounded-xl">
          <p class="text-[9px] font-bold text-gray-400 uppercase mb-1">Velocidad</p>
          <div class="flex items-baseline gap-1">
            <span class="text-xl font-black text-gray-800 dark:text-white">{{ point.speed }}</span>
            <span class="text-[10px] font-bold text-gray-400">knts</span>
          </div>
        </div>
        <div class="bg-surface-muted p-2.5 rounded-xl">
          <p class="text-[9px] font-bold text-gray-400 uppercase mb-1">Rumbo</p>
          <div class="flex items-baseline gap-1">
            <span class="text-xl font-black text-gray-800 dark:text-white"
              >{{ point.course }}°</span
            >
            <span class="text-[10px] font-bold text-gray-400">{{ courseName }}</span>
          </div>
        </div>
      </div>

      <div class="mt-4 space-y-2">
        <div class="flex items-center justify-between text-[11px] font-medium">
          <span class="text-text-muted">Latitud</span>
          <span class="text-text tabular-nums">{{
            formatCoord(point.lat, true)
          }}</span>
        </div>
        <div class="flex items-center justify-between text-[11px] font-medium">
          <span class="text-text-muted">Longitud</span>
          <span class="text-text tabular-nums">{{
            formatCoord(point.lon, false)
          }}</span>
        </div>
      </div>
    </div>

    <!-- Stats Summary Card -->
    <div
      class="bg-surface/70 backdrop-blur-xl border border-border/50 rounded-2xl p-5 shadow-2xl text-text"
    >
      <h3 class="text-xs font-black uppercase tracking-widest text-text-muted mb-4">
        Marea {{ tripId }}
      </h3>
      <div class="space-y-4">
        <div>
          <div class="flex justify-between text-[10px] font-bold text-gray-500 uppercase mb-1">
            <span>Distancia Recorrida</span>
            <span>Est. Total</span>
          </div>
          <div class="flex items-baseline gap-2">
            <span class="text-2xl font-black tracking-tighter"
              >{{ stats.distanceTraveled }} nm</span
            >
            <span class="text-xs text-brand-400">/ {{ stats.totalDistance }} nm</span>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 pt-4 border-t border-border/50">
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase mb-1">Días de Mar</p>
            <p class="text-sm font-black">{{ stats.daysAtSea }} días</p>
          </div>
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase mb-1">Posible Pesca</p>
            <p class="text-sm font-black">{{ stats.fishingHours }} hs</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { TrackingPoint } from '../data/mockTracking'

const props = defineProps<{
  point: TrackingPoint
  tripId: string
  stats: {
    distanceTraveled: number
    totalDistance: number
    daysAtSea: number
    fishingHours: number
  }
}>()

const statusClass = computed(() => {
  if (props.point.status === 'fishing') return 'bg-error text-error-fg'
  if (props.point.status === 'maneuvering') return 'bg-warning text-warning-fg'
  return 'bg-info text-info-fg'
})

const courseName = computed(() => {
  const c = props.point.course
  if (c >= 337.5 || c < 22.5) return 'N'
  if (c >= 22.5 && c < 67.5) return 'NE'
  if (c >= 67.5 && c < 112.5) return 'E'
  if (c >= 112.5 && c < 157.5) return 'SE'
  if (c >= 157.5 && c < 202.5) return 'S'
  if (c >= 202.5 && c < 247.5) return 'SO'
  if (c >= 247.5 && c < 292.5) return 'O'
  if (c >= 292.5 && c < 337.5) return 'NO'
  return ''
})

const formatCoord = (val: number, isLat: boolean) => {
  const orientation = isLat ? (val >= 0 ? 'N' : 'S') : val >= 0 ? 'E' : 'O'
  const abs = Math.abs(val)
  const deg = Math.floor(abs)
  const min = Math.floor((abs - deg) * 60)
  const sec = (((abs - deg) * 60 - min) * 60).toFixed(1)
  return `${deg}° ${min}' ${sec}" ${orientation}`
}
</script>
