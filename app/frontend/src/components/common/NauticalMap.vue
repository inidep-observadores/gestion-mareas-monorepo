<template>
  <div class="relative h-full w-full overflow-hidden bg-surface-muted" :class="{ 'hide-zoom-controls': !showControls }">
    <div ref="mapContainer" class="h-full w-full"></div>

    <!-- Leyenda de error de clima (Watermark) -->
    <div v-if="hasOverlayError"
      class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-[1000] pointer-events-none px-6 py-4 rounded-xl bg-gray-900/40 dark:bg-black/50 backdrop-blur-md border border-white/10 text-center shadow-2xl transition-all duration-500 max-w-[80%]">
      <span class="text-sm font-medium text-white/90 drop-shadow-md">
        En este momento no hay datos disponibles de clima y pronóstico
      </span>
    </div>

    <!-- Control de Capas (Posicionado sobre el Zoom) -->
    <div v-if="showControls" class="absolute bottom-[50px] right-[14px] z-[1000] pointer-events-auto">
      <MapLayerControl :base-layers="BASE_LAYERS" :overlay-layers="OVERLAY_LAYERS" :current-base-id="currentBaseId"
        :active-overlay-ids="activeOverlayIds" :show-graticule="localShowGraticule" @change-base="setBaseLayer"
        @toggle-overlay="toggleOverlay" @update:show-graticule="toggleGraticule" />
    </div>

    <!-- Control de Tiempo (Solo si hay capas con tiempo activo) -->
    <div v-if="hasTimeEnabledLayer"
      :class="['absolute left-1/2 -translate-x-1/2 z-[1000] pointer-events-auto w-full max-w-sm px-4', showControls ? 'bottom-[50px]' : 'bottom-[100px]']">
      <MapTimeSlider @time-change="onTimeChange" @opacity-change="onOpacityChange" />
    </div>

    <slot></slot>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'
import MapLayerControl from './MapLayerControl.vue'
import MapTimeSlider from './MapTimeSlider.vue'
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

const currentBaseId = ref('argenmap-mapa-base')
const activeOverlayIds = ref<string[]>([])
const failingOverlayIds = ref<string[]>([])

const hasOverlayError = computed(() => failingOverlayIds.value.length > 0)

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
  const layerDef = OVERLAY_LAYERS.find(l => l.id === id)
  if (!layerDef || !map) return

  if (index === -1) {
    activeOverlayIds.value.push(id)
    
    let newLayer: L.Layer
    if (layerDef.layers) {
      newLayer = L.tileLayer.wms(layerDef.url, {
        layers: layerDef.layers,
        styles: layerDef.styles || '',
        format: layerDef.format || 'image/png',
        transparent: layerDef.transparent ?? true,
        attribution: layerDef.attribution,
        maxZoom: layerDef.maxZoom,
        opacity: layerDef.defaultOpacity || 1,
        version: '1.3.0',
        zIndex: layerDef.zIndex ?? 10
        // time is intentionally omitted on init to let the server pick the default time
      })
    } else {
      newLayer = L.tileLayer(layerDef.url, {
        attribution: layerDef.attribution,
        maxZoom: layerDef.maxZoom,
        opacity: layerDef.defaultOpacity || 1,
        zIndex: layerDef.zIndex ?? 1
      })
    }
    
    // Z-index para asegurar que quede por debajo de los tracking y marcadores
    // Leaflet por defecto pone los tile layers en el tilePane que esta debajo del markerPane
    newLayer.addTo(map)
    activeOverlayLayers.set(id, newLayer)

    // Manejo de errores de carga de tiles
    newLayer.on('tileerror', () => {
      if (!failingOverlayIds.value.includes(id)) {
        failingOverlayIds.value.push(id)
      }
    })

    newLayer.on('tileload', () => {
      const failIndex = failingOverlayIds.value.indexOf(id)
      if (failIndex !== -1) {
        failingOverlayIds.value.splice(failIndex, 1)
      }
    })

  } else {
    activeOverlayIds.value.splice(index, 1)

    const failIndex = failingOverlayIds.value.indexOf(id)
    if (failIndex !== -1) {
      failingOverlayIds.value.splice(failIndex, 1)
    }

    const layerToRemove = activeOverlayLayers.get(id)
    if (layerToRemove) {
      map.removeLayer(layerToRemove)
      activeOverlayLayers.delete(id)
    }
  }
}

const activeOverlayLayers = new Map<string, L.Layer>()

const hasTimeEnabledLayer = computed(() => {
  return activeOverlayIds.value.some(id => {
    const def = OVERLAY_LAYERS.find(l => l.id === id)
    return def?.hasTime
  })
})

const onTimeChange = (isoTime: string, hoursOffset: number) => {
  activeOverlayLayers.forEach((layer, id) => {
    const def = OVERLAY_LAYERS.find(l => l.id === id)
    if (def?.hasTime && layer instanceof L.TileLayer.WMS) {
      if (!isoTime) {
        delete (layer as any).wmsParams.time
        layer.setParams({} as any)
      } else {
        layer.setParams({ time: isoTime } as any)
      }
    }
  })
}

const onOpacityChange = (opacity: number) => {
  activeOverlayLayers.forEach((layer, id) => {
    const def = OVERLAY_LAYERS.find(l => l.id === id)
    if (def?.hasTime && 'setOpacity' in layer) {
      (layer as L.TileLayer).setOpacity(opacity)
    }
  })
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

    // Formatear coordenadas para humanos
    const formatCoord = (val: number, isLat: boolean) => {
      const abs = Math.abs(val)
      const suffix = isLat ? (val >= 0 ? 'N' : 'S') : (val >= 0 ? 'E' : 'W')
      // Si el intervalo es decimal, mostrar un decimal en la etiqueta
      const fixed = interval < 1 ? 1 : 0
      return `${abs.toFixed(fixed)}°${suffix}`
    }

    for (let lat = latMin; lat <= latMax; lat += interval) {
      // Línea de latitud
      L.polyline([[lat, lonMin], [lat, lonMax]], {
        color: 'var(--color-text)',
        weight: 0.5,
        opacity: 0.35,
        dashArray: '5, 5',
        interactive: false,
        className: 'graticule-line'
      }).addTo(graticuleLayer)

      // Etiqueta de latitud (en los bordes izquierdo y derecho visibles)
      const latLabel = formatCoord(lat, true)
      // Borde izquierdo
      L.marker([lat, bounds.getWest()], {
        icon: L.divIcon({
          className: 'graticule-label graticule-label-lat',
          html: `<span>${latLabel}</span>`,
          iconSize: [40, 12],
          iconAnchor: [-8, 6] // Un poco más adentro (8px)
        }),
        interactive: false,
        zIndexOffset: 1000
      }).addTo(graticuleLayer)

      // Borde derecho
      L.marker([lat, bounds.getEast()], {
        icon: L.divIcon({
          className: 'graticule-label graticule-label-lat',
          html: `<span>${latLabel}</span>`,
          iconSize: [40, 12],
          iconAnchor: [48, 6] // 40px de ancho + 8px de margen hacia la izquierda
        }),
        interactive: false,
        zIndexOffset: 1000
      }).addTo(graticuleLayer)
    }

    for (let lon = lonMin; lon <= lonMax; lon += interval) {
      // Línea de longitud
      L.polyline([[latMin, lon], [latMax, lon]], {
        color: 'var(--color-text)',
        weight: 0.5,
        opacity: 0.35,
        dashArray: '5, 5',
        interactive: false,
        className: 'graticule-line'
      }).addTo(graticuleLayer)

      // Etiqueta de longitud (en el borde inferior visible)
      const lonLabel = formatCoord(lon, false)
      L.marker([bounds.getSouth(), lon], {
        icon: L.divIcon({
          className: 'graticule-label graticule-label-lon',
          html: `<span>${lonLabel}</span>`,
          iconSize: [60, 12],
          iconAnchor: [30, 20] // 12px de alto + 8px de margen hacia arriba
        }),
        interactive: false,
        zIndexOffset: 1000
      }).addTo(graticuleLayer)

      // Añadir también en el borde superior para asegurar visibilidad si el inferior está tapado
      L.marker([bounds.getNorth(), lon], {
        icon: L.divIcon({
          className: 'graticule-label graticule-label-lon',
          html: `<span>${lonLabel}</span>`,
          iconSize: [60, 12],
          iconAnchor: [30, -8] // 8px de margen hacia abajo desde el borde superior
        }),
        interactive: false,
        zIndexOffset: 1000
      }).addTo(graticuleLayer)
    }
  }
}

const updateBaseLayerByTheme = () => {
  const isDark = document.documentElement.classList.contains('dark')
  const defaultId = isDark ? 'argenmap-oscuro' : 'argenmap-mapa-base'
  setBaseLayer(defaultId)
}

const NauticalScale = L.Control.extend({
  onAdd: function (map: L.Map) {
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
  setBaseLayer,
  toggleOverlay,
  toggleGraticule
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
  font-family: 'Inter', sans-serif;
  font-size: 7px;
  font-weight: 600;
  color: var(--color-text);
  opacity: 0.7;
  text-shadow: 0 0 4px var(--color-surface);
  white-space: nowrap;
}

.graticule-label-lat span {
  display: block;
  text-align: left;
}

.graticule-label-lon span {
  display: block;
  text-align: center;
}

/* Ocultar controles de zoom en móvil */
.hide-zoom-controls .leaflet-control-zoom {
  display: none !important;
}
</style>
