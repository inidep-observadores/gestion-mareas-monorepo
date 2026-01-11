export declare class CreateAlertDto {
    codigoUnico: string;
    referenciaId?: string;
    referenciaTipo?: string;
    metadata?: Record<string, any>;
    tipo: string;
    titulo: string;
    descripcion: string;
    estado: string;
    prioridad: string;
    fechaVencimiento?: Date;
    asignadoId?: string;
}
