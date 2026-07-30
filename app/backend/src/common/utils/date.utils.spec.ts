import { DateUtils } from './date.utils';
import { DateTime, Settings } from 'luxon';

describe('DateUtils', () => {
    const TIMEZONE = 'America/Argentina/Buenos_Aires';
    const originalEnv = process.env;
    const originalNow = Settings.now;

    beforeEach(() => {
        jest.resetModules();
        process.env = { ...originalEnv };
        process.env.APP_TIMEZONE = TIMEZONE;
    });

    afterEach(() => {
        process.env = originalEnv;
        Settings.now = originalNow;
        jest.restoreAllMocks();
    });

    describe('getNow', () => {
        it('should return start of day by default (without time)', () => {
            const fixedDate = DateTime.fromObject(
                { year: 2023, month: 10, day: 15, hour: 15, minute: 30, second: 0 },
                { zone: TIMEZONE }
            );

            Settings.now = () => fixedDate.toMillis();

            const result = DateUtils.getNow(false);
            const resultLx = DateTime.fromJSDate(result).setZone(TIMEZONE);

            expect(resultLx.year).toBe(2023);
            expect(resultLx.month).toBe(10);
            expect(resultLx.day).toBe(15);
            expect(resultLx.hour).toBe(0);
        });
    });

    describe('calculateUniqueDays - UTC Consistency', () => {
        it('should return exactly 14 days for Feb 1 to Feb 14 (reported issue)', () => {
            // Mock current date to Feb 14, 2026 10:44 AM ARG (13:44 UTC)
            const fixedNow = DateTime.fromObject(
                { year: 2026, month: 2, day: 14, hour: 10, minute: 44 },
                { zone: TIMEZONE }
            );
            Settings.now = () => fixedNow.toMillis();

            // Interval in UTC as it comes from Prisma
            const intervals = [
                { start: new Date('2026-02-01T00:00:00Z'), end: null }
            ];

            const result = DateUtils.calculateUniqueDays(intervals);

            // Feb 1 to Feb 14 = 14 days
            expect(result).toBe(14);
        });

        it('should be immune to local time shifts (Midnight UTC should not become Previous Day)', () => {
            // Mock now to a time that would shift boundaries if using local time
            // Feb 14 01:00 AM ARG is still Feb 14 04:00 AM UTC. Both are Feb 14.
            // But Feb 1 00:00 AM UTC is Jan 31 09:00 PM ARG.

            const fixedNow = DateTime.fromObject(
                { year: 2026, month: 2, day: 14, hour: 1, minute: 0 },
                { zone: TIMEZONE }
            );
            Settings.now = () => fixedNow.toMillis();

            const intervals = [
                { start: new Date('2026-02-01T00:00:00Z'), end: null }
            ];

            const result = DateUtils.calculateUniqueDays(intervals);

            // If it were Jan 31 to Feb 14 it would be 15.
            // With pure UTC it stays Feb 1 to Feb 14 = 14.
            expect(result).toBe(14);
        });

        it('should handle multiple intervals correctly with pure dates', () => {
            const intervals = [
                { start: new Date('2026-01-01T00:00:00Z'), end: new Date('2026-01-05T00:00:00Z') }, // 5 days
                { start: new Date('2026-01-05T00:00:00Z'), end: new Date('2026-01-10T00:00:00Z') }  // overlaps on 5th
            ];
            // Total: Jan 1 to Jan 10 = 10 days
            const result = DateUtils.calculateUniqueDays(intervals);
            expect(result).toBe(10);
        });

        it('should cap ongoing intervals at limitEnd', () => {
            const intervals = [
                { start: new Date('2026-07-01T00:00:00Z'), end: null } // ongoing
            ];
            // Cap at July 15
            const limitEnd = new Date('2026-07-15T00:00:00Z');
            
            const result = DateUtils.calculateUniqueDays(intervals, undefined, limitEnd);
            // July 1 to July 15 = 15 days
            expect(result).toBe(15);
        });

        it('should correctly limit counted days within a periodRange', () => {
            const intervals = [
                { start: new Date('2026-06-15T00:00:00Z'), end: new Date('2026-07-15T00:00:00Z') }
            ];
            // Period is Q3: July 1 to Sept 30
            const periodRange = {
                start: new Date('2026-07-01T00:00:00Z'),
                end: new Date('2026-09-30T00:00:00Z')
            };

            const result = DateUtils.calculateUniqueDays(intervals, periodRange);
            // Intersection is July 1 to July 15 = 15 days
            expect(result).toBe(15);
        });

        it('should cap at limitEnd AND intersect with periodRange for ongoing intervals', () => {
            const intervals = [
                { start: new Date('2026-06-15T00:00:00Z'), end: null } // ongoing
            ];
            // Period is Q3: July 1 to Sept 30
            const periodRange = {
                start: new Date('2026-07-01T00:00:00Z'),
                end: new Date('2026-09-30T00:00:00Z')
            };
            // limitEnd is July 10 (e.g. today's date)
            const limitEnd = new Date('2026-07-10T00:00:00Z');

            const result = DateUtils.calculateUniqueDays(intervals, periodRange, limitEnd);
            // Start capped by periodRange (July 1). End capped by limitEnd (July 10).
            // July 1 to July 10 = 10 days
            expect(result).toBe(10);
        });
    });
});
