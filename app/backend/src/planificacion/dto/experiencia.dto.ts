import { IsInt, IsNotEmpty, IsOptional, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class UpsertExperienciaDto {
  @IsNotEmpty()
  observadorId: string;

  @IsNotEmpty()
  pesqueriaId: string;

  @IsNotEmpty()
  tipoFlotaId: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(5)
  valor?: number;

  @IsOptional()
  @IsInt()
  experiencia?: number;
}

export class BatchUpsertExperienciaDto {
  @IsNotEmpty()
  @Type(() => UpsertExperienciaDto)
  experiencias: UpsertExperienciaDto[];
}
