import httpClient from '@/config/http/http.client';
import type { AuthResponse, CheckStatusResponse } from '../types/auth.types';

// DTO interfaces
export interface LoginDto {
    email: string;
    password: string;
    remember?: boolean;
}

export interface RegisterDto {
    email: string;
    password: string;
    fullName: string;
}

const authApi = {
    login: async (credentials: LoginDto): Promise<AuthResponse> => {
        const { data } = await httpClient.post<AuthResponse>('/auth/login', credentials);
        return data;
    },

    register: async (user: RegisterDto): Promise<AuthResponse> => {
        const { data } = await httpClient.post<AuthResponse>('/auth/register', user);
        return data;
    },

    checkStatus: async (): Promise<CheckStatusResponse> => {
        const { data } = await httpClient.get<CheckStatusResponse>('/auth/check-status');
        return data;
    },

    // Refresh is handled via interceptor mostly, but can be explicit
    refresh: async (): Promise<AuthResponse> => {
        const { data } = await httpClient.get<AuthResponse>('/auth/refresh');
        return data;
    },

    logout: async (): Promise<void> => {
        await httpClient.post('/auth/logout');
    },
};

export default authApi;
