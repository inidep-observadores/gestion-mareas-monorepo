import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { PnaApiService } from './pna-api.service';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { PnaApiParser } from './pna-api.parser';
import { EventCorrelationService } from '../common/services/event-correlation.service';
import { JobQueueService } from '../jobs/job-queue.service';
import { DateTime } from 'luxon';
import { PnaReporteCostera } from './pna-api.interfaces';
import { ConfigService } from '@nestjs/config';

describe('PnaApiService - Reglas de Negocio Unificadas', () => {
    let service: PnaApiService;
    let prisma: PrismaService;
    let alertsService: AlertsService;

    const mockPrismaService = {
        buque: { findFirst: jest.fn() },
        puerto: { findFirst: jest.fn(), findMany: jest.fn(), findUnique: jest.fn() },
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
            if (key === 'USE_MOCK_FISHERY_API') return 'false';
            if (key === 'PNA_API_SYNC_SAFE_RANGE_DAYS') return '20';
            return null;
        }),
    };

    const mockJobQueueService = {
        addJob: jest.fn().mockResolvedValue({ id: 'mock-job-id' }),
    };

    beforeEach(async () => {
        jest.clearAllMocks();

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
                { provide: JobQueueService, useValue: mockJobQueueService },
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

    describe('Sincronización Incremental y system_status', () => {
        it('debe filtrar reportes fuera del rango solicitado', async () => {
            const lastSync = new Date('2025-01-15T15:00:00Z');
            mockPrismaService.systemStatus.findUnique.mockResolvedValue({ key: 'LAST_PNA_SYNC', value: lastSync.toISOString() });

            mockParser.parseXml.mockResolvedValue({
                reportes: [
                    generateReport({ fecha: '2025-01-15 01:00:00' }),
                    generateReport({ fecha: '2025-01-15 04:00:00' }),
                    generateReport({ fecha: '2025-01-15 22:00:00' }),
                ],
                error: false
            });

            mockPrismaService.buque.findFirst.mockResolvedValue(mockBuque);
            const summary = await service.processMovements();
            expect(summary.processed).toBe(3);
        });
    });

    describe('Modo Ingesta Pura (onlyIngest)', () => {
        it('debe persistir datos pero NO llamar a processSingleReport cuando onlyIngest es true', async () => {
            const reporte = generateReport();
            mockParser.parseXml.mockResolvedValue({
                reportes: [reporte],
                error: false
            });

            const processSpy = jest.spyOn(service as any, 'processSingleReport');
            const persistSpy = jest.spyOn(service as any, 'persistHistoricalData').mockResolvedValue(null);

            await service.processMovements(undefined, undefined, true);

            expect(persistSpy).toHaveBeenCalled();
            expect(processSpy).not.toHaveBeenCalled();
        });
    });

    describe('Fragmentación de Rangos Largos', () => {
        it('debe encolar múltiples trabajos si el rango excede SAFE_RANGE_DAYS', async () => {
            const from = new Date('2024-01-01T10:00:00Z');
            const to = new Date('2024-02-10T10:00:00Z');

            await service.scheduleManualSynchronization(from, to, true);

            expect(mockJobQueueService.addJob).toHaveBeenCalledTimes(3);
            expect(mockJobQueueService.addJob).toHaveBeenLastCalledWith(
                'PNA_API_SYNC',
                expect.objectContaining({ onlyIngest: true }),
                expect.any(Number),
                expect.any(Date)
            );
        });
    });
});
