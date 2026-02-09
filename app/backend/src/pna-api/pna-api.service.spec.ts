import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { PnaApiService } from './pna-api.service';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { PnaApiParser } from './pna-api.parser';
import { EventCorrelationService } from '../common/services/event-correlation.service';
import { DateTime } from 'luxon';
import { PnaReporteCostera } from './pna-api.interfaces';

import { ConfigService } from '@nestjs/config';

describe('PnaApiService - Reglas de Negocio Unificadas', () => {
    let service: PnaApiService;
    let prisma: PrismaService;
    let alertsService: AlertsService;

    const mockPrismaService = {
        buque: { findFirst: jest.fn() },
        puerto: { findFirst: jest.fn(), findMany: jest.fn() },
        marea: { findMany: jest.fn() },
        alerta: {
            findFirst: jest.fn(),
            create: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'mock-alert-id', ...args.data })),
        },
        alertaEvento: { create: jest.fn().mockResolvedValue({ id: 'mock-event-id' }) },
        pnaApiSnapshot: {
            findUnique: jest.fn(),
            create: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'mock-snap-id', ...args.data })),
            update: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'mock-snap-id', ...args.data })),
        },
        systemStatus: {
            findUnique: jest.fn(),
            upsert: jest.fn(),
        },
    };

    const mockAlertsService = {
        addValidationSource: jest.fn().mockResolvedValue(true),
        create: jest.fn().mockResolvedValue({ id: 'mock-alert-id' }),
    };

    const mockParser = {
        generateComboId: jest.fn().mockReturnValue('mock-combo-id'),
        parseXml: jest.fn(),
    };

    const mockConfigService = {
        get: jest.fn((key: string) => {
            if (key === 'USE_MOCK_FISHERY_API') return 'true';
            return null;
        }),
    };

    beforeEach(async () => {
        jest.clearAllMocks();

        // Mocks por defecto para evitar persistencia de estado entre tests
        mockPrismaService.buque.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findMany.mockResolvedValue([]);
        mockPrismaService.marea.findMany.mockResolvedValue([]);
        mockPrismaService.alerta.findFirst.mockResolvedValue(null);
        mockPrismaService.pnaApiSnapshot.findUnique.mockResolvedValue(null);
        mockAlertsService.create.mockResolvedValue({ id: 'mock-alert-id' });
        mockAlertsService.addValidationSource.mockResolvedValue(true);

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                PnaApiService,
                EventCorrelationService,
                { provide: PrismaService, useValue: mockPrismaService },
                { provide: AlertsService, useValue: mockAlertsService },
                { provide: PnaApiParser, useValue: mockParser },
                { provide: ConfigService, useValue: mockConfigService },
            ],
        }).compile();

        service = module.get<PnaApiService>(PnaApiService);
        prisma = module.get<PrismaService>(PrismaService);
        alertsService = module.get<AlertsService>(AlertsService);
    });

    const mockBuque = {
        id: 'buque-1',
        nombreBuque: 'BUQUE TEST',
        idMbpc: '12345',
        senalDistintiva: 'ABCD',
        matricula: 'MAT-001'
    };

    const mockPuertos = [
        { id: 'port-mdp', nombre: 'Mar del Plata', codigoExterno: 'MDP', latitud: -38.03, longitud: -57.53, activo: true },
        { id: 'port-ushuaia', nombre: 'Ushuaia', codigoExterno: 'USH', latitud: -54.80, longitud: -68.30, activo: true }
    ];

    const generateReport = (overrides: Partial<PnaReporteCostera> = {}): PnaReporteCostera => ({
        id_buque_mbpc: '12345',
        nombre: 'BUQUE TEST',
        matricula: 'MAT-001',
        sdist: 'ABCD',
        estado: 'ZARPADA',
        fecha: '2025-01-15 10:00:00',
        id_costera: 'MDP',
        nombre_costera: 'Mar del Plata',
        borrado: 'False',
        fecha_modificacion: '2025-01-15 10:05:00',
        cantidad_tripulantes: '10',
        observaciones: '',
        latitud: '-38.0',
        longitud: '-57.0',
        ...overrides
    });

    const generateMarea = (overrides: any = {}): any => ({
        id: 'marea-1',
        anioMarea: 2025,
        nroMarea: 123,
        tipoMarea: 'MC',
        buqueId: mockBuque.id,
        estadoActual: { codigo: 'EN_EJECUCION' },
        etapas: [],
        ...overrides
    });

    describe('Source Stacking y Deduplicación', () => {
        it('debe validar una alerta existente si PNA reporta el mismo evento (Deduplicación)', async () => {
            const reporte = generateReport({ estado: 'ZARPADA', fecha: '2025-01-15 10:00:00' });

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            mockPrismaService.puerto.findFirst.mockResolvedValue(mockPuertos[0]);
            mockPrismaService.puerto.findMany.mockResolvedValue(mockPuertos);
            mockPrismaService.pnaApiSnapshot.findUnique.mockResolvedValue(null);

            // Simular marea activa con etapa de zarpada ya registrada
            mockPrismaService.marea.findMany.mockResolvedValue([generateMarea({
                etapas: [{
                    nroEtapa: 1,
                    fechaZarpada: new Date('2025-01-15T10:00:00Z'),
                    puertoZarpadaId: 'port-mdp'
                }]
            })]);

            // Simular que ya existe una alerta para este evento (e.g. creada por Tracking CSV horas antes)
            mockPrismaService.alerta.findFirst.mockResolvedValue({ id: 'alert-vms-1' });

            await (service as any).processSingleReport(reporte);

            expect(mockAlertsService.addValidationSource).toHaveBeenCalledWith(
                'alert-vms-1',
                'API_PNA',
                expect.any(Object)
            );
            expect(mockAlertsService.create).not.toHaveBeenCalled();
        });
    });

    describe('Asignación a Marea Correcta', () => {
        it('debe asignar zarpada a marea DESIGNADA si existe una EN_EJECUCION (Source Stacking marea futura)', async () => {
            const reporte = generateReport({ estado: 'ZARPADA', fecha: '2025-01-20 10:00:00' });

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            mockPrismaService.puerto.findFirst.mockResolvedValue(mockPuertos[0]);
            mockPrismaService.puerto.findMany.mockResolvedValue(mockPuertos);
            mockPrismaService.pnaApiSnapshot.findUnique.mockResolvedValue(null);

            // Simular dos mareas: una en ejecución y una designada
            mockPrismaService.marea.findMany.mockResolvedValue([
                generateMarea({ id: 'marea-ejec', estadoActual: { codigo: 'EN_EJECUCION' } }),
                generateMarea({ id: 'marea-next', estadoActual: { codigo: 'DESIGNADA' }, nroMarea: 124 })
            ]);

            await (service as any).processSingleReport(reporte);

            // Debe crear alerta vinculada a la marea DESIGNADA (la futura)
            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                referenciaId: 'marea-next'
            }));
        });

        it('debe ignorar el evento si el buque no tiene mareas activas (Feedback Usuario)', async () => {
            const reporte = generateReport();
            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            mockPrismaService.marea.findMany.mockResolvedValue([]); // Sin mareas

            const result = await (service as any).processSingleReport(reporte);

            expect(result.alertCreated).toBe(false);
            expect(mockAlertsService.create).not.toHaveBeenCalled();
        });
    });

    describe('Detección de Discrepancias de Puerto', () => {
        it('debe crear alerta de discrepancia si el ID de puerto (vía codigo_externo) difiere del registrado', async () => {
            const reporte = generateReport({ id_costera: 'USH' }); // Reporta Ushuaia

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            // El puerto encontrado por codigo_externo 'USH'
            mockPrismaService.puerto.findFirst.mockResolvedValue(mockPuertos[1]);
            mockPrismaService.puerto.findMany.mockResolvedValue(mockPuertos);

            // La marea tiene registrada zarpada de Mar del Plata
            mockPrismaService.marea.findMany.mockResolvedValue([generateMarea({
                etapas: [{
                    nroEtapa: 1,
                    fechaZarpada: new Date('2025-01-15T10:00:00Z'),
                    puertoZarpadaId: 'port-mdp' // MDP != USH
                }]
            })]);

            await (service as any).processSingleReport(reporte);

            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'ERROR_REGISTRO_PUERTO',
                titulo: expect.stringContaining('Discrepancia en puerto')
            }));
        });
    });

    describe('Detección de Incongruencias de Fecha', () => {
        it('debe crear alerta de incongruencia si la fecha PNA difiere de la registrada (Día calendario distinto)', async () => {
            // El matching funciona con +/- 1 día. Jan 15 vs Jan 16
            const reporte = generateReport({ fecha: '2025-01-16 10:00:00' });

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            mockPrismaService.puerto.findFirst.mockResolvedValue(mockPuertos[0]);
            mockPrismaService.puerto.findMany.mockResolvedValue(mockPuertos);

            mockPrismaService.marea.findMany.mockResolvedValue([generateMarea({
                etapas: [{
                    nroEtapa: 1,
                    fechaZarpada: new Date('2025-01-15T10:00:00Z'),
                    puertoZarpadaId: 'port-mdp'
                }]
            })]);

            await (service as any).processSingleReport(reporte);

            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'ERROR_FECHA_MOVIMIENTO',
                titulo: expect.stringContaining('Incongruencia de FECHA')
            }));
        });
    });

    describe('Recomendación de Fin de Marea', () => {
        it('debe recomendar fin de marea si detecta ARRIBO y existe una marea DESIGNADA siguiente', async () => {
            const reporte = generateReport({ estado: 'ARRIBO', fecha: '2025-01-15 20:00:00' });

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            mockPrismaService.puerto.findFirst.mockResolvedValue(mockPuertos[0]);
            mockPrismaService.puerto.findMany.mockResolvedValue(mockPuertos);

            // Marea actual en ejecución + marea futura designada
            mockPrismaService.marea.findMany.mockResolvedValue([
                generateMarea({ id: 'marea-current' }),
                generateMarea({ id: 'marea-next', estadoActual: { codigo: 'DESIGNADA' }, nroMarea: 124 })
            ]);

            await (service as any).processSingleReport(reporte);

            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'RECOMENDACION_FIN_MAREA',
                titulo: expect.stringContaining('Recomendación FINALIZAR MAREA')
            }));
        });
    });

    describe('Validación Cronológica', () => {
        it('debe ignorar eventos de PNA que son más antiguos que las etapas ya registradas', async () => {
            const reporte = generateReport({ fecha: '2025-01-01 10:00:00' }); // Muy antiguo

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            mockPrismaService.puerto.findFirst.mockResolvedValue(mockPuertos[0]);
            mockPrismaService.puerto.findMany.mockResolvedValue(mockPuertos);

            mockPrismaService.marea.findMany.mockResolvedValue([generateMarea({
                etapas: [{
                    nroEtapa: 1,
                    fechaZarpada: new Date('2025-01-15T10:00:00Z'), // Ya hay algo más reciente
                    puertoZarpadaId: 'port-mdp'
                }]
            })]);

            const result = await (service as any).processSingleReport(reporte);

            expect(result.alertCreated).toBe(false);
            expect(mockAlertsService.create).not.toHaveBeenCalled();
        });
    });

    describe('Búsqueda de Buques (Prioridades)', () => {
        it('debe encontrar buque por MBPC (Prioridad 1)', async () => {
            const reporte = generateReport({ id_buque_mbpc: '999' });
            mockPrismaService.buque.findFirst.mockResolvedValueOnce({ id: 'b-mbpc' });

            const result = await (service as any).findVessel(reporte);
            expect(result.id).toBe('b-mbpc');
            expect(prisma.buque.findFirst).toHaveBeenCalledWith(expect.objectContaining({
                where: { idMbpc: '999' }
            }));
        });

        it('debe encontrar buque por Señal Distintiva si MBPC falla (Prioridad 2)', async () => {
            const reporte = generateReport({ id_buque_mbpc: '999', sdist: 'SD-1' });
            mockPrismaService.buque.findFirst
                .mockResolvedValueOnce(null) // Falla MBPC
                .mockResolvedValueOnce({ id: 'b-sdist' }); // Éxito SDIST

            const result = await (service as any).findVessel(reporte);
            expect(result.id).toBe('b-sdist');
            expect(prisma.buque.findFirst).toHaveBeenNthCalledWith(2, expect.objectContaining({
                where: { senalDistintiva: 'SD-1' }
            }));
        });

        it('debe encontrar buque por Matrícula si MBPC y SDIST fallan (Prioridad 3)', async () => {
            const reporte = generateReport({ id_buque_mbpc: '999', sdist: 'SD-1', matricula: 'MAT-1' });
            mockPrismaService.buque.findFirst
                .mockResolvedValueOnce(null) // Falla MBPC
                .mockResolvedValueOnce(null) // Falla SDIST
                .mockResolvedValueOnce({ id: 'b-mat' }); // Éxito Matrícula

            const result = await (service as any).findVessel(reporte);
            expect(result.id).toBe('b-mat');
            expect(prisma.buque.findFirst).toHaveBeenNthCalledWith(3, expect.objectContaining({
                where: { matricula: 'MAT-1' }
            }));
        });

        it('debe encontrar buque por Nombre como último recurso (Prioridad 4)', async () => {
            const reporte = generateReport({ nombre: 'TEST-NAME' });
            mockPrismaService.buque.findFirst
                .mockResolvedValueOnce(null)
                .mockResolvedValueOnce(null)
                .mockResolvedValueOnce(null)
                .mockResolvedValueOnce({ id: 'b-name' });

            const result = await (service as any).findVessel(reporte);
            expect(result.id).toBe('b-name');
            expect(prisma.buque.findFirst).toHaveBeenNthCalledWith(4, expect.objectContaining({
                where: { nombreBuque: { equals: 'TEST-NAME', mode: 'insensitive' } }
            }));
        });
    });

    describe('Manejo de Reportes Borrados y Snapshots', () => {
        it('debe omitir reportes marcados como borrados por la API PNA', async () => {
            // Este test requiere llamar al método público processMovements o simular el loop
            mockParser.parseXml.mockResolvedValue({
                reportes: [generateReport({ borrado: 'True' })],
                error: false
            });

            const summary = await service.processMovements();
            expect(summary.processed).toBe(0);
            expect(summary.skipped).toBe(1);
        });

        it('debe crear snapshot incluso si el buque no existe (Auditoría)', async () => {
            const reporte = generateReport({ id_buque_mbpc: 'OWNERLESS' });
            mockPrismaService.buque.findFirst.mockResolvedValue(null);

            await (service as any).processSingleReport(reporte);

            expect(mockPrismaService.pnaApiSnapshot.create).toHaveBeenCalled();
        });
        describe('Sincronización Incremental y system_status', () => {
            it('debe recuperar la fecha de última sincronización exitosa', async () => {
                const mockDate = new Date('2025-02-01T10:00:00Z');
                mockPrismaService.systemStatus.findUnique.mockResolvedValue({ key: 'LAST_PNA_SYNC', value: mockDate.toISOString() });

                const result = await service.getLastSuccessfulSyncDate();
                expect(result).toEqual(mockDate);
            });

            it('debe actualizar la fecha de última sincronización exitosa (upsert)', async () => {
                const mockDate = new Date();
                await service.updateLastSuccessfulSyncDate(mockDate);

                expect(mockPrismaService.systemStatus.upsert).toHaveBeenCalledWith(expect.objectContaining({
                    where: { key: 'LAST_PNA_SYNC' },
                    update: { value: mockDate.toISOString() }
                }));
            });

            it('debe filtrar reportes fuera del rango solicitado (00:00:00 del primer día -> 23:59:59 del último)', async () => {
                // Rango solicitado: 2025-01-15 (automáticamente desde las 00:00:00)
                const lastSync = new Date('2025-01-15T15:00:00Z');
                mockPrismaService.systemStatus.findUnique.mockResolvedValue({ key: 'LAST_PNA_SYNC', value: lastSync.toISOString() });

                mockParser.parseXml.mockResolvedValue({
                    reportes: [
                        generateReport({ fecha: '2025-01-15 01:00:00' }), // FUERA (Equivale a 14/01 22:00:00 ART)
                        generateReport({ fecha: '2025-01-15 04:00:00' }), // DENTRO (Equivale a 15/01 01:00:00 ART)
                        generateReport({ fecha: '2025-01-15 22:00:00' }), // DENTRO (Equivale a 15/01 19:00:00 ART)
                    ],
                    error: false
                });

                mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);

                const summary = await service.processMovements();

                expect(summary.processed).toBe(3); // En lógica UTC, los 3 caen el día 15
                expect(summary.skipped).toBe(0);
            });
        });
    });
});
