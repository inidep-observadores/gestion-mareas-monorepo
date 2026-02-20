import { IsArray, IsBoolean, IsDateString, IsInt, IsOptional, IsString, IsUUID, ValidateNested, IsEnum } from 'class-validator';
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
    puertoZarpadaId?: string;

    @IsUUID()
    @IsOptional()
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
    fuentesZarpada?: any;

    @IsOptional()
    fuentesArribo?: any;

    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => MareaEtapaObservadorDto)
    observadores?: MareaEtapaObservadorDto[];
}
