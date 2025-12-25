<template>
  <AdminLayout>
    <div class="relative w-full overflow-hidden bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100" style="height: calc(100vh - 64px)">
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
      <div class="relative w-full h-full pointer-events-none z-[1000] p-6 flex flex-col justify-between">
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

          <!-- Right: Trip Stages -->
          <TripStagesCard
            :stages="mockStages"
            :totalDays="36"
            @select-stage="handleStageSelection"
          />
        </div>

        <!-- Bottom Row -->
        <div class="flex flex-col gap-4">
          <!-- Mouse Coordinates -->
          <div class="flex items-end justify-between">
            <MouseCoordinates :coords="mouseCoords" />
            
            <div class="flex items-center gap-4">
              <!-- Search/Filter (Optional placeholder like in image) -->
              <button class="pointer-events-auto p-2.5 bg-white/70 dark:bg-gray-900/70 backdrop-blur-xl rounded-xl border border-white/20 shadow-lg text-gray-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
              </button>
            </div>
          </div>

          <!-- Player Control -->
          <div class="w-full flex justify-center">
            <div class="w-full max-w-4xl">
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
  name: 'UR ERTZA',
  type: 'Pesquero',
  active: true,
  trips: []
})

const trackPoints = ref<TrackingPoint[]>(generateMockTrack(new Date('2025-11-02T21:11:00Z')))
const playerIndex = ref(0)
const isPlaying = ref(false)
const playbackSpeed = ref(1)
const mapLayers = ref({ 
  totalPoints: true, 
  totalTrack: true, 
  veda: false, 
  isobatas: false 
})
const mouseCoords = ref<LatLng | null>(null)
let playbackInterval: ReturnType<typeof setInterval> | null = null

const currentPoint = computed(() => trackPoints.value[playerIndex.value] || null)

const mockStages: TripStage[] = [
  { id: '1', startDate: '2025-11-03T20:27:00Z', endDate: '2025-11-12T02:14:00Z', durationDays: 10, color: '#f59e0b' },
  { id: '2', startDate: '2025-11-14T10:30:00Z', endDate: '2025-11-21T13:33:00Z', durationDays: 8, color: '#a855f7' },
  { id: '3', startDate: '2025-11-23T12:33:00Z', endDate: '2025-12-01T16:21:00Z', durationDays: 9, color: '#10b981' },
  { id: '4', startDate: '2025-12-03T19:07:00Z', endDate: '2025-12-11T15:39:00Z', durationDays: 9, color: '#ec4899' },
]

const handleLayerToggle = (key: string, val: boolean) => {
  (mapLayers.value as any)[key] = val
}

const handleStageSelection = (stage: TripStage) => {
  // Logic to jump to stage start
  const index = trackPoints.value.findIndex(p => p.timestamp >= stage.startDate)
  if (index !== -1) playerIndex.value = index
}

const handleDateSelection = (date: Date) => {
  const dateStr = date.toISOString().split('T')[0]
  const index = trackPoints.value.findIndex(p => p.timestamp.startsWith(dateStr))
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
}
</style>
