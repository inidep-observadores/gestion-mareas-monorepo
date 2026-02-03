<template>
  <div class="rounded-3xl border border-border bg-surface shadow-sm border-l-4 border-l-warning flex flex-col h-full">
    <div class="flex items-center gap-2 p-6 pb-2">
      <HistoryIcon class="w-4 h-4 text-warning" />
      <h2 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
        Días sin Navegar (Top 5)
      </h2>
    </div>

    <div class="flex-1 p-2">
      <div v-if="topDry.length > 0" class="overflow-hidden rounded-xl border border-border/50">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr class="border-b border-border/50 bg-surface-muted/30">
              <th
                class="py-3 pl-4 pr-2 text-[10px] font-black text-text-muted uppercase tracking-widest w-10 text-center">
                #</th>
              <th class="py-3 px-2 text-[10px] font-black text-text-muted uppercase tracking-widest">Observador</th>
              <th class="py-3 px-2 text-[10px] font-black text-text-muted uppercase tracking-widest text-right">Últ.
                Arribo</th>
              <th class="py-3 pl-2 pr-4 text-[10px] font-black text-text-muted uppercase tracking-widest text-right">
                Días</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border/50">
            <tr v-for="(obs, index) in topDry" :key="obs.id" class="group hover:bg-surface-muted/50 transition-colors">
              <td class="py-2.5 pl-4 pr-2 text-center">
                <span class="text-[10px] font-black text-text-muted/40 group-hover:text-warning transition-colors">
                  0{{ index + 1 }}
                </span>
              </td>
              <td class="py-2.5 px-2">
                <span
                  class="text-xs font-bold text-text hover:text-primary cursor-pointer hover:underline decoration-primary/30 underline-offset-2 transition-colors block truncate max-w-[140px]"
                  @click="$emit('view-timeline', obs.id, obs.name)">
                  {{ obs.name }}
                </span>
              </td>
              <td class="py-2.5 px-2 text-right">
                <div class="flex flex-col items-end gap-0.5">
                  <span class="text-[10px] font-bold text-text-muted tabular-nums tracking-tight">
                    {{ formatDate(obs.lastArrival) }}
                  </span>
                  <span v-if="obs.mareaCode" class="text-[9px] font-medium text-text-muted uppercase tracking-tighter">
                    {{ obs.mareaCode }} • {{ obs.vesselName }}
                  </span>
                  <span v-if="obs.fishery" class="text-[8px] font-medium text-primary uppercase tracking-widest italic">
                    {{ obs.fishery }}
                  </span>
                </div>
              </td>
              <td class="py-2.5 pl-2 pr-4 text-right">
                <span class="text-xs font-black text-warning tabular-nums">
                  {{ obs.days }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-else class="flex flex-col items-center justify-center py-12 text-xs text-text-muted gap-2">
        <div class="p-3 rounded-full bg-surface-muted text-text-muted/50">
          <HistoryIcon class="w-6 h-6" />
        </div>
        <span class="font-bold uppercase tracking-wider">No hay datos disponibles</span>
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

defineEmits(['view-timeline'])

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
