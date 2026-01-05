import { IsBoolean, IsDateString, IsInt, IsNotEmpty, IsOptional, IsString, ValidateIf } from 'class-validator';

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
    
    @IsBoolean()
    @IsOptional()
    conImpedimento?: boolean;

    @ValidateIf(o => o.conImpedimento === true)
    @IsNotEmpty({ message: 'El motivo de impedimento es obligatorio cuando existe un impedimento' })
    @IsString()
    @IsOptional()
    motivoImpedimento?: string;

    @IsDateString()
    @IsOptional()
    fechaProximaDisponibilidad?: string;

    @IsString()
    @IsOptional()
    observaciones?: string;
}
