<template>
  <div
    class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col"
  >
    <div class="mb-6 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="p-2 bg-red-50 dark:bg-red-500/10 rounded-xl relative">
          <div class="w-2 h-2 rounded-full bg-red-500 animate-ping absolute top-0 right-0"></div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        </div>
        <div>
          <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest leading-tight">
            Central de alertas
          </h2>
          <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Gestión por excepción</p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <span class="text-[10px] font-black px-2 py-1 rounded-lg bg-red-500 text-white shadow-lg shadow-red-500/20">
          {{ totalAlerts }} ACTIVAS
        </span>
      </div>
    </div>

    <div class="space-y-6 flex-1 overflow-y-auto custom-scrollbar pr-2">
      <!-- Section: Delays in Revision -->
      <section class="space-y-3">
        <div class="flex items-center gap-2">
          <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span>
          <h3 class="text-[10px] font-black uppercase text-gray-500 dark:text-gray-400 tracking-widest">
            Retrasos Críticos (>15 días)
          </h3>
        </div>
        <div v-if="revisionDelays.length" class="grid gap-2">
          <div
            v-for="item in revisionDelays"
            :key="item.id"
            class="group flex items-center justify-between rounded-2xl border border-gray-50 bg-gray-50/30 p-4 transition-all hover:bg-white hover:shadow-md hover:border-red-100 dark:border-gray-800 dark:bg-gray-800/20 dark:hover:bg-gray-800"
          >
            <div class="flex items-center gap-4">
              <div class="flex flex-col">
                <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.mareaId }}</span>
                <span class="text-[10px] font-bold text-gray-400 uppercase">{{ item.obs }}</span>
              </div>
            </div>
            <div class="text-right flex items-center gap-4">
              <div class="flex flex-col text-right">
                <span class="text-xs font-black text-red-600 dark:text-red-400">{{ item.days }} DÍAS</span>
                <span class="text-[9px] font-bold text-gray-400 uppercase tracking-tighter">SIN ENTREGA</span>
              </div>
              <router-link
                :to="`/mareas/workflow/${item.id}`"
                class="p-2 rounded-xl bg-white dark:bg-gray-700 shadow-sm border border-gray-100 dark:border-gray-600 text-gray-400 hover:text-red-500 hover:border-red-500 transition-all opacity-0 group-hover:opacity-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
              </router-link>
            </div>
          </div>
        </div>
        <div class="bg-white dark:bg-gray-950 rounded-xl border border-gray-200 dark:border-gray-800 p-6 text-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>
          <h3 class="text-gray-900 dark:text-white font-semibold">Retrasos críticos</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 mt-1 max-w-sm mx-auto">Esta sección estará disponible próximamente. Estamos calibrando las reglas de alerta.</p>
        </div>
      </section>

      <!-- Section: Delayed Reports -->
      <section class="space-y-3">
        <div class="flex items-center gap-2">
          <span class="w-1.5 h-1.5 rounded-full bg-orange-500"></span>
          <h3 class="text-[10px] font-black uppercase text-gray-500 dark:text-gray-400 tracking-widest">
            Informes Demorados (>7 días)
          </h3>
        </div>
        <div v-if="reportDelays.length" class="grid gap-2">
          <div
            v-for="item in reportDelays"
            :key="item.id"
            class="group flex items-center justify-between rounded-2xl border border-gray-50 bg-gray-50/30 p-4 transition-all hover:bg-white hover:shadow-md hover:border-orange-100 dark:border-gray-800 dark:bg-gray-800/20 dark:hover:bg-gray-800"
          >
            <div class="flex items-center gap-4">
              <div class="flex flex-col">
                <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.vessel }}</span>
                <span class="text-[10px] font-bold text-gray-400 uppercase">{{ item.obs }}</span>
              </div>
            </div>
            <div class="text-right flex items-center gap-4">
              <div class="flex flex-col text-right">
                <span class="text-xs font-black text-orange-600 dark:text-orange-400">{{ item.days }} DÍAS</span>
                <span class="text-[9px] font-bold text-gray-400 uppercase tracking-tighter">PENDIENTE</span>
              </div>
              <button
                class="p-2 rounded-xl bg-white dark:bg-gray-700 shadow-sm border border-gray-100 dark:border-gray-600 text-gray-400 hover:text-orange-500 hover:border-orange-500 transition-all opacity-0 group-hover:opacity-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8a3 3 0 0 0-3-3H5a2 2 0 0 0-2 2v14c0 .6.4 1 1 1h12a2 2 0 0 0 2-2V8Z"/><path d="M22 6a3 3 0 0 0-3-3h-1a3 3 0 0 0-3 3v2h7V6Z"/></svg>
              </button>
            </div>
          </div>
        </div>
        <div class="bg-white dark:bg-gray-950 rounded-xl border border-gray-200 dark:border-gray-800 p-6 text-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>
          <h3 class="text-gray-900 dark:text-white font-semibold">Informes demorados</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400 mt-1 max-w-sm mx-auto">Esta sección estará disponible próximamente. Mostraremos pendientes de revisión y entrega de informes.</p>
        </div>
      </section>

      <!-- Section: Fatigue -->
      <section v-if="fatigueAlerts.length" class="space-y-3">
        <div class="flex items-center gap-2">
          <span class="w-1.5 h-1.5 rounded-full bg-brand-500"></span>
          <h3 class="text-[10px] font-black uppercase text-gray-500 dark:text-gray-400 tracking-widest">
            Alertas de Personal / Fatiga
          </h3>
        </div>
        <div class="grid gap-2">
          <div
            v-for="item in fatigueAlerts"
            :key="item.id"
            class="group flex items-center justify-between rounded-2xl border border-gray-50 bg-gray-50/30 p-4 transition-all hover:bg-white hover:shadow-md dark:border-gray-800 dark:bg-gray-800/20 dark:hover:bg-gray-800"
          >
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-brand-50 dark:bg-brand-900/20 flex items-center justify-center">
                <span class="text-[10px] font-black text-brand-500">{{ item.initials }}</span>
              </div>
              <div class="flex flex-col">
                <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.name }}</span>
                <span class="text-[10px] font-bold text-gray-400 uppercase">{{ item.reason }}</span>
              </div>
            </div>
            <div class="text-right">
              <span class="text-xs font-black bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded-lg" :class="item.isOver ? 'text-red-600 dark:text-red-400' : 'text-green-700 dark:text-green-300'">
                {{ item.value }} d ({{ item.percent }}%)
              </span>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import dashboardService, { FatigueAlert } from '@/modules/dashboard/services/dashboard.service'

const revisionDelays = ref<any[]>([])
const reportDelays = ref<any[]>([])
const fatigueAlerts = ref<{ id: string; name: string; initials: string; value: number; percent: number; reason: string; isOver: boolean }[]>([])

const totalAlerts = computed(
  () => revisionDelays.value.length + reportDelays.value.length + fatigueAlerts.value.length
)

const buildInitials = (name: string) =>
  name
    .split(' ')
    .filter(Boolean)
    .map((n) => n[0])
    .join('')
    .slice(0, 2)

const loadFatigueAlerts = async () => {
  try {
    const data: FatigueAlert[] = await dashboardService.getFatigueAlerts()
    fatigueAlerts.value = data.map((item) => ({
      id: item.id,
      name: item.name,
      initials: buildInitials(item.name),
      value: item.days,
      percent: Math.round((item.days / 180) * 100),
      reason: 'Acumulado anual',
      isOver: item.days > 180
    }))
  } catch (error) {
    fatigueAlerts.value = []
  }
}

onMounted(() => {
  loadFatigueAlerts()
})
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
