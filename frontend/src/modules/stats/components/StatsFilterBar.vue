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
      
      <!-- Año -->
      <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border">
        <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Año</span>
        <select 
          :value="year" 
          @input="$emit('update:year', parseInt(($event.target as HTMLSelectElement).value))"
          class="text-xs font-black bg-transparent border-none focus:ring-0 text-text cursor-pointer p-0 pr-6"
        >
          <option :value="2026">2026</option>
          <option :value="2025">2025</option>
          <option :value="2024">2024</option>
          <option :value="2023">2023</option>
        </select>
      </div>

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

      <!-- Protocolizadas Toggle -->
      <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border">
        <label class="flex items-center gap-2 cursor-pointer">
           <input 
             type="checkbox" 
             :checked="protocolizedOnly"
             @change="$emit('update:protocolizedOnly', ($event.target as HTMLInputElement).checked)"
             class="w-4 h-4 rounded border-border text-primary focus:ring-primary/20"
           />
           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Solo Protocolizadas</span>
        </label>
      </div>

      <!-- Out of Period (Conditional) -->
      <div v-if="protocolizedOnly" class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-xl border border-border animate-in fade-in zoom-in duration-300">
         <label class="flex items-center gap-2 cursor-pointer" title="Incluir mareas fuera del rango de actividad si se protocolizaron este año">
           <input 
             type="checkbox" 
             :checked="includeOutOfPeriod"
             @change="$emit('update:includeOutOfPeriod', ($event.target as HTMLInputElement).checked)"
             class="w-4 h-4 rounded border-border text-secondary focus:ring-secondary/20"
           />
           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Incluir Fuera Período</span>
        </label>
      </div>

      <!-- Refresh Action -->
      <button 
        @click="$emit('refresh')"
        class="bg-primary hover:bg-primary-hover text-primary-fg p-2 rounded-lg transition-all shadow-theme-xs shadow-primary/20 active:scale-95 flex items-center justify-center"
        title="Actualizar Datos"
      >
        <RefreshCwIcon :class="['w-4 h-4', loading ? 'animate-spin' : '']" />
      </button>

    </div>
  </div>
</template>

<script setup lang="ts">
import { RefreshCwIcon } from 'lucide-vue-next'
import { type Component } from 'vue'

defineProps<{
  title: string
  subtitle: string
  icon: Component
  year: number
  mode: 'CALENDAR' | 'TOTAL'
  protocolizedOnly: boolean
  includeOutOfPeriod: boolean
  loading?: boolean
}>()

defineEmits<{
  (e: 'update:year', val: number): void
  (e: 'update:mode', val: 'CALENDAR' | 'TOTAL'): void
  (e: 'update:protocolizedOnly', val: boolean): void
  (e: 'update:includeOutOfPeriod', val: boolean): void
  (e: 'refresh'): void
}>()
</script>
