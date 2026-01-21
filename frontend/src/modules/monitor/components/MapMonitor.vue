<template>
  <NauticalMap 
    ref="nauticalMap"
    @map-ready="onMapReady"
    @mousemove="emit('update:mouse-coords', $event.latlng)"
  >
    <!-- Slot for extra overlays if needed later -->
  </NauticalMap>
</template>

<script setup lang="ts">
import { ref, watch, onUnmounted } from 'vue'
import L from 'leaflet'
import NauticalMap from '@/components/common/NauticalMap.vue'

export interface FleetTrackPoint {
  lat: number
  lon: number
  timestamp: string | Date
  speed: number
  course: number
}

export interface VesselTrajectory {
  id: string
  name: string
  color: string
  points: FleetTrackPoint[]
  currentIndex: number
  visible: boolean
}

const props = defineProps<{
  fleet: Record<string, VesselTrajectory>
  activeLayers: { veda: boolean; isobatas: boolean; points: boolean }
}>()

const emit = defineEmits(['update:mouse-coords'])

const nauticalMap = ref<InstanceType<typeof NauticalMap> | null>(null)
let map: L.Map | null = null

// Layers management
const trajectoriesLayer = L.layerGroup()
const markersLayer = L.layerGroup()
const pointsLayer = L.layerGroup()

const vesselMarkers = new Map<string, L.Marker>()

const onMapReady = (mapInstance: L.Map) => {
  map = mapInstance
  trajectoriesLayer.addTo(map)
  markersLayer.addTo(map)
  pointsLayer.addTo(map)
  
  updateAll()
}

const updateAll = () => {
  if (!map) return
  
  trajectoriesLayer.clearLayers()
  markersLayer.clearLayers()
  pointsLayer.clearLayers()
  vesselMarkers.clear()

  Object.values(props.fleet).forEach(vessel => {
    if (!vessel.visible || vessel.points.length === 0) return
    
    renderTrajectory(vessel)
    renderMarker(vessel)
    if (props.activeLayers.points) {
      renderPoints(vessel)
    }
  })
}

const renderTrajectory = (vessel: VesselTrajectory) => {
  if (!map) return

  // Traveled path (segments with potential fishing colors)
  for (let i = 0; i < vessel.currentIndex; i++) {
    const p1 = vessel.points[i]
    const p2 = vessel.points[i + 1]
    if (!p1 || !p2) continue

    let color = vessel.color
    // FISHING SPEED: 2 to 5 knots (User request)
    // Distictive color for fishing segments (Cian/Info)
    if (p1.speed >= 2 && p1.speed <= 5) {
      color = 'var(--color-info)' // Using theme info color for fishing
    }

    L.polyline([[p1.lat, p1.lon], [p2.lat, p2.lon]], {
      color: color,
      weight: 3,
      opacity: 0.9,
      lineCap: 'round'
    }).addTo(trajectoriesLayer)
  }

  // Ghost path (remaining path)
  if (vessel.currentIndex < vessel.points.length - 1) {
    const remaining = vessel.points.slice(vessel.currentIndex).map(p => [p.lat, p.lon])
    L.polyline(remaining as L.LatLngExpression[], {
      color: vessel.color,
      weight: 2,
      opacity: 0.4,
      dashArray: '5, 10'
    }).addTo(trajectoriesLayer)
  }
}

const renderMarker = (vessel: VesselTrajectory) => {
  const current = vessel.points[vessel.currentIndex]
  if (!current) return

  const icon = L.divIcon({
    className: 'vessel-marker-icon',
    html: `
      <div class="relative w-8 h-8 flex items-center justify-center transition-all duration-300" style="transform: rotate(${current.course}deg)">
        <div class="w-4 h-6 rounded-t-full shadow-lg border-2 border-surface" style="background-color: ${vessel.color}"></div>
        <div class="absolute -top-1 w-1.5 h-1.5 bg-surface rounded-full shadow-sm"></div>
      </div>
    `,
    iconSize: [32, 32],
    iconAnchor: [16, 16],
  })

  const marker = L.marker([current.lat, current.lon], { icon }).addTo(markersLayer)
  marker.bindTooltip(vessel.name, { 
    permanent: false, 
    direction: 'top', 
    className: 'vessel-tooltip' 
  })
  
  vesselMarkers.set(vessel.id, marker)
}

const renderPoints = (vessel: VesselTrajectory) => {
  vessel.points.forEach(p => {
    L.circleMarker([p.lat, p.lon], {
      radius: 2,
      color: vessel.color,
      fillColor: vessel.color,
      fillOpacity: 0.5,
      weight: 1
    }).addTo(pointsLayer)
  })
}

watch(() => props.fleet, updateAll, { deep: true })
watch(() => props.activeLayers.points, (val) => {
  if (val) updateAll()
  else pointsLayer.clearLayers()
})

onUnmounted(() => {
  trajectoriesLayer.remove()
  markersLayer.remove()
  pointsLayer.remove()
})
</script>

<style>
.vessel-tooltip {
  background: var(--color-surface) !important;
  color: var(--color-text) !important;
  border: 1px solid var(--color-border) !important;
  border-radius: 8px !important;
  font-weight: 900 !important;
  font-size: 10px !important;
  text-transform: uppercase !important;
  padding: 2px 8px !important;
  box-shadow: var(--shadow-theme-md) !important;
}
</style>
