import { IsString, IsOptional, IsEnum, IsUUID } from 'class-validator';
import { AlertaEstado, AlertaPrioridad } from '../alerts.enums';

export class UpdateAlertDto {
    @IsEnum(AlertaEstado)
    @IsOptional()
    estado?: AlertaEstado;

    @IsEnum(AlertaPrioridad)
    @IsOptional()
    prioridad?: AlertaPrioridad;

    @IsOptional()
    fechaVencimiento?: Date;

    @IsUUID()
    @IsOptional()
    asignadoId?: string;

    @IsString()
    @IsOptional()
    comment?: string; // Virtual field for events
}
