<template>
  <HudCard customClass="px-2 py-1 pointer-events-none !bg-surface/5 !backdrop-blur-sm border-border/5">
    <div class="flex items-center gap-2 font-black tracking-tighter text-text tabular-nums text-[9px]">
      <div v-if="coords" class="flex items-center gap-2">
        <span class="text-text-muted/60 uppercase font-black text-[7px]">
          Cursor:
        </span>
        <div class="flex items-center gap-1">
          <span class="text-text-muted/40 font-black uppercase text-[6px]">LAT</span>
          <span>{{ formatCoordinate(coords.lat, 'lat') }}</span>
        </div>
        <span class="opacity-30 text-text-muted">|</span>
        <div class="flex items-center gap-1">
          <span class="text-text-muted/40 font-black uppercase text-[6px]">LON</span>
          <span>{{ formatCoordinate(coords.lng, 'lon') }}</span>
        </div>
      </div>
      <div v-else class="font-black uppercase opacity-30 text-text-muted text-[8px]">
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
