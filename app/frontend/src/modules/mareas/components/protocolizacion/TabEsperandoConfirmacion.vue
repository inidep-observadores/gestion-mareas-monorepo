<template>
  <div class="space-y-6">
    
    <div class="flex items-center justify-between mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Mareas Enviadas a Protocolizar</h2>
        <p class="text-xs text-text-muted">Aguardando la confirmación de fecha, número y año por parte de la autoridad.</p>
      </div>
    </div>

    <!-- Data Table / Grid -->
    <div v-if="mareas.length > 0" class="grid gap-4 lg:grid-cols-2 2xl:grid-cols-3">
      <div 
        v-for="marea in mareas" 
        :key="marea.id"
        class="bg-surface border border-border rounded-2xl p-5 shadow-sm space-y-4 hover:shadow-md transition-shadow"
      >
        <div class="flex flex-col h-full">
          <!-- Top Row -->
          <div class="flex justify-between items-start mb-3">
            <span class="text-xs font-mono font-black text-text border border-border bg-surface-muted px-2.5 py-1 rounded-lg tracking-widest shadow-sm">
              {{ formatMareaCode(marea) }}
            </span>
            <div class="flex flex-col items-end gap-1">
              <div class="px-2 py-0.5 bg-warning/10 border border-warning/20 rounded-full text-[9px] font-black text-warning uppercase tracking-tighter">
                Enviada
              </div>
            </div>
          </div>

          <!-- Main Info -->
          <div class="mb-3 flex-1">
            <div class="flex items-center gap-2 mb-1">
              <ShipIcon class="w-3.5 h-3.5 text-primary shrink-0" />
              <h4 class="text-sm font-black text-text">{{ marea.buque?.nombreBuque || marea.buque_nombre }}</h4>
            </div>
            <div class="flex flex-col gap-0.5 ml-5">
              <p class="text-[10px] font-black text-text-muted uppercase tracking-tight">
                {{ marea.pesqueria?.nombre || 'General' }}
              </p>
              <p class="text-[9px] font-bold text-text-muted/70 italic leading-none">
                {{ marea.buque?.tipoFlota?.nombre || marea.buque?.tipoBuque || 'Flota desconocida' }}
              </p>
            </div>
            <p class="text-xs font-bold text-text-muted truncate mt-1 ml-5">
              {{ marea.observadorPrincipal ? (marea.observadorPrincipal.nombre + ' ' + marea.observadorPrincipal.apellido) : (marea.observador || 'Sin Observador') }}
            </p>
          </div>

          <!-- Divider -->
          <div class="my-4 border-t border-border/50"></div>

          <!-- Footer (Button) -->
          <button 
            @click="openModal(marea)"
            class="flex items-center justify-center gap-2 w-full py-2 bg-primary text-primary-fg rounded-xl text-[10px] font-black uppercase tracking-widest shadow-md shadow-primary/10 hover:opacity-90 transition-all"
          >
            Confirmar Datos
          </button>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-20 bg-surface border border-dashed border-border rounded-2xl">
      <div class="w-16 h-16 rounded-full bg-surface-muted border border-border flex items-center justify-center mx-auto mb-4">
         <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-text-muted" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
         </svg>
      </div>
      <h3 class="text-sm font-black text-text uppercase tracking-widest">No hay mareas esperando confirmación</h3>
      <p class="text-xs text-text-muted max-w-sm mx-auto mt-2">No tienes tareas pendientes de confirmación en este momento.</p>
    </div>

    <!-- Confirm Modal -->
    <ModalConfirmarProtocolizacion 
      :show="showModal"
      :marea="selectedMarea"
      @close="closeModal"
      @confirmed="onConfirmed"
    />

  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import ModalConfirmarProtocolizacion from './ModalConfirmarProtocolizacion.vue'
import mareasService from '../../services/mareas.service'
import { toast } from 'vue-sonner'
import { ShipIcon } from '@/icons'

const props = defineProps<{
  mareas: any[]
}>()

const emit = defineEmits(['refresh'])

const showModal = ref(false)
const selectedMarea = ref<any>(null)

const openModal = (marea: any) => {
  selectedMarea.value = marea
  showModal.value = true
}

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}

const closeModal = () => {
  showModal.value = false
  selectedMarea.value = null
}

const onConfirmed = () => {
  closeModal()
  emit('refresh')
}
</script>
