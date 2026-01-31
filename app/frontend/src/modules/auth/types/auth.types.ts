import { ValidRoles } from '../interfaces/roles.enum';

export interface User {
    id: string;
    email: string;
    fullName: string;
    isActive: boolean;
    roles: ValidRoles[];
    avatarUrl?: string;
}

export interface AuthResponse {
    user: User;
    token: string;
}

export interface CheckStatusResponse {
    user: User;
    token: string;
}

export type AuthStatus = 'authenticated' | 'unauthenticated' | 'authenticating';
