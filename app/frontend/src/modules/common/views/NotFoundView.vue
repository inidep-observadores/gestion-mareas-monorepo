<template>
  <ErrorLayout>
    <template #icon>
      <svg class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
         <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
      </svg>
    </template>

    <template #title>404 - Página no encontrada</template>

    <template #description>
      Lo sentimos, no pudimos encontrar la página que está buscando. Puede que haya sido movida o eliminada.
    </template>

    <template #actions>
      <router-link
        :to="{ name: 'Dashboard' }"
        class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-brand-600 hover:bg-brand-700 text-white rounded-2xl font-bold shadow-lg shadow-brand-500/25 transition-all active:scale-95"
      >
        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
        </svg>
        Volver al Inicio
      </router-link>
    </template>
  </ErrorLayout>
</template>

<script setup lang="ts">
import ErrorLayout from '@/components/layout/ErrorLayout.vue';
import { RouterLink } from 'vue-router'
</script>
