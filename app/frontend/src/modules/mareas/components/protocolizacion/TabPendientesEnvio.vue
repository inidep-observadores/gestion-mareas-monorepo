<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Mareas Pendientes de Envío</h2>
        <p class="text-xs text-text-muted">Seleccione las mareas y adjunte el informe (.docx) para enviar a protocolizar.</p>
      </div>
      
      <div v-if="mareas.length > 0" class="flex items-center gap-4">
          <label class="flex items-center gap-2 cursor-pointer group">
              <input type="checkbox" v-model="enviadoPorCanalExterno" class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20">
              <span class="text-[11px] font-bold text-text-muted transition-colors group-hover:text-text uppercase tracking-tight">Envío por canal externo</span>
          </label>
          
          <button 
            @click="enviarSeleccionadas"
            :disabled="sending || selectedMareaIds.length === 0"
            class="flex items-center gap-2 py-2 px-6 bg-primary text-primary-fg rounded-xl text-[11px] font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
          >
            <span v-if="sending" class="w-3 h-3 border-2 border-primary-fg border-t-transparent rounded-full animate-spin"></span>
            {{ sending ? 'Enviando...' : 'Enviar a Protocolizar' }}
          </button>
      </div>
    </div>

    <div v-if="mareas.length > 0" class="grid gap-4 lg:grid-cols-2 2xl:grid-cols-3">
      <div 
        v-for="marea in mareas" 
        :key="marea.id"
        class="bg-surface border border-border rounded-2xl p-5 shadow-sm space-y-4 hover:shadow-md transition-shadow relative"
        :class="{'border-primary shadow-primary/5': isSelected(marea.id)}"
      >
        <div class="flex items-start justify-between">
          <div class="flex gap-4">
            <div class="pt-1">
                <input 
                    type="checkbox" 
                    :value="marea.id" 
                    v-model="selectedMareaIds"
                    class="w-5 h-5 rounded-lg border-border text-primary focus:ring-primary/20"
                >
            </div>
            <div class="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary shrink-0">
               <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                  <polyline points="14 2 14 8 20 8" />
               </svg>
            </div>
            <div>
              <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mb-1">{{ marea.buque_nombre || marea.buque?.nombreBuque }}</p>
              <h3 class="text-base font-black text-text capitalize leading-tight">Marea: {{ marea.nro_marea || marea.nroMarea }}/{{ marea.anio_marea || marea.anioMarea }}</h3>
              <p class="text-xs text-text-muted mt-1">{{ marea.tipo_marea || marea.tipoMarea }} | {{ marea.observador || marea.observadorPrincipal?.nombreCompleto }}</p>
            </div>
          </div>
        </div>
        
        <!-- File Input (solo si está seleccionada y no es canal externo) -->
        <div v-if="isSelected(marea.id) && !enviadoPorCanalExterno" class="pt-4 border-t border-border/50 animate-in fade-in slide-in-from-top-2 duration-300">
            <div class="space-y-2">
                <label class="text-[10px] font-bold uppercase tracking-widest text-text-muted">Adjuntar Informe (.docx)</label>
                <div class="relative">
                    <input 
                        type="file" 
                        accept=".docx" 
                        @change="(e) => handleFileChange(e, marea.id)"
                        class="block w-full text-xs text-text-muted
                               file:mr-4 file:py-2 file:px-4
                               file:rounded-xl file:border-0
                               file:text-[10px] file:font-extrabold file:uppercase
                               file:bg-primary/10 file:text-primary
                               hover:file:bg-primary/20 cursor-pointer"
                    />
                </div>
                <p v-if="files[marea.id]" class="text-[10px] text-success font-bold flex items-center gap-1">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                    Archivo seleccionado: {{ files[marea.id].name }}
                </p>
            </div>
        </div>
        <div v-else-if="isSelected(marea.id) && enviadoPorCanalExterno" class="pt-4 border-t border-border/50">
             <p class="text-[10px] text-warning font-black uppercase tracking-widest">Canal Externo: No requiere adjunto</p>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-20 bg-surface border border-dashed border-border rounded-2xl">
      <div class="w-16 h-16 rounded-full bg-surface-muted border border-border flex items-center justify-center mx-auto mb-4">
         <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-text-muted" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
         </svg>
      </div>
      <h3 class="text-sm font-black text-text uppercase tracking-widest">No hay mareas pendientes de envío</h3>
      <p class="text-xs text-text-muted max-w-sm mx-auto mt-2">Todas las mareas aprobadas ya han sido enviadas a protocolizar o están en proceso.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import mareasService from '../../services/mareas.service'
import { toast } from 'vue-sonner'

const props = defineProps<{
  mareas: any[]
}>()

const emit = defineEmits(['refresh'])

const selectedMareaIds = ref<string[]>([])
const files = ref<Record<string, File>>({})
const enviadoPorCanalExterno = ref(false)
const sending = ref(false)

const isSelected = (id: string) => selectedMareaIds.value.includes(id)

const handleFileChange = (event: Event, mareaId: string) => {
    const target = event.target as HTMLInputElement
    if (target.files && target.files.length > 0) {
        files.value[mareaId] = target.files[0]
    }
}

const enviarSeleccionadas = async () => {
    if (selectedMareaIds.value.length === 0) return

    // Validar que todas tengan archivo si no es canal externo
    if (!enviadoPorCanalExterno.value) {
        const missingFiles = selectedMareaIds.value.filter(id => !files.value[id])
        if (missingFiles.length > 0) {
            toast.error(`Debe adjuntar el informe para las ${missingFiles.length} mareas seleccionadas.`)
            return
        }
    }

    try {
        sending.value = true
        
        const formData = new FormData()
        selectedMareaIds.value.forEach((id) => {
            formData.append('mareaIds', id) // Append multiple times for array
            if (files.value[id]) {
                formData.append('files', files.value[id])
            }
        })
        formData.append('enviadoPorCanalExterno', enviadoPorCanalExterno.value.toString())

        const response = await mareasService.enviarAProtocolizacion(formData)
        toast.success(response.message || 'Envío realizado con éxito.')
        
        // Limpiar estado
        selectedMareaIds.value = []
        files.value = {}
        
        emit('refresh')
    } catch (error: any) {
        console.error('Error enviando a protocolización:', error)
        toast.error(error.response?.data?.message || 'Error al enviar a protocolizar.')
    } finally {
        sending.value = false
    }
}
</script>
