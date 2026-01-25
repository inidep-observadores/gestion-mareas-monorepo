import { IsString, MinLength, Matches } from 'class-validator';

export class ResetPasswordDto {
    @IsString()
    token: string;

    @IsString()
    @MinLength(6)
    @Matches(
        /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
        message: 'The password must have a Uppercase, lowercase letter and a number'
    })
    newPassword: string;
}
