<template>
  <BaseModal
    :show="show"
    title="Confirmar Protocolización"
    @close="handleClose"
    max-width="md"
  >
    <div class="space-y-6">
      
      <div class="bg-surface-muted/50 border border-border rounded-2xl p-4">
        <p class="text-[10px] font-black uppercase tracking-widest text-text-muted mb-0.5">Marea a Protocolizar</p>
        <h4 class="text-sm font-black text-text leading-tight">
          Nro: {{ marea?.nro_marea }}/{{ marea?.anio_marea }} <span class="mx-1 text-text-muted/40 font-normal">|</span> {{ marea?.buque_nombre }}
        </h4>
      </div>

      <div class="space-y-4">
         <!-- Numero -->
         <div class="space-y-1.5">
           <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
              <span>Número de Protocolización</span>
              <span class="text-error text-[8px] italic">*</span>
           </label>
           <input 
             type="number" 
             v-model.number="form.nroProtocolizacion"
             class="w-full bg-surface border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none"
             placeholder="Ej. 12345"
             :class="{ 'border-error ring-1 ring-error/30': validationErrors.nroProtocolizacion }"
           />
           <span v-if="validationErrors.nroProtocolizacion" class="text-[10px] text-error font-bold">{{ validationErrors.nroProtocolizacion }}</span>
         </div>
         
         <div class="grid grid-cols-2 gap-4">
            <!-- Año -->
            <div class="space-y-1.5">
              <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
                  <span>Año</span>
                  <span class="text-error text-[8px] italic">*</span>
              </label>
              <input 
                type="number" 
                v-model="form.anioProtocolizacion"
                class="w-full bg-surface border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none"
                placeholder="2026"
                :class="{ 'border-error ring-1 ring-error/30': validationErrors.anioProtocolizacion }"
              />
              <span v-if="validationErrors.anioProtocolizacion" class="text-[10px] text-error font-bold">{{ validationErrors.anioProtocolizacion }}</span>
            </div>

            <!-- Fecha -->
            <div class="space-y-1.5">
              <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
                  <span>Fecha de Protocolización</span>
                  <span class="text-error text-[8px] italic">*</span>
              </label>
              <input 
                type="date" 
                v-model="form.fechaProtocolizacion"
                class="w-full bg-surface border border-border rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none"
                :class="{ 'border-error ring-1 ring-error/30': validationErrors.fechaProtocolizacion }"
              />
              <span v-if="validationErrors.fechaProtocolizacion" class="text-[10px] text-error font-bold">{{ validationErrors.fechaProtocolizacion }}</span>
            </div>
         </div>
      </div>

      <!-- Footer Buttons -->
      <div class="flex flex-col sm:flex-row gap-3 pt-4 border-t border-border/50">
        <button
          @click="handleClose"
          class="flex-1 px-6 py-3 bg-surface border border-border hover:bg-surface-muted text-text-muted hover:text-text rounded-xl text-xs font-black uppercase tracking-widest transition-all"
        >
          Cancelar
        </button>
        <button
          @click="submitForm"
          :disabled="loading"
          class="flex-1 px-6 py-3 bg-primary text-primary-fg rounded-xl text-xs font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2"
        >
          <div v-if="loading" class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
          <span v-else>Confirmar</span>
        </button>
      </div>

    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, reactive } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import mareasService from '../../services/mareas.service'
import { toast } from 'vue-sonner'

const props = defineProps<{
  show: boolean
  marea: any
}>()

const emit = defineEmits(['close', 'confirmed'])

const loading = ref(false)

const form = reactive({
  nroProtocolizacion: null as number | null,
  anioProtocolizacion: new Date().getFullYear(),
  fechaProtocolizacion: new Date().toISOString().substring(0, 10)
})

const validationErrors = reactive<Record<string, string>>({})

watch(() => props.show, (newVal) => {
  if (newVal) {
    form.nroProtocolizacion = ''
    form.anioProtocolizacion = new Date().getFullYear()
    form.fechaProtocolizacion = new Date().toISOString().substring(0, 10)
    Object.keys(validationErrors).forEach(key => delete validationErrors[key])
  }
})

const validate = () => {
    let isValid = true
    Object.keys(validationErrors).forEach(key => delete validationErrors[key])

    if (!form.nroProtocolizacion) {
        validationErrors.nroProtocolizacion = 'El número es requerido'
        isValid = false
    }
    
    if (!form.anioProtocolizacion || form.anioProtocolizacion < 2000) {
        validationErrors.anioProtocolizacion = 'Año inválido'
        isValid = false
    }

    if (!form.fechaProtocolizacion) {
        validationErrors.fechaProtocolizacion = 'La fecha es requerida'
        isValid = false
    }

    return isValid
}

const submitForm = async () => {
  if (!validate()) return

  try {
    loading.value = true
    
    await mareasService.confirmarProtocolizacion(props.marea.id, {
        nroProtocolizacion: Number(form.nroProtocolizacion),
        anioProtocolizacion: form.anioProtocolizacion,
        fechaProtocolizacion: new Date(`${form.fechaProtocolizacion}T12:00:00Z`).toISOString()
    })

    toast.success('Protocolización confirmada exitosamente')
    emit('confirmed')

  } catch (error: any) {
    console.error('Error al confirmar protocolizacion:', error)
    toast.error(error.response?.data?.message || 'Error al confirmar la protocolización')
  } finally {
    loading.value = false
  }
}

const handleClose = () => {
    if (!loading.value) {
        emit('close')
    }
}
</script>
