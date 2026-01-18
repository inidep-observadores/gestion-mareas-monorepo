export class DateUtils {
    /**
     * Calcula la cantidad de días navegados entre dos fechas, considerando ambos extremos inclusivos.
     * Ejemplo: 16/01 al 17/01 = 2 días.
     * @param start Fecha de inicio (Zarpada)
     * @param end Fecha de fin (Arribo). Si es null se usa la fecha actual (marea en curso).
     * @returns Número entero de días. Mínimo 1 si las fechas son válidas.
     */
    static calculateInclusiveDays(start: Date | string, end?: Date | string | null): number {
        if (!start) return 0;

        const startDate = new Date(start);
        const endDate = end ? new Date(end) : startDate;

        // Normalizar a medianoche para evitar problemas de horas
        startDate.setHours(0, 0, 0, 0);
        endDate.setHours(0, 0, 0, 0);

        if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) return 0;

        // Si la fecha de fin es anterior a la de inicio, retornamos 0 (o error de datos)
        if (endDate < startDate) return 0;

        const diffTime = Math.abs(endDate.getTime() - startDate.getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        return diffDays + 1;
    }

    /**
     * Calcula la intersección de días entre un rango de fechas y un año específico.
     * @param start Fecha Inicio
     * @param end Fecha Fin
     * @param year Año a filtrar
     */
    static calculateDaysInYear(start: Date | string, end: Date | string | null, year: number): number {
        if (!start) return 0;

        const startDate = new Date(start);
        startDate.setHours(0, 0, 0, 0);

        const endDate = end ? new Date(end) : startDate;
        endDate.setHours(0, 0, 0, 0);

        const yearStart = new Date(year, 0, 1, 0, 0, 0, 0); // Enero 1
        const yearEnd = new Date(year, 11, 31, 0, 0, 0, 0); // Dic 31

        // Calcular intersección
        const effectiveStart = startDate < yearStart ? yearStart : startDate;
        const effectiveEnd = endDate > yearEnd ? yearEnd : endDate;

        if (effectiveStart > effectiveEnd) return 0;

        const diffTime = Math.abs(effectiveEnd.getTime() - effectiveStart.getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        return diffDays + 1;
    }

    /**
     * Calcula la cantidad total de días únicos navegados dados varios intervalos.
     * Fusiona intervalos solapados para evitar conteo doble (ej: arribo y zarpada el mismo día).
     * @param intervals Lista de intervalos con start y end.
     * @param year Año opcional para filtrar días (modo calendario).
     * @returns Total de días únicos.
     */
    static calculateUniqueDays(intervals: Array<{ start: Date | string; end?: Date | string | null }>, year?: number): number {
        if (!intervals.length) return 0;

        // Convertir y Normalizar
        const normalized = intervals
            .map(i => {
                const s = new Date(i.start);
                // WARNING: If end is null, we NO LONGER use new Date() by default here 
                // to prevent historical data from inflating.
                const e = i.end ? new Date(i.end) : new Date(s);
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
            if (year) {
                return acc + this.calculateDaysInYear(interval.start, interval.end, year);
            }
            return acc + this.calculateInclusiveDays(interval.start, interval.end);
        }, 0);
    }
}
