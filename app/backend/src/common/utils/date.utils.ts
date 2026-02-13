import { DateTime } from 'luxon';
import { APP_CONFIG } from '../constants';

export class DateUtils {
    /**
     * Obtiene la fecha actual respetando la zona horaria configurada en APP_TIMEZONE.
     * @param withTime Si es true, retorna la fecha con hora actual. Si es false (default), retorna el inicio del día (00:00:00).
     * @returns Instancia de Date convertida a JS Date estándar.
     */
    static getNow(withTime: boolean = false): Date {
        const timezone = process.env.APP_TIMEZONE || 'UTC';
        const now = DateTime.now().setZone(timezone);

        if (withTime) {
            return now.toJSDate();
        }

        return now.startOf('day').toJSDate();
    }

    /**
     * Formatea una fecha según el formato global configurado en APP_CONFIG.
     * @param date Fecha a formatear
     * @returns String formateado o '-' si es inválida
     */
    static formatDate(date: Date | string | null | undefined): string {
        if (!date) return '-';
        const d = new Date(date);
        if (isNaN(d.getTime())) return '-';

        const day = d.getDate().toString().padStart(2, '0');
        const month = (d.getMonth() + 1).toString().padStart(2, '0');
        const year = d.getFullYear();

        return APP_CONFIG.DATE_FORMAT
            .replace('DD', day)
            .replace('MM', month)
            .replace('YYYY', year.toString());
    }

    /**
     * Calcula la cantidad de días navegados entre dos fechas, considerando ambos extremos inclusivos.
     * Ejemplo: 16/01 al 17/01 = 2 días.
     * @param start Fecha de inicio (Zarpada)
     * @param end Fecha de fin (Arribo). Si es null se usa la fecha actual (marea en curso).
     * @returns Número entero de días. Mínimo 1 si las fechas son válidas.
     */
    static calculateInclusiveDays(start: Date | string, end?: Date | string | null): number {
        if (!start) return 0;

        const s = DateTime.fromJSDate(new Date(start)).setZone('UTC').startOf('day');
        const e = end 
            ? DateTime.fromJSDate(new Date(end)).setZone('UTC').startOf('day') 
            : DateTime.fromJSDate(this.getNow(true)).setZone('UTC').startOf('day');

        if (!s.isValid || !e.isValid) return 0;
        if (e < s) return 0;

        const diff = e.diff(s, 'days').days;
        return Math.floor(diff) + 1;
    }

    /**
     * Calcula la intersección de días entre un rango de fechas y un año específico.
     * @param start Fecha Inicio
     * @param end Fecha Fin
     * @param year Año a filtrar
     */
    static calculateDaysInYear(start: Date | string, end: Date | string | null, year: number): number {
        if (!start) return 0;

        const s = DateTime.fromJSDate(new Date(start)).setZone('UTC').startOf('day');
        const e = end ? DateTime.fromJSDate(new Date(end)).setZone('UTC').startOf('day') : s;

        const yearStart = DateTime.fromObject({ year, month: 1, day: 1 }, { zone: 'UTC' }).startOf('day');
        const yearEnd = DateTime.fromObject({ year, month: 12, day: 31 }, { zone: 'UTC' }).startOf('day');

        // Calcular intersección
        const effectiveStart = s < yearStart ? yearStart : s;
        const effectiveEnd = e > yearEnd ? yearEnd : e;

        if (effectiveStart > effectiveEnd) return 0;

        const diff = effectiveEnd.diff(effectiveStart, 'days').days;
        return Math.floor(diff) + 1;
    }

    /**
     * Calcula la cantidad total de días únicos navegados dados varios intervalos.
     * Fusiona intervalos solapados para evitar conteo doble (ej: arribo y zarpada el mismo día).
     * @param intervals Lista de intervalos con start y end.
     * @param periodRange Rango opcional para filtrar días (modo calendario o sub-periodo).
     * @param limitEnd Fecha límite opcional (física) para el cálculo (ej: "hoy").
     * @returns Total de días únicos.
     */
    static calculateUniqueDays(
        intervals: Array<{ start: Date | string; end?: Date | string | null }>,
        periodRange?: { start: Date; end: Date },
        limitEnd?: Date
    ): number {
        if (!intervals.length) return 0;

        const now = limitEnd || this.getNow(true);

        // Convertir y Normalizar
        const normalized = intervals
            .map(i => {
                const s = new Date(i.start);
                // If end is null, we use current date to show live progress
                let e = i.end ? new Date(i.end) : now;

                // Asegurar que no supere el límite
                if (e > now) e = new Date(now);

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
            if (periodRange) {
                // Intersect with the specific period (Month, Quarter, or Custom Range)
                const effectiveStart = (interval.start as Date) < periodRange.start ? periodRange.start : (interval.start as Date);
                const effectiveEnd = (interval.end as Date) > periodRange.end ? periodRange.end : (interval.end as Date);

                if (effectiveStart > effectiveEnd) return 0;

                // Normalizar extremos de intersección a medianoche (UTC) para cálculo de días enteros sin desfases
                const s = DateTime.fromJSDate(effectiveStart).setZone('UTC').startOf('day');
                const e = DateTime.fromJSDate(effectiveEnd).setZone('UTC').startOf('day');
                
                const diffDays = Math.floor(e.diff(s, 'days').days);
                return acc + diffDays + 1;
            }
            return acc + this.calculateInclusiveDays(interval.start, interval.end);
        }, 0);
    }


    /**
     * Parsea un string de fecha (YYYY-MM-DD o ISO) interpretándolo como inicio del día (00:00:00)
     * en la zona horaria configurada en APP_TIMEZONE.
     * @param dateStr Fecha en formato string
     * @returns Date object (JS Date) representando ese instante.
     */
    static parseToAppZone(dateStr: string): Date {
        if (!dateStr) return new Date(); // Fallback to now if empty

        const timezone = process.env.APP_TIMEZONE || 'UTC';

        // Intentar parsear ISO o SQL formato
        // Si viene con T (ISO), tomamos la parte de fecha
        const simpleDate = dateStr.includes('T') ? dateStr.split('T')[0] : dateStr;

        // Crear fecha en esa zona horaria specificamente a las 00:00
        const dt = DateTime.fromFormat(simpleDate, 'yyyy-MM-dd', { zone: timezone }).startOf('day');

        if (!dt.isValid) {
            // Fallback: tratar de parsear ISO directo si el formato anterior falla
            return new Date(dateStr);
        }

        return dt.toJSDate();
    }
}
