<template>
  <div class="relative group">
    <!-- Botón Principal: Estilo mimetizado con Leaflet Control Bar del Monitor -->
    <div class="leaflet-bar !border-none shadow-[0_4px_12px_rgba(0,0,0,0.3)]">
      <button
        type="button"
        @click="isOpen = !isOpen"
        class="flex h-[30px] w-[30px] items-center justify-center bg-surface/50 text-text transition-all hover:bg-primary hover:text-white backdrop-blur-[20px] border border-text/10"
        style="border-radius: 2px;"
        :class="{ '!bg-primary !text-white': isOpen }"
        title="Capas del mapa"
      >
        <LayersIcon class="h-4 w-4" />
      </button>
    </div>

    <!-- Panel de Selección (Popover) envuelto en HudCard -->
    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="translate-y-1 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-1 opacity-0"
    >
      <HudCard
        v-if="isOpen"
        customClass="absolute bottom-full right-0 mb-3 w-64 !p-0 divide-y divide-text/5 overflow-hidden shadow-2xl"
      >
        <!-- Sección Mapa Base -->
        <div class="p-4">
          <h3 class="mb-3 text-[10px] font-black uppercase tracking-widest text-text-muted/60">
            Mapa Base (Argenmap)
          </h3>
          <div class="grid grid-cols-2 gap-2">
            <button
              v-for="layer in baseLayers"
              :key="layer.id"
              type="button"
              @click="selectBase(layer.id)"
              class="group relative flex flex-col items-center gap-2 rounded-lg border p-2 transition-all"
              :class="[
                currentBaseId === layer.id
                  ? 'border-primary bg-primary/10 text-primary'
                  : 'border-transparent bg-text/5 text-text-muted hover:bg-text/10'
              ]"
            >
              <span class="text-[11px] font-bold">{{ layer.name }}</span>
              <div
                v-if="currentBaseId === layer.id"
                class="absolute -right-1 -top-1 flex h-4 w-4 items-center justify-center rounded-full bg-primary text-[8px] text-white"
              >
                ✓
              </div>
            </button>
          </div>
        </div>

        <!-- Sección Overlays (Solo si existen) -->
        <div v-if="overlayLayers.length > 0" class="p-4">
          <h3 class="mb-3 text-[10px] font-black uppercase tracking-widest text-text-muted/60">
            Capas Superpuestas
          </h3>
          <div class="space-y-2">
            <label
              v-for="layer in overlayLayers"
              :key="layer.id"
              class="flex cursor-pointer items-center justify-between rounded-lg bg-text/5 p-3 transition-colors hover:bg-text/10"
            >
              <span class="text-[12px] font-medium text-text">{{ layer.name }}</span>
              <input
                type="checkbox"
                :checked="activeOverlayIds.includes(layer.id)"
                @change="$emit('toggle-overlay', layer.id)"
                class="h-4 w-4 rounded border-text/20 bg-transparent text-primary focus:ring-primary"
              />
            </label>
          </div>
        </div>

        <!-- Sección Visualización (Retícula) -->
        <div class="p-4">
          <h3 class="mb-3 text-[10px] font-black uppercase tracking-widest text-text-muted/60">
            Visualización
          </h3>
          <div class="space-y-2">
            <label class="flex cursor-pointer items-center justify-between rounded-lg bg-text/5 p-3 transition-colors hover:bg-text/10">
              <span class="text-[12px] font-medium text-text">Red de coordenadas</span>
              <input
                type="checkbox"
                :checked="showGraticule"
                @change="$emit('update:show-graticule', !showGraticule)"
                class="h-4 w-4 rounded border-text/20 bg-transparent text-primary focus:ring-primary"
              />
            </label>
          </div>
        </div>
      </HudCard>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { LayersIcon } from '@/icons'
import HudCard from '@/modules/monitor/components/HudCard.vue'
import type { MapLayer } from './map-layers'

const props = defineProps<{
  baseLayers: MapLayer[]
  overlayLayers: MapLayer[]
  currentBaseId: string
  activeOverlayIds: string[]
  showGraticule: boolean
}>()

const emit = defineEmits<{
  (e: 'change-base', id: string): void
  (e: 'toggle-overlay', id: string): void
  (e: 'update:show-graticule', value: boolean): void
}>()

const isOpen = ref(false)

const selectBase = (id: string) => {
  emit('change-base', id)
}

// Cerrar al hacer clic fuera
const handleClickOutside = (event: MouseEvent) => {
  const target = event.target as HTMLElement
  if (isOpen.value && !target.closest('.group')) {
    isOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>
