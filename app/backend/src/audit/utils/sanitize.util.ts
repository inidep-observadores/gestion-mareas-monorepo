/**
 * Lista de campos sensibles que deben ser redactados en la auditoría
 */
const SENSITIVE_FIELDS = [
    'password',
    'newPassword',
    'oldPassword',
    'confirmPassword',
    'currentPassword',
    'token',
    'accessToken',
    'refreshToken',
    'resetToken',
    'authToken',
    'apiKey',
    'secret',
    'privateKey',
    'authorization',
    'cookie',
    'session',
    'sessionId',
];

/**
 * Verifica si un campo es sensible
 */
function isSensitiveField(fieldName: string): boolean {
    const lowerFieldName = fieldName.toLowerCase();
    return SENSITIVE_FIELDS.some(sensitiveField =>
        lowerFieldName.includes(sensitiveField.toLowerCase())
    );
}

/**
 * Sanitiza un objeto eliminando campos sensibles
 * @param obj Objeto a sanitizar
 * @param maxDepth Profundidad máxima de recursión (evita loops infinitos)
 * @returns Objeto sanitizado
 */
export function sanitizeObject(obj: any, maxDepth = 5): any {
    if (maxDepth <= 0) {
        return '[MAX_DEPTH_REACHED]';
    }

    if (obj === null || obj === undefined) {
        return obj;
    }

    // Si no es un objeto, retornar tal cual
    if (typeof obj !== 'object') {
        return obj;
    }

    // Si es un array, sanitizar cada elemento
    if (Array.isArray(obj)) {
        return obj.map(item => sanitizeObject(item, maxDepth - 1));
    }

    // Si es un objeto, sanitizar cada propiedad
    const sanitized: any = {};

    for (const key of Object.keys(obj)) {
        if (isSensitiveField(key)) {
            sanitized[key] = '***REDACTED***';
        } else if (typeof obj[key] === 'object' && obj[key] !== null) {
            sanitized[key] = sanitizeObject(obj[key], maxDepth - 1);
        } else {
            sanitized[key] = obj[key];
        }
    }

    return sanitized;
}

/**
 * Sanitiza headers HTTP eliminando campos sensibles
 */
export function sanitizeHeaders(headers: any): any {
    if (!headers || typeof headers !== 'object') {
        return headers;
    }

    const sanitized = { ...headers };

    // Eliminar headers sensibles
    const sensitiveHeaders = ['authorization', 'cookie', 'set-cookie', 'x-api-key'];

    for (const header of sensitiveHeaders) {
        if (sanitized[header]) {
            sanitized[header] = '***REDACTED***';
        }
        // También en minúsculas
        if (sanitized[header.toLowerCase()]) {
            sanitized[header.toLowerCase()] = '***REDACTED***';
        }
    }

    return sanitized;
}

/**
 * Trunca un objeto JSON si excede el tamaño máximo
 */
export function truncateIfNeeded(obj: any, maxSize: number): any {
    if (!obj) return obj;

    const jsonString = JSON.stringify(obj);

    if (jsonString.length <= maxSize) {
        return obj;
    }

    // Si excede, retornar un objeto indicando que fue truncado
    return {
        _truncated: true,
        _originalSize: jsonString.length,
        _maxSize: maxSize,
        _preview: jsonString.substring(0, Math.min(500, maxSize)),
    };
}
