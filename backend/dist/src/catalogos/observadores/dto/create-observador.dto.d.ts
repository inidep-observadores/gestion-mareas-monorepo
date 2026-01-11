export declare class CreateObservadorDto {
    codigoInterno: number;
    nombre: string;
    apellido: string;
    fotoUrl?: string;
    tipoObservador: string;
    tipoContrato: string;
    activo?: boolean;
    disponible?: boolean;
    conImpedimento?: boolean;
    motivoImpedimento?: string;
    fechaProximaDisponibilidad?: string;
    observaciones?: string;
}
