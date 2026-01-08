<template>
  <div 
    class="flex items-center gap-4 p-4 bg-red-50/50 dark:bg-red-500/5 border border-red-100 dark:border-red-500/10 rounded-2xl group hover:bg-red-50 dark:hover:bg-red-500/10 transition-all duration-300 ring-1 ring-black/5"
  >
    <!-- Icon / Status -->
    <div class="flex-shrink-0 relative">
      <div class="p-3 bg-red-500 text-white rounded-xl shadow-lg shadow-red-500/20 group-hover:scale-110 transition-transform">
        <ErrorIcon class="w-5 h-5" />
      </div>
      <span class="absolute -top-1 -right-1 flex h-3 w-3">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
        <span class="relative inline-flex rounded-full h-3 w-3 bg-red-500 border-2 border-white dark:border-gray-900"></span>
      </span>
    </div>

    <!-- Content -->
    <div class="flex-1 min-w-0">
      <div class="flex items-center gap-2 mb-0.5">
        <span class="text-[10px] font-black uppercase tracking-widest text-red-600 dark:text-red-400">Alerta Crítica</span>
        <span class="text-[10px] text-gray-400 dark:text-gray-500 font-mono">• {{ fecha }}</span>
      </div>
      <h4 class="text-sm font-black text-gray-900 dark:text-white truncate uppercase tracking-tight">
        {{ titulo }}
      </h4>
      <p class="text-[11px] text-gray-500 dark:text-gray-400 line-clamp-1 mt-0.5 leading-relaxed">
        {{ descripcion }}
      </p>
    </div>

    <!-- Actions -->
    <div class="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
      <button 
        @click="$emit('action', 'manage')"
        class="px-3 py-1.5 bg-white dark:bg-gray-800 text-red-600 dark:text-red-400 text-[10px] font-black hover:bg-red-600 hover:text-white dark:hover:bg-red-500 dark:hover:text-white rounded-lg transition-all border border-red-100 dark:border-red-900/30 shadow-sm active:scale-95"
      >
        Gestionar
      </button>
      <button 
        @click="$emit('action', 'dismiss')"
        class="p-2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-all"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ErrorIcon } from '@/icons'

interface Props {
  titulo: string
  descripcion: string
  fecha: string
}

defineProps<Props>()
defineEmits(['action'])
</script>
