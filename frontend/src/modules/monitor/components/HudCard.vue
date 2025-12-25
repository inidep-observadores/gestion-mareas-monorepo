<template>
  <div
    :class="[
      'pointer-events-auto bg-white/30 dark:bg-gray-900/30 backdrop-blur-sm rounded-xl border border-white/20 dark:border-white/10 shadow-xl overflow-hidden flex flex-col transition-all',
      customClass
    ]"
  >
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  customClass?: string
}>()
</script>
