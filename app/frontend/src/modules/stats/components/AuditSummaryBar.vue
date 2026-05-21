<template>
   <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
      <!-- Total Mareas -->
      <div class="bg-surface rounded-xl border border-border p-3 shadow-theme-xs">
         <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Mareas</p>
         <p class="text-xl font-black text-text tabular-nums">{{ stats.totalMareas }}</p>
      </div>

      <!-- Días Navegados -->
      <div class="bg-surface rounded-xl border border-border p-3 shadow-theme-xs">
         <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Días Navegados</p>
         <p class="text-xl font-black text-primary tabular-nums">{{ stats.totalDaysNavigated.toLocaleString() }}</p>
      </div>

      <!-- Cobertura -->
      <div class="bg-surface rounded-xl border border-border p-3 shadow-theme-xs">
         <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Cobertura</p>
         <p class="text-xl font-black tabular-nums"
            :class="coberturaPct >= 90 ? 'text-emerald-500' : coberturaPct >= 70 ? 'text-amber-500' : 'text-red-500'">
            {{ coberturaPct }}%
         </p>
      </div>

      <!-- Protocolizadas -->
      <div class="bg-surface rounded-xl border border-border p-3 shadow-theme-xs">
         <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Protocolizadas</p>
         <p class="text-xl font-black tabular-nums"
            :class="timelineData ? (timelineData.sinProtocolizar === 0 ? 'text-emerald-500' : 'text-text') : 'text-text'">
            {{ timelineData ? timelineData.totalProtocolizadas : '—' }}
         </p>
      </div>

      <!-- Canceladas -->
      <div class="bg-surface rounded-xl border border-border p-3 shadow-theme-xs relative overflow-hidden">
         <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Canceladas</p>
         <p class="text-xl font-black tabular-nums"
            :class="specialCounts.canceladas > 0 ? 'text-amber-500' : 'text-text-muted'">
            {{ specialCounts.canceladas }}
         </p>
         <div v-if="specialCounts.desestimadas > 0"
            class="text-[9px] font-bold text-error/70 mt-0.5">
            +{{ specialCounts.desestimadas }} desestimadas
         </div>
      </div>

      <!-- Pendientes/Seguimiento -->
      <div class="bg-surface rounded-xl border border-border p-3 shadow-theme-xs"
         :class="alertCount > 0 ? 'border-amber-500/30 bg-amber-500/5' : ''">
         <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Requieren atención</p>
         <div class="flex items-center gap-2">
            <p class="text-xl font-black tabular-nums"
               :class="alertCount > 0 ? 'text-amber-500' : 'text-text-muted'">
               {{ alertCount }}
            </p>
            <span v-if="alertCount > 0"
               class="text-[8px] font-black text-amber-600 bg-amber-500/10 border border-amber-500/20 rounded px-1 py-0.5 uppercase tracking-wider">
               pendientes
            </span>
         </div>
      </div>
   </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { DashboardStats, ProtocolizationTimelineResult } from '../services/stats.service'

const props = defineProps<{
   stats: DashboardStats
   coberturaPct: number
   specialCounts: { canceladas: number; desestimadas: number; pendientes: number; delegadas: number }
   timelineData: ProtocolizationTimelineResult | null
}>()

const alertCount = computed(() =>
   props.specialCounts.pendientes + props.specialCounts.delegadas
)
</script>
