<template>
  <div
    class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm"
  >
    <div
      class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between"
    >
      <h3 class="font-bold text-gray-800 dark:text-white/90">Logística y Talento (Observadores)</h3>
      <div class="text-xs text-gray-500">Últimos 12 meses</div>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-left border-collapse">
        <thead class="bg-gray-50 dark:bg-gray-800/50">
          <tr>
            <th class="px-6 py-3 text-[10px] font-bold uppercase text-gray-400">Observador</th>
            <th class="px-6 py-3 text-[10px] font-bold uppercase text-gray-400">Días Mar Año</th>
            <th class="px-6 py-3 text-[10px] font-bold uppercase text-gray-400">Estado</th>
            <th class="px-6 py-3 text-[10px] font-bold uppercase text-gray-400">En Tierra</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
          <tr
            v-for="obs in observers"
            :key="obs.id"
            class="hover:bg-gray-50/50 dark:hover:bg-white/[0.02] transition-colors"
          >
            <td class="px-6 py-4">
              <div class="flex items-center gap-3">
                <div
                  class="w-8 h-8 rounded-full bg-brand-50 dark:bg-brand-500/10 flex items-center justify-center text-brand-600 dark:text-brand-400 font-bold text-xs"
                >
                  {{
                    obs.nombre
                      .split(' ')
                      .map((n) => n[0])
                      .join('')
                  }}
                </div>
                <div class="text-sm font-medium text-gray-800 dark:text-gray-200">
                  {{ obs.nombre }}
                </div>
              </div>
            </td>
            <td class="px-6 py-4">
              <div class="w-full max-w-[120px]">
                <div class="flex justify-between text-[10px] mb-1">
                  <span class="font-bold text-gray-700 dark:text-gray-300"
                    >{{ obs.diasMar }} d</span
                  >
                  <span class="text-gray-400">/ 200</span>
                </div>
                <div class="h-1.5 w-full bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden">
                  <div
                    class="h-full transition-all duration-500 rounded-full"
                    :class="[obs.diasMar > 180 ? 'bg-error-500' : 'bg-brand-500']"
                    :style="{ width: Math.min((obs.diasMar / 200) * 100, 100) + '%' }"
                  ></div>
                </div>
              </div>
            </td>
            <td class="px-6 py-4">
              <span
                :class="[
                  'inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider',
                  statusStyles[obs.estado],
                ]"
              >
                <span
                  class="w-1 h-1 rounded-full mr-1.5"
                  :class="statusDotStyles[obs.estado]"
                ></span>
                {{ obs.estado }}
              </span>
            </td>
            <td class="px-6 py-4">
              <div
                class="text-sm font-bold"
                :class="
                  obs.diasTierra > 30 ? 'text-warning-600' : 'text-gray-600 dark:text-gray-400'
                "
              >
                {{ obs.diasTierra }} <span class="text-[10px] font-normal uppercase">días</span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div
      class="px-6 py-3 border-t border-gray-100 dark:border-gray-800 bg-gray-50/30 dark:bg-transparent"
    >
      <button
        class="text-xs font-bold text-brand-600 hover:text-brand-700 dark:text-brand-400 flex items-center gap-1"
      >
        Ver plantilla completa
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="w-3 h-3"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path
            fill-rule="evenodd"
            d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
            clip-rule="evenodd"
          />
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Observer {
  id: number
  nombre: string
  diasMar: number
  estado: 'Navegando' | 'Disponible' | 'Licencia'
  diasTierra: number
}

const observers: Observer[] = [
  { id: 1, nombre: 'Juan Pérez', diasMar: 185, estado: 'Navegando', diasTierra: 0 },
  { id: 2, nombre: 'María García', diasMar: 142, estado: 'Disponible', diasTierra: 15 },
  { id: 3, nombre: 'Carlos Rodríguez', diasMar: 195, estado: 'Disponible', diasTierra: 42 },
  { id: 4, nombre: 'Ana López', diasMar: 88, estado: 'Navegando', diasTierra: 0 },
  { id: 5, nombre: 'Roberto Gómez', diasMar: 120, estado: 'Licencia', diasTierra: 10 },
]

const statusStyles = {
  Navegando: 'bg-brand-50 text-brand-700 dark:bg-brand-500/10 dark:text-brand-400',
  Disponible: 'bg-success-50 text-success-700 dark:bg-success-500/10 dark:text-success-400',
  Licencia: 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-400',
}

const statusDotStyles = {
  Navegando: 'bg-brand-500 animate-pulse',
  Disponible: 'bg-success-500',
  Licencia: 'bg-gray-400',
}
</script>
