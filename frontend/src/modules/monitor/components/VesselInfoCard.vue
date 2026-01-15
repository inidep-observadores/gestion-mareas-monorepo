<template>
  <HudCard customClass="w-44">
    <!-- Vessel Header -->
    <div class="p-2 border-b border-gray-200/20 dark:border-white/5 flex items-start justify-between bg-white/5 dark:bg-black/10">
      <div class="flex flex-col gap-0">
        <h4 class="font-black uppercase tracking-[0.2em] text-indigo-500/80 mb-0.5" :style="{ fontSize: 'calc(6px + var(--hud-font-offset))' }">Marea Activa</h4>
        <h2 class="font-black text-gray-900 dark:text-gray-300 leading-none tracking-tighter" :style="{ fontSize: 'calc(12px + var(--hud-font-offset))' }">
          {{ vesselName }}
        </h2>
        <p class="font-bold text-gray-400 uppercase mt-0.5 opacity-60" :style="{ fontSize: 'calc(6px + var(--hud-font-offset))' }">Mat. {{ vesselMat }}</p>
      </div>
      <div class="p-1 bg-indigo-500/10 rounded-lg border border-indigo-500/20">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-indigo-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
          <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
          <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
        </svg>
      </div>
    </div>

    <div class="p-2 flex flex-col gap-2.5">
      <!-- Current Position -->
      <div class="flex flex-col gap-1.5">
        <h4 class="font-black uppercase tracking-[0.2em] text-gray-400/80 text-center" :style="{ fontSize: 'calc(6px + var(--hud-font-offset))' }">Posición Satelital</h4>
        <div class="grid grid-cols-2 gap-1.5">
          <div class="flex flex-col items-center bg-white/5 dark:bg-black/20 py-1.5 px-1 rounded-xl border border-white/5">
            <span class="font-black uppercase text-indigo-400 mb-0.5" :style="{ fontSize: 'calc(5px + var(--hud-font-offset))' }">Latitud</span>
            <span class="font-black tabular-nums text-gray-800 dark:text-gray-300 tracking-tighter" :style="{ fontSize: 'calc(9px + var(--hud-font-offset))' }">{{ formatCoordinate(position.lat, 'lat') }}</span>
          </div>
          <div class="flex flex-col items-center bg-white/5 dark:bg-black/20 py-1.5 px-1 rounded-xl border border-white/5">
            <span class="font-black uppercase text-indigo-400 mb-0.5" :style="{ fontSize: 'calc(5px + var(--hud-font-offset))' }">Longitud</span>
            <span class="font-black tabular-nums text-gray-800 dark:text-gray-300 tracking-tighter" :style="{ fontSize: 'calc(9px + var(--hud-font-offset))' }">{{ formatCoordinate(position.lon, 'lon') }}</span>
          </div>
        </div>
      </div>

      <!-- Date & Time & Telemetry -->
      <div class="flex flex-col gap-1.5 px-0.5">
        <div class="flex items-center justify-between font-black uppercase tracking-tighter" :style="{ fontSize: 'calc(8px + var(--hud-font-offset))' }">
          <div class="flex items-center gap-1.5 text-gray-500">
             <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 shadow-[0_0_5px_rgba(16,185,129,0.5)]"></span>
             <span>{{ formatDate(timestamp) }}</span>
          </div>
          <div class="text-gray-900 dark:text-gray-300 font-black">{{ formatTime(timestamp) }}</div>
        </div>

        <!-- Speed & Course - Combined in a pill -->
        <div class="flex items-center justify-between bg-indigo-500/5 dark:bg-white/5 px-2 py-1 rounded-lg border border-indigo-500/10">
          <div class="flex flex-col">
            <span class="font-black text-gray-400 uppercase" :style="{ fontSize: 'calc(5px + var(--hud-font-offset))' }">Velocidad</span>
            <span class="font-black text-indigo-500" :style="{ fontSize: 'calc(8px + var(--hud-font-offset))' }">{{ speed.toFixed(1) }} kn</span>
          </div>
          <div class="w-px h-4 bg-gray-200/20"></div>
          <div class="flex flex-col items-end">
            <span class="font-black text-gray-400 uppercase" :style="{ fontSize: 'calc(5px + var(--hud-font-offset))' }">Rumbo</span>
            <span class="font-black text-gray-900 dark:text-gray-300" :style="{ fontSize: 'calc(8px + var(--hud-font-offset))' }">{{ course }}°</span>
          </div>
        </div>
      </div>

      <!-- Visibility Layers -->
      <div class="flex flex-col gap-1.5 pt-2 border-t border-gray-200/10 dark:border-white/5">
        <div v-for="(val, key) in layers" :key="key" class="flex items-center justify-between group/layer">
          <span class="font-bold text-gray-400 group-hover/layer:text-gray-600 dark:group-hover/layer:text-gray-200 transition-colors capitalize tracking-tighter" :style="{ fontSize: 'calc(7px + var(--hud-font-offset))' }">{{ layerLabels[key] || key }}</span>
          <button
            @click="$emit('update:layer', key, !val)"
            class="relative inline-flex h-2.5 w-6 flex-shrink-0 cursor-pointer rounded-full border border-transparent transition-all duration-300"
            :class="val ? 'bg-indigo-500 shadow-[0_0_8px_rgba(99,102,241,0.4)]' : 'bg-gray-200 dark:bg-gray-800'"
          >
            <span
              class="pointer-events-none inline-block h-2 w-2 transform rounded-full bg-white shadow-sm ring-0 transition duration-300 ease-in-out"
              :class="val ? 'translate-x-3.5' : 'translate-x-0.5'"
            />
          </button>
        </div>
      </div>
    </div>
  </HudCard>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import HudCard from './HudCard.vue'

const props = defineProps<{
  vesselName: string
  vesselMat: string
  position: { lat: number; lon: number }
  timestamp: string
  speed: number
  course: number
  layers: Record<string, boolean>
}>()

defineEmits(['update:layer'])

const layerLabels: Record<string, string> = {
  totalPoints: 'Puntos totales',
  totalTrack: 'Trayectoria total',
  veda: 'Zonas de Veda', // "Áreas de Vieira" in the image, but I'll use generic labels or match image
  isobatas: 'Isobatas',
}

const formatCoordinate = (val: number, type: 'lat' | 'lon') => {
  const absVal = Math.abs(val)
  const degrees = Math.floor(absVal)
  const minutes = ((absVal - degrees) * 60).toFixed(3)
  const suffix = type === 'lat' ? (val >= 0 ? 'S' : 'N') : (val >= 0 ? 'O' : 'E') // Fixed based on image reference (S/O for Argentina area)
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
