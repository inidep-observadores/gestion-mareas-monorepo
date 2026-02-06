<template>
  <div v-if="data" class="mt-4 space-y-4 animate-in fade-in slide-in-from-top-2 duration-300">
    <!-- Totales -->
    <div class="flex items-center justify-between p-4 bg-primary/5 border border-primary/20 rounded-2xl">
      <div class="flex items-center gap-3">
        <div class="p-2 bg-primary/10 rounded-xl text-primary">
          <MapPinIcon class="w-5 h-5" />
        </div>
        <div>
          <h4 class="text-xs font-bold uppercase tracking-wider text-primary/80">Recuento Consolidado</h4>
          <p class="text-lg font-black text-primary">{{ data.totalDiasMarea }} Días Detectados</p>
        </div>
      </div>
      <button @click="showDates = !showDates"
        class="text-xs font-bold text-primary hover:underline px-3 py-1 bg-primary/10 rounded-lg transition-colors">
        {{ showDates ? 'Ocultar fechas' : 'Ver fechas' }}
      </button>
    </div>

    <!-- Lista de fechas consolidadas -->
    <div v-if="showDates"
      class="flex flex-wrap gap-2 p-3 bg-surface border border-border rounded-xl max-h-40 overflow-y-auto custom-scrollbar">
      <span v-for="date in data.diasDetectadosMarea" :key="date"
        class="px-2 py-1 bg-surface-muted text-[10px] font-bold text-text-muted rounded-md border border-border">
        {{ formatDate(date) }}
      </span>
      <p v-if="data.diasDetectadosMarea.length === 0" class="text-xs text-text-muted italic">No hay fechas detectadas.
      </p>
    </div>

    <!-- Desglose por Etapas -->
    <div v-if="data.etapas && data.etapas.length > 1" class="space-y-3">
      <h5 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted/60 px-1">Desglose por Etapa de
        Navegación</h5>
      <div v-for="etapa in data.etapas" :key="etapa.etapaId"
        class="p-4 bg-surface border border-border rounded-2xl hover:border-primary/30 transition-colors group">
        <div class="flex items-center justify-between mb-2">
          <div class="flex items-center gap-2">
            <span
              class="w-6 h-6 flex items-center justify-center bg-surface-muted rounded-lg text-xs font-bold text-text-muted border border-border">
              {{ etapa.nroEtapa }}
            </span>
            <span class="text-sm font-bold text-text">Etapa {{ etapa.nroEtapa }}</span>
          </div>
          <div
            class="flex items-center gap-1.5 px-2 py-0.5 bg-success/10 text-success rounded-full border border-success/20">
            <CheckIcon class="w-3 h-3" />
            <span class="text-[10px] font-black uppercase tracking-tighter">{{ etapa.totalDias }} Días</span>
          </div>
        </div>

        <div v-if="etapa.diasDetectados.length > 0" class="flex flex-wrap gap-1.5 mt-3">
          <span v-for="d in etapa.diasDetectados" :key="d"
            class="px-1.5 py-0.5 bg-primary/5 text-[9px] font-semibold text-primary/70 rounded border border-primary/10">
            {{ formatDate(d) }}
          </span>
        </div>
        <p v-else class="text-[10px] text-text-muted/50 italic mt-2">Sin actividad detectada en Zona Austral para esta
          etapa.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { ZonaAustralResponse } from '../types/marea.types';
import { MapPinIcon, CheckIcon } from '@/icons';

defineProps<{
  data: ZonaAustralResponse | null;
}>();

const showDates = ref(false);

const formatDate = (dateStr: string) => {
  const [year, month, day] = dateStr.split('-');
  return `${day}/${month}/${year}`;
};
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 10px;
}
</style>
