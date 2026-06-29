<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Mareas Pendientes de Envío</h2>
        <p class="text-xs text-text-muted">Seleccione las mareas y adjunte el informe (.docx) para enviar a protocolizar.</p>
      </div>

      <div class="flex flex-col md:flex-row items-start md:items-center gap-4">
          <SearchInput v-model="searchQuery" class="w-full md:w-64" placeholder="Buscar marea, buque, observador..." />
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
    </div>

    <div v-if="filteredAndSortedMareas.length > 0">
      <!-- VISTA MÓVIL: TARJETAS COMPACTAS -->
      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3 xl:hidden">
        <div
          v-for="marea in filteredAndSortedMareas"
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

      <!-- VISTA ESCRITORIO: TABLA -->
      <div class="hidden xl:block overflow-x-auto bg-surface border border-border rounded-2xl shadow-sm mt-4">
        <table class="w-full text-left">
          <thead class="bg-surface-muted/50 text-[10px] font-black uppercase tracking-widest text-text-muted border-b border-border">
            <tr>
              <th class="px-4 py-3 w-10 text-center">
                <input
                    type="checkbox"
                    :checked="filteredAndSortedMareas.length > 0 && selectedMareaIds.length === filteredAndSortedMareas.length"
                    @change="toggleAll"
                    class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20 cursor-pointer"
                >
              </th>
              <th @click="toggleSort('marea')" class="px-4 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Marea
                  <ChevronDownIcon v-if="sortBy === 'marea'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('buque')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Buque
                  <ChevronDownIcon v-if="sortBy === 'buque'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('pesqueria')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Pesquería / Flota
                  <ChevronDownIcon v-if="sortBy === 'pesqueria'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('observador')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Observador
                  <ChevronDownIcon v-if="sortBy === 'observador'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th class="px-5 py-3 text-center">Informe (.docx)</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-for="marea in filteredAndSortedMareas" :key="marea.id" 
                class="group odd:bg-surface-muted/30 hover:bg-primary/5 transition-all"
                :class="{'bg-primary/5': isSelected(marea.id)}">
              <td class="px-4 py-3 text-center">
                <input
                    type="checkbox"
                    :value="marea.id"
                    v-model="selectedMareaIds"
                    class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20 cursor-pointer"
                >
              </td>
              <td class="px-4 py-3">
                <span class="text-[11px] font-mono font-bold text-text-muted uppercase leading-none">{{ formatMareaCode(marea) }}</span>
              </td>
              <td class="px-5 py-3">
                <div class="flex items-center gap-2.5">
                  <div class="w-7 h-7 rounded-lg bg-surface-muted flex items-center justify-center text-text-muted group-hover:bg-primary/10 group-hover:text-primary transition-colors shrink-0">
                    <ShipIcon class="w-3.5 h-3.5" />
                  </div>
                  <span class="text-sm font-bold text-text leading-tight truncate">{{ marea.buque?.nombreBuque || marea.buque_nombre }}</span>
                </div>
              </td>
              <td class="px-5 py-3">
                <div class="flex flex-col">
                  <span class="text-[11px] font-black text-text-muted uppercase tracking-tight leading-tight">
                    {{ marea.pesqueria?.nombre || 'General' }}
                  </span>
                  <span class="text-[9px] font-bold text-primary/70 italic leading-none mt-0.5">
                    {{ marea.buque?.tipoFlota?.nombre || marea.buque?.tipoBuque || 'Flota desconocida' }}
                  </span>
                </div>
              </td>
              <td class="px-5 py-3">
                <span class="text-xs font-bold text-text-muted truncate">{{ marea.observadorPrincipal ? (marea.observadorPrincipal.nombre + ' ' + marea.observadorPrincipal.apellido) : (marea.observador || 'Sin Observador') }}</span>
              </td>
              <td class="px-5 py-3">
                <div v-if="isSelected(marea.id) && !enviadoPorCanalExterno" class="animate-in fade-in flex items-center justify-center">
                  <div v-if="getInformeAprobado(marea)" class="flex items-center gap-2 px-3 py-1.5 bg-success/10 border border-success/20 rounded-lg max-w-[200px]">
                      <DocumentCheckIcon class="w-4 h-4 text-success shrink-0" />
                      <span class="text-[9px] font-black uppercase text-success tracking-tight truncate" :title="getInformeAprobado(marea).metadata?.originalName">
                          {{ getInformeAprobado(marea).metadata?.originalName || 'Informe Aprobado' }}
                      </span>
                  </div>
                  <div v-else class="flex items-center gap-2">
                    <label 
                      class="flex items-center gap-2 px-3 py-1.5 bg-surface-muted hover:bg-primary/10 text-text-muted hover:text-primary border border-border hover:border-primary/50 rounded-lg cursor-pointer transition-colors max-w-[200px]"
                      :class="{'border-success text-success bg-success/10': files[marea.id]}"
                      :title="files[marea.id]?.name"
                    >
                      <input
                          type="file"
                          :id="'file-desktop-' + marea.id"
                          accept=".docx"
                          @change="(e) => handleFileChange(e, marea.id)"
                          class="hidden"
                      />
                      <svg v-if="!files[marea.id]" xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                          <polyline points="17 8 12 3 7 8" />
                          <line x1="12" y1="3" x2="12" y2="15" />
                      </svg>
                      <span v-else class="font-black text-[10px] shrink-0">✓</span>
                      <span class="text-[9px] font-bold uppercase tracking-tighter truncate">
                        {{ files[marea.id]?.name || 'Adjuntar .docx' }}
                      </span>
                    </label>
                  </div>
                </div>
                <div v-else-if="isSelected(marea.id) && enviadoPorCanalExterno" class="text-center">
                   <span class="px-2 py-1 bg-primary/10 text-primary text-[9px] font-black uppercase rounded-md border border-primary/20">Canal Externo</span>
                </div>
                <div v-else class="text-center text-[9px] text-text-muted/50 font-bold uppercase tracking-widest">
                  Seleccione
                </div>
              </td>
            </tr>
          </tbody>
        </table>
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
      <h3 class="text-sm font-black text-text uppercase tracking-widest">No hay mareas para mostrar</h3>
      <p class="text-xs text-text-muted max-w-sm mx-auto mt-2">No se encontraron resultados que coincidan con la búsqueda, o no hay mareas pendientes de envío.</p>
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
import { ShipIcon, ChevronDownIcon } from '@/icons'
import { FileCheck2 as DocumentCheckIcon } from 'lucide-vue-next'
import SearchInput from '@/components/ui/SearchInput.vue'
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
const searchQuery = ref('')
const sortBy = ref('marea')
const sortOrder = ref<'asc'|'desc'>('desc')

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

const toggleAll = (e: Event) => {
  const target = e.target as HTMLInputElement
  if (target.checked) {
    selectedMareaIds.value = filteredAndSortedMareas.value.map(m => m.id)
  } else {
    selectedMareaIds.value = []
  }
}

const toggleSort = (key: string) => {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortOrder.value = 'asc'
  }
}

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

const filteredAndSortedMareas = computed(() => {
  let list = [...props.mareas]

  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(m => {
      const code = formatMareaCode(m).toLowerCase()
      const buque = (m.buque?.nombreBuque || m.buque_nombre || '').toLowerCase()
      const obs = (m.observadorPrincipal ? (m.observadorPrincipal.nombre + ' ' + m.observadorPrincipal.apellido) : (m.observador || '')).toLowerCase()
      const pesqueria = (m.pesqueria?.nombre || '').toLowerCase()
      return code.includes(q) || buque.includes(q) || obs.includes(q) || pesqueria.includes(q)
    })
  }

  return list.sort((a, b) => {
    let valA: any = ''
    let valB: any = ''

    if (sortBy.value === 'marea') {
      const anioA = a.anio_marea || a.anioMarea || 0
      const anioB = b.anio_marea || b.anioMarea || 0
      if (anioA !== anioB) return (anioA - anioB) * (sortOrder.value === 'asc' ? 1 : -1)
      valA = a.nro_marea || a.nroMarea || 0
      valB = b.nro_marea || b.nroMarea || 0
    } else if (sortBy.value === 'buque') {
      valA = (a.buque?.nombreBuque || a.buque_nombre || '').toLowerCase()
      valB = (b.buque?.nombreBuque || b.buque_nombre || '').toLowerCase()
    } else if (sortBy.value === 'pesqueria') {
      valA = (a.pesqueria?.nombre || '').toLowerCase()
      valB = (b.pesqueria?.nombre || '').toLowerCase()
    } else if (sortBy.value === 'observador') {
      valA = (a.observadorPrincipal ? (a.observadorPrincipal.nombre + ' ' + a.observadorPrincipal.apellido) : (a.observador || '')).toLowerCase()
      valB = (b.observadorPrincipal ? (b.observadorPrincipal.nombre + ' ' + b.observadorPrincipal.apellido) : (b.observador || '')).toLowerCase()
    }

    if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1
    if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1
    return 0
  })
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
