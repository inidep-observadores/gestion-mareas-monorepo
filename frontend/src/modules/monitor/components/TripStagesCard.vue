<template>
  <HudCard customClass="w-[210px]">
    <div class="p-3 border-b border-border/10 flex flex-col items-center gap-0 bg-surface/5 group/card cursor-pointer" @click="isCollapsed = !isCollapsed">
      <div class="flex items-center justify-between w-full">
        <div class="flex flex-col">
          <h3 class="font-black uppercase tracking-[0.2em] text-text text-[10px]">
            {{ stages.length }} ETAPAS
          </h3>
          <p v-if="!isCollapsed" class="font-bold text-text-muted/60 uppercase tracking-tighter text-[9px]">
            {{ totalDays }} días navegados
          </p>
        </div>
        <div
          class="shrink-0 p-1.5 bg-primary/10 rounded-lg border border-primary/20 text-primary transition-transform duration-300"
          :class="{ 'rotate-180': isCollapsed }"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
            <path d="M19 9l-7 7-7-7"/>
          </svg>
        </div>
      </div>
    </div>

    <!-- Scrollable Area -->
    <div v-show="!isCollapsed" class="p-2 flex flex-col gap-2 overflow-y-auto max-h-[35vh] custom-scrollbar">
      <div
        v-for="(stage, index) in stages"
        :key="index"
        @click="$emit('select-stage', stage)"
        class="group relative flex flex-col gap-1.5 p-3 rounded-xl bg-surface/5 border border-border/5 hover:border-primary/30 transition-all cursor-pointer"
      >
        <!-- Color left border indicator -->
        <div
          class="absolute left-0 top-1.5 bottom-1.5 w-0.5 rounded-r-full opacity-60"
          :style="{ backgroundColor: stage.color || 'var(--color-primary)' }"
        ></div>

        <div class="flex items-center justify-between ml-1">
          <span class="font-black uppercase tracking-tighter text-xs" :style="{ color: stage.color }">
            Etapa {{ stage.nroEtapa || index + 1 }}
          </span>
          <span class="font-black px-2 py-0.5 rounded-lg bg-primary/10 text-primary border border-primary/20 shadow-[0_0_8px_rgba(var(--color-primary-rgb),0.1)] text-[10px]">
            {{ stage.durationDays ?? calculateDuration(stage.startDate, stage.endDate) }}d
          </span>
        </div>

        <div class="ml-1 flex flex-col gap-0.5 opacity-80 text-[10px]">
          <div
            class="flex items-center gap-2 group/date cursor-pointer hover:text-primary transition-colors"
            @click.stop="$emit('select-date', stage.startDate)"
          >
            <span class="text-text-muted font-black uppercase w-8 group-hover/date:text-primary/70">Zar:</span>
            <span class="text-text tabular-nums group-hover/date:underline decoration-primary/30 underline-offset-2">{{ formatDate(stage.startDate) }}</span>
          </div>
          <div
            class="flex items-center gap-2 group/date cursor-pointer hover:text-primary transition-colors"
            @click.stop="$emit('select-date', stage.endDate || new Date().toISOString())"
          >
            <span class="text-text-muted font-black uppercase w-8 group-hover/date:text-primary/70">Arr:</span>
            <span class="text-text tabular-nums group-hover/date:underline decoration-primary/30 underline-offset-2">
              <template v-if="stage.endDate">
                {{ formatDate(stage.endDate) }}
              </template>
              <template v-else>
                Actual (En Navegación)
              </template>
            </span>
          </div>
        </div>

      </div>
    </div>
  </HudCard>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import HudCard from './HudCard.vue'

export interface TripStage {
  id: string
  nroEtapa?: number
  startDate: string
  endDate: string | null
  durationDays?: number
  color?: string
}

const props = defineProps<{
  stages: TripStage[]
  totalDays: number
}>()

defineEmits(['select-stage', 'select-date'])

const calculateDuration = (start: string, end: string | null) => {
  const d1 = new Date(start)
  const d2 = end ? new Date(end) : new Date()
  const diff = d2.getTime() - d1.getTime()
  return Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)))
}

const isCollapsed = ref(false)

const formatDate = (ts: string) => {
  if (!ts) return '--/--/----'
  const date = new Date(ts)
  return `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
}
</script>
