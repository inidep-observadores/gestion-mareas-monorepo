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
        <div class="flex items-start justify-between">
          <div class="flex gap-4">
            <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary shrink-0">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                  <polyline points="14 2 14 8 20 8" />
                  <line x1="16" y1="13" x2="8" y2="13" />
                  <line x1="16" y1="17" x2="8" y2="17" />
                  <polyline points="10 9 9 9 8 9" />
              </svg>
            </div>
            <div>
              <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mb-1">{{ marea.buque_nombre }}</p>
              <h3 class="text-base font-black text-text capitalize leading-tight">Marea: {{ marea.nro_marea }}/{{ marea.anio_marea }}</h3>
              <p class="text-xs text-text-muted mt-1">{{ marea.tipo_marea }} | {{ marea.observador }}</p>
            </div>
          </div>
        </div>
        
        <div class="flex items-center justify-between pt-4 border-t border-border/50">
           <button 
             @click="openModal(marea)"
             class="flex items-center justify-center gap-2 w-full py-2.5 px-4 bg-primary text-primary-fg rounded-xl text-[11px] font-black uppercase tracking-widest shadow-md shadow-primary/20 hover:opacity-90 transition-opacity"
           >
             Confirmar Protocolización
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

const closeModal = () => {
  showModal.value = false
  selectedMarea.value = null
}

const onConfirmed = () => {
  closeModal()
  emit('refresh')
}
</script>
