<template>
  <AdminLayout title="Mapa de Recorridos" description="Monitoreo satelital y tracking de la flota en operación.">
    <div class="h-full w-full relative overflow-hidden bg-background text-text" style="height: calc(100vh - 64px)">
      <!-- MAP AND HUD AREA (Full Width background) -->
      <div class="absolute inset-0 z-0">
        <!-- THE MAP (Background) -->
        <div class="absolute inset-0">
          <MapMonitor ref="mapMonitor" class="w-full h-full" :fleet="fleet" :activeLayers="mapLayers"
            @update:mouse-coords="mouseCoords = $event" @seek-vessel="handleSeekVessel"
            @select-vessel="setSelectedVessel" />
        </div>

        <!-- HUD LAYER (Floating Components inside map area) -->
        <div class="relative w-full h-full pointer-events-none z-[1000] p-6">
          <!-- Top Row -->
          <div class="flex justify-between items-start w-full">
            <!-- Left: Back Button and Vessel Info -->
            <div class="flex flex-col gap-4">
              <button v-if="isSingleMareaMode" @click="handleGoBack"
                class="glass-hud flex items-center gap-2 px-4 py-2.5 text-text-muted hover:text-primary group w-fit">
                <ArrowLeftIcon class="w-5 h-5 transition-transform group-hover:-translate-x-1" />
                <span class="text-xs font-black uppercase tracking-widest">Volver</span>
              </button>

              <Transition name="hud-fade">
                <VesselInfoCard v-if="activeVessel && (!leftSidebarOpen || isSingleMareaMode)"
                  :vesselName="activeVessel.name" :mareaCode="activeVessel.mareaCode || '--'"
                  :position="{ lat: currentPoint?.lat || 0, lon: currentPoint?.lon || 0 }"
                  :timestamp="currentPoint?.timestamp?.toString() || ''" :speed="currentPoint?.speed || 0"
                  :course="currentPoint?.course || 0" :lastUpdate="activeVessel.lastUpdate" :layers="mapLayers"
                  :isSingleMode="isSingleMareaMode" @update:layer="handleLayerToggle" />
              </Transition>
            </div>
            <!-- Right: Trip Stages (Optional or for selected vessel) -->
            <div class="flex flex-col gap-3 items-end">
              <TripStagesCard v-if="activeVessel && currentVesselStages.length" :stages="currentVesselStages"
                :totalDays="activeVessel.totalDays || 0" @select-stage="handleStageSelection"
                @select-date="handleDateSelection" />

              <Transition name="hud-fade">
                <VesselInfoCard v-if="activeVessel && (leftSidebarOpen && !isSingleMareaMode)"
                  :vesselName="activeVessel.name" :mareaCode="activeVessel.mareaCode || '--'"
                  :position="{ lat: currentPoint?.lat || 0, lon: currentPoint?.lon || 0 }"
                  :timestamp="currentPoint?.timestamp?.toString() || ''" :speed="currentPoint?.speed || 0"
                  :course="currentPoint?.course || 0" :lastUpdate="activeVessel.lastUpdate" :layers="mapLayers"
                  :isSingleMode="isSingleMareaMode" @update:layer="handleLayerToggle" />
              </Transition>
            </div>
          </div>

          <!-- Top Center: Last Update HUD -->
          <div class="absolute top-6 left-1/2 -translate-x-1/2 pointer-events-none z-[1000] flex justify-center">
            <Transition name="hud-fade">
              <HudCard v-if="lastTrackingUpdate" customClass="px-5 py-2.5">
                <div class="flex items-center gap-4">
                  <div class="relative flex items-center justify-center">
                    <div class="absolute w-3 h-3 rounded-full bg-success animate-ping opacity-20"></div>
                    <div
                      class="relative w-2 h-2 rounded-full bg-success shadow-[0_0_8px_rgba(var(--color-success-rgb),0.6)]">
                    </div>
                  </div>
                  <div class="flex flex-col">
                    <span
                      class="text-[8px] font-black text-primary uppercase tracking-[0.25em] leading-none mb-1 opacity-80 group-hover:opacity-100 transition-opacity">
                      Estado Satelital
                    </span>
                    <span class="text-[11px] font-bold text-text uppercase tracking-wider leading-none">
                      Actualizado: {{ lastTrackingUpdate }}
                    </span>
                  </div>
                </div>
              </HudCard>
            </Transition>
          </div>

          <!-- Bottom Row (Anclado al fondo) -->
          <div class="absolute bottom-6 left-6 right-6 flex flex-col gap-2">
            <!-- Mouse Coordinates -->
            <div :class="[
              'flex transition-all duration-500 ease-in-out',
              leftSidebarOpen ? 'justify-end pr-14' : 'justify-start'
            ]">
              <MouseCoordinates :coords="mouseCoords" />
            </div>

            <!-- Player Control -->
            <div class="w-full flex justify-center pb-4">
              <div class="w-full max-w-md">
                <TimelinePlayer v-if="activeVessel && activeVessel.visible && activeVessel.points.length"
                  :currentIndex="activeVessel.currentIndex" :maxIndex="activeVessel.points.length - 1"
                  :currentTime="currentPoint?.timestamp?.toString() || ''" :isPlaying="isPlaying" :speed="playbackSpeed"
                  :startDate="activeVessel.points[0]?.timestamp.toString().split('T')[0] || '--'"
                  :endDate="activeVessel.points[activeVessel.points.length - 1]?.timestamp.toString().split('T')[0] || '--'"
                  @update:index="handlePlayerIndexUpdate" @update:speed="handleSpeedChange" @toggle-play="togglePlay"
                  @prev="handlePlayerPrev" @next="handlePlayerNext" @skip-start="activeVessel.currentIndex = 0"
                  @skip-end="activeVessel.currentIndex = activeVessel.points.length - 1"
                  @select-date="handleDateSelection" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- SIDEBAR IZQUIERDO (FLOTA) -->
      <VesselListSidebar v-if="!isSingleMareaMode" class="absolute left-0 top-0 h-full z-[2000]"
        v-model:isOpen="leftSidebarOpen" :vessels="vesselList" :selectedId="selectedVesselId"
        @select="setSelectedVessel" @refresh="fetchFleet" />

      <!-- SIDEBAR DERECHO (CONTROL) -->
      <MonitorSidebar v-if="!isSingleMareaMode" class="absolute right-0 top-0 h-full z-[2000]"
        v-model:isOpen="rightSidebarOpen" :mapLayers="mapLayers" @update:layer="handleLayerToggle"
        @open-upload="showUploadDialog = true" />

      <UploadTrackingDialog :show="showUploadDialog" @close="showUploadDialog = false" @refresh="fetchFleet" />

      <!-- LOADING OVERLAY -->
      <div class="absolute bottom-10 left-1/2 -translate-x-1/2 z-[3000] pointer-events-none">
        <TrajectoryLoadingOverlay :show="pendingTrajectoriesCount > 0" :count="pendingTrajectoriesCount" />
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted, onMounted, reactive, watch } from 'vue'
import { useRoute } from 'vue-router'
import type { LatLng } from 'leaflet'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import MapMonitor, { type VesselTrajectory } from '../components/MapMonitor.vue'
import TimelinePlayer from '../components/TimelinePlayer.vue'
import VesselInfoCard from '../components/VesselInfoCard.vue'
import HudCard from '../components/HudCard.vue'
import TripStagesCard, { type TripStage } from '../components/TripStagesCard.vue'
import MouseCoordinates from '../components/MouseCoordinates.vue'
import MonitorSidebar from '../components/MonitorSidebar.vue'
import VesselListSidebar, { type MonitorVessel } from '../components/VesselListSidebar.vue'
import UploadTrackingDialog from '../components/UploadTrackingDialog.vue'
import TrajectoryLoadingOverlay from '../components/TrajectoryLoadingOverlay.vue'
import httpClient from '@/config/http/http.client'
import { useRouter } from 'vue-router'
import { ArrowLeftIcon } from '@/icons'

// --- State ---
const showUploadDialog = ref(false)
const lastTrackingUpdate = ref<string | null>(null)
const fleet = reactive<Record<string, VesselTrajectory>>({})
const selectedVesselId = ref<string | null>(null)
const mouseCoords = ref<LatLng | null>(null)
const mapMonitor = ref<InstanceType<typeof MapMonitor> | null>(null)
const leftSidebarOpen = ref(true)
const rightSidebarOpen = ref(false)
const pendingZoomVesselId = ref<string | null>(null)
const pendingTrajectoriesCount = ref(0)
const isInitialLoad = ref(true)
const mapLayers = ref({
  veda: true,
  vieira: false,
  centolla: false,
  points: false,
  showAllVessels: true,
  showVesselNames: false,
})

const route = useRoute()
const router = useRouter()
const isSingleMareaMode = computed(() => route.name === 'MareaTrajectory' || !!route.params.mareaId)

import { MAX_DISPLAY_POINTS } from '../constants'

// Playback State
const isPlaying = ref(false)
const playbackSpeed = ref(1)
let playbackInterval: ReturnType<typeof setInterval> | null = null

// --- Computed ---
const vesselList = computed<MonitorVessel[]>(() => {
  return Object.values(fleet).map(v => ({
    id: v.id,
    name: v.name,
    matricula: v.matricula || v.id,
    mareaCode: v.mareaCode || '--',
    observer: v.observer || 'Sin asignar',
    color: v.color,
    visible: v.visible,
    voyageStart: v.voyageStart || null,
    voyageEnd: v.voyageEnd || null
  }))
})

const activeVessel = computed(() => {
  if (!selectedVesselId.value) return null
  return fleet[selectedVesselId.value]
})

const currentPoint = computed(() => {
  if (!activeVessel.value) return null
  return activeVessel.value.points[activeVessel.value.currentIndex] || null
})

// --- Methods ---

const generateLightColor = (id: string) => {
  let hash = 0
  for (let i = 0; i < id.length; i++) {
    hash = id.charCodeAt(i) + ((hash << 5) - hash)
  }
  const h = Math.abs(hash % 360)
  return `hsl(${h}, 70%, 60%)`
}

// Watch sidebars to invalidate map size
watch([leftSidebarOpen, rightSidebarOpen], () => {
  // Wait for CSS transition to finish (500ms in CSS)
  let elapsed = 0
  const interval = setInterval(() => {
    mapMonitor.value?.invalidateSize()
    elapsed += 50
    if (elapsed > 600) clearInterval(interval)
  }, 50)
})

const fetchFleet = async () => {
  try {
    const response = await httpClient.get('/tracking/fleet')
    const { fleet: activeMareas, lastUpdate } = response.data

    if (lastUpdate) {
      lastTrackingUpdate.value = lastUpdate
    }

    activeMareas.forEach((marea: any) => { // eslint-disable-line @typescript-eslint/no-explicit-any
      // Key by mareaId to allow multiple mareas per vessel
      if (!fleet[marea.mareaId]) {
        fleet[marea.mareaId] = {
          id: marea.mareaId,   // Use mareaId as the UI ID
          vesselId: marea.id,  // Store original vesselId for backend calls
          name: marea.name,
          color: generateLightColor(marea.id), // Color still based on vessel ID for consistency
          points: [],
          currentIndex: 0,
          visible: false,
          matricula: marea.matricula,
          mareaCode: marea.mareaCode,
          mareaStatus: marea.mareaStatus,
          observer: marea.observer,
          voyageStart: marea.voyageStart,
          voyageEnd: marea.voyageEnd,
          lastUpdate: marea.lastUpdate,
          totalDays: marea.totalDays,
          etapas: marea.etapas,
          lastKnownPoint: (marea.lat !== null && marea.lon !== null) ? {
            lat: marea.lat,
            lon: marea.lon,
            timestamp: marea.lastUpdate,
            speed: marea.speed,
            course: marea.course
          } : null
        }
        // Fetch history using vesselId but passing mareaId to update correct fleet entry
        fetchVesselHistory(marea.id, marea.mareaId, marea.voyageStart, marea.voyageEnd)
      }
    })

    if (!selectedVesselId.value && activeMareas.length > 0) {
      selectedVesselId.value = activeMareas[0].mareaId
    }

    // Zoom a toda la flota en la carga inicial si no hay mareaId específico
    if (isInitialLoad.value && activeMareas.length > 0) {
      setTimeout(() => {
        mapMonitor.value?.fitAllVesselsBounds()
        isInitialLoad.value = false
      }, 500)
    }
  } catch (error) {
    console.error('Error fetching fleet:', error)
  }
}

const fetchSingleMarea = async (mareaId: string) => {
  try {
    const response = await httpClient.get(`/tracking/marea/${mareaId}`)
    const marea = response.data

    fleet[marea.id] = {
      id: marea.id,
      vesselId: marea.buqueId,
      name: marea.name,
      color: generateLightColor(marea.buqueId),
      points: [],
      currentIndex: 0,
      visible: true, // Always visible in single mode
      matricula: marea.matricula,
      mareaCode: marea.mareaCode,
      observer: marea.observer,
      voyageStart: marea.voyageStart,
      voyageEnd: marea.voyageEnd,
      lastUpdate: marea.lastUpdate,
      totalDays: marea.totalDays,
      etapas: marea.etapas
    }

    if (marea.lastTrackingUpdate) {
      lastTrackingUpdate.value = marea.lastTrackingUpdate
    }

    selectedVesselId.value = marea.id
    // History is fetched and zoom is triggered automatically by the watcher/pending logic
    fetchVesselHistory(marea.buqueId, marea.id, marea.voyageStart, marea.voyageEnd)
    pendingZoomVesselId.value = marea.id // Ensure zoom to this marea
  } catch (error) {
    console.error('Error fetching single marea tracking info:', error)
  }
}

const fetchVesselHistory = async (buqueId: string, mareaId: string, from?: string, to?: string) => {
  pendingTrajectoriesCount.value++
  try {
    const params: Record<string, string> = {}
    if (from) params.from = from
    if (to) params.to = to

    const response = await httpClient.get(`/tracking/history/${buqueId}`, { params })
    if (fleet[mareaId]) {
      fleet[mareaId].points = response.data
      fleet[mareaId].currentIndex = response.data.length - 1

      // Auto-trigger zoom if this vessel was waiting for it
      if (pendingZoomVesselId.value === mareaId) {
        setTimeout(() => {
          mapMonitor.value?.fitVesselBounds(mareaId)
          pendingZoomVesselId.value = null
        }, 300)
      }
    }
  } catch (error) {
    console.error(`Error fetching history for marea ${mareaId} (vessel ${buqueId}):`, error)
  } finally {
    pendingTrajectoriesCount.value = Math.max(0, pendingTrajectoriesCount.value - 1)
  }
}

const setSelectedVessel = (id: string) => {
  selectedVesselId.value = id
  stopPlayback()

  // Visibilidad exclusiva: solo la seleccionada es visible
  Object.values(fleet).forEach(v => {
    v.visible = v.id === id
  })

  // Auto-zoom si hay puntos cargados y NO es la carga inicial
  if (!isInitialLoad.value && fleet[id]?.visible && fleet[id].points.length > 0) {
    setTimeout(() => {
      mapMonitor.value?.fitVesselBounds(id)
    }, 300)
  } else if (fleet[id]?.visible && !isInitialLoad.value) {
    // Si no hay puntos, marcar para zoom pendiente cuando carguen
    pendingZoomVesselId.value = id
  }
}

const handleSeekVessel = ({ vesselId, index }: { vesselId: string, index: number }) => {
  if (fleet[vesselId]) {
    fleet[vesselId].currentIndex = index
    selectedVesselId.value = vesselId
  }
}

const handleLayerToggle = (key: string, val: boolean) => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ; (mapLayers.value as any)[key] = val
}

const handlePlayerIndexUpdate = (val: number) => {
  if (activeVessel.value) {
    activeVessel.value.currentIndex = val
  }
}

const handlePlayerPrev = () => {
  if (activeVessel.value) {
    activeVessel.value.currentIndex = Math.max(0, activeVessel.value.currentIndex - 1)
  }
}

const handlePlayerNext = () => {
  if (activeVessel.value) {
    activeVessel.value.currentIndex = Math.min(activeVessel.value.points.length - 1, activeVessel.value.currentIndex + 1)
  }
}

const handleStageSelection = (stage: TripStage) => {
  if (!activeVessel.value) return
  const index = activeVessel.value.points.findIndex((p) => {
    const ts = typeof p.timestamp === 'string' ? p.timestamp : (p.timestamp as Date).toISOString()
    return ts >= stage.startDate
  })
  if (index !== -1) activeVessel.value.currentIndex = index
}

const handleDateSelection = (dateStr: string, isEnd: boolean = false) => {
  if (!activeVessel.value || !activeVessel.value.points.length) return

  const date = new Date(dateStr)
  if (isEnd) {
    // Si es fin (arribo), apuntamos al último momento del día para asegurar ver el tramo final
    date.setHours(23, 59, 59, 999)
  }

  const targetTime = date.getTime()
  let minDiff = Infinity
  let nearestIdx = 0

  activeVessel.value.points.forEach((p, idx) => {
    const pTime = new Date(p.timestamp).getTime()
    const diff = Math.abs(pTime - targetTime)
    if (diff < minDiff) {
      minDiff = diff
      nearestIdx = idx
    }
  })

  activeVessel.value.currentIndex = nearestIdx
}

const togglePlay = () => {
  if (isPlaying.value) stopPlayback()
  else startPlayback()
}

const startPlayback = () => {
  if (!activeVessel.value || activeVessel.value.points.length === 0) return

  if (activeVessel.value.currentIndex >= activeVessel.value.points.length - 1) {
    activeVessel.value.currentIndex = 0
  }

  isPlaying.value = true
  playbackInterval = setInterval(() => {
    if (activeVessel.value && activeVessel.value.currentIndex < activeVessel.value.points.length - 1) {
      activeVessel.value.currentIndex++
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

const handleGoBack = () => {
  if (window.history.length > 1) {
    router.back()
  } else {
    router.push({ name: 'MareasDashboard' })
  }
}

const handleSpeedChange = (newSpeed: number) => {
  playbackSpeed.value = newSpeed
  if (isPlaying.value) {
    stopPlayback()
    startPlayback()
  }
}

const currentVesselStages = computed<TripStage[]>(() => {
  if (!activeVessel.value || !activeVessel.value.etapas) return []
  return activeVessel.value.etapas.map((e: any) => ({ // eslint-disable-line @typescript-eslint/no-explicit-any
    id: e.id,
    nroEtapa: e.nroEtapa,
    startDate: e.fechaZarpada,
    endDate: e.fechaArribo,
    durationDays: e.diasNavegados,
    color: e.id_tipo_etapa === 'PESCA' ? 'var(--color-info)' : 'var(--color-primary)'
  }))
})

const initializeMonitor = () => {
  stopPlayback()

  // Reset state to avoid residual data
  Object.keys(fleet).forEach(key => delete fleet[key])
  selectedVesselId.value = null
  pendingZoomVesselId.value = null
  pendingTrajectoriesCount.value = 0
  isInitialLoad.value = true

  const mareaId = route.params.mareaId as string
  if (mareaId) {
    leftSidebarOpen.value = false
    rightSidebarOpen.value = false
    mapLayers.value.showAllVessels = false
    mapLayers.value.showVesselNames = false
    fetchSingleMarea(mareaId)
  } else {
    leftSidebarOpen.value = true
    rightSidebarOpen.value = false
    fetchFleet()
  }
}

// Watch for route changes (since the component is reused)
watch(() => route.path, () => {
  initializeMonitor()
})

onMounted(() => {
  initializeMonitor()
})

onUnmounted(stopPlayback)
</script>

<style scoped>
:deep(.admin-layout-content) {
  padding: 0 !important;
  max-width: none !important;
  margin: 0 !important;
}

/* Transiciones para el HUD */
.hud-fade-enter-active,
.hud-fade-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.hud-fade-enter-from,
.hud-fade-leave-to {
  opacity: 0;
  transform: translateY(10px) scale(0.95);
}
</style>
