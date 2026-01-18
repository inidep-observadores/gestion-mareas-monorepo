<template>
  <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6 bg-surface p-6 rounded-2xl border border-border shadow-theme-xs">
    <!-- Header/Icon Area -->
    <div class="flex items-center gap-4">
      <div class="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center text-primary">
        <component :is="icon" class="w-6 h-6" />
      </div>
      <div>
        <h2 class="text-base font-black text-text uppercase tracking-tight leading-none">{{ title }}</h2>
        <p class="text-[10px] font-black text-text-muted uppercase tracking-widest mt-1">{{ subtitle }}</p>
      </div>
    </div>

    <!-- Filtros -->
    <div class="flex flex-wrap items-center gap-3">
      
      <!-- Modo de Cálculo -->
      <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border" title="Calendario: Solo días dentro del año. Total: Mareas completas con actividad en el año.">
        <div class="flex gap-1 bg-surface rounded-lg p-1 border border-border/50">
          <button 
            @click="$emit('update:mode', 'CALENDAR')"
            :class="[
              'px-3 py-1 rounded text-[10px] font-black uppercase tracking-wider transition-all',
              mode === 'CALENDAR' ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text'
            ]"
          >
            Calendario
          </button>
          <button 
             @click="$emit('update:mode', 'TOTAL')"
             :class="[
              'px-3 py-1 rounded text-[10px] font-black uppercase tracking-wider transition-all',
              mode === 'TOTAL' ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text'
            ]"
          >
            Total Marea
          </button>
        </div>
      </div>

      <!-- Métrica Toggle -->
      <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border" title="Días Buque: Días únicos navegados por embarcación. Días Observador: Suma de días de cada observador a bordo.">
         <span class="text-[10px] font-black text-text-muted uppercase tracking-widest mr-1">Métrica:</span>
         <div class="flex gap-1 bg-surface rounded-lg p-1 border border-border/50">
          <button 
            @click="$emit('update:daysCalculationMode', 'SHIP')"
            :class="[
              'px-3 py-1 rounded text-[10px] font-black uppercase tracking-wider transition-all',
              daysCalculationMode === 'SHIP' ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text'
            ]"
          >
            Buque
          </button>
          <button 
             @click="$emit('update:daysCalculationMode', 'OBSERVER')"
             :class="[
              'px-3 py-1 rounded text-[10px] font-black uppercase tracking-wider transition-all',
              daysCalculationMode === 'OBSERVER' ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text'
            ]"
          >
            Observador
          </button>
        </div>
      </div>

      <!-- Protocolizadas Toggle -->
      <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border">
        <label class="flex items-center gap-2 cursor-pointer">
           <input 
             type="checkbox" 
             :checked="protocolizedOnly"
             @change="$emit('update:protocolizedOnly', ($event.target as HTMLInputElement).checked)"
             class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20"
           />
           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Protocolizadas</span>
        </label>
      </div>

      <!-- Out of Period (Conditional) -->
      <div v-if="protocolizedOnly" class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border animate-in fade-in zoom-in duration-300">
         <label class="flex items-center gap-2 cursor-pointer" title="Incluir mareas fuera del rango de actividad si se protocolizaron este año">
           <input 
             type="checkbox" 
             :checked="includeOutOfPeriod"
             @change="$emit('update:includeOutOfPeriod', ($event.target as HTMLInputElement).checked)"
              class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20"
           />
           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">+ Fuera Periodo</span>
         </label>
      </div>

      <!-- Campaigns Toggle -->
      <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border">
        <label class="flex items-center gap-2 cursor-pointer">
           <input 
             type="checkbox" 
             :checked="includeCampaigns"
             @change="$emit('update:includeCampaigns', ($event.target as HTMLInputElement).checked)"
             class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20"
           />
           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Incluir Campañas</span>
        </label>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  ActivityIcon
} from 'lucide-vue-next';
import type { Component } from 'vue';

interface Props {
  title: string;
  subtitle: string;
  mode: 'CALENDAR' | 'TOTAL';
  protocolizedOnly: boolean;
  includeOutOfPeriod: boolean;
  daysCalculationMode: 'SHIP' | 'OBSERVER';
  includeCampaigns: boolean;
  icon?: Component;
}

withDefaults(defineProps<Props>(), {
  icon: () => ActivityIcon,
  daysCalculationMode: 'SHIP',
  includeCampaigns: true
});

defineEmits<{
  (e: 'update:mode', value: 'CALENDAR' | 'TOTAL'): void;
  (e: 'update:protocolizedOnly', value: boolean): void;
  (e: 'update:includeOutOfPeriod', value: boolean): void;
  (e: 'update:daysCalculationMode', value: 'SHIP' | 'OBSERVER'): void;
  (e: 'update:includeCampaigns', value: boolean): void;
}>();
</script>
