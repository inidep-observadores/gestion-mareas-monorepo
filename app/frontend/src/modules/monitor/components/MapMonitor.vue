<template>
  <NauticalMap ref="nauticalMap" :show-controls="!isMobile" @map-ready="onMapReady" @mousemove="emit('update:mouse-coords', $event.latlng)">
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
  lastKnownPoint?: FleetTrackPoint | null
  currentIndex: number
  visible: boolean
  matricula?: string
  mareaCode?: string
  mareaStatus?: string
  observer?: string
  voyageStart?: string | null
  voyageEnd?: string | null
  lastUpdate?: string | Date | null
  totalDays?: number
  pesquerias_nombres?: string[]
  flota?: string
  etapas?: any[] // eslint-disable-line @typescript-eslint/no-explicit-any
}

const props = defineProps<{
  fleet: Record<string, VesselTrajectory>
  activeLayers: {
    veda: boolean;
    vieira: boolean;
    centolla: boolean;
    points: boolean;
    showAllVessels: boolean;
    showVesselNames: boolean;
  }
  isMobile?: boolean
  filterPesqueria: string
}>()

const emit = defineEmits(['update:mouse-coords', 'seek-vessel', 'select-vessel'])

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
    // FILTRO DE PESQUERÍA: Solo procesar buques que coincidan con la pesquería seleccionada
    if (props.filterPesqueria && !vessel.pesquerias_nombres?.includes(props.filterPesqueria)) {
      return
    }

    const hasHistory = vessel.points.length > 0

    // Solo renderizar trayectoria si es visible (seleccionado) y tiene datos
    if (vessel.visible && hasHistory) {
      renderTrajectory(vessel)
      if (props.activeLayers.points) {
        renderPoints(vessel)
      }
    }

    // Renderizar marcador si showAllVessels es true o si es el buque seleccionado
    if (props.activeLayers.showAllVessels || vessel.visible) {
      renderMarker(vessel)
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
  // Si tiene puntos de trayectoria, usamos el índice actual o el último
  // Si no tiene puntos todavía, usamos el lastKnownPoint de la carga inicial
  let current: FleetTrackPoint | null = null

  if (vessel.points.length > 0) {
    const pointIndex = vessel.visible ? vessel.currentIndex : (vessel.points.length - 1)
    current = vessel.points[pointIndex]
  } else {
    current = vessel.lastKnownPoint || null
  }

  if (!current) return

  const icon = L.divIcon({
    className: 'vessel-marker-container',
    html: `
      <div class="vessel-marker-wrapper ${vessel.visible ? 'is-active' : ''}" style="--vessel-color: ${vessel.color}; --vessel-rotation: ${current.course}deg; transform: rotate(${current.course}deg)">
        <svg viewBox="0 0 40 40" class="vessel-svg">
          <!-- Background Halo for high contrast against same-colored trajectories -->
          <path d="M20 4 C22.5 4 26 10 26 24 L26 34 Q26 36 20 36 Q14 36 14 34 L14 24 C14 10 17.5 4 20 4 Z" class="vessel-hull-halo" />
          
          <!-- Main Hull -->
          <path d="M20 4 C22.5 4 26 10 26 24 L26 34 Q26 36 20 36 Q14 36 14 34 L14 24 C14 10 17.5 4 20 4 Z" class="vessel-hull" fill="${vessel.color}" />
          
          <!-- Bridge / Cabin (Center-Forward) -->
          <rect x="17" y="14" width="6" height="6" rx="1" class="vessel-bridge" />
          <rect x="18.5" y="10" width="3" height="4" rx="0.5" class="vessel-bridge-upper" />
          
          <!-- Deck Lines -->
          <line x1="15" y1="22" x2="25" y2="22" class="vessel-deck-line" />
          <line x1="15" y1="28" x2="25" y2="28" class="vessel-deck-line" />
          
          <!-- Bow Detail (Pointer) -->
          <path d="M18.5 6 L20 3 L21.5 6" fill="white" />
        </svg>
      </div>
    `,
    iconSize: [36, 36],
    iconAnchor: [18, 18],
  })

  // interactive: true para permitir clics
  // zIndexOffset: 1000 para que el seleccionado flote sobre los demás
  const marker = L.marker([current.lat, current.lon], {
    icon,
    interactive: true,
    zIndexOffset: vessel.visible ? 1000 : 0
  }).addTo(markersLayer)

  const showNames = props.activeLayers.showVesselNames

  // HTML para versión simple vs HUD detallada
  const simpleContent = `<div class="tooltip-simple-name">${vessel.name}</div>`
  const mareaLabel = vessel.mareaCode ? `<span class="tooltip-marea">${vessel.mareaCode}</span>` : ''
  const statusLabel = vessel.mareaStatus === 'DESIGNADA' ? '<span class="tooltip-status">Designado</span>' : ''
  const hudContent = `
    <div class="vessel-tooltip-content">
      <span class="tooltip-name">${vessel.name}</span>
      ${mareaLabel}
      ${statusLabel}
    </div>
  `

  // Vincular tooltip inicial (Simple)
  marker.bindTooltip(simpleContent, {
    permanent: showNames,
    direction: 'top',
    className: 'vessel-tooltip-simple'
  })

  if (!props.isMobile) {
    // Eventos para intercambio dinámico solo en desktop
    marker.on('mouseover', () => {
      marker.setTooltipContent(hudContent)
      // Cambiamos la clase al elemento del tooltip para aplicar estilos HUD
      const el = marker.getTooltip()?.getElement()
      if (el) {
        el.classList.add('vessel-tooltip-hud')
        el.classList.remove('vessel-tooltip-simple')
      }
      marker.openTooltip()
    })

    marker.on('mouseout', () => {
      marker.setTooltipContent(simpleContent)
      const el = marker.getTooltip()?.getElement()
      if (el) {
        el.classList.add('vessel-tooltip-simple')
        el.classList.remove('vessel-tooltip-hud')
      }
      if (!props.activeLayers.showVesselNames) {
        marker.closeTooltip()
      }
    })
  }

  marker.on('click', () => {
    emit('select-vessel', vessel.id)
  })

  vesselMarkers.set(vessel.id, marker)
}

// Configuración de límites de visualización para rendimiento
import { MAX_DISPLAY_POINTS } from '../constants'

const renderPoints = (vessel: VesselTrajectory) => {
  const total = vessel.points.length
  // Calculamos el salto necesario para no superar el límite
  const step = Math.max(1, Math.ceil(total / MAX_DISPLAY_POINTS))

  vessel.points.forEach((p, idx) => {
    // Dibujamos el punto si cumple el salto O si es el último (posición actual)
    const isLast = idx === total - 1
    if (idx % step !== 0 && !isLast) return

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
watch(() => props.activeLayers.showAllVessels, updateAll)
watch(() => props.activeLayers.showVesselNames, updateAll)
watch(() => props.filterPesqueria, () => {
  updateAll()
  setTimeout(() => {
    fitAllVesselsBounds()
  }, 100)
})

const fitVesselBounds = (vesselId: string) => {
  if (!map) return
  const vessel = props.fleet[vesselId]
  if (!vessel || vessel.points.length === 0) return

  const bounds = L.latLngBounds(vessel.points.map(p => [p.lat, p.lon]))
  map.fitBounds(bounds, { padding: [50, 50], animate: true })
}

const fitAllVesselsBounds = () => {
  if (!map) return
  const currentPoints: L.LatLngExpression[] = []

  Object.values(props.fleet).forEach(vessel => {
    // FILTRO DE PESQUERÍA: Solo incluir buques que coincidan con la pesquería seleccionada
    if (props.filterPesqueria && !vessel.pesquerias_nombres?.includes(props.filterPesqueria)) {
      return
    }

    let current: FleetTrackPoint | null = null
    if (vessel.points.length > 0) {
      const pointIndex = vessel.visible ? vessel.currentIndex : (vessel.points.length - 1)
      current = vessel.points[pointIndex]
    } else {
      current = vessel.lastKnownPoint || null
    }

    if (current) {
      currentPoints.push([current.lat, current.lon])
    }
  })

  if (currentPoints.length === 0) return

  const bounds = L.latLngBounds(currentPoints)
  map.fitBounds(bounds, { padding: [100, 100], animate: true })
}

const invalidateSize = () => {
  if (map) {
    map.invalidateSize({ animate: true })
  }
}

const setBaseLayer = (id: string) => {
  if (nauticalMap.value) {
    nauticalMap.value.setBaseLayer(id)
  }
}

defineExpose({ fitVesselBounds, fitAllVesselsBounds, invalidateSize, setBaseLayer })

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
/* Variables locales para opacidad si no están en el global */
:root {
  --color-surface-rgb: 255, 255, 255;
  /* Light surface */
  --color-text-rgb: 15, 23, 42;
  /* Light text */
}

.dark {
  --color-surface-rgb: 15, 23, 42;
  /* Dark surface */
  --color-text-rgb: 241, 245, 249;
  /* Dark text */
}

/* Tooltips HUD Estilizados */
.leaflet-tooltip.vessel-tooltip-hud {
  background: rgba(var(--color-surface-rgb), 0.98) !important;
  backdrop-filter: blur(12px) !important;
  -webkit-backdrop-filter: blur(12px) !important;
  border: 1px solid rgba(var(--color-primary-rgb), 0.5) !important;
  border-radius: 14px !important;
  padding: 12px 16px !important;
  box-shadow: 0 12px 40px -10px rgba(0, 0, 0, 0.8) !important;
  z-index: 2000 !important;
}

/* Tooltip Simple (Solo nombre) */
.leaflet-tooltip.vessel-tooltip-simple {
  background: rgba(var(--color-surface-rgb), 0.95) !important;
  backdrop-filter: blur(8px) !important;
  border: 1px solid rgba(var(--color-text-rgb), 0.3) !important;
  border-radius: 8px !important;
  padding: 6px 12px !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5) !important;
  pointer-events: none !important;
}

.vessel-tooltip-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 8px;
  color: var(--color-text);
  font-family: 'Inter', sans-serif;
  min-width: 150px;
}

.tooltip-simple-name {
  font-weight: 900;
  text-transform: uppercase;
  font-size: 10px;
  letter-spacing: 0.1em;
  color: var(--color-text);
}

.tooltip-name {
  font-weight: 900;
  text-transform: uppercase;
  font-size: 12px;
  letter-spacing: 0.08em;
  color: var(--color-text);
  border-bottom: 2px solid rgba(var(--color-text-rgb), 0.2);
  padding-bottom: 6px;
  margin-bottom: 4px;
  width: 100%;
}

.tooltip-marea {
  color: var(--color-primary);
  font-weight: 800;
  font-size: 11px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  background: rgba(var(--color-primary-rgb), 0.15);
  padding: 3px 10px;
  border-radius: 6px;
}

.tooltip-marea::before {
  content: 'MAREA';
  font-size: 8px;
  font-weight: 900;
  opacity: 0.8;
  letter-spacing: 0.05em;
  color: var(--color-text-muted);
}

.tooltip-status {
  color: var(--color-warning);
  font-size: 10px;
  text-transform: uppercase;
  font-weight: 950;
  letter-spacing: 0.1em;
  background: rgba(var(--color-warning-rgb), 0.2);
  padding: 4px 10px;
  border-radius: 6px;
  width: fit-content;
  border: 1px solid rgba(var(--color-warning-rgb), 0.3);
  margin-top: 2px;
}

.tooltip-permanent {
  pointer-events: none !important;
}

/* Triángulo del tooltip */
.leaflet-tooltip-top.vessel-tooltip-hud:before,
.leaflet-tooltip-top.vessel-tooltip-simple:before {
  border-top-color: rgba(var(--color-surface-rgb), 0.98) !important;
}

.interactive-trajectory,
.interactive-dot {
  cursor: pointer !important;
}

/* MARCADOR DE BUQUE PREMIUM */
.vessel-marker-container {
  overflow: visible !important;
}

.vessel-marker-wrapper {
  position: relative;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
}

.vessel-marker-wrapper.is-active {
  z-index: 1000;
  filter: drop-shadow(0 4px 12px rgba(var(--color-primary-rgb), 0.4));
  animation: vessel-pulse 2s infinite cubic-bezier(0.4, 0, 0.6, 1);
}

@keyframes vessel-pulse {

  0%,
  100% {
    transform: scale(1) rotate(var(--vessel-rotation, 0deg));
  }

  50% {
    transform: scale(1.15) rotate(var(--vessel-rotation, 0deg));
  }
}

.vessel-marker-wrapper.is-active .vessel-hull-halo {
  stroke-width: 5;
  stroke: white;
  opacity: 1;
}

.vessel-svg {
  width: 100%;
  height: 100%;
}

.vessel-hull-halo {
  fill: none;
  stroke: white;
  stroke-width: 3.5;
  stroke-linejoin: round;
  opacity: 1;
}

.vessel-hull {
  stroke: rgba(0, 0, 0, 0.4);
  stroke-width: 0.6;
  transition: all 0.3s ease;
}

.vessel-bridge {
  fill: rgba(255, 255, 255, 0.6);
}

.vessel-bridge-upper {
  fill: rgba(255, 255, 255, 0.6);
}

.vessel-deck-line {
  stroke: rgba(0, 0, 0, 0.2);
  stroke-width: 0.8;
}

.vessel-marker-wrapper:hover {
  cursor: pointer;
}

/* Ajustes de controles de Leaflet */
.leaflet-bottom.leaflet-right .leaflet-control-zoom {
  margin-bottom: 94px !important;
  margin-right: 14px !important;
  border: none !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

.leaflet-control-zoom a {
  background-color: rgba(var(--color-surface-rgb), 0.5) !important;
  color: var(--color-text) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
  border: 1px solid rgba(var(--color-text-rgb), 0.1) !important;
  transition: all 0.3s ease !important;
}

.leaflet-control-zoom a:hover {
  background-color: var(--color-primary) !important;
  color: white !important;
}
</style>
