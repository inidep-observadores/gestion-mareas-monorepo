<template>
  <div
    v-if="isMobileOpen"
    class="fixed inset-0 bg-black/50 z-45 lg:hidden"
    @click="toggleMobileSidebar"
  ></div>
</template>

<script setup lang="ts">
import { useSidebar } from '@/composables/useSidebar'
const { toggleMobileSidebar, isMobileOpen } = useSidebar()
</script>
