
import { Test, TestingModule } from '@nestjs/testing';
import { StatsService } from './stats.service';
import { PrismaService } from '../prisma/prisma.service';
import { PlanificacionService } from '../planificacion/planificacion.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { DateUtils } from '../common/utils/date.utils';
import { FilterType } from './dto/get-stats.dto';
import { Sexo } from '@prisma/client';
import * as ExcelJS from 'exceljs';
import { MareasService } from '../mareas/mareas.service';

describe('StatsService', () => {
    let service: StatsService;
    let prisma: PrismaService;

    const mockPrisma = {
        marea: {
            findMany: jest.fn(),
        },
        observador: {
            findMany: jest.fn(),
        },
    };

    const mockPlanificacion = {
        getRequerimientosPorAnio: jest.fn(),
    };

    const mockBusinessRules = {
        getRules: jest.fn().mockReturnValue({ DIAS_DESCANSO_POST_MAREA: 5 }),
    };

    const mockMareasService = {
        getWorkforceStatus: jest.fn().mockResolvedValue({
            listNavegando: [],
            listDescanso: [],
            listDisponibles: [],
            listImpedidos: []
        }),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                StatsService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: PlanificacionService, useValue: mockPlanificacion },
                { provide: BusinessRulesService, useValue: mockBusinessRules },
                { provide: MareasService, useValue: mockMareasService },
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
                FilterType.FLEET, // filterType
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
                            fechaZarpada: new Date('2024-01-01'),
                            fechaArribo: new Date('2024-01-10'),
                            pesqueria: { nombre: 'Merluza' },
                            observadores: []
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
                            pesqueria: { nombre: 'Calamar' }, // Different fishery
                            observadores: []
                        }
                    ],
                    estadoActual: { codigo: 'PROTOCOLIZADA' }
                }
            ]);

            // Filter by 'Merluza'
            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true, true, undefined, undefined, 'Merluza');

            expect(result.count).toBe(1);
            expect(result.monthly[0].count).toBe(1); // Jan
            expect(result.monthly[0].days).toBe(10); // 1 to 10
            expect(result.monthly[0].fleets[0]).toEqual({ name: 'Fresquero', count: 1, days: 10 });
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
                            pesqueria: { nombre: 'LANGOSTINO COSTEÑO' },
                            observadores: []
                        }
                    ]
                }
            ]);

            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true, true, undefined, undefined, 'langostino');
            expect(result.count).toBe(1);
            expect(result.monthly[0].count).toBe(1);
            expect(result.monthly[0].days).toBe(11); // 5 to 15 is 11 days
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
                            pesqueria: { nombre: 'Merluza' },
                            observadores: []
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
                            fechaArribo: new Date('2024-03-10'),
                            pesqueria: { nombre: 'Merluza' },
                            observadores: []
                        }
                    ]
                }
            ]);

            const result = await service.getUniqueVesselsCount(year, 'CALENDAR', true, true);

            expect(result.count).toBe(2);
            // Jan: vessel-1 (Fresquero)
            expect(result.monthly[0].count).toBe(1);
            expect(result.monthly[0].days).toBe(17); // 15-31
            expect(result.monthly[0].fleets).toContainEqual({ name: 'Fresquero', count: 1, days: 17 });

            // Feb: vessel-1 (Fresquero), vessel-2 (Congelador)
            expect(result.monthly[1].count).toBe(2);
            expect(result.monthly[1].days).toBe(58); // vessel-1: 29 days + vessel-2: 29 days
            expect(result.monthly[1].fleets).toHaveLength(2);
            expect(result.monthly[1].fleets).toContainEqual({ name: 'Fresquero', count: 1, days: 29 });
            expect(result.monthly[1].fleets).toContainEqual({ name: 'Congelador', count: 1, days: 29 });

            // Mar: vessel-1 (Fresquero), vessel-2 (Congelador)
            expect(result.monthly[2].count).toBe(2);
            expect(result.monthly[2].days).toBe(20); // vessel-1: 10 days (1-10) + vessel-2: 10 days (1-10)
            expect(result.monthly[2].fleets).toHaveLength(2);
            expect(result.monthly[2].fleets).toContainEqual({ name: 'Fresquero', count: 1, days: 10 });
            expect(result.monthly[2].fleets).toContainEqual({ name: 'Congelador', count: 1, days: 10 });

            expect(result.monthly[3].count).toBe(0); // Apr
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
    describe('getExportWorkbook - WORKFORCE', () => {
        it('should exclude technical staff and classify by operational status', async () => {
            mockMareasService.getWorkforceStatus.mockResolvedValue({
                listNavegando: [
                    {
                        id: 'obs-1',
                        name: 'Juan Perez',
                        tipoObservador: 'TITULAR',
                        sexo: Sexo.Masculino,
                        days: 10,
                        vessel: 'Vessel A',
                        mareaCode: '2024-001',
                        fishery: 'Merluza',
                    }
                ],
                listDescanso: [
                    {
                        id: 'obs-2',
                        name: 'Maria Gomez',
                        tipoObservador: 'TITULAR',
                        sexo: Sexo.Femenino,
                        days: 5,
                        vessel: null,
                        mareaCode: '',
                        fishery: '',
                        status: 'DESCANSO',
                        tieneDesignacionActiva: true
                    }
                ],
                listDisponibles: [
                    {
                        id: 'obs-3',
                        name: 'Carlos Lopez',
                        tipoObservador: 'EVENTUAL',
                        sexo: Sexo.Masculino,
                        days: 20,
                        vessel: null,
                        mareaCode: '',
                        fishery: '',
                    }
                ],
                listImpedidos: []
            });

            const workbook = await service.getExportWorkbook(
                2024, 'TOTAL', true, true, 'SHIP', true, FilterType.WORKFORCE
            );

            const sheet = workbook.getWorksheet('Dotación de Personal');
            expect(sheet).toBeDefined();

            // Verify count (headers + 3 rows)
            expect(sheet.rowCount).toBe(4);

            // Verify that MareasService was called
            expect(mockMareasService.getWorkforceStatus).toHaveBeenCalled();
            // Verify order and values
            // Rows are 1-indexed (row 1 is header)
            expect(sheet.getCell(2, 3).value).toBe('Juan Perez');
            expect(sheet.getCell(2, 1).value).toBe('Navegando');
            
            expect(sheet.getCell(3, 3).value).toBe('Maria Gomez');
            expect(sheet.getCell(3, 1).value).toBe('En Descanso');
            
            expect(sheet.getCell(4, 3).value).toBe('Carlos Lopez');
            expect(sheet.getCell(4, 1).value).toBe('Disponible');
        });

        it('should correctly identify "Designado" status as a full row highlight', async () => {
            mockMareasService.getWorkforceStatus.mockResolvedValue({
                listNavegando: [],
                listDescanso: [],
                listDisponibles: [
                    {
                        id: 'obs-1',
                        name: 'Designado Test',
                        tipoObservador: 'TITULAR',
                        sexo: Sexo.Masculino,
                        days: 0,
                        vessel: 'Vessel X',
                        mareaCode: '2024-002',
                        fishery: 'Merluza',
                        status: 'DISPONIBLE',
                        tieneDesignacionActiva: true
                    }
                ],
                listImpedidos: []
            });

            const workbook = await service.getExportWorkbook(
                2024, 'TOTAL', true, true, 'SHIP', true, FilterType.WORKFORCE
            );

            const sheet = workbook.getWorksheet('Dotación de Personal');
            const statusCell = sheet.getCell(2, 1);
            const nameCell = sheet.getCell(2, 3); // Apellido y Nombre es la columna 3

            // Verify that it is "Disponible" but has the "Designado" highlight (E0F2FE) in all row
            expect(statusCell.value).toBe('Disponible');
            expect((nameCell.fill as any).fgColor?.argb).toBe('E0F2FE');
            expect((statusCell.fill as any).fgColor?.argb).toBe('E0F2FE');
        });
    });
});
