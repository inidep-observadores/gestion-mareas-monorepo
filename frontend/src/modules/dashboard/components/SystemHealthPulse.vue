<template>
  <div class="flex items-center gap-4 px-4 py-2 bg-white/50 dark:bg-gray-900/50 backdrop-blur-md border border-gray-100 dark:border-gray-800 rounded-2xl shadow-sm">
    <div class="flex items-center gap-2 border-r border-gray-100 dark:border-gray-800 pr-4">
      <div class="relative flex h-2 w-2">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-success-400 opacity-75"></span>
        <span class="relative inline-flex rounded-full h-2 w-2 bg-success-500"></span>
      </div>
      <span class="text-[10px] font-black uppercase tracking-widest text-gray-500 dark:text-gray-400">Core API Online</span>
    </div>

    <div class="flex items-center gap-4 text-[10px] font-bold text-gray-400 uppercase tracking-tight">
      <div class="flex items-center gap-1.5">
        <div class="w-1 h-1 rounded-full bg-brand-400"></div>
        <span>DB: <span class="text-gray-700 dark:text-gray-200">99.9%</span></span>
      </div>
      <div class="flex items-center gap-1.5">
        <div class="w-1 h-1 rounded-full bg-brand-400"></div>
        <span>Backup: <span class="text-gray-700 dark:text-gray-200">Hace 4h</span></span>
      </div>
      <div class="flex items-center gap-1.5">
        <div class="w-1 h-1 rounded-full bg-brand-400"></div>
        <span>Workers: <span class="text-gray-700 dark:text-gray-200">Activos (4)</span></span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// En el futuro esto vendrá de un endpoint de health-check
</script>
