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
            Entregas retrasadas (>15 días)
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
                <div class="flex items-center gap-2 mb-0.5">
                    <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.mareaId }}</span>
                    <span class="text-[9px] font-bold px-1.5 py-0.5 rounded-md bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400 uppercase tracking-tight">{{ item.vesselName }}</span>
                </div>
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
        <div v-else class="bg-white dark:bg-gray-950 rounded-xl border border-gray-200 dark:border-gray-800 p-6 text-center">
          <div class="w-10 h-10 rounded-full bg-green-50 dark:bg-green-900/20 flex items-center justify-center mx-auto mb-3">
             <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-green-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
          </div>
          <h3 class="text-gray-900 dark:text-white font-semibold text-xs">Sin retrasos críticos</h3>
          <p class="text-[10px] text-gray-500 dark:text-gray-400 mt-1 max-w-sm mx-auto">Todas las mareas pendientes están dentro del plazo de entrega de 15 días.</p>
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
                <div class="flex items-center gap-2 mb-0.5">
                    <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.mareaId }}</span>
                    <span class="text-[9px] font-bold px-1.5 py-0.5 rounded-md bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400 uppercase tracking-tight">{{ item.vesselName }}</span>
                </div>
                <span class="text-[10px] font-bold text-gray-400 uppercase">{{ item.obs }}</span>
              </div>
            </div>
            <div class="text-right flex items-center gap-4">
              <div class="flex flex-col text-right">
                <span class="text-xs font-black text-orange-600 dark:text-orange-400">{{ item.days }} DÍAS</span>
                <span class="text-[9px] font-bold text-gray-400 uppercase tracking-tighter">PENDIENTE</span>
              </div>
              <router-link
                :to="`/mareas/workflow/${item.id}`"
                class="p-2 rounded-xl bg-white dark:bg-gray-700 shadow-sm border border-gray-100 dark:border-gray-600 text-gray-400 hover:text-orange-500 hover:border-orange-500 transition-all opacity-0 group-hover:opacity-100"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8a3 3 0 0 0-3-3H5a2 2 0 0 0-2 2v14c0 .6.4 1 1 1h12a2 2 0 0 0 2-2V8Z"/><path d="M22 6a3 3 0 0 0-3-3h-1a3 3 0 0 0-3 3v2h7V6Z"/></svg>
              </router-link>
            </div>
          </div>
        </div>
        <div v-else class="bg-white dark:bg-gray-950 rounded-xl border border-gray-200 dark:border-gray-800 p-6 text-center">
            <div class="w-10 h-10 rounded-full bg-green-50 dark:bg-green-900/20 flex items-center justify-center mx-auto mb-3">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-green-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            </div>
          <h3 class="text-gray-900 dark:text-white font-semibold text-xs">Sin informes demorados</h3>
          <p class="text-[10px] text-gray-500 dark:text-gray-400 mt-1 max-w-sm mx-auto">Todos los informes están dentro de los plazos establecidos.</p>
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
            class="flex flex-col overflow-hidden"
          >
            <!-- Header/Toggle -->
            <div
              @click="toggleExpand(item.id)"
              class="group flex items-center justify-between rounded-2xl border border-gray-50 bg-gray-50/30 p-4 transition-all hover:bg-white hover:shadow-md dark:border-gray-800 dark:bg-gray-800/20 dark:hover:bg-gray-800 cursor-pointer relative"
              :class="{ 'border-brand-100 bg-white shadow-sm dark:border-brand-900/30': expandedId === item.id }"
            >
              <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-brand-50 dark:bg-brand-900/20 flex items-center justify-center relative">
                  <span class="text-[10px] font-black text-brand-500">{{ item.initials }}</span>
                  <div v-if="expandedId === item.id" class="absolute -bottom-1 -right-1 bg-brand-500 text-white rounded-full p-0.5 shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-2 h-2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="m18 15-6-6-6 6"/></svg>
                  </div>
                </div>
                <div class="flex flex-col">
                  <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.name }}</span>
                  <span class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">{{ item.reason }}</span>
                </div>
              </div>
              <div class="text-right flex flex-col items-end gap-1">
                <span class="text-xs font-black bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded-lg transition-colors" :class="[item.isOver ? 'text-red-600 dark:text-red-400' : 'text-green-700 dark:text-green-300', expandedId === item.id ? 'bg-brand-50 dark:bg-brand-900/30' : '']">
                  {{ item.value }} d ({{ item.percent }}%)
                </span>
                <span v-if="item.daysSinceLast !== null" class="text-[9px] font-bold text-gray-400 uppercase tracking-tight">
                  {{ item.daysSinceLast }} días de descanso
                </span>
              </div>
            </div>

            <!-- Accordion Content -->
            <Transition
              enter-active-class="transition-all duration-300 ease-out"
              enter-from-class="max-h-0 opacity-0"
              enter-to-class="max-h-[500px] opacity-100"
              leave-active-class="transition-all duration-200 ease-in"
              leave-from-class="max-h-[500px] opacity-100"
              leave-to-class="max-h-0 opacity-0"
            >
              <div v-if="expandedId === item.id" class="px-4 pb-4 pt-1">
                <div class="rounded-xl bg-gray-50/50 dark:bg-gray-800/30 border border-gray-100 dark:border-gray-800/50 overflow-hidden">
                  <div class="px-3 py-2 border-b border-gray-100 dark:border-gray-800/50 bg-white/50 dark:bg-gray-900/20 flex justify-between items-center">
                    <span class="text-[9px] font-black uppercase text-gray-400 tracking-widest">Historial de Mareas</span>
                    <span class="text-[9px] font-bold text-brand-500">{{ item.trips?.length || 0 }} viajes</span>
                  </div>
                  <div class="px-2 pb-2">
                    <div class="space-y-1">
                      <div v-for="(trip, idx) in item.trips" :key="idx"
                        class="p-2.5 rounded-xl bg-white dark:bg-gray-800/40 border border-gray-100 dark:border-gray-700/50 shadow-sm hover:border-brand-200 dark:hover:border-brand-900/50 transition-all group/trip"
                      >
                        <!-- Header: Code and Vessel -->
                        <div class="flex justify-between items-center mb-2">
                          <div class="flex flex-col">
                            <span class="text-[11px] font-black text-gray-900 dark:text-white mb-0.5">{{ trip.mareaCode }}</span>
                            <div v-if="trip.inExecution" class="flex items-center gap-1">
                              <span class="w-1 h-1 rounded-full bg-brand-500 animate-pulse"></span>
                              <span class="text-[8px] font-black text-brand-500 uppercase tracking-tighter">En ejecución</span>
                            </div>
                          </div>
                          <span class="text-[9px] font-black px-2 py-0.5 rounded-full bg-gray-50 dark:bg-gray-700/50 border border-gray-100 dark:border-gray-600/50 text-gray-500 uppercase">{{ trip.vessel }}</span>
                        </div>

                        <!-- Footer: Dates and Days (Aligned) -->
                        <div class="flex items-center justify-between pt-2 border-t border-gray-50 dark:border-gray-700/30">
                          <div class="flex items-center gap-2">
                            <div class="flex items-center gap-1.5 text-[10px] text-gray-500 dark:text-gray-400 font-bold">
                              <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                              <span>{{ formatDateShort(trip.departure) }}</span>
                            </div>
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
                            <div class="flex items-center gap-1.5 text-[10px] font-bold" :class="trip.inExecution ? 'text-brand-500' : 'text-gray-500 dark:text-gray-400'">
                              <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 opacity-50" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22v-5"/><path d="M9 17H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-4"/><path d="M12 17l4-4"/><path d="M12 17l-4-4"/></svg>
                              <span>{{ trip.inExecution ? 'ACTUAL' : formatDateShort(trip.arrival) }}</span>
                            </div>
                          </div>

                          <div class="flex items-center gap-1.5 bg-brand-50 dark:bg-brand-900/20 px-2 py-0.5 rounded-lg border border-brand-100/50 dark:border-brand-500/10 shrink-0">
                            <span class="text-[9px] font-black text-brand-600 dark:text-brand-400">{{ trip.navigatedDays }}</span>
                            <span class="text-[8px] font-bold text-brand-400 dark:text-brand-500 uppercase tracking-tight">días navegados</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </Transition>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import dashboardService, { type FatigueAlert, type FatigueTrip } from '@/modules/dashboard/services/dashboard.service'

const revisionDelays = ref<any[]>([])
const reportDelays = ref<any[]>([])
const fatigueAlerts = ref<{
  id: string;
  name: string;
  initials: string;
  value: number;
  percent: number;
  reason: string;
  isOver: boolean;
  daysSinceLast: number | null;
  trips: FatigueTrip[];
}[]>([])

const expandedId = ref<string | null>(null)

const toggleExpand = (id: string) => {
  expandedId.value = expandedId.value === id ? null : id
}

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

const calculateDaysSince = (dateStr: string | null) => {
  if (!dateStr) return null
  const arrival = new Date(dateStr)
  const now = new Date()

  arrival.setHours(0, 0, 0, 0)
  now.setHours(0, 0, 0, 0)

  const diffTime = now.getTime() - arrival.getTime()
  return Math.max(0, Math.floor(diffTime / (1000 * 60 * 60 * 24)))
}

const formatDateShort = (dateStr: string | null) => {
  if (!dateStr) return 'N/D'
  return new Date(dateStr).toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit'
  })
}

const loadCriticalDelays = async () => {
    try {
        const data = await dashboardService.getCriticalDelays()
        revisionDelays.value = data
    } catch {
        revisionDelays.value = []
    }
}

const loadFatigueAlerts = async () => {
  try {
    const data: FatigueAlert[] = await dashboardService.getFatigueAlerts()
    fatigueAlerts.value = data
      .map((item) => ({
        id: item.id,
        name: item.name,
        initials: buildInitials(item.name),
        value: item.days,
        percent: Math.round((item.days / 180) * 100),
        reason: 'Acumulado anual',
        isOver: item.days > 180,
        daysSinceLast: calculateDaysSince(item.lastArrival),
        trips: item.trips || []
      }))
      .sort((a, b) => b.value - a.value)
  } catch (error) {
    fatigueAlerts.value = []
  }
}

const loadReportDelays = async () => {
    try {
        const data = await dashboardService.getReportDelays()
        reportDelays.value = data
    } catch {
        reportDelays.value = []
    }
}

onMounted(() => {
  loadFatigueAlerts()
  loadCriticalDelays()
  loadReportDelays()
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
