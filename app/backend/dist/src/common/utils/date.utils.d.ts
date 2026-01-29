export declare class DateUtils {
    static getNow(withTime?: boolean): Date;
    static formatDate(date: Date | string | null | undefined): string;
    static calculateInclusiveDays(start: Date | string, end?: Date | string | null): number;
    static calculateDaysInYear(start: Date | string, end: Date | string | null, year: number): number;
    static calculateUniqueDays(intervals: Array<{
        start: Date | string;
        end?: Date | string | null;
    }>, year?: number): number;
    static truncateTime(date: Date | string | null | undefined): Date | null;
}
