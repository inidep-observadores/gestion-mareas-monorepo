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
            findMany: jest.fn(),
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
        mockPrismaService.buque.findUnique.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST_VESSEL', matriculaSiop: '123' });
        mockPrismaService.marea.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findMany.mockResolvedValue([]);
        mockPrismaService.buqueTrayectoriaPunto.createMany.mockResolvedValue({ count: 0 });

        const result = await service.importTrackingData(buffer);

        expect(result.processed).toBe(1);
    });

    it('should be case-insensitive and robust with spaces for vessel names', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
            '  test_vessel  ;123;123456;2025-01-01 10:00:00;-38.03;-57.53;10;0';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);
        mockPrismaService.buque.findUnique.mockResolvedValue(null);
        mockPrismaService.buque.findFirst.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST_VESSEL', matriculaSiop: '123' });
        mockPrismaService.marea.findFirst.mockResolvedValue(null);

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
                return Promise.resolve({ id: 'v-known', nombreBuque: 'KNOWN' });
            }
            return Promise.resolve(null);
        });

        mockPrismaService.marea.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findMany.mockResolvedValue([]);
        mockPrismaService.buqueTrayectoriaPunto.createMany.mockResolvedValue({ count: 1 });

        const result = await service.importTrackingData(buffer);

        expect(result.processed).toBe(2);
    });

    it('should use skipDuplicates in createMany to ensure idempotence at point level', async () => {
        const csvContent = 'Buque;Matricula;MMSI;Fecha;Latitud;Longitud;Velocidad;Rumbo\n' +
            'TEST;123;123456;2025-01-01 10:00:00;-38.03;-57.53;10;0';
        const buffer = Buffer.from(csvContent);

        mockPrismaService.buque.findMany.mockResolvedValue([]);
        mockPrismaService.buque.findUnique.mockResolvedValue({ id: 'v-1', nombreBuque: 'TEST' });
        mockPrismaService.marea.findFirst.mockResolvedValue(null);
        mockPrismaService.puerto.findMany.mockResolvedValue([]);

        await service.importTrackingData(buffer);

        expect(mockPrismaService.buqueTrayectoriaPunto.createMany).toHaveBeenCalledWith(expect.objectContaining({
            skipDuplicates: true
        }));
    });
});
