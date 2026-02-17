import { describe, it, expect } from 'vitest'
import { TrajectoryRangeUtils } from './trajectory-range.utils'

describe('TrajectoryRangeUtils', () => {
    describe('normalize', () => {
        it('should return empty string for nullish values', () => {
            expect(TrajectoryRangeUtils.normalize(null)).toBe('')
            expect(TrajectoryRangeUtils.normalize(undefined)).toBe('')
        })

        it('should handle ISO strings', () => {
            const iso = '2026-02-17T10:30:00.000Z'
            expect(TrajectoryRangeUtils.normalize(iso)).toBe(iso)
        })

        it('should handle Date objects', () => {
            const date = new Date('2026-02-17T10:30:00Z')
            expect(TrajectoryRangeUtils.normalize(date)).toBe(date.toISOString())
        })

        it('should handle Prisma/JSON metadata objects ($type: DateTime)', () => {
            const metaObj = {
                $type: 'DateTime',
                value: '2026-02-17T00:25:00.000Z'
            }
            expect(TrajectoryRangeUtils.normalize(metaObj)).toBe('2026-02-17T00:25:00.000Z')
        })
    })

    describe('hasTime', () => {
        it('should return true for timestamps with explicit time', () => {
            expect(TrajectoryRangeUtils.hasTime('2026-02-17T10:30:00Z')).toBe(true)
            expect(TrajectoryRangeUtils.hasTime('2026-02-17 15:45:00')).toBe(true)
        })

        it('should return false for pure dates (YYYY-MM-DD)', () => {
            expect(TrajectoryRangeUtils.hasTime('2026-02-17')).toBe(false)
        })

        it('should return false for midnight (00:00:00)', () => {
            expect(TrajectoryRangeUtils.hasTime('2026-02-17T00:00:00Z')).toBe(false)
            expect(TrajectoryRangeUtils.hasTime('2026-02-17 00:00')).toBe(false)
        })
    })

    describe('resolveAlertDates', () => {
        it('should prioritize eventDate from metadata', () => {
            const alert = {
                metadata: { eventDate: '2026-02-17T10:30:00Z' },
                fechaDetectada: '2026-02-17T12:00:00Z'
            }
            expect(TrajectoryRangeUtils.resolveAlertDates(alert).referenceDate).toBe('2026-02-17T10:30:00.000Z')
        })

        it('should use fechaDetectada as fallback', () => {
            const alert = {
                metadata: {},
                fechaDetectada: '2026-02-17T12:00:00Z'
            }
            expect(TrajectoryRangeUtils.resolveAlertDates(alert).referenceDate).toBe('2026-02-17T12:00:00.000Z')
        })

        it('should handle incongruency by taking MIN/MAX', () => {
            const alert = {
                metadata: {
                    subTipo: 'INCONGRUENCIA',
                    fechaZarpada: '2026-02-17T10:00:00Z',
                    localData: { fechaZarpada: '2026-02-17T09:00:00Z' }
                }
            }
            expect(TrajectoryRangeUtils.resolveAlertDates(alert).referenceDate).toBe('2026-02-17T09:00:00.000Z')
        })
    })

    describe('calculateFetchRange', () => {
        it('should expand +/- 6h for specific timestamps (12h total)', () => {
            const { from, to } = TrajectoryRangeUtils.calculateFetchRange('2026-02-17T10:00:00Z', null, 6)

            // from: 04:00Z, to: 16:00Z
            expect(from.toISOString()).toBe('2026-02-17T04:00:00.000Z')
            expect(to.toISOString()).toBe('2026-02-17T16:00:00.000Z')
        })

        it('should expand to full day (36h with buffers) for dates without time', () => {
            const { from, to } = TrajectoryRangeUtils.calculateFetchRange('2026-02-17', null, 6)

            // from: 2026-02-16T18:00Z (00:00 minus 6h)
            // to: 2026-02-18T05:59Z (23:59:59 plus 6h)
            expect(from.toISOString()).toBe('2026-02-16T18:00:00.000Z')
            expect(to.toISOString().startsWith('2026-02-18T05:59')).toBe(true)
        })
    })
})
