import { IsBoolean, IsEnum, IsInt, IsOptional, IsString, IsUUID, IsObject } from 'class-validator';
import { AuditCategoria } from '../enums/audit.enums';

export class CreateAuditApiDto {
    @IsOptional()
    @IsUUID()
    usuarioId?: string;

    @IsOptional()
    @IsString()
    usuarioEmail?: string;

    @IsOptional()
    @IsString()
    sessionId?: string;

    @IsString()
    metodoHttp: string;

    @IsString()
    ruta: string;

    @IsString()
    rutaBase: string;

    @IsOptional()
    @IsObject()
    queryParams?: any;

    @IsOptional()
    @IsObject()
    requestBody?: any;

    @IsInt()
    statusCode: number;

    @IsOptional()
    @IsObject()
    responseBody?: any;

    @IsOptional()
    @IsString()
    errorMessage?: string;

    @IsInt()
    responseTimeMs: number;

    @IsOptional()
    @IsString()
    ip?: string;

    @IsOptional()
    @IsString()
    userAgent?: string;

    @IsEnum(AuditCategoria)
    categoria: AuditCategoria;

    @IsOptional()
    @IsString()
    accion?: string;

    @IsOptional()
    @IsString()
    entidadTipo?: string;

    @IsOptional()
    @IsString()
    entidadId?: string;

    @IsBoolean()
    esError: boolean;

    @IsBoolean()
    esCritico: boolean;
}
