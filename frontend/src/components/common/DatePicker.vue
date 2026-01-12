<template>
  <div class="relative w-full" ref="containerRef">
    <!-- Input Field -->
    <div class="relative group">
      <input
        ref="inputRef"
        type="text"
        v-model="displayValue"
        @input="handleManualInput"
        @keydown="handleKeyDown"
        :placeholder="showTime ? 'DD/MM/YYYY HH:MM' : 'DD/MM/YYYY'"
        class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-900 border rounded-lg text-sm text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all cursor-text placeholder:text-gray-400 caret-brand-500"
        style="color-scheme: light dark;"
        :class="[
          error ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800',
          { 'pl-10': icon }
        ]"
      />
      <div 
        v-if="icon" 
        class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none" 
        :class="error ? 'text-red-500' : 'text-gray-400'"
      >
        <component :is="icon" class="w-4 h-4" />
      </div>
      
      <button 
        type="button" 
        @click="toggleCalendar"
        class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-brand-500 transition-colors"
      >
        <CalenderIcon class="w-4 h-4" v-if="!isOpen" />
        <ChevronDownIcon class="w-4 h-4 transition-transform rotate-180" v-else />
      </button>
    </div>

    <!-- Calendar Dropdown -->
    <Teleport to="body">
      <div 
        v-if="isOpen"
        ref="dropdownRef"
        class="fixed z-[200000] mt-2 bg-white dark:bg-gray-950 border border-gray-200 dark:border-gray-800 rounded-xl shadow-2xl p-4 w-[320px] animate-in fade-in zoom-in-95 duration-200"
        :style="dropdownStyle"
      >
        <!-- Header: Month & Year Picker -->
        <div class="flex items-center justify-between mb-4">
          <button @click="changeMonth(-1)" class="p-1.5 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors">
            <ArrowLeftIcon class="w-4 h-4 text-gray-500" />
          </button>
          <div class="flex items-center gap-1 font-bold text-sm text-gray-800 dark:text-white">
            <span>{{ monthNames[viewDate.getMonth()] }}</span>
            <span>{{ viewDate.getFullYear() }}</span>
          </div>
          <button @click="changeMonth(1)" class="p-1.5 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors">
            <ChevronRightIcon class="w-4 h-4 text-gray-500" />
          </button>
        </div>

        <!-- Weekdays Header -->
        <div class="grid grid-cols-7 mb-2">
          <div v-for="day in dayNames" :key="day" class="text-center text-[10px] font-black uppercase tracking-widest text-gray-400 py-1">
            {{ day }}
          </div>
        </div>

        <!-- Days Grid -->
        <div class="grid grid-cols-7 gap-1">
          <button
            v-for="date in calendarDays"
            :key="date.iso"
            @click="selectDate(date.date)"
            class="aspect-square flex items-center justify-center text-xs rounded-lg transition-all"
            :class="[
              date.isCurrentMonth ? 'text-gray-800 dark:text-gray-200' : 'text-gray-300 dark:text-gray-600',
              date.isSelected ? 'bg-brand-500 text-white font-bold shadow-lg shadow-brand-500/20' : 'hover:bg-gray-100 dark:hover:bg-gray-800',
              date.isToday && !date.isSelected ? 'border border-brand-200 dark:border-brand-800 text-brand-500' : ''
            ]"
          >
            {{ date.day }}
          </button>
        </div>

        <!-- Time Picker (Optional) -->
        <div v-if="showTime" class="mt-4 pt-4 border-t border-gray-100 dark:border-gray-800">
          <div class="flex items-center justify-center gap-4">
            <div class="flex flex-col items-center">
              <input 
                type="number" 
                v-model="hours" 
                min="0" max="23"
                class="w-12 h-10 text-center bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-lg text-sm font-bold focus:border-brand-500 outline-none"
              />
              <span class="text-[8px] font-black uppercase text-gray-400 mt-1">Horas</span>
            </div>
            <span class="text-gray-400 font-bold">:</span>
            <div class="flex flex-col items-center">
              <input 
                type="number" 
                v-model="minutes" 
                min="0" max="59"
                class="w-12 h-10 text-center bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-lg text-sm font-bold focus:border-brand-500 outline-none"
              />
              <span class="text-[8px] font-black uppercase text-gray-400 mt-1">Minutos</span>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div class="mt-4 flex justify-between gap-2">
          <button @click="setToday" class="flex-1 py-2 text-[10px] font-black uppercase tracking-widest text-brand-500 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-lg transition-colors">
            Hoy
          </button>
          <button @click="closeCalendar" class="flex-1 py-2 text-[10px] font-black uppercase tracking-widest text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors">
            Cerrar
          </button>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue'
import { 
  ArrowLeftIcon, 
  ChevronRightIcon, 
  ChevronDownIcon,
  CalenderIcon 
} from '@/icons'

const props = defineProps<{
  modelValue: string | null
  showTime?: boolean
  icon?: any
  error?: string
  placeholder?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string | null): void
}>()

// State
const isOpen = ref(false)
const isDeleting = ref(false)
const containerRef = ref<HTMLElement | null>(null)
const dropdownRef = ref<HTMLElement | null>(null)
const viewDate = ref(new Date())
const selectedDate = ref<Date | null>(null)
const displayValue = ref('')
const inputRef = ref<HTMLInputElement | null>(null)

const focus = () => {
  if (inputRef.value) {
    inputRef.value.focus()
    inputRef.value.select()
  }
}

defineExpose({ focus })

// Dropdown positioning
const dropdownStyle = ref<any>({})

// Time state
const hours = ref(0)
const minutes = ref(0)

// Constants
const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
const dayNames = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb']

// Helpers
const formatDate = (date: Date | null) => {
  if (!date) return ''
  const d = date.getDate().toString().padStart(2, '0')
  const m = (date.getMonth() + 1).toString().padStart(2, '0')
  const y = date.getFullYear()
  if (props.showTime) {
    const hh = date.getHours().toString().padStart(2, '0')
    const mm = date.getMinutes().toString().padStart(2, '0')
    return `${d}/${m}/${y} ${hh}:${mm}`
  }
  return `${d}/${m}/${y}`
}

const parseDate = (str: string) => {
  const parts = str.split(/[/\s:]/)
  if (parts.length < 3) return null
  const d = parseInt(parts[0])
  const m = parseInt(parts[1]) - 1
  const yPart = parts[2]
  if (yPart.length < 4) return null // Don't parse until year is complete
  const y = parseInt(yPart)
  let hh = 0
  let mm = 0
  if (props.showTime && parts.length >= 5) {
    if (parts[4].length < 2) return null // Minutes incomplete
    hh = parseInt(parts[3])
    mm = parseInt(parts[4])
  } else if (selectedDate.value) {
    hh = selectedDate.value.getHours()
    mm = selectedDate.value.getMinutes()
  }
  const date = new Date(y, m, d, hh, mm)
  return isNaN(date.getTime()) ? null : date
}

const isSameDay = (d1: Date | null, d2: Date | null) => {
  if (!d1 || !d2) return false
  return d1.getDate() === d2.getDate() && 
         d1.getMonth() === d2.getMonth() && 
         d1.getFullYear() === d2.getFullYear()
}

// Watchers
watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    const date = new Date(newVal)
    if (!isNaN(date.getTime())) {
      selectedDate.value = date
      viewDate.value = new Date(date)
      displayValue.value = formatDate(date)
      hours.value = date.getHours()
      minutes.value = date.getMinutes()
    }
  } else {
    selectedDate.value = null
    displayValue.value = ''
  }
}, { immediate: true })

watch([hours, minutes], () => {
  if (selectedDate.value && props.showTime) {
    const newDate = new Date(selectedDate.value)
    newDate.setHours(hours.value)
    newDate.setMinutes(minutes.value)
    if (newDate.toISOString() !== props.modelValue) {
      selectedDate.value = newDate
      emit('update:modelValue', newDate.toISOString())
      displayValue.value = formatDate(newDate)
    }
  }
})

// Computed Calendar Days
const calendarDays = computed(() => {
  const year = viewDate.value.getFullYear()
  const month = viewDate.value.getMonth()
  
  const firstDay = new Date(year, month, 1)
  const lastDay = new Date(year, month + 1, 0)
  
  const days: any[] = []
  const prevMonthLastDay = new Date(year, month, 0)
  const startOffset = firstDay.getDay()
  
  for (let i = startOffset - 1; i >= 0; i--) {
    const d = new Date(year, month - 1, prevMonthLastDay.getDate() - i)
    days.push({
      date: d,
      day: d.getDate(),
      isCurrentMonth: false,
      iso: d.toISOString(),
      isSelected: isSameDay(d, selectedDate.value),
      isToday: isSameDay(d, new Date())
    })
  }
  
  for (let i = 1; i <= lastDay.getDate(); i++) {
    const d = new Date(year, month, i)
    days.push({
      date: d,
      day: i,
      isCurrentMonth: true,
      iso: d.toISOString(),
      isSelected: isSameDay(d, selectedDate.value),
      isToday: isSameDay(d, new Date())
    })
  }
  
  const remaining = 42 - days.length
  for (let i = 1; i <= remaining; i++) {
    const d = new Date(year, month + 1, i)
    days.push({
      date: d,
      day: i,
      isCurrentMonth: false,
      iso: d.toISOString(),
      isSelected: isSameDay(d, selectedDate.value),
      isToday: isSameDay(d, new Date())
    })
  }
  
  return days
})

// Methods
const toggleCalendar = () => {
  if (isOpen.value) closeCalendar()
  else openCalendar()
}

const openCalendar = async () => {
  isOpen.value = true
  await nextTick()
  updateDropdownPosition()
}

const closeCalendar = () => {
  isOpen.value = false
}

const selectDate = (date: Date) => {
  const newDate = new Date(date)
  newDate.setHours(hours.value)
  newDate.setMinutes(minutes.value)
  selectedDate.value = newDate
  emit('update:modelValue', newDate.toISOString())
  displayValue.value = formatDate(newDate)
  if (!props.showTime) closeCalendar()
}

const changeMonth = (delta: number) => {
  const newDate = new Date(viewDate.value)
  newDate.setMonth(newDate.getMonth() + delta)
  viewDate.value = newDate
}

const setToday = () => {
  const today = new Date()
  selectDate(today)
  viewDate.value = new Date(today)
}

const handleKeyDown = (e: KeyboardEvent) => {
  isDeleting.value = e.key === 'Backspace' || e.key === 'Delete'
}

const handleManualInput = (e: Event) => {
  const target = e.target as HTMLInputElement
  const cursorPosition = target.selectionStart || 0
  const originalValue = target.value
  
  // Extract only digits
  const digits = originalValue.replace(/\D/g, '')
  let formatted = ''
  
  if (digits.length > 0) {
    // Day
    formatted = digits.substring(0, 2)
    if (digits.length > 2 || (digits.length === 2 && !isDeleting.value)) {
      formatted += '/'
    }
    
    // Month
    if (digits.length > 2) {
      formatted += digits.substring(2, 4)
      if (digits.length > 4 || (digits.length === 4 && !isDeleting.value)) {
        formatted += '/'
      }
      
      // Year
      if (digits.length > 4) {
        formatted += digits.substring(4, 8)
        
        // Time
        if (props.showTime && digits.length > 8) {
          if (digits.length > 8 || (digits.length === 8 && !isDeleting.value)) {
            formatted += ' '
          }
          formatted += digits.substring(8, 10)
          if (digits.length > 10 || (digits.length === 10 && !isDeleting.value)) {
            formatted += ':'
          }
          formatted += digits.substring(10, 12)
        }
      }
    }
  }
  
  displayValue.value = formatted
  
  // Adjust cursor position
  nextTick(() => {
    let newPos = cursorPosition
    
    // If we just auto-added a separator, move cursor past it
    const lastChar = formatted.charAt(newPos - 1)
    if (!isDeleting.value && (lastChar === '/' || lastChar === ' ' || lastChar === ':')) {
       newPos++
    }
    
    target.setSelectionRange(newPos, newPos)
  })

  // Try to parse and emit if complete
  const parsed = parseDate(formatted)
  if (parsed) {
    selectedDate.value = parsed
    emit('update:modelValue', parsed.toISOString())
  } else if (!formatted) {
    selectedDate.value = null
    emit('update:modelValue', null)
  }
}

const updateDropdownPosition = () => {
  if (!containerRef.value) return
  const rect = containerRef.value.getBoundingClientRect()
  dropdownStyle.value = {
    top: `${rect.bottom}px`,
    left: `${rect.left}px`,
  }
}

// Click outside
const handleClickOutside = (e: MouseEvent) => {
  if (containerRef.value && !containerRef.value.contains(e.target as Node) &&
      dropdownRef.value && !dropdownRef.value.contains(e.target as Node)) {
    closeCalendar()
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

