<template>
  <div class="min-h-screen animate-page-fade bg-background">
    <app-sidebar />
    <Backdrop />
    <div
      class="flex-1 transition-all duration-300 ease-in-out"
      :class="[isExpanded || isHovered ? 'lg:ml-[18.125rem]' : 'lg:ml-[5.625rem]']"
    >
      <app-header>
        <template #extra-content>
          <slot name="extra-header"></slot>
        </template>
      </app-header>
      <div class="admin-layout-content p-4 mx-auto max-w-(--breakpoint-2xl) md:p-6">
        <slot></slot>
      </div>
    </div>

    <!-- Global Spotlight Search -->
    <SpotlightSearch />
  </div>
</template>

<script setup lang="ts">
import { watchEffect, onUnmounted, onMounted } from 'vue'
import AppSidebar from './AppSidebar.vue'
import AppHeader from './AppHeader.vue'
import { useSidebar } from '@/composables/useSidebar'
import { usePageHeader } from '@/composables/usePageHeader'
import Backdrop from './Backdrop.vue'
import SpotlightSearch from '../common/SpotlightSearch.vue'
import httpClient from '@/config/http/http.client'

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


onMounted(() => {
  // Global heartbeat to trigger automated tracking checks (fire & forget)
  httpClient.get('/tracking/heartbeat', { skipToast: true }).catch(() => {})
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
