<template>
  <div class="alert-timeline py-2">
    <ol class="relative border-l-2 border-gray-200 dark:border-gray-800 ml-3">
      <li v-for="evento in eventosOrdenados" :key="evento.id" class="mb-8 ml-6">
        <span class="absolute flex items-center justify-center w-6 h-6 bg-white dark:bg-gray-900 rounded-full -left-[13px] ring-4 ring-white dark:ring-gray-900 shadow-sm border border-gray-200 dark:border-gray-800">
          <component :is="getIcon(evento.tipoEvento)" class="w-3.5 h-3.5 text-brand-500" />
        </span>
        <div class="p-4 bg-gray-50 dark:bg-gray-900/50 rounded-2xl border border-gray-200 dark:border-gray-800 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all group">
            <div class="flex justify-between items-start mb-2">
                <span class="text-xs font-black uppercase tracking-tight text-gray-900 dark:text-white">{{ getTitle(evento.tipoEvento) }}</span>
                <time class="text-[10px] font-bold text-gray-400 dark:text-gray-500 bg-gray-200/50 dark:bg-gray-800 px-2 py-0.5 rounded-md">{{ formatDate(evento.fechaHora) }}</time>
            </div>
            <p v-if="evento.detalle" class="text-[11px] text-gray-600 dark:text-gray-400 leading-relaxed font-medium italic">
                {{ evento.detalle }}
            </p>
            <div v-if="evento.usuario" class="mt-3 pt-3 border-t border-gray-200 dark:border-gray-800 flex items-center gap-2">
                 <div class="avatar placeholder">
                    <div class="bg-brand-50 text-brand-600 dark:bg-brand-900/20 dark:text-brand-400 rounded-full w-5">
                        <span class="text-[10px] font-black uppercase">{{ getInitials(evento.usuario.fullName) }}</span>
                    </div>
                 </div> 
                 <span class="text-[10px] font-black uppercase tracking-[0.05em] text-gray-400 dark:text-gray-500">{{ evento.usuario.fullName }}</span>
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
