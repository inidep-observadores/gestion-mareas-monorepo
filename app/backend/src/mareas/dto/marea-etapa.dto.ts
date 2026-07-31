import { IsObject, IsArray, IsBoolean, IsDateString, IsInt, IsOptional, IsString, IsUUID, ValidateNested, IsEnum, ValidateIf } from 'class-validator';
import { TipoEtapa } from '../mareas.constants';
import { Type } from 'class-transformer';

export class MareaEtapaObservadorDto {
    @IsUUID()
    observadorId: string;

    @IsString()
    rol: string;

    @IsBoolean()
    @IsOptional()
    esDesignado?: boolean;
}

export class MareaEtapaDto {
    @IsUUID()
    @IsOptional()
    id?: string;

    @IsInt()
    nroEtapa: number;

    @IsUUID()
    @IsOptional()
    pesqueriaId?: string;

    @IsUUID()
    @IsOptional()
    @ValidateIf((object, value) => value !== '')
    puertoZarpadaId?: string;

    @IsUUID()
    @IsOptional()
    @ValidateIf((object, value) => value !== '')
    puertoArriboId?: string;

    @IsDateString()
    @IsOptional()
    fechaZarpada?: string;

    @IsDateString()
    @IsOptional()
    fechaArribo?: string;

    @IsEnum(TipoEtapa)
    tipoEtapa: TipoEtapa;

    @IsString()
    @IsOptional()
    observaciones?: string;

    @IsOptional()
    @IsObject()
    fuentesZarpada?: Record<string, any>;

    @IsOptional()
    @IsObject()
    fuentesArribo?: Record<string, any>;

    @IsOptional()
    @IsObject()
    metadata?: Record<string, any>;

    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => MareaEtapaObservadorDto)
    observadores?: MareaEtapaObservadorDto[];
}
