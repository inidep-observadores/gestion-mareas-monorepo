<template>
  <BaseModal
    :show="isOpen"
    @close="$emit('close')"
    maxWidth="5xl"
  >
    <template #title>
      <div class="flex items-center gap-3 py-1">
        <div class="p-2 bg-primary/10 rounded-xl text-primary">
          <ShipIcon class="w-5 h-5" />
        </div>
        <div>
          <h3 class="text-sm font-black text-text uppercase tracking-widest">
            Detalle de Mareas
          </h3>
          <p class="text-[10px] font-bold text-text-muted uppercase tracking-wider">
            {{ title }} • {{ filterValueDisplay }}
          </p>
        </div>
      </div>
    </template>

    <div class="space-y-4 py-1 flex flex-col min-h-0">
      <!-- Search and Filters (Local) -->
      <div v-if="!loading && items.length > 0" class="px-1">
        <SearchInput
          v-model="searchQuery"
          placeholder="Filtrar por marea, buque, observador o pesquería..."
          class="w-full"
        />
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-16 gap-3">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        <p class="text-[10px] font-bold text-text-muted animate-pulse uppercase tracking-widest">Cargando registros...</p>
      </div>

      <!-- Content -->
      <div v-else-if="sortedItems.length > 0" class="overflow-auto rounded-xl border border-border shadow-sm max-h-[65vh] relative">
        <table class="w-full text-left border-collapse table-fixed lg:table-auto">
          <thead class="sticky top-0 z-10 bg-surface shadow-[0_1px_0_0_rgba(0,0,0,0.05)]">
            <tr class="bg-surface-muted/30 border-b border-border">
              <th
                v-for="col in columns"
                :key="col.key"
                @click="handleSort(col.key)"
                class="px-3 py-2 text-[9px] font-black text-text-muted uppercase tracking-widest cursor-pointer hover:bg-surface-muted transition-colors group"
                :class="[col.class, { 'text-primary': sortKey === col.key }]"
              >
                <div class="flex items-center gap-1.5" :class="{ 'justify-center': col.align === 'center', 'justify-end': col.align === 'right' }">
                  {{ col.label }}
                  <div class="flex flex-col -space-y-1 opacity-20 group-hover:opacity-100 transition-opacity" :class="{ 'opacity-100': sortKey === col.key }">
                     <ChevronUpIcon
                        class="w-2.5 h-2.5"
                        :class="{ 'text-primary': sortKey === col.key && sortOrder === 'asc' }"
                     />
                     <ChevronDownIcon
                        class="w-2.5 h-2.5"
                        :class="{ 'text-primary': sortKey === col.key && sortOrder === 'desc' }"
                     />
                  </div>
                </div>
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr
              v-for="marea in sortedItems"
              :key="marea.id"
              class="hover:bg-primary/5 transition-colors group cursor-pointer"
              @click="goToMarea(marea.id)"
            >
              <td class="px-3 py-1.5">
                <span class="text-[11px] font-mono font-bold text-text-muted uppercase leading-none">{{ marea.id_marea }}</span>
              </td>
              <td class="px-3 py-1.5">
                <span class="text-xs font-bold text-text truncate max-w-[140px] block">{{ marea.buque }}</span>
              </td>
              <td class="px-3 py-1.5">
                <div class="flex flex-col leading-tight">
                  <span class="text-[9px] font-black text-text-muted uppercase truncate max-w-[110px]">{{ marea.pesqueria }}</span>
                  <span class="text-[8px] font-bold text-text-muted/50 uppercase leading-none">{{ marea.flota }}</span>
                </div>
              </td>
              <td class="px-3 py-1.5 text-center">
                <Badge color="primary" variant="solid" size="sm" class="font-black tabular-nums text-[9px] h-5 px-1.5">
                  {{ marea.diasContabilizados }}
                </Badge>
              </td>
              <td class="px-3 py-1.5 text-[10px] font-bold text-text/70 truncate max-w-[120px]">
                {{ marea.observador }}
              </td>
               <td class="px-3 py-1.5 text-right">
                <Badge
                  :color="getStatusColor(marea.estado)"
                  variant="light"
                  size="sm"
                  class="font-black text-[8px] uppercase tracking-tighter h-5"
                >
                  {{ marea.estado }}
                </Badge>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Empty State -->
      <div v-else class="flex flex-col items-center justify-center py-16 text-center gap-2">
        <div class="p-3 bg-surface-muted rounded-full">
            <SearchIcon class="w-6 h-6 text-text-muted/40" />
        </div>
        <p class="text-[11px] font-bold text-text-muted uppercase tracking-widest">No se encontraron registros</p>
      </div>

      <!-- Footer Info -->
      <div class="flex items-center justify-between text-[9px] font-black text-text-muted uppercase tracking-widest pt-3 border-t border-border opacity-60">
         <span>{{ sortedItems.length }} mareas encontradas</span>
         <span class="text-primary/60">Análisis Técnico • INIDEP</span>
      </div>
    </div>

    <!-- Quick Detail Modal -->
    <MareaQuickDetailModal
      :is-open="quickDetail.isOpen"
      :marea-id="quickDetail.mareaId"
      @close="quickDetail.isOpen = false"
    />
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { useRouter } from 'vue-router'
import BaseModal from '@/components/common/BaseModal.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import MareaQuickDetailModal from './MareaQuickDetailModal.vue'
import {
  ShipIcon,
  ExternalLinkIcon,
  SearchIcon,
  ChevronUpIcon,
  ChevronDownIcon
} from 'lucide-vue-next'
import { statsService, type StatsDetailItem } from '../services/stats.service'
import { toast } from 'vue-sonner'

const props = defineProps<{
  isOpen: boolean
  title: string
  filterType: 'FISHERY' | 'FLEET' | 'OBSERVER' | null
  filterValue: string | null
  year: number
  mode: 'CALENDAR' | 'TOTAL'
  includeNonProtocolized: boolean
  includeProtocolizedOutOfPeriod: boolean
  daysCalculationMode: 'SHIP' | 'OBSERVER'
  includeCampaigns: boolean
}>()

const emit = defineEmits(['close'])
const router = useRouter()

const loading = ref(false)
const items = ref<StatsDetailItem[]>([])
const filterValueDisplay = ref('')

// Quick Detail State
const quickDetail = ref({
  isOpen: false,
  mareaId: null as string | null
})

const openQuickDetail = (id: string) => {
  quickDetail.value = {
    isOpen: true,
    mareaId: id
  }
}

// Sorting State (Year and Number ascending)
const sortKey = ref<string>('nroMarea')
const sortOrder = ref<'asc' | 'desc'>('asc')

const columns = [
  { key: 'nroMarea', label: 'Marea', align: 'left' },
  { key: 'buque', label: 'Buque', align: 'left' },
  { key: 'pesqueria', label: 'Pesquería / Flota', align: 'left' },
  { key: 'diasContabilizados', label: 'Días', align: 'center', class: 'w-16' },
  { key: 'observador', label: 'Observador', align: 'left' },
  { key: 'estado', label: 'Estado', align: 'left' },
  { key: 'actions', label: '', align: 'right', class: 'w-12' },
]

const handleSort = (key: string) => {
  if (key === 'actions') return
  if (sortKey.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value = key
    sortOrder.value = 'desc'
  }
}

// Search State
const searchQuery = ref('')

const filteredItems = computed(() => {
  if (!items.value.length) return []
  if (!searchQuery.value.trim()) return items.value

  const query = searchQuery.value.toLowerCase().trim()

  return items.value.filter(item => {
    const code = item.id_marea.toLowerCase()
    return (
      code.includes(query) ||
      item.buque.toLowerCase().includes(query) ||
      item.observador.toLowerCase().includes(query) ||
      item.pesqueria.toLowerCase().includes(query) ||
      item.flota.toLowerCase().includes(query)
    )
  })
})

const sortedItems = computed(() => {
  const sourceItems = filteredItems.value
  if (!sourceItems.length) return []

  return [...sourceItems].sort((a: any, b: any) => {
    const modifier = sortOrder.value === 'asc' ? 1 : -1

    // Special case for Marea (Year + Number)
    if (sortKey.value === 'nroMarea') {
      if (a.anioMarea !== b.anioMarea) {
        return (a.anioMarea - b.anioMarea) * modifier
      }
      return (a.nroMarea - b.nroMarea) * modifier
    }

    const valA = a[sortKey.value]
    const valB = b[sortKey.value]

    if (valA === valB) return 0

    if (valA === null || valA === undefined) return 1
    if (valB === null || valB === undefined) return -1

    if (typeof valA === 'string') {
      return valA.localeCompare(valB) * modifier
    }

    return (valA < valB ? -1 : 1) * modifier
  })
})

const fetchDetail = async () => {
  if (!props.isOpen || !props.filterType || !props.filterValue) return

  loading.value = true
  filterValueDisplay.value = props.filterValue

  try {
    items.value = await statsService.getDashboardStatsDetail(
      props.year,
      props.mode,
      props.includeNonProtocolized,
      props.includeProtocolizedOutOfPeriod,
      props.filterType,
      props.filterValue,
      props.daysCalculationMode,
      props.includeCampaigns
    )
  } catch (error) {
    console.error('Error fetching stats detail:', error)
    toast.error('No se pudo cargar el detalle de las mareas.')
    emit('close')
  } finally {
    loading.value = false
  }
}

watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    searchQuery.value = ''
    fetchDetail()
  } else {
    items.value = []
    searchQuery.value = ''
    quickDetail.value.isOpen = false
  }
})

const getStatusColor = (status: string) => {
  const s = status.toUpperCase()
  if (s.includes('FINALIZADA') || s.includes('PROTOCOLIZADA')) return 'success'
  if (s.includes('EJECUCION')) return 'primary'
  if (s.includes('CANCELADA')) return 'error'
  if (s.includes('DESIGNADA')) return 'info'
  return 'warning'
}

const goToMarea = (id: string) => {
  openQuickDetail(id)
}
</script>
