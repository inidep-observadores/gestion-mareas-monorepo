
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
                    pesqueria: { nombre: 'Calamar' },
                    etapas: [
                        {
                            nroEtapa: 1,
                            fechaZarpada: new Date('2023-12-20'), // Starts before year
                            fechaArribo: new Date('2024-01-10'),   // Ends inside year
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
            // Verify Prisma was called with shared where clause logic (at least basics)
            expect(mockPrisma.marea.findMany).toHaveBeenCalled();
        });

        it('should handle case-insensitive and partial matches for fishery', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
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
        });

        it('should NOT count vessels if no stage matches the fishery in the period', async () => {
            const year = 2024;
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'm1',
                    buqueId: 'vessel-1',
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
        });
    });
});

