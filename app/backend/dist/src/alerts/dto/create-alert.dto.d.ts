import { AlertaEstado, AlertaPrioridad } from '../alerts.enums';
export declare class CreateAlertDto {
    codigoUnico: string;
    referenciaId?: string;
    referenciaTipo?: string;
    metadata?: Record<string, any>;
    tipo: string;
    titulo: string;
    descripcion: string;
    estado: AlertaEstado;
    prioridad: AlertaPrioridad;
    fechaVencimiento?: Date;
    asignadoId?: string;
    visible?: boolean;
}
