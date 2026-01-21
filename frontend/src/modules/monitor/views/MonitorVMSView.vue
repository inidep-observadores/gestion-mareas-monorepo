<template>
  <AdminLayout 
    title="Mapa de Recorridos (VMS)" 
    description="Monitoreo satelital y tracking en tiempo real de la flota."
  >
    <div
      class="relative w-full overflow-hidden bg-background text-text"
      style="height: calc(100vh - 64px)"
    >
      <!-- THE MAP (Background) -->
      <div class="absolute inset-0">
        <MapMonitor
          class="w-full h-full"
          :points="trackPoints"
          :currentIndex="playerIndex"
          :activeLayers="mapLayers"
          @update:mouse-coords="mouseCoords = $event"
        />
      </div>

      <!-- HUD LAYER (Floating Components) -->
      <div
        class="relative w-full h-full pointer-events-none z-[1000] p-6 flex flex-col justify-between"
        :style="{ '--hud-font-offset': `${fontScale}px` }"
      >
        <!-- Top Row -->
        <div class="flex justify-between items-start w-full">
          <!-- Left: Vessel Info -->
          <VesselInfoCard
            v-if="selectedVessel"
            :vesselName="selectedVessel.name"
            :vesselMat="'6508'"
            :position="{ lat: currentPoint?.lat || 0, lon: currentPoint?.lon || 0 }"
            :timestamp="currentPoint?.timestamp || ''"
            :speed="currentPoint?.speed || 0"
            :course="currentPoint?.course || 0"
            :layers="mapLayers"
            @update:layer="handleLayerToggle"
          />

          <!-- Right: Control Panel (Layers & Font Size) -->
          <div class="flex flex-col gap-3 items-end">
            <TripStagesCard
              :stages="mockStages"
              :totalDays="36"
              @select-stage="handleStageSelection"
            />
            
            <!-- Font Size Context Menu -->
            <div class="pointer-events-auto flex items-center gap-1.5 p-1.5 bg-surface/20 backdrop-blur-xl rounded-2xl border border-border/20 shadow-2xl">
              <button 
                @click="fontScale = Math.max(0, fontScale - 1)"
                class="w-7 h-7 flex items-center justify-center rounded-xl bg-surface/10 hover:bg-surface/20 text-text-muted hover:text-primary transition-all active:scale-90"
                title="Reducir fuente"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                  <path d="M5 12h14"/>
                </svg>
              </button>
              <div class="px-2 text-[10px] font-black text-text-muted uppercase tracking-widest select-none">
                A<span class="text-primary">±</span>
              </div>
              <button 
                @click="fontScale = Math.min(4, fontScale + 1)"
                class="w-7 h-7 flex items-center justify-center rounded-xl bg-surface/10 hover:bg-surface/20 text-text-muted hover:text-primary transition-all active:scale-90"
                title="Aumentar fuente"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                  <path d="M12 5v14M5 12h14"/>
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Bottom Row -->
        <div class="flex flex-col gap-2">
          <!-- Mouse Coordinates -->
          <div class="flex items-end justify-between">
            <MouseCoordinates :coords="mouseCoords" />
          </div>

          <!-- Player Control -->
          <div class="w-full flex justify-center pb-4">
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
import TripStagesCard, { type TripStage } from '../components/TripStagesCard.vue'
import MouseCoordinates from '../components/MouseCoordinates.vue'
import { generateMockTrack, type TrackingPoint } from '../data/mockTracking'

interface Trip {
  id: string
  date: string
  status: string
}

interface Vessel {
  id: number
  name: string
  type: string
  active: boolean
  trips: Trip[]
}

const selectedVessel = ref<Vessel>({
  id: 1,
  name: 'BP VICTORIA',
  type: 'Pesquero',
  active: true,
  trips: [],
})

const fontScale = ref(0)
const trackPoints = ref<TrackingPoint[]>(generateMockTrack(new Date('2025-11-02T21:11:00Z')))
const playerIndex = ref(trackPoints.value.length - 1)
const isPlaying = ref(false)
const playbackSpeed = ref(1)
const mapLayers = ref({
  totalPoints: true,
  totalTrack: true,
  veda: false,
  isobatas: false,
})
const mouseCoords = ref<LatLng | null>(null)
let playbackInterval: ReturnType<typeof setInterval> | null = null

const currentPoint = computed(() => trackPoints.value[playerIndex.value] || null)

const mockStages: TripStage[] = [
  {
    id: '1',
    startDate: '2025-11-03T20:27:00Z',
    endDate: '2025-11-12T02:14:00Z',
    durationDays: 10,
    color: 'var(--color-warning)',
  },
  {
    id: '2',
    startDate: '2025-11-14T10:30:00Z',
    endDate: '2025-11-21T13:33:00Z',
    durationDays: 8,
    color: 'var(--color-info)',
  },
  {
    id: '3',
    startDate: '2025-11-23T12:33:00Z',
    endDate: '2025-12-01T16:21:00Z',
    durationDays: 9,
    color: 'var(--color-success)',
  },
  {
    id: '4',
    startDate: '2025-12-03T19:07:00Z',
    endDate: '2025-12-11T15:39:00Z',
    durationDays: 9,
    color: 'var(--color-error)',
  },
]

const handleLayerToggle = (key: string, val: boolean) => {
  ;(mapLayers.value as any)[key] = val
}

const handleStageSelection = (stage: TripStage) => {
  // Logic to jump to stage start
  const index = trackPoints.value.findIndex((p) => p.timestamp >= stage.startDate)
  if (index !== -1) playerIndex.value = index
}

const handleDateSelection = (date: Date) => {
  const dateStr = date.toISOString().split('T')[0]
  const index = trackPoints.value.findIndex((p) => p.timestamp.startsWith(dateStr))
  if (index !== -1) playerIndex.value = index
}

const togglePlay = () => {
  if (isPlaying.value) {
    stopPlayback()
  } else {
    startPlayback()
  }
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

onUnmounted(stopPlayback)
</script>

<style scoped>
/* Override AdminLayout padding to allow full-screen map */
:deep(.admin-layout-content) {
  padding: 0 !important;
  max-width: none !important;
  margin: 0 !important;
}
</style>
