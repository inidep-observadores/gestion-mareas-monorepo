<template>
  <BaseModal
    :show="show"
    :title="actionData?.label || 'Confirmar Acción'"
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

      <!-- Transición de Estado -->
      <div class="flex items-center gap-4 py-2">
        <div class="flex-1 text-center">
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-2">Estado Origen</p>
            <div class="p-3 bg-surface-muted rounded-xl border border-border text-xs font-bold text-text-muted">
                {{ marea?.estado }}
            </div>
        </div>
        <div class="shrink-0 pt-6">
            <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
            </div>
        </div>
        <div class="flex-1 text-center">
            <p class="text-[9px] font-bold text-primary uppercase tracking-widest mb-2">Nuevo Estado</p>
            <div class="p-3 bg-primary/5 border border-primary/20 rounded-xl text-xs font-black text-primary">
                {{ actionData?.toStateName || 'Siguiente Paso' }}
            </div>
        </div>
      </div>

      <!-- Notas / Observaciones -->
      <div v-if="requiresNotes" class="space-y-3">
        <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
          <span>Notas / Observaciones</span>
          <span class="text-error text-[8px] italic">* Obligatorio</span>
        </label>
        <textarea
          v-model="comentarios"
          rows="4"
          placeholder="Es obligatorio ingresar un motivo o nota para esta acción..."
          class="w-full bg-surface border border-border rounded-xl p-4 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all resize-none outline-none"
          :class="{ 'border-error ring-1 ring-error/10': showError }"
        ></textarea>
        <p v-if="showError" class="text-[10px] font-bold text-error uppercase tracking-tight flex items-center gap-1">
          <WarningIcon class="w-3 h-3" />
          Debe completar las notas para confirmar esta acción.
        </p>
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
          :disabled="loading"
          class="flex-1 px-6 py-3 bg-primary text-primary-fg rounded-xl text-xs font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 active:scale-95 transition-all flex items-center justify-center gap-2"
        >
          <LoadingSpinner v-if="loading" size="xs" />
          <span v-else>Confirmar Acción</span>
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { ShipIcon, WarningIcon } from '@/icons'

const props = defineProps<{
  show: boolean
  marea: any
  actionKey: string | null
  actionData: any
  loading?: boolean
}>()

const emit = defineEmits(['close', 'confirm'])

const comentarios = ref('')
const showError = ref(false)

const requiresNotes = computed(() => props.actionData?.requiresNotes || false)

watch(() => props.show, (newVal) => {
  if (newVal) {
    comentarios.value = ''
    showError.value = false
  }
})

const handleClose = () => {
    if (props.loading) return
    emit('close')
}

const handleConfirm = () => {
  if (requiresNotes.value && !comentarios.value.trim()) {
    showError.value = true
    return
  }
  
  emit('confirm', {
    comentarios: comentarios.value.trim()
  })
}
</script>
