<template>
  <div
    class="inline-flex items-center gap-1.5 p-1.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-700/50 rounded-2xl shadow-sm"
  >
    <button
      v-for="option in options"
      :key="option.value"
      @click="$emit('update:modelValue', option.value)"
      :class="[
        'px-5 py-2 text-[11px] font-black uppercase tracking-widest rounded-xl transition-all duration-300',
        modelValue === option.value
          ? 'bg-white dark:bg-gray-700 text-primary dark:text-primary shadow-md translate-y-[-1px]'
          : 'text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200 hover:bg-white/50 dark:hover:bg-gray-800',
      ]"
    >
      <div class="flex items-center gap-2.5">
        <component v-if="option.icon" :is="option.icon" class="w-3.5 h-3.5" />
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
