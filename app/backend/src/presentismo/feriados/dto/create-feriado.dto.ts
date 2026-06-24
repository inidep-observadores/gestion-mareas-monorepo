import { IsDateString, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateFeriadoDto {
  @IsDateString()
  @IsNotEmpty()
  fecha: string;

  @IsString()
  @IsNotEmpty()
  nombre: string;

  @IsString()
  @IsNotEmpty()
  tipo: string;

  @IsString()
  @IsOptional()
  origen?: string;
}
