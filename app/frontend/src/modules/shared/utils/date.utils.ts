export class DateUtils {
    /**
     * Calcula la cantidad de días navegados entre dos fechas, considerando ambos extremos inclusivos.
     * Normaliza las fechas a medianoche (00:00:00) para ignorar la hora.
     * Ejemplo: 16/01 al 17/01 = 2 días.
     * @param start Fecha de inicio (Zarpada)
     * @param end Fecha de fin (Arribo). Si es null o undefined se usa la fecha actual.
     * @returns Número entero de días. Mínimo 1 si las fechas son válidas.
     */
    static calculateInclusiveDays(start: Date | string, end?: Date | string | null): number {
        if (!start) return 0;

        const startDate = new Date(start);
        const endDate = end ? new Date(end) : new Date();

        // Normalizar a medianoche para evitar problemas de horas
        startDate.setHours(0, 0, 0, 0);
        endDate.setHours(0, 0, 0, 0);

        if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) return 0;

        // Si la fecha de fin es anterior a la de inicio por error de datos, retornamos 0
        if (endDate < startDate) return 0;

        const diffTime = Math.abs(endDate.getTime() - startDate.getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        return diffDays + 1;
    }

    /**
     * Calcula la cantidad total de días únicos navegados dados varios intervalos.
     * Fusiona intervalos solapados para evitar conteo doble (ej: arribo y zarpada el mismo día).
     * @param intervals Lista de intervalos con start y end.
     * @returns Total de días únicos.
     */
    static calculateUniqueDays(intervals: Array<{ start: Date | string; end?: Date | string | null }>): number {
        if (!intervals.length) return 0;

        // Convertir y Normalizar
        const normalized = intervals
            .map(i => {
                const s = new Date(i.start);
                const e = i.end ? new Date(i.end) : new Date();
                s.setHours(0, 0, 0, 0);
                e.setHours(0, 0, 0, 0);
                return { start: s, end: e };
            })
            .filter(i => !isNaN(i.start.getTime()) && !isNaN(i.end.getTime()) && i.end >= i.start)
            .sort((a, b) => a.start.getTime() - b.start.getTime());

        if (!normalized.length) return 0;

        // Fusionar Intervalos
        const merged: Array<{ start: Date; end: Date }> = [];
        let current = normalized[0];

        for (let i = 1; i < normalized.length; i++) {
            const next = normalized[i];

            // Si hay solapamiento o son adyacentes
            if (next.start.getTime() <= current.end.getTime()) {
                if (next.end.getTime() > current.end.getTime()) {
                    current.end = next.end;
                }
            } else {
                merged.push(current);
                current = next;
            }
        }
        merged.push(current);

        // Sumar días de intervalos fusionados
        return merged.reduce((acc, interval) => {
            return acc + this.calculateInclusiveDays(interval.start, interval.end);
        }, 0);
    }
}
