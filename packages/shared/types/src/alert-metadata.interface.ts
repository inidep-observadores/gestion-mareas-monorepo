/**
 * Metadata estándar para alertas del sistema SIGMA
 * CENTRALIZADO: Este archivo es la ÚNICA fuente de verdad para AlertMetadata.
 */
export interface AlertMetadata {
    // === Campos Comunes ===
    /** Tipo de evento: 'ZARPADA' | 'ARRIBO' | etc. */
    type?: string;

    /** Subtipo de alerta para clasificación adicional */
    subTipo?: string;

    /** Fuente de origen de la alerta */
    source?: 'ACCESS_IMPORT' | 'TRACKING_CSV' | 'API_PNA' | string;

    // === Referencias ===
    /** ID del buque relacionado */
    buqueId?: string;

    /** ID de la marea relacionada */
    mareaId?: string;

    /** Código de marea formateado (ej: "MC-190-25") */
    mareaCode?: string;

    /** Nombre del buque */
    vesselName?: string;

    /** ID del puerto relacionado */
    portId?: string;

    /** Nombre del puerto */
    portName?: string;

    /** Número de etapa */
    nroEtapa?: number;

    // === Fechas ===
    /** Fecha del evento que generó la alerta */
    eventDate?: Date | string;

    /** Fecha de zarpada */
    fechaZarpada?: Date | string;

    /** Fecha de arribo */
    fechaArribo?: Date | string;

    /** Lista de fuentes que han validado esta alerta (Source Stacking) */
    sources?: Array<{
        name: string;
        detectedAt: string | Date;
        data?: any;
    }>;

    // === Datos Externos (de sistemas externos como Access o Tracking) ===
    externalData?: {
        fechaZarpada?: Date | string;
        fechaArribo?: Date | string;
        puertoZarpadaId?: string;
        puertoArriboId?: string;
        buque?: string;
        nroMarea?: number;

        /** Campos específicos de PNA */
        id_costera?: string | number;
        nombre_costera?: string;
        id_buque_mbpc?: string | number;
        senial?: string;
        matricula?: string;

        /** Información del observador externo */
        observer?: {
            nombre?: string;
            apellido?: string;
            codigo?: string;
        };

        [key: string]: any;
    };

    // === Datos Locales (del sistema local) ===
    localData?: {
        fechaZarpada?: Date | string;
        fechaArribo?: Date | string;
        id?: string;
        [key: string]: any;
    };

    /** ID externo del registro en Access */
    idExterno?: string;

    /** Alias y campos adicionales */
    observerName?: string;
    vessel?: string;
    date?: Date | string;
    busDays?: number;

    [key: string]: any;
}
