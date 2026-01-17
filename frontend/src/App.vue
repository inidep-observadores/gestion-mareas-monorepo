<template>
  <div v-if="!isReady" class="flex items-center justify-center min-h-screen bg-background">
    <div class="flex flex-col items-center gap-4">
      <LoadingSpinner size="xl" class="text-primary" />
      <p class="text-sm font-medium text-text-muted">Cargando sistema...</p>
    </div>
  </div>
  <ThemeProvider v-else>
    <SidebarProvider>
      <RouterView />
    </SidebarProvider>
    <Toaster position="bottom-right" richColors :theme="darkMode ? 'dark' : 'light'" />
  </ThemeProvider>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useThemeStore } from '@/modules/shared/stores/theme.store'
import ThemeProvider from './components/layout/ThemeProvider.vue'
import SidebarProvider from './components/layout/SidebarProvider.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { Toaster } from 'vue-sonner'

const authStore = useAuthStore()
const { isReady } = storeToRefs(authStore)
const themeStore = useThemeStore()
const { darkMode } = storeToRefs(themeStore)
</script>
