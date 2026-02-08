import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { TrackingService } from './tracking.service';
import { PrismaService } from '../prisma/prisma.service';
import { EventCorrelationService } from '../common/services/event-correlation.service';
import { AlertsService } from '../alerts/alerts.service';
import { VesselSyncService } from '../catalogos/buques/vessel-sync.service';

describe('TrackingService', () => {
    let service: TrackingService;
    let prisma: PrismaService;

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
        alerta: {
            findFirst: jest.fn(),
            create: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'mock-alert-id', ...args.data })),
            findUnique: jest.fn(),
            update: jest.fn(),
        },
        alertaEvento: {
            create: jest.fn().mockResolvedValue({ id: 'mock-event-id' }),
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
        syncVessel: jest.fn().mockResolvedValue({ success: true }),
    };

    beforeEach(async () => {
        jest.clearAllMocks();
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                TrackingService,
                EventCorrelationService,
                AlertsService,
                { provide: VesselSyncService, useValue: mockVesselSyncService },
                { provide: PrismaService, useValue: mockPrismaService },
            ],
        }).compile();

        service = module.get<TrackingService>(TrackingService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    describe('checkPortStatus (Internal logic testable via detectPortEvents)', () => {
        it('should detect when a point is inside a port radius', async () => {
            const ports = [
                { id: 'port-1', nombre: 'Mar del Plata', latitud: -38.03, longitud: -57.53 }
            ];
            mockPrismaService.puerto.findMany.mockResolvedValue(ports);
            mockPrismaService.marea.findMany.mockResolvedValue([{ id: 'marea-1', buqueId: 'vessel-1', etapas: [], estadoActual: { codigo: 'EN_EJECUCION' }, buque: { nombreBuque: 'Test' } }]);

            // First point outside, second inside
            const points = [
                { lat: -37.00, lon: -56.00, timestamp: new Date('2025-01-01T10:00:00Z') }, // far
                { lat: -38.03, lon: -57.53, timestamp: new Date('2025-01-01T11:00:00Z') }  // inside
            ];

            // Mocking previous state as outside
            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue(null);

            await (service as any).detectPortEvents('vessel-1', points);

            // Should create an ARRIBO alert
            expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    titulo: expect.stringContaining('Posible arribo a Mar del Plata')
                })
            }));
        });
    });

    describe('Discrepancy detection', () => {
        it('should create discrepancy alert if detected port differs from registered port', async () => {
            const ports = [
                { id: 'port-real', nombre: 'Puerto Real', latitud: -40.0, longitud: -60.0 },
                { id: 'port-reg', nombre: 'Puerto Registrado', latitud: -41.0, longitud: -61.0 }
            ];
            mockPrismaService.puerto.findMany.mockResolvedValue(ports);

            const marea = {
                id: 'marea-1',
                buqueId: 'vessel-1',
                anioMarea: 2025,
                nroMarea: 1,
                tipoMarea: 'MC',
                estadoActual: { codigo: 'EN_EJECUCION' },
                buque: { nombreBuque: 'Test Vessel' },
                etapas: [
                    {
                        nroEtapa: 1,
                        fechaZarpada: new Date('2025-01-01T00:00:00Z'),
                        puertoZarpadaId: 'port-reg'
                    }
                ]
            };
            mockPrismaService.marea.findMany.mockResolvedValue([marea]);
            mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

            // Detect ZARPADA from a DIFFERENT port than registered
            // Prev state: in port-real
            // Current point: outside
            const points = [
                { lat: -30.0, lon: -30.0, timestamp: new Date('2025-01-01T01:00:00Z') } // outside
            ];
            // Mock prev point in port-real
            mockPrismaService.buqueTrayectoriaPunto.findFirst.mockResolvedValue({
                lat: -40.0, lon: -60.0, timestamp: new Date('2025-01-01T00:00:00Z')
            });

            await (service as any).detectPortEvents('vessel-1', points);

            expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    tipo: 'ERROR_REGISTRO_PUERTO',
                    titulo: expect.stringContaining('Discrepancia en puerto de zarpada')
                })
            } as any));
        });
    });
});
