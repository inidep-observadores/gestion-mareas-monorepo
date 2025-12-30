import type { AxiosError } from 'axios';
import httpClient from '@/config/http/http.client';
import type { User } from '../types/auth.types';

export interface UpdateProfileDto {
    fullName?: string;
    themePreference?: string;
    avatarUrl?: string;
}

export interface ChangePasswordDto {
    currentPassword: string;
    newPassword: string;
}

const usersApi = {
    updateProfile: async (data: UpdateProfileDto): Promise<User> => {
        const { data: user } = await httpClient.patch<User>('/users/me', data);
        return user;
    },

    changePassword: async (data: ChangePasswordDto): Promise<{ message: string }> => {
        const { data: response } = await httpClient.patch<{ message: string }>('/users/me/password', data);
        return response;
    },

    uploadOnly: async (file: File): Promise<string> => {
        const formData = new FormData();
        formData.append('file', file);

        const { data } = await httpClient.post<{ secureUrl: string }>('/files/user', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return data.secureUrl;
    },

    uploadAvatar: async (file: File): Promise<User> => {
        const secureUrl = await usersApi.uploadOnly(file);
        const { data: user } = await httpClient.patch<User>('/users/me', { avatarUrl: secureUrl });
        return user;
    }
}

export default usersApi;
