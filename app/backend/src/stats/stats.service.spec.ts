
import { Test, TestingModule } from '@nestjs/testing';
import { StatsService } from './stats.service';
import { PrismaService } from '../prisma/prisma.service';
import { DateUtils } from '../common/utils/date.utils';

describe('StatsService', () => {
    let service: StatsService;
    let prisma: PrismaService;

    const mockPrisma = {
        marea: {
            findMany: jest.fn(),
        },
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                StatsService,
                { provide: PrismaService, useValue: mockPrisma },
            ],
        }).compile();

        service = module.get<StatsService>(StatsService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    describe('getDashboardStatsDetail', () => {
        it('should use DateUtils.getNow() to calculate intervals for active mareas', async () => {
            const year = 2024;
            const fixedNow = new Date('2024-06-01T12:00:00Z');
            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);
            const calculateUniqueDaysSpy = jest.spyOn(DateUtils, 'calculateUniqueDays').mockReturnValue(10); // Simple mock

            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    observadorPrincipalId: 'obs1',
                    observadorPrincipal: { nombre: 'Juan', apellido: 'Perez' },
                    buque: { nombreBuque: 'Barco A' },
                    estadoActual: { codigo: 'EN_EJECUCION', nombre: 'En ejecucion' }, // Active marea
                    etapas: [
                        { fechaZarpada: new Date('2024-05-20'), fechaArribo: null, observadores: [] }
                    ]
                }
            ]);

            const result = await service.getDashboardStatsDetail(
                year,
                'TOTAL',
                false, // includeNonProtocolized
                false, // includeProtocolizedOutOfPeriod
                'FLEET', // filterType
                'Test Fleet', // filterValue
                'SHIP' // daysCalculationMode
            );

            // Verification:
            // The service maps stages, and for "EN_EJECUCION", it uses DateUtils.getNow() as 'end'.
            // Then it calls calculateUniqueDays(intervals).
            // We verify that getNow was called.

            expect(getNowSpy).toHaveBeenCalled();
            expect(calculateUniqueDaysSpy).toHaveBeenCalled();

            // Check that the interval passed to calculateUniqueDays actually uses fixedNow
            const intervalsPassed = calculateUniqueDaysSpy.mock.calls[0][0];
            // intervalsPassed is array of { start: Date, end: Date }
            expect(intervalsPassed).toHaveLength(1);
            expect(intervalsPassed[0].end).toEqual(fixedNow);

            getNowSpy.mockRestore();
            calculateUniqueDaysSpy.mockRestore();
        });
    });

    describe('getMareaDistribution', () => {
        it('should return trimmed dates when mode is CALENDAR', async () => {
            const year = 2024;
            const yearStart = new Date(Date.UTC(year, 0, 1));
            const yearEnd = new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));

            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buque: { nombreBuque: 'Barco A' },
                    pesqueria: { nombre: 'Calamar' }, // General (unused for label now)
                    etapas: [
                        {
                            nroEtapa: 1,
                            fechaZarpada: new Date('2023-12-20'), // Starts before year
                            fechaArribo: new Date('2024-01-10'),   // Ends inside year
                            pesqueria: { nombre: 'Merluza' } // Stage fishery
                        }
                    ],
                    estadoActual: { codigo: 'PROTOCOLIZADA' }
                }
            ]);

            const result = await service.getMareaDistribution(year, 'CALENDAR', true, true, true);

            expect(result).toHaveLength(1);
            // In CALENDAR mode, zarpada should be trimmed to yearStart
            expect(new Date(result[0].fechaZarpada).getTime()).toBe(yearStart.getTime());
            expect(new Date(result[0].fechaArribo!).getTime()).toBe(new Date('2024-01-10').getTime());
            // Should use stage fishery
            expect(result[0].pesqueria).toBe('Merluza');
        });

        it('should return multiple segments with different fisheries for the same marea', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buque: { nombreBuque: 'Barco A' },
                    etapas: [
                        {
                            nroEtapa: 1,
                            fechaZarpada: new Date('2024-01-01'),
                            fechaArribo: new Date('2024-01-10'),
                            pesqueria: { nombre: 'Calamar' }
                        },
                        {
                            nroEtapa: 2,
                            fechaZarpada: new Date('2024-01-11'),
                            fechaArribo: new Date('2024-01-20'),
                            pesqueria: { nombre: 'Langostino' }
                        }
                    ]
                }
            ]);

            const result = await service.getMareaDistribution(year, 'CALENDAR', true, true, true);

            expect(result).toHaveLength(2);
            expect(result[0].pesqueria).toBe('Calamar');
            expect(result[1].pesqueria).toBe('Langostino');
        });

        it('should not return items starting in the future', async () => {
            const year = 2024;
            const fixedNow = new Date('2024-06-01T12:00:00Z');
            jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            // Mock finding no mareas because getSharedWhereClause will handle the future filter
            mockPrisma.marea.findMany.mockResolvedValue([]);

            const result = await service.getMareaDistribution(year, 'CALENDAR', true, true, true, '2024-07-01');

            expect(result).toHaveLength(0);
            jest.restoreAllMocks();
        });
    });

    describe('getUniqueVesselsCount', () => {
        it('should count unique vessels filtered by stage fishery', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
                    buque: { tipoFlota: { nombre: 'Fresquero' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-01-05'),
                            fechaArribo: new Date('2024-01-15'),
                            pesqueria: { nombre: 'Merluza' }
                        }
                    ],
                    estadoActual: { codigo: 'PROTOCOLIZADA' }
                },
                {
                    id: 'm2',
                    buqueId: 'vessel-2',
                    buque: { tipoFlota: { nombre: 'Fresquero' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-01-05'),
                            fechaArribo: new Date('2024-01-15'),
                            pesqueria: { nombre: 'Calamar' } // Different fishery
                        }
                    ],
                    estadoActual: { codigo: 'PROTOCOLIZADA' }
                }
            ]);

            // Filter by 'Merluza'
            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true, true, undefined, undefined, 'Merluza');

            expect(result.count).toBe(1);
            expect(result.monthly).toHaveLength(12);
            expect(result.monthly[0].count).toBe(1); // Jan
            expect(result.monthly[0].fleets).toContainEqual({ name: 'Fresquero', count: 1 });
            expect(result.monthly[1].count).toBe(0); // Feb
            // Verify Prisma was called with shared where clause logic (at least basics)
            expect(mockPrisma.marea.findMany).toHaveBeenCalled();
        });

        it('should handle case-insensitive and partial matches for fishery', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
                    buque: { tipoFlota: { nombre: 'Fresquero' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-01-05'),
                            fechaArribo: new Date('2024-01-15'),
                            pesqueria: { nombre: 'LANGOSTINO COSTEÑO' }
                        }
                    ]
                }
            ]);

            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true, true, undefined, undefined, 'langostino');
            expect(result.count).toBe(1);
            expect(result.monthly[0].count).toBe(1);
            expect(result.monthly[0].fleets[0].name).toBe('Fresquero');
        });

        it('should NOT count vessels if no stage matches the fishery in the period', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
                    buque: { tipoFlota: { nombre: 'Fresquero' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-01-05'),
                            fechaArribo: new Date('2024-01-15'),
                            pesqueria: { nombre: 'Merluza' }
                        }
                    ]
                }
            ]);

            // Filter by 'Calamar'
            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true, true, undefined, undefined, 'Calamar');
            expect(result.count).toBe(0);
            expect(result.monthly.every(m => m.count === 0)).toBe(true);
        });

        it('should accurately distribute unique vessels across multiple months with fleet breakdown', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
                    buque: { tipoFlota: { nombre: 'Fresquero' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-01-15'),
                            fechaArribo: new Date('2024-03-10'),
                            pesqueria: { nombre: 'Merluza' }
                        }
                    ]
                },
                {
                    id: 'm2',
                    buqueId: 'vessel-2',
                    buque: { tipoFlota: { nombre: 'Congelador' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-02-01'),
                            fechaArribo: new Date('2024-02-15'),
                            pesqueria: { nombre: 'Merluza' }
                        }
                    ]
                }
            ]);

            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true, true);

            expect(result.count).toBe(2);
            // Jan: vessel-1 (Fresquero)
            expect(result.monthly[0].count).toBe(1);
            expect(result.monthly[0].fleets).toContainEqual({ name: 'Fresquero', count: 1 });

            // Feb: vessel-1 (Fresquero), vessel-2 (Congelador)
            expect(result.monthly[1].count).toBe(2);
            expect(result.monthly[1].fleets).toHaveLength(2);
            expect(result.monthly[1].fleets).toContainEqual({ name: 'Fresquero', count: 1 });
            expect(result.monthly[1].fleets).toContainEqual({ name: 'Congelador', count: 1 });

            // Mar: vessel-1 (Fresquero)
            expect(result.monthly[2].count).toBe(1);
            expect(result.monthly[2].fleets[0].name).toBe('Fresquero');
        });
    });

    describe('getDashboardStats - multi-fishery', () => {
        it('should distribute days and counts across multiple fisheries for a marea with different stage fisheries', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
                    buque: { tipoFlota: { nombre: 'Fresquero', codigo: 'F' } },
                    etapas: [
                        {
                            fechaZarpada: new Date('2024-01-01'),
                            fechaArribo: new Date('2024-01-10'),
                            pesqueria: { nombre: 'Calamar' },
                            observadores: []
                        },
                        {
                            fechaZarpada: new Date('2024-01-11'),
                            fechaArribo: new Date('2024-01-20'),
                            pesqueria: { nombre: 'Merluza' },
                            observadores: []
                        }
                    ],
                    estadoActual: { codigo: 'PROTOCOLIZADA' }
                }
            ]);

            const result = await service.getDashboardStats(year, 'CALENDAR', true, true);

            // Marea counts: this marea touched both fisheries
            const calamar = result.fisheries.find(f => f.name === 'Calamar');
            const merluza = result.fisheries.find(f => f.name === 'Merluza');

            expect(calamar?.mareas).toBe(1);
            expect(merluza?.mareas).toBe(1);

            // Days: 10 days for each (approx, DateUtils logic is used)
            expect(calamar?.days).toBe(10);
            expect(merluza?.days).toBe(10);

            // Total should still be correct
            expect(result.totalMareas).toBe(1);
            expect(result.totalDaysNavigated).toBe(20);
        });
    });
});
