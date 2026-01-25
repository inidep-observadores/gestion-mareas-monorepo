import { IsInt, IsNotEmpty, IsOptional, IsString, IsUUID, IsDateString, Min, Max, IsArray, ValidateNested, IsEnum } from 'class-validator';
import { TipoMarea } from '../mareas.constants';
import { Type } from 'class-transformer';
import { MareaEtapaDto } from './marea-etapa.dto';

export class CreateMareaDto {
    @IsUUID()
    @IsNotEmpty()
    buqueId: string;

    @IsInt()
    @Min(2000)
    @Max(2100)
    anioMarea: number;

    @IsInt()
    @Min(1)
    nroMarea: number;

    @IsUUID()
    @IsNotEmpty()
    pesqueriaId: string;

    @IsUUID()
    @IsNotEmpty()
    observadorId: string;

    @IsUUID()
    @IsOptional()
    arteId?: string;

    @IsDateString()
    fechaZarpadaEstimada: string;

    @IsEnum(TipoMarea)
    @IsOptional()
    tipoMarea?: TipoMarea;

    @IsInt()
    @IsOptional()
    diasEstimados?: number;

    @IsDateString()
    @IsOptional()
    fechaInicioObservador?: string;

    @IsString()
    @IsOptional()
    observaciones?: string;

    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => MareaEtapaDto)
    etapas?: MareaEtapaDto[];
}
