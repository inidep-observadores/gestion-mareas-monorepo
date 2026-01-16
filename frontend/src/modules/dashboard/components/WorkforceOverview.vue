<template>
  <div
    class="rounded-3xl border border-border bg-surface p-5 shadow-sm border-l-4 border-l-primary flex flex-col"
  >
    <div class="flex items-center gap-3 mb-6">
       <UserGroupIcon class="w-6 h-6 text-primary" />
       <div>
          <h2 class="text-sm font-black text-text uppercase tracking-widest leading-tight">
            Estado del Personal
          </h2>
          <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Distribución operativa de observadores</p>
       </div>
    </div>
    
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4" :class="[selectedStatus ? 'mb-8' : '']">
      <div
        v-for="status in distributions"
        :key="status.label"
        @click="selectStatus(status.label)"
        class="group relative flex flex-col items-center p-4 rounded-2xl bg-surface-muted/50 border border-border hover:bg-surface hover:shadow-xl hover:border-primary/30 transition-all duration-300 cursor-pointer"
        :class="[selectedStatus === status.label ? `ring-2 ${status.ringClass} bg-surface` : '']"
      >
        <!-- Naked Icon (Better Symmetry) -->
        <div class="mb-3 transition-transform duration-300 group-hover:scale-110 group-hover:-translate-y-1">
          <component :is="status.icon" class="w-6 h-6" :class="status.colorClass" />
        </div>

        <div class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 text-center transition-colors group-hover:text-text">
          {{ status.label }}
        </div>

        <div class="flex flex-col items-center gap-0.5 mb-3">
          <span class="text-2xl font-black tabular-nums transition-colors" :class="status.colorClass">
            {{ status.count }}
          </span>
          <span class="text-[11px] font-bold text-text-muted tabular-nums">
            ({{ status.value }}%)
          </span>
        </div>

        <!-- Progress Indicator -->
        <div class="w-full mt-auto">
          <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
            <div
              class="h-full rounded-full transition-all duration-1000 ease-out"
              :class="status.bgClass"
              :style="{ width: status.value + '%' }"
            ></div>
          </div>
        </div>
        <!-- Active Indicator Arrow -->
         <div v-if="selectedStatus === status.label" class="absolute -bottom-[10px] left-1/2 -translate-x-1/2 w-4 h-4 bg-surface border-r-2 border-b-2 rotate-45 z-10" :class="status.borderColorClass"></div>
      </div>
    </div>

    <!-- Detailed List Section -->
    <div v-if="selectedStatus" class="animate-fadeIn flex-grow flex flex-col min-h-0">
       <div class="rounded-2xl border border-border overflow-hidden flex flex-col flex-grow">
          <div class="bg-surface-muted px-6 py-3 border-b border-border flex justify-between items-center shrink-0">
             <h3 class="text-xs font-black text-text-muted uppercase tracking-widest">Detalle: {{ selectedStatus }}</h3>
             <button @click="selectedStatus = null" class="text-text-muted hover:text-text">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
             </button>
          </div>
          
          <div class="flex-grow overflow-y-auto no-scrollbar min-h-0">
             <table class="w-full text-left border-collapse">
                <thead class="bg-surface sticky top-0 z-10 shadow-sm">
                   <tr>
                      <th class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">Observador</th>
                      <th v-if="selectedStatus === 'Navegando'" class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">Buque</th>
                      <th v-if="selectedStatus === 'Impedidos'" class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">Motivo</th>
                      <th v-else class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider text-right">
                         {{ selectedStatus === 'Navegando' ? 'Días Navegados' : 'Días Inactivo' }}
                      </th>
                   </tr>
                </thead>
                <tbody class="divide-y divide-border bg-surface">
                   <tr v-for="item in currentList" :key="item.id" class="hover:bg-surface-muted/50 transition-colors">
                      <td class="px-6 py-3 text-xs font-bold text-text">{{ item.name }}</td>
                      
                      <!-- Navegando Columns -->
                      <td v-if="selectedStatus === 'Navegando'" class="px-6 py-3 text-xs text-text-muted">{{ (item as any).vessel }}</td>
                      
                      <!-- Impedidos Columns -->
                      <td v-if="selectedStatus === 'Impedidos'" class="px-6 py-3 text-xs text-text-muted">{{ (item as any).motivo }}</td>
                      
                      <!-- Days Column (Shared) -->
                      <td v-else class="px-6 py-3 text-xs font-bold text-text-muted text-right tabular-nums">
                         {{ (item as any).days }} días
                         <span class="block text-[9px] font-normal text-text-muted/60">Desde: {{ formatDate((item as any).lastArrival || (item as any).startDate) }}</span>
                      </td>
                   </tr>
                   <tr v-if="currentList.length === 0">
                      <td colspan="3" class="px-6 py-8 text-center text-xs text-text-muted">No hay observadores en este estado</td>
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
      colorClass: 'text-info',
      bgClass: 'bg-info',
      borderColorClass: 'border-info',
      ringClass: 'ring-info',
      icon: markRaw(ShipIcon)
    },
    {
      label: 'Descanso',
      count: data.descanso,
      value: Math.round((data.descanso / base) * 100),
      colorClass: 'text-primary',
      bgClass: 'bg-primary',
      borderColorClass: 'border-primary',
      ringClass: 'ring-primary',
      icon: markRaw(HotelIcon)
    },
    {
      label: 'Disponibles',
      count: data.disponibles,
      value: Math.round((data.disponibles / base) * 100),
      colorClass: 'text-success',
      bgClass: 'bg-success',
      borderColorClass: 'border-success',
      ringClass: 'ring-success',
      icon: markRaw(UserGroupIcon)
    },
    {
      label: 'Impedidos',
      count: data.impedidos,
      value: Math.round((data.impedidos / base) * 100),
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
