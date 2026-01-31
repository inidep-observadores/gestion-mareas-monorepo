<template>
  <BaseModal
    :show="show"
    title="Cancelar Marea"
    variant="danger"
    @close="$emit('close')"
    max-width="md"
  >
    <div class="space-y-6">
      <div class="bg-error/10 border border-error/20 p-4 rounded-xl flex items-start gap-3">
        <div class="p-2 bg-error/20 rounded-lg text-error shrink-0">
          <WarningIcon class="w-5 h-5" />
        </div>
        <div>
          <h4 class="text-sm font-bold text-error">Atención: Acción Irreversible</h4>
          <p class="text-xs text-error/80 mt-1 leading-relaxed">
            Está a punto de cancelar la marea <strong>{{ marea?.id_marea }}</strong>. Esta acción desestimará la operación y no se podrá volver atrás.
          </p>
        </div>
      </div>

      <div class="space-y-3">
        <label class="text-[10px] font-black uppercase tracking-widest text-text-muted">
          Motivo de la Cancelación <span class="text-error">*</span>
        </label>
        <textarea
          v-model="comentarios"
          rows="4"
          placeholder="Describa brevemente el motivo por el cual se cancela la marea..."
          class="w-full bg-surface border border-border rounded-xl p-4 text-sm focus:ring-2 focus:ring-error/20 focus:border-error transition-all resize-none outline-none"
          :class="{ 'border-error': error }"
        ></textarea>
        <p v-if="error" class="text-[10px] font-bold text-error uppercase tracking-tight">
          El motivo es obligatorio para proceder con la cancelación.
        </p>
      </div>

      <div class="flex flex-col sm:flex-row gap-3 pt-2">
        <button
          @click="$emit('close')"
          class="flex-1 px-6 py-3 bg-surface border border-border hover:bg-surface-muted text-text-muted hover:text-text rounded-xl text-xs font-black uppercase tracking-widest transition-all"
        >
          Volver
        </button>
        <button
          @click="handleConfirm"
          :disabled="loading"
          class="flex-1 px-6 py-3 bg-error text-error-fg rounded-xl text-xs font-black uppercase tracking-widest shadow-lg shadow-error/20 hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2"
        >
          <LoadingSpinner v-if="loading" size="xs" />
          <span v-else>Confirmar Cancelación</span>
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { WarningIcon } from '@/icons'

const props = defineProps<{
  show: boolean
  marea: any
  loading?: boolean
}>()

const emit = defineEmits(['close', 'confirm'])

const comentarios = ref('')
const error = ref(false)

watch(() => props.show, (newVal) => {
  if (newVal) {
    comentarios.value = ''
    error.value = false
  }
})

const handleConfirm = () => {
  if (!comentarios.value.trim()) {
    error.value = true
    return
  }
  
  emit('confirm', {
    comentarios: comentarios.value.trim()
  })
}
</script>
