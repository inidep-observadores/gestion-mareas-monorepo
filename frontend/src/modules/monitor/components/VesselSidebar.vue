<template>
  <div
    class="flex h-full flex-col border-r border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-900 overflow-hidden"
  >
    <!-- Search Header -->
    <div class="p-4 border-b border-gray-100 dark:border-gray-800">
      <h2 class="text-xs font-black uppercase tracking-widest text-gray-400 mb-4">
        Monitor de Flota
      </h2>
      <div class="relative">
        <input
          type="text"
          placeholder="Buscar buque o marea..."
          class="w-full rounded-xl border-gray-200 bg-gray-50 px-4 py-2.5 text-sm focus:border-brand-500 focus:ring-brand-500 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-200"
          v-model="searchQuery"
        />
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="absolute right-3 top-3 h-4 w-4 text-gray-400"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
          />
        </svg>
      </div>
    </div>

    <!-- Vessel List -->
    <div class="flex-1 overflow-y-auto">
      <div
        v-for="vessel in filteredVessels"
        :key="vessel.id"
        class="border-b border-gray-50 dark:border-gray-800/50"
      >
        <button
          @click="toggleVessel(vessel.id)"
          class="flex w-full items-center justify-between p-4 transition-colors hover:bg-gray-50 dark:hover:bg-gray-800/50"
          :class="{ 'bg-brand-50/50 dark:bg-brand-500/5': expandedVessel === vessel.id }"
        >
          <div class="flex items-center gap-3">
            <div
              :class="[
                'h-2 w-2 rounded-full',
                vessel.active ? 'bg-success-500 animate-pulse' : 'bg-gray-300',
              ]"
            ></div>
            <div class="text-left">
              <div class="text-sm font-bold text-gray-800 dark:text-gray-100">
                {{ vessel.name }}
              </div>
              <div class="text-[10px] font-medium text-gray-400 uppercase tracking-tighter">
                {{ vessel.type }}
              </div>
            </div>
          </div>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4 text-gray-400 transition-transform"
            :class="{ 'rotate-180': expandedVessel === vessel.id }"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>

        <!-- Trips List -->
        <div
          v-if="expandedVessel === vessel.id"
          class="bg-gray-50/50 dark:bg-gray-900 flex flex-col"
        >
          <button
            v-for="trip in vessel.trips"
            :key="trip.id"
            @click="$emit('select-trip', { vessel, trip })"
            class="flex items-center justify-between px-6 py-3 border-l-2 border-transparent hover:border-brand-500 hover:bg-white dark:hover:bg-gray-800 transition-all text-left"
          >
            <div>
              <div
                class="text-[11px] font-black text-gray-700 dark:text-gray-300 uppercase tracking-tight"
              >
                {{ trip.id }}
              </div>
              <div class="text-[10px] text-gray-500">{{ trip.date }}</div>
            </div>
            <span
              v-if="trip.status === 'active'"
              class="text-[8px] font-black bg-blue-500 text-white px-1.5 py-0.5 rounded uppercase"
              >En curso</span
            >
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const searchQuery = ref('')
const expandedVessel = ref<number | null>(null)

const vessels = [
  {
    id: 1,
    name: 'BP ARGENTINO I',
    type: 'FRESQUERO',
    active: true,
    trips: [
      { id: 'MAR-2025-048', date: '21/12/2025 - Actual', status: 'active' },
      { id: 'MAR-2025-012', date: '10/11/2025 - 25/11/2025', status: 'finished' },
    ],
  },
  {
    id: 2,
    name: 'MAR DEL SUR',
    type: 'CONGELADOR',
    active: false,
    trips: [{ id: 'MAR-2025-045', date: '05/12/2025 - 19/12/2025', status: 'finished' }],
  },
  {
    id: 3,
    name: 'BP NIETO DE PASCUAL',
    type: 'FRESQUERO',
    active: false,
    trips: [{ id: 'MAR-2025-050', date: 'Próxima Marea', status: 'planned' }],
  },
]

const filteredVessels = computed(() => {
  if (!searchQuery.value) return vessels
  return vessels.filter((v) => v.name.toLowerCase().includes(searchQuery.value.toLowerCase()))
})

const toggleVessel = (id: number) => {
  expandedVessel.value = expandedVessel.value === id ? null : id
}

defineEmits(['select-trip'])
</script>
