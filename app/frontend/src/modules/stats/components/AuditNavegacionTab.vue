<template>
   <div>
      <div class="grid grid-cols-1 lg:grid-cols-12 divide-y lg:divide-y-0 lg:divide-x divide-border">
         <!-- KPIs -->
         <div class="lg:col-span-3 p-5 flex flex-col gap-3 bg-surface-muted/10">
            <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
               <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Mareas</p>
               <p class="text-2xl font-black text-text tabular-nums">{{ stats.totalMareas }}</p>
            </div>
            <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
               <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Finalizadas</p>
               <p class="text-2xl font-black text-emerald-500 tabular-nums">{{ navData.finalizadas }}</p>
            </div>
            <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
               <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">En Ejecución</p>
               <p class="text-2xl font-black text-sky-500 tabular-nums">{{ navData.enEjecucion }}</p>
            </div>
            <div v-if="navData.delegadas > 0"
               class="bg-amber-500/5 rounded-xl p-4 border border-amber-500/20 shadow-sm">
               <p class="text-[9px] font-black text-amber-600 uppercase tracking-widest mb-1">Derivadas Ext.</p>
               <p class="text-2xl font-black text-amber-500 tabular-nums">{{ navData.delegadas }}</p>
               <p class="text-[8px] text-amber-600/70 font-medium mt-1 leading-tight">
                  Pendientes por proyecto externo
               </p>
            </div>
            <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
               <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Etapas</p>
               <p class="text-2xl font-black text-text tabular-nums">{{ navData.totalEtapas }}</p>
            </div>
         </div>

         <!-- Detail Table -->
         <div class="lg:col-span-9 overflow-x-auto scrollbar-thin scrollbar-thumb-border">
            <table class="w-full text-left border-collapse min-w-[820px]">
               <thead class="sticky top-0 z-20">
                  <tr class="bg-surface-muted/50 border-b border-border">
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">Pesquería</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">Buque</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted w-28">N° Marea</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-20">Estado</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-16">Etapas</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-24">Zarpada</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-24">Arribo</th>
                     <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-right w-28">Días {{ year }}</th>
                  </tr>
               </thead>
               <tbody class="divide-y divide-border">
                  <template v-for="(group, gIdx) in navData.grouped" :key="group.pesqueria">
                     <tr v-for="(marea, mIdx) in group.mareas" :key="marea.id_marea"
                        class="hover:bg-primary/5 transition-colors border-b border-border/50"
                        :class="[
                           { 'border-t-2 border-t-border': mIdx === 0 && gIdx > 0 },
                           marea.esDelegada ? 'bg-amber-500/[0.03]' : ''
                        ]">
                        <td class="px-4 py-2" :class="{ 'border-l-4 border-l-primary/30': mIdx > 0 }">
                           <span v-if="mIdx === 0"
                              class="text-[10px] font-black text-primary uppercase tracking-tight">
                              {{ group.pesqueria }}
                           </span>
                        </td>
                        <td class="px-4 py-2 text-xs font-bold text-text">{{ marea.buque }}</td>
                        <td class="px-4 py-2 text-xs font-black text-text tabular-nums">{{ marea.id_marea }}</td>
                        <td class="px-4 py-2 text-center">
                           <span v-if="marea.esDelegada"
                              class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider bg-amber-500/10 text-amber-600 border border-amber-500/20"
                              :title="marea.fechaDerivacion ? `Derivada el ${formatDate(marea.fechaDerivacion)}` : 'Derivada a proyecto externo'">
                              Derivada
                           </span>
                           <span v-else
                              class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider"
                              :class="marea.estado === 'Finalizada'
                                 ? 'bg-emerald-500/10 text-emerald-600 border border-emerald-500/20'
                                 : 'bg-sky-500/10 text-sky-600 border border-sky-500/20'">
                              {{ marea.estado === 'Finalizada' ? 'Fin.' : 'Ejec.' }}
                           </span>
                        </td>
                        <td class="px-4 py-2 text-xs font-bold text-text text-center tabular-nums">{{ marea.etapas }}</td>
                        <td class="px-4 py-2 text-center">
                           <span class="text-[10px] font-bold text-text-muted tabular-nums">
                              {{ marea.fechaZarpada ? formatDate(marea.fechaZarpada) : '—' }}
                           </span>
                        </td>
                        <td class="px-4 py-2 text-center">
                           <span class="text-[10px] font-bold text-text-muted tabular-nums">
                              {{ marea.fechaArribo ? formatDate(marea.fechaArribo) : '—' }}
                           </span>
                        </td>
                        <td class="px-4 py-2 text-right">
                           <span class="text-sm font-black text-text tabular-nums">{{ marea.dias }}</span>
                        </td>
                     </tr>
                  </template>
               </tbody>
               <tfoot class="sticky bottom-0 z-20">
                  <tr class="bg-background/95 backdrop-blur-md border-t-2 border-primary/20 shadow-md">
                     <td class="px-4 py-3 text-[10px] font-black text-text uppercase tracking-widest">TOTAL</td>
                     <td class="px-4 py-3 text-[10px] font-bold text-text-muted">{{ stats.totalMareas }} mareas</td>
                     <td class="px-4 py-3"></td>
                     <td class="px-4 py-3"></td>
                     <td class="px-4 py-3 text-xs font-black text-text text-center tabular-nums">{{ navData.totalEtapas }}</td>
                     <td class="px-4 py-3"></td>
                     <td class="px-4 py-3"></td>
                     <td class="px-4 py-3 text-right">
                        <span class="text-sm font-black text-primary tabular-nums">{{ stats.totalDaysNavigated.toLocaleString() }}</span>
                     </td>
                  </tr>
               </tfoot>
            </table>
         </div>
      </div>

      <!-- Nota explicativa sobre derivadas -->
      <div v-if="navData.delegadas > 0"
         class="mx-5 my-4 flex items-start gap-3 bg-amber-500/5 border border-amber-500/20 rounded-xl px-4 py-3">
         <span class="text-amber-500 mt-0.5 text-xs">⚠</span>
         <p class="text-[10px] font-medium text-amber-700/80 leading-relaxed">
            <span class="font-black">{{ navData.delegadas }} marea{{ navData.delegadas > 1 ? 's derivadas' : ' derivada' }}</span>
            a proyecto{{ navData.delegadas > 1 ? 's' : '' }} externo{{ navData.delegadas > 1 ? 's' : '' }} para validación de datos.
            La demora en la confección del informe correspondiente es ajena al Proyecto Observadores a Bordo.
         </p>
      </div>
   </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { DashboardStats, MareaDistributionItem, StatsDetailItem } from '../services/stats.service'

const props = defineProps<{
   stats: DashboardStats
   detailItems: StatsDetailItem[]
   distributionData: MareaDistributionItem[]
   year: number
   mode: 'CALENDAR' | 'TOTAL'
   endDate: string | null
}>()

interface NavMarea {
   id_marea: string
   buque: string
   pesqueria: string
   flota: string
   estado: string
   estadoActual: string
   esDelegada: boolean
   etapas: number
   dias: number
   fechaZarpada: string | null
   fechaArribo: string | null
   fechaDerivacion: string | null
}

const formatDate = (d: string | null) => {
   if (!d) return '—'
   return new Date(d).toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit', year: '2-digit' })
}

const etapasPorMarea = computed(() => {
   const map = new Map<string, number>()
   props.distributionData.forEach(item => {
      const cur = map.get(item.mareaId) || 0
      map.set(item.mareaId, Math.max(cur, item.nroEtapa))
   })
   return map
})

const sortMareas = (items: NavMarea[]) => {
   return [...items].sort((a, b) => {
      const regex = /^([A-Z]+)-(\d+)-(\d+)$/
      const mA = a.id_marea.match(regex)
      const mB = b.id_marea.match(regex)
      if (mA && mB) {
         const typeComp = mB[1].localeCompare(mA[1])
         if (typeComp !== 0) return typeComp
         const yearComp = mA[3].localeCompare(mB[3])
         if (yearComp !== 0) return yearComp
         return parseInt(mA[2]) - parseInt(mB[2])
      }
      return a.id_marea.localeCompare(b.id_marea)
   })
}

const navData = computed(() => {
   if (!props.detailItems.length) {
      return { finalizadas: 0, enEjecucion: 0, delegadas: 0, totalEtapas: 0, grouped: [] as { pesqueria: string, mareas: NavMarea[] }[] }
   }

   const limitDateStr = props.endDate ?? `${props.year}-12-31`
   const todayStr = new Date().toISOString().substring(0, 10)
   const isPeriodOpen = limitDateStr >= todayStr

   const mareasRaw: NavMarea[] = props.detailItems.map(item => {
      const esDelegada = item.estadoActual === 'DELEGADA_EXTERNA'

      let estadoAuditoria = 'Finalizada'
      if (esDelegada) {
         estadoAuditoria = 'Derivada'
      } else if (isPeriodOpen && item.estado === 'En ejecución') {
         estadoAuditoria = 'En ejecución'
      } else if (!item.fechaFin) {
         estadoAuditoria = 'En ejecución'
      } else {
         const finDate = item.fechaFin.substring(0, 10)
         if (finDate > limitDateStr) estadoAuditoria = 'En ejecución'
      }

      return {
         id_marea: item.id_marea,
         buque: item.buque,
         pesqueria: item.pesqueria,
         flota: item.flota,
         estado: estadoAuditoria,
         estadoActual: item.estadoActual,
         esDelegada,
         etapas: etapasPorMarea.value.get(item.id) || 1,
         dias: props.mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales,
         fechaZarpada: item.fechaZarpada ?? null,
         fechaArribo: item.fechaArribo ?? null,
         fechaDerivacion: item.fechaDerivacion ?? null,
      }
   })

   const sorted = sortMareas(mareasRaw)

   const groupMap = new Map<string, NavMarea[]>()
   sorted.forEach(m => {
      if (!groupMap.has(m.pesqueria)) groupMap.set(m.pesqueria, [])
      groupMap.get(m.pesqueria)!.push(m)
   })

   const grouped = Array.from(groupMap.entries()).map(([pesqueria, mareas]) => ({ pesqueria, mareas }))

   return {
      finalizadas: sorted.filter(m => m.estado === 'Finalizada').length,
      enEjecucion: sorted.filter(m => m.estado === 'En ejecución').length,
      delegadas: sorted.filter(m => m.esDelegada).length,
      totalEtapas: sorted.reduce((s, m) => s + m.etapas, 0),
      grouped,
   }
})
</script>
