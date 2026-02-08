import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { TrackingService } from './tracking.service';
import { PrismaService } from '../prisma/prisma.service';
import { EventCorrelationService } from '../common/services/event-correlation.service';
import { AlertsService } from '../alerts/alerts.service';
import { VesselSyncService } from '../catalogos/buques/vessel-sync.service';
import { DateTime } from 'luxon';

describe('TrackingService Matching V2', () => {
    let service: TrackingService;
    let prisma: PrismaService;

    const mockPrismaService = {
        marea: { findMany: jest.fn() },
        puerto: { findMany: jest.fn() },
        buqueTrayectoriaPunto: { findFirst: jest.fn(), createMany: jest.fn() },
        alerta: {
            findFirst: jest.fn(),
            create: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'mock-alert-id', ...args.data })),
            findUnique: jest.fn(),
            update: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'mock-alert-id', ...args.data }))
        },
        alertaEvento: { create: jest.fn().mockResolvedValue({ id: 'mock-event-id' }) },
        trackingEventSnapshot: { findUnique: jest.fn(), create: jest.fn() },
        systemStatus: { findUnique: jest.fn().mockResolvedValue({ lastUpdate: new Date() }), create: jest.fn() },
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

    const mockPorts = [{ id: 'port-mdp', nombre: 'Mar del Plata', latitud: -38.03, longitud: -57.53 }];

    it('debe asignar zarpada a marea DESIGNADA si existe una EN_EJECUCION', async () => {
        const mareaEjecucion = { id: 'm-ejec', estadoActual: { codigo: 'EN_EJECUCION' }, etapas: [], buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC' };
        const mareaDesignada = { id: 'm-desig', estadoActual: { codigo: 'DESIGNADA' }, etapas: [], buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 2, tipoMarea: 'MC' };

        mockPrismaService.marea.findMany.mockResolvedValue([mareaEjecucion, mareaDesignada]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);
        mockPrismaService.alerta.findFirst.mockResolvedValue(null);

        // Evento de zarpada (estábamos en puerto, ahora afuera)
        const date = new Date('2025-01-01T10:00:00Z');
        await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp', date, [mareaEjecucion, mareaDesignada], mockPorts);

        // Debe haber creado alerta para la marea DESIGNADA (m-desig)
        expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                referenciaId: 'm-desig',
                titulo: expect.stringContaining('(MC-2-25)')
            })
        }));
    });

    it('debe recomendar FIN DE MAREA si hay arribo en marea EN_EJECUCION y existe una DESIGNADA', async () => {
        const mareaEjecucion = { id: 'm-ejec', estadoActual: { codigo: 'EN_EJECUCION' }, etapas: [{ nroEtapa: 1, fechaZarpada: new Date('2025-01-01T00:00:00Z') }], buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC' };
        const mareaDesignada = { id: 'm-desig', estadoActual: { codigo: 'DESIGNADA' }, etapas: [], buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 2, tipoMarea: 'MC' };

        mockPrismaService.marea.findMany.mockResolvedValue([mareaEjecucion, mareaDesignada]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const date = new Date('2025-01-02T10:00:00Z');
        await (service as any).handleProcessedEvent('vessel-1', 'ARRIBO', 'port-mdp', date, [mareaEjecucion, mareaDesignada], mockPorts);

        expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                tipo: 'RECOMENDACION_FIN_MAREA',
                titulo: expect.stringContaining('Se recomienda FINALIZAR MAREA')
            })
        }));
    });

    it('debe lograr match y detectar incongruencia si hay 1 día de diferencia local', async () => {
        // Marea con zarpada registrada el 06/01 (Local)
        // Detección ocurre el 07/01 (Local).
        const regDate = DateTime.fromISO('2025-01-06T10:00:00', { zone: 'America/Argentina/Buenos_Aires' }).toJSDate();
        const detDate = DateTime.fromISO('2025-01-07T10:00:00', { zone: 'America/Argentina/Buenos_Aires' }).toJSDate();

        const marea = {
            id: 'm-1',
            estadoActual: { codigo: 'EN_EJECUCION' },
            etapas: [{ nroEtapa: 1, fechaZarpada: regDate, puertoZarpadaId: 'port-mdp' }],
            buque: { nombreBuque: 'Test' },
            anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp', detDate, [marea], mockPorts);

        expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                tipo: 'ERROR_FECHA_MOVIMIENTO',
                titulo: expect.stringContaining('Incongruencia de FECHA')
            })
        }));
    });

    it('no debe lograr match si hay 2 días de diferencia local', async () => {
        // Registro 06/01 vs Detección 08/01
        const regDate = DateTime.fromISO('2025-01-06T10:00:00', { zone: 'America/Argentina/Buenos_Aires' }).toJSDate();
        const detDate = DateTime.fromISO('2025-01-08T10:00:00', { zone: 'America/Argentina/Buenos_Aires' }).toJSDate();

        const marea = {
            id: 'm-1',
            estadoActual: { codigo: 'EN_EJECUCION' },
            etapas: [{ nroEtapa: 1, fechaZarpada: regDate, puertoZarpadaId: 'port-mdp' }],
            buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp', detDate, [marea], mockPorts);

        // Al no haber match, debería intentar crear una alerta de "Posible Zarpada" (nuevo evento)
        expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                tipo: 'POSIBLE_ZARPADA'
            })
        }));
    });

    it('debe lograr el match si es el mismo día local sin importar la hora (Caso 00:00 vs 23:59)', async () => {
        // Registro manual a las 00:00
        const regDate = DateTime.fromISO('2026-01-06T00:00:00', { zone: 'America/Argentina/Buenos_Aires' }).toJSDate();
        // Detección satelital a las 23:59
        const detDate = DateTime.fromISO('2026-01-06T23:59:00', { zone: 'America/Argentina/Buenos_Aires' }).toJSDate();

        const marea = {
            id: 'm-1',
            estadoActual: { codigo: 'EN_EJECUCION' },
            etapas: [{ nroEtapa: 1, fechaZarpada: regDate, puertoZarpadaId: 'port-mdp' }],
            buque: { nombreBuque: 'Test' }, anioMarea: 2026, nroMarea: 6, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const result = await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp', detDate, [marea], mockPorts);

        expect(result).toBe(false); // Match perfecto
        expect(mockPrismaService.alerta.create).not.toHaveBeenCalled();
    });

    it('no debe generar alerta de posible movimiento si coincide con una marea FINALIZADA', async () => {
        const mareaFinalizada = {
            id: 'm-fin',
            estadoActual: { codigo: 'FINALIZADA' },
            etapas: [{ nroEtapa: 1, fechaZarpada: new Date('2025-01-01T10:00:00Z'), puertoZarpadaId: 'port-mdp' }],
            buque: { nombreBuque: 'Test' }, anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([mareaFinalizada]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const date = new Date('2025-01-01T10:05:00Z'); // Match perfecto
        const result = await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp', date, [mareaFinalizada], mockPorts);

        expect(result).toBe(false); // No se creó alerta
        expect(mockPrismaService.alerta.create).not.toHaveBeenCalled();
    });

    it('debe lograr el match si los puertos tienen distinto ID pero mismo nombre', async () => {
        // Puerto registrado en la marea: 'port-mdp-old'
        // Puerto detectado por el sistema: 'port-mdp-new'
        // Ambos son "Mar del Plata"
        const ports = [
            { id: 'port-mdp-new', nombre: 'Mar del Plata', latitud: -38.03, longitud: -57.53 },
            { id: 'port-mdp-old', nombre: 'Mar del Plata', latitud: -38.03, longitud: -57.53 }
        ];
        const marea = {
            id: 'm-1',
            estadoActual: { codigo: 'EN_EJECUCION' },
            etapas: [{ nroEtapa: 1, fechaZarpada: new Date('2026-01-06T10:00:00Z'), puertoZarpadaId: 'port-mdp-old' }],
            buque: { nombreBuque: 'Test' }, anioMarea: 2026, nroMarea: 6, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(ports);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const date = new Date('2026-01-06T10:00:00Z');
        // El sistema detecta 'port-mdp-new'
        const result = await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp-new', date, [marea], ports);

        // AHORA el resultado debe ser TRUE (detecta discrepancia por ID distinto, aunque el nombre sea igual)
        // Esto cumple con la nueva política de integridad: IDs distintos = Puertos distintos.
        expect(result).toBe(true);
        expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                tipo: 'ERROR_REGISTRO_PUERTO'
            })
        }));
    });
    it('debe ignorar zarpada si la fecha es anterior a etapas existentes (Caso Anita 05/01 vs 27/01)', async () => {
        // Marea con etapa iniciada el 27/01
        const stageDate = new Date('2026-01-27T10:00:00Z');
        // Detección tardía del sistema del 05/01
        const eventDate = new Date('2026-01-05T17:47:00Z');

        const marea = {
            id: 'm-anita',
            estadoActual: { codigo: 'EN_EJECUCION' },
            etapas: [{ nroEtapa: 1, fechaZarpada: stageDate, puertoZarpadaId: 'port-mdp' }],
            buque: { nombreBuque: 'ANITA' }, anioMarea: 2026, nroMarea: 13, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const result = await (service as any).handleProcessedEvent('vessel-anita', 'ZARPADA', 'port-mdp', eventDate, [marea], mockPorts);

        // El resultado debe ser FALSE (ignorado por incoherencia cronológica)
        expect(result).toBe(false);
        expect(mockPrismaService.alerta.create).not.toHaveBeenCalled();
    });

    it('debe ignorar arribo si la fecha es anterior al inicio de la marea (Caso Jose Marcelo 31/12 vs 19/01)', async () => {
        // Marea con etapa iniciada el 19/01
        const stageDate = new Date('2026-01-19T10:00:00Z');
        // Detección tardía del sistema del 31/12
        const eventDate = new Date('2025-12-31T21:02:00Z');

        const marea = {
            id: 'm-jose',
            estadoActual: { codigo: 'EN_EJECUCION' },
            etapas: [{ nroEtapa: 1, fechaZarpada: stageDate, puertoZarpadaId: 'port-mdp' }],
            buque: { nombreBuque: 'JOSE MARCELO' }, anioMarea: 2026, nroMarea: 10, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const result = await (service as any).handleProcessedEvent('vessel-jose', 'ARRIBO', 'port-mdp', eventDate, [marea], mockPorts);

        // El resultado debe ser FALSE (ignorado por incoherencia cronológica)
        expect(result).toBe(false);
        expect(mockPrismaService.alerta.create).not.toHaveBeenCalled();
    });

    it('debe detectar zarpada si la marea es DESIGNADA y no tiene etapas aún', async () => {
        const marea = {
            id: 'm-new',
            estadoActual: { codigo: 'DESIGNADA' },
            etapas: [], // Sin etapas aún
            buque: { nombreBuque: 'NUEVO' }, anioMarea: 2026, nroMarea: 1, tipoMarea: 'MC'
        };

        mockPrismaService.marea.findMany.mockResolvedValue([marea]);
        mockPrismaService.puerto.findMany.mockResolvedValue(mockPorts);
        mockPrismaService.trackingEventSnapshot.findUnique.mockResolvedValue(null);

        const date = new Date('2026-02-01T10:00:00Z');
        const result = await (service as any).handleProcessedEvent('vessel-1', 'ZARPADA', 'port-mdp', date, [marea], mockPorts);

        // Debe ser TRUE (creó alerta de movimiento)
        expect(result).toBe(true);
        expect(mockPrismaService.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({ tipo: 'POSIBLE_ZARPADA' })
        }));
    });
});
