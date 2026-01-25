<template>
  <div class="rounded-3xl border border-border bg-surface shadow-sm flex flex-col border-l-4 border-l-info overflow-hidden transition-all duration-300">
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
          <button
            v-for="days in [3, 7]"
            :key="days"
            @click="setDays(days)"
            class="px-4 py-1.5 text-[11px] font-black rounded-lg transition-all uppercase tracking-wider"
            :class="selectedDays === days
              ? 'bg-surface text-primary shadow-sm ring-1 ring-black/5'
              : 'text-text-muted hover:text-text hover:bg-surface/50'"
          >
            Últimos {{ days }} días
          </button>
        </div>

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

    <!-- Content -->
    <div
      class="transition-all duration-300 overflow-hidden border-t border-border/50 bg-surface-muted/10"
      :class="isCollapsed ? 'max-h-0 opacity-0' : 'max-h-[500px] opacity-100'"
    >
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

      <div v-else class="overflow-y-auto max-h-[400px] custom-scrollbar">
        <table class="w-full text-left border-collapse">
          <thead class="bg-surface sticky top-0 z-10 shadow-sm">
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
            <tr
              v-for="mov in movements"
              :key="mov.id"
              class="hover:bg-surface-muted/50 transition-colors"
            >
              <!-- Col 1: Buque -->
              <td class="px-6 py-4 align-middle">
                <div class="font-bold text-text text-xs leading-tight">
                  {{ mov.buque }}
                </div>
              </td>

              <!-- Col 2: Evento (Nombre) -->
              <td class="px-4 py-4 align-middle">
                <span
                  class="text-[10px] font-bold uppercase"
                  :class="mov.tipo === 'ZARPADA' ? 'text-blue-500' : 'text-emerald-500'"
                >
                  {{ mov.tipo }}
                </span>
              </td>

              <!-- Col 3: Fecha / Puerto -->
              <td class="px-4 py-4 align-middle">
                 <div class="flex flex-col gap-0.5">
                    <span class="text-[11px] font-bold text-text tabular-nums">
                      {{ formatDate(mov.fecha) }}
                    </span>
                    <span class="text-[10px] font-medium text-text-muted/70 truncate max-w-[120px]" :title="mov.puerto">
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
                  <span class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[9px] font-black uppercase tracking-tighter border border-border w-fit">
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import { ChevronDownIcon, ShipIcon } from '@/icons'
import mareasService, { type MovementEvent } from '@/modules/mareas/services/mareas.service'

const isCollapsed = ref(false)
const selectedDays = ref(3)
const movements = ref<MovementEvent[]>([])
const loading = ref(false)

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value
}

const setDays = (days: number) => {
  if (selectedDays.value === days) return
  selectedDays.value = days
  loadMovements()
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return new Intl.DateTimeFormat('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date)
}

const loadMovements = async () => {
  loading.value = true
  try {
    movements.value = await mareasService.getRecentMovements(selectedDays.value)
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
