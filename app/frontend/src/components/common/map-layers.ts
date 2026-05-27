export interface MapLayer {
  id: string;
  name: string;
  url: string;
  attribution: string;
  type: 'base' | 'overlay';
  maxZoom?: number;
  hasTime?: boolean; // Indicates if layer supports TIME parameter
  defaultOpacity?: number; // Default opacity for the layer
  layers?: string; // WMS layers parameter
  format?: string;
  transparent?: boolean;
}

export const BASE_LAYERS: MapLayer[] = [
  {
    id: 'argenmap-mapa-base',
    name: 'Estándar',
    url: 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png',
    attribution: '&copy; Instituto Geográfico Nacional',
    type: 'base',
    maxZoom: 20
  },
  {
    id: 'argenmap-gris',
    name: 'Gris',
    url: 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/mapabase_gris@EPSG%3A3857@png/{z}/{x}/{-y}.png',
    attribution: '&copy; Instituto Geográfico Nacional',
    type: 'base',
    maxZoom: 20
  },
  {
    id: 'argenmap-oscuro',
    name: 'Oscuro',
    url: 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/argenmap_oscuro@EPSG%3A3857@png/{z}/{x}/{-y}.png',
    attribution: '&copy; Instituto Geográfico Nacional',
    type: 'base',
    maxZoom: 20
  },
  // {
  //   id: 'argenmap-topo',
  //   name: 'Topográfico',
  //   // url: 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/mapabase_hibrido@EPSG%3A3857@png/{z}/{x}/{-y}.png',
  //   url: 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/mapabase_topo@EPSG%3A3857@png/{z}/{x}/{-y}.png',
  //   attribution: '&copy; Instituto Geográfico Nacional',
  //   type: 'base',
  //   maxZoom: 20
  // },
  {
    id: 'google-satellite',
    name: 'Satelital',
    url: 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
    attribution: '&copy; Google Maps',
    type: 'base',
    maxZoom: 20
  }
];

export const OVERLAY_LAYERS: MapLayer[] = [
  {
    id: 'noaa-wind',
    name: 'Viento (Global GDPS)',
    url: 'https://geo.weather.gc.ca/geomet',
    attribution: '&copy; ECCC MSC GeoMet',
    type: 'overlay',
    layers: 'GDPS.ETA_WSPD',
    format: 'image/png',
    transparent: true,
    hasTime: true,
    defaultOpacity: 0.45,
    maxZoom: 12
  }
];
