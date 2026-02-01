<template>
  <div :class="darkMode ? 'bg-slate-950' : 'bg-slate-50'" class="min-h-screen transition-colors duration-700">
    <div v-if="!isReady" class="flex items-center justify-center min-h-screen">
      <div class="flex flex-col items-center gap-4">
        <LoadingSpinner size="xl" class="text-primary" />
        <p class="text-sm font-medium text-text-muted">Iniciando Sigma...</p>
      </div>
    </div>
    <ThemeProvider v-else>
      <SidebarProvider>
        <RouterView />
      </SidebarProvider>
      <Toaster position="bottom-right" richColors :theme="darkMode ? 'dark' : 'light'" />
      <StagingWatermark />
    </ThemeProvider>
  </div>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useThemeStore } from '@/modules/shared/stores/theme.store'
import ThemeProvider from './components/layout/ThemeProvider.vue'
import SidebarProvider from './components/layout/SidebarProvider.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import StagingWatermark from '@/components/layout/StagingWatermark.vue'
import { Toaster } from 'vue-sonner'

const authStore = useAuthStore()
const { isReady } = storeToRefs(authStore)
const themeStore = useThemeStore()
const { darkMode } = storeToRefs(themeStore)
</script>
