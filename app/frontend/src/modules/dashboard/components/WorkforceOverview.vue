<template>
  <div
    class="relative rounded-3xl border border-border bg-surface p-5 shadow-sm border-l-4 border-l-primary flex flex-col overflow-hidden">
    <!-- Total Badge -->
    <div v-if="filteredStats"
      class="absolute top-0 right-0 px-4 py-1.5 bg-primary/10 text-primary border-b border-l border-primary/20 rounded-bl-2xl font-black text-[10px] tracking-widest uppercase shadow-sm">
      {{ filteredStats.total }} TOTAL
    </div>

    <div class="flex items-center gap-3 mb-6">
      <UserGroupIcon class="w-6 h-6 text-primary" />
      <div>
        <h2 class="text-sm font-black text-text uppercase tracking-widest leading-tight">
          Estado del Personal
        </h2>
        <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Distribución operativa de
          observadores</p>
      </div>
    </div>

    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4" :class="[selectedStatus ? 'mb-8' : '']">
      <div v-for="status in distributions" :key="status.label" @click="selectStatus(status.label)"
        class="group relative flex flex-col items-center p-4 rounded-2xl bg-surface-muted/50 border border-border hover:bg-surface hover:shadow-xl hover:border-primary/30 transition-all duration-300 cursor-pointer"
        :class="[selectedStatus === status.label ? `ring-2 ${status.ringClass} bg-surface` : '']">
        <!-- Icon (Hidden for Disponibles as we have the chart) -->
        <div v-if="status.label !== 'Disponibles'" class="mb-3 transition-transform duration-300 group-hover:scale-110 group-hover:-translate-y-1">
          <component :is="status.icon" class="w-6 h-6" :class="status.colorClass" />
        </div>

        <div
          class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 text-center transition-colors group-hover:text-text">
          {{ status.label }}
        </div>

        <div class="flex flex-col items-center gap-0.5" :class="[status.label === 'Disponibles' ? 'mb-1' : 'mb-3']">
          <span class="text-2xl font-black tabular-nums transition-colors" :class="status.colorClass">
            {{ status.count }}
          </span>
          <span class="text-[11px] font-bold text-text-muted tabular-nums">
            ({{ status.value }}%)
          </span>
        </div>

        <!-- Donut Chart for Disponibles -->
        <div v-if="status.label === 'Disponibles' && availableComposition.total > 0" @click.stop class="w-full h-24 mb-2 flex items-center justify-center transition-all">
            <apexchart
                type="donut"
                height="100%"
                width="100%"
                :options="donutOptions"
                :series="availableComposition.series"
            />
        </div>

        <!-- Progress Indicator -->
        <div class="w-full mt-auto">
          <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
            <div class="h-full rounded-full transition-all duration-1000 ease-out" :class="status.bgClass"
              :style="{ width: status.value + '%' }"></div>
          </div>
        </div>
        <!-- Active Indicator Arrow -->
        <div v-if="selectedStatus === status.label"
          class="absolute -bottom-[10px] left-1/2 -translate-x-1/2 w-4 h-4 bg-surface border-r-2 border-b-2 rotate-45 z-10"
          :class="status.borderColorClass"></div>
      </div>
    </div>

    <!-- Detailed List Section -->
    <div v-if="selectedStatus" class="animate-fadeIn flex-grow flex flex-col min-h-0">
      <div class="rounded-2xl border border-border overflow-hidden flex flex-col flex-grow">
        <div class="bg-surface-muted px-6 py-3 border-b border-border flex justify-between items-center shrink-0">
          <h3 class="text-xs font-black text-text-muted uppercase tracking-widest flex items-center gap-2">
            Detalle: {{ selectedStatus }}
            <span v-if="selectedCategory" class="px-2 py-0.5 bg-primary text-white text-[9px] rounded-full flex items-center gap-1 animate-fadeIn">
              {{ selectedCategory }}
              <button @click="selectedCategory = null" class="hover:text-white/80">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-2.5 w-2.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </span>
          </h3>
          <button @click="selectedStatus = null" class="text-text-muted hover:text-text">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Filtros y Búsqueda -->
        <div
          class="px-6 py-2.5 bg-surface border-b border-border flex flex-col sm:flex-row sm:items-center gap-4 shrink-0 transition-all">
          <SearchInput v-model="searchQuery" placeholder="Buscar observador, buque o marea..."
            class="!w-full sm:!w-80" />

          <div class="flex gap-2">
            <button
              v-for="type in [{ key: 'OBSERVADOR', label: 'Observadores' }, { key: 'TECNICO', label: 'Técnicos' }]"
              :key="type.key" @click="toggleType(type.key)"
              class="px-4 py-1 rounded-full text-[10px] font-black uppercase tracking-tight transition-all duration-200"
              :class="[
                selectedTypes.includes(type.key)
                  ? 'bg-primary text-white shadow-sm ring-1 ring-primary'
                  : 'bg-surface-muted text-text-muted border border-border hover:bg-surface hover:text-text'
              ]">
              {{ type.label }}
            </button>
          </div>
        </div>

        <div class="flex-grow overflow-y-auto custom-scrollbar min-h-0 max-h-[400px]">
          <table class="w-full text-left border-collapse">
            <thead class="bg-surface sticky top-0 z-10 shadow-sm">
              <tr>
                <th @click="toggleSort('name')"
                  class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center gap-1">
                    Observador
                    <ChevronDownIcon v-if="sortBy === 'name'" class="w-3 h-3 transition-transform duration-300"
                      :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
                <th v-if="selectedStatus === 'Impedidos'"
                  class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">Motivo</th>
                <th v-else class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">
                  {{ selectedStatus === 'Navegando' ? 'Marea Actual / Buque' : 'Último Arribo' }}
                </th>
                <th v-if="selectedStatus !== 'Impedidos'" @click="toggleSort('days')"
                  class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider text-right cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center justify-end gap-1">
                    {{ selectedStatus === 'Navegando' ? 'Días' : 'Inactividad' }}
                    <ChevronDownIcon v-if="sortBy === 'days'" class="w-3 h-3 transition-transform duration-300"
                      :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border bg-surface">
              <tr v-for="item in currentList" :key="item.id" class="transition-all duration-200" :class="[
                // Prioridad 1: Designados (Celeste suave)
                (item as any).tieneDesignacionActiva
                  ? 'bg-sky-50 dark:bg-sky-950/20 border-l-4 border-l-sky-400'
                  : item.eventual && (item as any).sexo === 'Femenino'
                    ? 'bg-rose-100/40 dark:bg-rose-900/10 border-l-4 border-l-gray-400' 
                    : item.eventual
                      ? 'bg-slate-100 dark:bg-slate-800/60 border-l-4 border-l-slate-400 opacity-90' 
                      : (item as any).sexo === 'Femenino'
                        ? 'bg-rose-50 dark:bg-rose-950/20 border-l-4 border-l-rose-300' 
                        : 'hover:bg-surface-muted/80',
                
                // Efecto de brillo en hover para todos los que tienen color
                ((item as any).tieneDesignacionActiva || item.eventual || (item as any).sexo === 'Femenino') 
                  ? 'hover:brightness-95 dark:hover:brightness-110' : ''
              ]">
                <td class="px-6 py-3 text-xs font-bold text-text">
                  <span
                    class="hover:text-primary transition-colors cursor-pointer hover:underline decoration-primary/30 underline-offset-2"
                    @click="$emit('view-timeline', item.id, item.name)">
                    {{ item.name }}
                  </span>
                  <span class="block text-[9px] font-normal text-text-muted/60 lowercase italic">{{ item.tipoObservador
                    }}</span>
                </td>

                <!-- Impedidos Columns -->
                <td v-if="selectedStatus === 'Impedidos'" class="px-6 py-3 text-xs text-text-muted">{{ (item as
                  any).motivo }}</td>

                <!-- Details (Navegando / Disponibles / Descanso) -->
                <td v-else class="px-6 py-3">
                  <div class="flex flex-col gap-0.5">
                    <span class="text-[10px] font-bold tabular-nums" :class="[
                      selectedStatus === 'Navegando'
                        ? ((item as any).enTierra ? 'text-success' : 'text-info')
                        : 'text-text'
                    ]">
                      <template v-if="selectedStatus === 'Navegando'">
                        {{ (item as any).enTierra ? 'En tierra' : 'En navegación' }}
                      </template>
                      <template v-else>
                        {{ formatDate((item as any).lastArrival) }}
                      </template>
                    </span>
                    <div class="flex items-center gap-1.5">
                      <span class="text-[9px] font-bold text-text-muted/60 uppercase tracking-tighter">
                        {{ (item as any).mareaCode || 'S/M' }}
                      </span>
                      <div v-if="(item as any).stageCount > 1" class="relative group/stage">
                        <span
                          class="px-1 py-0.5 bg-primary/10 text-primary text-[7px] font-black rounded border border-primary/20 leading-none cursor-help">
                          E{{ (item as any).stageCount }}
                        </span>
                        <!-- Custom Tooltip -->
                        <div
                          class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-2 py-1 bg-surface border border-border text-text text-[9px] rounded-lg opacity-0 group-hover/stage:opacity-100 transition-all pointer-events-none shadow-theme-lg z-50 whitespace-nowrap font-bold">
                          Etapa {{ (item as any).stageCount }}
                          <div
                            class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-border">
                          </div>
                          <div
                            class="absolute top-full left-1/2 -translate-x-1/2 border-[3px] border-transparent border-t-surface mt-[-1px]">
                          </div>
                        </div>
                      </div>
                      <span class="text-[9px] font-bold text-text-muted/60 uppercase tracking-tighter">
                        • {{ (item as any).vessel || (item as any).vesselName || 'Desconocido' }}
                      </span>
                    </div>
                    <span class="text-[8px] font-medium text-primary uppercase tracking-widest italic">
                      {{ (item as any).fishery || 'Pesquería N/D' }}
                    </span>
                  </div>
                </td>

                <!-- Metric Column -->
                <td v-if="selectedStatus !== 'Impedidos'"
                  class="px-6 py-3 text-xs font-black text-text text-right tabular-nums">
                  <span :class="selectedStatus === 'Navegando' ? 'text-info' : 'text-text-muted'">{{ (item as any).days
                    }}
                    d</span>
                </td>
              </tr>
              <tr v-if="currentList.length === 0">
                <td colspan="3" class="px-6 py-8 text-center text-xs text-text-muted">No hay observadores en este estado
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, markRaw, computed } from 'vue'
import { ShipIcon, UserGroupIcon, DocsIcon, HotelIcon, ChevronDownIcon } from '@/icons'
import type { WorkforceStatus } from '../services/dashboard.service'
import SearchInput from '@/components/ui/SearchInput.vue'

const props = defineProps<{
  data: WorkforceStatus | null
}>()

const selectedStatus = ref<string | null>('Navegando')
const selectedTypes = ref<string[]>(['OBSERVADOR'])
const searchQuery = ref('')
const sortBy = ref<'name' | 'days' | null>(null)
const sortOrder = ref<'asc' | 'desc'>('desc')
const selectedCategory = ref<string | null>(null)

// Available Composition for Donut Chart
const availableComposition = computed(() => {
  if (!props.data || !props.data.listDisponibles) return { series: [], total: 0 }
  
  // IMPORTANTE: Aplicar el mismo filtro de tipos que el resto del dashboard
  const list = getFilteredList(props.data.listDisponibles)
  const stats = {
    titulares: 0, // Masc Titular
    femTitular: 0,
    femEventual: 0,
    otrosEventuales: 0, // Masc Eventual
    designados: 0
  }

  list.forEach((obs: any) => {
    if (obs.tieneDesignacionActiva) {
      stats.designados++
      return
    }
    
    const isFem = obs.sexo === 'Femenino'
    const isEventual = obs.eventual === true

    if (!isEventual && !isFem) stats.titulares++
    else if (!isEventual && isFem) stats.femTitular++
    else if (isEventual && isFem) stats.femEventual++
    else if (isEventual && !isFem) stats.otrosEventuales++
  })

  return {
    series: [stats.titulares, stats.femTitular, stats.femEventual, stats.otrosEventuales, stats.designados],
    total: list.length
  }
})

const donutOptions = computed(() => ({
  chart: {
    type: 'donut',
    sparkline: { enabled: true },
    animations: { enabled: true, easing: 'easeinout', speed: 800 },
    events: {
      dataPointSelection: (event: any, chartContext: any, config: any) => {
        const category = ['Titulares', 'Fem. Titular', 'Fem. Eventual', 'Otros Eventuales', 'Designados'][config.dataPointIndex]
        if (selectedCategory.value === category) {
            selectedCategory.value = null
        } else {
            selectedCategory.value = category
            selectedStatus.value = 'Disponibles'
        }
      }
    }
  },
  colors: ['#22c55e', '#ec4899', '#fb7185', '#94a3b8', '#38bdf8'],
  labels: ['Titulares', 'Fem. Titular', 'Fem. Eventual', 'Otros Eventuales', 'Designados'],
  stroke: { show: true, width: 2, colors: ['var(--color-surface)'] },
  plotOptions: {
    pie: {
      donut: {
        size: '55%',
        background: 'transparent',
        labels: {
          show: true,
          name: { show: false },
          value: {
            show: true,
            fontSize: '14px',
            fontFamily: 'inherit',
            fontWeight: '900',
            color: 'var(--color-success-500)',
            offsetY: 5,
            formatter: (val: string) => val
          },
          total: {
            show: true,
            showAlways: true,
            label: '',
            formatter: (w: any) => {
              return w.globals.seriesTotals.reduce((a: number, b: number) => a + b, 0).toString()
            }
          }
        }
      }
    }
  },
  dataLabels: { enabled: false },
  tooltip: {
    enabled: true,
    theme: 'dark',
    y: {
      formatter: (val: number) => `${val} obs.`
    }
  },
  legend: { show: false }
}))

const toggleSort = (key: 'name' | 'days') => {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortOrder.value = key === 'name' ? 'asc' : 'desc'
  }
}

const toggleType = (type: string) => {
  const index = selectedTypes.value.indexOf(type)
  if (index > -1) {
    // Solo permitir deseleccionar si queda al menos un elemento
    if (selectedTypes.value.length > 1) {
      selectedTypes.value.splice(index, 1)
    }
  } else {
    selectedTypes.value.push(type)
  }
}

type DistributionItem = {
  label: string
  count: number | string
  value: number
  colorClass: string
  bgClass: string
  borderColorClass: string
  ringClass: string
  icon: any
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit'
  })
}

const getFilteredList = (list: any[]) => {
  return (list || []).filter(item => {
    const raw = (item.tipoObservador || item.tipo_observador || '').toString().toUpperCase();
    let itemType = 'OBSERVADOR';
    if (raw.includes('TECNIC')) itemType = 'TECNICO';
    return selectedTypes.value.includes(itemType);
  });
}

const filteredStats = computed(() => {
  if (!props.data) return { navegando: 0, descanso: 0, disponibles: 0, impedidos: 0, total: 0 }

  const navegando = getFilteredList(props.data.listNavegando).length
  const descanso = getFilteredList(props.data.listDescanso).length
  const disponibles = getFilteredList(props.data.listDisponibles).length
  const impedidos = getFilteredList(props.data.listImpedidos).length
  const total = navegando + descanso + disponibles + impedidos

  return { navegando, descanso, disponibles, impedidos, total }
})

const distributions = computed<DistributionItem[]>(() => {
  if (!props.data) return []
  const stats = filteredStats.value
  const base = stats.total || 1

  return [
    {
      label: 'Navegando',
      count: stats.navegando,
      value: Math.round((stats.navegando / base) * 100),
      colorClass: 'text-info',
      bgClass: 'bg-info',
      borderColorClass: 'border-info',
      ringClass: 'ring-info',
      icon: markRaw(ShipIcon)
    },
    {
      label: 'Descanso',
      count: stats.descanso,
      value: Math.round((stats.descanso / base) * 100),
      colorClass: 'text-primary',
      bgClass: 'bg-primary',
      borderColorClass: 'border-primary',
      ringClass: 'ring-primary',
      icon: markRaw(HotelIcon)
    },
    {
      label: 'Disponibles',
      count: stats.disponibles,
      value: Math.round((stats.disponibles / base) * 100),
      colorClass: 'text-success',
      bgClass: 'bg-success',
      borderColorClass: 'border-success',
      ringClass: 'ring-success',
      icon: markRaw(UserGroupIcon)
    },
    {
      label: 'Impedidos',
      count: stats.impedidos,
      value: Math.round((stats.impedidos / base) * 100),
      colorClass: 'text-error',
      bgClass: 'bg-error',
      borderColorClass: 'border-error',
      ringClass: 'ring-error',
      icon: markRaw(DocsIcon)
    }
  ]
})

const selectStatus = (label: string) => {
  if (selectedStatus.value === label) {
    selectedStatus.value = null
  } else {
    selectedStatus.value = label
    // Limpiar filtro de categoría si cambiamos de estado y no es Disponibles
    if (label !== 'Disponibles') {
      selectedCategory.value = null
    }
  }
}

const currentList = computed(() => {
  if (!props.data || !selectedStatus.value) return []
  let list: any[] = []
  switch (selectedStatus.value) {
    case 'Navegando': list = props.data.listNavegando; break
    case 'Descanso': list = props.data.listDescanso; break
    case 'Disponibles': list = props.data.listDisponibles; break
    case 'Impedidos': list = props.data.listImpedidos; break
    default: list = []
  }

  // 1. Filtrado por tipo (si aplica)
  list = getFilteredList(list);

  // 2. Filtrado por búsqueda
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    list = list.filter(item => {
      const name = item.name.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
      const vessel = (item.vessel || item.vesselName || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
      const marea = (item.mareaCode || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
      const fishery = (item.fishery || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

      return name.includes(q) || vessel.includes(q) || marea.includes(q) || fishery.includes(q);
    });
  }

  // 2.5 Filtrado por categoría de la dona (solo si está en Disponibles)
  if (selectedStatus.value === 'Disponibles' && selectedCategory.value) {
    list = list.filter(obs => {
      if (selectedCategory.value === 'Designados') return obs.tieneDesignacionActiva;
      if (obs.tieneDesignacionActiva) return false; // Los demás no deben ser designados

      const isFem = obs.sexo === 'Femenino';
      const isEventual = obs.eventual === true;

      if (selectedCategory.value === 'Titulares') return !isEventual && !isFem;
      if (selectedCategory.value === 'Fem. Titular') return !isEventual && isFem;
      if (selectedCategory.value === 'Fem. Eventual') return isEventual && isFem;
      if (selectedCategory.value === 'Otros Eventuales') return isEventual && !isFem;
      
      return true;
    });
  }

  // 3. Ordenamiento
  if (selectedStatus.value === 'Disponibles') {
    // Orden especial para Disponibles:
    // 1. No eventuales primero, eventuales después
    // 2. Dentro de cada grupo: Masculinos primero, Femeninos después
    // 3. Finalmente por días de inactividad descendente (comportamiento actual)
    list = [...list].sort((a, b) => {
      // Prioridad 1: Eventual (false < true)
      if (a.eventual !== b.eventual) return a.eventual ? 1 : -1;

      // Prioridad 2: Sexo (Masculino < Femenino)
      if (a.sexo !== b.sexo) return a.sexo === 'Masculino' ? -1 : 1;

      // Prioridad 3: Días de inactividad descendente
      return b.days - a.days;
    });
  } else if (sortBy.value) {
    list = [...list].sort((a, b) => {
      const key = sortBy.value as 'name' | 'days'
      const valA = a[key]
      const valB = b[key]

      if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1
      if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1
      return 0
    })
  }

  return list
})
</script>

<style scoped>
.animate-fadeIn {
  animation: fadeIn 0.3s ease-out forwards;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
