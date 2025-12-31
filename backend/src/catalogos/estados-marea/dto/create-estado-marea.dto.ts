import { IsBoolean, IsInt, IsOptional, IsString } from 'class-validator';

export class CreateEstadoMareaDto {
    @IsString()
    codigo: string;

    @IsString()
    nombre: string;

    @IsString()
    @IsOptional()
    descripcion?: string;

    @IsString()
    categoria: string; // 'PENDIENTE' | 'EN_CURSO' | 'COMPLETADO' | 'CANCELADO'

    @IsInt()
    orden: number;

    @IsBoolean()
    @IsOptional()
    esInicial?: boolean;

    @IsBoolean()
    @IsOptional()
    esFinal?: boolean;

    @IsBoolean()
    @IsOptional()
    permiteCargaArchivos?: boolean;

    @IsBoolean()
    @IsOptional()
    permiteCorreccion?: boolean;

    @IsBoolean()
    @IsOptional()
    permiteInforme?: boolean;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;
}
