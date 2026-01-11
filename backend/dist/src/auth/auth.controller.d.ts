import { Response, Request } from 'express';
import { IncomingHttpHeaders } from 'http';
import { AuthService } from './auth.service';
import { CreateUserDto, LoginUserDto, ForgotPasswordDto, ResetPasswordDto } from './dto';
import { User } from '@prisma/client';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    createUser(createUserDto: CreateUserDto, res: Response): Promise<{
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
    loginUser(loginUserDto: LoginUserDto, res: Response): Promise<{
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
    refreshAuth(req: Request, res: Response): Promise<{
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
    logout(res: Response): {
        ok: boolean;
    };
    private setRefreshTokenCookie;
    forgotPassword(forgotPasswordDto: ForgotPasswordDto): Promise<{
        message: string;
    }>;
    validateResetToken(token: string): Promise<{
        valid: boolean;
        email: string;
    }>;
    resetPassword(resetPasswordDto: ResetPasswordDto): Promise<{
        message: string;
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
    testingPrivateRoute(request: Express.Request, user: User, userEmail: string, rawHeaders: string[], headers: IncomingHttpHeaders): {
        ok: boolean;
        message: string;
        user: {
            id: string;
            email: string;
            password: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
        userEmail: string;
        rawHeaders: string[];
        headers: IncomingHttpHeaders;
    };
    privateRoute2(user: User): {
        ok: boolean;
        user: {
            id: string;
            email: string;
            password: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
    };
    privateRoute3(user: User): {
        ok: boolean;
        user: {
            id: string;
            email: string;
            password: string;
            fullName: string;
            isActive: boolean;
            roles: string[];
            themePreference: string;
            avatarUrl: string | null;
        };
    };
}
