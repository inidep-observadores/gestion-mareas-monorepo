<template>
  <HudCard customClass="w-44">
    <div class="p-2 border-b border-border/20 flex flex-col items-center gap-0 bg-surface/5">
      <h3 class="font-black uppercase tracking-[0.2em] text-text" :style="{ fontSize: 'calc(8px + var(--hud-font-offset))' }">
        {{ stages.length }} ETAPAS
      </h3>
      <p class="font-bold text-text-muted uppercase tracking-tighter" :style="{ fontSize: 'calc(6px + var(--hud-font-offset))' }">
        {{ totalDays }} días navegados
      </p>
    </div>

    <!-- Scrollable Area -->
    <div class="p-1.5 flex flex-col gap-1.5 overflow-y-auto max-h-[35vh] custom-scrollbar">
      <div
        v-for="(stage, index) in stages"
        :key="index"
        @click="$emit('select-stage', stage)"
        class="group relative flex flex-col gap-1 p-2 rounded-xl bg-surface/5 border border-border/10 hover:border-primary/30 transition-all cursor-pointer"
      >
        <!-- Color left border indicator -->
        <div
          class="absolute left-0 top-1 bottom-1 w-0.5 rounded-r-full opacity-60"
          :style="{ backgroundColor: stage.color || 'var(--color-primary)' }"
        ></div>

        <div class="flex items-center justify-between ml-1">
          <span class="font-black text-text uppercase tracking-tighter" :style="{ color: stage.color, fontSize: 'calc(8px + var(--hud-font-offset))' }">
            Etapa {{ index + 1 }}
          </span>
          <span class="font-black px-1.5 py-0.5 rounded-lg bg-primary/10 text-primary border border-primary/20 shadow-[0_0_8px_rgba(var(--color-primary-rgb),0.2)]" :style="{ fontSize: 'calc(7px + var(--hud-font-offset))' }">
            {{ stage.durationDays }}d
          </span>
        </div>

        <div class="ml-1 flex flex-col gap-0 opacity-80" :style="{ fontSize: 'calc(7px + var(--hud-font-offset))' }">
          <div class="flex items-center gap-1">
            <span class="text-text-muted font-black uppercase w-6">Zar:</span>
            <span class="text-text tabular-nums">{{ formatDate(stage.startDate) }} {{ formatTime(stage.startDate) }}</span>
          </div>
          <div class="flex items-center gap-1">
            <span class="text-text-muted font-black uppercase w-6">Arr:</span>
            <span class="text-text tabular-nums">{{ formatDate(stage.endDate) }} {{ formatTime(stage.endDate) }}</span>
          </div>
        </div>

        <!-- Action Icons -->
        <div class="flex items-center gap-2 ml-1 mt-0.5 pt-1 border-t border-border/10">
          <button class="text-text-muted hover:text-primary transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
              <path d="M12 20v-6M9 20v-10M15 20v-4M18 20v-8M21 20v-12M6 20v-12M3 20v-14"/>
            </svg>
          </button>
          <button class="text-text-muted hover:text-primary transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
              <circle cx="12" cy="12" r="10"/><path d="M12 8l4 4-4 4M8 12h7"/>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </HudCard>
</template>

<script setup lang="ts">
import HudCard from './HudCard.vue'

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
