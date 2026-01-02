import { IsBoolean, IsDateString, IsInt, IsOptional, IsString } from 'class-validator';

export class CreateObservadorDto {
    @IsInt()
    codigoInterno: number;

    @IsString()
    nombre: string;

    @IsString()
    apellido: string;

    @IsString()
    @IsOptional()
    fotoUrl?: string;

    @IsString()
    tipoObservador: string; // 'OBSERVADOR' | 'TECNICO'

    @IsString()
    tipoContrato: string; // 'LEY MARCO' | '1109' | 'MONOTRIBUTISTA' | 'PLANTA PERMANENTE'

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsBoolean()
    @IsOptional()
    disponible?: boolean;

    @IsDateString()
    @IsOptional()
    fechaProximaDisponibilidad?: string;

    @IsString()
    @IsOptional()
    observaciones?: string;
}
