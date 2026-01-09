import { IsString, IsOptional, IsUUID, IsNotEmpty, IsObject } from 'class-validator';

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

    @IsString()
    @IsNotEmpty()
    estado: string;

    @IsString()
    @IsNotEmpty()
    prioridad: string;

    @IsOptional()
    fechaVencimiento?: Date;

    @IsUUID()
    @IsOptional()
    asignadoId?: string;
}
