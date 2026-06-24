import { IsString, IsNotEmpty, IsOptional, IsDateString, IsBoolean, IsIn, ValidateIf } from 'class-validator';

export class CreateNovedadDto {
  @IsString()
  @IsNotEmpty()
  observadorId: string;

  @IsString()
  @IsNotEmpty()
  @IsIn(['LICEN', 'FC', 'RP', 'ENFERMEDAD', 'MATERNIDAD', 'NACIMIENTO', 'FALLECIMIENTO', 'EXAMEN', 'DONACION_SANGRE', 'VIAJE'])
  estadoDisponibilidad: string;

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
