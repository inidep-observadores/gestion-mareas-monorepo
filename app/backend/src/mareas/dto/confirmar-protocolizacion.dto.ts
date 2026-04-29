import { IsDateString, IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { Type } from 'class-transformer';

export class ConfirmarProtocolizacionDto {
  @IsInt()
  @Type(() => Number)
  @IsNotEmpty()
  nroProtocolizacion: number;

  @IsInt()
  @Type(() => Number)
  @IsNotEmpty()
  anioProtocolizacion: number;

  @IsDateString()
  @IsNotEmpty()
  fechaProtocolizacion: string;
}
