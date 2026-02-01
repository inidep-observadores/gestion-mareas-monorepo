import { IsString, IsOptional, IsObject, IsArray, IsEnum } from 'class-validator';

export class CreateAuditoriaEntidadDto {
    @IsOptional()
    @IsString()
    usuarioId?: string;

    @IsOptional()
    @IsString()
    usuarioEmail?: string;

    @IsString()
    entidadTipo: string;

    @IsString()
    entidadId: string;

    @IsEnum(['INSERT', 'UPDATE', 'DELETE'])
    operacion: 'INSERT' | 'UPDATE' | 'DELETE';

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
