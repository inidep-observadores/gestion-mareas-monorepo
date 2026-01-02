<template>
  <div
    class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900"
  >
    <div class="grid grid-cols-1 gap-12 lg:grid-cols-12">
      <!-- Section: Distribution Chart -->
      <div class="lg:col-span-7">
        <div class="flex items-center gap-3 mb-10">
           <UserGroupIcon class="w-6 h-6 text-indigo-500" />
           <div>
              <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest leading-tight">
                Estado del Personal
              </h2>
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Distribución operativa de observadores</p>
           </div>
        </div>
        
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div
            v-for="status in distributions"
            :key="status.label"
            class="group relative flex flex-col items-center p-6 rounded-2xl bg-gray-50/50 dark:bg-gray-800/40 border border-gray-100 dark:border-gray-700 hover:bg-white dark:hover:bg-gray-800 hover:shadow-xl hover:border-indigo-100 dark:hover:border-indigo-800/50 transition-all duration-300"
          >
            <!-- Naked Icon (Better Symmetry) -->
            <div class="mb-5 transition-transform duration-300 group-hover:scale-110 group-hover:-translate-y-1">
              <component :is="status.icon" class="w-8 h-8" :class="status.colorClass" />
            </div>

            <div class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4 text-center transition-colors group-hover:text-gray-500">
              {{ status.label }}
            </div>

            <div class="flex flex-col items-center gap-0.5 mb-5">
              <span class="text-3xl font-black tabular-nums transition-colors" :class="status.colorClass">
                {{ status.count }}
              </span>
              <span class="text-[11px] font-bold text-gray-400 tabular-nums">
                ({{ status.value }}%)
              </span>
            </div>

            <!-- Progress Indicator -->
            <div class="w-full mt-auto">
              <div class="h-1.5 w-full bg-gray-100 dark:bg-gray-700/50 rounded-full overflow-hidden">
                <div
                  class="h-full rounded-full transition-all duration-1000 ease-out"
                  :class="status.bgClass"
                  :style="{ width: status.value + '%' }"
                ></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Section: Top Dry Time -->
      <div class="lg:col-span-5 border-l border-gray-50 dark:border-gray-800 lg:pl-8">
        <div class="flex items-center gap-2 mb-8">
          <HistoryIcon class="w-3.5 h-3.5 text-gray-400" />
          <h2 class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
             Días sin Navegar (Top 5)
          </h2>
        </div>

        <div class="space-y-4">
          <div v-for="(obs, index) in topDryTime" :key="obs.id" class="group/list flex items-center gap-4">
            <div class="w-6 text-[10px] font-black text-gray-300 group-hover/list:text-brand-500 transition-colors">0{{ index + 1 }}</div>
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between gap-3 mb-1.5">
                <div class="flex flex-col">
                  <span class="text-[12px] font-bold text-gray-800 dark:text-gray-200 truncate group-hover/list:text-brand-500 transition-colors">
                    {{ obs.name }}
                  </span>
                  <span class="text-[9px] font-bold text-gray-400 uppercase tracking-tighter">
                    Últ. Arribo: {{ formatDate(obs.lastArrival) }}
                  </span>
                </div>
                <div class="flex flex-col items-end">
                  <span class="text-[11px] font-black text-orange-600 dark:text-orange-400 whitespace-nowrap">
                    {{ obs.days }} días
                  </span>
                </div>
              </div>
              <div class="h-1.5 w-full bg-gray-50 dark:bg-gray-800/50 rounded-full overflow-hidden">
                <div
                  class="h-full bg-gradient-to-r from-orange-300 to-orange-500 rounded-full transition-all duration-700"
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
import { onMounted, ref, markRaw } from 'vue'
import { toast } from 'vue-sonner'
import { ShipIcon, HistoryIcon, UserGroupIcon, DocsIcon, HotelIcon } from '@/icons'
import dashboardService, { type WorkforceStatus } from '../services/dashboard.service'

type DistributionItem = {
  label: string
  count: number | string
  value: number
  colorClass: string
  bgClass: string
  icon: any
}

const distributions = ref<DistributionItem[]>([])
const topDryTime = ref<WorkforceStatus['topDry']>([])

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit'
  })
}

const loadWorkforce = async () => {
  try {
    const data = await dashboardService.getWorkforceStatus()
    const base = data.totalActivos || 1

    distributions.value = [
      {
        label: 'Navegando',
        count: data.navegando,
        value: Math.round((data.navegando / base) * 100),
        colorClass: 'text-blue-500',
        bgClass: 'bg-blue-500',
        icon: markRaw(ShipIcon)
      },
      {
        label: 'Descanso',
        count: data.descanso,
        value: Math.round((data.descanso / base) * 100),
        colorClass: 'text-indigo-500',
        bgClass: 'bg-indigo-500',
        icon: markRaw(HotelIcon)
      },
      {
        label: 'Disponibles',
        count: data.disponibles,
        value: Math.round((data.disponibles / base) * 100),
        colorClass: 'text-emerald-500',
        bgClass: 'bg-emerald-500',
        icon: markRaw(UserGroupIcon)
      },
      {
        label: 'Licencia',
        count: data.licencia,
        value: Math.round((data.licencia / base) * 100),
        colorClass: 'text-gray-400',
        bgClass: 'bg-gray-400',
        icon: markRaw(DocsIcon)
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
