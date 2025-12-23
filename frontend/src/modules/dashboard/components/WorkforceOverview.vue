<template>
  <div
    class="rounded-2xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900"
  >
    <div class="grid grid-cols-1 gap-8 lg:grid-cols-12">
      <!-- Section: Distribution Chart -->
      <div class="lg:col-span-8">
        <h2 class="text-sm text-gray-400 uppercase tracking-widest mb-6">
          Estado de la Fuerza de Trabajo
        </h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div
            v-for="status in distributions"
            :key="status.label"
            class="flex flex-col items-center justify-center p-4 rounded-2xl bg-gray-50 dark:bg-gray-800/50"
          >
            <div class="text-2xl mb-1" :class="status.colorClass">
              {{ status.value }}%
            </div>
            <div class="text-[10px] font-bold text-gray-500 uppercase tracking-tighter">
              {{ status.label }}
            </div>
            <div class="mt-3 h-1 w-full bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
              <div
                class="h-full rounded-full transition-all"
                :class="status.bgClass"
                :style="{ width: status.value + '%' }"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Section: Top Dry Time -->
      <div class="lg:col-span-4 border-l border-gray-50 dark:border-gray-800 pl-8">
        <h2 class="text-sm text-gray-400 uppercase tracking-widest mb-6">
          Top 5 "Tiempo en Seco"
        </h2>
        <div class="space-y-4">
          <div v-for="(obs, index) in topDryTime" :key="obs.id" class="flex items-center gap-3">
            <div class="text-xs text-gray-300">#{{ index + 1 }}</div>
            <div class="flex-1">
              <div class="flex items-center justify-between">
                <span class="text-sm font-bold text-gray-800 dark:text-gray-100">{{
                  obs.name
                }}</span>
                <span class="text-xs text-warning-600 dark:text-warning-400"
                  >{{ obs.days }} d</span
                >
              </div>
              <div class="h-1 w-full bg-gray-100 dark:bg-gray-800 rounded-full mt-1">
                <div
                  class="h-full bg-warning-500 rounded-full"
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
const distributions = [
  { label: 'Navegando', value: 45, colorClass: 'text-blue-600', bgClass: 'bg-blue-500' },
  { label: 'Descanso Oblig.', value: 25, colorClass: 'text-indigo-600', bgClass: 'bg-indigo-500' },
  {
    label: 'Disp. en Puerto',
    value: 20,
    colorClass: 'text-success-600',
    bgClass: 'bg-success-500',
  },
  { label: 'Licencia', value: 10, colorClass: 'text-gray-600', bgClass: 'bg-gray-500' },
]

const topDryTime = [
  { id: 1, name: 'Marcos Herrera', days: 42 },
  { id: 2, name: 'Esteban Quito', days: 38 },
  { id: 3, name: 'Valentina Rossi', days: 35 },
  { id: 4, name: 'Diego Torres', days: 31 },
  { id: 5, name: 'Mónica Geller', days: 28 },
]
</script>
