import { IsBoolean, IsOptional, IsString } from 'class-validator';

export class CreateEspecieDto {
    @IsString()
    codigo: string;

    @IsString()
    nombreCientifico: string;

    @IsString()
    nombreVulgar: string;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsString()
    @IsOptional()
    observaciones?: string;
}
