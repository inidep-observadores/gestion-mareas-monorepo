<template>
  <div class="flex flex-col h-full bg-surface text-text">
    <!-- Header Fijo -->
    <div class="px-6 py-4 border-b border-border bg-surface flex items-center justify-between shrink-0">
      <div class="flex items-center gap-3">
        <img v-if="observador?.fotoUrl" :src="getFullImageUrl(observador.fotoUrl)" class="w-10 h-10 rounded-full object-cover border border-border" alt="Foto">
        <div v-else class="w-10 h-10 rounded-full bg-surface-muted flex items-center justify-center border border-border">
          <span class="text-text-muted font-bold">{{ observador?.nombre?.charAt(0) }}{{ observador?.apellido?.charAt(0) }}</span>
        </div>
        <div>
          <h2 class="text-base font-extrabold text-text leading-tight">
            {{ observador?.apellido }}, {{ observador?.nombre }}
          </h2>
          <div class="text-[11px] text-text-muted font-medium mt-0.5 uppercase tracking-wider">
            ID: {{ observador?.codigoInterno }}
          </div>
        </div>
      </div>
      <button @click="$emit('close')" class="p-2 text-text-muted hover:text-text hover:bg-surface-muted rounded-full transition-colors focus:outline-none">
        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>

    <!-- TABS -->
    <div class="flex border-b border-border shrink-0 bg-surface">
      <button 
        v-for="tab in ['historial', 'calendario']" 
        :key="tab"
        @click="activeTab = tab"
        class="flex-1 py-3 text-xs font-bold uppercase tracking-wider transition-colors relative"
        :class="activeTab === tab ? 'text-primary' : 'text-text-muted hover:text-text'"
      >
        {{ tab === 'historial' ? 'Historial' : 'Calendario' }}
        <div v-if="activeTab === tab" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></div>
      </button>
    </div>

    <!-- Content (Scrollable) -->
    <div class="flex-1 overflow-y-auto p-6 relative bg-surface-muted/30">
      <div v-show="activeTab === 'historial'">
        <div class="text-center text-text-muted py-10">
          <div class="font-bold text-sm mb-2">Historial de Novedades y Mareas</div>
          <div class="text-xs">Mockup: Aquí irán los componentes de historial</div>
        </div>
      </div>
      <div v-show="activeTab === 'calendario'">
        <div class="text-center text-text-muted py-10">
          <div class="font-bold text-sm mb-2">Vista de Calendario</div>
          <div class="text-xs">Mockup: Aquí irá el componente del calendario</div>
        </div>
      </div>
    </div>
    
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { getFullImageUrl } from '@/helpers/image.helper';
import type { Observador } from '../interfaces/observador.interface';

const props = defineProps<{
  observador: Observador;
}>();

defineEmits<{
  (e: 'close'): void;
}>();

const activeTab = ref('historial');

</script>
