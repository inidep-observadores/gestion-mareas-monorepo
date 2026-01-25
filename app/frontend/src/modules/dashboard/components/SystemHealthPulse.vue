<template>
  <div class="flex items-center gap-4 px-4 py-2 bg-surface/50 backdrop-blur-md border border-border rounded-2xl shadow-sm">
    <div class="flex items-center gap-2 border-r border-border pr-4">
      <div class="relative flex h-2 w-2">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-success opacity-75"></span>
        <span class="relative inline-flex rounded-full h-2 w-2 bg-success"></span>
      </div>
      <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Core API Online</span>
    </div>

    <div class="flex items-center gap-4 text-[10px] font-bold text-text-muted uppercase tracking-tight">
      <div class="flex items-center gap-1.5">
        <div class="w-1 h-1 rounded-full bg-primary/40"></div>
        <span>DB: <span class="text-text">99.9%</span></span>
      </div>
      <div class="flex items-center gap-1.5">
        <div class="w-1 h-1 rounded-full bg-primary/40"></div>
        <span>Backup: <span class="text-text">Hace 4h</span></span>
      </div>
      <div class="flex items-center gap-1.5">
        <div class="w-1 h-1 rounded-full bg-primary/40"></div>
        <span>Workers: <span class="text-text">Activos (4)</span></span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// En el futuro esto vendrá de un endpoint de health-check
</script>
