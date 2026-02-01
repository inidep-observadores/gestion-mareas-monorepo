import { IsString, IsOptional, IsObject, IsEnum } from 'class-validator';
import { AuditCategoria } from '../enums/audit-categoria.enum';
import { AuditResultado } from '../enums/audit-resultado.enum';

export class CreateAuditoriaEventoDto {
    @IsOptional()
    @IsString()
    usuarioId?: string;

    @IsOptional()
    @IsString()
    usuarioEmail?: string;

    @IsString()
    tipoEvento: string;

    @IsEnum(AuditCategoria)
    categoria: AuditCategoria;

    @IsObject()
    entidadPrincipal: {
        tipo: string;
        id: string;
        nombre?: string;
    };

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
