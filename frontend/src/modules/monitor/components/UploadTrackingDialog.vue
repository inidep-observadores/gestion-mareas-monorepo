<template>
  <BaseModal
    :show="show"
    title="Importar Seguimiento"
    maxWidth="xl"
    @close="closeIfPossible"
  >
    <template #title>
      <div class="flex flex-col">
        <h2 class="text-xs font-black text-text uppercase tracking-widest">Importar Seguimiento</h2>
        <p class="text-[9px] text-text-muted font-bold uppercase tracking-tight">Procesamiento de Archivos CSV de SIOP</p>
      </div>
    </template>

    <div class="space-y-6">
      <!-- Dropzone -->
      <div
        v-if="files.length === 0"
        @click="triggerFileInput"
        class="group cursor-pointer border border-dashed border-border/20 rounded-2xl p-12 flex flex-col items-center justify-center gap-4 hover:border-primary/40 hover:bg-primary/5 transition-all bg-surface-muted/10 shadow-theme-xs"
      >
        <div class="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center text-primary group-hover:scale-110 transition-transform">
           <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
             <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>
           </svg>
        </div>
        <div class="text-center">
          <div class="text-[11px] font-black text-text uppercase tracking-widest">Seleccionar Archivos</div>
          <p class="text-[9px] text-text-muted uppercase font-bold mt-1">Suelte archivos CSV aquí o haga clic para buscar</p>
        </div>
        <input type="file" ref="fileInput" multiple accept=".csv" class="hidden" @change="handleFileChange">
      </div>

      <!-- Sequential List -->
      <div v-else class="space-y-3 max-h-[400px] overflow-y-auto custom-scrollbar pr-2">
        <div
          v-for="(f, idx) in files"
          :key="idx"
          class="p-4 rounded-2xl bg-surface-muted/30 border border-border/10 flex items-center justify-between group transition-all"
          :class="{ 'border-primary/40 shadow-theme-md bg-surface': f.status === 'processing' }"
        >
          <div class="flex items-center gap-4">
            <div class="w-10 h-10 rounded-xl bg-surface flex items-center justify-center shadow-theme-xs border border-border/5">
              <svg v-if="f.status === 'pending'" class="w-5 h-5 text-text-muted/40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="13 2 13 9 20 9"/></svg>
              <div v-if="f.status === 'processing'" class="w-5 h-5 border-2 border-primary border-t-transparent animate-spin rounded-full"></div>
              <svg v-if="f.status === 'success'" class="w-5 h-5 text-success" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
              <svg v-if="f.status === 'error'" class="w-5 h-5 text-error" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </div>
            <div>
              <div class="text-[10px] font-black text-text uppercase tracking-tight truncate max-w-[220px]">{{ f.file.name }}</div>
              <div class="text-[8px] font-bold uppercase mt-0.5" :class="statusColor(f.status)">
                {{ statusText(f) }}
              </div>
            </div>
          </div>

          <button
            v-if="f.status === 'pending' && !isUploading"
            @click="removeFile(idx)"
            class="p-2 opacity-0 group-hover:opacity-100 hover:bg-error/10 hover:text-error rounded-lg transition-all"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 6L6 18M6 6l12 12"/></svg>
          </button>
        </div>
      </div>

      <!-- Footer Actions -->
      <div v-if="files.length > 0" class="pt-6 border-t border-border/10 flex justify-between items-center">
        <Button
          v-if="!isUploading"
          variant="ghost"
          size="xs"
          className="!text-[10px] font-black !text-text-muted hover:!text-error uppercase tracking-widest"
          @click="files = []"
        >
          Limpiar Todo
        </Button>
        <div v-else class="text-[9px] font-black text-primary uppercase tracking-[0.2em] animate-pulse">
           Procesando Archivos...
        </div>

        <div class="flex gap-3">
          <Button
            v-if="!allFinished"
            variant="primary"
            size="sm"
            className="!rounded-xl shadow-lg shadow-primary/20"
            :disabled="isUploading"
            @click="startUpload"
          >
            <span class="text-[10px] font-black uppercase tracking-widest">
              {{ isUploading ? 'Cargando...' : `Iniciar Carga (${files.length})` }}
            </span>
          </Button>
          <Button
            v-else
            variant="outline"
            size="sm"
            className="!rounded-xl"
            @click="$emit('close'); $emit('refresh')"
          >
            <span class="text-[10px] font-black uppercase tracking-widest text-text">Cerrar Panel</span>
          </Button>
        </div>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import httpClient from '@/config/http/http.client'
import BaseModal from '@/components/common/BaseModal.vue'
import Button from '@/components/ui/Button.vue'

const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'refresh'): void
}>()

interface FileQueueItem {
  file: File
  status: 'pending' | 'processing' | 'success' | 'error'
  error?: string
}

const fileInput = ref<HTMLInputElement | null>(null)
const files = ref<FileQueueItem[]>([])
const isUploading = ref(false)

const allFinished = computed(() =>
  files.value.length > 0 && files.value.every(f => f.status === 'success' || f.status === 'error')
)

const triggerFileInput = () => fileInput.value?.click()

const handleFileChange = (e: Event) => {
  const selectedFiles = (e.target as HTMLInputElement).files
  if (selectedFiles) {
    for (let i = 0; i < selectedFiles.length; i++) {
      files.value.push({
        file: selectedFiles[i],
        status: 'pending'
      })
    }
  }
}

const removeFile = (idx: number) => {
  files.value.splice(idx, 1)
}

const statusText = (f: FileQueueItem) => {
  if (f.status === 'pending') return 'En espera'
  if (f.status === 'processing') return 'Procesando datos...'
  if (f.status === 'success') return 'Completado con éxito'
  if (f.status === 'error') return f.error || 'Error en la importación'
  return ''
}

const statusColor = (status: string) => {
  if (status === 'processing') return 'text-primary'
  if (status === 'success') return 'text-success'
  if (status === 'error') return 'text-error'
  return 'text-text-muted/60'
}

const startUpload = async () => {
  if (isUploading.value) return
  isUploading.value = true

  for (let i = 0; i < files.value.length; i++) {
    const item = files.value[i]
    if (item.status === 'success') continue

    item.status = 'processing'

    try {
      const formData = new FormData()
      formData.append('file', item.file)

      await httpClient.post('/tracking/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        timeout: 600000 // 10 minutos para procesos pesados
      })

      item.status = 'success'
    } catch (err: any) {
      item.status = 'error'
      const responseData = err.response?.data
      
      // Extracción robusta de mensajes de error
      let backendMsg = ''
      if (typeof responseData === 'string') {
        backendMsg = responseData
      } else if (responseData) {
        backendMsg = responseData.message || 
                     responseData.exception?.message || 
                     responseData.error || 
                     ''
      }

      const isValidationError = err.response?.status === 422
      item.error = backendMsg || (isValidationError ? 'Formato no válido' : 'Error procesando')
    }
  }

  isUploading.value = false
}

const closeIfPossible = () => {
  if (!isUploading.value) emit('close')
}
</script>
