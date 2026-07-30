<template>
  <div v-if="archivos && archivos.length > 0" class="flex flex-col">
    <!-- Header with Toggle -->
    <div class="flex items-center justify-between mb-2">
      <p class="text-[10px] font-black text-text-muted uppercase">{{ title || 'Archivos Generados/Adjuntos:' }}</p>
      
      <!-- Toggle View Mode Button -->
      <button 
        v-if="!hideToggle"
        type="button"
        @click="toggleViewMode"
        class="flex items-center gap-1.5 px-2 py-1 bg-surface border border-border rounded hover:border-primary transition-colors text-[10px] font-bold text-text-muted hover:text-primary group"
        :title="viewMode === 'inline' ? 'Cambiar a vista de lista' : 'Cambiar a vista de previsualización'"
      >
        <span v-if="viewMode === 'inline'" class="flex items-center gap-1">
          <ListIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
          Ver como Lista
        </span>
        <span v-else class="flex items-center gap-1">
          <EyeIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
          Ver Previsualización
        </span>
      </button>
    </div>

    <!-- Inline Preview Mode -->
    <div v-if="viewMode === 'inline'" class="flex flex-col gap-3">
      <div v-for="arch in archivos" :key="arch.id" class="flex flex-col flex-1 min-h-[300px] border border-border rounded-lg overflow-hidden bg-surface-muted relative shadow-inner group">
        <!-- Top bar over iframe for actions -->
        <div class="absolute top-0 inset-x-0 bg-surface-muted/90 backdrop-blur border-b border-border p-2 flex justify-between items-center z-10 opacity-0 group-hover:opacity-100 transition-opacity">
          <span class="text-xs font-bold text-text truncate px-2">{{ arch.nombreOriginal }}</span>
          <a :href="arch.rutaArchivo" target="_blank" class="text-[10px] font-bold text-primary hover:underline flex items-center gap-1 bg-primary/10 px-2 py-0.5 rounded-full transition-colors hover:bg-primary/20 shrink-0">
            Abrir externo <ExternalLinkIcon class="w-3 h-3" />
          </a>
        </div>
        
        <iframe 
          :src="getPreviewUrl(arch.rutaArchivo)" 
          class="w-full h-[400px] border-none"
          title="Previsualización de documento"
          allow="autoplay"
        ></iframe>
      </div>
    </div>

    <!-- List (Link) Mode -->
    <div v-else class="space-y-2">
      <a 
        v-for="arch in archivos" 
        :key="arch.id" 
        :href="arch.rutaArchivo" 
        target="_blank"
        class="flex items-center gap-2 p-2 bg-surface border border-border rounded hover:border-primary transition-colors group mt-1"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-primary shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
        </svg>
        <span class="text-xs truncate text-primary hover:underline group-hover:underline" :title="arch.nombreOriginal">{{ arch.nombreOriginal }}</span>
      </a>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ArrowRightIcon as ExternalLinkIcon } from '@/icons';
import EyeIcon from '@/icons/EyeIcon.vue';
import ListIcon from '@/icons/ListIcon.vue';

interface Archivo {
  id: string | number;
  rutaArchivo: string;
  nombreOriginal: string;
}

const props = defineProps<{
  archivos?: Archivo[];
  title?: string;
  hideToggle?: boolean;
}>();

import { useAttachmentViewMode } from '@/composables/useAttachmentViewMode';

const { viewMode, toggleViewMode } = useAttachmentViewMode();

const getPreviewUrl = (url: string) => {
  if (!url) return '';
  // Convertimos el link 'view' de Google Drive a 'preview' para iframes
  return url.replace(/\/view\?usp=.*/, '/preview');
};
</script>
