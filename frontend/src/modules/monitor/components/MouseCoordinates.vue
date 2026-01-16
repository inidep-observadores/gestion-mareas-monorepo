<template>
  <HudCard customClass="px-2 py-0.5 pointer-events-none border-white/5">
    <div class="flex items-center gap-2 font-black tracking-tighter text-text tabular-nums" :style="{ fontSize: 'calc(8px + var(--hud-font-offset))' }">
      <div v-if="coords" class="flex items-center gap-2">
        <span class="text-text-muted uppercase font-black" :style="{ fontSize: 'calc(7px + var(--hud-font-offset))' }">
          Cursor:
        </span>
        <div class="flex items-center gap-1">
          <span class="text-text-muted font-black uppercase" :style="{ fontSize: 'calc(5px + var(--hud-font-offset))' }">LAT</span>
          <span>{{ formatCoordinate(coords.lat, 'lat') }}</span>
        </div>
        <span class="opacity-30 text-text-muted">|</span>
        <div class="flex items-center gap-1">
          <span class="text-text-muted font-black uppercase" :style="{ fontSize: 'calc(5px + var(--hud-font-offset))' }">LON</span>
          <span>{{ formatCoordinate(coords.lng, 'lon') }}</span>
        </div>
      </div>
      <div v-else class="font-black uppercase opacity-30 text-text-muted" :style="{ fontSize: 'calc(7px + var(--hud-font-offset))' }">
        Fuera de mapa
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
