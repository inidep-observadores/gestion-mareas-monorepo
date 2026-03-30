import { IsInt, IsNotEmpty, IsNumber, IsOptional, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class UpsertRequerimientoDto {
  @IsNotEmpty()
  @IsNumber()
  anioOperativo: number;

  @IsNotEmpty()
  @IsNumber()
  mes: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  cantidad?: number;

  @IsNotEmpty()
  pesqueriaId: string;

  @IsNotEmpty()
  tipoFlotaId: string;
}

export class BatchUpsertRequerimientosDto {
  @IsNotEmpty()
  @IsNumber()
  anioOperativo: number;

  @IsNotEmpty()
  @Type(() => UpsertRequerimientoDto)
  requerimientos: UpsertRequerimientoDto[];
}
