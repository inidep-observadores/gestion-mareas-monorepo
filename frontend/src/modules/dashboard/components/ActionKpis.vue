<template>
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 xl:gap-6">
    <div
      v-for="kpi in kpis"
      :key="kpi.title"
      class="group relative overflow-hidden rounded-2xl border border-gray-100 bg-white p-5 shadow-sm transition-all hover:shadow-md dark:border-gray-800 dark:bg-gray-900"
    >
      <div class="flex items-center justify-between gap-4">
        <div>
          <p class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">
            {{ kpi.title }}
          </p>
          <h3 class="mt-1 text-2xl text-gray-800 dark:text-white sm:text-3xl">
            {{ kpi.value }}
          </h3>
          <p v-if="kpi.subtext" class="mt-1 text-xs font-medium" :class="kpi.trendClass">
            {{ kpi.subtext }}
          </p>
        </div>
        <div
          :class="[
            'flex h-12 w-12 items-center justify-center rounded-2xl transition-transform group-hover:scale-110',
            kpi.bgClass,
          ]"
        >
          <component :is="kpi.icon" class="h-6 w-6 text-white" />
        </div>
      </div>
      <!-- Progress Bar for Monthly Target -->
      <div v-if="kpi.progress !== undefined" class="mt-4">
        <div class="h-1.5 w-full rounded-full bg-gray-100 dark:bg-gray-800">
          <div
            class="h-full rounded-full bg-brand-500 transition-all"
            :style="{ width: kpi.progress + '%' }"
          ></div>
        </div>
      </div>

      <!-- Drill-down link overlay -->
      <router-link
        :to="kpi.link"
        class="absolute inset-0 z-10"
        aria-label="Ver detalles"
      ></router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { WaveIcon, UserGroupIcon, WarningIcon, CheckIcon } from '@/icons'

const kpis = [
  {
    title: 'Flota Activa',
    value: '34',
    subtext: 'Observadores navegando',
    icon: WaveIcon,
    bgClass: 'bg-blue-500',
    trendClass: 'text-blue-500',
    link: '/mareas/dashboard?status=sailing',
  },
  {
    title: 'Disponibles',
    value: '12',
    subtext: 'Listos para asignar',
    icon: UserGroupIcon,
    bgClass: 'bg-success-500',
    trendClass: 'text-success-500',
    link: '/mareas/workflow?status=available',
  },
  {
    title: 'Mareas en Limbo',
    value: '05',
    subtext: 'Material pendiente',
    icon: WarningIcon,
    bgClass: 'bg-error-500',
    trendClass: 'text-error-500',
    link: '/mareas/inbox?filter=limbo',
  },
  {
    title: 'Protocolizado / Mes',
    value: '16/24',
    subtext: '75% del objetivo',
    icon: CheckIcon,
    bgClass: 'bg-brand-500',
    trendClass: 'text-brand-500',
    progress: 75,
    link: '/mareas/stats',
  },
]
</script>
