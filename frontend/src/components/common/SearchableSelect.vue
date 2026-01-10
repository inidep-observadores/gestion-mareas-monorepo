<template>
  <div class="relative" ref="container">
    <!-- Trigger Input -->
    <div class="relative group">
      <input 
        type="text"
        v-model="searchQuery"
        @focus="openDropdown"
        @input="onSearchInput"
        @keydown="onKeyDown"
        :placeholder="selectedLabel ? '' : placeholder"
        class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-900 border rounded-lg text-sm text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all appearance-none caret-brand-500"
        style="color-scheme: light dark;"
        :class="[
          error ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800',
          { 'pl-10': icon }
        ]"
      />
      <!-- Display selected label when not searching and not focused -->
      <div v-if="selectedLabel && !searchQuery && !isOpen" 
           class="absolute inset-y-0 left-0 flex items-center px-4 pointer-events-none text-sm text-gray-800 dark:text-white"
           :class="{ 'pl-10': icon }">
        {{ selectedLabel }}
      </div>
      <div v-if="icon" class="absolute inset-y-0 left-0 flex items-center pl-3" :class="error ? 'text-red-500' : 'text-gray-400'">
        <component :is="icon" class="w-4 h-4" />
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
        <div class="max-h-64 overflow-y-auto custom-scrollbar p-1" ref="listContainer">
          <div v-if="filteredOptions.length === 0" class="p-4 text-center text-gray-400 text-xs italic">
            No se encontraron resultados
          </div>
          <button
            v-for="(option, index) in filteredOptions"
            :key="option.value"
            :id="`option-${index}`"
            @click="selectOption(option)"
            @mouseenter="highlightedIndex = index"
            class="w-full px-5 py-3 text-left rounded-xl transition-all flex items-center justify-between group"
            :class="[
              modelValue === option.value ? 'bg-brand-50/50 dark:bg-brand-500/10' : '',
              highlightedIndex === index ? 'bg-brand-50 dark:bg-brand-500/20 ring-1 ring-brand-200 dark:ring-brand-800' : ''
            ]"
          >
            <span class="text-sm font-semibold" :class="modelValue === option.value ? 'text-brand-500' : 'text-gray-700 dark:text-gray-300'">
              {{ option.label }}
            </span>
            <CheckIcon v-if="modelValue === option.value" class="w-4 h-4 text-brand-500" />
            <span v-else-if="highlightedIndex === index" class="text-[9px] text-brand-400 font-black uppercase tracking-widest transition-opacity animate-in fade-in slide-in-from-right-1">Seleccionar</span>
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
const listContainer = ref<HTMLElement | null>(null)
const isOpen = ref(false)
const searchQuery = ref('')
const dropdownStyle = ref({})
const highlightedIndex = ref(-1)

const selectedLabel = computed(() => {
  return props.options.find(o => o.value === props.modelValue)?.label || ''
})

const normalizeText = (text: string) => {
  return text.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase()
}

const filteredOptions = computed(() => {
  if (!searchQuery.value) return props.options
  const q = normalizeText(searchQuery.value)
  return props.options.filter(o => normalizeText(o.label).includes(q))
})

const openDropdown = () => {
  isOpen.value = true
  highlightedIndex.value = -1
  updateDropdownPosition()
}

const closeDropdown = () => {
  isOpen.value = false
  searchQuery.value = ''
  highlightedIndex.value = -1
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
  highlightedIndex.value = filteredOptions.value.length > 0 ? 0 : -1
}

const onKeyDown = (e: KeyboardEvent) => {
  if (!isOpen.value) {
    if (e.key === 'ArrowDown' || e.key === 'Enter') {
      openDropdown()
      if (filteredOptions.value.length > 0) highlightedIndex.value = 0
    }
    return
  }

  switch (e.key) {
    case 'ArrowDown':
      e.preventDefault()
      highlightedIndex.value = (highlightedIndex.value + 1) % filteredOptions.value.length
      scrollToHighlighted()
      break
    case 'ArrowUp':
      e.preventDefault()
      highlightedIndex.value = (highlightedIndex.value - 1 + filteredOptions.value.length) % filteredOptions.value.length
      scrollToHighlighted()
      break
    case 'Enter':
      e.preventDefault()
      if (highlightedIndex.value >= 0 && highlightedIndex.value < filteredOptions.value.length) {
        selectOption(filteredOptions.value[highlightedIndex.value])
      }
      break
    case 'Escape':
      e.preventDefault()
      closeDropdown()
      break
    case 'Tab':
      closeDropdown()
      break
  }
}

const scrollToHighlighted = () => {
  nextTick(() => {
    const el = document.getElementById(`option-${highlightedIndex.value}`)
    if (el) {
      el.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
  })
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

<style scoped>
input {
  color-scheme: light;
  caret-color: #465fff;
}

:global(.dark) input {
  color-scheme: dark;
  caret-color: #7592ff;
}
</style>


