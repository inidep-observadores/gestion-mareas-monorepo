<template>
  <div 
    :class="[
      'inline-block animate-spin rounded-full border-solid border-current border-t-transparent',
      sizeClasses[size]
    ]" 
    role="status"
  >
    <span class="sr-only">Cargando...</span>
  </div>
</template>

<script setup lang="ts">
interface Props {
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
}

withDefaults(defineProps<Props>(), {
  size: 'md'
})

const sizeClasses = {
  xs: 'w-3 h-3 border-[1.5px]',
  sm: 'w-4 h-4 border-2',
  md: 'w-6 h-6 border-[2.5px]',
  lg: 'w-8 h-8 border-[3px]',
  xl: 'w-12 h-12 border-4'
}
</script>
