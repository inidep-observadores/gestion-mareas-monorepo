export interface PnaReporteCostera {
    id_costera: string;
    nombre_costera: string;
    id_buque_mbpc: string;
    matricula: string;
    sdist: string; // Señal distintiva
    nombre: string;
    latitud: string;
    longitud: string;
    estado: 'ZARPADA' | 'ARRIBO';
    fecha: string; // UTC timestamp
    fecha_modificacion: string;
    cantidad_tripulantes: string;
    observaciones: string;
    borrado: string;
}

export interface PnaApiResponse {
    reportes: PnaReporteCostera[];
    error: boolean;
    mensaje: string;
}
