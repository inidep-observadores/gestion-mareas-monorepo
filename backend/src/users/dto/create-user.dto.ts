import { IsString, MinLength, IsEmail, IsArray, IsOptional, IsBoolean } from 'class-validator';

export class CreateUserDto {
    @IsString()
    @MinLength(1)
    fullName: string;

    @IsEmail()
    email: string;

    @IsString()
    @MinLength(6)
    @IsOptional()
    password?: string; // Optional if we auto-generate or handle it differently

    @IsArray()
    @IsString({ each: true })
    @IsOptional()
    roles?: string[];

    @IsBoolean()
    @IsOptional()
    isActive?: boolean;

    @IsString()
    @IsOptional()
    avatarUrl?: string;
}
