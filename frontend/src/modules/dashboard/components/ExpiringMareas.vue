<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
    <div class="mb-6 flex items-center justify-between">
      <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
        <div class="w-1.5 h-4 bg-emerald-500 rounded-full"></div>
        Próximas a finalizar
      </h2>
      <span class="text-[10px] font-black px-2 py-1 rounded-lg bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400">Progreso > 80%</span>
    </div>

    <div class="space-y-4 flex-1 overflow-y-auto custom-scrollbar pr-2">
      <div
        v-for="marea in expiringMareas"
        :key="marea.id"
        class="group p-4 rounded-2xl border border-gray-50 bg-gray-50/30 hover:bg-white hover:shadow-md hover:border-emerald-100 dark:border-gray-800 dark:bg-gray-800/20 dark:hover:bg-gray-800 transition-all"
      >
        <div class="flex items-center justify-between mb-3">
          <div class="flex items-center gap-3">
            <div
              class="w-10 h-10 rounded-xl bg-white dark:bg-gray-700 shadow-sm flex items-center justify-center text-gray-400 group-hover:text-emerald-500 transition-colors"
            >
              <ShipIcon class="w-5 h-5" />
            </div>
            <div class="flex flex-col">
              <span class="text-xs font-black text-gray-900 dark:text-white">{{ marea.buque }}</span>
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">{{ marea.obs }}</span>
            </div>
          </div>
          <div class="text-right">
            <span class="text-xs font-black text-emerald-600 dark:text-emerald-400">{{ marea.progreso }}%</span>
          </div>
        </div>

        <div class="h-1.5 w-full bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
          <div
            class="h-full bg-emerald-500 rounded-full transition-all duration-1000 ease-out"
            :style="{ width: marea.progreso + '%' }"
          ></div>
        </div>

        <div class="mt-3 flex items-center justify-between text-[10px] font-bold text-gray-400 uppercase tracking-tighter">
          <span>{{ marea.puerto }}</span>
          <span>ETA: {{ marea.eta }}</span>
        </div>
      </div>

      <div v-if="expiringMareas.length === 0" class="flex flex-col items-center justify-center h-full opacity-40 py-10">
        <ShipIcon class="w-12 h-12 mb-2 text-gray-300" />
        <p class="text-xs font-bold text-gray-400">No hay arribos inminentes</p>
      </div>
    </div>

    <div class="mt-6 pt-4 border-t border-gray-50 dark:border-gray-800/50">
      <router-link
        to="/mareas/calendar"
        class="flex items-center justify-between px-4 py-3 bg-gray-50/50 dark:bg-gray-800/30 rounded-2xl hover:bg-brand-50 dark:hover:bg-brand-900/10 transition-all group"
      >
        <div class="flex items-center gap-3">
          <div class="p-2 bg-white dark:bg-gray-800 rounded-xl shadow-sm">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="w-4 h-4 text-brand-500"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
              <line x1="16" y1="2" x2="16" y2="6" />
              <line x1="8" y1="2" x2="8" y2="6" />
              <line x1="3" y1="10" x2="21" y2="10" />
            </svg>
          </div>
          <span class="text-xs font-bold text-gray-600 dark:text-gray-400">Calendario Logístico</span>
        </div>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="w-4 h-4 text-gray-400 group-hover:text-brand-500 transform group-hover:translate-x-1 transition-all"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path d="m9 18 6-6-6-6" />
        </svg>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { ShipIcon } from '@/icons'
import mareasService from '@/modules/mareas/services/mareas.service'

type ExpiringMarea = {
  id: string
  buque: string
  obs: string
  progreso: number
  puerto: string
  eta: string
}

const expiringMareas = ref<ExpiringMarea[]>([])

const formatEta = (fecha?: string): string => {
  if (!fecha) return 'Pendiente'
  const parsed = new Date(fecha)
  if (Number.isNaN(parsed.getTime())) return 'Pendiente'
  return new Intl.DateTimeFormat('es-AR', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  }).format(parsed)
}

const loadExpiringMareas = async () => {
  try {
    const { items } = await mareasService.getDashboardOperativo()

    expiringMareas.value = items
      .filter((item) => item.progreso > 80)
      .sort((a, b) => b.progreso - a.progreso)
      .slice(0, 4)
      .map((item) => ({
        id: item.id,
        buque: item.buque_nombre,
        obs: (item as any).observador || 'Sin asignar',
        progreso: item.progreso,
        puerto: item.puerto,
        eta: formatEta(item.fecha_zarpada)
      }))
  } catch (error) {
    toast.error('No se pudieron cargar las mareas próximas a finalizar.')
  }
}

onMounted(() => void loadExpiringMareas())
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #f1f5f9;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1e293b;
}
</style>
