<template>
  <BaseModal
    :show="show"
    title="Finalizar Protocolización"
    @close="handleClose"
    max-width="md"
  >
    <div class="space-y-6">
      <!-- Info Contextual -->
      <div class="bg-surface-muted/50 border border-border rounded-2xl p-4 space-y-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="p-2 bg-primary/10 rounded-xl text-primary shrink-0">
              <ShipIcon class="w-4 h-4" />
            </div>
            <div>
              <p class="text-[10px] font-black uppercase tracking-widest text-text-muted mb-0.5">Marea & Buque</p>
              <h4 class="text-sm font-black text-text leading-tight">
                {{ marea?.id_marea }} <span class="mx-1 text-text-muted/40 font-normal">|</span> {{ marea?.buque_nombre || marea?.buque?.nombre }}
              </h4>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 pt-2 border-t border-border/50">
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1">Observador</p>
            <p class="text-xs font-black text-text truncate">{{ marea?.observador || 'No asignado' }}</p>
          </div>
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1">Estado Actual</p>
            <span class="px-2 py-0.5 bg-surface rounded text-[9px] font-black uppercase tracking-tighter text-text border border-border">
              {{ marea?.estado }}
            </span>
          </div>
        </div>
      </div>

      <!-- Protocolization Fields -->
      <div class="space-y-4">
        <p class="text-[10px] font-black uppercase tracking-widest text-primary">Datos de Protocolización</p>
        
        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <label class="text-[10px] font-black uppercase tracking-widest text-text-muted">Número Protocolo</label>
            <input
              ref="nroInput"
              v-model.number="form.nroProtocolizacion"
              type="number"
              placeholder="Ej: 123"
              data-test="nro-protocolo"
              class="w-full bg-surface border border-border rounded-xl p-3 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none"
              :class="{ 'border-error': errors.nroProtocolizacion }"
            />
          </div>
          <div class="space-y-2">
            <label class="text-[10px] font-black uppercase tracking-widest text-text-muted">Año</label>
            <input
              v-model.number="form.anioProtocolizacion"
              type="number"
              placeholder="Ej: 2024"
              data-test="anio-protocolo"
              class="w-full bg-surface border border-border rounded-xl p-3 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none"
              :class="{ 'border-error': errors.anioProtocolizacion }"
            />
          </div>
        </div>

        <div class="space-y-2">
          <label class="text-[10px] font-black uppercase tracking-widest text-text-muted">Fecha Protocolización</label>
          <DatePicker
            v-model="form.fechaProtocolizacion"
            :show-time="false"
            data-test="fecha-protocolo"
            placeholder="Seleccionar fecha..."
            :error="errors.fechaProtocolizacion ? 'La fecha es obligatoria' : ''"
          />
        </div>
      </div>

      <!-- Notas / Observaciones -->
      <div class="space-y-3">
        <label class="text-[10px] font-black uppercase tracking-widest text-text-muted">Observaciones Adicionales</label>
        <textarea
          v-model="form.comentarios"
          rows="3"
          placeholder="Opcional. Se registrará en el historial de la marea..."
          class="w-full bg-surface border border-border rounded-xl p-4 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all resize-none outline-none"
        ></textarea>
      </div>

      <!-- Footer Buttons -->
      <div class="flex flex-col sm:flex-row gap-3 pt-2">
        <button
          @click="handleClose"
          class="flex-1 px-6 py-3 bg-surface border border-border hover:bg-surface-muted text-text-muted hover:text-text rounded-xl text-xs font-black uppercase tracking-widest transition-all"
        >
          Cancelar
        </button>
        <button
          @click="handleConfirm"
          :disabled="loading || !isFormComplete"
          data-test="confirm-btn"
          class="flex-1 px-6 py-3 bg-primary text-primary-fg rounded-xl text-xs font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed disabled:scale-100"
        >
          <LoadingSpinner v-if="loading" size="xs" />
          <span v-else>Finalizar Protocolización</span>
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, reactive, watch, computed, nextTick } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { ShipIcon } from '@/icons'
import { toast } from 'vue-sonner'

const props = defineProps<{
  show: boolean
  marea: any
  loading?: boolean
}>()

const emit = defineEmits(['close', 'confirm'])

const initialForm = () => ({
  nroProtocolizacion: null as number | null,
  anioProtocolizacion: new Date().getFullYear(),
  fechaProtocolizacion: null as string | null,
  comentarios: ''
})

const form = reactive(initialForm())
const nroInput = ref<HTMLInputElement | null>(null)

const errors = reactive({
  nroProtocolizacion: false,
  anioProtocolizacion: false,
  fechaProtocolizacion: false
})

const isFormComplete = computed(() => {
  return !!form.nroProtocolizacion && 
         !!form.anioProtocolizacion && 
         !!form.fechaProtocolizacion
})

watch(() => props.show, (newVal) => {
  if (newVal) {
    Object.assign(form, initialForm())
    resetErrors()
    nextTick(() => {
      nroInput.value?.focus()
    })
  }
})

const resetErrors = () => {
  errors.nroProtocolizacion = false
  errors.anioProtocolizacion = false
  errors.fechaProtocolizacion = false
}

const getMareaEndDate = () => {
  if (!props.marea) return null
  
  // 1. Intentar obtener la fecha de arribo de la última etapa
  const etapas = props.marea.etapas || []
  if (etapas.length > 0) {
    const lastStage = etapas[etapas.length - 1]
    if (lastStage.fechaArribo) return new Date(lastStage.fechaArribo)
  }
  
  // 2. Si no hay etapas o no tienen fecha de arribo, usar la fecha de fin del observador de la marea
  if (props.marea.fechaFinObservador) return new Date(props.marea.fechaFinObservador)
  if (props.marea.fecha_fin_observador) return new Date(props.marea.fecha_fin_observador)
  
  return null
}

const validate = () => {
  resetErrors()
  let isValid = true

  if (!form.nroProtocolizacion || form.nroProtocolizacion <= 0) {
    errors.nroProtocolizacion = true
    isValid = false
  }

  if (!form.anioProtocolizacion || form.anioProtocolizacion < 2000) {
    errors.anioProtocolizacion = true
    isValid = false
  }

  if (!form.fechaProtocolizacion) {
    errors.fechaProtocolizacion = true
    isValid = false
  } else {
    const protocolDate = new Date(form.fechaProtocolizacion)
    const mareaEndDate = getMareaEndDate()
    
    if (mareaEndDate && protocolDate < mareaEndDate) {
      errors.fechaProtocolizacion = true
      toast.error('La fecha de protocolización no puede ser anterior a la finalización de la marea')
      isValid = false
    }
  }

  return isValid
}

const handleClose = () => {
  if (props.loading) return
  emit('close')
}

const handleConfirm = () => {
  if (!validate()) return
  
  emit('confirm', {
    ...form,
    comentarios: form.comentarios.trim()
  })
}
</script>
