export class ZonaAustralEtapaDto {
    etapaId: string;
    nroEtapa: number;
    diasDetectados: string[]; // ISO Strings (YYYY-MM-DD)
    totalDias: number;
}

export class ZonaAustralResponseDto {
    mareaId: string;
    totalDiasMarea: number;
    diasDetectadosMarea: string[]; // ISO Strings (YYYY-MM-DD)
    etapas: ZonaAustralEtapaDto[];
}
