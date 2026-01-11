import { ConfigService } from '@nestjs/config';
import { UsersService } from './users.service';
import { User } from '@prisma/client';
import { UpdateUserDto, ChangePasswordDto, CreateUserDto, AdminUpdateUserDto } from './dto';
export declare class UsersController {
    private readonly usersService;
    private readonly configService;
    constructor(usersService: UsersService, configService: ConfigService);
    getProfile(user: User): {
        id: string;
        email: string;
        password: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    };
    updateProfile(user: User, updateUserDto: UpdateUserDto): Promise<{
        id: string;
        email: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    changePassword(user: User, changePasswordDto: ChangePasswordDto): Promise<{
        message: string;
    }>;
    findAll(): Promise<{
        id: string;
        email: string;
        password: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }[]>;
    create(createUserDto: CreateUserDto): Promise<{
        id: string;
        email: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    update(id: string, adminUpdateUserDto: AdminUpdateUserDto, user: User): Promise<{
        id: string;
        email: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    toggleStatus(id: string, user: User): Promise<{
        id: string;
        email: string;
        password: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    remove(id: string, user: User): Promise<{
        id: string;
        email: string;
        password: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
}
