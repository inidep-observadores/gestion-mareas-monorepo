import { IsArray, IsObject, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateAuditEntidadDto {
    @IsOptional()
    @IsUUID()
    usuarioId?: string;

    @IsOptional()
    @IsString()
    usuarioEmail?: string;

    @IsString()
    entidadTipo: string;

    @IsString()
    entidadId: string;

    @IsString()
    operacion: string; // INSERT, UPDATE, DELETE

    @IsOptional()
    @IsObject()
    valoresAnteriores?: any;

    @IsOptional()
    @IsObject()
    valoresNuevos?: any;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    camposModificados?: string[];

    @IsOptional()
    @IsObject()
    contexto?: any;
}
