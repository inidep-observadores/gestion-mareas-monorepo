import axios, { type AxiosInstance, type AxiosRequestConfig, type AxiosError } from 'axios';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import { normalizeError } from './http.errors';
import { toast } from 'vue-sonner';

// Custom type for Axios config to support skipToast
declare module 'axios' {
    export interface AxiosRequestConfig {
        skipToast?: boolean;
    }
}

// Create Axios Instance
const httpClient: AxiosInstance = axios.create({
    baseURL: import.meta.env.VITE_BACKEND_URL,
    withCredentials: true, // Critical for httpOnly cookies
    timeout: 30000, // Aumentado a 30s para procesos pesados como backup
    headers: {
        'Content-Type': 'application/json',
    },
});

// Refresh Token Logic
let isRefreshing = false;
let failedQueue: Array<{
    resolve: (token?: string) => void;
    reject: (error: any) => void;
}> = [];

const processQueue = (error: any, token: string | null = null) => {
    failedQueue.forEach((prom) => {
        if (error) {
            prom.reject(error);
        } else {
            prom.resolve(token || undefined);
        }
    });

    failedQueue = [];
};

// Response Interceptor
httpClient.interceptors.response.use(
    (response) => {
        return response;
    },
    async (error: AxiosError) => {
        const originalRequest = error.config as AxiosRequestConfig & { _retry?: boolean };
        const authStore = useAuthStore();

        // prevent loop for auth endpoints
        if (originalRequest.url?.includes('/auth/login') || originalRequest.url?.includes('/auth/refresh')) {
            const appError = normalizeError(error);
            if (!originalRequest.skipToast) {
                toast.error(appError.message);
            }
            return Promise.reject(appError);
        }

        if (error.response?.status === 401 && !originalRequest._retry) {
            if (isRefreshing) {
                return new Promise(function (resolve, reject) {
                    failedQueue.push({ resolve, reject });
                })
                    .then(() => {
                        return httpClient(originalRequest);
                    })
                    .catch((err) => {
                        return Promise.reject(err);
                    });
            }

            originalRequest._retry = true;
            isRefreshing = true;

            try {
                await authStore.refresh(); // This calls the refresh endpoint
                processQueue(null, 'refreshed');
                return httpClient(originalRequest);
            } catch (err) {
                processQueue(err, null);
                // Terminal Logout
                authStore.logout();

                const appError = normalizeError(err);
                if (!originalRequest.skipToast) {
                    toast.error(appError.message);
                }
                return Promise.reject(appError);
            } finally {
                isRefreshing = false;
            }
        }

        const appError = normalizeError(error);

        // MOSTRAR TOAST AUTOMÁTICO (si no se pide explícitamente saltarlo)
        if (!originalRequest?.skipToast) {
            toast.error(appError.message);
        }

        return Promise.reject(appError);
    }
);

// Request Interceptor (Attach Access Token if in memory)
httpClient.interceptors.request.use(
    (config) => {
        const authStore = useAuthStore();
        if (authStore.token && config.headers) {
            config.headers.Authorization = `Bearer ${authStore.token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

export default httpClient;

