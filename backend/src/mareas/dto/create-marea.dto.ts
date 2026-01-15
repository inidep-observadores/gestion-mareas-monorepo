import { IsInt, IsNotEmpty, IsOptional, IsString, IsUUID, IsDateString, Min, Max } from 'class-validator';

export class CreateMareaDto {
    @IsUUID()
    @IsNotEmpty()
    buqueId: string;

    @IsInt()
    @Min(2000)
    @Max(2100)
    anioMarea: number;

    @IsInt()
    @Min(1)
    nroMarea: number;

    @IsUUID()
    @IsNotEmpty()
    pesqueriaId: string;

    @IsUUID()
    @IsOptional()
    observadorId?: string;

    @IsUUID()
    @IsOptional()
    arteId?: string;

    @IsDateString()
    @IsOptional()
    fechaZarpadaEstimada?: string;

    @IsString()
    @IsOptional()
    tipoMarea?: string;

    @IsInt()
    @IsOptional()
    diasEstimados?: number;
}
