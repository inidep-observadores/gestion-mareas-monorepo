<template>
  <div
    class="rounded-2xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full"
  >
    <div class="mb-6 flex items-center justify-between">
      <h2 class="text-lg text-gray-800 dark:text-white uppercase tracking-tight">
        Próximos Movimientos
      </h2>
      <div class="flex gap-1">
        <button
          class="rounded-lg bg-gray-50 p-1.5 hover:bg-gray-100 dark:bg-gray-800 dark:hover:bg-gray-700"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-4 h-4 text-gray-500"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              d="M5 4a1 1 0 00-2 0v7.268a2 2 0 000 3.464V16a1 1 0 102 0v-1.268a2 2 0 000-3.464V4zM11 4a1 1 0 10-2 0v1.268a2 2 0 000 3.464V16a1 1 0 102 0V8.732a2 2 0 000-3.464V4zM16 3a1 1 0 011 1v7.268a2 2 0 010 3.464V16a1 1 0 11-2 0v-1.268a2 2 0 010-3.464V4a1 1 0 011-1z"
            />
          </svg>
        </button>
      </div>
    </div>

    <div class="space-y-6">
      <!-- Section: Arrivals (ETA) -->
      <div class="space-y-4">
        <h3
          class="flex items-center gap-2 text-[10px] font-bold uppercase text-gray-400 tracking-widest"
        >
          Arribos Estimados (ETA 72hs)
          <span class="h-1 flex-1 bg-gray-50 dark:bg-gray-800/50"></span>
        </h3>
        <div class="space-y-3">
          <div v-for="eta in arrivals" :key="eta.id" class="relative pl-10">
            <div
              class="absolute left-0 top-0 flex h-8 w-8 items-center justify-center rounded-lg bg-blue-50 text-blue-600 dark:bg-blue-500/10 dark:text-blue-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-5 h-5"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm.707-10.293a1 1 0 00-1.414-1.414l-3 3a1 1 0 000 1.414l3 3a1 1 0 001.414-1.414L9.414 11H13a1 1 0 100-2H9.414l1.293-1.293z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div>
              <div class="flex items-center justify-between">
                <span class="text-sm font-bold text-gray-800 dark:text-white">{{
                  eta.vessel
                }}</span>
                <span class="text-xs text-blue-600 dark:text-blue-400">{{
                  eta.time
                }}</span>
              </div>
              <p class="text-[10px] font-medium text-gray-500 uppercase tracking-tighter mt-1">
                Obs: {{ eta.obs }} • Puerto: {{ eta.port }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Section: Pending Departures -->
      <div class="space-y-4">
        <h3
          class="flex items-center gap-2 text-[10px] font-bold uppercase text-gray-400 tracking-widest"
        >
          Próximos Despachos
          <span class="h-1 flex-1 bg-gray-50 dark:bg-gray-800/50"></span>
        </h3>
        <div class="space-y-3">
          <div v-for="out in departures" :key="out.id" class="relative pl-10">
            <div
              class="absolute left-0 top-0 flex h-8 w-8 items-center justify-center rounded-lg bg-indigo-50 text-indigo-600 dark:bg-indigo-500/10 dark:text-indigo-400"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="w-5 h-5"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-8.707l-3-3a1 1 0 00-1.414 1.414L10.586 9H7a1 1 0 100 2h3.586l-1.293 1.293a1 1 0 101.414 1.414l3-3a1 1 0 000-1.414z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div>
              <div class="flex items-center justify-between">
                <span class="text-sm font-bold text-gray-800 dark:text-white">{{
                  out.vessel
                }}</span>
                <span class="text-xs text-indigo-600 dark:text-indigo-400">{{
                  out.date
                }}</span>
              </div>
              <p class="text-[10px] font-medium text-gray-500 uppercase tracking-tighter mt-1">
                {{ out.status }} • {{ out.port }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="mt-6 border-t border-gray-50 pt-4 dark:border-gray-800">
      <router-link
        to="/mareas/calendar"
        class="text-xs font-bold text-brand-600 flex items-center gap-1 hover:gap-2 transition-all"
      >
        Ver calendario logístico completo →
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
const arrivals = [
  { id: 1, vessel: 'BP ARGENTINO I', obs: 'Juan Díaz', port: 'Mar del Plata', time: 'Hoy 22:00' },
  { id: 2, vessel: 'MAR DEL SUR', obs: 'Marta Ruiz', port: 'Pto. Madryn', time: 'Mañana 08:00' },
  { id: 3, vessel: 'BP UNION', obs: 'Pedro Gómez', port: 'Mar del Plata', time: '+48hs' },
]

const departures = [
  {
    id: 4,
    vessel: 'NIETO DE PASCUAL',
    date: '26/12',
    status: 'Designando Obs.',
    port: 'Mar del Plata',
  },
  { id: 5, vessel: 'ARGENOVA IV', date: '28/12', status: 'Confirmada', port: 'Pto. Deseado' },
]
</script>
