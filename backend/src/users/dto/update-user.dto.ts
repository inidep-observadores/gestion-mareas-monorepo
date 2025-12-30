import { IsString, IsOptional, MinLength } from 'class-validator';

export class UpdateUserDto {
    @IsString()
    @IsOptional()
    @MinLength(1)
    fullName?: string;

    @IsString()
    @IsOptional()
    themePreference?: string;

    @IsString()
    @IsOptional()
    avatarUrl?: string;
}
