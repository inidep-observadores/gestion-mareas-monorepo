<template>
  <label class="relative inline-flex items-center cursor-pointer group" :class="{ 'opacity-60 pointer-events-none': disabled }">
    <input 
      type="checkbox" 
      :checked="modelValue" 
      :disabled="disabled"
      @change="$emit('update:modelValue', ($event.target as HTMLInputElement).checked)"
      class="sr-only peer"
    >
    <div 
      class="w-8 h-4 bg-surface rounded-full border border-border/20 transition-all duration-300
             shadow-theme-xs
             peer-checked:bg-primary group-hover:border-border/40
             after:content-[''] after:absolute after:top-[2px] after:left-[2px] 
             after:bg-text-muted/60 after:rounded-full after:h-3 after:w-3 after:transition-all
             peer-checked:after:translate-x-full peer-checked:after:bg-primary-fg"
    ></div>
  </label>
</template>

<script setup lang="ts">
defineProps<{
  modelValue: boolean;
  disabled?: boolean;
}>()

defineEmits<{
  (e: 'update:modelValue', val: boolean): void
}>()
</script>
