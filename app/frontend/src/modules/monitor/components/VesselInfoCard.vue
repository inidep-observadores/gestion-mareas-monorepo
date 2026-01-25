<template>
  <HudCard customClass="w-[210px]">
    <!-- Vessel Header -->
    <div class="p-3 border-b border-border/10 flex items-start justify-between bg-surface/5 group/card cursor-pointer" @click="isCollapsed = !isCollapsed">
      <div class="flex flex-col gap-0.5 overflow-hidden pr-2">
        <h4 class="font-black uppercase tracking-[0.2em] text-primary/80 mb-0.5 text-[10px]">Marea Activa</h4>
        <h2 class="font-black text-text leading-tight tracking-tighter truncate text-sm">
          {{ vesselName }}
        </h2>
        <div v-if="!isCollapsed" class="flex flex-col gap-0.5 mt-0.5">
          <p class="font-black text-primary uppercase text-[10px]">{{ mareaCode }}</p>
          <p v-if="lastUpdate" class="font-bold text-text-muted/60 uppercase text-[8px] italic tracking-tighter">
            Actualizado al {{ formatDate(lastUpdate.toString()) }} {{ formatTime(lastUpdate.toString()) }}
          </p>
        </div>
      </div>
      <div
        class="shrink-0 p-1.5 bg-primary/10 rounded-lg border border-primary/20 text-primary transition-transform duration-300"
        :class="{ 'rotate-180': !isCollapsed }"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
          <path d="M19 9l-7 7-7-7"/>
        </svg>
      </div>
    </div>

    <!-- Collapsible Content -->
    <div v-show="!isCollapsed" class="flex flex-col gap-3 p-3 transition-all duration-300">
      <!-- Current Position -->
      <div class="flex flex-col gap-2">
        <h4 class="font-black uppercase tracking-[0.2em] text-text-muted/60 text-center text-[10px]">Posición Satelital</h4>
        <div class="grid grid-cols-2 gap-2">
          <div class="flex flex-col items-center bg-surface/5 py-1.5 px-1 rounded-xl border border-border/5">
            <span class="font-black uppercase text-primary mb-0.5 text-[9px]">Latitud</span>
            <span class="font-black tabular-nums text-text tracking-tighter text-xs">{{ formatCoordinate(position.lat, 'lat') }}</span>
          </div>
          <div class="flex flex-col items-center bg-surface/5 py-1.5 px-1 rounded-xl border border-border/5">
            <span class="font-black uppercase text-primary mb-0.5 text-[9px]">Longitud</span>
            <span class="font-black tabular-nums text-text tracking-tighter text-xs">{{ formatCoordinate(position.lon, 'lon') }}</span>
          </div>
        </div>
      </div>

      <!-- Date & Time & Telemetry -->
      <div class="flex flex-col gap-2">
        <div class="flex items-center justify-between font-black uppercase tracking-tighter text-xs px-1">
          <div class="flex items-center gap-2 text-text-muted/80">
             <span class="w-2 h-2 rounded-full bg-success shadow-[0_0_8px_rgba(var(--color-primary-rgb),0.4)]"></span>
             <span>{{ formatDate(timestamp) }}</span>
          </div>
          <div class="text-text font-black tracking-tight">{{ formatTime(timestamp) }}</div>
        </div>

        <!-- Speed & Course -->
        <div class="flex items-center justify-between bg-primary/5 px-3 py-2 rounded-xl border border-primary/10">
          <div class="flex flex-col">
            <span class="font-black text-text-muted/60 uppercase text-[9px]">Velocidad</span>
            <span class="font-black text-primary text-xs">{{ speed.toFixed(1) }} kn</span>
          </div>
          <div class="w-px h-4 bg-border/20"></div>
          <div class="flex flex-col items-end">
            <span class="font-black text-text-muted/60 uppercase text-[9px]">Rumbo</span>
            <span class="font-black text-text text-xs">{{ course }}°</span>
          </div>
        </div>
      </div>

      <div v-if="layers" class="flex flex-col gap-1.5 pt-2 border-t border-border/10">
        <template v-for="(val, key) in layers" :key="key">
          <div v-if="shouldShowLayer(key)" class="flex items-center justify-between group/layer">
            <span class="font-bold text-text-muted/80 group-hover/layer:text-text transition-colors tracking-tighter text-[11px]">{{ layerLabels[key] || key }}</span>
            <BaseSwitch
              :modelValue="val"
              @update:modelValue="$emit('update:layer', key, $event)"
              class="scale-90 origin-right"
            />
          </div>
        </template>
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
  mareaCode: string
  position: { lat: number; lon: number }
  timestamp: string
  speed: number
  course: number
  lastUpdate?: string | Date | null
  layers?: Record<string, boolean>
  isSingleMode?: boolean
}>()

defineEmits(['update:layer'])

const isCollapsed = ref(false)

const layerLabels: Record<string, string> = {
  veda: 'Zonas de veda',
  vieira: 'Áreas de vieira',
  centolla: 'Áreas de centolla',
  points: 'Puntos de reporte',
  showAllVessels: 'Todos los buques',
  showVesselNames: 'Mostrar identificación',
}

const shouldShowLayer = (key: string) => {
  // TODO: Habilitar 'points' en el futuro para análisis avanzado de datos.
  // Por ahora se mantiene oculta por no tener una utilidad operativa inmediata.
  if (key === 'points') {
    return false
  }

  // En modo marea única, ocultamos los controles de flota global
  if (props.isSingleMode && (key === 'showAllVessels' || key === 'showVesselNames')) {
    return false
  }

  if (key === 'showVesselNames') {
    return props.layers?.showAllVessels === true
  }
  return true
}

const formatCoordinate = (val: number, type: 'lat' | 'lon') => {
  const absVal = Math.abs(val)
  const degrees = Math.floor(absVal)
  const minutes = ((absVal - degrees) * 60).toFixed(3)
  const suffix = type === 'lat' ? (val >= 0 ? 'N' : 'S') : (val >= 0 ? 'E' : 'O')
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
