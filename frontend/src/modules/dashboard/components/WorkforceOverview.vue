<template>
  <div
    class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900"
  >
    <div class="grid grid-cols-1 gap-12 lg:grid-cols-12">
      <!-- Section: Distribution Chart -->
      <div class="lg:col-span-8">
        <div class="flex items-center gap-3 mb-8">
           <div class="p-2 bg-indigo-50 dark:bg-indigo-900/20 rounded-xl">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-indigo-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
           </div>
           <div>
              <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest leading-tight">
                Estado del Personal
              </h2>
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Distribución operativa de observadores</p>
           </div>
        </div>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <div
            v-for="status in distributions"
            :key="status.label"
            class="group flex flex-col items-center justify-center p-6 rounded-2xl bg-gray-50/50 dark:bg-gray-800/30 border border-transparent hover:border-indigo-100 dark:hover:border-indigo-900/30 transition-all"
          >
            <div class="text-sm font-black text-gray-400 uppercase tracking-widest mb-1 text-center">
              {{ status.label }}
            </div>
            <div class="text-3xl font-black mb-1 transition-transform group-hover:scale-110" :class="status.colorClass">
              {{ status.count }} <span class="text-xs font-black text-gray-400">({{ status.value }}%)</span>
            </div>
            <div class="mt-4 h-1.5 w-full bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
              <div
                class="h-full rounded-full transition-all duration-1000"
                :class="status.bgClass"
                :style="{ width: status.value + '%' }"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Section: Top Dry Time -->
      <div class="lg:col-span-4 border-l border-gray-50 dark:border-gray-800 pl-8">
        <h2 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-6">
           Días sin Navegar (Top 5)
        </h2>
        <div class="space-y-5">
          <div v-for="(obs, index) in topDryTime" :key="obs.id" class="group flex items-center gap-4">
            <div class="text-[10px] font-black text-gray-300 group-hover:text-brand-500 transition-colors">#0{{ index + 1 }}</div>
            <div class="flex-1">
              <div class="flex items-center justify-between mb-1">
                <span class="text-xs font-black text-gray-800 dark:text-gray-200 group-hover:text-brand-500 transition-colors">{{
                  obs.name
                }}</span>
                <span class="text-xs font-black text-orange-600 dark:text-orange-400"
                  >{{ obs.days }} d</span
                >
              </div>
              <div class="h-1 w-full bg-gray-50 dark:bg-gray-800 rounded-full">
                <div
                  class="h-full bg-orange-500 rounded-full transition-all duration-700"
                  :style="{ width: Math.min(obs.days * 2, 100) + '%' }"
                ></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import dashboardService, { WorkforceStatus } from '../services/dashboard.service'

type DistributionItem = {
  label: string
  count: number | string
  value: number
  colorClass: string
  bgClass: string
}

const distributions = ref<DistributionItem[]>([])
const topDryTime = ref<Array<{ id: string; name: string; days: number }>>([])

const loadWorkforce = async () => {
  try {
    const data: WorkforceStatus = await dashboardService.getWorkforceStatus()
    const base = data.totalActivos || 1

    distributions.value = [
      {
        label: 'Navegando',
        count: data.navegando,
        value: Math.round((data.navegando / base) * 100),
        colorClass: 'text-blue-500',
        bgClass: 'bg-blue-500'
      },
      {
        label: 'Descanso',
        count: data.descanso,
        value: Math.round((data.descanso / base) * 100),
        colorClass: 'text-indigo-500',
        bgClass: 'bg-indigo-500'
      },
      {
        label: 'Disponibles',
        count: data.disponibles,
        value: Math.round((data.disponibles / base) * 100),
        colorClass: 'text-emerald-500',
        bgClass: 'bg-emerald-500'
      },
      {
        label: 'Licencia',
        count: data.licencia ?? '?',
        value: data.licencia === '?' ? 0 : Math.round(((data.licencia as number) / base) * 100),
        colorClass: 'text-gray-400',
        bgClass: 'bg-gray-400'
      }
    ]

    topDryTime.value = data.topDry || []
  } catch (error) {
    toast.error('No se pudo cargar el estado del personal.')
    distributions.value = []
    topDryTime.value = []
  }
}

onMounted(() => {
  loadWorkforce()
})
</script>
