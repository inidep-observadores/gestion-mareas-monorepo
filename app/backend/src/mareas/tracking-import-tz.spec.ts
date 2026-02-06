import { DateTime } from 'luxon';

describe('Tracking Import - Timezone Integrity', () => {

    it('should parse CSV date string as UTC regardless of system timezone', () => {
        const csvDateStr = '2026-01-01 02:08:00';

        // This is the exact logic from TrackingService.ts
        const dt = DateTime.fromFormat(csvDateStr, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
        const jsDate = dt.toJSDate();

        // Expected values in UTC
        expect(dt.isValid).toBe(true);
        expect(dt.zoneName).toBe('UTC');
        expect(dt.hour).toBe(2);
        expect(dt.minute).toBe(8);

        // JavaScript Date ISO representation should always be in UTC 'Z'
        // 2026-01-01 02:08:00 UTC -> 2026-01-01T02:08:00.000Z
        expect(jsDate.toISOString()).toBe('2026-01-01T02:08:00.000Z');

        // Epoch should match exact UTC timestamp
        const expectedEpoch = Date.UTC(2026, 0, 1, 2, 8, 0);
        expect(jsDate.getTime()).toBe(expectedEpoch);
    });

    it('should handle ISO fallback dates as UTC', () => {
        const isoDateStr = '2026-01-01T02:08:00';

        // This is the fallback logic from TrackingService.ts
        const dt = DateTime.fromISO(isoDateStr, { zone: 'utc' });
        const jsDate = dt.toJSDate();

        expect(jsDate.toISOString()).toBe('2026-01-01T02:08:00.000Z');
    });

    it('should maintain the same time instant (Epoch) when converted to local and back', () => {
        // This simulates saving to DB and reading it back in a server with UTC-3
        const csvDateStr = '2026-01-01 02:08:00';
        const dtUtc = DateTime.fromFormat(csvDateStr, 'yyyy-MM-dd HH:mm:ss', { zone: 'utc' });
        const jsDate = dtUtc.toJSDate();

        // Time in UTC-3 should be 3 hours earlier than UTC 02:08 -> 23:08 of previous day
        const dtLocal = DateTime.fromJSDate(jsDate).setZone('America/Argentina/Buenos_Aires');

        expect(dtLocal.day).toBe(31);
        expect(dtLocal.month).toBe(12);
        expect(dtLocal.year).toBe(2025);
        expect(dtLocal.hour).toBe(23);
        expect(dtLocal.minute).toBe(8);

        // Instant (epoch) remains identical
        expect(dtLocal.toMillis()).toBe(dtUtc.toMillis());
    });
});
