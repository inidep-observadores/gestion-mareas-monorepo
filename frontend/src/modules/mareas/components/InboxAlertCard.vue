<template>
  <div
    class="flex items-center gap-4 p-4 rounded-2xl group transition-all duration-300 border border-border shadow-sm"
    :class="cardClasses"
  >
    <!-- Icon / Status -->
    <div class="flex-shrink-0 relative">
      <div :class="['p-3 text-white rounded-xl shadow-lg transition-transform group-hover:scale-110', iconBgClass, { 'animate-pulse': isUrgent }]">
        <component :is="statusIcon" class="w-5 h-5" />
      </div>
      <span v-if="estado === AlertaEstado.PENDIENTE || estado === AlertaEstado.VENCIDA" class="absolute -top-1 -right-1 flex h-3 w-3">
        <span :class="['animate-ping absolute inline-flex h-full w-full rounded-full opacity-75', isUrgent ? 'bg-error' : 'bg-error/60']"></span>
        <span :class="['relative inline-flex rounded-full h-3 w-3 border-2 border-background', isUrgent ? 'bg-error' : 'bg-error/80']"></span>
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
import { AlertaEstado, AlertaPrioridad } from '../../alerts/services/alerts.service'

interface Props {
  titulo: string
  descripcion: string
  fecha: string
  estado?: AlertaEstado
  prioridad?: AlertaPrioridad
  referenciaTipo?: string
  metadata?: Record<string, any>
  notaGestion?: string
}

const props = withDefaults(defineProps<Props>(), {
    estado: AlertaEstado.PENDIENTE,
    prioridad: AlertaPrioridad.MEDIA
})

defineEmits(['action'])

const isHistoric = computed(() => [AlertaEstado.RESUELTA, AlertaEstado.DESCARTADA].includes(props.estado as AlertaEstado))
const isUrgent = computed(() => props.prioridad === AlertaPrioridad.URGENTE && !isHistoric.value)

const cardClasses = computed(() => {
    if (isHistoric.value) {
        return props.estado === AlertaEstado.RESUELTA 
            ? 'bg-surface-muted/40 hover:bg-surface-muted/60' 
            : 'bg-surface opacity-75 hover:opacity-100 hover:bg-surface-muted/40'
    }
    
    if (props.estado === AlertaEstado.SEGUIMIENTO) {
        return 'bg-warning/5 hover:bg-warning/10 border-warning/20'
    }

    // Para PENDIENTE y VENCIDA usamos la prioridad
    switch (props.prioridad) {
        case AlertaPrioridad.URGENTE: return 'bg-error/10 hover:bg-error/15 border-error/40 shadow-lg shadow-error/5 ring-1 ring-error/20'
        case AlertaPrioridad.ALTA: return 'bg-warning/5 hover:bg-warning/10 border-warning/20'
        case AlertaPrioridad.MEDIA: return 'bg-info/5 hover:bg-info/10 border-info/20'
        case AlertaPrioridad.BAJA: return 'bg-purple/5 hover:bg-purple/10 border-purple/20'
        default: return 'bg-error/5 hover:bg-error/10 border-error/20'
    }
})

const iconBgClass = computed(() => {
    if (isHistoric.value) {
        return props.estado === AlertaEstado.RESUELTA ? 'bg-success shadow-success/20' : 'bg-text-muted/40 text-background shadow-none'
    }

    if (props.estado === AlertaEstado.SEGUIMIENTO) {
        return 'bg-warning shadow-warning/20'
    }

    switch (props.prioridad) {
        case AlertaPrioridad.URGENTE: return 'bg-error shadow-error/40'
        case AlertaPrioridad.ALTA: return 'bg-warning shadow-warning/20'
        case AlertaPrioridad.MEDIA: return 'bg-info shadow-info/20'
        case AlertaPrioridad.BAJA: return 'bg-purple shadow-purple/10'
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
    if (isHistoric.value) {
        return props.estado === AlertaEstado.RESUELTA ? 'Incidente Resuelto' : 'Alerta Archivada'
    }

    if (props.estado === AlertaEstado.SEGUIMIENTO) {
        return 'En Seguimiento'
    }

    const prefix = props.estado === AlertaEstado.VENCIDA ? 'Vencida' : 'Pendiente'
    switch (props.prioridad) {
        case AlertaPrioridad.URGENTE: return `${prefix}: Atención Inmediata`
        case AlertaPrioridad.ALTA: return `${prefix}: Importante`
        case AlertaPrioridad.MEDIA: return `${prefix}: Normal`
        case AlertaPrioridad.BAJA: return `${prefix}`
        default: return `${prefix}`
    }
})

const labelClass = computed(() => {
    if (isHistoric.value) {
        return props.estado === AlertaEstado.RESUELTA ? 'text-success' : 'text-text-muted/60'
    }

    if (props.estado === AlertaEstado.SEGUIMIENTO) {
        return 'text-warning'
    }

    switch (props.prioridad) {
        case AlertaPrioridad.URGENTE: return 'text-error font-black'
        case AlertaPrioridad.ALTA: return 'text-warning'
        case AlertaPrioridad.MEDIA: return 'text-info'
        case AlertaPrioridad.BAJA: return 'text-purple'
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
    
    if (props.estado === AlertaEstado.SEGUIMIENTO) return 'warning'

    switch (props.prioridad) {
        case AlertaPrioridad.URGENTE: return 'error'
        case AlertaPrioridad.ALTA: return 'warning'
        case AlertaPrioridad.MEDIA: return 'info'
        case AlertaPrioridad.BAJA: return 'purple'
        default: return 'error'
    }
})

const notaGestionCorta = computed(() => {
    const text = props.notaGestion?.trim()
    if (!text) return ''
    return text.length > 50 ? `${text.slice(0, 47)}...` : text
})
</script>
