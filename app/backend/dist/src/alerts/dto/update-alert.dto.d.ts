import { AlertaEstado, AlertaPrioridad } from '../alerts.enums';
export declare class UpdateAlertDto {
    estado?: AlertaEstado;
    prioridad?: AlertaPrioridad;
    fechaVencimiento?: Date;
    asignadoId?: string;
    comment?: string;
}
