<template>
  <div class="relative w-full sm:w-64">
    <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-text-muted">
      <SearchIcon class="w-4 h-4" />
    </span>
    <input
      :value="modelValue"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      type="text"
      :placeholder="placeholder"
      class="text-sm pl-9 pr-9 py-2 border border-border rounded-xl bg-surface focus:ring-2 focus:ring-primary/20 outline-none transition-all w-full"
    />
    <button
      v-if="modelValue"
      @click="$emit('update:modelValue', '')"
      class="absolute inset-y-0 right-0 flex items-center pr-2.5 text-text-muted hover:text-text transition-colors"
      title="Limpiar búsqueda"
    >
      <XIcon class="w-4 h-4" />
    </button>
  </div>
</template>

<script setup lang="ts">
import { SearchIcon, XIcon } from '@/icons'

defineProps<{
  modelValue: string
  placeholder?: string
}>()

defineEmits(['update:modelValue'])
</script>
