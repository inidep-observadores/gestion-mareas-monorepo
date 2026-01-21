<template>
  <div
    :class="[
      'pointer-events-auto bg-surface/10 dark:bg-surface/40 backdrop-blur-md rounded-2xl border border-border/10 shadow-theme-lg overflow-hidden flex flex-col transition-all duration-500 hover:border-border/20',
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
