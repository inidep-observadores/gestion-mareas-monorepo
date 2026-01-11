export declare class MareaEtapaObservadorDto {
    observadorId: string;
    rol: string;
    esDesignado?: boolean;
}
export declare class MareaEtapaDto {
    id?: string;
    nroEtapa: number;
    pesqueriaId?: string;
    puertoZarpadaId?: string;
    puertoArriboId?: string;
    fechaZarpada?: string;
    fechaArribo?: string;
    tipoEtapa: string;
    observaciones?: string;
    observadores?: MareaEtapaObservadorDto[];
}
