<template>
  <div
    class="pointer-events-auto bg-white/70 dark:bg-gray-900/70 backdrop-blur-xl border border-white/20 dark:border-white/10 rounded-2xl p-4 shadow-2xl flex flex-col gap-4"
  >
    <div class="flex items-center gap-6">
      <!-- Playback Controls -->
      <div class="flex items-center gap-2">
        <button @click="$emit('skip-start')" class="p-2 text-gray-500 hover:text-brand-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M6 6h2v12H6zm3.5 6l8.5 6V6z"/>
          </svg>
        </button>
        <button @click="$emit('prev')" class="p-2 text-gray-500 hover:text-brand-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/>
          </svg>
        </button>
        
        <button
          @click="$emit('toggle-play')"
          class="h-12 w-12 flex items-center justify-center rounded-full bg-brand-500 text-white shadow-lg shadow-brand-500/30 hover:bg-brand-600 transition-all transform active:scale-95"
        >
          <svg v-if="isPlaying" xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
            <path d="M6 4h4v16H6V4zm8 0h4v16h-4V4z" />
          </svg>
          <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
            <path d="M8 5v14l11-7z" />
          </svg>
        </button>

        <button @click="$emit('next')" class="p-2 text-gray-500 hover:text-brand-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/>
          </svg>
        </button>
        <button @click="$emit('skip-end')" class="p-2 text-gray-500 hover:text-brand-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
            <path d="M6 18l8.5-6L6 6zM16 6h2v12h-2z"/>
          </svg>
        </button>
      </div>

      <!-- Speed Selector -->
      <div class="flex items-center gap-2 border-l border-gray-200/30 dark:border-white/5 pl-6">
        <span class="text-[9px] font-black uppercase tracking-tight text-gray-400">Velocidad</span>
        <div class="flex gap-1 bg-gray-100 dark:bg-black/20 p-1 rounded-lg">
          <button 
            v-for="s in [1, 2, 5, 10]" 
            :key="s"
            @click="$emit('update:speed', s)"
            class="px-2 py-1 text-[9px] font-black rounded-md transition-all"
            :class="speed === s ? 'bg-white dark:bg-gray-800 text-brand-500 shadow-sm' : 'text-gray-400 hover:text-gray-600 dark:hover:text-gray-200'"
          >
            {{ s }}x
          </button>
        </div>
      </div>

      <!-- Spacer -->
      <div class="flex-1"></div>

      <!-- Date Picker Trigger -->
      <div class="relative">
        <flat-pickr
          v-model="internalDate"
          :config="fpConfig"
          class="hidden"
          ref="datepicker"
        />
        <button 
          @click="openDatePicker"
          class="p-2.5 bg-gray-50 dark:bg-gray-800 text-gray-500 hover:text-brand-500 rounded-xl transition-all border border-gray-200/50 dark:border-white/5 shadow-sm"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- Timeline Slider -->
    <div class="relative px-2 pb-2">
      <div class="flex items-center justify-between mb-4">
        <span class="text-[10px] font-black uppercase tracking-widest text-gray-400">Timeline / {{ formatTime(currentTime) }}</span>
      </div>
      
      <div class="relative h-1 w-full bg-gray-100 dark:bg-gray-800 rounded-full flex items-center group">
        <!-- Progress Line (Mock) -->
        <div 
          class="absolute left-0 top-0 h-full bg-brand-500 rounded-full transition-all duration-300"
          :style="{ width: `${(currentIndex / maxIndex) * 100}%` }"
        ></div>
        
        <input
          type="range"
          :min="0"
          :max="maxIndex"
          :value="currentIndex"
          @input="$emit('update:index', Number(($event.target as HTMLInputElement).value))"
          class="absolute w-full h-full bg-transparent appearance-none cursor-pointer z-10"
        />
        
        <!-- Thumb is handled via CSS -->
      </div>
      
      <div class="flex justify-between mt-3 px-1">
        <span class="text-[9px] text-gray-400 font-bold uppercase">{{ startDate }}</span>
        <span class="text-[9px] text-gray-400 font-bold uppercase">{{ endDate }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import flatPickr from 'vue-flatpickr-component'
import 'flatpickr/dist/flatpickr.css'
import 'flatpickr/dist/themes/dark.css' // Optional if we want to force dark

const props = defineProps<{
  currentIndex: number
  maxIndex: number
  currentTime: string
  isPlaying: boolean
  speed: number
  startDate: string
  endDate: string
}>()

const emit = defineEmits(['update:index', 'toggle-play', 'update:speed', 'prev', 'next', 'skip-start', 'skip-end', 'select-date'])

const internalDate = ref('')
const datepicker = ref<any>(null)

const fpConfig = {
  inline: false,
  dateFormat: 'Y-m-d',
  allowInput: true,
  onChange: (selectedDates: Date[]) => {
    if (selectedDates.length) {
      emit('select-date', selectedDates[0])
    }
  }
}

const openDatePicker = () => {
  if (datepicker.value && datepicker.value.fp) {
    datepicker.value.fp.open()
  }
}

const formatTime = (iso: string) => {
  if (!iso) return '--/-- --:--'
  const date = new Date(iso)
  return date.toLocaleString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  })
}

watch(() => props.currentTime, (newVal) => {
  if (newVal) {
    internalDate.value = newVal.split('T')[0]
  }
})
</script>

<script lang="ts">
// Extra styles for the range input to make it look premium
</script>

<style scoped>
input[type='range']::-webkit-slider-thumb {
  -webkit-appearance: none;
  height: 16px;
  width: 16px;
  border-radius: 50%;
  background: white;
  border: 3px solid var(--color-brand-500);
  cursor: pointer;
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.2);
  transition: all 0.2s ease;
  z-index: 20;
}

input[type='range']:hover::-webkit-slider-thumb {
  transform: scale(1.1);
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2);
}

input[type='range']::-moz-range-thumb {
  height: 16px;
  width: 16px;
  border-radius: 50%;
  background: white;
  border: 3px solid var(--color-brand-500);
  cursor: pointer;
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.2);
  z-index: 20;
}
</style>
