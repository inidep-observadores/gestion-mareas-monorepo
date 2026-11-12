import { ref, watch } from 'vue'

export type MapProvider = 'argenmaps' | 'google' | 'osm'
export type MapType = 'estandar' | 'gris' | 'oscuro' | 'satelital'

const SETTINGS_KEY = 'sigma_map_settings'

interface MapSettings {
  provider: MapProvider
  mapType: MapType
  rememberSelection: boolean
}

const defaultSettings: MapSettings = {
  provider: 'argenmaps',
  mapType: 'estandar',
  rememberSelection: false
}

// Inicialización desde localStorage
const loadSettings = (): MapSettings => {
  try {
    const saved = localStorage.getItem(SETTINGS_KEY)
    if (saved) {
      return { ...defaultSettings, ...JSON.parse(saved) }
    }
  } catch (e) {
    console.error('Error loading map settings from localStorage', e)
  }
  return defaultSettings
}

const settings = ref<MapSettings>(loadSettings())

// Persistencia en localStorage
watch(settings, (newVal) => {
  try {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(newVal))
  } catch (e) {
    console.error('Error saving map settings to localStorage', e)
  }
}, { deep: true })

export const useMapSettings = () => {
  return {
    settings
  }
}
