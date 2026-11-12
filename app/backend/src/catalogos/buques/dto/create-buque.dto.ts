import { IsBoolean, IsDateString, IsInt, IsNumber, IsOptional, IsString, IsUUID, Max, Min, ValidateIf } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateBuqueDto {
    @IsString()
    nombreBuque: string;

    @IsString()
    matricula: string;

    @IsString()
    @IsOptional()
    matriculaSiop?: string | null;

    @IsInt()
    @IsOptional()
    @ValidateIf((o, v) => v !== null)
    @Type(() => Number)
    codigoInterno?: number | null;

    @IsUUID()
    @IsOptional()
    tipoFlotaId?: string | null;

    @IsUUID()
    @IsOptional()
    arteHabitualId?: string | null;

    @IsUUID()
    @IsOptional()
    pesqueriaHabitualId?: string | null;

    @IsInt()
    @IsOptional()
    @ValidateIf((o, v) => v !== null)
    @Type(() => Number)
    diasMareaEstimada?: number | null;

    @IsNumber()
    @IsOptional()
    @ValidateIf((o, v) => v !== null)
    @Type(() => Number)
    esloraM?: number | null;

    @IsInt()
    @IsOptional()
    @ValidateIf((o, v) => v !== null)
    @Type(() => Number)
    potenciaHp?: number | null;

    @IsUUID()
    @IsOptional()
    puertoBaseId?: string | null;

    @IsString()
    @IsOptional()
    empresaNombre?: string | null;

    @IsString()
    @IsOptional()
    empresaLocalidad?: string | null;

    @IsString()
    @IsOptional()
    empresaTelefono?: string | null;

    @IsString()
    @IsOptional()
    empresaFax?: string | null;

    @IsString()
    @IsOptional()
    empresaCorreoPrincipal?: string | null;

    @IsString()
    @IsOptional()
    empresaCorreoSecundario?: string | null;

    @IsString()
    @IsOptional()
    armadorNombre?: string | null;

    @IsString()
    @IsOptional()
    armadorTelefono?: string | null;

    @IsString()
    @IsOptional()
    agenciaMaritimaNombre?: string | null;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsDateString()
    @IsOptional()
    fechaAlta?: string | null;

    @IsDateString()
    @IsOptional()
    fechaBaja?: string | null;

    @IsBoolean()
    @IsOptional()
    habitabilidadFemeninaApta?: boolean;

    @IsInt({ message: 'La calificación debe ser un número entero' })
    @Min(0, { message: 'La calificación mínima es 0' })
    @Max(5, { message: 'La calificación máxima es 5' })
    @IsOptional()
    @ValidateIf((o, v) => v !== null && v !== undefined)
    @Type(() => Number)
    calificacion?: number;

    @IsString()
    @IsOptional()
    observaciones?: string | null;
}
