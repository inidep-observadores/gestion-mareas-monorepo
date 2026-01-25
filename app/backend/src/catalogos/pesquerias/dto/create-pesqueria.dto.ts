import { IsBoolean, IsInt, IsOptional, IsString } from 'class-validator';

export class CreatePesqueriaDto {
    @IsString()
    codigo: string;

    @IsString()
    nombre: string;

    @IsString()
    @IsOptional()
    descripcion?: string;

    @IsString()
    @IsOptional()
    grupo?: string;

    @IsInt()
    @IsOptional()
    orden?: number;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;
}
