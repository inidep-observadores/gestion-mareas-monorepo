<template>
  <div v-if="!isReady" class="flex items-center justify-center min-h-screen bg-gray-50 dark:bg-gray-950">
    <div class="flex flex-col items-center gap-4">
      <div class="w-12 h-12 border-4 border-blue-500 rounded-full border-t-transparent animate-spin"></div>
      <p class="text-sm font-medium text-gray-500 dark:text-gray-400">Cargando sistema...</p>
    </div>
  </div>
  <ThemeProvider v-else>
    <SidebarProvider>
      <RouterView />
      <Toaster position="top-right" richColors />
    </SidebarProvider>
  </ThemeProvider>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import ThemeProvider from './components/layout/ThemeProvider.vue'
import SidebarProvider from './components/layout/SidebarProvider.vue'
import { Toaster } from 'vue-sonner'

const authStore = useAuthStore()
const { isReady } = storeToRefs(authStore)
</script>
