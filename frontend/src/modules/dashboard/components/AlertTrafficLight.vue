<template>
  <div
    class="rounded-2xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full"
  >
    <div class="mb-6 flex items-center justify-between">
      <h2
        class="text-lg text-gray-800 dark:text-white uppercase tracking-tight flex items-center gap-2"
      >
        <span class="flex h-3 w-3">
          <span
            class="animate-ping absolute inline-flex h-3 w-3 rounded-full bg-error-400 opacity-75"
          ></span>
          <span class="relative inline-flex rounded-full h-3 w-3 bg-error-500"></span>
        </span>
        Semáforo de Alertas
      </h2>
      <span
        class="rounded-full bg-error-50 px-2 py-0.5 text-[10px] font-bold text-error-700 dark:bg-error-500/10 dark:text-error-400"
      >
        {{ totalAlerts }} CRÍTICAS
      </span>
    </div>

    <div class="space-y-4">
      <!-- Section: Delays in Revision -->
      <div v-if="revisionDelays.length" class="space-y-3">
        <h3 class="text-[10px] font-bold uppercase text-gray-400 tracking-widest">
          Retrasos en Entrega (>15 días)
        </h3>
        <div
          v-for="item in revisionDelays"
          :key="item.id"
          class="group flex items-center justify-between rounded-xl border border-error-100 bg-error-50/30 p-3 transition-colors hover:bg-error-50 dark:border-error-500/20 dark:bg-error-500/5 dark:hover:bg-error-500/10"
        >
          <div class="flex items-center gap-3">
            <div class="text-sm font-bold text-gray-800 dark:text-gray-100">{{ item.mareaId }}</div>
            <div class="text-xs text-gray-500">{{ item.obs }}</div>
          </div>
          <div class="text-right">
            <div class="text-xs text-error-600 dark:text-error-400">
              {{ item.days }} DÍAS
            </div>
            <router-link
              :to="`/mareas/workflow/${item.id}`"
              class="text-[10px] font-bold text-brand-500 opacity-0 group-hover:opacity-100 transition-opacity uppercase"
              >Atender</router-link
            >
          </div>
        </div>
      </div>

      <!-- Section: Delayed Reports -->
      <div v-if="reportDelays.length" class="space-y-3">
        <h3 class="text-[10px] font-bold uppercase text-gray-400 tracking-widest">
          Informes Demorados (>7 días)
        </h3>
        <div
          v-for="item in reportDelays"
          :key="item.id"
          class="group flex items-center justify-between rounded-xl border border-warning-100 bg-warning-50/30 p-3 transition-colors hover:bg-warning-50 dark:border-warning-500/20 dark:bg-warning-500/5 dark:hover:bg-warning-500/10"
        >
          <div class="flex items-center gap-3">
            <div class="text-sm font-bold text-gray-800 dark:text-gray-100">{{ item.vessel }}</div>
            <div class="text-[10px] font-bold text-gray-500">{{ item.obs }}</div>
          </div>
          <div class="text-right">
            <div class="text-xs text-warning-600 dark:text-warning-400">
              {{ item.days }} DÍAS DE ATRASO
            </div>
            <router-link
              :to="`/mareas/inbox?marea=${item.mareaId}`"
              class="text-[10px] font-bold text-brand-500 opacity-0 group-hover:opacity-100 transition-opacity uppercase"
              >Reclamar</router-link
            >
          </div>
        </div>
      </div>

      <!-- Section: Fatigue Alerts -->
      <div v-if="fatigueAlerts.length" class="space-y-3">
        <h3 class="text-[10px] font-bold uppercase text-gray-400 tracking-widest">
          Alertas de Fatiga / Límites
        </h3>
        <div
          v-for="item in fatigueAlerts"
          :key="item.id"
          class="group flex items-center justify-between rounded-xl border border-gray-100 bg-gray-50 p-3 transition-colors hover:bg-gray-100 dark:border-gray-800 dark:bg-white/5"
        >
          <div class="flex items-center gap-3">
            <div
              class="h-8 w-8 rounded-full bg-error-100 flex items-center justify-center text-error-600 text-xs font-bold dark:bg-error-500/20"
            >
              {{
                item.name
                  .split(' ')
                  .map((n) => n[0])
                  .join('')
              }}
            </div>
            <div>
              <div class="text-sm font-bold text-gray-800 dark:text-gray-100">{{ item.name }}</div>
              <div class="text-[10px] text-gray-500">{{ item.reason }}</div>
            </div>
          </div>
          <div class="text-right">
            <div class="text-xs text-gray-700 dark:text-gray-300">
              {{ item.value }} d
            </div>
            <button
              class="text-[10px] font-bold text-brand-500 opacity-0 group-hover:opacity-100 transition-opacity uppercase"
            >
              Ver Historial
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const revisionDelays = [
  { id: 101, mareaId: '2025-042', obs: 'Juan Díaz', days: 15 },
  { id: 105, mareaId: '2025-038', obs: 'Ana López', days: 12 },
]

const reportDelays = [
  { id: 202, vessel: 'BP ARGENTINO I', obs: 'Pedro Gómez', days: 18, mareaId: '2025-048' },
  { id: 204, vessel: 'MAR DEL SUR', obs: 'Marta Ruiz', days: 25, mareaId: '2025-049' },
]

const fatigueAlerts = [
  { id: 301, name: 'Carlos Rodríguez', reason: 'Acumulado anual', value: 205 },
  { id: 305, name: 'Sofía Martínez', reason: 'Marea actual', value: 45 },
]

const totalAlerts = revisionDelays.length + reportDelays.length + fatigueAlerts.length
</script>
