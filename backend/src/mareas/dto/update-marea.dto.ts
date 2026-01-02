import { PartialType } from '@nestjs/mapped-types';
import { CreateMareaDto } from './create-marea.dto';
import { IsInt, IsOptional, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class UpdateMareaDto extends PartialType(CreateMareaDto) {
    @IsInt()
    @IsOptional()
    diasZonaAustral?: number;

    // TODO: Definir DTO para Etapas si se requiere nested update
    @IsArray()
    @IsOptional()
    etapas?: any[];
}
