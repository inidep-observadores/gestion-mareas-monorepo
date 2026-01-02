<template>
  <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
    <div
      v-for="kpi in kpis"
      :key="kpi.title"
      class="group relative overflow-hidden rounded-3xl border border-gray-100 bg-white p-6 shadow-sm transition-all hover:shadow-xl dark:border-gray-800 dark:bg-gray-900"
    >
      <div class="flex items-start justify-between mb-4">
        <div>
          <p class="text-[10px] font-black uppercase tracking-widest text-gray-500 dark:text-gray-400">
            {{ kpi.title }}
          </p>
          <h3 class="mt-1 text-3xl font-black text-gray-900 dark:text-white leading-none">
            {{ kpi.value }}
          </h3>
        </div>
        <div 
          class="p-2 rounded-xl"
          :class="kpi.iconWrapperClass"
        >
          <component :is="kpi.icon" class="w-5 h-5 flex-shrink-0" :class="kpi.iconClass" />
        </div>
      </div>

      <div class="h-12 w-full mt-4">
        <apexchart
          type="area"
          height="60"
          :options="sparklineOptions(kpi.color)"
          :series="[{ data: kpi.trendData }]"
        />
      </div>

      <div class="mt-4 flex items-center justify-between border-t border-gray-50 dark:border-gray-800 pt-4">
        <span 
          class="text-[10px] font-black px-2 py-0.5 rounded-lg"
          :class="kpi.trendClass"
        >
          {{ kpi.trendLabel }}
        </span>
        <span class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">vs mes anterior</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useTheme } from '@/components/layout/ThemeProvider.vue'
import { ShipIcon, UserGroupIcon, TaskIcon, CheckIcon } from '@/icons'

const { isDarkMode } = useTheme() as { isDarkMode: { value: boolean } }

const kpis = [
  {
    title: 'Cobertura Global',
    value: '84.2%',
    icon: ShipIcon,
    iconWrapperClass: 'bg-blue-50 dark:bg-blue-900/20',
    iconClass: 'text-blue-500',
    color: '#3b82f6',
    trendData: [45, 52, 48, 62, 58, 75, 84],
    trendLabel: '↑ 5.2%',
    trendClass: 'bg-blue-50 text-blue-600 dark:bg-blue-900/30',
  },
  {
    title: 'Mareas Cerradas',
    value: '142',
    icon: CheckIcon,
    iconWrapperClass: 'bg-emerald-50 dark:bg-emerald-900/20',
    iconClass: 'text-emerald-500',
    color: '#10b981',
    trendData: [30, 40, 35, 50, 49, 60, 70],
    trendLabel: '↑ 12%',
    trendClass: 'bg-emerald-50 text-emerald-600 dark:bg-emerald-900/30',
  },
  {
    title: 'Eficiencia SLA',
    value: '91.5%',
    icon: TaskIcon,
    iconWrapperClass: 'bg-indigo-50 dark:bg-indigo-900/20',
    iconClass: 'text-indigo-500',
    color: '#6366f1',
    trendData: [80, 85, 82, 88, 87, 90, 91],
    trendLabel: '↑ 2.1%',
    trendClass: 'bg-indigo-50 text-indigo-600 dark:bg-indigo-900/30',
  },
  {
    title: 'Volumen Datos',
    value: '4.8 GB',
    icon: UserGroupIcon,
    iconWrapperClass: 'bg-brand-50 dark:bg-brand-900/20',
    iconClass: 'text-brand-500',
    color: '#A5182C', // Using brand color
    trendData: [2.1, 2.5, 3.0, 3.8, 4.2, 4.5, 4.8],
    trendLabel: '↑ 8.4%',
    trendClass: 'bg-brand-50 text-brand-600 dark:bg-brand-900/30',
  }
]

const sparklineOptions = (color: string) => ({
  chart: {
    sparkline: { enabled: true },
    fontFamily: 'inherit',
    animations: { enabled: true }
  },
  stroke: { curve: 'smooth', width: 2 },
  fill: {
    type: 'gradient',
    gradient: {
      shadeIntensity: 1,
      opacityFrom: 0.45,
      opacityTo: 0.05,
      stops: [0, 100]
    }
  },
  colors: [color],
  tooltip: { enabled: false },
  theme: {
    mode: isDarkMode.value ? 'dark' : 'light'
  }
})
</script>
