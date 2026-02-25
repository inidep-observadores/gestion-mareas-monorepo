<template>
  <div class="rounded-3xl border border-border bg-surface shadow-sm flex flex-col border-l-4 border-l-success overflow-hidden transition-all duration-300">
    <div class="p-6 flex items-center justify-between bg-surface relative">
      <div class="flex items-center gap-3">
        <div class="w-1.5 h-1.5 rounded-full bg-success animate-pulse"></div>
        <h2 class="text-sm font-black text-text uppercase tracking-widest flex items-center gap-2">
          Mareas próximas a finalizar
        </h2>
      </div>

      <div class="flex items-center gap-3">
        <span class="text-[10px] font-black px-2 py-1 rounded-lg bg-success/10 text-success">Progreso > 80%</span>

        <!-- Collapse Toggle -->
        <button
          @click="toggleCollapse"
          class="w-8 h-8 flex items-center justify-center rounded-xl hover:bg-surface-muted text-text-muted hover:text-text transition-all"
        >
          <ChevronDownIcon
            class="w-4 h-4 transition-transform duration-300"
            :class="{ 'rotate-180': !isCollapsed }"
          />
        </button>
      </div>
    </div>

    <div
      class="transition-all duration-300 overflow-hidden border-t border-border/50 bg-surface-muted/10 px-6"
      :class="isCollapsed ? 'max-h-0 opacity-0 py-0' : 'max-h-[800px] opacity-100 py-6'"
    >
      <div class="space-y-4 overflow-y-auto custom-scrollbar pr-2">
        <div
          v-for="marea in expiringMareas"
          :key="marea.id"
          @click="openMareaDetail(marea.id)"
          class="group p-4 rounded-2xl border border-border bg-surface hover:bg-surface hover:shadow-md hover:border-success/30 transition-all cursor-pointer"
        >
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center gap-3">
              <div
                class="w-10 h-10 rounded-xl bg-surface-muted shadow-sm flex items-center justify-center text-text-muted group-hover:text-success transition-colors"
              >
                <ShipIcon class="w-5 h-5" />
              </div>
              <div class="flex flex-col">
                <span class="text-xs font-black text-text">{{ marea.code }} - {{ marea.buque }}</span>
              <div class="flex items-center gap-2">
                <span class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">{{ marea.obs }}</span>
                <span v-if="marea.en_tierra" class="px-2 py-0.5 bg-success/10 text-success rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap flex items-center gap-1 border border-success/20">
                  <div class="w-1 h-1 rounded-full bg-success animate-pulse"></div>
                  En Tierra
                </span>
              </div>
              </div>
            </div>
            <div class="text-right">
              <span class="text-xs font-black" :class="marea.isOverdue ? 'text-error' : 'text-success'">{{ marea.progreso }}%</span>
            </div>
          </div>

          <div class="relative w-full mt-2">
             <!-- Sports Score Flag Marker -->
             <div
                class="absolute -top-4 z-20 transition-all duration-1000 -ml-0.5 cursor-help group/tooltip"
                :class="marea.isOverdue ? 'text-error' : 'text-text-muted/40'"
                :style="{ left: marea.isOverdue ? marea.splitPoint + '%' : '100%' }"
             >
                <SportsScoreIcon class="w-4 h-4" />
                <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-1.5 px-2 py-1 text-[11px] text-white bg-text rounded-lg opacity-0 invisible group-hover/tooltip:opacity-100 group-hover/tooltip:visible transition-all whitespace-nowrap dark:bg-text-inverse dark:text-text shadow-xl pointer-events-none">
                  Finalización estimada
                </div>
             </div>

             <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden relative">
                <div
                  class="h-full rounded-full transition-all duration-1000 ease-out relative"
                   :class="!marea.isOverdue ? 'bg-success' : ''"
                   :style="{
                      width: marea.isOverdue ? '100%' : marea.progreso + '%',
                      background: marea.isOverdue ? `linear-gradient(90deg, var(--color-success) ${marea.splitPoint}%, var(--color-error) ${marea.splitPoint}%)` : ''
                   }"
                >
                   <div v-if="marea.isOverdue" class="absolute top-0 bottom-0 w-[2px] bg-white shadow-[0_0_2px_rgba(0,0,0,0.2)]" :style="{ left: marea.splitPoint + '%' }"></div>
                </div>
             </div>
          </div>

          <div class="mt-3 flex items-center justify-between text-[10px] font-bold uppercase tracking-tighter">
            <div class="flex items-center gap-2">
              <span class="text-text-muted">{{ marea.en_tierra ? 'Arribo confirmado' : 'Arribo previsto' }}: {{ marea.puerto }}</span>
            </div>
            <span class="text-text-muted">ETA: {{ marea.eta }}</span>
          </div>
        </div>

        <div v-if="expiringMareas.length === 0" class="flex flex-col items-center justify-center opacity-40 py-10">
          <ShipIcon class="w-12 h-12 mb-2 text-text-muted/30" />
          <p class="text-xs font-bold text-text-muted">No hay arribos inminentes</p>
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
import { onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { ShipIcon, SportsScoreIcon, ChevronDownIcon } from '@/icons'
import mareasService from '@/modules/mareas/services/mareas.service'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'

type ExpiringMarea = {
  id: string
  code: string
  buque: string
  obs: string
  progreso: number
  puerto: string
  en_tierra: boolean
  eta: string
  isOverdue: boolean
  splitPoint: number
}

const expiringMareas = ref<ExpiringMarea[]>([])
const isCollapsed = ref(false)

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

const formatEta = (fecha?: string, diasEstimados: number = 30): string => {
  if (!fecha) return 'Pendiente'
  const parsed = new Date(fecha)
  if (Number.isNaN(parsed.getTime())) return 'Pendiente'

  const estimatedEnd = new Date(parsed.getTime() + diasEstimados * 24 * 60 * 60 * 1000)

  return new Intl.DateTimeFormat('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(estimatedEnd)
}

const loadExpiringMareas = async () => {
  try {
    const { items } = await mareasService.getDashboardOperativo()

    expiringMareas.value = items
      .filter((item: any) => item.progreso > 80 && item.estado_codigo === 'EN_EJECUCION')
      .sort((a, b) => b.progreso - a.progreso)
      .slice(0, 4)
      .map((item) => {
        const isOverdue = item.progreso > 100
        const splitPoint = isOverdue ? (100 / item.progreso) * 100 : 0

        return {
          id: item.id,
          code: item.id_marea,
          buque: item.buque_nombre,
          obs: (item as any).observador || 'Sin asignar',
          progreso: item.progreso,
          puerto: item.en_tierra ? (item.puerto_arribo || item.puerto) : (item.puerto_zarpada || item.puerto),
          en_tierra: !!item.en_tierra,
          eta: formatEta(item.fecha_zarpada, item.dias_estimados),
          isOverdue,
          splitPoint
        }
      })
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
  background: var(--color-surface-muted);
  border-radius: 10px;
}
</style>
