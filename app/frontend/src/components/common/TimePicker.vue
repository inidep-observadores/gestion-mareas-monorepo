<template>
  <div class="relative w-full" ref="containerRef">
    <!-- Input -->
    <div class="relative group">
      <input
        ref="inputRef"
        type="text"
        v-model="displayValue"
        @input="handleInput"
        @keydown="handleKeyDown"
        @blur="handleBlur"
        placeholder="HH:MM"
        maxlength="5"
        :disabled="disabled"
        class="w-full pl-4 pr-10 py-2.5 bg-background border rounded-lg text-sm text-text outline-none focus:border-primary transition-all cursor-text placeholder:text-text-muted caret-primary disabled:opacity-50 disabled:bg-surface-muted disabled:cursor-not-allowed"
        :class="error ? 'border-error bg-error/5' : 'border-border'"
      />
      <button
        v-if="!disabled"
        type="button"
        @click="toggleDropdown"
        class="absolute inset-y-0 right-0 flex items-center pr-3 text-text-muted hover:text-primary transition-colors"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      </button>
    </div>

    <!-- Dropdown -->
    <Teleport to="body">
      <div
        v-if="isOpen"
        ref="dropdownRef"
        class="fixed z-[200000] bg-surface border border-border rounded-xl shadow-theme-xl p-4 animate-in fade-in zoom-in-95 duration-200"
        :style="dropdownStyle"
      >
        <p class="text-[10px] font-black uppercase tracking-widest text-text-muted text-center mb-3">Seleccionar hora</p>
        <div class="flex items-center justify-center gap-3">
          <!-- Horas -->
          <div class="flex flex-col items-center gap-1">
            <button
              type="button"
              @click="changeHours(1)"
              class="p-1 hover:bg-primary/10 rounded-lg transition-colors text-text-muted hover:text-primary"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 15 12 9 6 15"/></svg>
            </button>
            <div class="w-14 h-12 flex items-center justify-center bg-background border border-border rounded-lg font-black text-2xl text-text tabular-nums">
              {{ hoursDisplay }}
            </div>
            <button
              type="button"
              @click="changeHours(-1)"
              class="p-1 hover:bg-primary/10 rounded-lg transition-colors text-text-muted hover:text-primary"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <span class="text-[8px] font-black uppercase text-text-muted tracking-widest">Horas</span>
          </div>

          <span class="text-2xl font-black text-text-muted mb-3">:</span>

          <!-- Minutos -->
          <div class="flex flex-col items-center gap-1">
            <button
              type="button"
              @click="changeMinutes(15)"
              class="p-1 hover:bg-primary/10 rounded-lg transition-colors text-text-muted hover:text-primary"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 15 12 9 6 15"/></svg>
            </button>
            <div class="w-14 h-12 flex items-center justify-center bg-background border border-border rounded-lg font-black text-2xl text-text tabular-nums">
              {{ minutesDisplay }}
            </div>
            <button
              type="button"
              @click="changeMinutes(-15)"
              class="p-1 hover:bg-primary/10 rounded-lg transition-colors text-text-muted hover:text-primary"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <span class="text-[8px] font-black uppercase text-text-muted tracking-widest">Minutos</span>
          </div>
        </div>

        <button
          type="button"
          @click="isOpen = false"
          class="mt-3 w-full py-2 text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-primary/10 rounded-lg transition-colors"
        >
          Cerrar
        </button>
      </div>
    </Teleport>

    <p v-if="error" class="text-[10px] text-error font-bold uppercase mt-1 animate-in fade-in slide-in-from-top-1 duration-200">
      {{ error }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue'

const props = defineProps<{
  modelValue: string  // formato "HH:MM"
  disabled?: boolean
  error?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

const isOpen = ref(false)
const isDeleting = ref(false)
const containerRef = ref<HTMLElement | null>(null)
const dropdownRef = ref<HTMLElement | null>(null)
const inputRef = ref<HTMLInputElement | null>(null)
const dropdownStyle = ref<any>({})

// Parsear horas y minutos del modelValue
const hours = ref(17)
const minutes = ref(0)

const hoursDisplay = computed(() => String(hours.value).padStart(2, '0'))
const minutesDisplay = computed(() => String(minutes.value).padStart(2, '0'))
const displayValue = ref('17:00')

// Sincronizar desde props
watch(() => props.modelValue, (val) => {
  if (val && /^\d{2}:\d{2}$/.test(val)) {
    const [h, m] = val.split(':').map(Number)
    hours.value = h
    minutes.value = m
    displayValue.value = val
  }
}, { immediate: true })

// Sincronizar spinners → display → emit
watch([hours, minutes], () => {
  const val = `${hoursDisplay.value}:${minutesDisplay.value}`
  displayValue.value = val
  emit('update:modelValue', val)
})

const changeHours = (delta: number) => {
  hours.value = ((hours.value + delta) + 24) % 24
}

const changeMinutes = (delta: number) => {
  // Avanza/retrocede de a 15 minutos: 0, 15, 30, 45
  const steps = [0, 15, 30, 45]
  const currentIdx = steps.findIndex(s => s === minutes.value)
  if (currentIdx === -1) {
    minutes.value = delta > 0 ? 15 : 45
  } else {
    const nextIdx = ((currentIdx + (delta > 0 ? 1 : -1)) + steps.length) % steps.length
    minutes.value = steps[nextIdx]
  }
}

const handleKeyDown = (e: KeyboardEvent) => {
  isDeleting.value = e.key === 'Backspace' || e.key === 'Delete'
}

const handleInput = (e: Event) => {
  const target = e.target as HTMLInputElement
  const digits = target.value.replace(/\D/g, '')
  let formatted = ''

  if (digits.length > 0) {
    formatted = digits.substring(0, 2)
    if (digits.length > 2 || (digits.length === 2 && !isDeleting.value)) {
      formatted += ':'
    }
    if (digits.length > 2) {
      formatted += digits.substring(2, 4)
    }
  }
  displayValue.value = formatted

  // Intentar parsear
  if (/^\d{2}:\d{2}$/.test(formatted)) {
    const [h, m] = formatted.split(':').map(Number)
    if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
      hours.value = h
      minutes.value = m
      emit('update:modelValue', formatted)
    }
  }
}

const handleBlur = () => {
  // Al perder el foco, restablecer al último valor válido
  displayValue.value = `${hoursDisplay.value}:${minutesDisplay.value}`
}

const toggleDropdown = async () => {
  isOpen.value = !isOpen.value
  if (isOpen.value) {
    await nextTick()
    updateDropdownPosition()
  }
}

const updateDropdownPosition = () => {
  if (!containerRef.value || !dropdownRef.value) return
  const rect = containerRef.value.getBoundingClientRect()
  const dropdownHeight = dropdownRef.value.offsetHeight || 240
  const spaceBelow = window.innerHeight - rect.bottom

  let top = rect.bottom + 8
  if (spaceBelow < dropdownHeight && rect.top > dropdownHeight) {
    top = rect.top - dropdownHeight - 8
  }

  let left = rect.left
  const dropdownWidth = 180
  if (left + dropdownWidth > window.innerWidth) {
    left = window.innerWidth - dropdownWidth - 16
  }

  dropdownStyle.value = { top: `${top}px`, left: `${left}px`, width: `${dropdownWidth}px` }
}

const handleClickOutside = (e: MouseEvent) => {
  if (containerRef.value && !containerRef.value.contains(e.target as Node) &&
      dropdownRef.value && !dropdownRef.value.contains(e.target as Node)) {
    isOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('mousedown', handleClickOutside)
  window.addEventListener('resize', updateDropdownPosition)
  window.addEventListener('scroll', updateDropdownPosition, true)
})

onUnmounted(() => {
  document.removeEventListener('mousedown', handleClickOutside)
  window.removeEventListener('resize', updateDropdownPosition)
  window.removeEventListener('scroll', updateDropdownPosition, true)
})
</script>
