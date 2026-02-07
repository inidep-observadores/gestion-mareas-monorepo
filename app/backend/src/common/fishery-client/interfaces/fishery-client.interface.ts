import { VesselOfficialData, OfficialMovement, SatellitePosition } from './fishery-client-response.interface';

export interface TimeWindow {
    start: Date;
    end: Date;
}

export abstract class FisheryClient {
    /**
     * Obtiene los datos oficiales de un buque por su matrícula.
     */
    abstract getVesselByMatricula(matricula: string): Promise<VesselOfficialData | null>;

    /**
     * Obtiene los datos oficiales de un buque por su ID MBPC.
     */
    abstract getVesselDetails(idMbpc: string): Promise<VesselOfficialData | null>;

    /**
     * Obtiene los datos oficiales de un buque por su nombre.
     */
    abstract getVesselByName(nombre: string): Promise<VesselOfficialData | null>;

    /**
     * Obtiene movimientos recientes para todos los buques o uno específico.
     */
    abstract getRecentMovements(since: Date, idMbpc?: string): Promise<OfficialMovement[]>;

    /**
     * Obtiene trazas de posicionamiento satelital para un buque en una ventana de tiempo.
     */
    abstract getSatelliteTracking(idMbpc: string, window: TimeWindow): Promise<SatellitePosition[]>;
}
