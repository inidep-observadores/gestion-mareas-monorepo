<template>
  <HudCard customClass="px-3 py-1.5 pointer-events-none border-border/5">
    <div class="flex items-center gap-3 font-black tracking-tighter text-text tabular-nums text-xs">
      <div v-if="coords" class="flex items-center gap-3">
        <span class="text-text-muted/60 uppercase font-black text-[9px]">
          Cursor:
        </span>
        <div class="flex items-center gap-1.5">
          <span class="text-text-muted/40 font-black uppercase text-[9px]">LAT</span>
          <span>{{ formatCoordinate(coords.lat, 'lat') }}</span>
        </div>
        <span class="opacity-30 text-text-muted">|</span>
        <div class="flex items-center gap-1.5">
          <span class="text-text-muted/40 font-black uppercase text-[9px]">LON</span>
          <span>{{ formatCoordinate(coords.lng, 'lon') }}</span>
        </div>
      </div>
      <div v-else class="font-black uppercase opacity-30 text-text-muted text-[10px]">
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
