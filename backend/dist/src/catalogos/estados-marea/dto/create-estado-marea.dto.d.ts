export declare class CreateEstadoMareaDto {
    codigo: string;
    nombre: string;
    descripcion?: string;
    categoria: string;
    orden: number;
    esInicial?: boolean;
    esFinal?: boolean;
    permiteCargaArchivos?: boolean;
    permiteCorreccion?: boolean;
    permiteInforme?: boolean;
    activo?: boolean;
}
