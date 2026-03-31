import { IsBoolean, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateTransicionEstadoDto {
    @IsUUID()
    estadoOrigenId: string;

    @IsUUID()
    estadoDestinoId: string;

    @IsString()
    accion: string;

    @IsString()
    etiqueta: string;

    @IsString()
    @IsOptional()
    claseBoton?: string;

    @IsBoolean()
    @IsOptional()
    requiereObs?: boolean;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;
}
