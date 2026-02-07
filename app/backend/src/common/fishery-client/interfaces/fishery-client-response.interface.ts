/**
 * Datos oficiales de un buque provenientes de la API de Pesca.
 * Abstrae la complejidad del XML/SOAP.
 */
export interface VesselOfficialData {
    id_mbpc: string;
    matricula: string;
    nro_omi?: string;
    nombre: string;
    bandera?: string;
    anio_construccion?: number;
    mmsi?: string;
    astill_partic?: string;
    registro?: string;
    tipo_buque?: string;
    tipo_servicio?: string;
    tipo_explotacion?: string;
    senal_distintiva?: string; // Mapeado desde 'sdist'
    velocidad?: number;
    eslora_mbpc?: number; // Se mapea a eslora_m en DB
    manga?: number; // Se mapea a manga en DB (si existe)
    puntal?: number;
    arqueo_total?: number;
    calado_max?: number;
    puerto_asiento?: string;
    material?: string;
    sociedadclasif?: string;
    arqueo_neto?: number;
    dotacion_minima?: number;
    tipo?: string; // Ej: SIB
    fecha_mod?: Date;
    estado_reg?: string;
    observaciones?: string;
}

/**
 * Registro de movimiento oficial (Arribo/Zarpada).
 */
export interface OfficialMovement {
    id_buque_mbpc: string;
    matricula: string;
    nombre_buque: string;
    estado: 'ARRIBO' | 'ZARPADA' | string;
    fecha: Date;
    puerto_nombre: string;
    id_costera: string;
    latitud?: number;
    longitud?: number;
    cantidad_tripulantes?: number;
    observaciones?: string;
}

/**
 * Registro de posición satelital.
 */
export interface SatellitePosition {
    id_mbpc: string;
    timestamp: Date;
    lat: number;
    lon: number;
    velocidad?: number;
    rumbo?: number;
}
