import { IsArray, IsBoolean, IsNotEmpty, IsOptional, IsUUID } from 'class-validator';
import { Transform } from 'class-transformer';

export class EnviarProtocolizacionDto {
  @Transform(({ value }) => {
    if (typeof value === 'string') return [value];
    return value;
  })
  @IsArray()
  @IsUUID('4', { each: true })
  @IsNotEmpty()
  mareaIds: string[];

  @Transform(({ value }) => value === 'true' || value === true)
  @IsBoolean()
  @IsOptional()
  enviadoPorCanalExterno?: boolean;

  @IsOptional()
  files?: any;

  @Transform(({ value }) => {
    if (typeof value === 'string') {
      try {
        return JSON.parse(value);
      } catch {
        return value;
      }
    }
    return value;
  })
  @IsOptional()
  fechasEnvio?: Record<string, string>;
}
