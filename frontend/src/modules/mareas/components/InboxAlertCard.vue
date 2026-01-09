<template>
  <div 
    class="flex items-center gap-4 p-4 rounded-2xl group transition-all duration-300 border border-gray-200 dark:border-gray-800 shadow-sm"
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
        <span class="text-[10px] text-gray-400 dark:text-gray-500 font-mono">• {{ fecha }}</span>
      </div>
      <h4 class="text-sm font-black text-gray-900 dark:text-white truncate uppercase tracking-tight">
        {{ titulo }}
      </h4>
      <p class="text-[11px] text-gray-500 dark:text-gray-400 line-clamp-1 mt-0.5 leading-relaxed font-medium">
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
        case 'RESUELTA': return 'bg-white dark:bg-gray-900 hover:bg-gray-50 dark:hover:bg-gray-800'
        case 'SEGUIMIENTO': return 'bg-amber-50/60 dark:bg-amber-900/10 hover:bg-amber-50 dark:hover:bg-amber-900/20'
        case 'DESCARTADA': return 'bg-gray-50 dark:bg-gray-900/50 opacity-75 hover:opacity-100 hover:bg-gray-100 dark:hover:bg-gray-800'
        default: return 'bg-red-50/60 dark:bg-red-900/10 hover:bg-red-50 dark:hover:bg-red-900/20'
    }
})

const iconBgClass = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'bg-green-500 shadow-green-500/20'
        case 'SEGUIMIENTO': return 'bg-amber-500 shadow-amber-500/20'
        case 'DESCARTADA': return 'bg-gray-200 dark:bg-gray-800 text-gray-500 dark:text-gray-400 shadow-none'
        default: return 'bg-red-500 shadow-red-500/20'
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
        case 'RESUELTA': return 'text-green-600 dark:text-green-400'
        case 'SEGUIMIENTO': return 'text-amber-600 dark:text-amber-400'
        case 'DESCARTADA': return 'text-gray-400 dark:text-gray-500'
        default: return 'text-red-600 dark:text-red-400'
    }
})

const actionButtonClass = computed(() => {
    if (isHistoric.value) return 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700'
    switch (props.estado) {
        case 'SEGUIMIENTO': return 'bg-amber-500 text-white border-amber-500/20 hover:bg-amber-600'
        default: return 'bg-red-500 text-white border-red-500/20 hover:bg-red-600'
    }
})
</script>
