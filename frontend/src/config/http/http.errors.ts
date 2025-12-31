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
    if (error.response) {
        const data = error.response.data;

        // NestJS Default Error Structure
        if (data.message) {
            // If message is array (class-validator), map it
            if (Array.isArray(data.message)) {
                const validationErrors: Record<string, string> = {};
                data.message.forEach((msg: string, index: number) => {
                    validationErrors[`error_${index}`] = msg;
                });
                // Better: If we can't parse field, join messages
                return new AppError('Error de validación', 'VALIDATION_ERROR', validationErrors);
            }
            return new AppError(data.message, data.error || 'API_ERROR');
        }
    }

    // Network Error
    if (error.request) {
        return new AppError('No se pudo conectar con el servidor', 'NETWORK_ERROR');
    }

    return new AppError(error.message || 'Error desconocido', 'UNKNOWN_ERROR');
}
