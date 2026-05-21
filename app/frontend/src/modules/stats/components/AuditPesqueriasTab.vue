<template>
   <div>
      <div class="grid grid-cols-1 lg:grid-cols-12 divide-y lg:divide-y-0 lg:divide-x divide-border">
         <!-- Resumen por Pesquería / Flota -->
         <div class="lg:col-span-5 p-5">
            <div class="flex items-center gap-2 mb-4">
               <span class="w-1.5 h-1.5 rounded-full bg-primary/40"></span>
               <h4 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
                  Resumen por Pesquería y Flota
               </h4>
            </div>
            <div class="overflow-x-auto">
               <table class="w-full text-left border-collapse">
                  <thead>
                     <tr class="bg-surface-muted/30">
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">
                           Pesquería / Flota</th>
                        <th class="px-2 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-16">
                           Mar.</th>
                        <th class="px-2 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-16">
                           Etap.</th>
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-right w-20">
                           Días</th>
                     </tr>
                  </thead>
                  <tbody class="divide-y divide-border/50">
                     <tr v-for="row in pesqueriaData.resumen" :key="row.key"
                        class="hover:bg-primary/5 transition-colors">
                        <td class="px-4 py-2">
                           <div class="flex flex-col">
                              <span class="text-[10px] font-black text-text uppercase tracking-tight">{{ row.pesqueria }}</span>
                              <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">{{ row.flota }}</span>
                           </div>
                        </td>
                        <td class="px-2 py-2 text-[11px] font-bold text-center tabular-nums text-text">{{ row.mareas }}</td>
                        <td class="px-2 py-2 text-[11px] font-bold text-center tabular-nums text-text-muted">{{ row.etapas }}</td>
                        <td class="px-4 py-2 text-right">
                           <span class="text-[11px] font-black text-primary tabular-nums">{{ row.dias }}</span>
                        </td>
                     </tr>
                  </tbody>
                  <tfoot class="border-t border-border">
                     <tr class="bg-surface-muted/20">
                        <td class="px-4 py-2 text-[9px] font-black text-text uppercase tracking-widest">TOTALES</td>
                        <td class="px-2 py-2 text-[10px] font-black text-center tabular-nums text-text">{{ stats.totalMareas }}</td>
                        <td class="px-2 py-2 text-[10px] font-black text-center tabular-nums text-text-muted">{{ totalEtapas }}</td>
                        <td class="px-4 py-2 text-right">
                           <span class="text-[10px] font-black text-primary tabular-nums">{{ stats.totalDaysNavigated }}</span>
                        </td>
                     </tr>
                  </tfoot>
               </table>
            </div>
         </div>

         <!-- Distribución Chart -->
         <div class="lg:col-span-7 p-5 bg-surface-muted/5">
            <div class="flex items-center gap-2 mb-4">
               <span class="w-1.5 h-1.5 rounded-full bg-primary/40"></span>
               <h4 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
                  Distribución de Días por Pesquería y Flota
               </h4>
            </div>
            <div class="h-100">
               <ChartWidget title="Distribución de Días" type="bar" :series="chartSeries" :options="chartOptions"
                  :chart-height="330" />
            </div>
         </div>
      </div>

      <!-- Detalle expandible por pesquería -->
      <div class="border-t border-border">
         <div class="p-5 pb-2 bg-surface-muted/10">
            <h4 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
               Detalle de Mareas por Pesquería
            </h4>
         </div>
         <div class="divide-y divide-border">
            <div v-for="fishery in pesqueriaData.detalle" :key="fishery.name" class="overflow-hidden">
               <button @click="toggleFishery(fishery.name)"
                  class="w-full flex items-center justify-between px-5 py-3 hover:bg-surface-muted/30 transition-colors group">
                  <div class="flex items-center gap-3">
                     <component :is="expanded.has(fishery.name) ? ChevronDownIcon : ChevronRightIcon"
                        class="w-4 h-4 text-text-muted group-hover:text-primary transition-colors" />
                     <span class="text-xs font-black text-text uppercase tracking-tight">{{ fishery.name }}</span>
                  </div>
                  <div class="flex items-center gap-4 text-[10px] font-bold text-text-muted">
                     <span class="tabular-nums">{{ fishery.mareas }} mareas</span>
                     <span class="w-px h-3 bg-border"></span>
                     <span class="tabular-nums font-black text-primary">{{ fishery.dias }} días</span>
                  </div>
               </button>
               <div v-if="expanded.has(fishery.name)" class="bg-surface-muted/10 animate-in fade-in duration-200">
                  <table class="w-full text-left border-collapse">
                     <thead>
                        <tr class="bg-surface-muted/30">
                           <th class="px-8 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Flota</th>
                           <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Marea</th>
                           <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Buque</th>
                           <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-20">Etapas</th>
                           <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-right w-28">Días</th>
                           <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-24">Estado</th>
                        </tr>
                     </thead>
                     <tbody class="divide-y divide-border/30">
                        <tr v-for="m in fishery.items" :key="m.id_marea" class="hover:bg-primary/5 transition-colors">
                           <td class="px-8 py-2 text-[11px] font-bold text-text-muted">{{ m.flota }}</td>
                           <td class="px-5 py-2 text-[11px] font-black text-text tabular-nums">{{ m.id_marea }}</td>
                           <td class="px-5 py-2 text-[11px] font-bold text-text">{{ m.buque }}</td>
                           <td class="px-5 py-2 text-[11px] font-bold text-text text-center tabular-nums">{{ m.etapas }}</td>
                           <td class="px-5 py-2 text-right">
                              <span class="text-xs font-black text-text tabular-nums">{{ m.dias }}</span>
                           </td>
                           <td class="px-5 py-2 text-center">
                              <span class="px-2 py-0.5 rounded text-[8px] font-bold uppercase tracking-wider"
                                 :class="m.estado === 'Finalizada'
                                    ? 'bg-emerald-500/10 text-emerald-600'
                                    : m.estado === 'Derivada'
                                       ? 'bg-amber-500/10 text-amber-600'
                                       : 'bg-sky-500/10 text-sky-600'">
                                 {{ m.estado }}
                              </span>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </div>
         </div>
      </div>
   </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { ChevronDownIcon, ChevronRightIcon } from 'lucide-vue-next'
import ChartWidget from './ChartWidget.vue'
import type { DashboardStats, MareaDistributionItem, StatsDetailItem } from '../services/stats.service'

const props = defineProps<{
   stats: DashboardStats
   detailItems: StatsDetailItem[]
   distributionData: MareaDistributionItem[]
   year: number
   mode: 'CALENDAR' | 'TOTAL'
   endDate: string | null
}>()

const expanded = ref(new Set<string>())
const toggleFishery = (name: string) => {
   const s = new Set(expanded.value)
   s.has(name) ? s.delete(name) : s.add(name)
   expanded.value = s
}

const etapasPorMarea = computed(() => {
   const map = new Map<string, number>()
   props.distributionData.forEach(item => {
      const cur = map.get(item.mareaId) || 0
      map.set(item.mareaId, Math.max(cur, item.nroEtapa))
   })
   return map
})

const totalEtapas = computed(() =>
   props.detailItems.reduce((s, item) => s + (etapasPorMarea.value.get(item.id) || 1), 0)
)

interface ResumenRow { key: string; pesqueria: string; flota: string; mareas: number; etapas: number; dias: number }
interface DetalleItem { id_marea: string; buque: string; flota: string; estado: string; etapas: number; dias: number }
interface DetalleGroup { name: string; mareas: number; dias: number; items: DetalleItem[] }

const sortMareas = (items: DetalleItem[]) => {
   return [...items].sort((a, b) => {
      const regex = /^([A-Z]+)-(\d+)-(\d+)$/
      const mA = a.id_marea.match(regex), mB = b.id_marea.match(regex)
      if (mA && mB) {
         const t = mB[1].localeCompare(mA[1])
         if (t !== 0) return t
         const y = mA[3].localeCompare(mB[3])
         if (y !== 0) return y
         return parseInt(mA[2]) - parseInt(mB[2])
      }
      return a.id_marea.localeCompare(b.id_marea)
   })
}

const pesqueriaData = computed(() => {
   if (!props.detailItems.length) return { resumen: [] as ResumenRow[], detalle: [] as DetalleGroup[] }

   const limitDateStr = props.endDate ?? `${props.year}-12-31`
   const todayStr = new Date().toISOString().substring(0, 10)
   const isPeriodOpen = limitDateStr >= todayStr

   const resumenMap = new Map<string, ResumenRow>()
   const detalleMap = new Map<string, DetalleItem[]>()

   props.detailItems.forEach(item => {
      const etapas = etapasPorMarea.value.get(item.id) || 1
      const dias = props.mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales

      // Resumen
      const key = `${item.pesqueria}||${item.flota}`
      if (!resumenMap.has(key)) {
         resumenMap.set(key, { key, pesqueria: item.pesqueria, flota: item.flota, mareas: 0, etapas: 0, dias: 0 })
      }
      const row = resumenMap.get(key)!
      row.mareas++; row.etapas += etapas; row.dias += dias

      // Detalle
      const esDelegada = item.estadoActual === 'DELEGADA_EXTERNA'
      let estado = 'Finalizada'
      if (esDelegada) {
         estado = 'Derivada'
      } else if (isPeriodOpen && item.estado === 'En ejecución') {
         estado = 'En ejecución'
      } else if (!item.fechaFin || item.fechaFin.substring(0, 10) > limitDateStr) {
         estado = 'En ejecución'
      }

      if (!detalleMap.has(item.pesqueria)) detalleMap.set(item.pesqueria, [])
      detalleMap.get(item.pesqueria)!.push({ id_marea: item.id_marea, buque: item.buque, flota: item.flota, estado, etapas, dias })
   })

   const resumen = Array.from(resumenMap.values()).sort((a, b) => {
      const p = a.pesqueria.localeCompare(b.pesqueria)
      return p !== 0 ? p : a.flota.localeCompare(b.flota)
   })

   const detalle: DetalleGroup[] = Array.from(detalleMap.entries())
      .map(([name, items]) => ({
         name,
         mareas: items.length,
         dias: items.reduce((s, i) => s + i.dias, 0),
         items: sortMareas(items)
      }))
      .sort((a, b) => a.name.localeCompare(b.name))

   return { resumen, detalle }
})

const chartSeries = computed(() => {
   const flotaSet = new Set<string>()
   pesqueriaData.value.resumen.forEach(r => flotaSet.add(r.flota))
   const flotas = Array.from(flotaSet).sort()
   const pesquerias = [...new Set(pesqueriaData.value.resumen.map(r => r.pesqueria))].sort()
   return flotas.map(flota => ({
      name: flota,
      data: pesquerias.map(pesq => {
         const row = pesqueriaData.value.resumen.find(r => r.pesqueria === pesq && r.flota === flota)
         return row?.dias || 0
      })
   }))
})

const chartOptions = computed(() => ({
   chart: { type: 'bar', stacked: true, toolbar: { show: false } },
   plotOptions: { bar: { horizontal: false, borderRadius: 4, columnWidth: '65%' } },
   xaxis: {
      categories: [...new Set(pesqueriaData.value.resumen.map(r => r.pesqueria))].sort(),
      labels: { style: { fontSize: '10px', fontWeight: 700 }, rotate: -45, trim: true, maxHeight: 80 }
   },
   yaxis: { title: { text: 'Días Navegados', style: { fontWeight: 800 } } },
   grid: { padding: { left: 15 } },
   legend: { position: 'top' as const, fontSize: '10px', fontWeight: 700 },
   colors: ['#0ea5e9', '#f59e0b', '#10b981', '#8b5cf6', '#ef4444', '#ec4899'],
   dataLabels: { enabled: false },
   tooltip: {
      shared: true,
      intersect: false,
      custom: ({ series, dataPointIndex, w }: any) => {
         const label = w.globals.labels[dataPointIndex]
         const colors = w.globals.colors
         const seriesNames = w.config.series.map((s: any) => s.name)
         const total = series.reduce((sum: number, s: any) => sum + (s[dataPointIndex] || 0), 0)
         const rows = series
            .map((s: any, i: number) => {
               const val = s[dataPointIndex] || 0
               if (!val) return ''
               return `<div class="flex items-center justify-between gap-6">
                  <div class="flex items-center gap-1.5">
                     <span class="w-2 h-2 rounded-full shrink-0" style="background:${colors[i]}"></span>
                     <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">${seriesNames[i]}</span>
                  </div>
                  <span class="text-sm font-black tabular-nums">${val} días</span>
               </div>`
            })
            .join('')
         return `
            <div class="px-4 py-4 bg-surface/90 backdrop-blur-xl text-text border border-border/50 rounded-2xl flex flex-col gap-2 shadow-2xl ring-1 ring-black/10 min-w-[220px]">
               <div class="flex items-center justify-between border-b border-border/30 pb-2 mb-1">
                  <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label}</span>
                  <div class="px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[9px] font-black uppercase">Pesquerías</div>
               </div>
               <div class="flex flex-col gap-1.5">${rows}</div>
               <div class="pt-1.5 border-t border-border/30 flex items-baseline justify-between">
                  <span class="text-[9px] font-black text-text-muted uppercase tracking-tighter">Total</span>
                  <span class="text-base font-black text-primary tabular-nums">${total} días</span>
               </div>
            </div>
         `
      }
   }
}))
</script>

<style scoped>
.animate-in { animation-duration: 0.3s; animation-timing-function: cubic-bezier(0,0,0.2,1); }
.fade-in { animation-name: fadeIn; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(4px); } to { opacity: 1; transform: translateY(0); } }
</style>
