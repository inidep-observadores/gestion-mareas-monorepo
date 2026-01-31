
import { DateUtils } from './date.utils';
import { DateTime, Settings } from 'luxon';

describe('DateUtils', () => {
    describe('getNow', () => {
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
            expect(resultLx.minute).toBe(0);
            expect(resultLx.second).toBe(0);
        });

        it('should return full time when withTime is true', () => {
            const fixedDate = DateTime.fromObject(
                { year: 2023, month: 10, day: 15, hour: 15, minute: 30, second: 45 },
                { zone: TIMEZONE }
            );
            Settings.now = () => fixedDate.toMillis();

            const result = DateUtils.getNow(true);
            const resultLx = DateTime.fromJSDate(result).setZone(TIMEZONE);

            expect(resultLx.hour).toBe(15);
            expect(resultLx.minute).toBe(30);
            expect(resultLx.second).toBe(45);
        });
    });
});
