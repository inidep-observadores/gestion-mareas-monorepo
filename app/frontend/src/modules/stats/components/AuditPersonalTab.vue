<template>
   <div class="space-y-0">
      <!-- KPIs Row -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 p-5">
         <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Observadores Afectados</p>
            <p class="text-2xl font-black text-text tabular-nums">{{ personalData.observadoresAfectados }}</p>
         </div>
         <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50 relative group/dot">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">
               Dotación Referencia
               <span class="inline-block w-3 h-3 rounded-full bg-primary/10 text-primary text-[8px] font-black text-center leading-3 ml-1 cursor-help">?</span>
            </p>
            <p class="text-2xl font-black text-text tabular-nums">{{ dotacionReferencia }}</p>
            <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-2 bg-surface border border-border rounded-xl text-[9px] font-medium text-text-muted opacity-0 group-hover/dot:opacity-100 transition-all pointer-events-none shadow-theme-lg z-50 whitespace-nowrap">
               Máximo entre dotación activa ({{ dotacionTotal }}) y observadores afectados ({{ personalData.observadoresAfectados }})
            </div>
         </div>
         <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">% sobre Dotación</p>
            <p class="text-2xl font-black tabular-nums"
               :class="coberturaPct >= 90 ? 'text-emerald-500' : coberturaPct >= 70 ? 'text-amber-500' : 'text-red-500'">
               {{ coberturaPct }}%
            </p>
         </div>
         <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Días Navegados</p>
            <p class="text-2xl font-black text-primary tabular-nums">{{ stats.totalDaysNavigated.toLocaleString() }}</p>
         </div>
      </div>

      <!-- Stats Summary Banner -->
      <div class="mx-5 mb-5 bg-primary/5 border border-primary/10 rounded-xl px-4 py-3 flex flex-wrap items-center gap-x-6 gap-y-2 text-[11px]">
         <div class="flex items-center gap-2">
            <span class="text-text-muted font-bold">Promedio:</span>
            <span class="font-black text-text tabular-nums">{{ personalData.promedioDias }} días/obs.</span>
         </div>
         <div class="w-px h-4 bg-border"></div>
         <div class="flex items-center gap-2">
            <span class="text-text-muted font-bold">Máximo:</span>
            <span class="font-black text-primary tabular-nums">{{ personalData.maxDias }} días</span>
            <span class="text-text-muted font-medium">({{ personalData.maxNombre }})</span>
         </div>
         <div class="w-px h-4 bg-border"></div>
         <div class="flex items-center gap-2">
            <span class="text-text-muted font-bold">Mínimo:</span>
            <span class="font-black text-text tabular-nums">{{ personalData.minDias }} días</span>
            <span class="text-text-muted font-medium">({{ personalData.minNombre }})</span>
         </div>
         <template v-if="hasSecondaryData">
            <div class="w-px h-4 bg-border"></div>
            <div class="flex items-center gap-2">
               <span class="text-text-muted font-bold">Con participación secundaria:</span>
               <span class="font-black text-violet-500 tabular-nums">{{ observadoresConSecundario }}</span>
            </div>
         </template>
      </div>

      <!-- Chart -->
      <div class="px-5 pb-5">
         <ChartWidget title="Ranking de Observadores" subtitle="Días navegados por observador (todos)" type="bar"
            :series="chartSeries" :options="chartOptions"
            :chart-height="Math.max(400, personalData.ranking.length * 28)" />
      </div>

      <!-- Full Table -->
      <div class="border-t border-border overflow-x-auto">
         <table class="w-full text-left border-collapse">
            <thead>
               <tr class="bg-surface-muted/50">
                  <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted w-12">#</th>
                  <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">Observador</th>
                  <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-28">
                     Mareas</th>
                  <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-32">
                     Etapas Sec.</th>
                  <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-right w-36">
                     Días Nav. {{ year }}</th>
               </tr>
            </thead>
            <tbody class="divide-y divide-border">
               <tr v-for="(obs, index) in personalData.ranking" :key="obs.id"
                  class="hover:bg-primary/5 transition-colors">
                  <td class="px-5 py-2.5 text-xs font-bold text-text-muted tabular-nums">{{ index + 1 }}</td>
                  <td class="px-5 py-2.5">
                     <span class="text-xs font-bold text-text">{{ obs.name }}</span>
                     <span v-if="!obs.active"
                        class="ml-2 text-[8px] font-black text-error uppercase tracking-wider">Inactivo</span>
                  </td>
                  <td class="px-5 py-2.5 text-xs font-bold text-text text-center tabular-nums">{{ obs.mareas }}</td>
                  <td class="px-5 py-2.5 text-center">
                     <span v-if="secondaryMap.get(obs.id)"
                        class="text-xs font-black text-violet-500 tabular-nums">
                        {{ secondaryMap.get(obs.id) }}
                     </span>
                     <span v-else class="text-[10px] text-text-muted/40">—</span>
                  </td>
                  <td class="px-5 py-2.5 text-right">
                     <div class="flex items-center justify-end gap-3">
                        <div class="flex-1 max-w-[80px] h-1.5 bg-surface-muted rounded-full overflow-hidden hidden sm:block">
                           <div class="h-full bg-violet-500 rounded-full transition-all" :style="{
                              width: `${personalData.ranking[0]?.days ? (obs.days / personalData.ranking[0].days) * 100 : 0}%`
                           }"></div>
                        </div>
                        <span class="text-sm font-black text-text tabular-nums">{{ obs.days }}</span>
                     </div>
                  </td>
               </tr>
            </tbody>
            <tfoot class="sticky bottom-0 z-10">
               <tr class="bg-background/95 backdrop-blur-md border-t-2 border-primary/20 shadow-[0_-4px_12px_rgba(0,0,0,0.08)]">
                  <td class="px-5 py-3"></td>
                  <td class="px-5 py-3 text-[10px] font-black text-text uppercase tracking-widest">
                     TOTAL ({{ personalData.observadoresAfectados }} observadores)
                  </td>
                  <td class="px-5 py-3 text-xs font-black text-text text-center tabular-nums">{{ stats.totalMareas }}</td>
                  <td class="px-5 py-3"></td>
                  <td class="px-5 py-3 text-right">
                     <span class="text-sm font-black text-primary tabular-nums">{{ stats.totalDaysNavigated.toLocaleString() }}</span>
                  </td>
               </tr>
            </tfoot>
         </table>
      </div>
   </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import ChartWidget from './ChartWidget.vue'
import type { DashboardStats, ObserverSecondaryStats } from '../services/stats.service'

const props = defineProps<{
   stats: DashboardStats
   year: number
   dotacionTotal: number
   dotacionReferencia: number
   coberturaPct: number
   secondaryStats: ObserverSecondaryStats[]
}>()

const secondaryMap = computed(() => {
   const m = new Map<string, number>()
   props.secondaryStats.forEach(s => m.set(s.observadorId, s.etapasComoSecundario))
   return m
})

const hasSecondaryData = computed(() => props.secondaryStats.length > 0)

const observadoresConSecundario = computed(() =>
   props.secondaryStats.filter(s => s.etapasComoSecundario > 0).length
)

const personalData = computed(() => {
   const observers = [...props.stats.observers].sort((a, b) => b.days - a.days)
   const totalDays = observers.reduce((sum, o) => sum + o.days, 0)
   const count = observers.length
   return {
      observadoresAfectados: count,
      promedioDias: count > 0 ? (totalDays / count).toFixed(1) : '0',
      maxDias: observers[0]?.days || 0,
      maxNombre: observers[0]?.name || '',
      minDias: observers[count - 1]?.days || 0,
      minNombre: observers[count - 1]?.name || '',
      ranking: observers
   }
})

const chartSeries = computed(() => [{
   name: 'Días Navegados',
   data: personalData.value.ranking.map(o => o.days)
}])

const chartOptions = computed(() => ({
   plotOptions: { bar: { horizontal: true, borderRadius: 3, barHeight: '65%' } },
   xaxis: { categories: personalData.value.ranking.map(o => o.name) },
   colors: ['#8b5cf6'],
   dataLabels: {
      enabled: true,
      textAnchor: 'start' as const,
      offsetX: 5,
      style: { fontSize: '10px', fontWeight: 900, colors: ['#8b5cf6'] },
      formatter: (val: number) => val
   }
}))
</script>
