import { PartialType } from '@nestjs/mapped-types';
import { CreateMareaDto } from './create-marea.dto';
import { IsBoolean, IsDateString, IsInt, IsOptional, IsArray, IsString, IsUUID, ValidateNested, IsEnum } from 'class-validator';
import { Type } from 'class-transformer';
import { MareaEtapaDto } from './marea-etapa.dto';
import { TipoCalculoZonaAustral } from '@prisma/client';
import { ObservadorSecundarioPlanificadoDto } from './observador-secundario-planificado.dto';

export class UpdateMareaDto extends PartialType(CreateMareaDto) {
    @IsInt()
    @IsOptional()
    diasZonaAustral?: number | null;

    @IsEnum(TipoCalculoZonaAustral)
    @IsOptional()
    tipoCalculoZonaAustral?: TipoCalculoZonaAustral | null;



    @IsDateString()
    @IsOptional()
    fechaInicioObservador?: string | null;

    @IsDateString()
    @IsOptional()
    fechaFinObservador?: string | null;

    @IsInt()
    @IsOptional()
    nroProtocolizacion?: number | null;

    @IsInt()
    @IsOptional()
    anioProtocolizacion?: number | null;

    @IsDateString()
    @IsOptional()
    fechaProtocolizacion?: string | null;

    @IsString()
    @IsOptional()
    observaciones?: string | null;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsBoolean()
    @IsOptional()
    inicioValidado?: boolean;

    @IsBoolean()
    @IsOptional()
    finValidado?: boolean;

    @IsUUID()
    @IsOptional()
    artePrincipalId?: string | null;

    @IsUUID()
    @IsOptional()
    observadorPrincipalId?: string | null;

    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => MareaEtapaDto)
    etapas?: MareaEtapaDto[];

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    archivosToDelete?: string[];

    /** Actualización del borrador de observadores secundarios planificados. */
    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => ObservadorSecundarioPlanificadoDto)
    observadoresSecundariosPlanificados?: ObservadorSecundarioPlanificadoDto[];
}
