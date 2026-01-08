<template>
  <div class="alert-timeline">
    <ol class="relative border-l border-base-content/20 ml-2">
      <li v-for="evento in eventosOrdenados" :key="evento.id" class="mb-6 ml-6">
        <span class="absolute flex items-center justify-center w-6 h-6 bg-base-100 rounded-full -left-3 ring-4 ring-base-100">
          <component :is="getIcon(evento.tipoEvento)" class="w-4 h-4 text-primary" />
        </span>
        <div class="p-3 bg-base-200/50 rounded-lg border border-base-content/5">
            <div class="flex justify-between items-center mb-1">
                <span class="text-sm font-semibold text-base-content/90">{{ getTitle(evento.tipoEvento) }}</span>
                <time class="text-xs text-base-content/50">{{ formatDate(evento.fechaHora) }}</time>
            </div>
            <p v-if="evento.detalle" class="text-sm text-base-content/70 italic">"{{ evento.detalle }}"</p>
            <div v-if="evento.usuario" class="mt-2 flex items-center gap-2">
                 <div class="avatar placeholder">
                    <div class="bg-neutral-focus text-neutral-content rounded-full w-5">
                        <span class="text-xs">{{ getInitials(evento.usuario.fullName) }}</span>
                    </div>
                 </div> 
                 <span class="text-xs text-base-content/60">{{ evento.usuario.fullName }}</span>
            </div>
        </div>
      </li>
    </ol>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { AlertEvent } from '../services/alerts.service'
import { CheckIcon, DocsIcon, EditIcon, ChatIcon } from '@/icons' // Updated imports

const props = defineProps<{
  eventos: AlertEvent[]
}>()

const eventosOrdenados = computed(() => {
  return [...props.eventos].sort((a, b) => new Date(b.fechaHora).getTime() - new Date(a.fechaHora).getTime())
})

const getIcon = (type: string) => {
  switch (type) {
    case 'CREACION': return DocsIcon // Using DocsIcon as placeholder for Create
    case 'RESUELTA': return CheckIcon
    case 'AUTO_RESOLUCION': return CheckIcon
    case 'CAMBIO_ESTADO': return EditIcon
    default: return ChatIcon // Updates/Comments
  }
}

const getTitle = (type: string) => {
    const titulos: Record<string, string> = {
        'CREACION': 'Alerta Detectada',
        'CAMBIO_ESTADO': 'Cambio de Estado',
        'ASIGNACION': 'Asignación de Responsable',
        'COMENTARIO': 'Nuevo Comentario',
        'AUTO_RESOLUCION': 'Resuelta Automáticamente',
        'ESCALADO': 'Alerta Escalada / Vencida'
    }
    return titulos[type] || type
}

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleString('es-AR', { 
    day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' 
  })
}

const getInitials = (name: string) => {
    return name.split(' ').map(n => n[0]).join('').substring(0,2).toUpperCase()
}
</script>
