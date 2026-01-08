```
<template>
  <div class="flex flex-col h-full gap-6">
    <!-- Header de Columna -->
    <div class="flex items-center justify-between px-2">
      <div class="flex items-center gap-3">
        <div class="p-2 bg-red-50 dark:bg-red-500/10 rounded-xl relative">
          <div class="w-2 h-2 rounded-full bg-red-500 animate-ping absolute top-0 right-0"></div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-red-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        </div>
        <div>
          <h2 class="text-lg font-black text-gray-900 dark:text-white uppercase tracking-tight leading-none">
            Central de alertas
          </h2>
          <p class="text-xs font-medium text-gray-400 mt-1">Gestión por excepción</p>
        </div>
      </div>
      <div>
        <span class="text-xs font-black px-3 py-1.5 rounded-xl bg-red-500 text-white shadow-lg shadow-red-500/20">
          {{ totalAlerts }} ACTIVAS
        </span>
      </div>
    </div>

    <!-- Container Scrollable -->
    <div class="flex flex-col gap-4 flex-1 overflow-y-auto custom-scrollbar pr-2 pb-4">
        
      <!-- CARD 1: Retrasos Críticos (Red) -->
      <div 
        v-if="showDelays"
        class="rounded-3xl border border-gray-100 bg-white shadow-sm dark:border-gray-800 dark:bg-gray-900 relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'delays' ? 'border-l-red-500' : 'border-l-red-300 dark:border-l-red-900/50']"
      >
        <!-- Header Ficha -->
        <button 
          @click="toggleSection('delays')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-gray-50 dark:border-gray-800 bg-gray-50/30 dark:bg-gray-800/20': expandedSection === 'delays' }"
        >
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'delays' ? 'bg-red-500 text-white' : 'bg-red-50 dark:bg-red-900/10 text-red-500']"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-gray-700 dark:text-gray-200 tracking-wide flex items-center gap-2">
                Entregas Retrasadas
                <span 
                  class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors"
                  :class="[
                    revisionDelays.length > 0 
                      ? 'bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400' 
                      : 'bg-gray-100 dark:bg-gray-800 text-gray-400 dark:text-gray-500'
                  ]"
                >
                  {{ revisionDelays.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Documentación pendiente</p>
            </div>
          </div>
          <svg 
            xmlns="http://www.w3.org/2000/svg" 
            class="w-5 h-5 text-gray-400 transition-transform duration-300" 
            :class="{ 'rotate-180': expandedSection === 'delays' }"
            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
          >
            <polyline points="6 9 12 15 18 9"/>
          </svg>
        </button>

        <Transition
          enter-active-class="transition-all duration-300 ease-out"
          enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100"
          leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100"
          leave-to-class="max-h-0 opacity-0"
        >
          <div v-if="expandedSection === 'delays'" class="p-5 pt-2">
            <div v-if="revisionDelays.length" class="grid gap-3">
              <div
                v-for="item in revisionDelays"
                :key="item.id"
                class="flex items-center justify-between rounded-xl border border-gray-50 bg-gray-50/50 p-3 transition-colors hover:bg-red-50/30 hover:border-red-100 dark:border-gray-800 dark:bg-gray-800/30 dark:hover:bg-red-900/10 dark:hover:border-red-900/30"
              >
                <div>
                    <div class="flex items-center gap-2 mb-1">
                        <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.mareaId }}</span>
                        <span class="text-[10px] font-bold px-1.5 py-0.5 rounded-md bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400 uppercase tracking-tight">{{ item.vesselName }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-gray-400">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <span class="text-[10px] font-bold uppercase">{{ item.obs }}</span>
                    </div>
                </div>

                <div class="flex items-center gap-3">
                  <div class="text-right">
                    <span class="block text-sm font-black text-red-600 dark:text-red-400 leading-none">{{ item.days }}</span>
                    <span class="text-[8px] font-bold text-red-400 dark:text-red-500 uppercase tracking-tighter">Días</span>
                  </div>
                  <button
                    v-if="showActions"
                    @click="openReclamo(item)"
                    class="w-8 h-8 rounded-lg bg-white dark:bg-gray-800 shadow-sm border border-gray-100 dark:border-gray-700 flex items-center justify-center text-gray-400 hover:text-red-500 hover:border-red-200 transition-all"
                    title="Reclamar documentación"
                  >
                    <MailIcon v-if="item.email" class="w-4 h-4" />
                    <PhoneIcon v-else class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-gray-50/50 dark:bg-gray-800/20 rounded-2xl border border-dashed border-gray-200 dark:border-gray-800">
              <p class="text-xs font-medium text-gray-400">Sin entregas pendientes fuera de término.</p>
            </div>
          </div>
        </Transition>
      </div>

      <!-- CARD 2: Informes Demorados (Orange) -->
      <div 
        v-if="showReports"
        class="rounded-3xl border border-gray-100 bg-white shadow-sm dark:border-gray-800 dark:bg-gray-900 relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'reports' ? 'border-l-orange-500' : 'border-l-orange-300 dark:border-l-orange-900/50']"
      >
        <!-- Header Ficha -->
        <button 
          @click="toggleSection('reports')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-gray-50 dark:border-gray-800 bg-gray-50/30 dark:bg-gray-800/20': expandedSection === 'reports' }"
        >
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'reports' ? 'bg-orange-500 text-white' : 'bg-orange-50 dark:bg-orange-900/10 text-orange-500']"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-gray-700 dark:text-gray-200 tracking-wide flex items-center gap-2">
                Informes Demorados
                <span 
                  class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors"
                  :class="[
                    reportDelays.length > 0 
                      ? 'bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400' 
                      : 'bg-gray-100 dark:bg-gray-800 text-gray-400 dark:text-gray-500'
                  ]"
                >
                  {{ reportDelays.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Procesamiento de datos</p>
            </div>
          </div>
          <svg 
            xmlns="http://www.w3.org/2000/svg" 
            class="w-5 h-5 text-gray-400 transition-transform duration-300" 
            :class="{ 'rotate-180': expandedSection === 'reports' }"
            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
          >
            <polyline points="6 9 12 15 18 9"/>
          </svg>
        </button>

        <Transition
          enter-active-class="transition-all duration-300 ease-out"
          enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100"
          leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100"
          leave-to-class="max-h-0 opacity-0"
        >
          <div v-if="expandedSection === 'reports'" class="p-5 pt-2">
            <div v-if="reportDelays.length" class="grid gap-3">
              <div
                v-for="item in reportDelays"
                :key="item.id"
                class="flex items-center justify-between rounded-xl border border-gray-50 bg-gray-50/50 p-3 transition-colors hover:bg-orange-50/30 hover:border-orange-100 dark:border-gray-800 dark:bg-gray-800/30 dark:hover:bg-orange-900/10 dark:hover:border-orange-900/30"
              >
                <div>
                    <div class="flex items-center gap-2 mb-1">
                        <span class="text-xs font-black text-gray-900 dark:text-white">{{ item.mareaId }}</span>
                        <span class="text-[10px] font-bold px-1.5 py-0.5 rounded-md bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400 uppercase tracking-tight">{{ item.vesselName }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 text-gray-400">
                         <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <span class="text-[10px] font-bold uppercase">{{ item.obs }}</span>
                    </div>
                </div>

                <div class="flex items-center gap-3">
                  <div class="text-right">
                    <span class="block text-sm font-black text-orange-600 dark:text-orange-400 leading-none">{{ item.days }}</span>
                    <span class="text-[8px] font-bold text-orange-400 dark:text-orange-500 uppercase tracking-tighter">Días</span>
                  </div>
                  <router-link
                    v-if="showActions"
                    :to="`/mareas/workflow/${item.id}`"
                    class="w-8 h-8 rounded-lg bg-white dark:bg-gray-800 shadow-sm border border-gray-100 dark:border-gray-700 flex items-center justify-center text-gray-400 hover:text-orange-500 hover:border-orange-200 transition-all"
                  >
                   <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                  </router-link>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-gray-50/50 dark:bg-gray-800/20 rounded-2xl border border-dashed border-gray-200 dark:border-gray-800">
              <p class="text-xs font-medium text-gray-400">Sin informes pendientes.</p>
            </div>
          </div>
        </Transition>
      </div>

      <!-- CARD 3: Fatigue (Blue/Brand) -->
      <div 
        v-if="showFatigue"
        class="rounded-3xl border border-gray-100 bg-white shadow-sm dark:border-gray-800 dark:bg-gray-900 relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'fatigue' ? 'border-l-brand-500' : 'border-l-brand-300 dark:border-l-brand-900/50']"
      >
        <!-- Header Ficha -->
        <button 
          @click="toggleSection('fatigue')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-gray-50 dark:border-gray-800 bg-gray-50/30 dark:bg-gray-800/20': expandedSection === 'fatigue' }"
        >
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'fatigue' ? 'bg-brand-500 text-white' : 'bg-brand-50 dark:bg-brand-900/10 text-brand-500']"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="23" y1="11" x2="17" y2="11"/></svg>
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-gray-700 dark:text-gray-200 tracking-wide flex items-center gap-2">
                Fatiga / Personal
                <span 
                  class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors"
                  :class="[
                    fatigueAlerts.length > 0 
                      ? 'bg-brand-100 dark:bg-brand-900/30 text-brand-600 dark:text-brand-400' 
                      : 'bg-gray-100 dark:bg-gray-800 text-gray-400 dark:text-gray-500'
                  ]"
                >
                  {{ fatigueAlerts.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Gestión de esfuerzo</p>
            </div>
          </div>
          <svg 
            xmlns="http://www.w3.org/2000/svg" 
            class="w-5 h-5 text-gray-400 transition-transform duration-300" 
            :class="{ 'rotate-180': expandedSection === 'fatigue' }"
            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
          >
            <polyline points="6 9 12 15 18 9"/>
          </svg>
        </button>

        <Transition
          enter-active-class="transition-all duration-300 ease-out"
          enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100"
          leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100"
          leave-to-class="max-h-0 opacity-0"
        >
          <div v-if="expandedSection === 'fatigue'" class="p-5 pt-2">
            <div v-if="fatigueAlerts.length" class="grid gap-2">
              <div
                v-for="item in fatigueAlerts"
                :key="item.id"
                class="flex flex-col overflow-hidden"
              >
                <!-- Header/Toggle Individual -->
                <div
                  @click="toggleExpandIndividual(item.id)"
                  class="group flex items-center justify-between rounded-xl border border-gray-50 bg-gray-50/50 p-3 transition-all hover:bg-white hover:shadow-sm dark:border-gray-800 dark:bg-gray-800/20 dark:hover:bg-gray-800 cursor-pointer relative"
                  :class="{ 'border-brand-100 bg-white shadow-sm dark:border-brand-900/30': expandedIndividualId === item.id }"
                >
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-full bg-brand-50 dark:bg-brand-900/20 flex items-center justify-center relative shrink-0">
                      <span class="text-[10px] font-black text-brand-500">{{ item.initials }}</span>
                      <div v-if="expandedIndividualId === item.id" class="absolute -bottom-1 -right-1 bg-brand-500 text-white rounded-full p-0.5 shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-2 h-2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="m18 15-6-6-6 6"/></svg>
                      </div>
                    </div>
                    <div class="flex flex-col min-w-0">
                      <span class="text-xs font-black text-gray-900 dark:text-white truncate">{{ item.name }}</span>
                      <span class="text-[9px] font-bold text-gray-400 uppercase tracking-tighter">{{ item.reason }}</span>
                    </div>
                  </div>
                  <div class="text-right flex flex-col items-end gap-0.5 shrink-0">
                    <span class="text-xs font-black bg-gray-100 dark:bg-gray-700 px-2 py-0.5 rounded-lg transition-colors" :class="[item.isOver ? 'text-red-600 dark:text-red-400' : 'text-green-700 dark:text-green-300', expandedIndividualId === item.id ? 'bg-brand-50 dark:bg-brand-900/30' : '']">
                      {{ item.value }} d
                    </span>
                    <span class="text-[8px] font-bold text-gray-400 uppercase tracking-tight">
                        {{ item.percent }}%
                    </span>
                  </div>
                </div>

                <!-- Accordion Content Individual -->
                <Transition
                  enter-active-class="transition-all duration-300 ease-out"
                  enter-from-class="max-h-0 opacity-0"
                  enter-to-class="max-h-[500px] opacity-100"
                  leave-active-class="transition-all duration-200 ease-in"
                  leave-from-class="max-h-[500px] opacity-100"
                  leave-to-class="max-h-0 opacity-0"
                >
                  <div v-if="expandedIndividualId === item.id" class="px-2 pb-2 pt-1">
                     <div class="rounded-xl bg-gray-50/50 dark:bg-gray-800/30 border border-gray-100 dark:border-gray-800/50 overflow-hidden">
                        <div class="px-3 py-2 border-b border-gray-100 dark:border-gray-800/50 bg-white/50 dark:bg-gray-900/20 flex justify-between items-center">
                            <span class="text-[9px] font-black uppercase text-gray-400 tracking-widest">Historial</span>
                            <span class="text-[9px] font-bold text-brand-500">{{ item.trips?.length || 0 }} viajes</span>
                        </div>
                        <div class="px-2 pb-2 pt-2 space-y-1">
                            <div v-for="(trip, idx) in item.trips" :key="idx" class="p-2 rounded-lg bg-white dark:bg-gray-800/40 border border-gray-100 dark:border-gray-700/50 flex justify-between items-center group/trip">
                                <div class="flex flex-col min-w-0 pr-2">
                                    <span class="text-[10px] font-bold text-gray-700 dark:text-gray-300">{{ trip.mareaCode }}</span>
                                    <span class="text-[9px] text-gray-400 font-medium truncate">{{ trip.vessel }}</span>
                                </div>
                                <span class="text-[10px] font-bold text-brand-500 whitespace-nowrap">{{ trip.navigatedDays }}d</span>
                            </div>
                        </div>
                     </div>
                  </div>
                </Transition>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-gray-50/50 dark:bg-gray-800/20 rounded-2xl border border-dashed border-gray-200 dark:border-gray-800">
              <p class="text-xs font-medium text-gray-400">Sin alertas de fatiga.</p>
            </div>
          </div>
        </Transition>
      </div>
    </div>
    <ReclamoEntregaDialog
      :show="showReclamoDialog"
      :id="selectedReclamoItem?.id || ''"
      :marea-id="selectedReclamoItem?.mareaId || ''"
      :vessel-name="selectedReclamoItem?.vesselName || ''"
      :obs-name="selectedReclamoItem?.obs || ''"
      :email="selectedReclamoItem?.email"
      :delay-days="selectedReclamoItem?.days || 0"
      :arrival-date="selectedReclamoItem?.arrivalDate ? new Date(selectedReclamoItem.arrivalDate).toLocaleDateString() : ''"
      @close="showReclamoDialog = false"
      @confirm="handleReclamoConfirm"
    />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { MailIcon, PhoneIcon } from '@/icons'
import dashboardService, { type FatigueAlert, type FatigueTrip } from '@/modules/dashboard/services/dashboard.service'
import ReclamoEntregaDialog from './ReclamoEntregaDialog.vue'

const showReclamoDialog = ref(false)
const selectedReclamoItem = ref<any>(null)

const openReclamo = (item: any) => {
  selectedReclamoItem.value = item
  showReclamoDialog.value = true
}

const handleReclamoConfirm = async (payload: any) => {
  try {
    await dashboardService.sendClaim(payload)
    toast.success(`Reclamo enviado correctamente a ${payload.to}`)
  } catch (error) {
    console.error('Error enviando reclamo:', error)
    toast.error('Error al enviar el correo de reclamo')
  } finally {
    showReclamoDialog.value = false
    selectedReclamoItem.value = null
  }
}

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

const props = withDefaults(defineProps<{
  showActions?: boolean
  showDelays?: boolean
  showReports?: boolean
  showFatigue?: boolean
}>(), {
  showActions: true,
  showDelays: true,
  showReports: true,
  showFatigue: true
})

const expandedSection = ref<'delays' | 'reports' | 'fatigue' | null>(null)
const expandedIndividualId = ref<string | null>(null)

const toggleSection = (section: 'delays' | 'reports' | 'fatigue') => {
  expandedSection.value = expandedSection.value === section ? null : section
}

const toggleExpandIndividual = (id: string) => {
  expandedIndividualId.value = expandedIndividualId.value === id ? null : id
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

/* Forzar que las alturas de las transiciones funcionen correctamente */
.transition-all {
    backface-visibility: hidden;
}
</style>
