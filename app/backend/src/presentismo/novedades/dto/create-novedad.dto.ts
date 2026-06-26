import { IsString, IsNotEmpty, IsOptional, IsDateString, IsBoolean, IsIn, ValidateIf } from 'class-validator';

export class CreateNovedadDto {
  @IsString()
  @IsNotEmpty()
  observadorId: string;

  @IsString()
  @IsNotEmpty()
  tipoNovedadId: string;

  @IsDateString()
  @IsNotEmpty()
  fechaInicio: string;

  @IsDateString()
  @IsOptional()
  fechaFin?: string;

  @IsBoolean()
  @IsOptional()
  permiteUrgencia?: boolean;

  @IsString()
  @IsOptional()
  motivo?: string;
}
