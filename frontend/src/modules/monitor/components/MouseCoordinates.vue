<template>
  <HudCard customClass="px-3 py-1.5 pointer-events-none">
    <div class="flex items-center gap-4 text-[10px] font-black tracking-tight text-gray-700 dark:text-gray-300">
      <div v-if="coords">
        {{ formatCoordinate(coords.lat, 'lat') }} <span class="mx-2 text-gray-300">|</span> {{ formatCoordinate(coords.lng, 'lon') }}
      </div>
      <div v-else class="text-gray-400 italic">
        Mover el cursor sobre el mapa
      </div>
    </div>
  </HudCard>
</template>

<script setup lang="ts">
import type { LatLng } from 'leaflet'
import HudCard from './HudCard.vue'

const props = defineProps<{
  coords: LatLng | null
}>()

const formatCoordinate = (val: number, type: 'lat' | 'lon') => {
  const absVal = Math.abs(val)
  const degrees = Math.floor(absVal)
  const minutes = ((absVal - degrees) * 60).toFixed(3)
  const suffix = type === 'lat' ? (val >= 0 ? 'N' : 'S') : (val >= 0 ? 'E' : 'O')
  return `${degrees}° ${minutes}' ${suffix}`
}
</script>
