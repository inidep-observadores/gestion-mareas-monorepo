<template>
  <router-link to="/" class="lg:hidden flex items-center gap-2">
    <div
      class="w-9 h-9 rounded-lg bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center flex-shrink-0"
    >
      <WaveIcon class="w-5 h-5 text-white" />
    </div>
    <div class="flex flex-col">
      <span class="text-sm font-bold text-gray-800 dark:text-white leading-tight">Gestión de</span>
      <span class="text-sm font-bold text-blue-600 dark:text-blue-400 leading-tight">Mareas</span>
    </div>
  </router-link>
</template>

<script setup>
import { RouterLink } from 'vue-router'
import { WaveIcon } from '@/icons'
</script>
