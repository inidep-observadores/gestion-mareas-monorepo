import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { User, AuthStatus } from '../types/auth.types';
import authApi, { type LoginDto, type RegisterDto } from '../services/auth.service';
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

        // Optimistic check: only try if we think we might be logged in?
        // Actually for robust SPA, we always try checkStatus on reload 
        // because refresh token might be in cookie.

        try {
            // Check status checks validity of access token or gets 401
            // If 401, interceptor tries refresh.
            // If refresh fails, it throws 401 and we clear auth.
            // But checkStatus endpoint is protected? Yes.
            // So if we have no access token in memory (which is always true on F5),
            // we need to rely on cookie.

            // WAIT: checkStatus requires Bearer token? 
            // If access token is in memory, it's gone on F5.
            // So on F5, checkStatus request will satisfy 'unauthorized' initially?
            // No, checkStatus endpoint @Auth() requires valid JWT.
            // If we send request without Header, it fails immediately.

            // Strategy: 
            // On F5, we have NO access token.
            // We should call 'refresh' endpoint first! 
            // OR allow checkStatus to be public? No.

            // CORRECT FLOW FOR F5:
            // 1. Try /auth/refresh directly.
            // 2. If success, we have user + new access token.
            // 3. If fail, we are unauthenticated.

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
        whenReady
    };
});
