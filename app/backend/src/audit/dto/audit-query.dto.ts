import { IsOptional, IsString, IsDateString, IsUUID, IsBoolean } from 'class-validator';
import { Transform } from 'class-transformer';
import { PaginationDto } from '../../common/dto/pagination.dto';

export class AuditQueryDto extends PaginationDto {
    @IsOptional()
    @Transform(({ value }) => (value === '' ? undefined : value))
    @IsDateString()
    desde?: string;

    @IsOptional()
    @Transform(({ value }) => (value === '' ? undefined : value))
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
    @Transform(({ value }) => {
        if (value === 'true') return true;
        if (value === 'false') return false;
        return value;
    })
    @IsBoolean()
    soloErrores?: boolean;

    @IsOptional()
    @IsString()
    busqueda?: string;
}
