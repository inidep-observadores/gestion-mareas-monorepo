<template>
  <div class="pointer-events-none absolute inset-0 z-[2000] overflow-hidden">
    
    <!-- Map Type FAB (Top Right) - NEW -->
    <div class="absolute top-4 right-4 pointer-events-auto">
      <button @click="openMapBase = true"
        class="w-10 h-10 rounded-xl bg-surface/90 backdrop-blur-md shadow-lg border border-border/20 flex items-center justify-center text-text-muted hover:text-primary active:scale-95 transition-all">
        <!-- Map Icon -->
        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"></polygon>
          <line x1="8" y1="2" x2="8" y2="18"></line>
          <line x1="16" y1="6" x2="16" y2="22"></line>
        </svg>
      </button>
    </div>

    <!-- FABs Container (Bottom Right) -->
    <div class="absolute bottom-6 right-6 flex flex-col gap-4 pointer-events-auto items-end">
      
      <!-- Layers FAB (Restored Position) -->
      <button @click="openLayers = true"
        class="w-12 h-12 rounded-full bg-surface shadow-lg border border-primary/20 flex items-center justify-center text-primary active:scale-95 transition-all">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
        </svg>
      </button>

      <!-- Fleet FAB -->
      <button @click="openFleet = true"
        class="w-12 h-12 rounded-full bg-primary shadow-xl shadow-primary/30 flex items-center justify-center text-primary-fg active:scale-95 transition-all relative">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M3 3h7v7H3zM14 3h7v7h-7zM14 14h7v7h-7zM3 14h7v7H3z"/>
        </svg>
        <!-- Badge for active count if needed -->
        <span v-if="vessels.length > 0" class="absolute -top-1 -right-1 bg-warning text-warning-fg text-[10px] font-black w-5 h-5 flex items-center justify-center rounded-full border-2 border-surface">
          {{ vessels.length }}
        </span>
      </button>
    </div>

    <!-- Backdrop -->
    <Transition name="fade">
      <div v-if="openLayers || openFleet || openMapBase" 
           class="absolute inset-0 bg-black/40 backdrop-blur-sm pointer-events-auto"
           @click="closeAll"></div>
    </Transition>

    <!-- Map Base Drawer (NEW) -->
    <Transition name="slide-up">
      <div v-if="openMapBase" class="absolute bottom-0 left-0 w-full bg-surface rounded-t-3xl shadow-2xl pointer-events-auto flex flex-col max-h-[50vh]">
        <div class="p-4 border-b border-border/10 flex items-center justify-between">
          <h3 class="text-sm font-black text-text uppercase tracking-widest">Tipo de Mapa</h3>
          <button @click="openMapBase = false" class="p-2 text-text-muted hover:text-text">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        <div class="p-4 grid grid-cols-2 gap-3 overflow-y-auto">
           <button v-for="layer in baseLayers" :key="layer.id"
             @click="selectBase(layer.id)"
             class="flex flex-col items-center gap-2 p-3 rounded-xl border border-border/10 bg-surface-muted/30 hover:bg-primary/5 active:scale-95 transition-all">
             <span class="text-xs font-bold text-text">{{ layer.name }}</span>
           </button>
        </div>
      </div>
    </Transition>

    <!-- Map Base Drawer -->
    <Transition name="slide-up">
      <div v-if="openMapBase" class="absolute bottom-0 left-0 w-full bg-surface rounded-t-3xl shadow-2xl pointer-events-auto flex flex-col max-h-[50vh]">
        <div class="p-4 border-b border-border/10 flex items-center justify-between">
          <h3 class="text-sm font-black text-text uppercase tracking-widest">Tipo de Mapa</h3>
          <button @click="openMapBase = false" class="p-2 text-text-muted hover:text-text">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        <div class="p-4 grid grid-cols-2 gap-3 overflow-y-auto">
           <button v-for="layer in baseLayers" :key="layer.id"
             @click="selectBase(layer.id)"
             class="flex flex-col items-center gap-2 p-3 rounded-xl border border-border/10 bg-surface-muted/30 hover:bg-primary/5 active:scale-95 transition-all">
             <span class="text-xs font-bold text-text">{{ layer.name }}</span>
           </button>
        </div>
      </div>
    </Transition>

    <!-- Layers Drawer -->
    <Transition name="slide-up">
      <div v-if="openLayers" class="absolute bottom-0 left-0 w-full bg-surface rounded-t-3xl shadow-2xl pointer-events-auto flex flex-col max-h-[70vh]">
        <div class="p-4 border-b border-border/10 flex items-center justify-between">
          <h3 class="text-sm font-black text-text uppercase tracking-widest">Capas</h3>
          <button @click="openLayers = false" class="p-2 text-text-muted hover:text-text">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        <div class="p-4 space-y-3 overflow-y-auto">
          <div v-for="(val, key) in mapLayers" :key="key"
            class="flex items-center justify-between p-3 rounded-xl bg-surface-muted/30 border border-border/10">
             <div class="flex items-center gap-3">
                <div class="w-2 h-2 rounded-full transition-all duration-500"
                  :class="val ? 'bg-primary shadow-[0_0_8px_rgba(var(--color-primary-rgb),0.5)]' : 'bg-text-muted/20'">
                </div>
                <span class="text-xs font-bold text-text-muted uppercase tracking-wider">{{ formatKey(key) }}</span>
              </div>
              <BaseSwitch :modelValue="val" @update:modelValue="$emit('update:layer', key, $event)" />
          </div>
        </div>
      </div>
    </Transition>

    <!-- Fleet Drawer -->
    <Transition name="slide-up">
       <div v-if="openFleet" class="absolute bottom-0 left-0 w-full bg-surface rounded-t-3xl shadow-2xl pointer-events-auto flex flex-col max-h-[80vh]">
        <div class="p-4 border-b border-border/10 flex items-center justify-between">
          <h3 class="text-sm font-black text-text uppercase tracking-widest">Flota Activa</h3>
           <button @click="openFleet = false" class="p-2 text-text-muted hover:text-text">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        
        <!-- Search Area -->
        <div class="px-4 py-3 bg-surface/5 border-b border-border/5">
          <SearchInput v-model="searchQuery" placeholder="Marea, buque u observador..." size="sm" />
        </div>
        
        <div class="p-2 flex-1 overflow-y-auto">
           <div v-if="filteredVessels.length === 0" class="p-8 text-center text-text-muted text-sm">
             <span v-if="searchQuery">No hay coincidencias</span>
             <span v-else>No hay buques activos</span>
           </div>
           <div class="space-y-2 p-2">
             <div v-for="vessel in filteredVessels" :key="vessel.id"
                @click="selectVessel(vessel.id)"
                class="p-3 rounded-xl border transition-all flex items-center gap-4 active:scale-95"
                :class="selectedId === vessel.id 
                  ? 'bg-primary/10 border-primary/30' 
                  : 'bg-surface hover:bg-surface-muted border-border/10'">
                
                <!-- Vessel Icon -->
                <div class="w-10 h-10 rounded-full flex items-center justify-center shadow-sm"
                     :style="{ backgroundColor: vessel.color + '20', color: vessel.color }">
                   <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M12 2L2 22h20L12 2z"/> <!-- Simple placeholder ship -->
                   </svg>
                </div>

                <!-- Info -->
                <div class="flex-1 min-w-0">
                  <div class="flex items-center justify-between">
                    <span class="text-sm font-black text-text uppercase truncate">{{ vessel.name }}</span>
                    <span v-if="vessel.mareaCode" class="text-[10px] font-bold bg-surface-muted px-2 py-0.5 rounded text-text-muted">{{ vessel.mareaCode }}</span>
                  </div>
                  <div class="text-xs text-text-muted mt-0.5 flex gap-2">
                    <span class="truncate">{{ vessel.matricula }}</span>
                    <span v-if="vessel.observer" class="text-primary font-bold">• {{ vessel.observer }}</span>
                  </div>
                </div>

                <!-- Chevron -->
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-text-muted/50" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M9 18l6-6-6-6"/>
                </svg>
             </div>
           </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import BaseSwitch from '@/components/ui/BaseSwitch.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import { BASE_LAYERS } from '@/components/common/map-layers'
import type { MonitorVessel } from './VesselListSidebar.vue'

const props = defineProps<{
  mapLayers: Record<string, boolean>
  vessels: MonitorVessel[]
  selectedId: string | null
}>()

const emit = defineEmits<{
  (e: 'update:layer', key: string, val: boolean): void
  (e: 'select-vessel', id: string): void
  (e: 'change-base', id: string): void
}>()

const openLayers = ref(false)
const openFleet = ref(false)
const openMapBase = ref(false)
const searchQuery = ref('')

const filteredVessels = computed(() => {
  let list = [...props.vessels]
  
  const q = searchQuery.value.toLowerCase().trim()
  if (q) {
    list = list.filter(v =>
      v.name.toLowerCase().includes(q) ||
      v.mareaCode.toLowerCase().includes(q) ||
      v.observer.toLowerCase().includes(q)
    )
  }
  
  // Sort by Year ASC, then Number ASC based on mareaCode (Format: TYPE-NUM-YY)
  return list.sort((a, b) => {
    const partsA = a.mareaCode.split('-')
    const partsB = b.mareaCode.split('-')
    
    const yearA = parseInt(partsA[2]) || 0
    const yearB = parseInt(partsB[2]) || 0
    
    if (yearA !== yearB) return yearA - yearB
    
    const numA = parseInt(partsA[1]) || 0
    const numB = parseInt(partsB[1]) || 0
    
    return numA - numB
  })
})

const baseLayers = BASE_LAYERS

const closeAll = () => {
  openLayers.value = false
  openFleet.value = false
  openMapBase.value = false
}

const selectVessel = (id: string) => {
  emit('select-vessel', id)
  openFleet.value = false
}

const selectBase = (id: string) => {
  emit('change-base', id)
  openMapBase.value = false
}

const formatKey = (key: string) => {
  const labels: any = {
    veda: 'Zonas de Veda',
    vieira: 'Áreas de Vieira',
    centolla: 'Áreas de Centolla',
    points: 'Puntos de Reporte',
    showAllVessels: 'Ver toda la flota',
    showVesselNames: 'Mostrar identificación',
  }
  return labels[key] || key
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(100%);
}
</style>
