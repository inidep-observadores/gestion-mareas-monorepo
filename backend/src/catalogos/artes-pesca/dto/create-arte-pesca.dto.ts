import { IsBoolean, IsInt, IsString } from 'class-validator';

export class CreateArtePescaDto {
    @IsInt()
    codigoNumerico: number;

    @IsString()
    descripcion: string;

    @IsBoolean()
    activo: boolean;
}
