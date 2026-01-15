import { IsBoolean, IsDateString, IsInt, IsNumber, IsOptional, IsString, IsUUID, ValidateIf } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateBuqueDto {
    @IsString()
    nombreBuque: string;

    @IsString()
    matricula: string;

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

    @IsString()
    @IsOptional()
    observaciones?: string | null;
}
