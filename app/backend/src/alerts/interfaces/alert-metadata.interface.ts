/**
 * Metadata estándar para alertas del sistema
 * 
 * Esta interfaz define la estructura de metadatos que pueden acompañar
 * a las alertas generadas por diferentes fuentes (Access Import, Tracking CSV, etc.)
 */
export interface AlertMetadata {
    // === Campos Comunes ===
    /** Tipo de evento: 'ZARPADA' | 'ARRIBO' | etc. */
    type?: string;

    /** Subtipo de alerta para clasificación adicional */
    subTipo?: string;

    /** Fuente de origen de la alerta */
    source?: 'ACCESS_IMPORT' | 'TRACKING_CSV' | 'API_PNA';

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
        /** Fecha de zarpada según sistema externo */
        fechaZarpada?: Date | string;

        /** Fecha de arribo según sistema externo */
        fechaArribo?: Date | string;

        /** ID de puerto de zarpada según sistema externo */
        puertoZarpadaId?: string;

        /** ID de puerto de arribo según sistema externo */
        puertoArriboId?: string;

        /** Nombre de buque según sistema externo */
        buque?: string;

        /** Número de marea según sistema externo */
        nroMarea?: number;

        /** Campos específicos de PNA */
        id_costera?: string | number;
        nombre_costera?: string;
        id_buque_mbpc?: string | number;
        senial?: string;
        matricula?: string;

        /** Información del observador externo (cuando no hay match local) */
        observer?: {
            nombre?: string;
            apellido?: string;
            codigo?: string;
        };

        /** Otros datos específicos del sistema externo */
        [key: string]: any;
    };

    // === Datos Locales (del sistema local) ===
    localData?: {
        /** Fecha de zarpada local */
        fechaZarpada?: Date | string;

        /** Fecha de arribo local */
        fechaArribo?: Date | string;

        /** ID de la etapa local */
        id?: string;

        /** Otros datos locales */
        [key: string]: any;
    };

    // === Campos Específicos de Access Import ===
    /** ID externo del registro en Access */
    idExterno?: string;

    // === Campos Adicionales ===
    /** Nombre del observador */
    observadorNombre?: string;

    /** Nombre del observador (alias) */
    observerName?: string;

    /** Nombre del buque (alias) */
    vessel?: string;

    /** Fecha específica */
    date?: Date | string;

    /** Días de retraso en entrega */
    busDays?: number;

    /** Permite campos adicionales no tipados */
    [key: string]: any;
}
