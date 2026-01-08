import { IsString, IsOptional, IsEnum, IsUUID, IsNotEmpty } from 'class-validator';

export class CreateAlertDto {
    @IsString()
    @IsNotEmpty()
    codigoUnico: string;

    @IsUUID()
    @IsOptional()
    referenciaId?: string;

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
