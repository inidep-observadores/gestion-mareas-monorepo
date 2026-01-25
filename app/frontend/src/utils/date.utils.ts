/**
 * Utilidades para manejo robusto de fechas y zonas horarias.
 * Garantiza comparaciones consistentes normalizando a la hora local.
 */

export type DateInput = string | Date | null | undefined;

/**
 * Normaliza una fecha al inicio del día (00:00:00) en la zona horaria local.
 * Esto es crucial para comparar fechas eliminando el ruido de las horas/minutos
 * y diferencias de zona horaria (UTC vs Local).
 */
export const normalizeToLocalStartOfDay = (input: DateInput): Date | null => {
    if (!input) return null;

    const date = new Date(input);
    if (isNaN(date.getTime())) return null;

    // Creamos una nueva fecha usando los componentes locales explícitos
    // Esto descarta cualquier hora que viniera en el ISO string o Date original
    return new Date(
        date.getFullYear(),
        date.getMonth(),
        date.getDate(),
        0, 0, 0, 0
    );
};

/**
 * Normaliza una fecha al final del día (23:59:59.999) en la zona horaria local.
 */
export const normalizeToLocalEndOfDay = (input: DateInput): Date | null => {
    if (!input) return null;

    const date = new Date(input);
    if (isNaN(date.getTime())) return null;

    return new Date(
        date.getFullYear(),
        date.getMonth(),
        date.getDate(),
        23, 59, 59, 999
    );
};

// --- Comparaciones estrictas de FECHA (Día/Mes/Año) ignorando la hora ---

export const isSameDay = (d1: DateInput, d2: DateInput): boolean => {
    const date1 = normalizeToLocalStartOfDay(d1);
    const date2 = normalizeToLocalStartOfDay(d2);
    if (!date1 || !date2) return false;
    return date1.getTime() === date2.getTime();
};

export const isDateBefore = (d1: DateInput, d2: DateInput): boolean => {
    const date1 = normalizeToLocalStartOfDay(d1);
    const date2 = normalizeToLocalStartOfDay(d2);
    if (!date1 || !date2) return false;
    return date1.getTime() < date2.getTime();
};

export const isDateAfter = (d1: DateInput, d2: DateInput): boolean => {
    const date1 = normalizeToLocalStartOfDay(d1);
    const date2 = normalizeToLocalStartOfDay(d2);
    if (!date1 || !date2) return false;
    return date1.getTime() > date2.getTime();
};

export const isDateSameOrBefore = (d1: DateInput, d2: DateInput): boolean => {
    const date1 = normalizeToLocalStartOfDay(d1);
    const date2 = normalizeToLocalStartOfDay(d2);
    if (!date1 || !date2) return false;
    return date1.getTime() <= date2.getTime();
};

export const isDateSameOrAfter = (d1: DateInput, d2: DateInput): boolean => {
    const date1 = normalizeToLocalStartOfDay(d1);
    const date2 = normalizeToLocalStartOfDay(d2);
    if (!date1 || !date2) return false;
    return date1.getTime() >= date2.getTime();
};

// --- Helpers de Formato Local ---

export const toLocalISOString = (input: DateInput): string | null => {
    const d = normalizeToLocalStartOfDay(input);
    if (!d) return null;

    // Ajuste manual para obtener el ISO local real sin conversión a UTC automática de toISOString()
    const offset = d.getTimezoneOffset() * 60000;
    return new Date(d.getTime() - offset).toISOString().split('T')[0];
};

/**
 * Parsea una fecha local a objeto Date asegurando consistencia
 */
export const parseFromLocal = (dateStr: string): Date | null => {
    if (!dateStr) return null;
    // Soporta formatos "YYYY-MM-DD", "DD/MM/YYYY"
    if (dateStr.includes('/')) {
        const parts = dateStr.split('/');
        if (parts.length === 3) {
            // Asume DD/MM/YYYY
            return new Date(parseInt(parts[2]), parseInt(parts[1]) - 1, parseInt(parts[0]));
        }
    }
    return normalizeToLocalStartOfDay(dateStr);
};
