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

const initMap = () => {
  if (!mapContainer.value) return

  map = L.map(mapContainer.value, {
    zoomControl: false,
    attributionControl: false,
  }).setView([-42.5, -60.2], 7)

  // Initialize with correct theme
  updateBaseLayer()

  L.control.zoom({ position: 'bottomright' }).addTo(map)

  trackLayer = L.featureGroup().addTo(map)
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

const updateVesselPos = () => {
  if (!map || !props.points[props.currentIndex]) return

  const current = props.points[props.currentIndex]

  if (!vesselMarker) {
    const vesselIcon = L.divIcon({
      html: `<div class="vessel-icon" style="transform: rotate(${current.course}deg)">
               <svg viewBox="0 0 24 24" class="w-8 h-8 text-brand-500 drop-shadow-lg" fill="currentColor">
                 <path d="M12 2L4.5 20.29L5.21 21L12 18L18.79 21L19.5 20.29L12 2Z" />
               </svg>
             </div>`,
      className: '',
      iconSize: [32, 32],
      iconAnchor: [16, 16],
    })
    vesselMarker = L.marker([current.lat, current.lon], { icon: vesselIcon }).addTo(map)
  } else {
    vesselMarker.setLatLng([current.lat, current.lon])
    const iconEl = vesselMarker.getElement()
    if (iconEl) {
      const svgContainer = iconEl.querySelector('.vessel-icon') as HTMLElement
      if (svgContainer) svgContainer.style.transform = `rotate(${current.course}deg)`
    }
  }

  // Draw a path already traveled in a vibrant cian
  if (ghostPath) map.removeLayer(ghostPath)
  const traveledPoints = props.points.slice(0, props.currentIndex + 1).map((p) => [p.lat, p.lon])
  ghostPath = L.polyline(traveledPoints as L.LatLngExpression[], {
    color: '#00f2ff', // Cyan vibrante
    weight: 4,
    opacity: 1,
    dashArray: '1, 5', // Style it a bit
  }).addTo(map)
}

watch(() => props.points, drawTrack)
watch(() => props.currentIndex, updateVesselPos)

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
