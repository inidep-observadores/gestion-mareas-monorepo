<template>
   <div v-if="loading" class="flex items-center justify-center py-20">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
   </div>

   <div v-else-if="stats" class="space-y-4 animate-in fade-in duration-500">

      <!-- ── TOOLBAR ──────────────────────────────────────── -->
      <div class="flex items-center justify-between bg-surface p-5 rounded-2xl border border-border shadow-theme-xs">
         <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center">
               <FileBarChart2Icon class="w-6 h-6 text-primary" />
            </div>
            <div>
               <h2 class="text-lg font-black text-text tracking-tight uppercase leading-none">Informe de Auditoría</h2>
               <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-1.5 flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                  Datos consolidados del período {{ year }}
               </p>
            </div>
         </div>
         <div class="flex items-center gap-2">
            <ExportWordButton
               :loading="exportingWord"
               label="GENERAR INFORME"
               title="Generar informe narrativo completo en formato Word (.docx)"
               class="px-4 py-2.5 rounded-xl border border-blue-500/20 bg-surface shadow-theme-xs"
               @click="handleExportWord" />
            <ExportPdfButton
               :loading="exportingPdf"
               label="PREVISUALIZAR"
               title="Previsualizar informe completo en formato PDF en una nueva pestaña"
               class="px-4 py-2.5 rounded-xl border border-emerald-500/20 bg-surface shadow-theme-xs"
               @click="handleExportPdf" />
            <ExportExcelButton
               :loading="exporting"
               label="DATOS EXCEL"
               title="Exportar análisis completo para auditoría (4 hojas)"
               class="px-4 py-2.5 rounded-xl border border-primary/20 bg-surface shadow-theme-xs"
               @click="handleExportAudit" />
         </div>
      </div>

      <!-- ── KPI SUMMARY BAR ─────────────────────────────── -->
      <AuditSummaryBar
         :stats="stats"
         :cobertura-pct="coberturaPct"
         :special-counts="specialCounts"
         :timeline-data="timelineData" />

      <!-- ── TAB BAR + CONTENT ───────────────────────────── -->
      <div class="bg-surface rounded-2xl border border-border shadow-theme-xs overflow-hidden">
         <!-- Tab bar -->
         <div class="flex items-center border-b border-border overflow-x-auto">
            <button v-for="tab in tabs" :key="tab.id"
               @click="setTab(tab.id)"
               class="relative flex items-center gap-2 px-5 py-4 text-[11px] font-black uppercase tracking-widest transition-colors whitespace-nowrap shrink-0"
               :class="activeTab === tab.id
                  ? 'text-primary bg-primary/5'
                  : 'text-text-muted hover:text-text hover:bg-surface-muted/30'">
               <component :is="tab.icon" class="w-4 h-4" />
               {{ tab.label }}
               <span v-if="tab.badge && tab.badge > 0"
                  class="ml-1 min-w-4.5 h-4.5 px-1 rounded-full bg-amber-500 text-white text-[9px] font-black flex items-center justify-center tabular-nums">
                  {{ tab.badge }}
               </span>
               <div v-if="activeTab === tab.id"
                  class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-t-full" />
            </button>
         </div>

         <!-- Tab content -->
         <div class="min-h-100">
            <AuditPersonalTab v-if="activeTab === 'personal'"
               :stats="stats"
               :year="year"
               :dotacion-total="dotacionTotal"
               :dotacion-referencia="dotacionReferencia"
               :cobertura-pct="coberturaPct"
               :secondary-stats="secondaryStats" />

            <AuditNavegacionTab v-else-if="activeTab === 'navegacion'"
               :stats="stats"
               :detail-items="detailItems"
               :distribution-data="distributionData"
               :year="year"
               :mode="mode"
               :end-date="endDate" />

            <AuditPesqueriasTab v-else-if="activeTab === 'pesquerias'"
               :stats="stats"
               :detail-items="detailItems"
               :distribution-data="distributionData"
               :year="year"
               :mode="mode"
               :end-date="endDate" />

            <AuditSeguimientoTab v-else-if="activeTab === 'seguimiento'"
               :special-cases="specialCasesData"
               :timeline="timelineData"
               :loading="seguimientoLoading"
               :year="year" />
         </div>
      </div>
   </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import {
   UsersIcon, ShipIcon, BarChart3Icon,
   AlertTriangleIcon, FileBarChart2Icon
} from 'lucide-vue-next'
import AuditSummaryBar from './AuditSummaryBar.vue'
import AuditPersonalTab from './AuditPersonalTab.vue'
import AuditNavegacionTab from './AuditNavegacionTab.vue'
import AuditPesqueriasTab from './AuditPesqueriasTab.vue'
import AuditSeguimientoTab from './AuditSeguimientoTab.vue'
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue'
import ExportWordButton from '@/modules/shared/components/ExportWordButton.vue'
import ExportPdfButton from '@/modules/shared/components/ExportPdfButton.vue'
import { useThemeStore } from '@/modules/shared/stores/theme.store'
import { storeToRefs } from 'pinia'
import type {
   DashboardStats, MareaDistributionItem, StatsDetailItem,
   AuditSpecialCasesResult, ProtocolizationTimelineResult, ObserverSecondaryStats
} from '../services/stats.service'
import { statsService } from '../services/stats.service'
import dashboardService from '@/modules/dashboard/services/dashboard.service'

const props = defineProps<{
   stats: DashboardStats | null
   distributionData: MareaDistributionItem[]
   year: number
   mode: 'CALENDAR' | 'TOTAL'
   loading: boolean
   protocolizedOnly: boolean
   includeOutOfPeriod: boolean
   daysCalculationMode: 'SHIP' | 'OBSERVER'
   includeCampaigns: boolean
   startDate: string | null
   endDate: string | null
}>()

const themeStore = useThemeStore()
const { darkMode } = storeToRefs(themeStore)

// ── Tabs ──────────────────────────────────────────────────
type TabId = 'personal' | 'navegacion' | 'pesquerias' | 'seguimiento'
const activeTab = ref<TabId>('personal')
const seguimientoLoaded = ref(false)

const tabs = computed(() => [
   { id: 'personal' as TabId,    label: 'Personal',    icon: UsersIcon,          badge: 0 },
   { id: 'navegacion' as TabId,  label: 'Navegación',  icon: ShipIcon,           badge: 0 },
   { id: 'pesquerias' as TabId,  label: 'Pesquerías',  icon: BarChart3Icon,       badge: 0 },
   { id: 'seguimiento' as TabId, label: 'Seguimiento', icon: AlertTriangleIcon,  badge: specialCounts.value.total },
])

const setTab = (id: TabId) => {
   activeTab.value = id
   if (id === 'seguimiento' && !seguimientoLoaded.value) {
      fetchSeguimientoData()
   }
}

// ── Dotación ──────────────────────────────────────────────
const dotacionTotal = ref(0)

const fetchDotacion = async () => {
   try {
      const data = await dashboardService.getWorkforceStatus('OBSERVADOR')
      dotacionTotal.value = data.totalActivos
   } catch { dotacionTotal.value = 0 }
}

// ── Detail items ──────────────────────────────────────────
const detailItems = ref<StatsDetailItem[]>([])

const fetchDetailData = async () => {
   if (!props.stats) return
   try {
      detailItems.value = await statsService.getDashboardStatsDetail(
         props.year, props.mode,
         !props.protocolizedOnly, props.includeOutOfPeriod,
         null, null,
         props.daysCalculationMode, props.includeCampaigns,
         props.startDate || undefined, props.endDate || undefined,
         props.startDate || undefined, props.endDate || undefined
      )
   } catch (e) { console.error('Error fetching detail data:', e) }
}

// ── Secondary observers ───────────────────────────────────
const secondaryStats = ref<ObserverSecondaryStats[]>([])

const fetchSecondaryStats = async () => {
   try {
      secondaryStats.value = await statsService.getSecondaryObserverStats(
         props.year,
         props.startDate || undefined,
         props.endDate || undefined,
      )
   } catch { secondaryStats.value = [] }
}

// ── Seguimiento (pre-cargado para badge) ──────────────────
const specialCasesData = ref<AuditSpecialCasesResult | null>(null)
const timelineData = ref<ProtocolizationTimelineResult | null>(null)
const seguimientoLoading = ref(false)

const fetchSeguimientoData = async () => {
   seguimientoLoading.value = true
   try {
      const [special, timeline] = await Promise.all([
         statsService.getAuditSpecialCases(
            props.year,
            props.startDate || undefined,
            props.endDate || undefined,
            props.includeCampaigns,
         ),
         statsService.getProtocolizationTimeline(
            props.year,
            props.startDate || undefined,
            props.endDate || undefined,
         ),
      ])
      specialCasesData.value = special
      timelineData.value = timeline
      seguimientoLoaded.value = true
   } catch (e) { console.error('Error fetching seguimiento data:', e) }
   finally { seguimientoLoading.value = false }
}

// ── Computed ──────────────────────────────────────────────
const dotacionReferencia = computed(() => {
   const afectados = props.stats?.observers.length || 0
   return Math.max(afectados, dotacionTotal.value)
})

const coberturaPct = computed(() => {
   if (!props.stats || !dotacionReferencia.value) return 0
   return Math.round((props.stats.observers.length / dotacionReferencia.value) * 100)
})

const specialCounts = computed(() => {
   if (!specialCasesData.value) return { canceladas: 0, desestimadas: 0, pendientes: 0, delegadas: 0, total: 0 }
   const c = specialCasesData.value.canceladas.length
   const d = specialCasesData.value.desestimadas.length
   const p = specialCasesData.value.pendientesDeInforme.length
   const e = specialCasesData.value.delegadasExternas.length
   return { canceladas: c, desestimadas: d, pendientes: p, delegadas: e, total: c + d + p + e }
})

// ── Lifecycle ─────────────────────────────────────────────
onMounted(() => {
   fetchDotacion()
   fetchDetailData()
   fetchSecondaryStats()
   fetchSeguimientoData() // Pre-carga para el badge
})

watch(() => props.stats, () => {
   fetchDetailData()
   fetchSecondaryStats()
   seguimientoLoaded.value = false
   fetchSeguimientoData()
})

// ── Exports ───────────────────────────────────────────────
const exporting = ref(false)
const exportingWord = ref(false)
const exportingPdf = ref(false)

const handleExportAudit = async () => {
   if (!props.stats || exporting.value) return
   exporting.value = true
   try {
      await statsService.downloadExport(
         props.year, props.mode, !props.protocolizedOnly, props.includeOutOfPeriod,
         props.daysCalculationMode, props.includeCampaigns, 'AUDIT', undefined,
         `Anexo_Auditoria_Mareas_${props.year}`,
         props.startDate || undefined, props.endDate || undefined,
         props.startDate || undefined, props.endDate || undefined, true
      )
   } catch (e) { console.error('Error exporting audit report:', e) }
   finally { exporting.value = false }
}

const handleExportWord = async () => {
   if (!props.stats || exportingWord.value) return
   exportingWord.value = true
   try {
      await statsService.downloadAuditReport(
         props.year, props.mode, !props.protocolizedOnly, props.includeOutOfPeriod,
         props.includeCampaigns, `Informe_Auditoria_Mareas_${props.year}`,
         props.startDate || undefined, props.endDate || undefined,
         props.startDate || undefined, props.endDate || undefined
      )
   } catch (e) { console.error('Error exporting word audit report:', e) }
   finally { exportingWord.value = false }
}

const handleExportPdf = async () => {
   if (!props.stats || exportingPdf.value) return
   
   // Abrir ventana inmediatamente para evitar bloqueo de popup
   const reportWindow = window.open('', '_blank')
   if (reportWindow) {
      const isDarkMode = darkMode.value
      reportWindow.document.write(`
         <!DOCTYPE html>
         <html lang="es" ${isDarkMode ? 'class="dark"' : ''}>
         <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Generando Informe SIGMA</title>
            <style>
               body { 
                  margin: 0; 
                  display: flex; 
                  align-items: center; 
                  justify-content: center; 
                  min-height: 100vh;
                  min-height: 100dvh;
                  font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; 
                  background: #f8fafc;
                  color: #0f172a;
                  -webkit-font-smoothing: antialiased;
               }
               .container { 
                  text-align: center; 
                  max-width: 450px; 
                  padding: 2rem; 
                  width: 100%;
                  box-sizing: border-box;
               }
               .spinner {
                  width: 56px;
                  height: 56px;
                  border: 5px solid #e2e8f0;
                  border-bottom-color: #465fff;
                  border-radius: 50%;
                  display: inline-block;
                  box-sizing: border-box;
                  animation: rotation 1s linear infinite;
                  margin-bottom: 28px;
               }
               @keyframes rotation { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
               h1 { 
                  font-size: 1.1rem; 
                  font-weight: 900; 
                  margin: 0 0 12px 0; 
                  letter-spacing: 0.05em; 
                  text-transform: uppercase; 
                  color: #1e293b;
               }
               p { font-size: 0.9rem; color: #64748b; margin: 0; line-height: 1.6; font-weight: 500; }
               .brand { 
                  margin-top: 40px; 
                  font-size: 0.75rem; 
                  font-weight: 800; 
                  color: #465fff; 
                  letter-spacing: 0.1em;
                  opacity: 0.5;
               }

               @media (max-width: 480px) {
                  .container { padding: 1.5rem; }
                  h1 { font-size: 1rem; }
                  p { font-size: 0.85rem; }
                  .brand { margin-top: 32px; }
               }
               
               /* Tema Oscuro (basado en clase .dark) */
               .dark body { background: #020617; color: #f1f5f9; }
               .dark .spinner { border-color: #1e293b; border-bottom-color: #3b82f6; }
               .dark h1 { color: #f1f5f9; }
               .dark p { color: #94a3b8; }
               .dark .brand { color: #3b82f6; }
            </style>
         </head>
         <body>
            <div class="container">
               <div class="spinner"></div>
               <h1>Generando Informe</h1>
               <p>Estamos procesando y validando los datos.<br>Por favor, mantenga esta ventana abierta.</p>
               <div class="brand">SIGMA • INIDEP</div>
            </div>
         </body>
         </html>
      `);
      reportWindow.document.close();
   }

   exportingPdf.value = true
   try {
      const url = await statsService.openAuditReportPdf(
         props.year, props.mode, !props.protocolizedOnly, props.includeOutOfPeriod,
         props.includeCampaigns,
         props.startDate || undefined, props.endDate || undefined,
         props.startDate || undefined, props.endDate || undefined
      )
      
      if (reportWindow) {
         reportWindow.location.href = url
      } else {
         // Fallback si por alguna razón falló el window.open inicial
         window.open(url, '_blank')
      }
   } catch (e) { 
      console.error('Error opening pdf audit report:', e)
      if (reportWindow) reportWindow.close()
   }
   finally { exportingPdf.value = false }
}
</script>

<style scoped>
.animate-in { animation-duration: 0.3s; animation-timing-function: cubic-bezier(0, 0, 0.2, 1); }
.fade-in { animation-name: fadeIn; }
@keyframes fadeIn {
   from { opacity: 0; transform: translateY(5px); }
   to { opacity: 1; transform: translateY(0); }
}
</style>
