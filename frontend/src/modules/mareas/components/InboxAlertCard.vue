<template>
  <div 
    class="flex items-center gap-4 p-4 rounded-2xl group transition-all duration-300 border border-base-content/5 shadow-sm"
    :class="cardClasses"
  >
    <!-- Icon / Status -->
    <div class="flex-shrink-0 relative">
      <div :class="['p-3 text-white rounded-xl shadow-lg transition-transform group-hover:scale-110', iconBgClass]">
        <component :is="statusIcon" class="w-5 h-5" />
      </div>
      <span v-if="estado === 'PENDIENTE' || estado === 'VENCIDA'" class="absolute -top-1 -right-1 flex h-3 w-3">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
        <span class="relative inline-flex rounded-full h-3 w-3 bg-red-500 border-2 border-white dark:border-base-100"></span>
      </span>
    </div>

    <!-- Content -->
    <div class="flex-1 min-w-0">
      <div class="flex items-center gap-2 mb-0.5">
        <span :class="['text-[10px] font-black uppercase tracking-widest', labelClass]">{{ statusLabel }}</span>
        <span class="text-[10px] text-base-content/40 font-mono">• {{ fecha }}</span>
      </div>
      <h4 class="text-sm font-black text-base-content/90 truncate uppercase tracking-tight">
        {{ titulo }}
      </h4>
      <p class="text-[11px] text-base-content/60 line-clamp-1 mt-0.5 leading-relaxed font-medium">
        {{ descripcion }}
      </p>
    </div>

    <!-- Actions -->
    <div class="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
      <button
        @click="$emit('action', 'manage')"
        class="px-3 py-1.5 text-[10px] font-black uppercase tracking-tight rounded-lg transition-all active:scale-95 border"
        :class="actionButtonClass"
      >
        {{ isHistoric ? 'Ver Detalle' : 'Gestionar' }}
      </button>
      <button
        v-if="!isHistoric"
        @click.stop="$emit('action', 'dismiss')"
        class="p-2 text-base-content/30 hover:text-base-content/60 hover:bg-base-200 rounded-lg transition-all"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ErrorIcon, BellIcon, CheckIcon, DocsIcon } from '@/icons'

interface Props {
  titulo: string
  descripcion: string
  fecha: string
  estado?: 'PENDIENTE' | 'SEGUIMIENTO' | 'RESUELTA' | 'DESCARTADA' | 'VENCIDA'
}

const props = withDefaults(defineProps<Props>(), {
    estado: 'PENDIENTE'
})

defineEmits(['action'])

const isHistoric = computed(() => ['RESUELTA', 'DESCARTADA'].includes(props.estado as string))

const cardClasses = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'bg-success/5 border-success/10 hover:bg-success/10'
        case 'SEGUIMIENTO': return 'bg-warning/5 border-warning/10 hover:bg-warning/10'
        case 'DESCARTADA': return 'bg-base-100 border-base-content/10 hover:bg-base-200/40 opacity-80'
        default: return 'bg-error/5 border-error/10 hover:bg-error/10'
    }
})

const iconBgClass = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'bg-success shadow-success/20'
        case 'SEGUIMIENTO': return 'bg-warning shadow-warning/20'
        case 'DESCARTADA': return 'bg-base-300 text-base-content/60 shadow-none border border-base-content/5'
        default: return 'bg-error shadow-error/20'
    }
})

const statusIcon = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return CheckIcon
        case 'SEGUIMIENTO': return BellIcon
        case 'DESCARTADA': return DocsIcon
        default: return ErrorIcon
    }
})

const statusLabel = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'Incidente Resuelto'
        case 'SEGUIMIENTO': return 'En Seguimiento'
        case 'DESCARTADA': return 'Alerta Archivada'
        case 'VENCIDA': return 'Atención Vencida'
        default: return 'Atención Inmediata'
    }
})

const labelClass = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'text-success'
        case 'SEGUIMIENTO': return 'text-warning'
        case 'DESCARTADA': return 'text-base-content/40'
        default: return 'text-error'
    }
})

const actionButtonClass = computed(() => {
    if (isHistoric.value) return 'bg-base-100 text-base-content/60 border-base-content/10 hover:bg-base-200'
    switch (props.estado) {
        case 'SEGUIMIENTO': return 'bg-warning text-white border-warning/20 hover:bg-warning/80'
        default: return 'bg-error text-white border-error/20 hover:bg-error/80'
    }
})
</script>
