<template>
  <BaseModal :show="show" @close="close" :title="isEdit ? 'Editar Novedad' : 'Nueva Novedad'" maxWidth="2xl">
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
            v-model="form.estadoDisponibilidad"
            class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs"
            :class="fieldErrors.estadoDisponibilidad ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'"
          >
            <option value="" disabled>Seleccione un tipo...</option>
            <option value="LICEN">Licencia / Vacaciones</option>
            <option value="FC">Franco Compensatorio</option>
            <option value="RP">Razones Particulares</option>
            <option value="ENFERMEDAD">Enfermedad</option>
            <option value="MATERNIDAD">Maternidad</option>
            <option value="NACIMIENTO">Nacimiento</option>
            <option value="FALLECIMIENTO">Fallecimiento</option>
            <option value="EXAMEN">Examen</option>
            <option value="DONACION_SANGRE">Donación de Sangre</option>
            <option value="VIAJE_INICIO">Aviso de Viaje (Inicio)</option>
            <option value="VIAJE_FIN">Aviso de Viaje (Fin)</option>
          </select>
          <p v-if="fieldErrors.estadoDisponibilidad" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.estadoDisponibilidad }}</p>
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
          <div class="space-y-1.5" :class="{'opacity-50 pointer-events-none': isViajeNovedad}">
            <label class="block text-sm font-medium text-text-muted">Fecha de Fin (Opcional)</label>
            <DatePicker 
              v-model="form.fechaFin" 
              :icon="CalenderIcon" 
              :show-time="false"
              :error="fieldErrors.fechaFin" 
              :disabled="isViajeNovedad"
            />
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
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import catalogosService from '@/modules/mareas/services/catalogos.service'
import {
  UserGroupIcon,
  CalenderIcon
} from '@/icons'
import type { Novedad } from '../interfaces/novedad.interface'

const props = defineProps<{
  show: boolean
  editData?: Novedad | null
}>()

const emit = defineEmits(['close', 'save'])

const observadorSelect = ref<any>(null)

const getInitialForm = () => ({
  observadorId: '',
  estadoDisponibilidad: '',
  fechaInicio: '',
  fechaFin: '',
  motivo: ''
})

const form = ref(getInitialForm())
const fieldErrors = ref<Record<string, string>>({})
const error = ref('')
const loading = ref(false)
const isEdit = computed(() => !!props.editData)
const isViajeNovedad = computed(() => ['VIAJE_INICIO', 'VIAJE_FIN'].includes(form.value.estadoDisponibilidad))

const observadores = ref<any[]>([])
const loadingCatalogs = ref(true)

const observadorOptions = computed(() => {
  return observadores.value.map(o => ({
    value: o.id,
    label: `${o.apellido}, ${o.nombre} (${o.codigoInterno || ''})`
  }))
})

onMounted(async () => {
  try {
    observadores.value = await catalogosService.getObservadores(true)
  } catch (err) {
    console.error('Error cargando observadores', err)
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
        estadoDisponibilidad: props.editData.estadoDisponibilidad,
        fechaInicio: props.editData.fechaInicio ? new Date(props.editData.fechaInicio).toISOString().split('T')[0] : '',
        fechaFin: props.editData.fechaFin ? new Date(props.editData.fechaFin).toISOString().split('T')[0] : '',
        motivo: props.editData.motivo || ''
      }
    } else {
      form.value = getInitialForm()
    }
    
    nextTick(() => {
      observadorSelect.value?.focus()
    })
  }
})

// Auto-clear errors
watch(() => form.value.observadorId, (val) => { if (val) delete fieldErrors.value.observadorId })
watch(() => form.value.estadoDisponibilidad, (val) => { 
  if (val) delete fieldErrors.value.estadoDisponibilidad 
  if (['VIAJE_INICIO', 'VIAJE_FIN'].includes(val)) {
    form.value.fechaFin = ''
    delete fieldErrors.value.fechaFin
  }
})
watch(() => form.value.fechaInicio, (val) => { if (val) delete fieldErrors.value.fechaInicio })

const close = () => {
  emit('close')
}

const validate = () => {
  fieldErrors.value = {}
  if (!form.value.observadorId) fieldErrors.value.observadorId = 'El observador es requerido'
  if (!form.value.estadoDisponibilidad) fieldErrors.value.estadoDisponibilidad = 'Seleccione un tipo de novedad'
  if (!form.value.fechaInicio) fieldErrors.value.fechaInicio = 'La fecha de inicio es requerida'
  
  if (form.value.fechaInicio && form.value.fechaFin) {
    if (new Date(form.value.fechaInicio) > new Date(form.value.fechaFin)) {
      fieldErrors.value.fechaFin = 'La fecha de fin no puede ser anterior a la de inicio'
    }
  }

  return Object.keys(fieldErrors.value).length === 0
}

const submit = () => {
  if (!validate()) return

  loading.value = true
  const payload = {
    ...form.value,
    fechaFin: form.value.fechaFin || null
  }
  
  emit('save', payload)
  loading.value = false
}
</script>
