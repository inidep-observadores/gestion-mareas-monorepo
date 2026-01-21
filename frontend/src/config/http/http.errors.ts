export interface ApiError {
    code: string;
    message: string;
    field?: string; // For form validation
}

export class AppError extends Error {
    public readonly code: string;
    public readonly validationErrors?: Record<string, string>;

    constructor(message: string, code = 'UNKNOWN_ERROR', validationErrors?: Record<string, string>) {
        super(message);
        this.name = 'AppError';
        this.code = code;
        this.validationErrors = validationErrors;
    }
}

export function normalizeError(error: any): AppError {
    if (error instanceof AppError) return error;

    // Axios Error
    if (error.isAxiosError && error.response) {
        const data = error.response.data;

        // NestJS Default Error Structure
        if (data && typeof data === 'object') {
            const message = data.message;
            const errorTitle = data.error || 'API_ERROR';

            // If message is array (class-validator), map it
            if (Array.isArray(message)) {
                // Join validation messages into a single readable string
                const combinedMessage = message.join('. ');
                return new AppError(combinedMessage, 'VALIDATION_ERROR');
            }

            if (typeof message === 'string') {
                return new AppError(message, errorTitle);
            }
        }
    }

    // Network Error
    if (error.request) {
        return new AppError('No se pudo conectar con el servidor. Verifique su conexión.', 'NETWORK_ERROR');
    }

    // Error con mensaje directo
    if (error.message) {
        return new AppError(error.message, 'UNKNOWN_ERROR');
    }

    return new AppError('Error desconocido', 'UNKNOWN_ERROR');
}
