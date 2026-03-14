<script setup lang="ts">
import { computed } from 'vue';

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
  label: 'EXCEL',
  title: 'Exportar a Excel',
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
    class="flex items-center gap-1.5 p-1.5 rounded-lg transition-all active:scale-95 group/export disabled:opacity-50 disabled:grayscale disabled:cursor-not-allowed hover:bg-success/10 text-success"
    :title="title"
    :disabled="loading || disabled"
  >
    <!-- Loading State -->
    <svg v-if="loading" class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>

    <!-- Excel Icon -->
    <svg v-else xmlns="http://www.w3.org/2000/svg" 
      class="w-4 h-4 transition-transform group-hover/export:scale-110" 
      viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
    >
      <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
      <polyline points="7 10 12 15 17 10" />
      <line x1="12" y1="15" x2="12" y2="3" />
    </svg>

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
