<template>
  <div class="min-h-screen xl:flex">
    <app-sidebar />
    <Backdrop />
    <div
      class="flex-1 transition-all duration-300 ease-in-out"
      :class="[isExpanded || isHovered ? 'lg:ml-[290px]' : 'lg:ml-[90px]']"
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
import { watchEffect, onUnmounted } from 'vue'
import AppSidebar from './AppSidebar.vue'
import AppHeader from './AppHeader.vue'
import { useSidebar } from '@/composables/useSidebar'
import { usePageHeader } from '@/composables/usePageHeader'
import Backdrop from './Backdrop.vue'
import SpotlightSearch from '../common/SpotlightSearch.vue'

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
