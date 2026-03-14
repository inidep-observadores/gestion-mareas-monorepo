<template>
  <div 
    @click="$emit('select-status', status.label)"
    class="group relative flex flex-col items-center p-4 rounded-2xl bg-surface-muted/50 border border-border hover:bg-surface hover:shadow-xl hover:border-primary/30 transition-all duration-300 cursor-pointer"
    :class="[isSelected ? `ring-2 ${status.ringClass} bg-surface` : '']"
  >
    <!-- Icon Layer (Transparent to pointer events) -->
    <div class="mb-3 transition-transform duration-300 group-hover:scale-110 group-hover:-translate-y-1 pointer-events-none z-10">
      <component :is="status.icon" class="w-6 h-6" :class="status.colorClass" />
    </div>

    <!-- Label Layer (Transparent to pointer events) -->
    <div
      class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 text-center transition-colors group-hover:text-text pointer-events-none z-10">
      {{ status.label }}
    </div>

    <!-- Value Layer (Transparent to pointer events) -->
    <div class="flex flex-col items-center gap-0.5 mb-3 pointer-events-none z-10 text-center">
      <span class="text-2xl font-black tabular-nums transition-colors" :class="status.colorClass">
        {{ status.count }}
      </span>
      <span class="text-[11px] font-bold text-text-muted tabular-nums">
        ({{ status.value }}%)
      </span>
    </div>

    <!-- Chart Layer (Receives pointer events exclusively) -->
    <WorkforceDonutChart 
      v-if="showChart && chartObservers.length > 0"
      :observers="chartObservers"
      @select-category="(category) => $emit('select-category', category)"
    />

    <!-- Progress Indicator Layer (Transparent to pointer events) -->
    <div class="w-full mt-auto pointer-events-none z-10">
      <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
        <div class="h-full rounded-full transition-all duration-1000 ease-out" :class="status.bgClass"
          :style="{ width: status.value + '%' }"></div>
      </div>
    </div>

    <!-- Selected Indicator (Triangle) -->
    <div v-if="isSelected"
      class="absolute -bottom-[10px] left-1/2 -translate-x-1/2 w-4 h-4 bg-surface border-r-2 border-b-2 rotate-45 z-10 lg:visible invisible"
      :class="status.borderColorClass">
    </div>
  </div>
</template>

<script setup lang="ts">
import WorkforceDonutChart from './WorkforceDonutChart.vue'

interface StatusInfo {
  label: string
  count: number | string
  value: number
  colorClass: string
  bgClass: string
  borderColorClass: string
  ringClass: string
  icon: any
}

defineProps<{
  status: StatusInfo
  isSelected: boolean
  showChart: boolean
  chartObservers: any[]
}>()

defineEmits(['select-status', 'select-category'])
</script>

<style scoped>
</style>
