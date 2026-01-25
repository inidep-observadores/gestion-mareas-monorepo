<script setup lang="ts">
import { FileBarChart, PieChart, BarChart3, Download, Calendar } from 'lucide-vue-next';
</script>

<template>
  <div class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
    <!-- Header Section -->
    <div class="flex items-end justify-between">
      <div>
        <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">Centro de Reportes</h1>
        <p class="text-slate-500 mt-2 font-medium">Analítica avanzada y exportación de datos de mareas.</p>
      </div>
      
      <div class="flex space-x-3">
        <button class="flex items-center space-x-2 px-4 py-2 bg-white border border-slate-200 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-all shadow-sm">
          <Calendar :size="16" />
          <span>Último Mes</span>
        </button>
        <button class="flex items-center space-x-2 px-4 py-2 bg-slate-900 text-white rounded-xl text-sm font-semibold hover:bg-slate-800 transition-all shadow-lg shadow-slate-200">
          <Download :size="16" />
          <span>Exportar PDF</span>
        </button>
      </div>
    </div>

    <!-- Quick Stats Mockup -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
      <div v-for="i in 4" :key="i" class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm">
        <div class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Indicador {{ i }}</div>
        <div class="text-2xl font-black text-slate-900">84.2%</div>
        <div class="flex items-center mt-2 text-emerald-500 text-xs font-bold">
          <span>+12.5%</span>
          <span class="text-slate-300 ml-1 font-medium">vs mes ant.</span>
        </div>
      </div>
    </div>

    <!-- Charts Placeholder -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm min-h-[400px] flex flex-col">
        <div class="flex items-center justify-between mb-8">
          <h3 class="font-bold text-slate-900 text-lg flex items-center gap-2">
            <BarChart3 :size="20" class="text-blue-500" />
            Tendencia Temporal
          </h3>
        </div>
        <div class="flex-1 bg-slate-50 rounded-2xl flex items-center justify-center border-2 border-dashed border-slate-100">
          <span class="text-slate-400 font-medium">Visualización de Datos en Preparación</span>
        </div>
      </div>

      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm min-h-[400px] flex flex-col">
        <div class="flex items-center justify-between mb-8">
          <h3 class="font-bold text-slate-900 text-lg flex items-center gap-2">
            <PieChart :size="20" class="text-indigo-500" />
            Distribución por Zona
          </h3>
        </div>
        <div class="flex-1 bg-slate-50 rounded-2xl flex items-center justify-center border-2 border-dashed border-slate-100">
          <span class="text-slate-400 font-medium">Gráfico de Distribución Mockup</span>
        </div>
      </div>
    </div>
  </div>
</template>
