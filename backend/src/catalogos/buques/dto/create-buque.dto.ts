import { IsBoolean, IsDateString, IsInt, IsNumber, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateBuqueDto {
    @IsString()
    nombreBuque: string;

    @IsString()
    matricula: string;

    @IsInt()
    @IsOptional()
    codigoInterno?: number;

    @IsUUID()
    @IsOptional()
    tipoFlotaId?: string;

    @IsUUID()
    @IsOptional()
    arteHabitualId?: string;

    @IsUUID()
    @IsOptional()
    pesqueriaHabitualId?: string;

    @IsInt()
    @IsOptional()
    diasMareaEstimada?: number;

    @IsNumber()
    @IsOptional()
    esloraM?: number;

    @IsInt()
    @IsOptional()
    potenciaHp?: number;

    @IsUUID()
    @IsOptional()
    puertoBaseId?: string;

    @IsString()
    @IsOptional()
    empresaNombre?: string;

    @IsString()
    @IsOptional()
    empresaLocalidad?: string;

    @IsString()
    @IsOptional()
    empresaTelefono?: string;

    @IsString()
    @IsOptional()
    empresaFax?: string;

    @IsString()
    @IsOptional()
    empresaCorreoPrincipal?: string;

    @IsString()
    @IsOptional()
    empresaCorreoSecundario?: string;

    @IsString()
    @IsOptional()
    armadorNombre?: string;

    @IsString()
    @IsOptional()
    armadorTelefono?: string;

    @IsString()
    @IsOptional()
    agenciaMaritimaNombre?: string;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsDateString()
    @IsOptional()
    fechaAlta?: string;

    @IsDateString()
    @IsOptional()
    fechaBaja?: string;

    @IsString()
    @IsOptional()
    observaciones?: string;
}
