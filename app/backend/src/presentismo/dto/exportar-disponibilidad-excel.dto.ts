import { IsString, IsNotEmpty, IsArray, IsOptional } from 'class-validator';

export class ExportarDisponibilidadExcelDto {
  @IsString()
  @IsNotEmpty()
  fechaDesde: string;

  @IsString()
  @IsNotEmpty()
  fechaHasta: string;

  @IsArray()
  @IsOptional()
  observadorIds?: string[];
}

