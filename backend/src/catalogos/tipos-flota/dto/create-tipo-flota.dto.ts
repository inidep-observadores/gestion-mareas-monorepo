import { IsBoolean, IsInt, IsOptional, IsString } from 'class-validator';

export class CreateTipoFlotaDto {
    @IsString()
    codigo: string;

    @IsString()
    nombre: string;

    @IsString()
    @IsOptional()
    descripcion?: string;

    @IsInt()
    @IsOptional()
    orden?: number;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;
}
