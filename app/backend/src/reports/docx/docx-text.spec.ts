import { describePeriod } from './docx-text';

describe('describePeriod', () => {
    const year = 2025;

    it('should describe a full year correctly', () => {
        const result = describePeriod({ year });
        expect(result.short).toBe('Año 2025');
        expect(result.full).toBe('año 2025');
    });

    it('should describe a quarter correctly', () => {
        const result = describePeriod({
            year,
            startDate: '2025-01-01',
            endDate: '2025-03-31'
        });
        expect(result.short).toBe('1er Trimestre 2025');
        expect(result.range).toBe('enero – marzo 2025');
    });

    it('should describe a full month correctly (New functionality)', () => {
        const result = describePeriod({
            year,
            startDate: '2025-05-01',
            endDate: '2025-05-31'
        });
        expect(result.short).toBe('Mayo 2025');
        expect(result.range).toBe('mayo 2025');
        expect(result.full).toBe('mes de mayo de 2025');
        expect(result.article).toBe('el mes');
    });

    it('should describe a partial month correctly (New functionality)', () => {
        const result = describePeriod({
            year,
            startDate: '2025-05-05',
            endDate: '2025-05-20'
        });
        expect(result.short).toBe('5–20 Mayo 2025');
        expect(result.range).toBe('5 al 20 de mayo 2025');
        expect(result.article).toBe('el período');
    });

    it('should describe a single day correctly', () => {
        const result = describePeriod({
            year,
            startDate: '2025-05-15',
            endDate: '2025-05-15'
        });
        expect(result.short).toBe('15 Mayo 2025');
        expect(result.range).toBe('15 de mayo 2025');
    });
});
