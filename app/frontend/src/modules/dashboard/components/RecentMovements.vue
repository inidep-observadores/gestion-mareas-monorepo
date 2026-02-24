<template>
  <div
    class="rounded-3xl border border-border bg-surface shadow-sm flex flex-col border-l-4 border-l-info overflow-hidden transition-all duration-300">
    <!-- Header -->
    <div class="p-5 flex items-center justify-between bg-surface relative">
      <div class="flex items-center gap-3">
        <div class="w-1.5 h-1.5 rounded-full bg-info animate-pulse"></div>
        <h2 class="text-sm font-black text-text uppercase tracking-widest">
          Movimientos de buques
        </h2>
      </div>

      <div class="flex items-center gap-4">
        <!-- Date Filter (Tabs Style) -->
        <div class="flex p-1 bg-surface-muted/50 rounded-xl border border-border/50">
          <button v-for="days in [3, 7]" :key="days" @click="setDays(days)"
            class="px-4 py-1.5 text-[11px] font-black rounded-lg transition-all uppercase tracking-wider" :class="selectedDays === days
              ? 'bg-surface text-primary shadow-sm ring-1 ring-black/5'
              : 'text-text-muted hover:text-text hover:bg-surface/50'">
            Últimos {{ days }} días
          </button>
        </div>

        <!-- Collapse Toggle -->
        <button @click="toggleCollapse"
          class="w-8 h-8 flex items-center justify-center rounded-xl hover:bg-surface-muted text-text-muted hover:text-text transition-all">
          <ChevronDownIcon class="w-4 h-4 transition-transform duration-300" :class="{ 'rotate-180': !isCollapsed }" />
        </button>
      </div>
    </div>

    <!-- Content -->
    <div class="transition-all duration-300 overflow-hidden border-t border-border/50 bg-surface-muted/10"
      :class="isCollapsed ? 'max-h-0 opacity-0' : 'max-h-[500px] opacity-100'">
      <div v-if="loading" class="py-12 flex justify-center">
        <div class="flex flex-col items-center gap-3">
          <div class="w-6 h-6 border-2 border-info border-t-transparent rounded-full animate-spin"></div>
          <span class="text-[10px] font-bold text-text-muted uppercase tracking-widest">Cargando...</span>
        </div>
      </div>

      <div v-else-if="movements.length === 0" class="py-12 flex flex-col items-center justify-center opacity-40">
        <ShipIcon class="w-12 h-12 mb-3 text-text-muted/30" />
        <p class="text-xs font-bold text-text-muted uppercase tracking-widest">Sin movimientos recientes</p>
      </div>

      <div class="px-6 pb-6">
        <div class="rounded-2xl border border-border overflow-hidden bg-surface">
          <div class="overflow-y-auto max-h-[400px] custom-scrollbar">
            <table class="w-full text-left border-collapse">
              <thead class="bg-surface sticky top-0 z-10 shadow-sm border-b border-border">
                <tr>
                  <th class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider w-[20%]">
                    Buque
                  </th>
                  <th class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider w-[15%]">
                    Evento
                  </th>
                  <th class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider w-[15%]">
                    Fecha / Puerto
                  </th>
                  <th class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider w-[20%]">
                    Marea
                  </th>
                  <th class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider w-[30%]">
                    Observador
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border bg-surface">
                <tr v-for="mov in movements" :key="mov.id" 
                @click="openMareaDetail(mov.mareaId)"
                class="hover:bg-surface-muted/50 transition-colors cursor-pointer group">
                  <!-- Col 1: Buque -->
                  <td class="px-6 py-4 align-middle">
                    <div class="font-bold text-text text-xs leading-tight">
                      {{ mov.buque }}
                    </div>
                  </td>

                  <!-- Col 2: Evento (Nombre) -->
                  <td class="px-4 py-4 align-middle">
                    <div class="flex flex-col gap-1.5">
                      <span class="text-[10px] font-bold uppercase"
                        :class="mov.tipo === 'ZARPADA' ? 'text-blue-500' : 'text-emerald-500'">
                        {{ mov.tipo }}
                      </span>
                      <!-- Badges de fuentes -->
                      <div v-if="mov.fuentes && mov.fuentes.sources" class="flex flex-wrap gap-1">
                        <template v-for="(src, index) in mov.fuentes.sources" :key="index">
                          <TrajectorySourceBadge
                            v-if="src.name === 'TRACKING_CSV' || src.name === 'PNA' || src.name === 'API_PNA'"
                            :source="src.name" :vesselId="mov.vesselId" :vesselName="mov.buque"
                            :referenceDate="TrajectoryRangeUtils.resolveAlertDates({ metadata: mov.fuentes, fechaDetectada: mov.fecha }).referenceDate"
                            :endDate="TrajectoryRangeUtils.resolveAlertDates({ metadata: mov.fuentes, fechaDetectada: mov.fecha }).endDate"
                            :mareaCode="mov.marea" :abbreviated="true" />
                          <span v-else
                            class="px-1.5 py-0.5 rounded text-[8px] font-black tracking-tighter uppercase border"
                            :class="getSourceStyle(src.name === 'API_PNA' ? 'PNA' : src.name)">
                            {{ src.name === 'API_PNA' ? 'PNA' : src.name }}
                          </span>
                        </template>
                      </div>
                    </div>
                  </td>

                  <!-- Col 3: Fecha / Puerto -->
                  <td class="px-4 py-4 align-middle">
                    <div class="flex flex-col gap-0.5">
                      <span class="text-[11px] font-bold text-text tabular-nums"
                        :title="mov.fechaDb !== mov.fecha ? 'Fecha precisa de metadata' : 'Fecha de registro'">
                        {{ mov.fechaDb !== mov.fecha ? formatDateTime(mov.fecha) : formatDate(mov.fecha) }}
                      </span>
                      <span class="text-[10px] font-medium text-text-muted/70 truncate max-w-[120px]"
                        :title="mov.puerto">
                        {{ mov.puerto }}
                      </span>
                    </div>
                  </td>

                  <!-- Col 4: Marea (Code + Badge Etapa) -->
                  <td class="px-4 py-4 align-middle">
                    <div class="flex flex-col gap-1">
                      <span class="text-[11px] font-bold text-text-muted tabular-nums">
                        {{ mov.marea }}
                      </span>
                      <span
                        class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[9px] font-black uppercase tracking-tighter border border-border w-fit">
                        Etapa {{ mov.etapa }}
                      </span>
                    </div>
                  </td>

                  <!-- Col 5: Observador -->
                  <td class="px-4 py-4 align-middle">
                    <div class="text-xs font-bold text-text">
                      {{ mov.observador }}
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <!-- Display Last Updated Time for Etapas -->
        <div v-if="lastEtapaUpdate"
          class="mt-4 pt-4 border-t border-border/30 flex items-center justify-end gap-2 text-[10px] font-bold text-text-muted/60 uppercase tracking-widest bg-surface/30">
          <span class="w-1.5 h-1.5 rounded-full bg-success/40"></span>
          Última actualización de etapas: {{ formatDateTime(lastEtapaUpdate) }}
        </div>
      </div>
    </div>
    
    <MareaQuickDetailModal 
      :is-open="showMareaModal" 
      :marea-id="selectedMareaId" 
      @close="showMareaModal = false" 
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import { ChevronDownIcon, ShipIcon } from '@/icons'
import mareasService from '@/modules/mareas/services/mareas.service'
import TrajectorySourceBadge from '@/modules/alerts/components/TrajectorySourceBadge.vue'
import { TrajectoryRangeUtils } from '@/modules/alerts/utils/trajectory-range.utils'
import type { MovementEvent } from '@/modules/mareas/types/marea.types'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'

const isCollapsed = ref(false)
const selectedDays = ref(3)
const movements = ref<MovementEvent[]>([])
const loading = ref(false)
const lastEtapaUpdate = ref<string | null>(null)

// Marea Quick Detail Modal
const showMareaModal = ref(false)
const selectedMareaId = ref<string | null>(null)

const openMareaDetail = (mareaId: string) => {
  if (!mareaId) return
  selectedMareaId.value = mareaId
  showMareaModal.value = true
}

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value
}

const setDays = async (days: number) => {
  if (selectedDays.value === days) return
  selectedDays.value = days
  await loadMovements()
}

const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return new Intl.DateTimeFormat('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date)
}

const formatDateTime = (dateTimeStr: string) => {
  if (!dateTimeStr) return '-'
  const date = new Date(dateTimeStr)
  return new Intl.DateTimeFormat('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(date)
}

const getSources = (fuentes: any): string[] => {
  if (!fuentes) return []
  // Estructura: { sources: [{ name, ... }], automatizado: boolean }
  if (Array.isArray(fuentes.sources)) {
    const names: string[] = fuentes.sources.map((s: any) => {
      if (s.name === 'API_PNA') return 'PNA'
      if (s.name === 'TRACKING_CSV') return 'TRK'
      return s.name
    })
    return [...new Set(names)]
  }
  return []
}

const getSourceStyle = (source: string) => {
  switch (source) {
    case 'PNA': return 'bg-amber-100/50 text-amber-700 border-amber-200/50 dark:bg-amber-900/30 dark:text-amber-400 dark:border-amber-800/50'
    case 'TRK': return 'bg-emerald-100/50 text-emerald-700 border-emerald-200/50 dark:bg-emerald-900/30 dark:text-emerald-400 dark:border-emerald-800/50'
    default: return 'bg-gray-100/50 text-gray-700 border-gray-200/50 dark:bg-gray-800/30 dark:text-gray-400 dark:border-gray-700/50'
  }
}

const loadMovements = async () => {
  loading.value = true
  try {
    const response = await mareasService.getRecentMovements(selectedDays.value)
    movements.value = response.events
    lastEtapaUpdate.value = response.lastUpdate
  } catch (error) {
    toast.error('Error al cargar movimientos recientes')
    console.error(error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadMovements()
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-surface-muted);
  border-radius: 10px;
}
</style>
