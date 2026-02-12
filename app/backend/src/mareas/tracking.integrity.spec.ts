import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { TrackingService } from './tracking.service';
import { PrismaService } from '../prisma/prisma.service';
import { EventCorrelationService } from '../common/services/event-correlation.service';
import { AlertsService } from '../alerts/alerts.service';
import { VesselSyncService } from '../catalogos/buques/vessel-sync.service';

describe('TrackingService Integrity (CSV & Robustness)', () => {
    let service: TrackingService;
    let prisma: PrismaService;

    const mockPrismaService = {
        marea: {
            findMany: jest.fn().mockResolvedValue([]),
            findFirst: jest.fn(),
            findUnique: jest.fn()
        },
        buque: {
            findMany: jest.fn(),
            findUnique: jest.fn(),
            findFirst: jest.fn(),
            update: jest.fn()
        },
        puerto: {
            findMany: jest.fn()
        },
        buqueTrayectoria: {
            upsert: jest.fn().mockResolvedValue({ id: 'tray-1' })
        },
        buqueTrayectoriaPunto: {
            findFirst: jest.fn(),
            createMany: jest.fn().mockResolvedValue({ count: 1 }),
            findMany: jest.fn()
        },
        alerta: {
            create: jest.fn().mockResolvedValue({ id: 'alert-1' }),
            findFirst: jest.fn()
        },
        systemStatus: {
            findUnique: jest.fn().mockResolvedValue({ lastUpdate: new Date() }),
            upsert: jest.fn(),
            update: jest.fn()
        },
        trackingEventSnapshot: {
            findUnique: jest.fn().mockResolvedValue(null),
            create: jest.fn().mockResolvedValue({ id: 'snapshot-1' })
        }
    };

    const mockVesselSyncService = {
        syncVesselIfNeeded: jest.fn().mockResolvedValue(undefined),
    };

    const mockAlertsService = {
        create: jest.fn().mockResolvedValue({ id: 'alert-1' }),
        addValidationSource: jest.fn().mockResolvedValue(undefined),
    };

    const mockCorrelationService = {
        evaluateEventContext: jest.fn().mockResolvedValue({ action: 'NO_MATCH' }),
    };

    beforeEach(async () => {
        jest.clearAllMocks();
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                TrackingService,
                { provide: EventCorrelationService, useValue: mockCorrelationService },
                { provide: AlertsService, useValue: mockAlertsService },
                { provide: VesselSyncService, useValue: mockVesselSyncService },
                { provide: PrismaService, useValue: mockPrismaService },
            ],
        }).compile();
        service = module.get<TrackingService>(TrackingService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    it('should ignore empty CSV files silently', async () => {
        const csvContent = '';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);

        const result = await service.importTrackingData(buffer);

        expect(result.processed).toBe(0);
    });

    it('should handle CSV with only headers', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);

        const result = await service.importTrackingData(buffer);

        expect(result.processed).toBe(0);
    });

    it('should handle malformed coordinates or numbers by skipping only those points', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
            'TEST_VESSEL;123;123456;2025-01-01 10:00:00;INVALID;-57.53;not_a_number;0';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);
        // Simular que no lo encuentra por MMSI (Priority 1)
        mockPrismaService.buque.findFirst.mockImplementation((args) => {
            if (args.where.mmsi === '123456') return Promise.resolve(null);
            if (args.where.nombreBuque?.equals === 'TEST_VESSEL') return Promise.resolve({ id: 'v-1', nombreBuque: 'TEST_VESSEL' });
            return Promise.resolve(null);
        });
        // Simular que lo encuentra por Matricula SIOP (Priority 4)
        mockPrismaService.buque.findUnique.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST_VESSEL', matriculaSiop: '123' });

        const result = await service.importTrackingData(buffer);

        expect(result.processed).toBe(1);
    });

    it('should be case-insensitive and robust with spaces for vessel names', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
            '  test_vessel  ;123;123456;2025-01-01 10:00:00;-38.03;-57.53;10;0';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);
        mockPrismaService.buque.findFirst.mockImplementation((args) => {
            if (args.where.mmsi === '123456') return Promise.resolve(null); // P1
            if (args.where.nombreBuque?.equals === 'TEST_VESSEL') {
                return Promise.resolve({ id: 'v-1', nombreBuque: 'TEST_VESSEL' }); // P2
            }
            return Promise.resolve(null);
        });
        mockPrismaService.buque.findUnique.mockResolvedValue(null);

        await service.importTrackingData(buffer);

        expect(mockPrismaService.buque.findFirst).toHaveBeenCalledWith(expect.objectContaining({
            where: { nombreBuque: { equals: 'TEST_VESSEL', mode: 'insensitive' } }
        }));
    });

    it('should skip records for vessels not in database without failing the whole import', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
            'UNKNOWN;999;000000;2025-01-01 10:00:00;-38.03;-57.53;10;0\n' +
            'KNOWN;123;123456;2025-01-01 10:05:00;-38.05;-57.55;10;0';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);
        mockPrismaService.buque.findUnique.mockResolvedValue(null);
        mockPrismaService.buque.findFirst.mockImplementation((args) => {
            if (args.where.nombreBuque?.equals === 'KNOWN') {
                return Promise.resolve({ id: 'v-known', nombreBuque: 'KNOWN', matricula: '123', mmsi: '123456' });
            }
            return Promise.resolve(null);
        });
        mockPrismaService.buque.update.mockImplementation((args) => Promise.resolve({ id: 'v-known', ...args.data }));

        mockPrismaService.marea.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findMany.mockResolvedValue([]);
        mockPrismaService.buqueTrayectoriaPunto.createMany.mockResolvedValue({ count: 1 });

        const result = await service.importTrackingData(buffer);

        expect(result.processed).toBe(2);
        expect(result.errors).toHaveLength(0); // Debe ser silencioso
    });

    it('should use skipDuplicates in createMany to ensure idempotence at point level', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
            'TEST;123;123456;2025-01-01 10:00:00;-38.03;-57.53;10;0';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);
        mockPrismaService.buque.findFirst.mockImplementation((args) => {
            if (args.where.mmsi === '123456') return Promise.resolve(null);
            if (args.where.nombreBuque?.equals === 'TEST') return Promise.resolve({ id: 'v-1', nombreBuque: 'TEST', matricula: '123' });
            return Promise.resolve(null);
        });
        mockPrismaService.buque.findUnique.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST', matricula: '123' });
        mockPrismaService.buque.update.mockImplementation((args) => Promise.resolve({ id: 'v-1', ...args.data }));
        mockPrismaService.marea.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findMany.mockResolvedValue([]);

        await service.importTrackingData(buffer);

        expect(mockPrismaService.buqueTrayectoriaPunto.createMany).toHaveBeenCalledWith(expect.objectContaining({
            skipDuplicates: true
        }));
    });

    describe('GPS Jump Filtering', () => {
        const harborPort = {
            id: 'p-mdp',
            nombre: 'Mar del Plata',
            latitud: -38.03,
            longitud: -57.53,
            activo: true
        };

        beforeEach(() => {
            mockPrismaService.puerto.findMany.mockResolvedValue([harborPort]);
            mockPrismaService.marea.findMany.mockResolvedValue([{
                id: 'm-1',
                estadoActual: { codigo: 'EN_EJECUCION' },
                etapas: []
            }]);
            mockCorrelationService.evaluateEventContext.mockResolvedValue({ 
                action: 'CREATE_ALERT',
                marea: {
                    id: 'm-1',
                    anioMarea: 2025,
                    nroMarea: 1,
                    tipoMarea: 'MC',
                    buque: { nombreBuque: 'TEST' }
                }
            });
        });

        it('should detect a valid departure (normal speed)', async () => {
            const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
                'TEST;123;123456;2025-01-01 10:00:00;-38.03;-57.53;0;0\n' + // Punto 1: Inicializa lastState (InPort)
                'TEST;123;123456;2025-01-01 11:00:00;-38.03;-57.53;0;0\n' + // Punto 2: Sigue en puerto, confirma estado base
                'TEST;123;123456;2025-01-01 12:00:00;-38.20;-57.70;8;0';   // Punto 3: ZARPADA (InPort -> OutPort)
            const buffer = Buffer.from(csvContent);

            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue(null);
            mockPrismaService.buque.findFirst.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST' });

            await service.importTrackingData(buffer);

            // Debe haber intentado crear una alerta de POSIBLE_ZARPADA
            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'POSIBLE_ZARPADA'
            }));
        });

        it('should detect a valid arrival (normal speed)', async () => {
            const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
                'TEST;123;123456;2025-01-01 10:00:00;-38.20;-57.70;8;0\n' + // Punto 1: Inicializa lastState (OutPort)
                'TEST;123;123456;2025-01-01 11:00:00;-38.20;-57.70;8;0\n' + // Punto 2: Sigue fuera, confirma OutPort
                'TEST;123;123456;2025-01-01 13:00:00;-38.03;-57.53;0;0';   // Punto 3: ARRIBO (OutPort -> InPort) a vel normal
            const buffer = Buffer.from(csvContent);

            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue(null);
            mockPrismaService.buque.findFirst.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST' });

            await service.importTrackingData(buffer);

            // Debe haber intentado crear una alerta de POSIBLE_ARRIBO
            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'POSIBLE_ARRIBO'
            }));
        });

        it('should ignore an illogical "jump" (excessive speed)', async () => {
            const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
                'TEST;123;123456;2025-01-01 10:00:00;-38.03;-57.53;0;0\n' + // Punto inicial (InPort)
                'TEST;123;123456;2025-10-01 10:00:00;-38.03;-57.53;0;0\n' + // Punto de reposo (InPort)
                'TEST;123;123456;2025-10-01 10:01:00;-40.03;-58.53;10;0';  // Salto masivo en 1 min
            const buffer = Buffer.from(csvContent);

            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue(null);
            mockPrismaService.buque.findFirst.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST' });

            await service.importTrackingData(buffer);

            // NO debe haber creado alerta de ZARPADA
            expect(mockAlertsService.create).not.toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'ZARPADA'
            }));
        });
    });
});
