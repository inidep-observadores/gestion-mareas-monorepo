import { PrismaService } from '../prisma/prisma.service';
export declare class TrackingService {
    private prisma;
    private readonly logger;
    private readonly PORT_RADIUS_METERS;
    private readonly GAP_THRESHOLD_MINUTES;
    private readonly OLD_DATA_THRESHOLD_HOURS;
    private readonly CHECK_INTERVAL_HOURS;
    private readonly TIMEZONE;
    constructor(prisma: PrismaService);
    checkHeartbeat(): Promise<{
        status: string;
        timestamp: Date;
    }>;
    runAutomatedChecks(): Promise<void>;
    importTrackingData(fileBuffer: Buffer): Promise<{
        processed: number;
        inserted: number;
        updated: number;
        alerts: number;
        errors: {
            vessel: string;
            reason: string;
        }[];
    }>;
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
        totalDays: number;
        etapas: {
            durationDays: number;
            id: string;
            observaciones: string | null;
            pesqueriaId: string | null;
            nroEtapa: number;
            mareaId: string;
            puertoZarpadaId: string | null;
            puertoArriboId: string | null;
            fechaZarpada: Date | null;
            fechaArribo: Date | null;
            tipoEtapa: import("@prisma/client").$Enums.TipoEtapa;
        }[];
    }>;
    getLatestFleetPositions(): Promise<any[]>;
    getVesselHistory(buqueId: string, from?: string, to?: string, limit?: number): Promise<{
        lat: number;
        lon: number;
        timestamp: Date;
        speed: number;
        course: number;
        isFishing: boolean;
    }[]>;
    private detectPortEvents;
    private handleProcessedEvent;
    private createDiscrepancyAlert;
    private saveSnapshot;
    private checkPortStatus;
    private analyzeGaps;
    private createAlert;
}
