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
        <div class="flex flex-col h-full">
          <!-- Top Row -->
          <div class="flex justify-between items-start mb-3">
            <span class="text-xs font-mono font-black text-text border border-border bg-surface-muted px-2.5 py-1 rounded-lg tracking-widest shadow-sm">
              {{ formatMareaCode(marea) }}
            </span>
            <div class="flex flex-col items-end gap-1">
              <input
                  type="checkbox"
                  :value="marea.id"
                  v-model="selectedMareaIds"
                  class="w-5 h-5 rounded border-border text-primary focus:ring-primary/20 cursor-pointer"
              >
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

          <!-- Footer (File Input) -->
          <div v-if="isSelected(marea.id) && !enviadoPorCanalExterno" class="animate-in fade-in slide-in-from-top-2 duration-300">
              <div v-if="getInformeAprobado(marea)" class="flex items-center gap-3 p-3 bg-success/10 border border-success/20 rounded-xl">
                  <DocumentCheckIcon class="w-6 h-6 text-success shrink-0" />
                  <span class="text-[10px] font-black uppercase text-success tracking-tight overflow-hidden text-ellipsis">
                      ✓ Informe Aprobado<br/>
                      <span class="text-[9px] font-bold text-success/80 block w-full truncate" :title="getInformeAprobado(marea).metadata?.originalName">{{ getInformeAprobado(marea).metadata?.originalName || 'Documento .docx' }}</span>
                  </span>
              </div>
              <div v-else class="space-y-2">
                  <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/70">Adjuntar Informe (.docx)</label>

                  <div
                    class="relative border-2 border-dashed rounded-xl p-4 transition-all group/drop"
                    :class="[
                      isDragging[marea.id]
                        ? 'border-primary bg-primary/5 scale-[1.02]'
                        : 'border-border hover:border-primary/50 bg-surface-muted/30'
                    ]"
                    @dragover.prevent="onDragOver(marea.id)"
                    @dragleave.prevent="onDragLeave(marea.id)"
                    @drop.prevent="onDrop($event, marea.id)"
                  >
                        <input
                            type="file"
                            :id="'file-' + marea.id"
                            accept=".docx"
                            @change="(e) => handleFileChange(e, marea.id)"
                            class="hidden"
                        />

                        <label
                          :for="'file-' + marea.id"
                          class="flex flex-col items-center justify-center gap-2 cursor-pointer py-2"
                        >
                            <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center text-primary group-hover/drop:scale-110 transition-transform">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                    <polyline points="17 8 12 3 7 8" />
                                    <line x1="12" y1="3" x2="12" y2="15" />
                                </svg>
                            </div>
                            <div class="text-center">
                                <p class="text-[10px] font-black text-text uppercase tracking-tight">
                                    {{ isDragging[marea.id] ? '¡Suelte el archivo!' : 'Suelte el archivo aquí' }}
                                </p>
                                <p class="text-[9px] text-text-muted font-bold mt-0.5">O haga clic para buscar</p>
                            </div>
                        </label>
                  </div>

                  <p v-if="files[marea.id]" class="text-[9px] text-success font-black flex items-center gap-1 uppercase tracking-tighter bg-success/10 px-2 py-1 rounded-md border border-success/20 animate-in zoom-in-95">
                      ✓ {{ files[marea.id].name }}
                  </p>
              </div>
          </div>
          <div v-else-if="isSelected(marea.id) && enviadoPorCanalExterno" class="animate-in fade-in slide-in-from-top-2 duration-300">
               <div class="p-3 bg-primary/5 border border-primary/20 rounded-xl">
                    <p class="text-[10px] font-black text-primary uppercase tracking-tight">Canal Externo</p>
                    <p class="text-[9px] text-text-muted font-bold">Se solicitará la fecha de envío en el diálogo final.</p>
               </div>
          </div>
          <div v-else class="h-10 flex items-center">
               <p class="text-[9px] text-text-muted uppercase tracking-widest font-bold">Seleccione para adjuntar archivo</p>
          </div>
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

    <!-- Modals -->
    <ModalConfirmarEnvioEmail
      :show="showEmailModal"
      :mareas="mareasToProcess"
      :files="processingFiles"
      :sending="sending"
      @close="showEmailModal = false"
      @confirm="onConfirmEmail"
    />

    <ModalConfirmarCanalExterno
      :show="showExternalModal"
      :mareas="mareasToProcess"
      :sending="sending"
      @close="showExternalModal = false"
      @confirm="onConfirmExternal"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import mareasService from '../../services/mareas.service'
import { toast } from 'vue-sonner'
import { ShipIcon } from '@/icons'
import { FileCheck2 as DocumentCheckIcon } from 'lucide-vue-next'
import ModalConfirmarEnvioEmail from './ModalConfirmarEnvioEmail.vue'
import ModalConfirmarCanalExterno from './ModalConfirmarCanalExterno.vue'
import { computed } from 'vue'

const props = defineProps<{
  mareas: any[]
}>()

const emit = defineEmits(['refresh'])

const selectedMareaIds = ref<string[]>([])
const files = ref<Record<string, File>>({})
const isDragging = ref<Record<string, boolean>>({})
const enviadoPorCanalExterno = ref(false)
const sending = ref(false)
const showEmailModal = ref(false)
const showExternalModal = ref(false)
const idsToProcessFinal = ref<string[]>([])

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}

const getInformeAprobado = (marea: any) => {
    return marea.archivos?.find((a: any) => a.tipoArchivo === 'INFORME_APROBACION')
}

const isSelected = (id: string) => selectedMareaIds.value.includes(id)

const handleFileChange = (event: Event, mareaId: string) => {
    const target = event.target as HTMLInputElement
    if (target.files && target.files.length > 0) {
        processFile(target.files[0], mareaId)
    }
}

const onDragOver = (id: string) => {
    isDragging.value[id] = true
}

const onDragLeave = (id: string) => {
    isDragging.value[id] = false
}

const onDrop = (event: DragEvent, id: string) => {
    isDragging.value[id] = false
    const droppedFiles = event.dataTransfer?.files
    if (droppedFiles && droppedFiles.length > 0) {
        processFile(droppedFiles[0], id)
    }
}

const processFile = (file: File, mareaId: string) => {
    // Validar extensión
    const isDocx = file.name.toLowerCase().endsWith('.docx')
    if (!isDocx) {
        toast.error('Solo se permiten archivos .docx')
        return
    }
    files.value[mareaId] = file
}

const mareasToProcess = computed(() => {
    return props.mareas.filter(m => idsToProcessFinal.value.includes(m.id))
})

const processingFiles = computed(() => {
    const subset: Record<string, File> = {}
    idsToProcessFinal.value.forEach(id => {
        if (files.value[id]) subset[id] = files.value[id]
    })
    return subset
})

const enviarSeleccionadas = async () => {
    if (selectedMareaIds.value.length === 0) return

    let ids: string[] = []

    if (enviadoPorCanalExterno.value) {
        // En canal externo, simplemente pasamos las seleccionadas
        ids = [...selectedMareaIds.value]
        idsToProcessFinal.value = ids
        showExternalModal.value = true
    } else {
        // En canal email, validamos que tengan informe
        ids = selectedMareaIds.value.filter(id => {
            const marea = props.mareas.find(m => m.id === id)
            return files.value[id] || getInformeAprobado(marea)
        })
        if (ids.length === 0) {
            toast.error('Seleccione al menos una marea y asegúrese de que cuente con su informe aprobado o de adjuntarlo ahora.')
            return
        }

        idsToProcessFinal.value = ids
        showEmailModal.value = true
    }
}

const onConfirmEmail = (data: { cco?: string, textoAdicional?: string }) => {
    confirmarEnvioFinal(undefined, data)
}

const onConfirmExternal = (fecha: string) => {
    confirmarEnvioFinal(fecha)
}

const confirmarEnvioFinal = async (fechaEnvio?: string, extraData?: { cco?: string, textoAdicional?: string }) => {
    const idsToProcess = idsToProcessFinal.value
    if (idsToProcess.length === 0) return

    try {
        sending.value = true

        const formData = new FormData()
        idsToProcess.forEach((id) => {
            formData.append('mareaIds', id)
            if (!enviadoPorCanalExterno.value && files.value[id]) {
                formData.append(`file_${id}`, files.value[id])
            }
        })
        formData.append('enviadoPorCanalExterno', enviadoPorCanalExterno.value.toString())

        if (enviadoPorCanalExterno.value && fechaEnvio) {
            formData.append('fechaEnvio', fechaEnvio)
        }

        if (extraData?.cco) {
            formData.append('cco', extraData.cco)
        }
        if (extraData?.textoAdicional) {
            formData.append('textoAdicional', extraData.textoAdicional)
        }

        const response = await mareasService.enviarAProtocolizacion(formData)
        toast.success(response.message || 'Envío realizado con éxito.')

        // Limpiar estado
        selectedMareaIds.value = selectedMareaIds.value.filter(id => !idsToProcess.includes(id))
        idsToProcess.forEach(id => {
            delete files.value[id]
            delete isDragging.value[id]
        })

        showEmailModal.value = false
        showExternalModal.value = false
        idsToProcessFinal.value = []
        emit('refresh')
    } catch (error: any) {
        console.error('Error enviando a protocolización:', error)
        toast.error(error.response?.data?.message || 'Error al enviar a protocolizar.')
    } finally {
        sending.value = false
    }
}
</script>
