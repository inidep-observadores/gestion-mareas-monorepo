import { IsOptional, IsInt, IsString, IsArray, IsUUID } from 'class-validator';
import { Type } from 'class-transformer';

export class ExportMareaDto {
    @IsOptional()
    @IsInt()
    @Type(() => Number)
    year?: number;

    @IsOptional()
    @IsString()
    searchQuery?: string;

    @IsOptional()
    @IsArray()
    @IsUUID('all', { each: true })
    ids?: string[];
}
