<template>
  <div
    class="bg-white/60 dark:bg-gray-900/60 backdrop-blur-xl border border-gray-200/50 dark:border-white/10 rounded-2xl p-4 shadow-2xl"
  >
    <div class="flex items-center gap-6">
      <!-- Play/Pause & Speed -->
      <div class="flex items-center gap-2 pr-6 border-r border-gray-100 dark:border-gray-800">
        <button
          @click="$emit('toggle-play')"
          class="h-10 w-10 flex items-center justify-center rounded-xl bg-brand-500 text-white shadow-lg shadow-brand-500/30 hover:bg-brand-600 transition-all"
        >
          <svg
            v-if="isPlaying"
            xmlns="http://www.w3.org/2000/svg"
            class="w-5 h-5"
            fill="currentColor"
            viewBox="0 0 24 24"
          >
            <path d="M6 4h4v16H6V4zm8 0h4v16h-4V4z" />
          </svg>
          <svg
            v-else
            xmlns="http://www.w3.org/2000/svg"
            class="w-5 h-5"
            fill="currentColor"
            viewBox="0 0 24 24"
          >
            <path d="M8 5v14l11-7z" />
          </svg>
        </button>

        <select
          :value="speed"
          @change="$emit('update:speed', Number(($event.target as HTMLSelectElement).value))"
          class="bg-gray-50 dark:bg-gray-800 border-none rounded-lg text-[10px] font-black uppercase py-1 px-2 focus:ring-0"
        >
          <option :value="1">1x</option>
          <option :value="2">2x</option>
          <option :value="5">5x</option>
          <option :value="10">10x</option>
        </select>
      </div>

      <!-- Slider & Time -->
      <div class="flex-1">
        <div class="flex items-center justify-between mb-2">
          <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest"
            >Línea de Tiempo</span
          >
          <span class="text-xs font-black text-gray-800 dark:text-gray-200 tabular-nums">
            {{ formatTime(currentTime) }}
          </span>
        </div>
        <input
          type="range"
          :min="0"
          :max="maxIndex"
          :value="currentIndex"
          @input="$emit('update:index', Number(($event.target as HTMLInputElement).value))"
          class="w-full h-1.5 bg-gray-100 dark:bg-gray-800 rounded-lg appearance-none cursor-pointer accent-brand-500"
        />
        <div class="flex justify-between mt-1">
          <span class="text-[9px] text-gray-400 font-medium">{{ startDate }}</span>
          <span class="text-[9px] text-gray-400 font-medium">{{ endDate }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  currentIndex: number
  maxIndex: number
  currentTime: string
  isPlaying: boolean
  speed: number
  startDate: string
  endDate: string
}>()

defineEmits(['update:index', 'toggle-play', 'update:speed'])

const formatTime = (iso: string) => {
  if (!iso) return '--:--:--'
  const date = new Date(iso)
  return date.toLocaleString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false,
  })
}
</script>

<style scoped>
input[type='range']::-webkit-slider-thumb {
  -webkit-appearance: none;
  height: 14px;
  width: 14px;
  border-radius: 50%;
  background: white;
  border: 2px solid var(--color-brand-500);
  cursor: pointer;
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
}
</style>
