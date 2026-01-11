import { PrismaService } from '../prisma/prisma.service';
import { UpdateUserDto, ChangePasswordDto, CreateUserDto, AdminUpdateUserDto } from './dto';
import { User } from '@prisma/client';
import { HashService } from '../common/services/hash.service';
export declare class UsersService {
    private readonly prisma;
    private readonly hashService;
    constructor(prisma: PrismaService, hashService: HashService);
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
    updateAvatar(user: User, avatarUrl: string): Promise<{
        id: string;
        email: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
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
    update(id: string, adminUpdateUserDto: AdminUpdateUserDto, currentUser: User): Promise<{
        id: string;
        email: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    toggleStatus(id: string, currentUser: User): Promise<{
        id: string;
        email: string;
        password: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    remove(id: string, currentUser: User): Promise<{
        id: string;
        email: string;
        password: string;
        fullName: string;
        isActive: boolean;
        roles: string[];
        themePreference: string;
        avatarUrl: string | null;
    }>;
    private handleDBErrors;
}
