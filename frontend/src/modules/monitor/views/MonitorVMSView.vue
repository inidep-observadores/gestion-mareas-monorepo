
<template>
  <AdminLayout 
    title="Mapa de Recorridos (VMS)" 
    description="Monitoreo satelital y tracking en tiempo real de la flota."
  >
    <div
      class="relative w-full overflow-hidden bg-background text-text"
      style="height: calc(100vh - 64px)"
      @dragover.prevent="dragOver = true"
      @dragleave.prevent="dragOver = false"
      @drop.prevent="handleDrop"
    >
      <!-- Drag Overlay -->
      <transition name="fade">
        <div v-if="dragOver || isUploading" class="absolute inset-0 z-[2000] bg-primary/20 backdrop-blur-sm flex items-center justify-center pointer-events-none">
           <div class="bg-surface p-8 rounded-2xl shadow-2xl flex flex-col items-center gap-4 animate-bounce-custom">
               <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-16 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                   <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
               </svg>
               <h3 class="text-xl font-bold text-text">{{ isUploading ? 'Procesando...' : 'Soltar archivo CSV aquí' }}</h3>
           </div>
        </div>
      </transition>

      <!-- THE MAP (Background) -->
      <div class="absolute inset-0">
        <MapMonitor
          class="w-full h-full"
          :points="trackPoints"
          :current-index="playerIndex"
          :active-layers="mapLayers"
          :mode="viewMode"
          :fleet-data="fleet"
          @update:mouse-coords="mouseCoords = $event"
          @select-vessel="handleVesselSelection"
        />
      </div>

      <!-- HUD LAYER (Floating Components) -->
      <div
        class="relative w-full h-full pointer-events-none z-[1000] p-6 flex flex-col justify-between"
        :style="{ '--hud-font-offset': `${fontScale}px` }"
      >
        <!-- Top Row -->
        <div class="flex justify-between items-start w-full">
          <!-- Left: Vessel Info (Only in TRACK Mode or if selected) -->
          <VesselInfoCard
            v-if="selectedVessel && viewMode === 'TRACK'"
            :vesselName="selectedVessel.name"
            :vesselMat="selectedVessel.matricula"
            :position="{ lat: currentPoint?.lat || 0, lon: currentPoint?.lon || 0 }"
            :timestamp="currentPoint?.timestamp || ''"
            :speed="currentPoint?.speed || 0"
            :course="currentPoint?.course || 0"
            :layers="mapLayers"
            @update:layer="handleLayerToggle"
          />

          <!-- Right: Control Panel (Layers & Font Size) -->
          <div class="flex flex-col gap-3 items-end pointer-events-auto">
             <div v-if="viewMode === 'TRACK'" class="mb-2">
                 <button @click="resetToFleet" class="px-3 py-1 bg-primary text-primary-fg rounded-lg text-sm font-bold shadow-lg hover:bg-primary-hover transition-colors">
                     ← Volver a Flota
                 </button>
             </div>

             <!-- Font Size Context Menu -->
             <div class="flex items-center gap-1.5 p-1.5 bg-surface/20 backdrop-blur-xl rounded-2xl border border-border/20 shadow-2xl">
              <button 
                @click="fontScale = Math.max(0, fontScale - 1)"
                class="w-7 h-7 flex items-center justify-center rounded-xl bg-surface/10 hover:bg-surface/20 text-text-muted hover:text-primary transition-all active:scale-90"
              >A-</button>
              <button 
                @click="fontScale = Math.min(4, fontScale + 1)"
                class="w-7 h-7 flex items-center justify-center rounded-xl bg-surface/10 hover:bg-surface/20 text-text-muted hover:text-primary transition-all active:scale-90"
              >A+</button>
            </div>
          </div>
        </div>

        <!-- Bottom Row -->
        <div class="flex flex-col gap-2">
          <!-- Mouse Coordinates -->
          <div class="flex items-end justify-between">
            <MouseCoordinates :coords="mouseCoords" />
          </div>

          <!-- Player Control (Only in TRACK Mode) -->
          <div v-if="viewMode === 'TRACK'" class="w-full flex justify-center pb-4 pointer-events-auto">
            <div class="w-full max-w-md">
              <TimelinePlayer
                :currentIndex="playerIndex"
                :maxIndex="trackPoints.length - 1"
                :currentTime="currentPoint?.timestamp || ''"
                :isPlaying="isPlaying"
                :speed="playbackSpeed"
                :startDate="trackPoints[0]?.timestamp.split('T')[0] || '--'"
                :endDate="trackPoints[trackPoints.length - 1]?.timestamp.split('T')[0] || '--'"
                @update:index="playerIndex = $event"
                @update:speed="handleSpeedChange"
                @toggle-play="togglePlay"
                @prev="playerIndex = Math.max(0, playerIndex - 1)"
                @next="playerIndex = Math.min(trackPoints.length - 1, playerIndex + 1)"
                @skip-start="playerIndex = 0"
                @skip-end="playerIndex = trackPoints.length - 1"
                @select-date="handleDateSelection"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'
import type { LatLng } from 'leaflet'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import MapMonitor from '../components/MapMonitor.vue'
import TimelinePlayer from '../components/TimelinePlayer.vue'
import VesselInfoCard from '../components/VesselInfoCard.vue'
import MouseCoordinates from '../components/MouseCoordinates.vue'
import { useMonitorVMS, type FleetVessel } from '../composables/useMonitorVMS'
import { toast } from 'vue-sonner'

// Composables
const { fleet, uploadFile, isUploading, getHistory } = useMonitorVMS()

// Refs
const viewMode = ref<'FLEET' | 'TRACK'>('FLEET')
const selectedVessel = ref<FleetVessel | null>(null)
const mouseCoords = ref<LatLng | null>(null)
const dragOver = ref(false)

// Track Data
const trackPoints = ref<any[]>([])
const playerIndex = ref(0)
const isPlaying = ref(false)
const playbackSpeed = ref(1)
let playbackInterval: any = null

// Display Refs
const fontScale = ref(0)
const mapLayers = ref({
  totalPoints: true,
  totalTrack: true,
  veda: false,
  isobatas: false,
})

const currentPoint = computed(() => trackPoints.value[playerIndex.value] || null)

// Methods
const handleDrop = async (e: DragEvent) => {
    dragOver.value = false
    const files = e.dataTransfer?.files
    if (files && files.length > 0) {
        const file = files[0]
        if (file.type === 'text/csv' || file.name.endsWith('.csv')) {
            const success = await uploadFile(file)
            if (success) toast.success('Archivo procesado correctamente')
            else toast.error('Error al procesar archivo')
        } else {
            toast.error('Solo archivos CSV permitidos')
        }
    }
}

const handleVesselSelection = async (vesselId: string) => {
    const vessel = fleet.value.find(v => v.id === vesselId)
    if (!vessel) return

    toast.info(`Cargando historial de ${vessel.name}...`)
    selectedVessel.value = vessel
    
    // Load history
    const history = await getHistory(vessel.id)
    if (history.length > 0) {
        trackPoints.value = history
        playerIndex.value = history.length - 1 // Start at end
        viewMode.value = 'TRACK'
    } else {
        toast.warning('No hay historial de recorrido para este buque')
    }
}

const resetToFleet = () => {
    viewMode.value = 'FLEET'
    selectedVessel.value = null
    stopPlayback()
    trackPoints.value = []
}

// Player Logic (Reused)
const togglePlay = () => {
  if (isPlaying.value) stopPlayback()
  else startPlayback()
}

const startPlayback = () => {
  if (playerIndex.value >= trackPoints.value.length - 1) {
    playerIndex.value = 0
  }
  isPlaying.value = true
  playbackInterval = setInterval(() => {
    if (playerIndex.value < trackPoints.value.length - 1) {
      playerIndex.value++
    } else {
      stopPlayback()
    }
  }, 500 / playbackSpeed.value)
}

const stopPlayback = () => {
  isPlaying.value = false
  if (playbackInterval) {
    clearInterval(playbackInterval)
    playbackInterval = null
  }
}

const handleSpeedChange = (newSpeed: number) => {
  playbackSpeed.value = newSpeed
  if (isPlaying.value) {
    stopPlayback()
    startPlayback()
  }
}

const handleDateSelection = (date: Date) => {
  const dateStr = date.toISOString().split('T')[0]
  const index = trackPoints.value.findIndex((p) => p.timestamp.startsWith(dateStr))
  if (index !== -1) playerIndex.value = index
}

const handleLayerToggle = (key: string, val: boolean) => {
  (mapLayers.value as any)[key] = val
}

onUnmounted(stopPlayback)
</script>

<style scoped>
:deep(.admin-layout-content) {
  padding: 0 !important;
  max-width: none !important;
  margin: 0 !important;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
