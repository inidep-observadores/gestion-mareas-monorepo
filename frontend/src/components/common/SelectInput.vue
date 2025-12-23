<template>
  <select
    :value="modelValue"
    @change="$emit('update:modelValue', ($event.target as HTMLSelectElement).value)"
    :class="[
      'w-full px-4 py-2.5 border rounded-xl text-sm font-medium transition-all duration-200',
      'bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300',
      'border-gray-200 dark:border-gray-700',
      'hover:border-gray-300 dark:hover:border-gray-600',
      'focus:outline-none focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500',
      'disabled:opacity-50 disabled:cursor-not-allowed',
    ]"
    :disabled="disabled"
  >
    <option v-if="placeholder" value="" class="text-gray-500 dark:text-gray-400">
      {{ placeholder }}
    </option>
    <option
      v-for="option in options"
      :key="option.value"
      :value="option.value"
      class="text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800"
    >
      {{ option.label }}
    </option>
  </select>
</template>

<script setup lang="ts">
interface SelectOption {
  value: string | number
  label: string
}

interface Props {
  modelValue?: string | number
  options: SelectOption[]
  placeholder?: string
  disabled?: boolean
}

defineProps<Props>()
defineEmits<{
  'update:modelValue': [value: string]
}>()
</script>
