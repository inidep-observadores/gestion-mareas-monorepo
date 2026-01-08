import { IsString, IsOptional, IsEnum, IsUUID } from 'class-validator';

export class UpdateAlertDto {
    @IsString()
    @IsOptional()
    estado?: string;

    @IsString()
    @IsOptional()
    prioridad?: string;

    @IsOptional()
    fechaVencimiento?: Date;

    @IsUUID()
    @IsOptional()
    asignadoId?: string;

    @IsString()
    @IsOptional()
    comment?: string; // Virtual field for events
}
