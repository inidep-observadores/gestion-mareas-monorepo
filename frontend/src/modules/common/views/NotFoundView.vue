<template>
  <FullScreenLayout>
    <div class="relative p-6 bg-white z-1 dark:bg-gray-900 sm:p-0 flex items-center justify-center h-screen">
      <div class="flex flex-col items-center justify-center text-center max-w-lg mx-auto">
        
        <div class="mb-6 w-24 h-24 rounded-3xl bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center shadow-lg shadow-blue-500/20">
             <svg class="w-12 h-12 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
        </div>

        <h1 class="mb-3 text-3xl font-bold text-gray-800 dark:text-white sm:text-4xl">
          404 - Página no encontrada
        </h1>

        <p class="mb-8 text-base text-gray-500 dark:text-gray-400">
          Lo sentimos, no pudimos encontrar la página que estás buscando. Puede que haya sido movida o eliminada.
        </p>

        <router-link
          :to="{ name: 'Dashboard' }"
          class="inline-flex items-center justify-center px-6 py-3 text-base font-medium text-white transition-all duration-200 rounded-xl bg-brand-500 hover:bg-brand-600 shadow-theme-xs hover:shadow-lg hover:shadow-brand-500/20"
        >
          <svg
            class="w-5 h-5 mr-2"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
          Volver al Inicio
        </router-link>
      </div>
    </div>
  </FullScreenLayout>
</template>

<script setup lang="ts">
import FullScreenLayout from '@/components/layout/FullScreenLayout.vue'
import { RouterLink } from 'vue-router'
</script>
