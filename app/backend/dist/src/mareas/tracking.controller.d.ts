import { TrackingService } from './tracking.service';
export declare class TrackingController {
    private readonly trackingService;
    constructor(trackingService: TrackingService);
    uploadFile(file: Express.Multer.File): Promise<{
        processed: number;
        inserted: number;
        updated: number;
        alerts: number;
        errors: {
            vessel: string;
            reason: string;
        }[];
    }>;
    heartbeat(): Promise<{
        status: string;
        timestamp: Date;
    }>;
    getFleet(): Promise<{
        fleet: any[];
        lastUpdate: string;
    }>;
    getHistory(buqueId: string, from?: string, to?: string): Promise<{
        lat: number;
        lon: number;
        timestamp: Date;
        speed: number;
        course: number;
        isFishing: boolean;
    }[]>;
    getMareaTrackingInfo(mareaId: string): Promise<{
        id: string;
        buqueId: string;
        name: string;
        matricula: string;
        mareaCode: string;
        observer: string;
        voyageStart: string;
        voyageEnd: string;
        lastUpdate: Date;
        lastTrackingUpdate: string;
        totalDays: number;
        etapas: {
            durationDays: number;
            id: string;
            observaciones: string | null;
            pesqueriaId: string | null;
            mareaId: string;
            nroEtapa: number;
            puertoZarpadaId: string | null;
            puertoArriboId: string | null;
            fechaZarpada: Date | null;
            fechaArribo: Date | null;
            tipoEtapa: import("@prisma/client").$Enums.TipoEtapa;
            updatedAt: Date;
        }[];
    }>;
}
