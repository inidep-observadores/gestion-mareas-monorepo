<template>
  <HudCard customClass="map-time-slider flex flex-col pointer-events-auto">
    <!-- Controles de Tiempo -->
    <div class="p-3 border-b border-border/10 flex flex-col gap-2">
      <div class="flex justify-between items-center mb-1">
        <h4 class="font-black uppercase tracking-[0.2em] text-primary/80 mb-0.5 text-[10px]">Pronóstico</h4>
        <span class="text-[10px] font-black bg-primary/20 text-primary px-2 py-0.5 rounded-full">
          {{ formatOffset(currentOffset) }}
        </span>
      </div>
      
      <input 
        type="range" 
        :min="0" 
        :max="maxHours" 
        :step="stepHours" 
        v-model.number="currentOffset"
        @input="emitTimeChange"
        class="range range-xs range-primary w-full"
      />
      
      <div class="flex justify-between font-black uppercase tracking-tighter text-[9px] text-text-muted/60 mt-1 px-1">
        <span>Actual</span>
        <span>+24h</span>
        <span>+48h</span>
        <span>+72h</span>
      </div>
      
      <div class="text-center font-black text-text tracking-tighter text-xs mt-1">
        {{ formattedFutureDate }}
      </div>
    </div>

    <!-- Controles de Opacidad -->
    <div class="p-3 flex flex-col gap-2 bg-surface/5 rounded-b-2xl">
      <div class="flex justify-between items-center mb-1">
        <h4 class="font-black uppercase tracking-[0.2em] text-text-muted/60 text-[10px]">Opacidad de capa</h4>
        <span class="font-black text-text tracking-tighter text-[10px]">{{ Math.round(currentOpacity * 100) }}%</span>
      </div>
      
      <input 
        type="range" 
        :min="0" 
        :max="1" 
        :step="0.05" 
        v-model.number="currentOpacity"
        @input="emitOpacityChange"
        class="range range-xs w-full"
      />
    </div>
  </HudCard>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import HudCard from '@/modules/monitor/components/HudCard.vue'

const props = withDefaults(defineProps<{
  maxHours?: number
  stepHours?: number
  initialOpacity?: number
}>(), {
  maxHours: 72,
  stepHours: 3,
  initialOpacity: 0.45
})

const emit = defineEmits<{
  (e: 'time-change', isoTime: string, hoursOffset: number): void
  (e: 'opacity-change', opacity: number): void
}>()

const currentOffset = ref(0)
const currentOpacity = ref(props.initialOpacity)

// Función para emitir la hora ISO calculada en base al offset
const emitTimeChange = () => {
  if (currentOffset.value === 0) {
    emit('time-change', '', currentOffset.value)
    return
  }

  const now = new Date()
  // GeoMet requiere intervalos exactos de 3 horas en UTC (00, 03, 06, 09, 12...)
  const utcHours = now.getUTCHours()
  const roundedHours = Math.floor(utcHours / 3) * 3
  now.setUTCHours(roundedHours, 0, 0, 0)
  
  const future = new Date(now.getTime() + currentOffset.value * 3600000)
  emit('time-change', future.toISOString().split('.')[0] + 'Z', currentOffset.value)
}

const emitOpacityChange = () => {
  emit('opacity-change', currentOpacity.value)
}

// Formateo del label del offset
const formatOffset = (hours: number) => {
  if (hours === 0) return 'Actual'
  return `+${hours}h`
}

// Formateo de la fecha futura para mostrar al usuario
const formattedFutureDate = computed(() => {
  if (currentOffset.value === 0) return 'Ahora'

  const now = new Date()
  const utcHours = now.getUTCHours()
  const roundedHours = Math.floor(utcHours / 3) * 3
  now.setUTCHours(roundedHours, 0, 0, 0)
  
  const future = new Date(now.getTime() + currentOffset.value * 3600000)
  
  return new Intl.DateTimeFormat('es-AR', {
    weekday: 'short',
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  }).format(future)
})

// Emitir inicialmente
watch(() => props.initialOpacity, (newVal) => {
  currentOpacity.value = newVal
}, { immediate: true })

</script>

<style scoped>
/* Fallback simple inputs si FlyonUI no aplica la clase range automáticamente */
input[type=range] {
  accent-color: var(--color-primary);
}
</style>
