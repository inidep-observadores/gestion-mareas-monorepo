import { PartialType } from '@nestjs/mapped-types';
import { CreateMareaDto } from './create-marea.dto';
import { IsBoolean, IsDateString, IsInt, IsOptional, IsArray, IsString, IsUUID, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { MareaEtapaDto } from './marea-etapa.dto';

export class UpdateMareaDto extends PartialType(CreateMareaDto) {
    @IsInt()
    @IsOptional()
    diasZonaAustral?: number;

    @IsString()
    @IsOptional()
    tipoCalculoZonaAustral?: string;

    @IsDateString()
    @IsOptional()
    fechaInicioObservador?: string;

    @IsDateString()
    @IsOptional()
    fechaFinObservador?: string;

    @IsInt()
    @IsOptional()
    nroProtocolizacion?: number;

    @IsInt()
    @IsOptional()
    anioProtocolizacion?: number;

    @IsDateString()
    @IsOptional()
    fechaProtocolizacion?: string;

    @IsString()
    @IsOptional()
    observaciones?: string;

    @IsBoolean()
    @IsOptional()
    activo?: boolean;

    @IsUUID()
    @IsOptional()
    artePrincipalId?: string;

    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => MareaEtapaDto)
    etapas?: MareaEtapaDto[];
}
