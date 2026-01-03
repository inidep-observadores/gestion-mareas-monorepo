import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class ClaimMareaDto {
    @IsEmail()
    to: string;

    @IsString()
    @IsNotEmpty()
    body: string;

    @IsString()
    @IsNotEmpty()
    mareaId: string;
}
