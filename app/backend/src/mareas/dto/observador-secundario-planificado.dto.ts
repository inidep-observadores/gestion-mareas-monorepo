import { IsInt, IsOptional, IsString, IsUUID, Min } from 'class-validator';

/**
 * DTO que representa un observador secundario planificado en el borrador
 * del campo `mareas.metadata`.
 *
 * Se usa en CreateMareaDto y UpdateMareaDto como parte del array
 * `observadoresSecundariosPlanificados`.
 */
export class ObservadorSecundarioPlanificadoDto {
    @IsUUID()
    observadorId: string;

    /** Número de etapa desde la que aplica (base 1). */
    @IsInt()
    @Min(1)
    etapaDesde: number;

    /**
     * Número de etapa hasta la que aplica (inclusivo).
     * Enviar `null` para indicar "hasta la última etapa".
     */
    @IsInt()
    @Min(1)
    @IsOptional()
    etapaHasta?: number | null;

    @IsString()
    @IsOptional()
    notas?: string;
}
