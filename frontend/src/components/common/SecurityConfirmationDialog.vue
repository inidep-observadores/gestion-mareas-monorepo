<template>
  <BaseModal 
    :show="show" 
    :title="title"
    variant="danger"
    @close="$emit('close')"
  >
    <div class="p-6">
      <div class="bg-error/5 dark:bg-error/10 p-4 rounded-xl border border-error/20 dark:border-error/50 mb-6">
          <div class="flex gap-3 text-error dark:text-error">
              <WarningIcon class="w-6 h-6 flex-shrink-0" />
              <div>
                  <h4 class="font-bold underline">¡ADVERTENCIA DE SEGURIDAD!</h4>
                  <div class="text-xs mt-1 leading-relaxed">
                      <slot name="warning">
                          Este proceso es **IRREVERSIBLE**. Al confirmar, la base de datos actual será modificada permanentemente.
                      </slot>
                  </div>
              </div>
          </div>
      </div>

      <div class="space-y-4">
          <p class="text-sm text-gray-600 dark:text-gray-400">
              Para proceder, escriba la siguiente frase exactamente como aparece:
          </p>
          <div class="p-4 bg-gray-50 dark:bg-gray-950/40 border border-gray-200 dark:border-gray-800 rounded-xl text-center font-black tracking-widest text-gray-800 dark:text-brand-400 select-none shadow-inner">
              {{ currentPhrase }}
          </div>
          
          <div>
              <input 
                  type="text" 
                  v-model="confirmationPhrase"
                  placeholder="Escriba la frase de confirmación aquí..."
                  class="w-full px-4 py-3 rounded-xl border-2 border-gray-100 dark:border-gray-900 bg-white dark:bg-gray-950/20 focus:border-error focus:ring-0 transition-all text-center font-bold text-gray-900 dark:text-white"
                  @paste.prevent
              />
              <p class="text-[10px] text-gray-500 mt-2 text-center italic">
                  Sin avisos visuales de corrección. Asegúrese de escribir cada letra correctamente.
              </p>
          </div>

          <div class="flex gap-4 pt-4">
              <button @click="$emit('close')" class="flex-1 h-12 rounded-xl border border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800 font-bold transition-all active:scale-95">
                  Cancelar
              </button>
              <button 
                  @click="handleConfirm" 
                  :disabled="loading || confirmationPhrase !== currentPhrase"
                  class="flex-[1.5] h-12 rounded-xl bg-gradient-to-r from-red-600 to-red-500 hover:from-red-700 hover:to-red-600 active:scale-95 disabled:opacity-50 text-white font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-red-500/25"
              >
                  <RefreshIcon v-if="loading" class="w-5 h-5 animate-spin" />
                  <HistoryIcon v-else class="w-5 h-5" />
                  {{ confirmButtonText }}
              </button>
          </div>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import BaseModal from '@/components/common/BaseModal.vue';
import { WarningIcon, RefreshIcon, HistoryIcon } from '@/icons';

const props = defineProps({
  show: Boolean,
  title: {
      type: String,
      default: 'Acción Crítica'
  },
  confirmButtonText: {
      type: String,
      default: 'CONFIRMAR AHORA'
  },
  loading: Boolean,
  phrases: {
      type: Array as () => string[],
      default: () => [
          'CONFIRMAR ACCION',
          'ESTOY SEGURO',
          'PROCEDER CON CAMBIOS'
      ]
  }
});

const emit = defineEmits(['close', 'confirm']);

const confirmationPhrase = ref('');
const currentPhrase = ref('');

watch(() => props.show, (newVal) => {
  if (newVal) {
      confirmationPhrase.value = '';
      const randomIndex = Math.floor(Math.random() * props.phrases.length);
      currentPhrase.value = props.phrases[randomIndex];
  }
});

const handleConfirm = () => {
  if (confirmationPhrase.value === currentPhrase.value) {
      emit('confirm', confirmationPhrase.value);
  }
};
</script>
