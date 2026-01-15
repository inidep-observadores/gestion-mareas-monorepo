<template>
  <div
    class="flex items-center gap-4 p-4 rounded-2xl group transition-all duration-300 border border-border shadow-sm"
    :class="cardClasses"
  >
    <!-- Icon / Status -->
    <div class="flex-shrink-0 relative">
      <div :class="['p-3 text-white rounded-xl shadow-lg transition-transform group-hover:scale-110', iconBgClass]">
        <component :is="statusIcon" class="w-5 h-5" />
      </div>
      <span v-if="estado === 'PENDIENTE' || estado === 'VENCIDA'" class="absolute -top-1 -right-1 flex h-3 w-3">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
        <span class="relative inline-flex rounded-full h-3 w-3 bg-red-500 border-2 border-background"></span>
      </span>
    </div>

    <!-- Content -->
    <div class="flex-1 min-w-0">
      <div class="flex items-center gap-2 mb-0.5 flex-wrap">
        <span :class="['text-[10px] font-black uppercase tracking-widest', labelClass]">{{ statusLabel }}</span>
        <Badge 
          v-if="referenciaTipo" 
          :color="originBadgeColor" 
          variant="light" 
          size="sm"
          class="font-bold uppercase tracking-wider py-0.5 px-2 rounded-lg"
        >
            {{ referenciaTipo }}
            <span v-if="metadata && metadata.mareaCode" class="ml-1 opacity-75 font-mono">{{ metadata.mareaCode }}</span>
        </Badge>
        <span class="text-[10px] text-text-muted/60 font-mono">• {{ fecha }}</span>
      </div>
      <h4 class="text-sm font-black text-text truncate uppercase tracking-tight">
        {{ titulo }}
      </h4>
      <p class="text-[11px] text-text-muted line-clamp-1 mt-0.5 leading-relaxed font-medium">
        {{ descripcion }}
      </p>
      <p v-if="notaGestionCorta" class="text-[10px] text-text-muted/60 mt-1 leading-relaxed font-semibold">
        Nota de gestion: {{ notaGestionCorta }}
      </p>
    </div>

    <!-- Actions -->
    <div class="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-all duration-300">
      <Button
        @click="$emit('action', 'manage')"
        :variant="actionButtonVariant"
        size="sm"
        class="uppercase tracking-tight h-8 px-4"
      >
        {{ isHistoric ? 'Ver Detalle' : 'Gestionar' }}
      </Button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ErrorIcon, BellIcon, CheckIcon, DocsIcon } from '@/icons'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'

interface Props {
  titulo: string
  descripcion: string
  fecha: string
  estado?: 'PENDIENTE' | 'SEGUIMIENTO' | 'RESUELTA' | 'DESCARTADA' | 'VENCIDA'
  referenciaTipo?: string
  metadata?: Record<string, any>
  notaGestion?: string
}

const props = withDefaults(defineProps<Props>(), {
    estado: 'PENDIENTE'
})

defineEmits(['action'])

const isHistoric = computed(() => ['RESUELTA', 'DESCARTADA'].includes(props.estado as string))

const cardClasses = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'bg-surface-muted/40 hover:bg-surface-muted/60'
        case 'SEGUIMIENTO': return 'bg-warning/5 hover:bg-warning/10 border-warning/20'
        case 'DESCARTADA': return 'bg-surface opacity-75 hover:opacity-100 hover:bg-surface-muted/40'
        default: return 'bg-error/5 hover:bg-error/10 border-error/20'
    }
})

const iconBgClass = computed(() => {
    switch (props.estado) {
        case 'RESUELTA': return 'bg-success shadow-success/20'
        case 'SEGUIMIENTO': return 'bg-warning shadow-warning/20'
        case 'DESCARTADA': return 'bg-text-muted/40 text-background shadow-none'
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
        case 'DESCARTADA': return 'text-text-muted/60'
        default: return 'text-error'
    }
})

const originBadgeColor = computed(() => {
    switch (props.referenciaTipo) {
        case 'MAREA': return 'info'
        case 'OBSERVADOR': return 'primary'
        case 'BUQUE': return 'warning'
        default: return 'light'
    }
})

const actionButtonVariant = computed(() => {
    if (isHistoric.value) return 'soft'
    switch (props.estado) {
        case 'SEGUIMIENTO': return 'warning'
        default: return 'error'
    }
})

const notaGestionCorta = computed(() => {
    const text = props.notaGestion?.trim()
    if (!text) return ''
    return text.length > 50 ? `${text.slice(0, 47)}...` : text
})
</script>
