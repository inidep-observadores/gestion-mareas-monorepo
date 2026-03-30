<template>
  <div class="min-h-screen animate-page-fade transition-colors duration-500" 
       :class="isHistoricalYear ? 'bg-amber-50/50 dark:bg-amber-900/10' : 'bg-background'">
    
    <!-- Distinctive Background Pattern for Historical Years (Sepia/Paper effect) -->
    <div v-if="isHistoricalYear" class="fixed inset-0 z-0 pointer-events-none opacity-[0.25] dark:opacity-[0.15]">
      <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
        <filter id="noiseFilter">
          <feTurbulence type="fractalNoise" baseFrequency="0.8" numOctaves="3" stitchTiles="stitch"/>
        </filter>
        <rect width="100%" height="100%" fill="var(--color-warning)" opacity="0.05" />
        <rect width="100%" height="100%" filter="url(#noiseFilter)" opacity="0.08" />
        <defs>
          <pattern id="historical-grid" width="30" height="30" patternUnits="userSpaceOnUse">
            <path d="M 30 0 L 0 0 0 30" fill="none" stroke="var(--color-warning)" stroke-width="0.5" opacity="0.3"/>
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#historical-grid)" />
      </svg>
    </div>

    <!-- The actual app sidebar and backdrop are absolutely positioned or flex elements so they shouldn't conflict -->
    <app-sidebar />
    <Backdrop />
    
    <div
      class="flex-1 transition-all duration-300 ease-in-out relative z-10"
      :class="[isExpanded || isHovered ? 'lg:ml-[18.125rem]' : 'lg:ml-[5.625rem]']"
    >
      <app-header>
        <template #extra-content>
          <slot name="extra-header"></slot>
        </template>
      </app-header>
      <!-- Note: the background applied to .admin-layout-content here is transparent by default -->
      <div class="admin-layout-content p-4 mx-auto max-w-(--breakpoint-2xl) md:p-6">
        <slot></slot>
      </div>
    </div>

    <!-- Global Spotlight Search -->
    <SpotlightSearch />
  </div>
</template>

<script setup lang="ts">
import { watchEffect, onUnmounted, computed } from 'vue'
import AppSidebar from './AppSidebar.vue'
import AppHeader from './AppHeader.vue'
import { useSidebar } from '@/composables/useSidebar'
import { usePageHeader } from '@/composables/usePageHeader'
import { useConfigStore } from '@/modules/shared/stores/config.store'
import Backdrop from './Backdrop.vue'
import SpotlightSearch from '../common/SpotlightSearch.vue'

const props = defineProps<{
  title?: string
  description?: string
}>()

const { isExpanded, isHovered } = useSidebar()
const { setHeader, clearHeader } = usePageHeader()
const configStore = useConfigStore()

const isHistoricalYear = computed(() => {
  const currentYear = new Date().getFullYear()
  return configStore.selectedYear < currentYear
})

watchEffect(() => {
  if (props.title) {
    setHeader(props.title, props.description || '')
  }
})

onUnmounted(() => {
  if (props.title) {
    clearHeader(props.title)
  }
})
</script>

<style scoped>
.animate-page-fade {
  animation: pageFadeIn 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

@keyframes pageFadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
</style>
