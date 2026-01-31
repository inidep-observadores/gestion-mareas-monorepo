import { IsBoolean, IsInt, IsOptional, IsString } from 'class-validator';

export class CreatePuertoDto {
    @IsString()
    nombre: string;

    @IsString()
    @IsOptional()
    provincia?: string;

    @IsString()
    @IsOptional()
    pais?: string;

    @IsString()
    @IsOptional()
    codigoInterno?: string;

    @IsString()
    @IsOptional()
    codigoExterno?: string;

    @IsBoolean()
    @IsOptional()
    esLocal?: boolean;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsInt()
    @IsOptional()
    orden?: number;

    @IsString()
    @IsOptional()
    observaciones?: string;
}
