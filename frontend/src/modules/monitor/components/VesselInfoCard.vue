<template>
  <HudCard customClass="w-[170px]">
    <!-- Vessel Header -->
    <div class="p-2 border-b border-border/10 flex items-start justify-between bg-surface/5 group/card cursor-pointer" @click="isCollapsed = !isCollapsed">
      <div class="flex flex-col gap-0 overflow-hidden pr-2">
        <h4 class="font-black uppercase tracking-[0.2em] text-primary/80 mb-0.5 text-[7px]">Marea Activa</h4>
        <h2 class="font-black text-text leading-tight tracking-tighter truncate text-[11px]">
          {{ vesselName }}
        </h2>
        <p v-if="!isCollapsed" class="font-bold text-text-muted/60 uppercase mt-0.5 text-[7px]">Mat. {{ vesselMat }}</p>
      </div>
      <div 
        class="shrink-0 p-1 bg-primary/10 rounded-lg border border-primary/20 text-primary transition-transform duration-300"
        :class="{ 'rotate-180': isCollapsed }"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
          <path d="M19 9l-7 7-7-7"/>
        </svg>
      </div>
    </div>

    <!-- Collapsible Content -->
    <div v-show="!isCollapsed" class="flex flex-col gap-2 p-2 transition-all duration-300">
      <!-- Current Position -->
      <div class="flex flex-col gap-1">
        <h4 class="font-black uppercase tracking-[0.2em] text-text-muted/60 text-center text-[7px]">Posición Satelital</h4>
        <div class="grid grid-cols-2 gap-1.5">
          <div class="flex flex-col items-center bg-surface/5 py-1 px-1 rounded-xl border border-border/5">
            <span class="font-black uppercase text-primary mb-0.5 text-[6px]">Latitud</span>
            <span class="font-black tabular-nums text-text tracking-tighter text-[9px]">{{ formatCoordinate(position.lat, 'lat') }}</span>
          </div>
          <div class="flex flex-col items-center bg-surface/5 py-1 px-1 rounded-xl border border-border/5">
            <span class="font-black uppercase text-primary mb-0.5 text-[6px]">Longitud</span>
            <span class="font-black tabular-nums text-text tracking-tighter text-[9px]">{{ formatCoordinate(position.lon, 'lon') }}</span>
          </div>
        </div>
      </div>

      <!-- Date & Time & Telemetry -->
      <div class="flex flex-col gap-1.5">
        <div class="flex items-center justify-between font-black uppercase tracking-tighter text-[9px] px-0.5">
          <div class="flex items-center gap-1.5 text-text-muted/80">
             <span class="w-1.5 h-1.5 rounded-full bg-success shadow-[0_0_8px_rgba(var(--color-success-rgb),0.4)]"></span>
             <span>{{ formatDate(timestamp) }}</span>
          </div>
          <div class="text-text font-black tracking-tight">{{ formatTime(timestamp) }}</div>
        </div>

        <!-- Speed & Course -->
        <div class="flex items-center justify-between bg-primary/5 px-2 py-1 rounded-xl border border-primary/10">
          <div class="flex flex-col">
            <span class="font-black text-text-muted/60 uppercase text-[6px]">Velocidad</span>
            <span class="font-black text-primary text-[9px]">{{ speed.toFixed(1) }} kn</span>
          </div>
          <div class="w-px h-3 bg-border/20"></div>
          <div class="flex flex-col items-end">
            <span class="font-black text-text-muted/60 uppercase text-[6px]">Rumbo</span>
            <span class="font-black text-text text-[9px]">{{ course }}°</span>
          </div>
        </div>
      </div>

      <!-- Visibility Layers -->
      <div v-if="layers" class="flex flex-col gap-1 pt-2 border-t border-border/10">
        <div v-for="(val, key) in layers" :key="key" class="flex items-center justify-between group/layer">
          <span class="font-bold text-text-muted/80 group-hover/layer:text-text transition-colors capitalize tracking-tighter text-[8px]">{{ layerLabels[key] || key }}</span>
          <BaseSwitch 
            :modelValue="val" 
            @update:modelValue="$emit('update:layer', key, $event)" 
            class="scale-75 origin-right"
          />
        </div>
      </div>
    </div>
  </HudCard>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import HudCard from './HudCard.vue'
import BaseSwitch from '@/components/ui/BaseSwitch.vue'

const props = defineProps<{
  vesselName: string
  vesselMat: string
  position: { lat: number; lon: number }
  timestamp: string
  speed: number
  course: number
  layers?: Record<string, boolean>
}>()

defineEmits(['update:layer'])

const isCollapsed = ref(false)

const layerLabels: Record<string, string> = {
  totalPoints: 'Puntos totales',
  totalTrack: 'Trayectoria total',
  veda: 'Zonas de Veda',
  isobatas: 'Isobatas',
}

const formatCoordinate = (val: number, type: 'lat' | 'lon') => {
  const absVal = Math.abs(val)
  const degrees = Math.floor(absVal)
  const minutes = ((absVal - degrees) * 60).toFixed(3)
  const suffix = type === 'lat' ? (val >= 0 ? 'S' : 'N') : (val >= 0 ? 'O' : 'E')
  return `${degrees}° ${minutes}' ${suffix}`
}

const formatDate = (ts: string) => {
  if (!ts) return '--/--/--'
  const date = new Date(ts)
  return `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear().toString().slice(-2)}`
}

const formatTime = (ts: string) => {
  if (!ts) return '--:--'
  return new Date(ts).toLocaleTimeString('es-AR', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: false
  })
}
</script>
