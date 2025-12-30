import axios, { type AxiosInstance, type AxiosRequestConfig, type AxiosError } from 'axios';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import { normalizeError } from './http.errors';

// Create Axios Instance
const httpClient: AxiosInstance = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
    withCredentials: true, // Critical for httpOnly cookies
    timeout: 10000,
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
            return Promise.reject(normalizeError(error));
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
                // Redirect is handled by router guard or store
                return Promise.reject(normalizeError(err));
            } finally {
                isRefreshing = false;
            }
        }

        return Promise.reject(normalizeError(error));
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
