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
  styles?: string; // WMS styles parameter
  format?: string;
  transparent?: boolean;
  zIndex?: number;
  className?: string;
}

export const getBaseLayers = (provider: 'argenmaps' | 'google' | 'osm'): MapLayer[] => {
  return [
    {
      id: 'estandar',
      name: 'Estándar',
      url: provider === 'argenmaps' 
        ? 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/capabaseargenmap@EPSG%3A3857@png/{z}/{x}/{-y}.png'
        : provider === 'google'
        ? 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: provider === 'argenmaps'
        ? '&copy; Instituto Geográfico Nacional'
        : provider === 'google'
        ? '&copy; Google Maps'
        : '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      type: 'base',
      maxZoom: 20
    },
    {
      id: 'gris',
      name: 'Gris',
      url: provider === 'argenmaps'
        ? 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/mapabase_gris@EPSG%3A3857@png/{z}/{x}/{-y}.png'
        : provider === 'google'
        ? 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}'
        : 'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',
      attribution: provider === 'argenmaps'
        ? '&copy; Instituto Geográfico Nacional'
        : provider === 'google'
        ? '&copy; Google Maps'
        : '&copy; Esri, HERE, Garmin, FAO, NOAA, USGS, EPA',
      type: 'base',
      maxZoom: 20,
      className: provider === 'google' ? 'google-gray-map' : undefined
    },
    {
      id: 'oscuro',
      name: 'Oscuro',
      url: provider === 'argenmaps'
        ? 'https://wms.ign.gob.ar/geoserver/gwc/service/tms/1.0.0/argenmap_oscuro@EPSG%3A3857@png/{z}/{x}/{-y}.png'
        : provider === 'google'
        ? 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}'
        : 'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}',
      attribution: provider === 'argenmaps'
        ? '&copy; Instituto Geográfico Nacional'
        : provider === 'google'
        ? '&copy; Google Maps'
        : '&copy; Esri, HERE, Garmin, FAO, NOAA, USGS, EPA',
      type: 'base',
      maxZoom: 20,
      className: provider === 'google' ? 'google-dark-map' : undefined
    },
    {
      id: 'satelital',
      name: 'Satelital',
      url: 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
      attribution: '&copy; Google Maps',
      type: 'base',
      maxZoom: 20
    }
  ];
};

export const OVERLAY_LAYERS: MapLayer[] = [
  {
    id: 'noaa-wind',
    name: 'Viento (Global GDPS)',
    url: 'https://geo.weather.gc.ca/geomet',
    attribution: '&copy; ECCC MSC GeoMet',
    type: 'overlay',
    layers: 'GDPS_15km_WindSpeed_10m',
    format: 'image/png',
    transparent: true,
    hasTime: true,
    defaultOpacity: 0.35,
    maxZoom: 12,
    zIndex: 10
  },
  {
    id: 'noaa-wind-arrows',
    name: 'Viento Direccion (Global GDPS)',
    url: 'https://geo.weather.gc.ca/geomet',
    attribution: '&copy; ECCC MSC GeoMet',
    type: 'overlay',
    layers: 'GDPS_15km_Winds_10m',
    styles: 'WindBarbs_knots',
    format: 'image/png',
    transparent: true,
    hasTime: true,
    defaultOpacity: 0.35,
    maxZoom: 12,
    zIndex: 20
  }
];
