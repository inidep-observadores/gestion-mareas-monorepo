import { DateTime } from 'luxon';
import { APP_CONFIG } from '../constants';

export class DateUtils {
    /**
     * Obtiene la zona horaria de la aplicación.
     */
    static getTimezone(): string {
        return process.env.APP_TIMEZONE || 'UTC';
    }

    /**
     * Obtiene la fecha actual respetando la zona horaria configurada.
     * Retorna el inicio del día en la zona de la app.
     */
    static getNow(withTime: boolean = false): Date {
        const now = DateTime.now().setZone(this.getTimezone());
        return withTime ? now.toJSDate() : now.startOf('day').toJSDate();
    }

    /**
     * Formatea una fecha según el formato global configurado.
     */
    static formatDate(date: Date | string | null | undefined): string {
        if (!date) return '-';
        const d = new Date(date);
        if (isNaN(d.getTime())) return '-';

        const dt = DateTime.fromJSDate(d).setZone(this.getTimezone());
        return dt.toFormat(APP_CONFIG.DATE_FORMAT.replace('YYYY', 'yyyy').replace('DD', 'dd'));
    }

    /**
     * Auxiliar para normalizar cualquier fecha a solo-fecha (YYYY-MM-DD) en UTC.
     * Esto evita que las horas o los desplazamientos de zona horaria alteren el conteo de días.
     */
    private static toPureDate(date: Date | string): DateTime {
        const d = new Date(date);
        // Extraemos año, mes y día tal cual vienen (asumiendo que representan la fecha nominal)
        // Usamos UTC para evitar que el motor de JS aplique offsets locales al crear el DateTime
        return DateTime.fromObject({
            year: d.getUTCFullYear(),
            month: d.getUTCMonth() + 1,
            day: d.getUTCDate()
        }, { zone: 'UTC' }).startOf('day');
    }

    /**
     * Calcula la cantidad de días navegados entre dos fechas, considerando ambos extremos inclusivos.
     */
    static calculateInclusiveDays(start: Date | string, end?: Date | string | null): number {
        if (!start) return 0;

        const startDate = this.toPureDate(start);
        const endDate = end
            ? this.toPureDate(end)
            : this.toPureDate(DateTime.now().toJSDate()); // Hoy (UTC)

        if (!startDate.isValid || !endDate.isValid || endDate < startDate) return 0;

        return Math.floor(endDate.diff(startDate, 'days').days) + 1;
    }

    /**
     * Calcula la intersección de días entre un rango de fechas y un año específico.
     */
    static calculateDaysInYear(start: Date | string, end: Date | string | null, year: number): number {
        if (!start) return 0;

        const startDate = this.toPureDate(start);
        const endDate = end ? this.toPureDate(end) : startDate;

        const yearStart = DateTime.fromObject({ year, month: 1, day: 1 }, { zone: 'UTC' }).startOf('day');
        const yearEnd = DateTime.fromObject({ year, month: 12, day: 31 }, { zone: 'UTC' }).startOf('day');

        const effectiveStart = startDate < yearStart ? yearStart : startDate;
        const effectiveEnd = endDate > yearEnd ? yearEnd : endDate;

        if (effectiveStart > effectiveEnd) return 0;

        return Math.floor(effectiveEnd.diff(effectiveStart, 'days').days) + 1;
    }

    /**
     * Calcula la cantidad total de días únicos navegados dados varios intervalos.
     * Basado puramente en fechas nominales UTC.
     */
    static calculateUniqueDays(
        intervals: Array<{ start: Date | string; end?: Date | string | null }>,
        periodRange?: { start: Date; end: Date },
        limitEnd?: Date
    ): number {
        if (!intervals.length) return 0;

        const nowPure = limitEnd ? this.toPureDate(limitEnd) : this.toPureDate(DateTime.now().toJSDate());

        // Normalizar a fechas puras (ignorar horas/offsets)
        const normalized = intervals
            .map(i => {
                const s = this.toPureDate(i.start);
                let e = i.end ? this.toPureDate(i.end) : nowPure;

                if (e > nowPure) e = nowPure;
                return { start: s, end: e };
            })
            .filter(i => i.start.isValid && i.end.isValid && i.end >= i.start)
            .sort((a, b) => a.start.toMillis() - b.start.toMillis());

        if (!normalized.length) return 0;

        // Fusionar Intervalos solapados
        const merged: Array<{ start: DateTime; end: DateTime }> = [];
        let current = normalized[0];

        for (let i = 1; i < normalized.length; i++) {
            const next = normalized[i];

            if (next.start <= current.end) {
                if (next.end > current.end) {
                    current.end = next.end;
                }
            } else {
                merged.push(current);
                current = next;
            }
        }
        merged.push(current);

        const period = periodRange ? {
            start: this.toPureDate(periodRange.start),
            end: this.toPureDate(periodRange.end)
        } : null;

        return merged.reduce((acc, interval) => {
            if (period) {
                const effectiveStart = interval.start < period.start ? period.start : interval.start;
                const effectiveEnd = interval.end > period.end ? period.end : interval.end;

                if (effectiveStart > effectiveEnd) return acc;
                return acc + Math.floor(effectiveEnd.diff(effectiveStart, 'days').days) + 1;
            }
            return acc + Math.floor(interval.end.diff(interval.start, 'days').days) + 1;
        }, 0);
    }

    /**
     * Parsea un string de fecha (YYYY-MM-DD o ISO) interpretándolo como inicio del día (00:00:00)
     * en la zona horaria de la aplicación.
     */
    static parseToAppZone(dateStr: string): Date {
        if (!dateStr) return new Date();
        const tz = this.getTimezone();

        const simpleDate = dateStr.includes('T') ? dateStr.split('T')[0] : dateStr;
        const dt = DateTime.fromFormat(simpleDate, 'yyyy-MM-dd', { zone: tz }).startOf('day');

        return dt.isValid ? dt.toJSDate() : new Date(dateStr);
    }
}
