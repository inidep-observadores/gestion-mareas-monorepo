import { IsInt, IsNotEmpty, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class UpsertExperienciaDto {
  @IsNotEmpty()
  observadorId: string;

  @IsNotEmpty()
  pesqueriaId: string;

  @IsNotEmpty()
  @IsInt()
  @Min(0)
  @Max(5)
  valor: number;
}

export class BatchUpsertExperienciaDto {
  @IsNotEmpty()
  @Type(() => UpsertExperienciaDto)
  experiencias: UpsertExperienciaDto[];
}
