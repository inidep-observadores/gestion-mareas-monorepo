import { IsEnum, IsObject, IsOptional, IsString, IsUUID } from 'class-validator';
import { AuditCategoria, AuditResultado } from '../enums/audit.enums';

export class CreateAuditEventoDto {
    @IsOptional()
    @IsUUID()
    usuarioId?: string;

    @IsOptional()
    @IsString()
    usuarioEmail?: string;

    @IsString()
    tipoEvento: string;

    @IsEnum(AuditCategoria)
    categoria: AuditCategoria;

    @IsObject()
    entidadPrincipal: any;

    @IsOptional()
    @IsObject()
    entidadesRelacionadas?: any;

    @IsString()
    descripcion: string;

    @IsOptional()
    @IsObject()
    metadata?: any;

    @IsEnum(AuditResultado)
    resultado: AuditResultado;

    @IsOptional()
    @IsString()
    mensajeError?: string;
}
