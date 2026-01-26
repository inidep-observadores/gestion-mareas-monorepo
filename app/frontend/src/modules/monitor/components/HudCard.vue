<template>
  <div :class="[
    'glass-hud',
    customClass
  ]">
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  customClass?: string
}>()
</script>
