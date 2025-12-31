<template>
  <div class="relative" ref="container">
    <!-- Trigger Input -->
    <div class="relative group">
      <input 
        type="text"
        v-model="searchQuery"
        @focus="openDropdown"
        @input="onSearchInput"
        :placeholder="selectedLabel || placeholder"
        class="w-full px-6 py-4 bg-gray-50/50 dark:bg-gray-900 border-2 rounded-2xl font-bold text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all appearance-none"
        :class="[
          error ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800',
          { 'pl-12': icon }
        ]"
      />
      <div v-if="icon" class="absolute inset-y-0 left-0 flex items-center pl-4" :class="error ? 'text-red-500' : 'text-gray-400'">
        <component :is="icon" class="w-5 h-5" />
      </div>
      <div class="absolute inset-y-0 right-0 flex items-center pr-4 text-gray-400 pointer-events-none transition-transform duration-300" :class="{ 'rotate-180': isOpen }">
        <ChevronDownIcon class="w-4 h-4" />
      </div>
    </div>

    <!-- Dropdown Menu -->
    <Teleport to="body">
      <div 
        v-if="isOpen" 
        ref="dropdown"
        class="fixed z-[9999] bg-white dark:bg-gray-950 border border-gray-200 dark:border-gray-800 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200"
        :style="dropdownStyle"
      >
        <div class="max-h-60 overflow-y-auto custom-scrollbar">
          <div v-if="filteredOptions.length === 0" class="p-4 text-center text-gray-400 text-xs italic">
            No se encontraron resultados
          </div>
          <button
            v-for="option in filteredOptions"
            :key="option.value"
            @click="selectOption(option)"
            class="w-full px-5 py-3 text-left hover:bg-brand-50 dark:hover:bg-brand-500/10 transition-colors flex items-center justify-between group"
          >
            <span class="text-sm font-semibold" :class="modelValue === option.value ? 'text-brand-500' : 'text-gray-700 dark:text-gray-300'">
              {{ option.label }}
            </span>
            <CheckIcon v-if="modelValue === option.value" class="w-4 h-4 text-brand-500" />
            <span v-else class="text-[10px] opacity-0 group-hover:opacity-100 text-brand-400 font-black uppercase tracking-widest transition-opacity">Seleccionar</span>
          </button>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import { ChevronDownIcon, CheckIcon } from '@/icons'

interface Option {
  value: string | number
  label: string
}

const props = defineProps<{
  modelValue: string | number | null
  options: Option[]
  placeholder?: string
  icon?: any
  error?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string | number | null): void
  (e: 'change', value: string | number | null): void
}>()

const container = ref<HTMLElement | null>(null)
const dropdown = ref<HTMLElement | null>(null)
const isOpen = ref(false)
const searchQuery = ref('')
const dropdownStyle = ref({})

const selectedLabel = computed(() => {
  return props.options.find(o => o.value === props.modelValue)?.label || ''
})

const filteredOptions = computed(() => {
  if (!searchQuery.value) return props.options
  const q = searchQuery.value.toLowerCase()
  return props.options.filter(o => o.label.toLowerCase().includes(q))
})

const openDropdown = () => {
  isOpen.value = true
  updateDropdownPosition()
}

const closeDropdown = () => {
  isOpen.value = false
  searchQuery.value = ''
}

const updateDropdownPosition = () => {
  if (!container.value) return
  const rect = container.value.getBoundingClientRect()
  dropdownStyle.value = {
    top: `${rect.bottom + 8}px`,
    left: `${rect.left}px`,
    width: `${rect.width}px`
  }
}

const selectOption = (option: Option) => {
  emit('update:modelValue', option.value)
  emit('change', option.value)
  closeDropdown()
}

const onSearchInput = () => {
  if (!isOpen.value) openDropdown()
}

// Window resize/scroll handling
const handleOutsideClick = (event: MouseEvent) => {
  if (container.value && !container.value.contains(event.target as Node) && 
      dropdown.value && !dropdown.value.contains(event.target as Node)) {
    closeDropdown()
  }
}

onMounted(() => {
  window.addEventListener('click', handleOutsideClick)
  window.addEventListener('scroll', updateDropdownPosition, true)
  window.addEventListener('resize', updateDropdownPosition)
})

onUnmounted(() => {
  window.removeEventListener('click', handleOutsideClick)
  window.removeEventListener('scroll', updateDropdownPosition, true)
  window.removeEventListener('resize', updateDropdownPosition)
})

watch(() => props.modelValue, () => {
  // Reset search when value changes externally if needed
})
</script>

