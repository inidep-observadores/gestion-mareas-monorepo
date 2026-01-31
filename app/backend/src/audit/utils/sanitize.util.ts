
/**
 * Lista de campos que deben ser ofuscados en los logs de auditoría
 */
export const SENSITIVE_FIELDS = [
    'password',
    'newPassword',
    'oldPassword',
    'confirmPassword',
    'token',
    'accessToken',
    'refreshToken',
    'resetToken',
    'authorization',
    'cookie',
    'session',
    'secret',
    'credential',
    'creditCard',
    'cvv'
];

/**
 * Sanitiza un objeto reemplazando valores sensibles
 * @param obj Objeto a sanitizar
 * @returns Objeto sanitizado (copia)
 */
export function sanitizeObject(obj: any): any {
    if (!obj) return obj;
    if (typeof obj !== 'object') return obj;

    // Manejar arrays
    if (Array.isArray(obj)) {
        return obj.map(item => sanitizeObject(item));
    }

    // Clonar para no mutar original
    const sanitized = { ...obj };

    for (const key of Object.keys(sanitized)) {
        const value = sanitized[key];
        const lowerKey = key.toLowerCase();

        // Verificar si es campo sensible
        if (SENSITIVE_FIELDS.some(field => lowerKey.includes(field.toLowerCase()))) {
            sanitized[key] = '***REDACTED***';
        }
        // Recursividad para objetos anidados
        else if (typeof value === 'object' && value !== null) {
            sanitized[key] = sanitizeObject(value);
        }
    }

    return sanitized;
}
