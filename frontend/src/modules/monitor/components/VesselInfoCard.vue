<template>
  <div
    class="pointer-events-auto w-80 bg-white/70 dark:bg-gray-900/70 backdrop-blur-xl rounded-2xl border border-white/20 dark:border-white/10 shadow-2xl overflow-hidden flex flex-col transition-all"
  >
    <!-- Vessel Header -->
    <div class="p-5 border-b border-gray-200/30 dark:border-white/5 flex items-start justify-between">
      <div class="flex flex-col gap-0.5">
        <h4 class="text-[10px] font-black uppercase tracking-widest text-secondary-500/80 mb-1">Buque</h4>
        <h2 class="text-xl font-black text-gray-900 dark:text-white leading-tight">
          {{ vesselName }}
        </h2>
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Mat. {{ vesselMat }}</p>
      </div>
      <div class="p-2 bg-brand-500/10 rounded-xl">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-brand-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
          <path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/>
        </svg>
      </div>
    </div>

    <div class="p-5 flex flex-col gap-6">
      <!-- Current Position -->
      <div class="flex flex-col gap-3">
        <h4 class="text-[10px] font-black uppercase tracking-widest text-gray-400 text-center">Posición Actual</h4>
        <div class="grid grid-cols-2 gap-3">
          <div class="flex flex-col items-center bg-gray-50/50 dark:bg-black/20 p-3 rounded-2xl border border-gray-100 dark:border-white/5">
            <span class="text-[9px] font-black uppercase text-brand-500 mb-1">Latitud</span>
            <span class="text-sm font-bold tracking-tight text-gray-800 dark:text-gray-100">{{ formatCoordinate(position.lat, 'lat') }}</span>
          </div>
          <div class="flex flex-col items-center bg-gray-50/50 dark:bg-black/20 p-3 rounded-2xl border border-gray-100 dark:border-white/5">
            <span class="text-[9px] font-black uppercase text-brand-500 mb-1">Longitud</span>
            <span class="text-sm font-bold tracking-tight text-gray-800 dark:text-gray-100">{{ formatCoordinate(position.lon, 'lon') }}</span>
          </div>
        </div>
      </div>

      <!-- Date & Time -->
      <div class="flex items-center justify-between px-2">
        <div class="flex items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          <span class="text-xs font-medium text-gray-600 dark:text-gray-300">Fecha: <span class="font-bold text-gray-900 dark:text-white">{{ formatDate(timestamp) }}</span></span>
        </div>
        <div class="flex items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
          </svg>
          <span class="text-xs font-medium text-gray-600 dark:text-gray-300">Hora: <span class="font-bold text-gray-900 dark:text-white">{{ formatTime(timestamp) }}</span></span>
        </div>
      </div>

      <!-- Speed & Course -->
      <div class="flex items-center justify-between text-[10px] font-bold uppercase tracking-tight text-gray-500 px-2 mt-[-8px]">
        <span>Vel: <span class="text-gray-900 dark:text-white">{{ speed.toFixed(1) }} kn</span></span>
        <span>Rumbo: <span class="text-gray-900 dark:text-white">{{ course }}°</span></span>
      </div>

      <!-- Visibility Layers -->
      <div class="flex flex-col gap-3 pt-2">
        <h4 class="text-[10px] font-black uppercase tracking-widest text-gray-400">Capas Visibles</h4>
        <div class="flex flex-col gap-2">
          <div v-for="(val, key) in layers" :key="key" class="flex items-center justify-between">
            <span class="text-xs font-bold text-gray-600 dark:text-gray-300 capitalize">{{ layerLabels[key] || key }}</span>
            <button 
              @click="$emit('update:layer', key, !val)"
              class="relative inline-flex h-5 w-10 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none"
              :class="val ? 'bg-brand-500' : 'bg-gray-200 dark:bg-gray-700'"
            >
              <span 
                class="pointer-events-none inline-block h-4 w-4 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                :class="val ? 'translate-x-5' : 'translate-x-0'"
              />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

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
  const suffix = type === 'lat' ? (val >= 0 ? 'N' : 'S') : (val >= 0 ? 'E' : 'O')
  return `${degrees}° ${minutes}' ${suffix}`
}

const formatDate = (ts: string) => {
  if (!ts) return '--/--/----'
  return new Date(ts).toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
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
