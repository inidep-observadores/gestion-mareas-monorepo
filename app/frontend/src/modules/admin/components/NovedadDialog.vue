<template>
  <BaseModal :show="show" @close="close" :title="isEdit ? 'Editar Novedad' : 'Nueva Novedad'" :maxWidth="hasPreview ? '5xl' : '2xl'">
    <div class="grid gap-6 items-start" :class="hasPreview ? 'lg:grid-cols-2' : 'grid-cols-1'">
      <!-- Formulario -->
      <div v-form-nav class="space-y-6">
      <div v-if="error" class="p-4 bg-error/5 border border-error/20 rounded-xl text-error text-[10px] font-black uppercase tracking-widest text-center">
        {{ error }}
      </div>

      <div class="grid grid-cols-1 gap-6">
        <!-- Observador -->
        <div class="space-y-1.5">
          <label class="block text-sm font-medium text-text-muted">Observador</label>
          <SearchableSelect 
            ref="observadorSelect"
            v-model="form.observadorId" 
            :options="observadorOptions"
            :icon="UserGroupIcon" 
            :error="fieldErrors.observadorId" 
            placeholder="Seleccione el observador..." 
            :disabled="isEdit"
          />
        </div>

        <!-- Tipo de Disponibilidad (Novedad) -->
        <div class="space-y-1.5">
          <label class="block text-sm font-medium text-text-muted">Tipo de Novedad</label>
          <select 
            v-model="form.tipoNovedadId"
            class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs"
            :class="fieldErrors.tipoNovedadId ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'"
            :disabled="!form.observadorId"
          >
            <option value="" disabled>Seleccione un tipo...</option>
            <option v-for="tipo in filteredTiposNovedad" :key="tipo.id" :value="tipo.id">
              {{ tipo.descripcion }}
            </option>
          </select>
          <p v-if="!form.observadorId" class="text-[10px] text-text-muted font-bold uppercase mt-1">Debe seleccionar un observador primero</p>
          <p v-if="fieldErrors.tipoNovedadId" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.tipoNovedadId }}</p>
        </div>

        <!-- Rango de Fechas -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div class="space-y-1.5">
            <label class="block text-sm font-medium text-text-muted">Fecha de Inicio</label>
            <DatePicker 
              v-model="form.fechaInicio" 
              :icon="CalenderIcon" 
              :show-time="false"
              :error="fieldErrors.fechaInicio" 
            />
          </div>
          <div class="space-y-1.5">
            <label class="block text-sm font-medium text-text-muted">Fecha de Fin (Opcional)</label>
            <DatePicker 
              v-model="form.fechaFin" 
              :icon="CalenderIcon" 
              :show-time="false"
              :error="fieldErrors.fechaFin" 
            />
          </div>
        </div>

        <!-- Flexibilidad -->
        <div class="flex items-start gap-3 bg-surface border border-border p-4 rounded-lg shadow-theme-xs transition-all" :class="{'opacity-50 pointer-events-none': isViajeNovedad}">
          <BaseSwitch v-model="form.permiteUrgencia" class="mt-0.5" />
          <div class="flex-1">
            <p class="text-sm font-bold text-text">Permitir cancelación anticipada por urgencia</p>
            <p class="text-[11px] text-text-muted mt-0.5 leading-relaxed">Indica si esta novedad es flexible y el observador puede ser convocado antes de la fecha de fin en caso de necesidad operativa.</p>
          </div>
        </div>

        <!-- Motivo / Observaciones -->
        <div class="space-y-1.5">
          <label class="block text-sm font-medium text-text-muted">Motivo / Observaciones</label>
          <textarea 
            v-model="form.motivo" 
            rows="3"
            placeholder="Ingrese el motivo de la novedad si es necesario..."
            class="w-full px-4 py-2.5 bg-surface border border-border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs resize-none"
          ></textarea>
        </div>

        <!-- Archivo Adjunto -->
        <div class="space-y-1.5">
          <label class="block text-sm font-medium text-text-muted">Archivo Adjunto</label>
          <div v-if="isEdit && editData?.archivos?.length && !eliminarArchivoViejo" class="flex items-center gap-3 p-3 bg-surface border border-border rounded-lg shadow-theme-xs">
             <DocsIcon class="w-5 h-5 text-primary" />
             <div class="flex-1 overflow-hidden">
                <p class="text-sm font-medium text-text truncate">{{ editData.archivos[0].nombreOriginal || 'Archivo adjunto' }}</p>
             </div>
             <button @click.prevent="eliminarArchivoViejo = true" class="text-xs font-bold text-error hover:underline px-2">Eliminar / Reemplazar</button>
          </div>
          <div v-else>
            <input 
              type="file" 
              ref="fileInput"
              @change="e => selectedFile = (e.target as HTMLInputElement).files?.[0] || null"
              class="w-full text-sm text-text file:mr-4 file:py-2.5 file:px-4 file:rounded-lg file:border-0 file:text-xs file:font-black file:uppercase file:tracking-widest file:bg-primary/10 file:text-primary hover:file:bg-primary/20 transition-all border border-border rounded-lg cursor-pointer bg-surface"
            />
            <button v-if="isEdit && eliminarArchivoViejo && editData?.archivos?.length" @click.prevent="restaurarArchivoViejo" class="mt-2 text-[10px] font-bold text-primary uppercase hover:underline">Deshacer (Mantener original)</button>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="mt-6 pt-6 flex items-center justify-end gap-3 border-t border-border">
        <button 
          @click="close"
          class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all"
        >
          Cancelar
        </button>
        <button 
          @click="submit" 
          :disabled="loading"
          :data-allow-enter="true"
          class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 flex items-center gap-2 disabled:opacity-50"
        >
          <div v-if="loading" class="flex items-center justify-center">
            <LoadingSpinner size="xs" class="text-primary-fg" />
          </div>
          <template v-else>
            {{ isEdit ? 'Guardar Cambios' : 'Crear Novedad' }}
          </template>
        </button>
      </div>
      </div>
      
      <!-- Previsualización (Emails / Archivos) -->
      <div v-if="hasPreview" class="bg-surface-muted rounded-xl border border-border p-5 flex flex-col gap-4 max-h-[80vh] overflow-y-auto">
        <div class="flex items-center gap-2 mb-2 border-b border-border pb-3">
          <DocsIcon class="w-5 h-5 text-primary" />
          <h3 class="text-base font-bold text-text">Contenido Original (Origen: {{ editData?.origen }})</h3>
        </div>
        
        <div v-if="editData?.metadata?.body" class="space-y-2">
          <h4 class="text-[10px] font-black text-text-muted uppercase tracking-wider">Cuerpo del Mensaje</h4>
          <div class="p-4 bg-white dark:bg-gray-900 border border-border rounded-lg text-xs text-text whitespace-pre-wrap font-mono leading-relaxed shadow-inner overflow-x-auto">
            {{ editData.metadata.body }}
          </div>
        </div>
        
        <AttachmentViewer 
          v-if="editData?.archivos && editData.archivos.length > 0" 
          :archivos="editData.archivos" 
          title="Archivos Adjuntos" 
          class="mt-4" 
        />
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import BaseSwitch from '@/components/ui/BaseSwitch.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import AttachmentViewer from '@/components/common/AttachmentViewer.vue'
import catalogosService from '@/modules/mareas/services/catalogos.service'
import tiposNovedadApi from '../services/tipos-novedad.service'
import { novedadesService } from '../services/novedades.service'
import {
  UserGroupIcon,
  CalenderIcon,
  DocsIcon
} from '@/icons'
import type { Novedad } from '../interfaces/novedad.interface'
import type { TipoNovedad } from '../interfaces/tipo-novedad.interface'

const props = defineProps<{
  show: boolean
  editData?: Novedad | null
}>()

const emit = defineEmits(['close', 'save'])

const observadorSelect = ref<any>(null)

const getInitialForm = () => ({
  observadorId: '',
  tipoNovedadId: '',
  fechaInicio: '',
  fechaFin: '',
  motivo: '',
  permiteUrgencia: false
})

const form = ref(getInitialForm())
const fieldErrors = ref<Record<string, string>>({})
const error = ref('')
const loading = ref(false)
const isEdit = computed(() => !!props.editData)

const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const eliminarArchivoViejo = ref(false)

const restaurarArchivoViejo = () => {
  eliminarArchivoViejo.value = false
  selectedFile.value = null
  if (fileInput.value) fileInput.value.value = ''
}

const tiposNovedad = ref<TipoNovedad[]>([])

const isViajeNovedad = computed(() => {
  const tipo = tiposNovedad.value.find(t => t.id === form.value.tipoNovedadId)
  return tipo && ['VIAJE_INICIO', 'VIAJE_FIN'].includes(tipo.codigo)
})

const observadores = ref<any[]>([])
const loadingCatalogs = ref(true)

const selectedObservador = computed(() => {
  return observadores.value.find(o => o.id === form.value.observadorId) || null
})

const filteredTiposNovedad = computed(() => {
  if (!selectedObservador.value) return []
  const contrato = selectedObservador.value.tipoContrato
  return tiposNovedad.value.filter(t => {
    if (!t.tiposContratoPermitidos || t.tiposContratoPermitidos.length === 0) return true
    if (!contrato) return false
    return t.tiposContratoPermitidos.includes(contrato)
  })
})

const observadorOptions = computed(() => {
  return observadores.value.map(o => ({
    value: o.id,
    label: `${o.apellido}, ${o.nombre} (${o.codigoInterno || ''})${!o.disponible ? ' [No Disponible]' : ''}`
  }))
})

const hasPreview = computed(() => {
  if (!props.editData) return false
  const hasMetadataBody = props.editData.metadata && props.editData.metadata.body
  const hasArchivos = props.editData.archivos && props.editData.archivos.length > 0
  return hasMetadataBody || hasArchivos
})

onMounted(async () => {
  try {
    const [obsRes, tiposRes] = await Promise.all([
      catalogosService.getObservadores(),
      tiposNovedadApi.getActivos()
    ])
    observadores.value = obsRes
    tiposNovedad.value = tiposRes
  } catch (err) {
    console.error('Error cargando catálogos', err)
  } finally {
    loadingCatalogs.value = false
  }
})

watch(() => props.show, (newVal) => {
  if (newVal) {
    error.value = ''
    fieldErrors.value = {}
    if (props.editData) {
      form.value = {
        observadorId: props.editData.observadorId,
        tipoNovedadId: props.editData.tipoNovedadId,
        fechaInicio: props.editData.fechaInicio ? String(props.editData.fechaInicio) : '',
        fechaFin: props.editData.fechaFin ? String(props.editData.fechaFin) : '',
        motivo: props.editData.motivo || '',
        permiteUrgencia: props.editData.permiteUrgencia || false
      }
    } else {
      form.value = getInitialForm()
    }
    
    selectedFile.value = null
    eliminarArchivoViejo.value = false
    if (fileInput.value) fileInput.value.value = ''

    nextTick(() => {
      observadorSelect.value?.focus()
    })
  }
})

// Auto-clear errors
watch(() => form.value.observadorId, (val) => { 
  if (val) {
    delete fieldErrors.value.observadorId
    // Si el tipo de novedad actual ya no es válido para este observador, resetearlo
    if (form.value.tipoNovedadId) {
      const isValid = filteredTiposNovedad.value.some(t => t.id === form.value.tipoNovedadId)
      if (!isValid) form.value.tipoNovedadId = ''
    }
  } 
})
watch(() => form.value.tipoNovedadId, (val) => { 
  if (val) delete fieldErrors.value.tipoNovedadId 
})
watch(() => form.value.fechaInicio, (val) => { if (val) delete fieldErrors.value.fechaInicio })

const close = () => {
  emit('close')
}

const validate = () => {
  fieldErrors.value = {}
  if (!form.value.observadorId) fieldErrors.value.observadorId = 'El observador es requerido'
  if (!form.value.tipoNovedadId) fieldErrors.value.tipoNovedadId = 'Seleccione un tipo de novedad'
  if (!form.value.fechaInicio) fieldErrors.value.fechaInicio = 'La fecha de inicio es requerida'
  
  if (form.value.fechaInicio && form.value.fechaFin) {
    if (new Date(form.value.fechaInicio) > new Date(form.value.fechaFin)) {
      fieldErrors.value.fechaFin = 'La fecha de fin no puede ser anterior a la de inicio'
    }
  }

  return Object.keys(fieldErrors.value).length === 0
}

const submit = async () => {
  if (!validate()) return

  loading.value = true
  try {
    const payload: any = {
      ...form.value,
      fechaFin: form.value.fechaFin || null
    }

    if (eliminarArchivoViejo.value) {
      payload.eliminarArchivoViejo = true
    }

    if (selectedFile.value) {
      const fileInfo = await novedadesService.uploadFile(selectedFile.value)
      payload.archivo = {
        nombreOriginal: fileInfo.originalName,
        rutaArchivo: fileInfo.secureUrl,
        tipoArchivo: fileInfo.mimetype,
        driveFileId: fileInfo.driveFileId
      }
    }
    
    emit('save', payload)
  } catch (err: any) {
    error.value = err.response?.data?.message || 'Error al procesar el archivo o guardar la novedad'
    console.error(err)
  } finally {
    loading.value = false
  }
}
</script>
