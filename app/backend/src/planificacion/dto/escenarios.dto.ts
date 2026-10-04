import { IsString, IsNotEmpty, IsOptional, IsInt, IsArray, IsBoolean } from 'class-validator';

export class CreateEscenarioDto {
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsString()
  @IsOptional()
  descripcion?: string;

  @IsInt()
  @IsNotEmpty()
  anioOperativo: number;

  @IsArray()
  @IsOptional()
  items?: any[];
}

export class UpdateEscenarioDto {
  @IsString()
  @IsOptional()
  tabId?: string;

  @IsString()
  @IsOptional()
  nombre?: string;

  @IsString()
  @IsOptional()
  descripcion?: string;

  @IsString()
  @IsOptional()
  estado?: string;

  @IsArray()
  @IsOptional()
  items?: any[];
}

export class CloneEscenarioDto {
  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsString()
  @IsOptional()
  descripcion?: string;
}

export class ExportEscenarioDto {
  @IsString()
  @IsNotEmpty()
  fechaDesde: string;

  @IsString()
  @IsNotEmpty()
  fechaHasta: string;

  @IsBoolean()
  @IsOptional()
  soloPlanificadas?: boolean;
}


export class AdquirirLockDto {
  @IsString()
  @IsNotEmpty()
  tabId: string;

  @IsBoolean()
  @IsOptional()
  isHeartbeat?: boolean;
}
