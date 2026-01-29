<template>
  <div class="relative h-full w-full overflow-hidden bg-surface-muted">
    <div ref="mapContainer" class="h-full w-full"></div>
    
    <!-- Control de Capas (Posicionado sobre el Zoom) -->
    <div class="absolute bottom-[50px] right-[14px] z-[1000] pointer-events-auto">
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
import { ref, onMounted, onUnmounted, watch, computed } from 'vue'
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
}>(), {
  center: () => [-42.5, -60.2],
  zoom: 7,
  minZoom: 3,
  maxZoom: 18,
  showGraticule: true,
  showScale: true
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

// --- Graticule Logic ---
const formatLabel = (val: number) => {
  const absVal = Math.abs(val)
  const deg = Math.floor(absVal)
  const min = Math.round((absVal - deg) * 60)
  return `${val < 0 ? '-' : ''}${deg}°${min > 0 ? min.toString().padStart(2, '0') + "'" : ''}`
}

const updateGraticule = () => {
  if (!map || !localShowGraticule.value) return
  if (!graticuleLayer) {
    graticuleLayer = L.layerGroup().addTo(map)
  }

  graticuleLayer.clearLayers()

  const bounds = map.getBounds()
  const currentZoom = map.getZoom()

  let interval = 1
  if (currentZoom < 5) interval = 5
  else if (currentZoom < 7) interval = 2
  else if (currentZoom > 10) interval = 0.5

  const minLat = Math.floor(bounds.getSouth() / interval) * interval
  const maxLat = Math.ceil(bounds.getNorth() / interval) * interval
  const minLon = Math.floor(bounds.getWest() / interval) * interval
  const maxLon = Math.ceil(bounds.getEast() / interval) * interval

  const isDark = document.documentElement.classList.contains('dark')
  const lineStyle = {
    color: isDark ? 'rgba(255, 255, 255, 0.10)' : 'rgba(0, 0, 0, 0.12)',
    weight: 1,
    interactive: false,
    pane: 'overlayPane'
  }

  const labelIcon = (text: string) => L.divIcon({
    className: 'graticule-label',
    html: `<div class="text-[8px] font-black ${isDark ? 'text-text-muted/40' : 'text-text-muted/70'} uppercase tracking-widest whitespace-nowrap font-sans">${text}</div>`,
    iconSize: [0, 0],
    iconAnchor: [0, 0]
  })

  // Latitude
  for (let lat = minLat; lat <= maxLat; lat += interval) {
    L.polyline([[lat, minLon], [lat, maxLon]], lineStyle).addTo(graticuleLayer)
    const labelText = formatLabel(lat)
    const pLeft = map.latLngToContainerPoint([lat, bounds.getWest()])
    const pRight = map.latLngToContainerPoint([lat, bounds.getEast()])
    L.marker(map.containerPointToLatLng([pLeft.x + 5, pLeft.y]), { icon: labelIcon(labelText), interactive: false, pane: 'tooltipPane' }).addTo(graticuleLayer)
    L.marker(map.containerPointToLatLng([pRight.x - 25, pRight.y]), { icon: labelIcon(labelText), interactive: false, pane: 'tooltipPane' }).addTo(graticuleLayer)
  }

  // Longitude
  for (let lon = minLon; lon <= maxLon; lon += interval) {
    L.polyline([[minLat, lon], [maxLat, lon]], lineStyle).addTo(graticuleLayer)
    const labelText = formatLabel(lon)
    const pTop = map.latLngToContainerPoint([bounds.getNorth(), lon])
    const pBottom = map.latLngToContainerPoint([bounds.getSouth(), lon])
    L.marker(map.containerPointToLatLng([pTop.x, pTop.y + 5]), { icon: labelIcon(labelText), interactive: false, pane: 'tooltipPane' }).addTo(graticuleLayer)
    L.marker(map.containerPointToLatLng([pBottom.x, pBottom.y - 5]), { icon: labelIcon(labelText), interactive: false, pane: 'tooltipPane' }).addTo(graticuleLayer)
  }
}

// --- Custom Nautical Scale ---
class NauticalScale extends L.Control {
  override options: L.ControlOptions & { maxWidth: number }
  private container?: HTMLDivElement
  private line?: HTMLDivElement
  private label?: HTMLDivElement
  private mapInstance: L.Map | null = null

  constructor(options?: Partial<{ position: L.ControlPosition; maxWidth: number }>) {
    const mergedOptions = {
      position: 'bottomright' as L.ControlPosition,
      maxWidth: 100,
      ...options,
    }
    super(mergedOptions)
    this.options = mergedOptions
  }

  onAdd(map: L.Map): HTMLElement {
    this.mapInstance = map
    this.container = L.DomUtil.create('div', 'nautical-scale-container')
    this.label = L.DomUtil.create('div', 'nautical-scale-label', this.container)
    this.line = L.DomUtil.create('div', 'nautical-scale-bar', this.container)

    map.on('move', this.updateScale, this)
    map.whenReady(this.updateScale, this)
    return this.container
  }

  onRemove(map: L.Map): void {
    map.off('move', this.updateScale, this)
    this.mapInstance = null
  }

  private updateScale = () => {
    if (!this.mapInstance || !this.line || !this.label) return
    const mapSize = this.mapInstance.getSize()
    const y = mapSize.y / 2
    const maxMeters = this.mapInstance.distance(
      this.mapInstance.containerPointToLatLng([0, y]),
      this.mapInstance.containerPointToLatLng([this.options.maxWidth, y]),
    )
    const maxNM = maxMeters / 1852
    const nm = this.getRoundNum(maxNM)
    const px = (nm * 1852 * this.options.maxWidth) / maxMeters

    this.line.style.width = `${px}px`
    // Redondear para evitar decimales infinitos (ej. 0.3000...004)
    const displayNM = nm < 1 ? nm.toFixed(1) : Math.round(nm)
    this.label.innerHTML = `${displayNM} NM`
  }

  private getRoundNum(num: number) {
    const pow10 = Math.pow(10, Math.floor(Math.log10(num)))
    let d = num / pow10
    d = d >= 10 ? 10 : d >= 5 ? 5 : d >= 3 ? 3 : d >= 2 ? 2 : 1
    return pow10 * d
  }
}

// --- Layers handling ---
const currentBaseId = ref('carto-voyager')
const activeOverlayIds = ref<string[]>([])
const overlayLayersMap = new Map<string, L.TileLayer>()

const setBaseLayer = (id: string) => {
  if (!map) return
  const layerDef = BASE_LAYERS.find(l => l.id === id)
  if (!layerDef) return

  if (baseLayer) map.removeLayer(baseLayer)
  
  baseLayer = L.tileLayer(layerDef.url, { 
    attribution: layerDef.attribution, 
    maxZoom: layerDef.maxZoom || 18 
  })
  
  baseLayer.addTo(map)
  baseLayer.bringToBack()
  currentBaseId.value = id
}

const toggleOverlay = (id: string) => {
  if (!map) return
  const layerDef = OVERLAY_LAYERS.find(l => l.id === id)
  if (!layerDef) return

  const existing = overlayLayersMap.get(id)
  if (existing) {
    map.removeLayer(existing)
    overlayLayersMap.delete(id)
    activeOverlayIds.value = activeOverlayIds.value.filter(oid => oid !== id)
  } else {
    const newOverlay = L.tileLayer(layerDef.url, {
      attribution: layerDef.attribution,
      maxZoom: layerDef.maxZoom || 18,
      pane: 'overlayPane'
    })
    newOverlay.addTo(map)
    overlayLayersMap.set(id, newOverlay)
    activeOverlayIds.value.push(id)
  }
}

const toggleGraticule = (val: boolean) => {
  localShowGraticule.value = val
  if (val) {
    if (!graticuleLayer) {
      graticuleLayer = L.layerGroup().addTo(map!)
    }
    setTimeout(() => updateGraticule(), 50) // Un poco más de tiempo para estar seguros
  } else if (graticuleLayer) {
    graticuleLayer.clearLayers()
  }
}

const updateBaseLayerByTheme = () => {
  if (!map) return
  const isDark = document.documentElement.classList.contains('dark')
  const targetId = isDark ? 'carto-dark' : 'carto-voyager'
  setBaseLayer(targetId)
}

onMounted(() => {
  if (!mapContainer.value) return

  map = L.map(mapContainer.value, {
    zoomControl: false,
    attributionControl: false,
    minZoom: props.minZoom,
    maxZoom: props.maxZoom
  }).setView(props.center, props.zoom)

  updateBaseLayerByTheme()
  L.control.zoom({ position: 'bottomright' }).addTo(map)

  if (props.showScale) {
    new NauticalScale().addTo(map)
  }

  map.on('mousemove', (e: L.LeafletMouseEvent) => {
    emit('mousemove', e)
  })

  map.on('moveend zoomend', updateGraticule)
  updateGraticule()

  // Theme observer
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

// Watchers for reactive props
watch(() => props.center, (newVal) => map?.setView(newVal))
watch(() => props.zoom, (newVal) => map?.setZoom(newVal))
watch(() => props.showGraticule, (show) => {
  if (show) updateGraticule()
  else if (graticuleLayer) graticuleLayer.clearLayers()
})

defineExpose({
  getMap: () => map
})
</script>

<style>
/* Ajustes de controles de Leaflet */
.leaflet-bottom.leaflet-right .leaflet-control-zoom {
  margin-bottom: 24px !important;
  margin-right: 14px !important;
  border: none !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

/* --- Nautical Scale Redesign --- */
.nautical-scale-container {
  margin-right: 14px !important;
  margin-bottom: 160px !important;
  /* Arriba de todos los controles */
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

/* Graticule labels */
.graticule-label {
  pointer-events: none !important;
}
</style>
