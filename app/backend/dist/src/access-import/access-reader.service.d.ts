export interface ExternalRecord {
    Id: number;
    CodObs: number;
    Buque: string;
    Especie: string;
    Flota: string;
    Fecha_Zarpada: Date | string;
    Fecha_Arribo: Date | string;
    DiasNavegados: number;
    NroMarea: string;
    Validada: boolean;
    SinEtapas: boolean;
    NroInformeDni?: string;
    Comentarios?: string;
    Prospeccion: boolean;
    InicioProspeccion?: Date | string;
    FinProspeccion?: Date | string;
    NroEtapa: number;
    FechaInicioCI?: Date | string;
    FechaFinCI?: Date | string;
    ObservadorNombre?: string;
    ObservadorApellido?: string;
}
export declare class AccessReaderService {
    private readonly logger;
    readAccessFile(buffer: Buffer): Promise<ExternalRecord[]>;
    parseDate(value: Date | string | null | undefined): Date | null;
}
