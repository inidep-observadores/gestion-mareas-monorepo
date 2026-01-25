<template>
  <div class="min-h-screen xl:flex bg-error/5 dark:bg-error/10 relative overflow-hidden">
    <!-- Distinctive Background Pattern for Admin (Hazard Zone) -->
    <div class="absolute inset-0 z-0 pointer-events-none opacity-[0.15] dark:opacity-[0.25]">
      <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <pattern id="admin-grid" width="60" height="60" patternUnits="userSpaceOnUse">
            <path d="M 60 0 L 0 0 0 60" fill="none" stroke="var(--color-error)" stroke-width="1.5"/>
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#admin-grid)" />
      </svg>
    </div>

    <admin-sidebar />
    <Backdrop />
    <div
      class="flex-1 transition-all duration-300 ease-in-out relative z-10 min-w-0"
      :class="[isExpanded || isHovered ? 'lg:ml-[18.125rem]' : 'lg:ml-[5.625rem]']"
    >
      <app-header />
      <div class="admin-layout-content p-4 mx-auto max-w-(--breakpoint-2xl) md:p-6 min-w-0 overflow-hidden">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { watchEffect, onUnmounted } from 'vue'
import AdminSidebar from '../components/AdminSidebar.vue'
import AppHeader from '@/components/layout/AppHeader.vue'
import { useSidebar } from '@/composables/useSidebar'
import { usePageHeader } from '@/composables/usePageHeader'
import Backdrop from '@/components/layout/Backdrop.vue'

const props = defineProps<{
  title?: string
  description?: string
}>()

const { isExpanded, isHovered } = useSidebar()
const { setHeader, clearHeader } = usePageHeader()

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
