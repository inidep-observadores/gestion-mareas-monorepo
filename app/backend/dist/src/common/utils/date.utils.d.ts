export declare class DateUtils {
    static formatDate(date: Date | string | null | undefined): string;
    static calculateInclusiveDays(start: Date | string, end?: Date | string | null): number;
    static calculateDaysInYear(start: Date | string, end: Date | string | null, year: number): number;
    static calculateUniqueDays(intervals: Array<{
        start: Date | string;
        end?: Date | string | null;
    }>, year?: number): number;
}
