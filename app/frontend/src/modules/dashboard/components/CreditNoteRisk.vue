<template>
  <div class="rounded-3xl border border-border bg-surface shadow-sm relative overflow-hidden group hover:shadow-md transition-all border-l-4"
       :class="[isExpanded ? 'border-l-error' : 'border-l-error/30']">
    <!-- Header Ficha -->
    <button @click="$emit('toggle')"
      class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
      :class="{ 'border-border bg-surface-muted': isExpanded }">
      <div class="flex items-center gap-3">
        <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
          :class="[isExpanded ? 'bg-error text-white' : 'bg-error/10 text-error']">
          <WarningIcon class="w-4 h-4" />
        </span>
        <div>
          <h3 class="text-sm font-black uppercase text-text tracking-wide flex items-center gap-2">
            Riesgo de Nota de Crédito
            <span class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors" :class="[
              filteredList.length > 0
                ? 'bg-error/20 text-error'
                : 'bg-surface-muted text-text-muted'
            ]">
              {{ filteredList.length }}
            </span>
          </h3>
          <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Observadores Monotributistas</p>
        </div>
      </div>
      <ChevronDownIcon class="w-5 h-5 text-text-muted transition-transform duration-300"
        :class="{ 'rotate-180': isExpanded }" />
    </button>

    <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
      enter-to-class="max-h-[1000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="max-h-[1000px] opacity-100" leave-to-class="max-h-0 opacity-0">
      <div v-if="isExpanded" class="p-5 pt-2">
        <!-- Filtro/Busqueda Opcional -->
        <div v-if="filteredList.length > 0" class="mb-4">
          <SearchInput v-model="searchQuery" placeholder="Buscar observador o buque..." class="!w-full" />
        </div>

        <!-- Tabla -->
        <div class="flex-grow overflow-y-auto custom-scrollbar max-h-[350px]">
          <table class="w-full text-left border-collapse">
            <thead class="bg-surface sticky top-0 z-10 shadow-sm">
              <tr>
                <th @click="toggleSort('name')" class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center gap-1">
                    Observador
                    <ChevronDownIcon v-if="sortBy === 'name'" class="w-3 h-3 transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
                <th class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">
                  Marea Actual / Buque
                </th>
                <th @click="toggleSort('days')" class="px-4 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider text-right cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center justify-end gap-1">
                    Días
                    <ChevronDownIcon v-if="sortBy === 'days'" class="w-3 h-3 transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border bg-surface">
              <tr v-for="item in currentList" :key="item.id" class="transition-all duration-200 group hover:bg-error/5 border-l-2 border-transparent hover:border-l-error">
                <td class="px-4 py-3 text-xs font-bold text-text">
                  <div class="flex items-center gap-2">
                    <span class="hover:text-error transition-colors cursor-pointer hover:underline decoration-error/30 underline-offset-2" @click="$emit('view-timeline', item.id, item.name)">
                      {{ item.name }}
                    </span>
                  </div>
                  <span class="block text-[9px] font-normal text-text-muted/60 uppercase tracking-tighter mt-0.5">
                    {{ item.tipoContrato }}
                  </span>
                </td>

                <td class="px-4 py-3">
                  <div class="flex flex-col gap-0.5">
                    <span class="text-[10px] font-bold tabular-nums text-error">
                      {{ item.enTierra ? 'En tierra' : 'En navegación' }}
                    </span>
                    <div class="flex items-center gap-1.5">
                      <span class="text-[11px] font-medium text-text-muted uppercase tracking-tighter">
                        {{ item.mareaCode || 'S/M' }} • {{ item.vessel || 'Desconocido' }}
                      </span>
                      <div v-if="item.stageCount && item.stageCount > 1" class="relative group/stage">
                        <span class="px-1 py-0.5 bg-error/10 text-error text-[7px] font-black rounded border border-error/20 leading-none">
                          E{{ item.stageCount }}
                        </span>
                      </div>
                    </div>
                    <span class="text-[8px] font-medium text-error uppercase tracking-widest italic">
                      {{ item.fishery || 'Sin Pesquería' }}
                    </span>
                  </div>
                </td>

                <td class="px-4 py-3 text-xs font-black text-error text-right tabular-nums">
                  <span>{{ item.days }} d</span>
                </td>
              </tr>
              <tr v-if="currentList.length === 0 && filteredList.length > 0">
                <td colspan="3" class="px-4 py-8 text-center text-xs text-text-muted">No hay resultados para la búsqueda</td>
              </tr>
              <tr v-else-if="filteredList.length === 0">
                 <td colspan="3" class="px-4 py-12">
                   <div class="flex flex-col items-center justify-center text-xs text-text-muted gap-3">
                      <div class="p-4 rounded-full bg-surface-muted/50 text-text-muted/40">
                         <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10z"/><path d="m9 12 2 2 4-4"/>
                         </svg>
                      </div>
                      <span class="font-bold uppercase tracking-wider text-[10px]">Sin riesgos detectados</span>
                   </div>
                 </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { WarningIcon, ChevronDownIcon } from '@/icons'
import SearchInput from '@/components/ui/SearchInput.vue'
import type { WorkforceStatus } from '../services/dashboard.service'

const props = defineProps<{
  data: WorkforceStatus | null
  isExpanded: boolean
}>()

defineEmits(['view-timeline', 'toggle'])

const searchQuery = ref('')
const sortBy = ref<'name' | 'days' | null>('days')
const sortOrder = ref<'asc' | 'desc'>('desc')

const toggleSort = (key: 'name' | 'days') => {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortOrder.value = key === 'name' ? 'asc' : 'desc'
  }
}

const filteredList = computed(() => {
  if (!props.data || !props.data.listNavegando) return [];

  return props.data.listNavegando.filter(item => {
    const isMonotributista = item.tipoContrato?.toUpperCase() === 'MONOTRIBUTISTA';
    const isLessThan15Days = item.days < 15;
    
    // Pesquería Langostino O (Merluza Y Flota Altura Fresquero)
    const fisheryUpper = (item.fishery || '').toUpperCase();
    const isLangostino = fisheryUpper.includes('LANGOSTINO');
    const isMerluza = fisheryUpper.includes('MERLUZA');
    
    // Evaluamos el código de flota que añadimos en backend
    const fleetCode = item.fleetCode || '';
    const isFresqueroAltura = fleetCode === 'ALTURA_FRESQUERO';

    const validFishery = isLangostino || (isMerluza && isFresqueroAltura);

    return isMonotributista && isLessThan15Days && validFishery;
  });
})

const currentList = computed(() => {
  let result = [...filteredList.value];
  
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase();
    result = result.filter(item => 
      item.name.toLowerCase().includes(q) || 
      (item.vessel || '').toLowerCase().includes(q) ||
      (item.mareaCode || '').toLowerCase().includes(q)
    );
  }

  if (sortBy.value) {
    result.sort((a, b) => {
      let valA, valB;
      if (sortBy.value === 'name') {
        valA = a.name.toLowerCase();
        valB = b.name.toLowerCase();
      } else {
        valA = a.days;
        valB = b.days;
      }
      if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1;
      if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1;
      return 0;
    });
  }

  return result;
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
  background: var(--color-surface-muted);
  border-radius: 10px;
}
</style>
