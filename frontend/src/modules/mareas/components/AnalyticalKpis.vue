<template>
  <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
    <div
      v-for="kpi in kpis"
      :key="kpi.title"
      class="group relative overflow-hidden rounded-3xl border border-border bg-surface p-6 shadow-sm transition-all hover:shadow-xl"
    >
      <div class="flex items-start justify-between mb-4">
        <div>
          <p class="text-[10px] font-black uppercase tracking-widest text-text-muted">
            {{ kpi.title }}
          </p>
          <h3 class="mt-1 text-3xl font-black text-text leading-none">
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

      <div class="mt-4 flex items-center justify-between border-t border-border pt-4">
        <span 
          class="text-[10px] font-black px-2 py-0.5 rounded-lg"
          :class="kpi.trendClass"
        >
          {{ kpi.trendLabel }}
        </span>
        <span class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">vs mes anterior</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useTheme } from '@/components/layout/ThemeProvider.vue'
import { ShipIcon, UserGroupIcon, TaskIcon, CheckIcon } from '@/icons'

const { isDarkMode } = useTheme() as any

const kpis = [
  {
    title: 'Cobertura Global',
    value: '84.2%',
    icon: ShipIcon,
    iconWrapperClass: 'bg-info/10',
    iconClass: 'text-info',
    color: '#0ea5e9', // info
    trendData: [45, 52, 48, 62, 58, 75, 84],
    trendLabel: '↑ 5.2%',
    trendClass: 'bg-info/10 text-info',
  },
  {
    title: 'Mareas Cerradas',
    value: '142',
    icon: CheckIcon,
    iconWrapperClass: 'bg-success/10',
    iconClass: 'text-success',
    color: '#10b981', // success
    trendData: [30, 40, 35, 50, 49, 60, 70],
    trendLabel: '↑ 12%',
    trendClass: 'bg-success/10 text-success',
  },
  {
    title: 'Eficiencia SLA',
    value: '91.5%',
    icon: TaskIcon,
    iconWrapperClass: 'bg-warning/10',
    iconClass: 'text-warning',
    color: '#f59e0b', // warning
    trendData: [80, 85, 82, 88, 87, 90, 91],
    trendLabel: '↑ 2.1%',
    trendClass: 'bg-warning/10 text-warning',
  },
  {
    title: 'Volumen Datos',
    value: '4.8 GB',
    icon: UserGroupIcon,
    iconWrapperClass: 'bg-primary/10',
    iconClass: 'text-primary',
    color: '#2563eb', // primary
    trendData: [2.1, 2.5, 3.0, 3.8, 4.2, 4.5, 4.8],
    trendLabel: '↑ 8.4%',
    trendClass: 'bg-primary/10 text-primary',
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
