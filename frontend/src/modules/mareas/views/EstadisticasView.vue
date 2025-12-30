<template>
  <AdminLayout 
    title="Panel de Estadísticas y KPIs" 
    description="Monitoreo en tiempo real del flujo de trabajo y desempeño institucional."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1 pb-10">
      <!-- FILTERS -->
      <div class="mb-8 flex justify-end">

        <!-- Filter Bar -->
        <div
          class="flex flex-wrap items-center gap-3 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-2 rounded-2xl shadow-sm"
        >
          <div class="flex items-center gap-2 px-3 border-r border-gray-100 dark:border-gray-800">
            <span class="text-[10px] font-bold text-gray-400 uppercase">Periodo</span>
            <select
              class="text-xs font-bold bg-transparent border-none focus:ring-0 cursor-pointer text-gray-700 dark:text-gray-300"
            >
              <option>Año 2025</option>
              <option>Año 2024</option>
            </select>
            <select
              class="text-xs font-bold bg-transparent border-none focus:ring-0 cursor-pointer text-gray-700 dark:text-gray-300"
            >
              <option>Todos los meses</option>
              <option>Enero</option>
              <option>Febrero</option>
            </select>
          </div>
          <div class="flex items-center gap-2 px-3 border-r border-gray-100 dark:border-gray-800">
            <span class="text-[10px] font-bold text-gray-400 uppercase">Pesquería</span>
            <select
              class="text-xs font-bold bg-transparent border-none focus:ring-0 cursor-pointer text-gray-700 dark:text-gray-300"
            >
              <option>Todas</option>
              <option>Langostino</option>
              <option>Merluza</option>
            </select>
          </div>
          <div class="flex items-center gap-2 px-3">
            <span class="text-[10px] font-bold text-gray-400 uppercase">Estado</span>
            <select
              class="text-xs font-bold bg-transparent border-none focus:ring-0 cursor-pointer text-gray-700 dark:text-gray-300"
            >
              <option>Todos</option>
              <option>Navegando</option>
              <option>Protocolizada</option>
            </select>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-6">
        <!-- MODULE A: Workflow Performance -->
        <div class="col-span-12 lg:col-span-12 xl:col-span-8">
          <WorkflowFunnel :data="funnelData" />
        </div>

        <!-- NOTIFICATIONS / ALERTS -->
        <div class="col-span-12 lg:col-span-12 xl:col-span-4">
          <AlertSection />
        </div>

        <!-- MODULE B: Observer Logistics -->
        <div class="col-span-12 lg:col-span-7 xl:col-span-8">
          <ObserverLogisticsTable />
        </div>

        <!-- MODULE C: Strategic KPIs -->
        <div class="col-span-12 lg:col-span-5 xl:col-span-4 space-y-6">
          <GaugeChart
            title="Cobertura Real vs Objetivo"
            subtitle="Basado en plan anual por pesquería"
            :value="84"
            colorType="brand"
          />

          <!-- Efficiency Card -->
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-6 rounded-2xl shadow-sm"
          >
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-sm font-bold text-gray-500 uppercase tracking-wider">
                Eficiencia de Oficina
              </h3>
              <span
                class="px-2 py-1 bg-success-50 dark:bg-success-500/10 text-success-600 dark:text-success-400 text-[10px] rounded-lg"
              >
                ↑ 12% vs 2024
              </span>
            </div>
            <div class="flex items-baseline gap-2">
              <span class="text-3xl text-gray-800 dark:text-white">28.5</span>
              <span class="text-xs text-gray-400 font-medium uppercase"
                >días promedio de cierre</span
              >
            </div>
            <div class="mt-4 h-2 w-full bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
              <div class="h-full bg-success-500 w-[75%] rounded-full"></div>
            </div>
            <p class="text-[10px] text-gray-400 mt-2 font-medium">Meta institucional: 25 días</p>
          </div>
        </div>

        <!-- MODULE D: Statistics by Fishery -->
        <div class="col-span-12">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-6 rounded-2xl shadow-sm"
          >
            <div class="mb-6">
              <h3 class="text-sm font-bold text-gray-500 uppercase tracking-wider">
                Estadísticas por Pesquería
              </h3>
              <p class="text-xs text-gray-400 mt-1">
                Distribución de mareas y cobertura por tipo de pesquería
              </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <!-- Langostino -->
              <div
                class="bg-gradient-to-br from-orange-50 to-orange-100/50 dark:from-orange-900/10 dark:to-orange-800/5 p-5 rounded-xl border border-orange-200 dark:border-orange-800/30"
              >
                <div class="flex items-center justify-between mb-3">
                  <h4 class="text-sm font-bold text-orange-900 dark:text-orange-300">Langostino</h4>
                  <div class="p-2 bg-orange-500/10 rounded-lg">
                    <WaveIcon class="w-5 h-5 text-orange-600 dark:text-orange-400" />
                  </div>
                </div>
                <div class="space-y-2">
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs text-orange-700 dark:text-orange-400">Mareas totales</span>
                    <span class="text-2xl font-bold text-orange-900 dark:text-orange-200">45</span>
                  </div>
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs text-orange-700 dark:text-orange-400">Cobertura</span>
                    <span class="text-lg font-bold text-orange-900 dark:text-orange-200">89%</span>
                  </div>
                  <div
                    class="mt-3 h-2 w-full bg-orange-200 dark:bg-orange-900/30 rounded-full overflow-hidden"
                  >
                    <div class="h-full bg-orange-500 w-[89%] rounded-full"></div>
                  </div>
                </div>
              </div>

              <!-- Merluza -->
              <div
                class="bg-gradient-to-br from-blue-50 to-blue-100/50 dark:from-blue-900/10 dark:to-blue-800/5 p-5 rounded-xl border border-blue-200 dark:border-blue-800/30"
              >
                <div class="flex items-center justify-between mb-3">
                  <h4 class="text-sm font-bold text-blue-900 dark:text-blue-300">Merluza</h4>
                  <div class="p-2 bg-blue-500/10 rounded-lg">
                    <WaveIcon class="w-5 h-5 text-blue-600 dark:text-blue-400" />
                  </div>
                </div>
                <div class="space-y-2">
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs text-blue-700 dark:text-blue-400">Mareas totales</span>
                    <span class="text-2xl font-bold text-blue-900 dark:text-blue-200">67</span>
                  </div>
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs text-blue-700 dark:text-blue-400">Cobertura</span>
                    <span class="text-lg font-bold text-blue-900 dark:text-blue-200">92%</span>
                  </div>
                  <div
                    class="mt-3 h-2 w-full bg-blue-200 dark:bg-blue-900/30 rounded-full overflow-hidden"
                  >
                    <div class="h-full bg-blue-500 w-[92%] rounded-full"></div>
                  </div>
                </div>
              </div>

              <!-- Calamar -->
              <div
                class="bg-gradient-to-br from-purple-50 to-purple-100/50 dark:from-purple-900/10 dark:to-purple-800/5 p-5 rounded-xl border border-purple-200 dark:border-purple-800/30"
              >
                <div class="flex items-center justify-between mb-3">
                  <h4 class="text-sm font-bold text-purple-900 dark:text-purple-300">Calamar</h4>
                  <div class="p-2 bg-purple-500/10 rounded-lg">
                    <WaveIcon class="w-5 h-5 text-purple-600 dark:text-purple-400" />
                  </div>
                </div>
                <div class="space-y-2">
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs text-purple-700 dark:text-purple-400">Mareas totales</span>
                    <span class="text-2xl font-bold text-purple-900 dark:text-purple-200">38</span>
                  </div>
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs text-purple-700 dark:text-purple-400">Cobertura</span>
                    <span class="text-lg font-bold text-purple-900 dark:text-purple-200">76%</span>
                  </div>
                  <div
                    class="mt-3 h-2 w-full bg-purple-200 dark:bg-purple-900/30 rounded-full overflow-hidden"
                  >
                    <div class="h-full bg-purple-500 w-[76%] rounded-full"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- MOCK DETAIL MODAL (Hidden by default, shown for demo purpose in logic) -->
    <div
      v-if="showDetail"
      class="fixed inset-0 z-99999 flex items-center justify-center bg-gray-900/60 backdrop-blur-sm p-4"
    >
      <div
        class="bg-white dark:bg-gray-900 w-full max-w-2xl rounded-3xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200"
      >
        <div
          class="p-6 border-b border-gray-100 dark:border-gray-800 flex justify-between items-center"
        >
          <div>
            <span
              class="text-[10px] bg-brand-50 text-brand-600 px-2 py-0.5 rounded-full mb-1 inline-block"
              >ID: MAR-2025-042</span
            >
            <h2 class="text-xl font-bold text-gray-800 dark:text-white">Detalle de Marea y Log</h2>
          </div>
          <button
            @click="showDetail = false"
            class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </div>
        <div class="p-6">
          <div class="space-y-6">
            <div v-for="(step, i) in history" :key="i" class="relative pl-8 pb-6 last:pb-0">
              <div
                v-if="i < history.length - 1"
                class="absolute left-[11px] top-6 bottom-0 w-0.5 bg-gray-100 dark:bg-gray-800"
              ></div>
              <div
                class="absolute left-0 top-1 w-6 h-6 rounded-full border-4 border-white dark:border-gray-900 flex items-center justify-center"
                :class="step.completed ? 'bg-success-500' : 'bg-gray-200 dark:bg-gray-700'"
              >
                <svg
                  v-if="step.completed"
                  xmlns="http://www.w3.org/2000/svg"
                  class="w-3 h-3 text-white"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
              <div>
                <div class="flex justify-between items-start">
                  <h4 class="text-sm font-bold text-gray-800 dark:text-gray-100">
                    {{ step.status }}
                  </h4>
                  <span class="text-[10px] text-gray-400 font-medium">{{ step.date }}</span>
                </div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Responsable:
                  <span class="font-bold text-gray-700 dark:text-gray-300">{{ step.user }}</span>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import WorkflowFunnel from '../components/WorkflowFunnel.vue'
import ObserverLogisticsTable from '../components/ObserverLogisticsTable.vue'
import GaugeChart from '../components/GaugeChart.vue'
import AlertSection from '../components/AlertSection.vue'
import { WaveIcon } from '@/icons'

const showDetail = ref(false)

const funnelData = {
  entrega: 12, // SLA > 10
  informe: 7, // SLA < 10
  protocolo: 18, // SLA > 10
}

const history = [
  { status: 'Protocolización', user: 'Admin Sistema', date: 'Pendiente', completed: false },
  {
    status: 'Informe Final Aprobado',
    user: 'Lic. Martin Paz',
    date: '21/12/2025',
    completed: true,
  },
  {
    status: 'Entrega de Materiales',
    user: 'Roberto Gómez (Obs)',
    date: '15/12/2025',
    completed: true,
  },
  { status: 'Fin de Marea', user: 'Capitán Buque', date: '01/12/2025', completed: true },
]

// Simulate interactivity for demonstration
setTimeout(() => {
  // Option to show detail by clicking something or just exposing the ref
}, 1000)
</script>

<style scoped>
/* Animations for the modal */
.animate-in {
  animation-duration: 0.2s;
  animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
}
.zoom-in {
  animation-name: zoom-in;
}
.fade-in {
  animation-name: fade-in;
}

@keyframes zoom-in {
  from {
    transform: scale(0.95);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
@keyframes fade-in {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>
