import { IsBoolean, IsInt, IsString } from 'class-validator';

export class CreateArtePescaDto {
    @IsInt()
    codigoNumerico: number;

    @IsString()
    nombre: string;

    @IsBoolean()
    activo: boolean;
}
