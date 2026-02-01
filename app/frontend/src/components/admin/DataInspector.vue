<template>
  <div class="animate-in fade-in slide-in-from-bottom-4 duration-500">
    <div class="flex justify-between items-center mb-5">
      <h4 class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
        <BoxIcon class="w-4 h-4 text-primary" /> {{ title }}
      </h4>
      <button
        v-if="data"
        @click="copyToClipboard"
        class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-surface-muted text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-primary hover:text-primary-fg transition-all shadow-xs"
      >
        <DocsIcon class="w-3.5 h-3.5" /> Copiar JSON
      </button>
    </div>
    
    <div 
      class="bg-surface-muted rounded-3xl border border-border shadow-sm overflow-hidden transition-all duration-500"
      :class="{ 
        'border-success/30 bg-success/5': variant === 'success',
        'border-warning/30 bg-warning/5': variant === 'warning'
      }"
    >
      <div class="flex items-center gap-2 px-6 py-3 bg-surface/50 border-b border-border">
        <div 
          class="w-2 h-2 rounded-full"
          :class="{
            'bg-success': variant === 'success',
            'bg-warning': variant === 'warning',
            'bg-primary': !variant
          }"
        ></div>
        <span class="text-[10px] text-text-muted font-bold uppercase tracking-widest font-mono">inspector_data.json</span>
      </div>
      
      <div v-if="data && Object.keys(data).length > 0" class="p-6 md:p-8 overflow-x-auto custom-scrollbar max-h-[400px]">
        <code class="text-[11px] font-mono leading-relaxed text-text whitespace-pre">{{ formattedData }}</code>
      </div>
      <div v-else class="p-8 text-center bg-surface/30">
        <p class="text-[10px] font-black text-text-muted uppercase tracking-widest italic">N/A - Datos no disponibles</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { BoxIcon, DocsIcon } from '@/icons';
import { toast } from 'vue-sonner';

const props = defineProps<{
  title: string;
  data: any;
  variant?: 'success' | 'warning';
}>();

const formattedData = computed(() => {
  if (!props.data) return '';
  return JSON.stringify(props.data, null, 2);
});

const copyToClipboard = () => {
  navigator.clipboard.writeText(formattedData.value);
  toast.success('JSON copiado al portapapeles');
};
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(156, 163, 175, 0.2); border-radius: 10px; }
</style>
