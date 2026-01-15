<template>
  <AdminLayout
    title="Centro de Análisis"
    description="Inteligencia institucional y monitoreo de desempeño estratégico."
  >
    <div class="relative min-h-screen pb-20 animate-in fade-in duration-700">

      <!-- TOP ANALYTICS FILTERS -->
      <div class="mb-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6 bg-surface p-6 rounded-3xl border border-border shadow-sm">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center text-primary">
            <BarChartIcon class="w-6 h-6" />
          </div>
          <div>
            <h2 class="text-lg font-black text-gray-900 dark:text-white uppercase tracking-tighter leading-none">Análisis de Gestión</h2>
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Filtros dinámicos de periodo</p>
          </div>
        </div>

        <div class="flex flex-wrap items-center gap-3">
          <!-- Period Filter -->
          <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-2xl border border-border">
            <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Año</span>
            <select class="text-xs font-black bg-transparent border-none focus:ring-0 text-text cursor-pointer p-0 pr-6">
              <option>2025</option>
              <option>2024</option>
            </select>
          </div>

          <!-- Fishery Filter -->
          <div class="flex items-center gap-2 bg-surface-muted px-4 py-2 rounded-2xl border border-border">
            <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Pesquería</span>
            <select class="text-xs font-black bg-transparent border-none focus:ring-0 text-text cursor-pointer p-0 pr-6">
              <option>Todas las especies</option>
              <option>Langostino</option>
              <option>Merluza</option>
              <option>Calamar</option>
            </select>
          </div>

          <button class="bg-primary hover:bg-primary/90 text-primary-fg px-6 py-2 rounded-2xl text-[10px] font-black uppercase tracking-widest transition-all shadow-lg shadow-primary/20 active:scale-95">
            Actualizar Reporte
          </button>
        </div>
      </div>

      <!-- ROW 1: CORE ANALYTICAL KPIs -->
      <section class="mb-8">
        <AnalyticalKpis />
      </section>

      <!-- ROW 2: TEMPORAL TRENDS & EFFICIENCY -->
      <div class="grid grid-cols-12 gap-8 mb-8">
        <!-- Historical Trends -->
        <div class="col-span-12 lg:col-span-7 xl:col-span-8">
          <HistoricalTrends />
        </div>
        <!-- Efficiency SLA -->
        <div class="col-span-12 lg:col-span-5 xl:col-span-4">
          <EfficiencySLA />
        </div>
      </div>

      <!-- ROW 3: DETAILED FISHERY MATRIX -->
      <section class="mb-8">
        <FisheryComparisonMatrix />
      </section>

      <!-- ROW 4: OBSERVER LOGISTICS -->
      <section>
        <ObserverLogisticsTable />
      </section>

    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import AnalyticalKpis from '../components/AnalyticalKpis.vue'
import EfficiencySLA from '../components/EfficiencySLA.vue'
import FisheryComparisonMatrix from '../components/FisheryComparisonMatrix.vue'
import HistoricalTrends from '../components/HistoricalTrends.vue'
import ObserverLogisticsTable from '../components/ObserverLogisticsTable.vue'
import { BarChartIcon } from '@/icons'
</script>

<style scoped>
.animate-in {
  animation-duration: 0.7s;
  animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
}
.fade-in {
  animation-name: fade-in;
}

@keyframes fade-in {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
