<template>
  <AdminLayout>
    <div class="relative w-full overflow-hidden bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100" style="height: calc(100vh - 64px)">
      <!-- DRAWER: Vessel Selection -->
      <div
        v-if="isSidebarOpen"
        class="absolute inset-0 z-[1040] bg-black/20 backdrop-blur-[2px] transition-opacity"
        @click="isSidebarOpen = false"
      ></div>

      <aside
        class="absolute top-0 bottom-0 left-0 z-[1050] w-80 bg-white dark:bg-gray-900 shadow-2xl transition-transform duration-300 ease-in-out"
        :class="isSidebarOpen ? 'translate-x-0' : '-translate-x-full'"
      >
        <VesselSidebar @select-trip="handleTripSelection" />
        <!-- Close Button -->
        <button
          @click="isSidebarOpen = false"
          class="absolute top-3 right-3 p-1.5 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 bg-white/50 dark:bg-black/20 rounded-full"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
      </aside>

      <!-- MAIN AREA: Map & Overlays -->
      <div class="relative w-full h-full">
        <!-- Top Overlay: Context Info & Toggle -->
        <div class="absolute top-6 left-6 z-[1000] flex flex-col gap-4 pointer-events-none">
          <div class="flex items-center gap-4 pointer-events-auto">
            <button
              @click="isSidebarOpen = true"
              class="p-2.5 bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-200 rounded-xl shadow-lg border border-gray-200 dark:border-gray-800 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all active:scale-95"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
            <div class="flex flex-col gap-1">
              <h1 class="text-2xl uppercase tracking-tight text-gray-900 dark:text-white drop-shadow-md">
                Centro de Operaciones Marítimas
              </h1>
              <div v-if="selectedVessel" class="flex items-center gap-2">
                <span class="flex h-2 w-2 rounded-full bg-success-500"></span>
                <span class="text-xs font-bold text-gray-700 dark:text-gray-300">{{ selectedVessel.name }}</span>
                <span class="text-[10px] text-gray-500">|</span>
                <span class="text-xs font-medium text-gray-500 dark:text-gray-400">{{ selectedTrip?.id }}</span>
              </div>
            </div>
          </div>
        </div>

      <!-- THE MAP -->
      <MapMonitor class="w-full h-full" :points="trackPoints" :currentIndex="playerIndex" />

      <!-- Right Overlay: Telemetry -->
      <div v-if="currentPoint" class="absolute top-6 right-20 z-[1000] w-72 pointer-events-auto">
        <TelemetryOverlay
          :point="currentPoint"
          :tripId="selectedTrip?.id || ''"
          :stats="tripStats"
        />
      </div>

      <!-- Bottom Overlay: Timeline Player -->
      <div
        class="absolute bottom-10 left-1/2 -translate-x-1/2 z-[1000] w-full max-w-4xl px-6 pointer-events-auto"
      >
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
        />
      </div>
    </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import VesselSidebar from '../components/VesselSidebar.vue'
import MapMonitor from '../components/MapMonitor.vue'
import TimelinePlayer from '../components/TimelinePlayer.vue'
import TelemetryOverlay from '../components/TelemetryOverlay.vue'
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

const selectedVessel = ref<Vessel | null>(null)
const selectedTrip = ref<Trip | null>(null)
const trackPoints = ref<TrackingPoint[]>([])
const playerIndex = ref(0)
const isPlaying = ref(false)
const isSidebarOpen = ref(true)
const playbackSpeed = ref(1)
let playbackInterval: ReturnType<typeof setInterval> | null = null

const currentPoint = computed(() => trackPoints.value[playerIndex.value] || null)

const tripStats = computed(() => {
  if (!trackPoints.value.length)
    return { distanceTraveled: 0, totalDistance: 0, daysAtSea: 0, fishingHours: 0 }

  // Mock constant stats for the demo
  return {
    distanceTraveled: Math.round(playerIndex.value * 2.4),
    totalDistance: Math.round(trackPoints.value.length * 2.4),
    daysAtSea: 14,
    fishingHours: 120,
  }
})

const handleTripSelection = (data: { vessel: Vessel; trip: Trip }) => {
  selectedVessel.value = data.vessel
  selectedTrip.value = data.trip
  isSidebarOpen.value = false

  // Load mock data
  trackPoints.value = generateMockTrack(new Date('2025-12-05T08:00:00Z'))
  playerIndex.value = 0
  isPlaying.value = false
  stopPlayback()
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
  }, 500 / playbackSpeed.value) // Base 500ms per point adj by speed
}

const stopPlayback = () => {
  isPlaying.value = false
  if (playbackInterval) {
    clearInterval(playbackInterval)
    playbackInterval = null
  }
}

// Watch speed changes to adjust interval
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
