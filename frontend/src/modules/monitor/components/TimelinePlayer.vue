<template>
  <HudCard customClass="p-1 px-2 duration-300">
    <!-- Essential Visibility Row (Integrated Controls) -->
    <div class="flex items-center gap-2">
      <!-- Mini Playback Group -->
      <div class="flex items-center gap-0.5 bg-black/5 dark:bg-white/5 p-0.5 rounded-lg border border-white/5">
        <button @click="$emit('prev')" class="p-1 text-gray-500 hover:text-indigo-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/>
          </svg>
        </button>
        
        <button
          @click="$emit('toggle-play')"
          class="h-5 w-5 flex items-center justify-center rounded-lg bg-indigo-500 text-white shadow-lg shadow-indigo-500/20 hover:bg-indigo-600 transition-all active:scale-90"
        >
          <svg v-if="isPlaying" xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M6 4h4v16H6V4zm8 0h4v16h-4V4z" />
          </svg>
          <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M8 5v14l11-7z" />
          </svg>
        </button>

        <button @click="$emit('next')" class="p-1 text-gray-500 hover:text-indigo-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
            <path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/>
          </svg>
        </button>
      </div>

      <!-- Compact Progress Area -->
      <div class="flex-1 relative flex items-center h-4">
        <div class="absolute inset-x-0 h-0.5 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
          <div 
            class="h-full bg-indigo-500 rounded-full transition-all duration-300"
            :style="{ width: `${(currentIndex / maxIndex) * 100}%` }"
          ></div>
        </div>
        
        <input
          type="range"
          :min="0"
          :max="maxIndex"
          :value="currentIndex"
          @input="$emit('update:index', Number(($event.target as HTMLInputElement).value))"
          class="relative w-full h-full bg-transparent appearance-none cursor-pointer z-10"
        />
      </div>

      <!-- Telemetry Info -->
      <div class="flex items-center gap-1.5 min-w-[40px] justify-end">
        <span class="font-black text-gray-900 dark:text-gray-300 tabular-nums tracking-tighter opacity-80" :style="{ fontSize: 'calc(8px + var(--hud-font-offset))' }">
          {{ Math.round((currentIndex / maxIndex) * 100) }}%
        </span>
      </div>

      <!-- Expand Toggle -->
      <button 
        @click="$emit('toggle-expand')"
        class="p-1 text-gray-400 hover:text-indigo-500 transition-colors"
      >
        <svg 
          xmlns="http://www.w3.org/2000/svg" 
          class="w-3 h-3 transition-transform duration-300" 
          :class="{ 'rotate-180 text-indigo-500': isExpanded }"
          viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"
        >
          <path d="M18 15l-6-6-6 6"/>
        </svg>
      </button>
    </div>

    <!-- Expansion Area (Options & Date) -->
    <Transition name="accordion">
      <div v-if="isExpanded" class="overflow-hidden">
        <div class="pt-2 mt-2 border-t border-gray-200/10 dark:border-white/5 flex items-center justify-between gap-4">
          <!-- Speed Mini-Group -->
          <div class="flex gap-0.5 bg-black/5 dark:bg-white/5 p-0.5 rounded-lg border border-white/5">
            <button 
              v-for="s in [1, 2, 5, 10]" 
              :key="s"
              @click="$emit('update:speed', s)"
              class="px-1.5 py-0.5 font-black rounded-md transition-all uppercase tracking-tighter"
              :class="speed === s ? 'bg-indigo-500 text-white shadow-md shadow-indigo-500/20' : 'text-gray-400 hover:text-gray-600'"
              :style="{ fontSize: 'calc(6px + var(--hud-font-offset))' }"
            >
              {{ s }}x
            </button>
          </div>

          <div class="flex-1 text-center">
             <span class="font-black text-gray-400 uppercase tracking-widest" :style="{ fontSize: 'calc(7px + var(--hud-font-offset))' }">{{ startDate }} — {{ endDate }}</span>
          </div>

          <!-- Date Trigger -->
          <button 
            @click="openDatePicker"
            class="p-1 bg-white/5 dark:bg-black/20 text-gray-500 hover:text-indigo-500 rounded-lg transition-all border border-white/5"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
          </button>
          <flat-pickr v-model="internalDate" :config="fpConfig" class="hidden" ref="datepicker" />
        </div>
      </div>
    </Transition>
  </HudCard>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import HudCard from './HudCard.vue'
import flatPickr from 'vue-flatpickr-component'
import 'flatpickr/dist/flatpickr.css'
import 'flatpickr/dist/themes/material_blue.css' 

const props = defineProps<{
  currentIndex: number
  maxIndex: number
  currentTime: string
  isPlaying: boolean
  speed: number
  startDate: string
  endDate: string
}>()

const emit = defineEmits(['update:index', 'toggle-play', 'update:speed', 'prev', 'next', 'skip-start', 'skip-end', 'select-date', 'toggle-expand'])

const isExpanded = ref(false)
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
  if (!iso) return '--/--'
  const date = new Date(iso)
  return `${date.getDate()}/${date.getMonth()+1} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

watch(() => props.currentTime, (newVal) => {
  if (newVal) {
    internalDate.value = newVal.split('T')[0]
  }
})
</script>

<style scoped>
.accordion-enter-active,
.accordion-leave-active {
  transition: all 0.3s ease-in-out;
  max-height: 100px;
}

.accordion-enter-from,
.accordion-leave-to {
  max-height: 0;
  opacity: 0;
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom-width: 0;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

input[type='range']::-webkit-slider-thumb {
  -webkit-appearance: none;
  height: 12px;
  width: 12px;
  border-radius: 50%;
  background: white;
  border: 2px solid var(--color-brand-500);
  cursor: pointer;
  box-shadow: 0 2px 4px -1px rgb(0 0 0 / 0.2);
  transition: all 0.2s ease;
  z-index: 20;
}

input[type='range']:hover::-webkit-slider-thumb {
  transform: scale(1.1);
}

input[type='range']::-moz-range-thumb {
  height: 12px;
  width: 12px;
  border-radius: 50%;
  background: white;
  border: 2px solid var(--color-brand-500);
  cursor: pointer;
  box-shadow: 0 2px 4px -1px rgb(0 0 0 / 0.2);
  z-index: 20;
}
</style>
