export interface MapLayer {
  id: string;
  name: string;
  url: string;
  attribution: string;
  type: 'base' | 'overlay';
  maxZoom?: number;
}

export const BASE_LAYERS: MapLayer[] = [
  {
    id: 'carto-voyager',
    name: 'Estándar',
    url: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    attribution: '&copy; OSM &copy; CARTO',
    type: 'base',
    maxZoom: 20
  },
  {
    id: 'carto-dark',
    name: 'Oscuro',
    url: 'https://{s}.basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png',
    attribution: '&copy; OSM &copy; CARTO',
    type: 'base',
    maxZoom: 20
  },
  {
    id: 'esri-satellite',
    name: 'Satélite',
    url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    attribution: 'Tiles &copy; Esri',
    type: 'base',
    maxZoom: 19
  },
  {
    id: 'esri-ocean',
    name: 'Océano (Esri)',
    url: 'https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}',
    attribution: 'Tiles &copy; Esri',
    type: 'base',
    maxZoom: 13
  },
  {
    id: 'osm',
    name: 'OpenStreetMap',
    url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: '&copy; OpenStreetMap',
    type: 'base',
    maxZoom: 19
  },
  {
    id: 'topo',
    name: 'Relieve',
    url: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
    attribution: 'Map data: &copy; OSM, SRTM | Style: &copy; OpenTopoMap',
    type: 'base',
    maxZoom: 17
  }
];

export const OVERLAY_LAYERS: MapLayer[] = [];
