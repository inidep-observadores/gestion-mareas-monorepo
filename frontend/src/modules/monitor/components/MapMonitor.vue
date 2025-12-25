<template>
  <div class="relative h-full w-full overflow-hidden bg-gray-100 dark:bg-gray-950">
    <div ref="mapContainer" class="h-full w-full"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, onUnmounted } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import type { TrackingPoint } from '../data/mockTracking'

const props = defineProps<{
  points: TrackingPoint[]
  currentIndex: number
  activeLayers: { veda: boolean; isobatas: boolean }
}>()

const mapContainer = ref<HTMLElement | null>(null)
let map: L.Map | null = null
let trackLayer: L.FeatureGroup | null = null
let vesselMarker: L.Marker | null = null
let ghostPath: L.Polyline | null = null
let baseLayer: L.TileLayer | null = null
let themeObserver: MutationObserver | null = null

const emit = defineEmits(['update:mouse-coords'])

const graticuleLayer = ref<L.LayerGroup | null>(null)

const updateGraticule = () => {
  if (!map) return
  if (!graticuleLayer.value) {
    graticuleLayer.value = L.layerGroup().addTo(map)
  }
  
  graticuleLayer.value.clearLayers()
  
  const bounds = map.getBounds()
  const zoom = map.getZoom()
  
  // Adjust interval based on zoom
  let interval = 1
  if (zoom < 5) interval = 5
  else if (zoom < 7) interval = 2
  else if (zoom > 10) interval = 0.5
  
  const minLat = Math.floor(bounds.getSouth() / interval) * interval
  const maxLat = Math.ceil(bounds.getNorth() / interval) * interval
  const minLon = Math.floor(bounds.getWest() / interval) * interval
  const maxLon = Math.ceil(bounds.getEast() / interval) * interval
  
  const style = {
    color: 'rgba(156, 163, 175, 0.2)', // gray-400 with low opacity
    weight: 1,
    interactive: false
  }

  for (let lat = minLat; lat <= maxLat; lat += interval) {
    L.polyline([[lat, minLon], [lat, maxLon]], style).addTo(graticuleLayer.value)
  }
  
  for (let lon = minLon; lon <= maxLon; lon += interval) {
    L.polyline([[minLat, lon], [maxLat, lon]], style).addTo(graticuleLayer.value)
  }
}

const initMap = () => {
  if (!mapContainer.value) return

  map = L.map(mapContainer.value, {
    zoomControl: false,
    attributionControl: false,
  }).setView([-42.5, -60.2], 7)

  // Initialize with correct theme
  updateBaseLayer()

  L.control.zoom({ position: 'bottomright' }).addTo(map)
  L.control.scale({ imperial: false, position: 'bottomright' }).addTo(map)

  trackLayer = L.featureGroup().addTo(map)

  map.on('mousemove', (e: L.LeafletMouseEvent) => {
    emit('update:mouse-coords', e.latlng)
  })
  
  map.on('moveend zoomend', updateGraticule)
  updateGraticule()
}

const drawTrack = () => {
  if (!map || !trackLayer || !props.points.length) return

  trackLayer.clearLayers()

  // Draw segments with different colors based on speed
  for (let i = 0; i < props.points.length - 1; i++) {
    const p1 = props.points[i]
    const p2 = props.points[i + 1]

    let color = 'var(--color-blue-500)'
    if (p1.speed < 4.5) color = 'var(--color-error-500)'
    else if (p1.speed < 7) color = 'var(--color-warning-500)'

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
    )
      .on('mouseover', () => {
        // Logic for Sticky Tooltip (could be handled via event to parent)
      })
      .addTo(trackLayer)
  }

  // Initial fit bounds
  const bounds = L.latLngBounds(props.points.map((p) => [p.lat, p.lon]))
  map.fitBounds(bounds, { padding: [50, 50] })
}

const checkAutoPan = (lat: number, lon: number) => {
  if (!map) return

  const point = map.latLngToContainerPoint([lat, lon])
  const size = map.getSize()
  
  const thresholdX = size.x * 0.1
  const thresholdY = size.y * 0.1

  const isNearEdge = 
    point.x < thresholdX || 
    point.x > (size.x - thresholdX) || 
    point.y < thresholdY || 
    point.y > (size.y - thresholdY)

  if (isNearEdge) {
    map.panTo([lat, lon], { animate: true, duration: 0.5 })
  }
}

watch(() => props.points, drawTrack)

watch(() => props.currentIndex, (newIndex) => {
  if (!map || !props.points[newIndex]) return

  const current = props.points[newIndex]

  const icon = L.divIcon({
    className: 'vessel-marker-icon',
    html: `
      <div class="relative w-8 h-8 flex items-center justify-center transition-transform duration-500 ease-linear" style="transform: rotate(${current.course}deg)">
        <div class="w-4 h-6 bg-brand-500 rounded-t-full shadow-lg border-2 border-white"></div>
        <div class="absolute -top-1 w-1 h-1 bg-white rounded-full"></div>
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

  checkAutoPan(current.lat, current.lon)

  // Draw a path already traveled in a vibrant cian
  if (ghostPath) map.removeLayer(ghostPath)
  const traveledPoints = props.points.slice(0, props.currentIndex + 1).map((p) => [p.lat, p.lon])
  ghostPath = L.polyline(traveledPoints as L.LatLngExpression[], {
    color: '#00f2ff', // Cyan vibrante
    weight: 4,
    opacity: 1,
    dashArray: '1, 5', // Style it a bit
  }).addTo(map)
})

// In a real app we would add/remove GeoJSON layers here based on props.activeLayers
watch(() => props.activeLayers, (newLayers) => {
  console.log('Layers updated:', newLayers)
}, { deep: true })

const updateBaseLayer = () => {
  if (!map) return

  const isDark = document.documentElement.classList.contains('dark')

  // Remove previous layer if exists
  if (baseLayer) {
    map.removeLayer(baseLayer)
  }

  if (isDark) {
    // Dark Mode: Esri World Imagery (Satellite)
    // Provides a rich, dark aesthetic without being "flat black"
    baseLayer = L.tileLayer(
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      {
        attribution: 'Tiles &copy; Esri',
        maxZoom: 19,
      },
    )
  } else {
    // Light Mode: CartoDB Voyager
    // Very clean, distinct colors for land/sea, perfect for overlays
    baseLayer = L.tileLayer(
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      {
        attribution: '&copy; OpenStreetMap &copy; CARTO',
        maxZoom: 20,
      },
    )
  }

  baseLayer.addTo(map)
  baseLayer.bringToBack()
}

onMounted(() => {
  initMap()

  // Watch for theme changes (class="dark" on html)
  themeObserver = new MutationObserver(() => updateBaseLayer())
  themeObserver.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['class'],
  })
})

onUnmounted(() => {
  if (themeObserver) themeObserver.disconnect()
  if (map) map.remove()
})
</script>

<style>
.vessel-icon {
  transition: transform 0.3s ease-in-out;
}
</style>
