import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { User, AuthStatus } from '../types/auth.types';
import authApi, { type LoginDto, type RegisterDto } from '../services/auth.service';
import usersApi, { type UpdateProfileDto, type ChangePasswordDto } from '../services/users.service';
import { AppError } from '@/config/http/http.errors';

export const useAuthStore = defineStore('auth', () => {

    // State
    const status = ref<AuthStatus>('authenticating');
    const user = ref<User | null>(null);
    const token = ref<string | null>(null);
    const isReady = ref(false); // For bootstrap

    // Getters
    const isAuthenticated = computed(() => status.value === 'authenticated');
    const fullName = computed(() => user.value?.fullName || '');

    // Actions
    const setAuth = (newUser: User, newToken: string) => {
        user.value = newUser;
        token.value = newToken;
        status.value = 'authenticated';
    };

    const clearAuth = () => {
        user.value = null;
        token.value = null;
        status.value = 'unauthenticated';
    };

    const login = async (credentials: LoginDto) => {
        try {
            const { user, token } = await authApi.login(credentials);
            setAuth(user, token);
            return { ok: true };
        } catch (error) {
            return { ok: false, error: error as AppError };
        }
    };

    const register = async (userData: RegisterDto) => {
        try {
            const { user, token } = await authApi.register(userData);
            setAuth(user, token);
            return { ok: true };
        } catch (error) {
            return { ok: false, error: error as AppError };
        }
    };

    const logout = async () => {
        try {
            await authApi.logout();
        } catch (error) {
            // Ignore logout errors
        } finally {
            clearAuth();
        }
    };

    const checkAuthStatus = async () => {
        try {
            const { user, token } = await authApi.checkStatus();
            setAuth(user, token);
            return true;
        } catch (error) {
            clearAuth();
            return false;
        }
    };

    const updateProfile = async (data: UpdateProfileDto) => {
        try {
            const updatedUser = await usersApi.updateProfile(data);
            user.value = { ...user.value, ...updatedUser } as User;
            return { ok: true };
        } catch (error) {
            return { ok: false, error: error as AppError };
        }
    };

    const changePassword = async (data: ChangePasswordDto) => {
        try {
            await usersApi.changePassword(data);
            return { ok: true };
        } catch (error) {
            return { ok: false, error: error as AppError };
        }
    };

    const uploadAvatar = async (file: File) => {
        try {
            const updatedUser = await usersApi.uploadAvatar(file);
            user.value = { ...user.value, ...updatedUser } as User;
            return { ok: true };
        } catch (error) {
            return { ok: false, error: error as AppError };
        }
    };

    // Called by interceptor
    const refresh = async () => {
        try {
            const { user, token } = await authApi.refresh();
            setAuth(user, token);
            return true;
        } catch (error) {
            clearAuth();
            throw error;
        }
    };

    // Bootstrap Session (called in main.ts)
    const bootstrap = async () => {
        if (isReady.value) return;

        try {
            await refresh(); // Calls /auth/refresh with cookie
        } catch (error) {
            // It's normal to fail if user is not logged in
            clearAuth();
        } finally {
            isReady.value = true;
            if (status.value === 'authenticating') {
                status.value = 'unauthenticated';
            }
        }
    };

    const whenReady = () => {
        return new Promise<void>((resolve) => {
            if (isReady.value) {
                resolve();
            } else {
                const interval = setInterval(() => {
                    if (isReady.value) {
                        clearInterval(interval);
                        resolve();
                    }
                }, 50);
            }
        });
    }

    const uploadOnly = async (file: File) => {
        try {
            const secureUrl = await usersApi.uploadOnly(file);
            return { ok: true, url: secureUrl };
        } catch (error) {
            return { ok: false, error: error as AppError };
        }
    };

    return {
        // State
        status,
        user,
        token,
        isReady,
        isAuthenticated,
        fullName,

        // Actions
        login,
        register,
        logout,
        checkAuthStatus,
        refresh,
        bootstrap,
        whenReady,
        updateProfile,
        changePassword,
        uploadAvatar,
        uploadOnly
    };
});
