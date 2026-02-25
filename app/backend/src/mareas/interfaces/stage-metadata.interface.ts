export interface StageMetadata {
    /** Fecha real del evento extraída de la fuente (PNA/Tracking) */
    eventDate?: string | Date;

    /** Lista de fuentes que validaron el movimiento */
    sources?: Array<{
        name: string;
        detectedAt: string | Date;
        data?: any;
    }>;

    /** Indica si fue procesada por el servicio de automatización */
    automatizado?: boolean;

    /** Puerto detectado */
    portId?: string;

    /** Otros campos dinámicos */
    [key: string]: any;
}
