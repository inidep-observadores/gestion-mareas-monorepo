
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
});
