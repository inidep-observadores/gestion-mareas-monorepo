import { IsArray, IsBoolean, IsNotEmpty, IsOptional, IsUUID } from 'class-validator';

export class EnviarProtocolizacionDto {
  @IsArray()
  @IsUUID('4', { each: true })
  @IsNotEmpty()
  mareaIds: string[];

  @IsBoolean()
  @IsOptional()
  enviadoPorCanalExterno?: boolean;
}
