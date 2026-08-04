import { PartialType } from '@nestjs/mapped-types';
import { CreateNovedadDto } from './create-novedad.dto';
import { IsString, IsOptional, IsIn } from 'class-validator';

export class UpdateNovedadDto extends PartialType(CreateNovedadDto) {
    @IsString()
    @IsOptional()
    @IsIn(['PENDIENTE', 'APROBADA', 'RECHAZADA'])
    estadoAprobacion?: string;

    @IsString()
    @IsOptional()
    comentarioMovimiento?: string;

    @IsOptional()
    eliminarArchivoViejo?: boolean;
}

