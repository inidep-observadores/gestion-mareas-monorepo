import type { User } from '@/modules/auth/types/auth.types';
import httpClient from '@/config/http/http.client';

export interface CreateUserDto {
    fullName: string;
    email: string;
    password?: string;
    roles?: string[];
    isActive?: boolean;
}

export interface UpdateUserDto {
    fullName?: string;
    email?: string; // Usually not editable but let's see
    password?: string;
    roles?: string[];
    isActive?: boolean;
    avatarUrl?: string;
}

const usersAdminApi = {
    getUsers: async (): Promise<User[]> => {
        const { data } = await httpClient.get<User[]>('/users');
        return data;
    },

    createUser: async (user: CreateUserDto): Promise<User> => {
        const { data } = await httpClient.post<User>('/users', user);
        return data;
    },

    updateUser: async (id: string, user: UpdateUserDto): Promise<User> => {
        const { data } = await httpClient.patch<User>(`/users/${id}`, user);
        return data;
    },

    toggleStatus: async (id: string): Promise<User> => {
        const { data } = await httpClient.patch<User>(`/users/${id}/toggle-status`);
        return data;
    },

    uploadOnly: async (file: File): Promise<string> => {
        const formData = new FormData();
        formData.append('file', file);
        const { data } = await httpClient.post<{ secureUrl: string }>('/files/user', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });
        return data.secureUrl;
    }
}

export default usersAdminApi;
