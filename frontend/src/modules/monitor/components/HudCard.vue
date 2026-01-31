<template>
  <div
    :class="[
      'pointer-events-auto bg-white/10 dark:bg-gray-900/40 backdrop-blur-xl rounded-[1.25rem] border border-white/20 dark:border-white/5 shadow-2xl shadow-black/5 overflow-hidden flex flex-col transition-all duration-500',
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
