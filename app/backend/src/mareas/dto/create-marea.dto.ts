import { IsInt, IsNotEmpty, IsOptional, IsString, IsUUID, IsDateString, Min, Max, IsArray, ValidateNested, IsEnum, IsBoolean } from 'class-validator';
import { TipoMarea } from '../mareas.constants';
import { Type } from 'class-transformer';
import { MareaEtapaDto } from './marea-etapa.dto';
import { ObservadorSecundarioPlanificadoDto } from './observador-secundario-planificado.dto';

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

    @IsBoolean()
    @IsOptional()
    iniciaEnProspeccion?: boolean;

    @IsInt()
    @IsOptional()
    diasEstimados?: number;

    @IsDateString()
    @IsOptional()
    fechaInicioObservador?: string;

    @IsString()
    @IsOptional()
    observaciones?: string;

    @IsBoolean()
    @IsOptional()
    inicioValidado?: boolean;

    @IsBoolean()
    @IsOptional()
    finValidado?: boolean;

    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => MareaEtapaDto)
    etapas?: MareaEtapaDto[];

    /** Borrador de observadores secundarios planificados (se almacena en mareas.metadata). */
    @IsArray()
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => ObservadorSecundarioPlanificadoDto)
    observadoresSecundariosPlanificados?: ObservadorSecundarioPlanificadoDto[];
}
