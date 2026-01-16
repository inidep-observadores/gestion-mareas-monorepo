import { IsString, IsOptional, IsUUID, IsNotEmpty, IsObject, IsEnum } from 'class-validator';
import { AlertaEstado, AlertaPrioridad } from '../alerts.enums';

export class CreateAlertDto {
    @IsString()
    @IsNotEmpty()
    codigoUnico: string;

    @IsUUID()
    @IsOptional()
    referenciaId?: string;

    @IsOptional()
    @IsString()
    referenciaTipo?: string; // e.g., 'MAREA', 'BUQUE', 'OBSERVADOR', 'OTRO'

    @IsOptional()
    @IsObject()
    metadata?: Record<string, any>;

    @IsString()
    @IsNotEmpty()
    tipo: string;

    @IsString()
    @IsNotEmpty()
    titulo: string;

    @IsString()
    @IsNotEmpty()
    descripcion: string;

    @IsEnum(AlertaEstado)
    @IsNotEmpty()
    estado: AlertaEstado;

    @IsEnum(AlertaPrioridad)
    @IsNotEmpty()
    prioridad: AlertaPrioridad;

    @IsOptional()
    fechaVencimiento?: Date;

    @IsUUID()
    @IsOptional()
    asignadoId?: string;
}
