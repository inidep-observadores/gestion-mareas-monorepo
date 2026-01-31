import { IsOptional, IsString, IsDateString, IsUUID, IsBoolean } from 'class-validator';
import { PaginationDto } from '../../common/dto/pagination.dto';

export class AuditQueryDto extends PaginationDto {
    @IsOptional()
    @IsDateString()
    desde?: string;

    @IsOptional()
    @IsDateString()
    hasta?: string;

    @IsOptional()
    @IsUUID()
    usuarioId?: string;

    @IsOptional()
    @IsString()
    categoria?: string;

    @IsOptional()
    @IsString()
    tipo?: string; // entidadTipo o tipoEvento

    @IsOptional()
    @IsString()
    entidadId?: string;

    @IsOptional()
    @IsBoolean()
    soloErrores?: boolean;

    @IsOptional()
    @IsString()
    busqueda?: string;
}
