import { ref, readonly } from 'vue'
import { userLayersStorage, type UserMapLayer } from '../services/userLayers.storage'

const PALETTE = ['#6366F1', '#14B8A6', '#F97316', '#A855F7', '#06B6D4', '#EC4899']
const MAX_FILE_BYTES = 20 * 1024 * 1024
const VALID_TYPES = ['FeatureCollection', 'Feature', 'GeometryCollection', 'Point', 'MultiPoint',
  'LineString', 'MultiLineString', 'Polygon', 'MultiPolygon']

// Estado compartido (singleton): lo consumen el mapa y los paneles de capas
const layers = ref<UserMapLayer[]>([])
const loaded = ref(false)
let loading: Promise<void> | null = null

const load = () => {
  if (!loading) {
    loading = userLayersStorage.getAll()
      .then(all => { layers.value = all })
      .catch(e => console.error('Error al cargar capas del usuario', e))
      .finally(() => { loaded.value = true })
  }
  return loading
}

const update = async (id: string, patch: Partial<Pick<UserMapLayer, 'isVisible' | 'showDescriptions' | 'color' | 'name'>>) => {
  const layer = layers.value.find(l => l.id === id)
  if (!layer) return
  const updated = { ...layer, ...patch }
  await userLayersStorage.put(JSON.parse(JSON.stringify(updated)))
  layers.value = layers.value.map(l => (l.id === id ? updated : l))
}

const importFile = async (file: File): Promise<UserMapLayer> => {
  if (file.size > MAX_FILE_BYTES) throw new Error('El archivo supera el máximo de 20 MB')

  let data: unknown
  try {
    data = JSON.parse(await file.text())
  } catch {
    throw new Error('El archivo no es un JSON válido')
  }
  const type = (data as { type?: string } | null)?.type
  if (!type || !VALID_TYPES.includes(type)) throw new Error('El archivo no es un GeoJSON válido')

  const layer: UserMapLayer = {
    id: crypto.randomUUID(),
    name: file.name.replace(/\.(geo)?json$/i, ''),
    color: PALETTE[layers.value.length % PALETTE.length],
    isVisible: true,
    showDescriptions: true,
    importedAt: new Date().toISOString(),
    geojson: data as object
  }
  await userLayersStorage.put(layer)
  layers.value = [...layers.value, layer]
  return layer
}

const remove = async (id: string) => {
  await userLayersStorage.remove(id)
  layers.value = layers.value.filter(l => l.id !== id)
}

export const useUserMapLayers = () => {
  load()
  return {
    layers: readonly(layers),
    loaded: readonly(loaded),
    importFile,
    remove,
    toggleVisibility: (id: string) => {
      const l = layers.value.find(x => x.id === id)
      return l ? update(id, { isVisible: !l.isVisible }) : Promise.resolve()
    },
    toggleDescriptions: (id: string) => {
      const l = layers.value.find(x => x.id === id)
      return l ? update(id, { showDescriptions: !l.showDescriptions }) : Promise.resolve()
    },
    setColor: (id: string, color: string) => update(id, { color })
  }
}
