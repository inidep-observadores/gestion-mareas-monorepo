import { IsBoolean, IsNotEmpty, IsOptional, IsString, IsArray } from 'class-validator';

export class CreateTipoNovedadDto {
    @IsString()
    @IsNotEmpty()
    codigo: string;

    @IsString()
    @IsNotEmpty()
    descripcion: string;

    @IsBoolean()
    @IsOptional()
    afectaPresentismo?: boolean;

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    tiposContratoPermitidos?: string[];

    @IsBoolean()
    @IsOptional()
    activo?: boolean;
}
