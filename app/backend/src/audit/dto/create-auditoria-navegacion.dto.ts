import { IsString, IsOptional, IsInt, IsObject } from 'class-validator';

export class CreateAuditoriaNavegacionDto {
    @IsOptional()
    @IsString()
    usuarioId?: string;

    @IsString()
    sessionId: string;

    @IsOptional()
    @IsString()
    rutaOrigen?: string;

    @IsString()
    rutaDestino: string;

    @IsOptional()
    @IsObject()
    parametros?: any;

    @IsOptional()
    @IsInt()
    tiempoVistaMs?: number;
}
