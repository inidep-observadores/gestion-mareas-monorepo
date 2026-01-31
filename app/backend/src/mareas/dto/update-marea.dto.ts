import { PartialType } from '@nestjs/mapped-types';
import { CreateMareaDto } from './create-marea.dto';
import { IsBoolean, IsDateString, IsInt, IsOptional, IsArray, IsString, IsUUID, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { MareaEtapaDto } from './marea-etapa.dto';

export class UpdateMareaDto extends PartialType(CreateMareaDto) {
    @IsInt()
    @IsOptional()
    diasZonaAustral?: number | null;

    @IsString()
    @IsOptional()
    tipoCalculoZonaAustral?: string | null;

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
}
