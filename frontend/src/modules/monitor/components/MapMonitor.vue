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
import { ref, watch, onMounted } from 'vue'
import L from 'leaflet'
import NauticalMap from '@/components/common/NauticalMap.vue'
import type { TrackingPoint } from '../data/mockTracking'

const props = defineProps<{
  points: TrackingPoint[]
  currentIndex: number
  activeLayers: { veda: boolean; isobatas: boolean }
}>()

const emit = defineEmits(['update:mouse-coords'])

const nauticalMap = ref<InstanceType<typeof NauticalMap> | null>(null)
let map: L.Map | null = null
let trackLayer: L.FeatureGroup | null = null
let vesselMarker: L.Marker | null = null
let ghostPath: L.Polyline | null = null

const onMapReady = (mapInstance: L.Map) => {
  map = mapInstance
  trackLayer = L.featureGroup().addTo(map)
  drawTrack()
  updateVesselMarker(props.currentIndex)
}

const drawTrack = () => {
  if (!map || !trackLayer || !props.points.length) return

  trackLayer.clearLayers()

  for (let i = 0; i < props.points.length - 1; i++) {
    const p1 = props.points[i]
    const p2 = props.points[i + 1]

    let color = 'var(--color-info)'
    if (p1.speed < 4.5) color = 'var(--color-error)'
    else if (p1.speed < 7) color = 'var(--color-warning)'

    L.polyline(
      [
        [p1.lat, p1.lon],
        [p2.lat, p2.lon],
      ],
      {
        color: color,
        weight: 3,
        opacity: 0.8,
        lineCap: 'round',
        interactive: true,
      },
    ).addTo(trackLayer)
  }

  const bounds = L.latLngBounds(props.points.map((p) => [p.lat, p.lon]))
  map.fitBounds(bounds, { padding: [50, 50] })
}

const checkAutoPan = (lat: number, lon: number) => {
  if (!map) return
  const point = map.latLngToContainerPoint([lat, lon])
  const size = map.getSize()
  const thresholdX = size.x * 0.1
  const thresholdY = size.y * 0.1

  if (point.x < thresholdX || point.x > (size.x - thresholdX) || 
      point.y < thresholdY || point.y > (size.y - thresholdY)) {
    map.panTo([lat, lon], { animate: true, duration: 0.5 })
  }
}

let isInitialLoad = true

const updateVesselMarker = (index: number) => {
  if (!map || !props.points[index]) return
  const current = props.points[index]

  const icon = L.divIcon({
    className: 'vessel-marker-icon',
    html: `
      <div class="relative w-8 h-8 flex items-center justify-center transition-transform duration-500 ease-linear" style="transform: rotate(${current.course}deg)">
        <div class="w-4 h-6 bg-primary rounded-t-full shadow-lg border-2 border-surface"></div>
        <div class="absolute -top-1 w-1 h-1 bg-surface rounded-full"></div>
      </div>
    `,
    iconSize: [32, 32],
    iconAnchor: [16, 16],
  })

  if (!vesselMarker) {
    vesselMarker = L.marker([current.lat, current.lon], { icon }).addTo(map)
  } else {
    vesselMarker.setLatLng([current.lat, current.lon])
    vesselMarker.setIcon(icon)
  }

  if (ghostPath) map.removeLayer(ghostPath)
  const traveledPoints = props.points.slice(0, index + 1).map((p) => [p.lat, p.lon])
  ghostPath = L.polyline(traveledPoints as L.LatLngExpression[], {
    color: 'var(--color-info)',
    weight: 4,
    opacity: 1,
    dashArray: '1, 5',
  }).addTo(map)

  if (!isInitialLoad) {
    checkAutoPan(current.lat, current.lon)
  }
}

watch(() => props.points, drawTrack)

watch(() => props.currentIndex, (newIndex) => {
  isInitialLoad = false
  updateVesselMarker(newIndex)
})

watch(() => props.activeLayers, (newLayers) => {
  console.log('Layers updated:', newLayers)
}, { deep: true })
</script>
</script>

<style>
.vessel-icon {
  transition: transform 0.3s ease-in-out;
}
</style>
