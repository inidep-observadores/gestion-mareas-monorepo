<template>
  <div
    class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 border-l-4 border-l-indigo-500"
  >
    <div class="flex items-center gap-3 mb-8">
       <UserGroupIcon class="w-6 h-6 text-indigo-500" />
       <div>
          <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest leading-tight">
            Estado del Personal
          </h2>
          <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Distribución operativa de observadores</p>
       </div>
    </div>
    
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <div
        v-for="status in distributions"
        :key="status.label"
        @click="selectStatus(status.label)"
        class="group relative flex flex-col items-center p-6 rounded-2xl bg-gray-50/50 dark:bg-gray-800/40 border border-gray-100 dark:border-gray-700 hover:bg-white dark:hover:bg-gray-800 hover:shadow-xl hover:border-indigo-100 dark:hover:border-indigo-800/50 transition-all duration-300 cursor-pointer"
        :class="[selectedStatus === status.label ? `ring-2 ${status.ringClass} bg-white dark:bg-gray-800` : '']"
      >
        <!-- Naked Icon (Better Symmetry) -->
        <div class="mb-5 transition-transform duration-300 group-hover:scale-110 group-hover:-translate-y-1">
          <component :is="status.icon" class="w-8 h-8" :class="status.colorClass" />
        </div>

        <div class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4 text-center transition-colors group-hover:text-gray-500">
          {{ status.label }}
        </div>

        <div class="flex flex-col items-center gap-0.5 mb-5">
          <span class="text-3xl font-black tabular-nums transition-colors" :class="status.colorClass">
            {{ status.count }}
          </span>
          <span class="text-[11px] font-bold text-gray-400 tabular-nums">
            ({{ status.value }}%)
          </span>
        </div>

        <!-- Progress Indicator -->
        <div class="w-full mt-auto">
          <div class="h-1.5 w-full bg-gray-100 dark:bg-gray-700/50 rounded-full overflow-hidden">
            <div
              class="h-full rounded-full transition-all duration-1000 ease-out"
              :class="status.bgClass"
              :style="{ width: status.value + '%' }"
            ></div>
          </div>
        </div>
        <!-- Active Indicator Arrow -->
         <div v-if="selectedStatus === status.label" class="absolute -bottom-[10px] left-1/2 -translate-x-1/2 w-4 h-4 bg-white dark:bg-gray-800 border-r-2 border-b-2 rotate-45 z-10" :class="status.borderColorClass"></div>
      </div>
    </div>

    <!-- Detailed List Section -->
    <div v-if="selectedStatus" class="animate-fadeIn">
       <div class="rounded-2xl border border-gray-100 dark:border-gray-800 overflow-hidden">
          <div class="bg-gray-50 dark:bg-gray-800/50 px-6 py-3 border-b border-gray-100 dark:border-gray-800 flex justify-between items-center">
             <h3 class="text-xs font-black text-gray-500 uppercase tracking-widest">Detalle: {{ selectedStatus }}</h3>
             <button @click="selectedStatus = null" class="text-gray-400 hover:text-gray-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
             </button>
          </div>
          
          <div class="max-h-[300px] overflow-y-auto">
             <table class="w-full text-left border-collapse">
                <thead class="bg-white dark:bg-gray-900 sticky top-0 z-10 shadow-sm">
                   <tr>
                      <th class="px-6 py-3 text-[10px] font-black uppercase text-gray-400 tracking-wider">Observador</th>
                      <th v-if="selectedStatus === 'Navegando'" class="px-6 py-3 text-[10px] font-black uppercase text-gray-400 tracking-wider">Buque</th>
                      <th v-if="selectedStatus === 'Impedidos'" class="px-6 py-3 text-[10px] font-black uppercase text-gray-400 tracking-wider">Motivo</th>
                      <th v-else class="px-6 py-3 text-[10px] font-black uppercase text-gray-400 tracking-wider text-right">
                         {{ selectedStatus === 'Navegando' ? 'Días Navegados' : 'Días Inactivo' }}
                      </th>
                   </tr>
                </thead>
                <tbody class="divide-y divide-gray-50 dark:divide-gray-800 bg-white dark:bg-gray-900">
                   <tr v-for="item in currentList" :key="item.id" class="hover:bg-gray-50/50 dark:hover:bg-gray-800/30 transition-colors">
                      <td class="px-6 py-3 text-xs font-bold text-gray-700 dark:text-gray-300">{{ item.name }}</td>
                      
                      <!-- Navegando Columns -->
                      <td v-if="selectedStatus === 'Navegando'" class="px-6 py-3 text-xs text-gray-500">{{ (item as any).vessel }}</td>
                      
                      <!-- Impedidos Columns -->
                      <td v-if="selectedStatus === 'Impedidos'" class="px-6 py-3 text-xs text-gray-500">{{ (item as any).motivo }}</td>
                      
                      <!-- Days Column (Shared) -->
                      <td v-else class="px-6 py-3 text-xs font-bold text-gray-500 text-right tabular-nums">
                         {{ (item as any).days }} días
                         <span class="block text-[9px] font-normal text-gray-400">Desde: {{ formatDate((item as any).lastArrival || (item as any).startDate) }}</span>
                      </td>
                   </tr>
                   <tr v-if="currentList.length === 0">
                      <td colspan="3" class="px-6 py-8 text-center text-xs text-gray-400">No hay observadores en este estado</td>
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
import { ShipIcon, UserGroupIcon, DocsIcon, HotelIcon } from '@/icons'
import type { WorkforceStatus } from '../services/dashboard.service'

const props = defineProps<{
  data: WorkforceStatus | null
}>()

const selectedStatus = ref<string | null>(null)

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

const distributions = computed<DistributionItem[]>(() => {
  if (!props.data) return []
  const data = props.data
  const base = data.totalActivos || 1

  return [
    {
      label: 'Navegando',
      count: data.navegando,
      value: Math.round((data.navegando / base) * 100),
      colorClass: 'text-blue-500',
      bgClass: 'bg-blue-500',
      borderColorClass: 'border-blue-500',
      ringClass: 'ring-blue-500',
      icon: markRaw(ShipIcon)
    },
    {
      label: 'Descanso',
      count: data.descanso,
      value: Math.round((data.descanso / base) * 100),
      colorClass: 'text-indigo-500',
      bgClass: 'bg-indigo-500',
      borderColorClass: 'border-indigo-500',
      ringClass: 'ring-indigo-500',
      icon: markRaw(HotelIcon)
    },
    {
      label: 'Disponibles',
      count: data.disponibles,
      value: Math.round((data.disponibles / base) * 100),
      colorClass: 'text-emerald-500',
      bgClass: 'bg-emerald-500',
      borderColorClass: 'border-emerald-500',
      ringClass: 'ring-emerald-500',
      icon: markRaw(UserGroupIcon)
    },
    {
      label: 'Impedidos',
      count: data.impedidos,
      value: Math.round((data.impedidos / base) * 100),
      colorClass: 'text-rose-500',
      bgClass: 'bg-rose-500',
      borderColorClass: 'border-rose-500',
      ringClass: 'ring-rose-500',
      icon: markRaw(DocsIcon)
    }
  ]
})

const selectStatus = (label: string) => {
   if (selectedStatus.value === label) {
      selectedStatus.value = null
   } else {
      selectedStatus.value = label
   }
}

const currentList = computed(() => {
   if (!props.data || !selectedStatus.value) return []
   switch (selectedStatus.value) {
      case 'Navegando': return props.data.listNavegando
      case 'Descanso': return props.data.listDescanso
      case 'Disponibles': return props.data.listDisponibles
      case 'Impedidos': return props.data.listImpedidos
      default: return []
   }
})
</script>

<style scoped>
.animate-fadeIn {
   animation: fadeIn 0.3s ease-out forwards;
}
@keyframes fadeIn {
   from { opacity: 0; transform: translateY(-10px); }
   to { opacity: 1; transform: translateY(0); }
}
</style>
