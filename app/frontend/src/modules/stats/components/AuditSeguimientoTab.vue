<template>
   <div v-if="loading" class="flex items-center justify-center py-20">
      <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary"></div>
   </div>

   <div v-else class="divide-y divide-border">

      <!-- ── CASOS ESPECIALES ─────────────────────────────── -->
      <section class="p-5 space-y-4">
         <h3 class="text-[10px] font-black text-text-muted uppercase tracking-widest">Mareas con Estado Especial</h3>

         <!-- Contadores rápidos -->
         <div class="grid grid-cols-2 lg:grid-cols-4 gap-3">
            <div class="rounded-xl p-3 border"
               :class="counts.canceladas > 0 ? 'bg-amber-500/5 border-amber-500/20' : 'bg-surface-muted/20 border-border/50'">
               <p class="text-[9px] font-black uppercase tracking-widest mb-1"
                  :class="counts.canceladas > 0 ? 'text-amber-600' : 'text-text-muted'">Canceladas</p>
               <p class="text-2xl font-black tabular-nums"
                  :class="counts.canceladas > 0 ? 'text-amber-500' : 'text-text-muted'">{{ counts.canceladas }}</p>
               <p class="text-[8px] text-text-muted mt-1">Nunca ejecutadas</p>
            </div>
            <div class="rounded-xl p-3 border"
               :class="counts.desestimadas > 0 ? 'bg-red-500/5 border-red-500/20' : 'bg-surface-muted/20 border-border/50'">
               <p class="text-[9px] font-black uppercase tracking-widest mb-1"
                  :class="counts.desestimadas > 0 ? 'text-red-600' : 'text-text-muted'">Desestimadas</p>
               <p class="text-2xl font-black tabular-nums"
                  :class="counts.desestimadas > 0 ? 'text-red-500' : 'text-text-muted'">{{ counts.desestimadas }}</p>
               <p class="text-[8px] text-text-muted mt-1">Datos descartados</p>
            </div>
            <div class="rounded-xl p-3 border"
               :class="counts.pendientes > 0 ? 'bg-sky-500/5 border-sky-500/20' : 'bg-surface-muted/20 border-border/50'">
               <p class="text-[9px] font-black uppercase tracking-widest mb-1"
                  :class="counts.pendientes > 0 ? 'text-sky-600' : 'text-text-muted'">Pendientes de informe</p>
               <p class="text-2xl font-black tabular-nums"
                  :class="counts.pendientes > 0 ? 'text-sky-500' : 'text-text-muted'">{{ counts.pendientes }}</p>
               <p class="text-[8px] text-text-muted mt-1">Sin informe aún</p>
            </div>
            <div class="rounded-xl p-3 border"
               :class="counts.delegadas > 0 ? 'bg-amber-500/5 border-amber-500/30' : 'bg-surface-muted/20 border-border/50'">
               <p class="text-[9px] font-black uppercase tracking-widest mb-1"
                  :class="counts.delegadas > 0 ? 'text-amber-600' : 'text-text-muted'">Derivadas externas</p>
               <p class="text-2xl font-black tabular-nums"
                  :class="counts.delegadas > 0 ? 'text-amber-500' : 'text-text-muted'">{{ counts.delegadas }}</p>
               <p class="text-[8px] text-text-muted mt-1">En espera de programa ext.</p>
            </div>
         </div>

         <!-- Tablas expandibles por categoría -->
         <div class="space-y-3 mt-2">
            <!-- Canceladas -->
            <SpecialCaseTable v-if="specialCases && specialCases.canceladas.length"
               title="Canceladas" subtitle="Mareas previstas que nunca se ejecutaron"
               badge-class="bg-amber-500/10 text-amber-600 border-amber-500/20"
               :items="specialCases.canceladas"
               event-label="Fecha cancelación" />

            <!-- Desestimadas -->
            <SpecialCaseTable v-if="specialCases && specialCases.desestimadas.length"
               title="Desestimadas" subtitle="Mareas ejecutadas cuyos datos no serán incorporados"
               badge-class="bg-red-500/10 text-red-600 border-red-500/20"
               :items="specialCases.desestimadas"
               event-label="Fecha desestimación"
               show-motivo />

            <!-- Pendientes de informe -->
            <SpecialCaseTable v-if="specialCases && specialCases.pendientesDeInforme.length"
               title="Pendientes de Informe" subtitle="Mareas completadas sin informe redactado aún"
               badge-class="bg-sky-500/10 text-sky-600 border-sky-500/20"
               :items="specialCases.pendientesDeInforme"
               event-label="En pendiente desde" />

            <!-- Derivadas externas -->
            <div v-if="specialCases && specialCases.delegadasExternas.length">
               <SpecialCaseTable
                  title="Derivadas a Programas Científicos Externos" subtitle="Pendientes de validación por otro programa científico externo"
                  badge-class="bg-amber-500/10 text-amber-600 border-amber-500/30"
                  :items="specialCases.delegadasExternas"
                  event-label="Fecha derivación" />
               <p class="text-[9px] font-medium text-amber-700/70 mt-2 px-1 leading-relaxed">
                  La demora en la confección del informe de estas mareas es ajena al Proyecto Observadores a Bordo.
               </p>
            </div>

            <!-- Sin datos -->
            <div v-if="specialCases && counts.total === 0"
               class="text-center py-10 text-text-muted/60">
               <p class="text-sm font-bold">Sin casos especiales en el período</p>
               <p class="text-[11px] mt-1">Todas las mareas fueron ejecutadas y están en proceso normal.</p>
            </div>
         </div>
      </section>

      <!-- ── TIMELINE DE PROTOCOLIZACIÓN ─────────────────── -->
      <section class="p-5 space-y-5">
         <h3 class="text-[10px] font-black text-text-muted uppercase tracking-widest">Timeline de Protocolización</h3>

         <template v-if="timeline">
            <!-- KPIs de protocolización -->
            <div class="grid grid-cols-2 lg:grid-cols-5 gap-3">
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Enviadas a DNI</p>
                  <p class="text-2xl font-black text-sky-500 tabular-nums">{{ timeline.totalEnviadas }}</p>
                  <p class="text-[9px] text-text-muted mt-1">en el período</p>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Protocolizadas</p>
                  <p class="text-2xl font-black tabular-nums"
                     :class="timeline.sinProtocolizar === 0 ? 'text-emerald-500' : 'text-text'">
                     {{ timeline.totalProtocolizadas }}
                  </p>
                  <p class="text-[9px] text-text-muted mt-1">de {{ timeline.totalEnPeriodo }} del período</p>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50"
                  :class="timeline.sinProtocolizar > 0 ? 'border-amber-500/20 bg-amber-500/5' : ''">
                  <p class="text-[9px] font-black uppercase tracking-widest mb-1"
                     :class="timeline.sinProtocolizar > 0 ? 'text-amber-600' : 'text-text-muted'">
                     Sin Protocolizar</p>
                  <p class="text-2xl font-black tabular-nums"
                     :class="timeline.sinProtocolizar > 0 ? 'text-amber-500' : 'text-text-muted'">
                     {{ timeline.sinProtocolizar }}
                  </p>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Latencia Promedio</p>
                  <p class="text-2xl font-black text-text tabular-nums">
                     {{ timeline.promedioDiasLatencia !== null ? timeline.promedioDiasLatencia : '—' }}
                  </p>
                  <p class="text-[9px] text-text-muted mt-1">días fin → protocolización</p>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Latencia Máxima</p>
                  <p class="text-2xl font-black text-text tabular-nums">
                     {{ timeline.maxDiasLatencia !== null ? timeline.maxDiasLatencia : '—' }}
                  </p>
                  <p class="text-[9px] text-text-muted mt-1">días (caso más demorado)</p>
               </div>
            </div>

            <!-- Chart mensual -->
            <div v-if="hasChartData">
               <ChartWidget
                  title="Enviadas a DNI y Protocolizadas por Mes" subtitle="Comparación mensual entre mareas enviadas a la DNI y efectivamente protocolizadas"
                  type="bar" :series="timelineSeries" :options="timelineChartOptions" :chart-height="280" />
            </div>

            <!-- Tabla mensual -->
            <div class="overflow-x-auto">
               <table class="w-full text-left border-collapse text-[11px]">
                  <thead>
                     <tr class="bg-surface-muted/30">
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Mes</th>
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-sky-600 text-center w-28">Enviadas a DNI</th>
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-28">Protocolizadas</th>
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-24">Acumulado</th>
                        <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-right w-24">% del total</th>
                     </tr>
                  </thead>
                  <tbody class="divide-y divide-border/50">
                     <tr v-for="row in timeline.distribucionMensual.filter(r => r.cantidad > 0 || r.enviadas > 0)" :key="row.mes"
                        class="hover:bg-primary/5 transition-colors">
                        <td class="px-4 py-2 font-bold text-text">{{ row.label }}</td>
                        <td class="px-4 py-2 text-center font-black text-sky-500 tabular-nums">
                           {{ row.enviadas > 0 ? row.enviadas : '—' }}
                        </td>
                        <td class="px-4 py-2 text-center font-black text-primary tabular-nums">{{ row.cantidad }}</td>
                        <td class="px-4 py-2 text-center font-bold text-text-muted tabular-nums">{{ row.acumulado }}</td>
                        <td class="px-4 py-2 text-right font-bold text-text-muted tabular-nums">{{ row.pctDelTotal }}%</td>
                     </tr>
                  </tbody>
                  <tfoot class="border-t border-border">
                     <tr class="bg-surface-muted/20">
                        <td class="px-4 py-2 text-[9px] font-black text-text uppercase tracking-widest">TOTAL</td>
                        <td class="px-4 py-2 text-center font-black text-sky-500 tabular-nums">{{ timeline.totalEnviadas }}</td>
                        <td class="px-4 py-2 text-center font-black text-primary tabular-nums">{{ timeline.totalProtocolizadas }}</td>
                        <td class="px-4 py-2"></td>
                        <td class="px-4 py-2 text-right font-black text-text-muted tabular-nums">
                           {{ timeline.totalEnPeriodo > 0 ? Math.round(timeline.totalProtocolizadas / timeline.totalEnPeriodo * 100) : 0 }}%
                        </td>
                     </tr>
                  </tfoot>
               </table>
            </div>
         </template>
      </section>
   </div>
</template>

<script setup lang="ts">
import { computed, defineAsyncComponent } from 'vue'
import ChartWidget from './ChartWidget.vue'
import type { AuditSpecialCasesResult, ProtocolizationTimelineResult, AuditSpecialMarea } from '../services/stats.service'

// Sub-componente inline para las tablas de casos especiales
const SpecialCaseTable = defineAsyncComponent(() => import('./AuditSpecialCaseTable.vue'))

const props = defineProps<{
   specialCases: AuditSpecialCasesResult | null
   timeline: ProtocolizationTimelineResult | null
   loading: boolean
   year: number
}>()

const counts = computed(() => {
   if (!props.specialCases) return { canceladas: 0, desestimadas: 0, pendientes: 0, delegadas: 0, total: 0 }
   const c = props.specialCases.canceladas.length
   const d = props.specialCases.desestimadas.length
   const p = props.specialCases.pendientesDeInforme.length
   const e = props.specialCases.delegadasExternas.length
   return { canceladas: c, desestimadas: d, pendientes: p, delegadas: e, total: c + d + p + e }
})

const hasChartData = computed(() =>
   props.timeline?.distribucionMensual.some(r => r.cantidad > 0 || r.enviadas > 0) ?? false
)

const timelineSeries = computed(() => [
   {
      name: 'Enviadas a DNI',
      data: props.timeline?.distribucionMensual.map(r => r.enviadas) ?? []
   },
   {
      name: 'Protocolizadas',
      data: props.timeline?.distribucionMensual.map(r => r.cantidad) ?? []
   },
])

const timelineChartOptions = computed(() => ({
   chart: { type: 'bar', toolbar: { show: false } },
   plotOptions: { bar: { borderRadius: 3, columnWidth: '65%', dataLabels: { position: 'top' } } },
   xaxis: {
      categories: props.timeline?.distribucionMensual.map(r => r.label) ?? [],
      labels: { style: { fontSize: '10px', fontWeight: 700 } }
   },
   yaxis: { title: { text: 'Cantidad', style: { fontWeight: 800 } }, min: 0 },
   colors: ['#0ea5e9', '#10b981'],
   legend: { position: 'top' as const, fontSize: '10px', fontWeight: 700 },
   dataLabels: {
      enabled: true,
      style: { fontSize: '9px', fontWeight: 900 },
      formatter: (val: number) => val > 0 ? String(val) : ''
   },
   grid: { padding: { left: 10 } },
   tooltip: {
      shared: true,
      intersect: false,
      custom: ({ series, dataPointIndex, w }: any) => {
         const label = w.globals.labels[dataPointIndex]
         const enviadas = series[0]?.[dataPointIndex] ?? 0
         const prot = series[1]?.[dataPointIndex] ?? 0
         return `
            <div class="px-4 py-4 bg-surface/90 backdrop-blur-xl text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-2xl ring-1 ring-black/10 min-w-[200px]">
               <div class="flex items-center justify-between border-b border-border/30 pb-2 mb-1">
                  <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label}</span>
                  <div class="px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-600 text-[9px] font-black uppercase">Protocolización</div>
               </div>
               <div class="flex flex-col gap-2">
                  <div class="flex items-baseline justify-between gap-6">
                     <span class="text-[9px] font-black text-sky-500 uppercase tracking-tighter">Enviadas a DNI</span>
                     <span class="text-xl font-black tabular-nums">${enviadas}</span>
                  </div>
                  <div class="flex items-baseline justify-between gap-6">
                     <span class="text-[9px] font-black text-emerald-500 uppercase tracking-tighter">Protocolizadas</span>
                     <span class="text-xl font-black tabular-nums">${prot}</span>
                  </div>
               </div>
            </div>
         `
      }
   }
}))
</script>
