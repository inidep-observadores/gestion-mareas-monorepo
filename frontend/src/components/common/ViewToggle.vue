<template>
  <div
    class="inline-flex items-center gap-1 p-1 bg-gray-100 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 rounded-xl shadow-sm"
  >
    <button
      v-for="option in options"
      :key="option.value"
      @click="$emit('update:modelValue', option.value)"
      :class="[
        'px-4 py-2 text-sm font-medium rounded-lg transition-all duration-200',
        modelValue === option.value
          ? 'bg-white dark:bg-gray-700 text-brand-500 dark:text-brand-400 shadow-sm'
          : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200',
      ]"
    >
      <div class="flex items-center gap-2">
        <component v-if="option.icon" :is="option.icon" class="w-4 h-4" />
        <span :class="{ 'hidden sm:inline': option.hideTextOnMobile }">{{ option.label }}</span>
      </div>
    </button>
  </div>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

interface ToggleOption {
  value: string
  label: string
  icon?: Component
  hideTextOnMobile?: boolean
}

interface Props {
  modelValue: string
  options: ToggleOption[]
}

defineProps<Props>()
defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>
