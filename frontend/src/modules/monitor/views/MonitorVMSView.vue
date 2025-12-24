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
      <!-- MAIN AREA: Map & Overlays -->
      <div class="relative w-full h-full flex flex-col md:flex-row">
        <!-- THE MAP (Full width/height background) -->
        <div class="absolute inset-0">
          <MapMonitor
            class="w-full h-full"
            :points="trackPoints"
            :currentIndex="playerIndex"
            :activeLayers="mapLayers"
          />
        </div>

        <!-- HUD Layer (Pointer events transparent to allow clicking map) -->
        <div class="relative flex-1 p-6 flex flex-col pointer-events-none z-[1000] h-full">
          <!-- TOP ROW: Header & Vessel Info -->
          <div class="flex justify-between items-start w-full">
            <div class="flex items-center gap-4 pointer-events-auto">
              <button
                @click="isSidebarOpen = true"
                class="p-2.5 bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-200 rounded-xl shadow-lg border border-gray-200 dark:border-gray-800 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all active:scale-95"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-6 w-6"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                </svg>
              </button>
              <div class="flex flex-col gap-0.5">
                <h1
                  class="text-xl md:text-2xl uppercase tracking-tight text-gray-900 dark:text-white drop-shadow-md"
                >
                  Monitoreo VMS
                </h1>
                <div v-if="selectedVessel" class="flex items-center gap-2">
                  <span class="flex h-2 w-2 rounded-full bg-success-500 animate-pulse"></span>
                  <span class="text-xs font-bold text-gray-700 dark:text-gray-300">{{
                    selectedVessel.name
                  }}</span>
                  <span class="text-[10px] text-gray-400">|</span>
                  <span class="text-xs font-medium text-gray-500 dark:text-gray-400">{{
                    selectedTrip?.id
                  }}</span>
                </div>
              </div>
            </div>

            <!-- RIGHT HUD: Telemetry & Layer Controls (Hidden on small mobile) -->
            <div class="hidden sm:flex flex-col gap-4 w-72 pointer-events-auto">
              <TelemetryOverlay
                v-if="currentPoint"
                :point="currentPoint"
                :tripId="selectedTrip?.id || ''"
                :stats="tripStats"
              />

              <!-- Layer Selection (Moved from MapMonitor) -->
              <div
                class="bg-white/60 dark:bg-gray-900/60 backdrop-blur-xl p-4 rounded-2xl border border-gray-200/50 dark:border-white/10 shadow-xl"
              >
                <h4 class="text-[10px] font-black uppercase tracking-widest text-gray-400 mb-3">
                  Capas del Mapa
                </h4>
                <div class="flex flex-col gap-2">
                  <button
                    @click="mapLayers.veda = !mapLayers.veda"
                    class="flex items-center justify-between px-3 py-2 rounded-xl text-[10px] font-bold uppercase transition-all"
                    :class="
                      mapLayers.veda
                        ? 'bg-error-500 text-white shadow-lg shadow-error-500/20'
                        : 'bg-gray-50 dark:bg-gray-800 text-gray-500 hover:bg-gray-100'
                    "
                  >
                    <span>Zonas de Veda</span>
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M13.477 14.89A6 6 0 015.11 6.524l8.367 8.368zm1.414-1.414L6.524 5.11a6 6 0 018.367 8.367zM18 10a8 8 0 11-16 0 8 8 0 0116 0z" clip-rule="evenodd" />
                    </svg>
                  </button>
                  <button
                    @click="mapLayers.isobatas = !mapLayers.isobatas"
                    class="flex items-center justify-between px-3 py-2 rounded-xl text-[10px] font-bold uppercase transition-all"
                    :class="
                      mapLayers.isobatas
                        ? 'bg-blue-500 text-white shadow-lg shadow-blue-500/20'
                        : 'bg-gray-50 dark:bg-gray-800 text-gray-500 hover:bg-gray-100'
                    "
                  >
                    <span>Isobatas</span>
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm6 5a1 1 0 011-1h6a1 1 0 110 2h-6a1 1 0 01-1-1z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div class="flex-1"></div>

          <!-- BOTTOM HUD -->
          <div class="flex flex-col md:flex-row items-end justify-between gap-6 w-full">
            <!-- Legend (Moved from MapMonitor) -->
            <div
              class="hidden md:block bg-white/60 dark:bg-gray-900/60 backdrop-blur-xl p-4 rounded-2xl border border-gray-200/50 dark:border-white/10 text-gray-900 dark:text-white shadow-2xl pointer-events-auto"
            >
              <h4 class="text-[9px] font-black uppercase tracking-widest text-gray-400 mb-3">
                Velocidad (Nudos)
              </h4>
              <div class="flex items-center gap-6">
                <div class="flex items-center gap-2">
                  <div class="h-1 w-6 bg-error-500 rounded-full"></div>
                  <span class="text-[9px] font-bold">&lt; 4 (Pesca)</span>
                </div>
                <div class="flex items-center gap-2">
                  <div class="h-1 w-6 bg-warning-500 rounded-full"></div>
                  <span class="text-[9px] font-bold">4-8 (Maniobra)</span>
                </div>
                <div class="flex items-center gap-2">
                  <div class="h-1 w-6 bg-blue-500 rounded-full"></div>
                  <span class="text-[9px] font-bold">> 8 (Tránsito)</span>
                </div>
              </div>
            </div>

            <!-- PLAYER -->
            <div class="w-full max-w-3xl pointer-events-auto">
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
const mapLayers = ref({ veda: false, isobatas: false })
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
