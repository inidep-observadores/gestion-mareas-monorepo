<template>
  <div class="alert-timeline py-2">
    <ol class="relative border-l-2 border-base-content/10 ml-3">
      <li v-for="evento in eventosOrdenados" :key="evento.id" class="mb-8 ml-6">
        <span class="absolute flex items-center justify-center w-6 h-6 bg-base-100 rounded-full -left-[13px] ring-4 ring-base-100 shadow-sm border border-base-content/10">
          <component :is="getIcon(evento.tipoEvento)" class="w-3.5 h-3.5 text-info" />
        </span>
        <div class="p-4 bg-base-200/50 rounded-2xl border border-base-content/10 hover:bg-base-200/80 transition-all group">
            <div class="flex justify-between items-start mb-2">
                <span class="text-xs font-black uppercase tracking-tight text-base-content">{{ getTitle(evento.tipoEvento) }}</span>
                <time class="text-[10px] font-black uppercase tracking-wider text-base-content/60 bg-base-content/5 px-2.5 py-1 rounded-lg border border-base-content/5">{{ formatDate(evento.fechaHora) }}</time>
            </div>
            <p v-if="evento.detalle" class="text-[11px] text-base-content/80 leading-relaxed font-medium italic">
                {{ evento.detalle }}
            </p>
            <div v-if="evento.usuario" class="mt-3 pt-3 border-t border-base-content/10 flex items-center gap-2">
                 <div class="avatar placeholder">
                    <div class="bg-info/10 text-info/80 rounded-full w-5">
                        <span class="text-[10px] font-black uppercase">{{ getInitials(evento.usuario.fullName) }}</span>
                    </div>
                 </div> 
                 <span class="text-[10px] font-black uppercase tracking-[0.05em] text-base-content/40">{{ evento.usuario.fullName }}</span>
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
