<template>
  <div
    class="pointer-events-auto w-52 bg-white/70 dark:bg-gray-900/70 backdrop-blur-xl rounded-xl border border-white/20 dark:border-white/10 shadow-xl overflow-hidden flex flex-col transition-all"
  >
    <div class="p-3 border-b border-gray-200/30 dark:border-white/5 flex flex-col items-center gap-0.5">
      <h3 class="text-[10px] font-black uppercase tracking-widest text-gray-900 dark:text-white">
        {{ stages.length }} ETAPAS
      </h3>
      <p class="text-[7px] font-bold text-gray-400 uppercase tracking-tight">
        {{ totalDays }} días navegados
      </p>
    </div>

    <!-- Scrollable Area -->
    <div class="p-2.5 flex flex-col gap-2 overflow-y-auto max-h-[40vh] scrollbar-hide">
      <div 
        v-for="(stage, index) in stages" 
        :key="index"
        @click="$emit('select-stage', stage)"
        class="group relative flex flex-col gap-1.5 p-2.5 rounded-lg bg-white/50 dark:bg-black/30 border border-gray-100 dark:border-white/5 hover:border-brand-500/50 transition-all cursor-pointer shadow-sm hover:shadow-md"
      >
        <!-- Color left border -->
        <div 
          class="absolute left-0 top-2 bottom-2 w-1 rounded-r-md"
          :style="{ backgroundColor: stage.color || '#3b82f6' }"
        ></div>

        <div class="flex items-center justify-between ml-1.5">
          <span class="text-[9px] font-black text-gray-900 dark:text-white uppercase tracking-tight" :style="{ color: stage.color }">
            Etapa {{ index + 1 }}
          </span>
          <span class="text-[8px] font-black px-1.5 py-0.5 rounded-full bg-gray-100 dark:bg-gray-800 text-gray-500">
            {{ stage.durationDays }} d
          </span>
        </div>

        <div class="ml-1.5 flex flex-col gap-0.5 text-[8px]">
          <div class="flex items-center gap-1.5">
            <span class="text-gray-400 font-bold uppercase w-8">Zar:</span>
            <span class="text-gray-700 dark:text-gray-300">{{ formatDate(stage.startDate) }} {{ formatTime(stage.startDate) }}</span>
          </div>
          <div class="flex items-center gap-1.5">
            <span class="text-gray-400 font-bold uppercase w-8">Arr:</span>
            <span class="text-gray-700 dark:text-gray-300">{{ formatDate(stage.endDate) }} {{ formatTime(stage.endDate) }}</span>
          </div>
        </div>

        <!-- Action Icons (Mock) -->
        <div class="flex items-center gap-2.5 ml-1.5 mt-0.5">
          <button class="text-gray-400 hover:text-brand-500 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M12 20v-6M9 20v-10M15 20v-4M18 20v-8M21 20v-12M6 20v-12M3 20v-14"/>
            </svg>
          </button>
          <button class="text-gray-400 hover:text-brand-500 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <circle cx="12" cy="12" r="10"/><path d="M12 8l4 4-4 4M8 12h7"/>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
export interface TripStage {
  id: string
  startDate: string
  endDate: string
  durationDays: number
  color?: string
}

const props = defineProps<{
  stages: TripStage[]
  totalDays: number
}>()

defineEmits(['select-stage'])

const formatDate = (ts: string) => {
  if (!ts) return '--/--'
  const date = new Date(ts)
  return `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}`
}

const formatTime = (ts: string) => {
  if (!ts) return '--:--'
  return new Date(ts).toLocaleTimeString('es-AR', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: false
  })
}
</script>

<style scoped>
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
