<template>
  <div class="relative h-full w-full overflow-hidden bg-surface-muted" :class="{ 'hide-zoom-controls': !showControls }">
    <div ref="mapContainer" class="h-full w-full"></div>
    
    <!-- Control de Capas (Posicionado sobre el Zoom) -->
    <div v-if="showControls" class="absolute bottom-[50px] right-[14px] z-[1000] pointer-events-auto">
      <MapLayerControl
        :base-layers="BASE_LAYERS"
        :overlay-layers="OVERLAY_LAYERS"
        :current-base-id="currentBaseId"
        :active-overlay-ids="activeOverlayIds"
        :show-graticule="localShowGraticule"
        @change-base="setBaseLayer"
        @toggle-overlay="toggleOverlay"
        @update:show-graticule="toggleGraticule"
      />
    </div>

    <slot></slot>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import MapLayerControl from './MapLayerControl.vue'
import { BASE_LAYERS, OVERLAY_LAYERS } from './map-layers'

const props = withDefaults(defineProps<{
  center?: [number, number]
  zoom?: number
  minZoom?: number
  maxZoom?: number
  showGraticule?: boolean
  showScale?: boolean
  showControls?: boolean
}>(), {
  center: () => [-42.5, -60.2],
  zoom: 7,
  minZoom: 3,
  maxZoom: 18,
  showGraticule: true,
  showScale: true,
  showControls: true
})

const localShowGraticule = ref(props.showGraticule)
watch(() => props.showGraticule, (newVal) => {
  localShowGraticule.value = newVal
})

const emit = defineEmits<{
  (e: 'map-ready', map: L.Map): void
  (e: 'mousemove', event: L.LeafletMouseEvent): void
}>()

const mapContainer = ref<HTMLElement | null>(null)
let map: L.Map | null = null
let baseLayer: L.TileLayer | null = null
let graticuleLayer: L.LayerGroup | null = null
let themeObserver: MutationObserver | null = null

const currentBaseId = ref('carto-voyager')
const activeOverlayIds = ref<string[]>([])

const setBaseLayer = (id: string) => {
  if (!map) return
  const layerDef = BASE_LAYERS.find(l => l.id === id)
  if (!layerDef) return

  if (baseLayer) {
    map.removeLayer(baseLayer)
  }

  baseLayer = L.tileLayer(layerDef.url, {
    attribution: layerDef.attribution,
    maxZoom: layerDef.maxZoom
  }).addTo(map)
  currentBaseId.value = id
}

const toggleOverlay = (id: string) => {
  const index = activeOverlayIds.value.indexOf(id)
  if (index === -1) {
    activeOverlayIds.value.push(id)
  } else {
    activeOverlayIds.value.splice(index, 1)
  }
}

const toggleGraticule = (val: boolean) => {
  localShowGraticule.value = val
  updateGraticule()
}

const updateGraticule = () => {
  if (!map) return
  
  if (graticuleLayer) {
    map.removeLayer(graticuleLayer)
    graticuleLayer = null
  }

  if (localShowGraticule.value) {
    graticuleLayer = L.layerGroup().addTo(map)
    const bounds = map.getBounds()
    const zoom = map.getZoom()
    
    let interval = 5
    if (zoom > 10) interval = 0.1
    else if (zoom > 8) interval = 0.5
    else if (zoom > 6) interval = 1
    else if (zoom > 4) interval = 2

    const latMin = Math.floor(bounds.getSouth() / interval) * interval
    const latMax = Math.ceil(bounds.getNorth() / interval) * interval
    const lonMin = Math.floor(bounds.getWest() / interval) * interval
    const lonMax = Math.ceil(bounds.getEast() / interval) * interval

    for (let lat = latMin; lat <= latMax; lat += interval) {
      L.polyline([[lat, lonMin], [lat, lonMax]], {
        color: 'var(--color-text)',
        weight: 0.5,
        opacity: 0.15,
        dashArray: '5, 5',
        interactive: false,
        className: 'graticule-line'
      }).addTo(graticuleLayer)
    }

    for (let lon = lonMin; lon <= lonMax; lon += interval) {
      L.polyline([[latMin, lon], [latMax, lon]], {
        color: 'var(--color-text)',
        weight: 0.5,
        opacity: 0.15,
        dashArray: '5, 5',
        interactive: false,
        className: 'graticule-line'
      }).addTo(graticuleLayer)
    }
  }
}

const updateBaseLayerByTheme = () => {
  const isDark = document.documentElement.classList.contains('dark')
  const defaultId = isDark ? 'carto-dark' : 'carto-voyager'
  setBaseLayer(defaultId)
}

const NauticalScale = L.Control.extend({
  onAdd: function(map: L.Map) {
    const container = L.DomUtil.create('div', 'nautical-scale-container')
    const label = L.DomUtil.create('div', 'nautical-scale-label', container)
    const bar = L.DomUtil.create('div', 'nautical-scale-bar', container)
    
    const update = () => {
      const center = map.getCenter()
      const zoom = map.getZoom()
      const latRad = center.lat * Math.PI / 180
      const milesPerPixel = (21639 * Math.cos(latRad)) / Math.pow(2, zoom + 8)
      const targetMiles = 100 * milesPerPixel
      let miles = 1
      if (targetMiles > 500) miles = 500
      else if (targetMiles > 250) miles = 250
      else if (targetMiles > 100) miles = 100
      else if (targetMiles > 50) miles = 50
      else if (targetMiles > 25) miles = 25
      else if (targetMiles > 10) miles = 10
      else if (targetMiles > 5) miles = 5
      else if (targetMiles > 2) miles = 2
      
      const width = miles / milesPerPixel
      bar.style.width = width + 'px'
      label.innerHTML = miles + ' NM'
    }

    map.on('move zoom', update)
    update()
    return container
  }
})

onMounted(() => {
  if (!mapContainer.value) return

  map = L.map(mapContainer.value, {
    zoomControl: false,
    attributionControl: false,
    minZoom: props.minZoom,
    maxZoom: props.maxZoom
  }).setView(props.center, props.zoom)

  updateBaseLayerByTheme()
  
  if (props.showControls) {
    L.control.zoom({ position: 'bottomright' }).addTo(map)
  }

  if (props.showScale) {
    // @ts-ignore - Leaflet custom control types
    const scalePosition = props.showControls ? 'bottomright' : 'bottomleft'
    new NauticalScale({ position: scalePosition }).addTo(map)
  }

  map.on('mousemove', (e: L.LeafletMouseEvent) => {
    emit('mousemove', e)
  })

  map.on('moveend zoomend', updateGraticule)
  updateGraticule()

  themeObserver = new MutationObserver(() => updateBaseLayerByTheme())
  themeObserver.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['class'],
  })

  emit('map-ready', map)
})

onUnmounted(() => {
  if (themeObserver) themeObserver.disconnect()
  if (map) map.remove()
})

defineExpose({
  getMap: () => map,
  setBaseLayer
})
</script>

<style>
.leaflet-bottom.leaflet-right .leaflet-control-zoom {
  margin-bottom: 24px !important;
  margin-right: 14px !important;
  border: none !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

.nautical-scale-container {
  margin-left: 14px !important;
  margin-right: 14px !important;
  margin-bottom: 24px !important;
  display: flex;
  flex-direction: column;
  align-items: center;
  pointer-events: none;
  filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.3));
}

.nautical-scale-label {
  font-family: 'Inter', sans-serif;
  font-size: 9px !important;
  font-weight: 900 !important;
  color: var(--color-text) !important;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  margin-bottom: 2px;
  text-shadow: 0 0 4px var(--color-surface);
}

.nautical-scale-bar {
  height: 4px;
  border: 1.5px solid var(--color-text);
  border-top: none;
  box-sizing: border-box;
  transition: width 0.2s ease;
}

.graticule-label {
  pointer-events: none !important;
}

/* Ocultar controles de zoom en móvil */
.hide-zoom-controls .leaflet-control-zoom {
  display: none !important;
}
</style>
