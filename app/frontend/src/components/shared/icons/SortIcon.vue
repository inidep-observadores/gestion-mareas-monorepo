<template>
  <div class="flex flex-col items-center justify-center">
    <svg 
      xmlns="http://www.w3.org/2000/svg" 
      class="w-3 h-3 transition-colors"
      :class="order === 'asc' ? 'text-primary' : 'text-text-muted/30'"
      viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"
    >
      <polyline points="18 15 12 9 6 15"></polyline>
    </svg>
    <svg 
      xmlns="http://www.w3.org/2000/svg" 
      class="w-3 h-3 -mt-1 transition-colors"
      :class="order === 'desc' ? 'text-primary' : 'text-text-muted/30'"
      viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"
    >
      <polyline points="6 9 12 15 18 9"></polyline>
    </svg>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  order?: 'asc' | 'desc'
}>()
</script>
