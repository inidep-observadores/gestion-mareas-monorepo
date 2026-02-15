import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { TrackingService } from './tracking.service';
import { PrismaService } from '../prisma/prisma.service';
import { EventCorrelationService } from '../common/services/event-correlation.service';
import { AlertsService } from '../alerts/alerts.service';
import { AlertAutomationService } from '../alerts/alert-automation.service';
import { VesselSyncService } from '../catalogos/buques/vessel-sync.service';

describe('TrackingService', () => {
    let service: TrackingService;

    const mockAutomationService = {
        processAlertAutomation: jest.fn().mockResolvedValue(undefined),
    };

    const mockAlertsService = {
        create: jest.fn().mockResolvedValue({ id: 'mock-alert-id' }),
        addValidationSource: jest.fn().mockResolvedValue({ id: 'mock-alert-id' }),
    };

    const mockCorrelationService = {
        evaluateEventContext: jest.fn(),
    };

    const mockPrismaService = {
        marea: {
            findMany: jest.fn(),
            findUnique: jest.fn(),
            findFirst: jest.fn(),
        },
        puerto: {
            findMany: jest.fn(),
        },
        buqueTrayectoriaPunto: {
            findFirst: jest.fn(),
            createMany: jest.fn(),
        },
        buqueTrayectoria: {
            upsert: jest.fn(),
        },
        trackingEventSnapshot: {
            findUnique: jest.fn(),
            create: jest.fn(),
        },
        systemStatus: {
            findUnique: jest.fn().mockResolvedValue({ lastUpdate: new Date() }),
            create: jest.fn(),
            update: jest.fn(),
        }
    };

    const mockVesselSyncService = {
        syncVesselIfNeeded: jest.fn().mockResolvedValue({ success: true }),
    };

    beforeEach(async () => {
        jest.clearAllMocks();
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                TrackingService,
                { provide: EventCorrelationService, useValue: mockCorrelationService },
                { provide: AlertsService, useValue: mockAlertsService },
                { provide: AlertAutomationService, useValue: mockAutomationService },
                { provide: VesselSyncService, useValue: mockVesselSyncService },
                { provide: PrismaService, useValue: mockPrismaService },
            ],
        }).compile();

        service = module.get<TrackingService>(TrackingService);
    });

    describe('checkPortStatus (Internal logic testable via detectPortEvents)', () => {
        it('should detect when a point is inside a port radius', async () => {
            const ports = [
                { id: 'port-1', nombre: 'Mar del Plata', latitud: -38.03, longitud: -57.53 }
            ];
            mockPrismaService.puerto.findMany.mockResolvedValue(ports);

            const marea = { id: 'marea-1', buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC', etapas: [], estadoActual: { codigo: 'EN_EJECUCION' } };
            mockPrismaService.marea.findMany.mockResolvedValue([marea]);

            // Mocking CorrelationService to trigger createAlert
            mockCorrelationService.evaluateEventContext.mockResolvedValue({
                action: 'CREATE_ALERT',
                marea: marea
            });

            // First point outside, second inside
            const points = [
                { lat: -38.13, lon: -57.63, timestamp: new Date('2025-01-01T00:00:00Z') }, // outside
                { lat: -38.03, lon: -57.53, timestamp: new Date('2025-01-01T10:00:00Z') }  // inside
            ];

            // Mocking previous state as outside
            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue(null);

            await (service as any).detectPortEvents('vessel-1', points);

            expect(mockAlertsService.create).toHaveBeenCalled();
        });
    });

    describe('Business Rule: fecha_zarpada_estimada restriction', () => {
        const ports = [{ id: 'port-1', nombre: 'Test Port', latitud: -38.0, longitud: -57.0 }];
        const mareaBase = {
            id: 'marea-1',
            buqueId: 'vessel-1',
            anioMarea: 2026,
            nroMarea: 1,
            tipoMarea: 'MC',
            estadoActual: { codigo: 'DESIGNADA' },
            buque: { id: 'vessel-1', nombreBuque: 'Test Vessel' },
            etapas: [],
            fechaZarpadaEstimada: new Date('2026-02-14T03:00:00Z'), // 00:00 ART
        };

        beforeEach(() => {
            mockPrismaService.puerto.findMany.mockResolvedValue(ports);
            mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);
            // Mock prev point in port-1
            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue({
                lat: -38.0, lon: -57.0, timestamp: new Date('2026-02-12T00:00:00Z')
            });
        });

        it('should IGNORE ZARPADA if CorrelationService returns IGNORE_OLD', async () => {
            mockPrismaService.marea.findMany.mockResolvedValue([mareaBase]);
            mockCorrelationService.evaluateEventContext.mockResolvedValue({
                action: 'IGNORE_OLD',
                marea: mareaBase
            });

            const points = [{ lat: -38.1, lon: -57.1, timestamp: new Date('2026-02-13T12:00:00Z') }];
            await (service as any).detectPortEvents('vessel-1', points);

            expect(mockAlertsService.create).not.toHaveBeenCalled();
        });

        it('should CREATE_ALERT if CorrelationService returns CREATE_ALERT', async () => {
            mockPrismaService.marea.findMany.mockResolvedValue([mareaBase]);
            mockCorrelationService.evaluateEventContext.mockResolvedValue({
                action: 'CREATE_ALERT',
                marea: mareaBase
            });

            const points = [{ lat: -38.1, lon: -57.1, timestamp: new Date('2026-02-14T04:00:00Z') }];
            await (service as any).detectPortEvents('vessel-1', points);

            expect(mockAlertsService.create).toHaveBeenCalledWith(expect.objectContaining({
                tipo: 'POSIBLE_ZARPADA'
            }));
        });
    });
});
