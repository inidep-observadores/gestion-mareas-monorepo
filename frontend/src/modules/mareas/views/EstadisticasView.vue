<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">
            Estadísticas Anuales de Mareas
          </h1>
          <p class="text-gray-500 dark:text-gray-400">
            Análisis agregado del desempeño y actividad del sistema.
          </p>
        </div>
        <div>
          <select
            class="px-4 py-2 border border-gray-200 dark:border-gray-700 rounded-lg bg-white dark:bg-gray-800 text-sm font-medium"
          >
            <option>Año 2023</option>
            <option>Año 2022</option>
          </select>
        </div>
      </div>

      <!-- General Activity KPIs -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div
          class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-5 rounded-xl"
        >
          <div class="text-sm text-gray-500 mb-1">Mareas Realizadas</div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">142</div>
          <div class="text-xs text-green-500 mt-2">↑ 12% vs año anterior</div>
        </div>
        <div
          class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-5 rounded-xl"
        >
          <div class="text-sm text-gray-500 mb-1">Días Navegados</div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">2.450</div>
          <div class="text-xs text-gray-400 mt-2">Promedio 17.2 días/marea</div>
        </div>
        <div
          class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-5 rounded-xl"
        >
          <div class="text-sm text-gray-500 mb-1">Calidad de Datos</div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">94%</div>
          <div class="text-xs text-green-500 mt-2">Sin alertas críticas</div>
        </div>
        <div
          class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-5 rounded-xl"
        >
          <div class="text-sm text-gray-500 mb-1">Observadores</div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">48</div>
          <div class="text-xs text-gray-400 mt-2">Activos en el periodo</div>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-6">
        <!-- Main Chart Placeholder -->
        <div class="col-span-12 lg:col-span-8">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-6 rounded-xl h-full"
          >
            <h3 class="font-bold text-gray-800 dark:text-white mb-6">Mareas por Mes</h3>
            <div class="flex items-end justify-between h-64 px-4">
              <div
                v-for="(h, i) in [40, 60, 45, 80, 70, 90, 100, 85, 75, 60, 50, 45]"
                :key="i"
                class="w-8 bg-brand-500/20 hover:bg-brand-500 transition-colors rounded-t-sm relative group cursor-pointer"
                :style="{ height: h + '%' }"
              >
                <div
                  class="hidden group-hover:block absolute -top-8 left-1/2 -translate-x-1/2 bg-gray-800 text-white text-[10px] px-2 py-1 rounded"
                >
                  {{ h }}
                </div>
              </div>
            </div>
            <div class="flex justify-between mt-4 text-[10px] text-gray-400 uppercase font-medium">
              <span>Ene</span><span>Feb</span><span>Mar</span><span>Abr</span><span>May</span
              ><span>Jun</span><span>Jul</span><span>Ago</span><span>Sep</span><span>Oct</span
              ><span>Nov</span><span>Dic</span>
            </div>
          </div>
        </div>

        <!-- Distributions -->
        <div class="col-span-12 lg:col-span-4 space-y-6">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-6 rounded-xl"
          >
            <h3 class="font-bold text-gray-800 dark:text-white mb-4 text-sm">
              Distribución por Pesquería
            </h3>
            <div class="space-y-3">
              <div v-for="(p, i) in pesquerias" :key="i" class="space-y-1">
                <div class="flex justify-between text-xs">
                  <span class="text-gray-600 dark:text-gray-400">{{ p.nombre }}</span>
                  <span class="font-bold text-gray-800 dark:text-white">{{ p.porcentaje }}%</span>
                </div>
                <div class="h-1.5 w-full bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
                  <div class="h-full bg-brand-500" :style="{ width: p.porcentaje + '%' }"></div>
                </div>
              </div>
            </div>
          </div>

          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-6 rounded-xl shadow-sm"
          >
            <div class="flex items-center gap-3">
              <div class="p-2 bg-green-50 dark:bg-green-900/20 rounded-lg">
                <PieChartIcon class="w-5 h-5 text-green-500" />
              </div>
              <div>
                <div class="text-sm font-bold text-gray-800 dark:text-white">
                  Reporte de Eficiencia
                </div>
                <div class="text-xs text-gray-500">Generar PDF detallado</div>
              </div>
              <button class="ml-auto p-1.5 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg">
                <PlusIcon class="w-4 h-4 text-gray-500" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { PieChartIcon, PlusIcon } from '@/icons'

const pesquerias = [
  { nombre: 'Langostino', porcentaje: 45 },
  { nombre: 'Merluza Hubbsi', porcentaje: 30 },
  { nombre: 'Calamar Illex', porcentaje: 15 },
  { nombre: 'Otras', porcentaje: 10 },
]
</script>
