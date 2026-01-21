<template>
  <NauticalMap ref="nauticalMap" @map-ready="onMapReady" @mousemove="emit('update:mouse-coords', $event.latlng)">
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
  vesselId?: string
  name: string
  color: string
  points: FleetTrackPoint[]
  currentIndex: number
  visible: boolean
  matricula?: string
  mareaCode?: string
  observer?: string
  voyageStart?: string | null
  voyageEnd?: string | null
  lastUpdate?: string | Date | null
  totalDays?: number
  etapas?: any[] // eslint-disable-line @typescript-eslint/no-explicit-any
}

const props = defineProps<{
  fleet: Record<string, VesselTrajectory>
  activeLayers: { veda: boolean; vieira: boolean; centolla: boolean; points: boolean }
}>()

const emit = defineEmits(['update:mouse-coords', 'seek-vessel'])

const nauticalMap = ref<InstanceType<typeof NauticalMap> | null>(null)
let map: L.Map | null = null

// Layers management
const trajectoriesLayer = L.layerGroup()
const markersLayer = L.layerGroup()
const pointsLayer = L.layerGroup()
const geojsonLayers = {
  limite: L.layerGroup(),
  veda: L.layerGroup(),
  vieira: L.layerGroup(),
  centolla: L.layerGroup()
}

const LAYER_FILES = {
  limite: [
    'areas_generales/mar_territorial.geojson',
    'areas_generales/zona_economica_exclusiva.geojson',
    'areas_generales/ZCP.geojson'
  ],
  veda: [
    'zonas_veda/Veda 2014.geojson',
    'zonas_veda/Veda Merluza Negra.geojson'
  ],
  vieira: [
    // (rest as before)
    'areas_vieira/areas_vieira.geojson'
  ],
  centolla: [
    'areas_centolla/area_centolla_C1.geojson',
    'areas_centolla/area_centolla_C2.geojson',
    'areas_centolla/area_centolla_C3.geojson',
    'areas_centolla/area_centolla_C4.geojson',
    'areas_centolla/area_centolla_C5.geojson',
    'areas_centolla/area_centolla_S1.geojson',
    'areas_centolla/area_centolla_S2.geojson',
    'areas_centolla/area_centolla_S3.geojson',
    'areas_centolla/area_centolla_S4.geojson'
  ]
}

const vesselMarkers = new Map<string, L.Marker>()

const onMapReady = (mapInstance: L.Map) => {
  map = mapInstance

  // Create pane for GeoJSON behind everything
  if (!map.getPane('geojson')) {
    map.createPane('geojson')
    map.getPane('geojson')!.style.zIndex = '350' // Below overlays (400)
    map.getPane('geojson')!.style.pointerEvents = 'none'
  }

  // Add layers in correct order
  geojsonLayers.limite.addTo(map)
  geojsonLayers.veda.addTo(map)
  geojsonLayers.vieira.addTo(map)
  geojsonLayers.centolla.addTo(map)

  trajectoriesLayer.addTo(map)
  markersLayer.addTo(map)
  pointsLayer.addTo(map)

  // Initial load of active geojson layers
  loadGeoJson('limite') // Fixed layer
  if (props.activeLayers.veda) loadGeoJson('veda')
  if (props.activeLayers.vieira) loadGeoJson('vieira')
  if (props.activeLayers.centolla) loadGeoJson('centolla')

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

    const poly = L.polyline([[p1.lat, p1.lon], [p2.lat, p2.lon]], {
      color: color,
      weight: 3, // Thinner, cleaner look
      opacity: 0.9,
      lineCap: 'round',
      className: 'interactive-trajectory'
    }).addTo(trajectoriesLayer)

    poly.on('click', (e: L.LeafletMouseEvent) => {
      const index = findNearestPoint(e.latlng, vessel.points)
      emit('seek-vessel', { vesselId: vessel.id, index })
    })
  }

  // Ghost path (remaining path)
  if (vessel.currentIndex < vessel.points.length - 1) {
    const remaining = vessel.points.slice(vessel.currentIndex).map(p => [p.lat, p.lon])
    const ghost = L.polyline(remaining as L.LatLngExpression[], {
      color: vessel.color,
      weight: 2,
      opacity: 0.4,
      dashArray: '4, 8',
      className: 'interactive-trajectory'
    }).addTo(trajectoriesLayer)

    ghost.on('click', (e: L.LeafletMouseEvent) => {
      // Adjust click index because slice starts from currentIndex
      const indexInSlice = findNearestPoint(e.latlng, vessel.points.slice(vessel.currentIndex))
      emit('seek-vessel', { vesselId: vessel.id, index: vessel.currentIndex + indexInSlice })
    })
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
  vessel.points.forEach((p, idx) => {
    const dot = L.circleMarker([p.lat, p.lon], {
      radius: 4,
      color: vessel.color,
      fillColor: vessel.color,
      fillOpacity: 0.5,
      weight: 1,
      className: 'interactive-dot'
    }).addTo(pointsLayer)

    dot.on('click', () => {
      emit('seek-vessel', { vesselId: vessel.id, index: idx })
    })
  })
}

const loadGeoJson = async (type: 'veda' | 'vieira' | 'centolla' | 'limite') => {
  if (!map) return

  const group = geojsonLayers[type]
  group.clearLayers()

  if (type !== 'limite' && !props.activeLayers[type]) return

  const files = LAYER_FILES[type as keyof typeof LAYER_FILES]

  for (const file of files) {
    try {
      const response = await fetch(`/data/layers/geojson/${file}`)
      if (!response.ok) throw new Error(`Status: ${response.status}`)
      const data = await response.json()

      let style: L.PathOptions = {}

      if (type === 'limite') {
        if (file.includes('mar_territorial')) {
          style = { color: '#3B82F6', weight: 1, opacity: 0.8, fillOpacity: 0 }
        } else if (file.includes('zona_economica_exclusiva')) {
          style = { color: '#EF4444', weight: 2.5, opacity: 0.8, fillOpacity: 0 }
        } else if (file.includes('ZCP')) {
          style = { color: '#10B981', weight: 1.2, opacity: 0.7, fillOpacity: 0 }
        }
      } else {
        const color = type === 'veda' ? '#F43F5E' : type === 'vieira' ? '#10B981' : '#F59E0B'
        style = {
          color: color,
          weight: 2,
          opacity: 1, // Visible border
          fillColor: color,
          fillOpacity: 0.15, // Subtle fill
          dashArray: type === 'veda' ? '5, 5' : undefined
        }
      }

      L.geoJSON(data, {
        pane: 'geojson',
        style: style
      }).addTo(group)
    } catch (e) {
      console.error(`Error loading geojson ${file}:`, e)
    }
  }
}

// Optimization: Find nearest point index in trajectory
const findNearestPoint = (latlng: L.LatLng, points: FleetTrackPoint[]): number => {
  let minMarkerDist = Infinity
  let nearestIdx = 0

  for (let i = 0; i < points.length; i++) {
    const p = points[i]
    // Simple Euclidean-like distance is enough for local proximity at zoom
    const d = Math.pow(latlng.lat - p.lat, 2) + Math.pow(latlng.lng - p.lon, 2)
    if (d < minMarkerDist) {
      minMarkerDist = d
      nearestIdx = i
    }
  }
  return nearestIdx
}

watch(() => props.fleet, updateAll, { deep: true })
watch(() => props.activeLayers.points, (val) => {
  if (val) updateAll()
  else pointsLayer.clearLayers()
})

watch(() => props.activeLayers.veda, () => loadGeoJson('veda'))
watch(() => props.activeLayers.vieira, () => loadGeoJson('vieira'))
watch(() => props.activeLayers.centolla, () => loadGeoJson('centolla'))

const fitVesselBounds = (vesselId: string) => {
  if (!map) return
  const vessel = props.fleet[vesselId]
  if (!vessel || vessel.points.length === 0) return

  const bounds = L.latLngBounds(vessel.points.map(p => [p.lat, p.lon]))
  map.fitBounds(bounds, { padding: [50, 50], animate: true })
}

const invalidateSize = () => {
  if (map) {
    map.invalidateSize({ animate: true })
  }
}

defineExpose({ fitVesselBounds, invalidateSize })

onUnmounted(() => {
  trajectoriesLayer.remove()
  markersLayer.remove()
  pointsLayer.remove()
  geojsonLayers.limite.remove()
  geojsonLayers.veda.remove()
  geojsonLayers.vieira.remove()
  geojsonLayers.centolla.remove()
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

.interactive-trajectory,
.interactive-dot {
  cursor: pointer !important;
}
</style>
