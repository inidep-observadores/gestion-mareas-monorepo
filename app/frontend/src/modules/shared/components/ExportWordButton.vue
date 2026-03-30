<script setup lang="ts">
import { computed } from 'vue';
import { FileTextIcon } from 'lucide-vue-next';

interface Props {
  loading?: boolean;
  label?: string;
  title?: string;
  disabled?: boolean;
  compact?: boolean;
  expandable?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  label: 'WORD',
  title: 'Generar Informe en Word (.docx)',
  disabled: false,
  compact: false,
  expandable: true
});

const emit = defineEmits<{
  (e: 'click'): void;
}>();

const handleClick = () => {
  if (!props.loading && !props.disabled) {
    emit('click');
  }
};
</script>

<template>
  <button 
    @click="handleClick"
    type="button"
    class="flex items-center gap-1.5 p-1.5 rounded-lg transition-all active:scale-95 group/export disabled:opacity-50 disabled:grayscale disabled:cursor-not-allowed hover:bg-blue-500/10 text-blue-600 dark:text-blue-400 dark:hover:bg-blue-400/10"
    :title="title"
    :disabled="loading || disabled"
  >
    <!-- Loading State -->
    <svg v-if="loading" class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>

    <!-- Word Icon (FileText) -->
    <FileTextIcon v-else 
      class="w-4 h-4 transition-transform group-hover/export:scale-110" 
      stroke-width="2.5"
    />

    <!-- Label -->
    <span v-if="!compact && label" 
      class="text-[9px] font-black uppercase tracking-widest animate-fadeIn"
      :class="expandable ? 'hidden group-hover/export:inline-block' : 'inline-block'"
    >
      {{ label }}
    </span>
  </button>
</template>

<style scoped>
@keyframes fadeIn {
  from { opacity: 0; transform: translateX(-4px); }
  to { opacity: 1; transform: translateX(0); }
}

.animate-fadeIn {
  animation: fadeIn 0.2s ease-out forwards;
}
</style>
