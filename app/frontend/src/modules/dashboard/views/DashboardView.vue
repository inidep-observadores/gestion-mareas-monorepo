<template>
  <AdminLayout
    title="Centro de Comando"
    description="Panel General Operativo: Gestión por excepción y monitoreo de flota en tiempo real."
  >
    <!-- <template #extra-header>
      <div class="flex items-center gap-4">
        <router-link
          to="/mareas/calendar"
          class="flex items-center gap-2 px-4 py-2 bg-surface border border-border rounded-xl hover:bg-surface-muted transition-all shadow-sm ring-1 ring-black/5"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-text-muted" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
          <span class="text-xs font-bold text-text">Calendario Logístico</span>
        </router-link>
      </div>
    </template> -->

    <div v-if="!isHistoricalYear" class="relative min-h-[calc(100vh-120px)] z-1 pb-10 mt-6 md:mt-0">

      <!-- ROW 1: THE PULSE OF THE MOMENT (KPIs) -->
      <div class="mb-8">
        <ActionKpis />
      </div>

      <!-- ROW 2: CRITICAL PANELS -->
      <div class="grid grid-cols-12 gap-8 mb-8 items-start">
        <!-- ALERT CENTER (Left) -->
        <div class="col-span-12 lg:col-span-6 xl:col-span-5 flex flex-col gap-8">
          <AlertTrafficLight :show-actions="false" :workforce-data="workforceData" />
          <div class="flex flex-col gap-2">
            <WorkforceOverview :data="workforceData" @view-timeline="openTimeline" @refresh="loadWorkforce" />
            <TopDryTime v-show="false" :topDry="workforceData?.topDry || []" @view-timeline="openTimeline" />
          </div>
        </div>

        <!-- PANELS DERECHA (Right) -->
        <div class="col-span-12 lg:col-span-6 xl:col-span-7 flex flex-col gap-8">
          <RecentMovements />
          <ExpiringMareas />
          <FleetDistributionByFishery />
        </div>
      </div>
    </div>

    <!-- Historical Year Placeholder -->
    <div v-else class="relative flex flex-col items-center justify-center min-h-[calc(100vh-120px)] z-1 pb-10 mt-6 md:mt-0 px-4 text-center">
      <div class="max-w-md mx-auto p-8 rounded-3xl bg-surface/50 backdrop-blur-sm border border-border shadow-theme-lg flex flex-col items-center">
        <div class="w-16 h-16 mb-6 rounded-2xl bg-warning/10 text-warning flex items-center justify-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"/>
            <polyline points="12 6 12 12 16 14"/>
          </svg>
        </div>
        <h2 class="text-xl font-bold text-text mb-3 tracking-tight">Datos Históricos</h2>
        <p class="text-sm text-text-muted leading-relaxed mb-8">
          El Centro de Comando muestra el pulso operativo en tiempo real y sólo está disponible para el año en curso.
          Ahora está visualizando datos del año operativo <strong class="text-text">{{ configStore.selectedYear }}</strong>.
        </p>
        <button
          @click="resetToCurrentYear"
          class="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-primary text-primary-fg text-sm font-bold shadow-theme-md hover:bg-primary/90 hover:shadow-theme-lg hover:-translate-y-0.5 transition-all active:scale-95"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            <polyline points="9 22 9 12 15 12 15 22"/>
          </svg>
          Volver al año en curso
        </button>
      </div>
    </div>

    <!-- Centralized Dialogs -->
    <ObservadorTimelineDialog
      v-if="showTimelineDialog"
      :show="showTimelineDialog"
      :observador-id="selectedObserver?.id"
      :observador-name="selectedObserver?.name"
      :year="selectedYear"
      @close="showTimelineDialog = false"
      @refresh="loadWorkforce"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { toast } from 'vue-sonner'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import ActionKpis from '../components/ActionKpis.vue'
import AlertTrafficLight from '../components/AlertTrafficLight.vue'
import ExpiringMareas from '../components/ExpiringMareas.vue'
import FleetDistributionByFishery from '../components/FleetDistributionByFishery.vue'
import WorkforceOverview from '../components/WorkforceOverview.vue'
import TopDryTime from '../components/TopDryTime.vue'
import RecentMovements from '../components/RecentMovements.vue'
import ObservadorTimelineDialog from '@/modules/admin/components/ObservadorTimelineDialog.vue'
import dashboardService, { type WorkforceStatus } from '../services/dashboard.service'
import { useConfigStore } from '@/modules/shared/stores/config.store'
import { storeToRefs } from 'pinia'

const workforceData = ref<WorkforceStatus | null>(null)
const showTimelineDialog = ref(false)
const selectedObserver = ref<{ id: string, name: string } | null>(null)
const configStore = useConfigStore()
const { selectedYear } = storeToRefs(configStore)

const currentYear = new Date().getFullYear()
const isHistoricalYear = computed(() => configStore.selectedYear < currentYear)

const resetToCurrentYear = () => {
  configStore.setSelectedYear(currentYear)
}

const openTimeline = (id: string, name: string) => {
  selectedObserver.value = { id, name }
  showTimelineDialog.value = true
}

const loadWorkforce = async () => {
  try {
    workforceData.value = await dashboardService.getWorkforceStatus()
  } catch (error) {
    toast.error('Error al cargar datos del personal')
  }
}

onMounted(() => {
  loadWorkforce()
})
</script>

<style scoped>
/* Reducir padding en AdminLayout si es necesario para que entre en una pantalla */
:deep(.admin-layout-content) {
  padding-top: 1.5rem !important;
}
</style>
