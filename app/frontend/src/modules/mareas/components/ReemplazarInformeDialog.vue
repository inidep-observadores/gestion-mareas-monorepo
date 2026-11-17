<template>
  <BaseModal
    :show="show"
    title="Reemplazar Informe de Marea"
    @close="handleClose"
    max-width="md"
  >
    <div v-form-nav class="space-y-6">
      <!-- Info Contextual -->
      <div class="bg-surface-muted/50 border border-border rounded-2xl p-4 space-y-3">
        <div class="flex items-center gap-3">
          <div class="p-2 bg-primary/10 rounded-xl text-primary shrink-0">
            <ShipIcon class="w-4 h-4" />
          </div>
          <div>
            <p class="text-[10px] font-black uppercase tracking-widest text-text-muted mb-0.5">Marea & Buque</p>
            <h4 class="text-sm font-black text-text leading-tight">
              {{ marea?.id_marea }} <span class="mx-1 text-text-muted/40 font-normal">|</span>
              {{ marea?.buque_nombre || marea?.buque?.nombre }}
            </h4>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4 pt-2 border-t border-border/50">
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1">Observador</p>
            <p class="text-xs font-black text-text truncate">{{ marea?.observador || 'No asignado' }}</p>
          </div>
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1">Estado</p>
            <span class="px-2 py-0.5 bg-surface rounded text-[9px] font-black uppercase tracking-tighter text-text border border-border">
              {{ marea?.estado || 'Para Protocolizar' }}
            </span>
          </div>
        </div>
      </div>

      <!-- Referencia de Archivo Actual -->
      <div v-if="currentFileName" class="p-3 bg-surface-muted/30 border border-border/60 rounded-xl flex items-center gap-3">
        <div class="p-2 bg-primary/10 rounded-lg text-primary shrink-0">
          <DocsIcon class="w-4 h-4" />
        </div>
        <div class="min-w-0 flex-1">
          <p class="text-[9px] font-black uppercase tracking-widest text-text-muted">Archivo Actual en Trámite</p>
          <p class="text-xs font-bold text-text truncate" :title="currentFileName">
            {{ currentFileName }}
          </p>
        </div>
      </div>

      <!-- Upload de nuevo informe -->
      <div class="space-y-3">
        <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
          <span>Nuevo Informe Corregido (.docx)</span>
          <span class="text-error text-[8px] italic">* Obligatorio</span>
        </label>

        <div
          class="relative border-2 border-dashed rounded-xl p-5 transition-all group/drop"
          :class="[
            isDragging
              ? 'border-primary bg-primary/5 scale-[1.02]'
              : file
                ? 'border-success/50 bg-success/5'
                : showFileError
                  ? 'border-error/50 bg-error/5'
                  : 'border-border hover:border-primary/50 bg-surface-muted/30'
          ]"
          @dragover.prevent="isDragging = true"
          @dragleave.prevent="isDragging = false"
          @drop.prevent="onDrop"
        >
          <input
            type="file"
            id="reemplazar-informe-file"
            accept=".docx"
            class="hidden"
            @change="onFileChange"
          />

          <label for="reemplazar-informe-file" class="flex flex-col items-center justify-center gap-3 cursor-pointer py-2">
            <div
              class="w-10 h-10 rounded-full flex items-center justify-center transition-transform group-hover/drop:scale-110"
              :class="file ? 'bg-success/10 text-success' : 'bg-primary/10 text-primary'"
            >
              <svg v-if="!file" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                <polyline points="17 8 12 3 7 8" />
                <line x1="12" y1="3" x2="12" y2="15" />
              </svg>
              <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="20 6 9 17 4 12"/>
              </svg>
            </div>
            <div class="text-center">
              <p class="text-[11px] font-black text-text uppercase tracking-tight">
                {{ isDragging ? '¡Suelte el archivo!' : file ? file.name : 'Suelte el nuevo archivo aquí' }}
              </p>
              <p v-if="!file" class="text-[9px] text-text-muted font-bold mt-0.5">O haga clic para buscar en su equipo</p>
              <p v-else class="text-[9px] text-success font-bold mt-0.5">
                {{ (file.size / 1024).toFixed(1) }} KB · Haga clic para cambiar
              </p>
            </div>
          </label>
        </div>

        <p v-if="showFileError && !file" class="text-[10px] font-bold text-error uppercase tracking-tight flex items-center gap-1">
          <WarningIcon class="w-3 h-3" />
          Debe adjuntar el nuevo archivo (.docx) para continuar.
        </p>
      </div>

      <!-- Motivo del Reemplazo (Obligatorio) -->
      <div class="space-y-2">
        <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
          <span>Motivo del Reemplazo</span>
          <span class="text-error text-[8px] italic">* Obligatorio</span>
        </label>
        <textarea
          ref="motivoInput"
          v-model="motivo"
          rows="3"
          placeholder="Describa el motivo o las correcciones realizadas en el nuevo informe..."
          class="w-full bg-surface border border-border rounded-xl p-4 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all resize-none outline-none"
          :class="{ 'border-error ring-1 ring-error/10': showMotivoError }"
        ></textarea>
        <p v-if="showMotivoError" class="text-[10px] font-bold text-error uppercase tracking-tight flex items-center gap-1">
          <WarningIcon class="w-3 h-3" />
          Es obligatorio indicar el motivo para registrar la trazabilidad.
        </p>
      </div>

      <!-- Botones -->
      <div class="flex flex-col sm:flex-row gap-3 pt-2">
        <button
          type="button"
          @click="handleClose"
          :disabled="loading"
          class="flex-1 px-6 py-3 bg-surface border border-border hover:bg-surface-muted text-text-muted hover:text-text rounded-xl text-xs font-black uppercase tracking-widest transition-all disabled:opacity-50"
        >
          Cancelar
        </button>
        <button
          type="button"
          @click="handleConfirm"
          :disabled="loading"
          data-allow-enter
          class="flex-1 px-6 py-3 bg-primary text-primary-fg rounded-xl text-xs font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
        >
          <LoadingSpinner v-if="loading" size="xs" />
          <span v-else>Confirmar Reemplazo</span>
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed, nextTick } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { ShipIcon, WarningIcon, DocsIcon } from '@/icons'

const props = defineProps<{
  show: boolean
  marea: any
  archivoActualNombre?: string
  loading?: boolean
}>()

const emit = defineEmits<{
  close: []
  confirm: [file: File, motivo: string]
}>()

const file = ref<File | null>(null)
const motivo = ref('')
const isDragging = ref(false)
const showFileError = ref(false)
const showMotivoError = ref(false)
const motivoInput = ref<HTMLTextAreaElement | null>(null)

const currentFileName = computed(() => {
  return (
    props.archivoActualNombre ||
    props.marea?.informeAprobado?.nombre ||
    props.marea?.archivos?.[0]?.metadata?.originalName ||
    props.marea?.archivos?.find?.((a: any) => a.tipoArchivo === 'INFORME_APROBACION')?.metadata?.originalName ||
    'Documento .docx anterior'
  )
})

watch(() => props.show, (val) => {
  if (val) {
    file.value = null
    motivo.value = ''
    showFileError.value = false
    showMotivoError.value = false
    isDragging.value = false
    nextTick(() => {
      motivoInput.value?.focus()
    })
  }
})

watch(motivo, (val) => {
  if (val.trim()) showMotivoError.value = false
})

const processFile = (f: File) => {
  if (!f.name.toLowerCase().endsWith('.docx')) return
  file.value = f
  showFileError.value = false
}

const onFileChange = (e: Event) => {
  const target = e.target as HTMLInputElement
  if (target.files?.[0]) processFile(target.files[0])
}

const onDrop = (e: DragEvent) => {
  isDragging.value = false
  const dropped = e.dataTransfer?.files?.[0]
  if (dropped) processFile(dropped)
}

const handleClose = () => {
  if (!props.loading) emit('close')
}

const handleConfirm = () => {
  let hasError = false
  if (!file.value) {
    showFileError.value = true
    hasError = true
  }
  if (!motivo.value.trim()) {
    showMotivoError.value = true
    hasError = true
  }
  if (hasError || !file.value) return

  emit('confirm', file.value, motivo.value.trim())
}
</script>
