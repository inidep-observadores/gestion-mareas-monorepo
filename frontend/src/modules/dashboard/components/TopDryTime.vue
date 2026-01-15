<template>
  <div class="rounded-3xl border border-border bg-surface p-6 shadow-sm border-l-4 border-l-warning">
    <div class="flex items-center gap-2 mb-6">
      <HistoryIcon class="w-4 h-4 text-warning" />
      <h2 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
         Días sin Navegar (Top 5)
      </h2>
    </div>

    <div class="space-y-4">
      <div v-for="(obs, index) in topDry" :key="obs.id" class="group/list flex items-center gap-4">
        <div class="w-6 text-[10px] font-black text-text-muted/30 group-hover/list:text-warning transition-colors">0{{ index + 1 }}</div>
        <div class="flex-1 min-w-0">
          <div class="flex items-center justify-between gap-3 mb-1.5">
            <div class="flex flex-col">
              <span class="text-[12px] font-bold text-text truncate group-hover/list:text-warning transition-colors">
                {{ obs.name }}
              </span>
              <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">
                Últ. Arribo: {{ formatDate(obs.lastArrival) }}
              </span>
            </div>
            <div class="flex flex-col items-end">
              <span class="text-[11px] font-black text-warning whitespace-nowrap">
                {{ obs.days }} días
              </span>
            </div>
          </div>
          <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
            <div
              class="h-full bg-warning rounded-full transition-all duration-700"
              :style="{ width: Math.min(obs.days * 2, 100) + '%' }"
            ></div>
          </div>
        </div>
      </div>
      
      <div v-if="topDry.length === 0" class="text-center py-4 text-xs text-text-muted">
        No hay datos disponibles
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { HistoryIcon } from '@/icons'
import type { WorkforceStatus } from '../services/dashboard.service'

const props = defineProps<{
  topDry: WorkforceStatus['topDry']
}>()

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit'
  })
}
</script>
