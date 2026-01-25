<template>
  <div class="bg-surface p-5 rounded-2xl border border-border shadow-theme-xs hover:shadow-theme-sm transition-all duration-300 group">
    <div class="flex items-start justify-between mb-4">
      <div>
        <p class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-1">{{ label }}</p>
        <h3 class="text-2xl font-black text-text tracking-tight">{{ value }}</h3>
      </div>
      <div 
        class="w-10 h-10 rounded-xl flex items-center justify-center transition-colors duration-300"
        :class="colorClass"
      >
        <component :is="icon" class="w-5 h-5" />
      </div>
    </div>
    
    <div v-if="trend" class="flex items-center gap-2">
      <span 
        class="text-xs font-bold px-1.5 py-0.5 rounded"
        :class="trend > 0 ? 'bg-emerald-500/10 text-emerald-600' : 'bg-red-500/10 text-red-600'"
      >
        {{ trend > 0 ? '+' : ''}}{{ trend }}%
      </span>
      <span class="text-[10px] text-text-muted font-medium">vs periodo anterior</span>
    </div>
    <div v-else-if="subtext" class="text-[10px] text-text-muted font-medium">
      {{ subtext }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, type Component } from 'vue'

const props = defineProps<{
  label: string
  value: string | number
  icon: Component
  trend?: number
  subtext?: string
  color?: 'primary' | 'secondary' | 'accent' | 'info' | 'success' | 'warning' | 'danger'
}>()

const colorClass = computed(() => {
  const map: Record<string, string> = {
    primary: 'bg-primary/10 text-primary group-hover:bg-primary group-hover:text-primary-fg',
    secondary: 'bg-secondary/10 text-secondary group-hover:bg-secondary group-hover:text-secondary-fg',
    accent: 'bg-accent/10 text-accent group-hover:bg-accent group-hover:text-accent-fg',
    info: 'bg-blue-500/10 text-blue-600 group-hover:bg-blue-500 group-hover:text-white',
    success: 'bg-emerald-500/10 text-emerald-600 group-hover:bg-emerald-500 group-hover:text-white',
    warning: 'bg-amber-500/10 text-amber-600 group-hover:bg-amber-500 group-hover:text-white',
    danger: 'bg-red-500/10 text-red-600 group-hover:bg-red-500 group-hover:text-white',
  }
  return map[props.color || 'primary']
})
</script>
