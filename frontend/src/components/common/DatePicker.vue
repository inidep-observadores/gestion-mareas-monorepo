<template>
  <div class="relative group">
    <input
      :type="showTime ? 'datetime-local' : 'date'"
      :value="modelValue"
      @input="onInput"
      class="w-full px-4 py-2.5 bg-gray-50/50 dark:bg-gray-900 border rounded-lg text-sm text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all appearance-none"
      :class="[
        error ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800',
        { 'pl-10': icon }
      ]"
    />
    <div v-if="icon" class="absolute inset-y-0 left-0 flex items-center pl-3" :class="error ? 'text-red-500' : 'text-gray-400'">
      <component :is="icon" class="w-4 h-4" />
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: string | null
  showTime?: boolean
  icon?: any
  error?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string | null): void
}>()

const onInput = (event: Event) => {
  const target = event.target as HTMLInputElement
  emit('update:modelValue', target.value || null)
}
</script>

<style scoped>
::-webkit-calendar-picker-indicator {
  @apply dark:invert cursor-pointer opacity-50 hover:opacity-100 transition-opacity;
}
</style>
