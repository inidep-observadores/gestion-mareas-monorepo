<template>
  <div
    class="pointer-events-auto w-80 bg-white/70 dark:bg-gray-900/70 backdrop-blur-xl rounded-2xl border border-white/20 dark:border-white/10 shadow-2xl overflow-hidden flex flex-col transition-all"
  >
    <div class="p-5 border-b border-gray-200/30 dark:border-white/5 flex flex-col items-center gap-1">
      <h3 class="text-sm font-black uppercase tracking-widest text-gray-900 dark:text-white">
        {{ stages.length }} ETAPAS
      </h3>
      <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tight">
        {{ totalDays }} días navegados
      </p>
    </div>

    <!-- Scrollable Area -->
    <div class="p-4 flex flex-col gap-3 overflow-y-auto max-h-[50vh] scrollbar-hide">
      <div 
        v-for="(stage, index) in stages" 
        :key="index"
        @click="$emit('select-stage', stage)"
        class="group relative flex flex-col gap-2 p-4 rounded-xl bg-white/50 dark:bg-black/30 border border-gray-100 dark:border-white/5 hover:border-brand-500/50 transition-all cursor-pointer shadow-sm hover:shadow-md"
      >
        <!-- Color left border -->
        <div 
          class="absolute left-0 top-3 bottom-3 w-1 rounded-r-lg"
          :style="{ backgroundColor: stage.color || '#3b82f6' }"
        ></div>

        <div class="flex items-center justify-between ml-2">
          <span class="text-xs font-black text-gray-900 dark:text-white uppercase tracking-tight" :style="{ color: stage.color }">
            Etapa {{ index + 1 }}
          </span>
          <span class="text-[9px] font-black px-2 py-0.5 rounded-full bg-gray-100 dark:bg-gray-800 text-gray-500">
            {{ stage.durationDays }} días
          </span>
        </div>

        <div class="ml-2 flex flex-col gap-1">
          <div class="flex items-center gap-2 text-[10px]">
            <span class="text-gray-400 font-bold uppercase w-10">Zarpada:</span>
            <span class="text-gray-700 dark:text-gray-300">{{ formatDate(stage.startDate) }} {{ formatTime(stage.startDate) }}</span>
          </div>
          <div class="flex items-center gap-2 text-[10px]">
            <span class="text-gray-400 font-bold uppercase w-10">Arribo:</span>
            <span class="text-gray-700 dark:text-gray-300">{{ formatDate(stage.endDate) }} {{ formatTime(stage.endDate) }}</span>
          </div>
        </div>

        <!-- Action Icons (Mock) -->
        <div class="flex items-center gap-3 ml-2 mt-1">
          <button class="text-gray-400 hover:text-brand-500 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 20v-6M9 20v-10M15 20v-4M18 20v-8M21 20v-12M6 20v-12M3 20v-14"/>
            </svg>
          </button>
          <button class="text-gray-400 hover:text-brand-500 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
