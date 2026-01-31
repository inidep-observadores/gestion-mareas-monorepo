<template>
  <slot></slot>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useThemeStore } from '@/modules/shared/stores/theme.store'

const themeStore = useThemeStore()

onMounted(() => {
  themeStore.init()
})
</script>

<script lang="ts">
import { inject } from 'vue'
import type { useThemeStore as useThemeStoreType } from '@/modules/shared/stores/theme.store'

export function useTheme() {
  const theme = useThemeStore()
  return {
    isDarkMode: theme.darkMode,
    toggleTheme: theme.toggleDarkMode,
    primaryColor: theme.primaryColor,
    setPrimaryColor: theme.setPrimaryColor
  }
}
</script>
