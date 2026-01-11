import { JwtService } from '@nestjs/jwt';
import { MailerService } from '@nestjs-modules/mailer';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '@prisma/client';
import { LoginUserDto, CreateUserDto, ResetPasswordDto } from './dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';
import { HashService } from '../common/services/hash.service';
export declare class AuthService {
    private readonly prisma;
    private readonly jwtService;
    private readonly mailerService;
    private readonly hashService;
    constructor(prisma: PrismaService, jwtService: JwtService, mailerService: MailerService, hashService: HashService);
    create(createUserDto: CreateUserDto): Promise<{
        user: {
            id: string;
            email: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
        token: string;
        refreshToken: string;
    }>;
    login(loginUserDto: LoginUserDto): Promise<{
        user: {
            id: string;
            email: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
        token: string;
        refreshToken: string;
    }>;
    checkAuthStatus(user: User): Promise<{
        user: {
            id: string;
            email: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
        token: string;
    }>;
    private getJwtToken;
    private handleDBErrors;
    forgotPassword(email: string): Promise<{
        message: string;
    }>;
    validateResetToken(token: string): Promise<{
        valid: boolean;
        email: string;
    }>;
    resetPassword(resetPasswordDto: ResetPasswordDto): Promise<{
        message: string;
    }>;
    getRefreshJwtToken(payload: JwtPayload): string;
    refreshAuth(refreshToken: string): Promise<{
        user: {
            id: string;
            email: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
        token: string;
        refreshToken: string;
    }>;
}
