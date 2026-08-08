import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { ConfigService } from '@nestjs/config';
import { DriveStorageService } from '../files/drive-storage.service';
import { JobQueueService } from '../jobs/job-queue.service';

describe('MareasService - getWorkforceStatus', () => {
    let service: MareasService;
    let mockPrismaService: any;

    const mockBusinessRulesService = {
        getRules: jest.fn().mockReturnValue({
            DIAS_DESCANSO_POST_MAREA: 5,
        }),
    };

    beforeEach(async () => {
        mockPrismaService = {
            observador: {
                findMany: jest.fn(),
            },
            mareaEtapa: {
                findMany: jest.fn(),
            },
            marea: {
                findMany: jest.fn(),
            },
            systemStatus: {
                findUnique: jest.fn().mockResolvedValue({ lastUpdate: new Date() }),
                upsert: jest.fn(),
                update: jest.fn(),
            },
            alerta: {
                findMany: jest.fn().mockResolvedValue([]),
            },
            seguimientoPostMarea: {
                findMany: jest.fn().mockResolvedValue([]),
                updateMany: jest.fn(),
            }
        };

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrismaService },
                { provide: BusinessRulesService, useValue: mockBusinessRulesService },
                { provide: MailService, useValue: {} },
                { provide: AlertsService, useValue: {} },
                { provide: ConfigService, useValue: { get: jest.fn().mockReturnValue('60') } },
                { provide: DriveStorageService, useValue: {} },
                { provide: JobQueueService, useValue: {} },
            ],
        }).compile();

        service = module.get<MareasService>(MareasService);
    });

    it('debe mapear correctamente los observadores designados y su pesquería', async () => {
        const now = new Date('2026-03-28T12:00:00Z');
        jest.useFakeTimers().setSystemTime(now);

        const mockObservers = [
            { id: 'obs-1', apellido: 'Perez', nombre: 'Juan', activo: true, sexo: 'Masculino', eventual: false, tipoObservador: 'OBSERVADOR', tipoContrato: 'TITULAR' },
            { id: 'obs-2', apellido: 'Gomez', nombre: 'Ana', activo: true, sexo: 'Femenino', eventual: false, tipoObservador: 'OBSERVADOR', tipoContrato: 'TITULAR' },
        ];
        mockPrismaService.observador.findMany.mockResolvedValue(mockObservers);
        mockPrismaService.mareaEtapa.findMany.mockResolvedValue([]);

        const mockMareasDesignadas = [
            {
                id: 'marea-1',
                nroMarea: 10,
                anioMarea: 2026,
                observadorPrincipalId: 'obs-1',
                buque: { nombreBuque: 'BUQUE TEST' },
                pesqueria: { nombre: 'PESQUERIA TEST' },
                estadoActual: { codigo: 'DESIGNADA' },
                fechaZarpadaEstimada: new Date('2026-04-01')
            },
            {
                id: 'marea-2',
                nroMarea: 11,
                anioMarea: 2026,
                observadorPrincipalId: 'obs-2',
                buque: { nombreBuque: 'OTRO BUQUE' },
                pesqueria: null,
                estadoActual: { codigo: 'DESIGNADA' },
                fechaZarpadaEstimada: null
            }
        ];
        mockPrismaService.marea.findMany.mockResolvedValue(mockMareasDesignadas);
        mockPrismaService.systemStatus.findUnique.mockResolvedValue({ key: 'LAST_ALERT_CHECK', lastUpdate: now });

        const result = await service.getWorkforceStatus(2026);

        expect(result.designados).toBe(2);
        const obs1 = result.listDesignados.find(o => o.id === 'obs-1');
        expect(obs1?.fishery).toBe('PESQUERIA TEST');
        const obs2 = result.listDesignados.find(o => o.id === 'obs-2');
        expect(obs2?.fishery).toBe('Sin Pesquería');

        jest.useRealTimers();
    });

    it('debe priorizar la pesquería de la etapa incluso en mareas DESIGNADAS si existe la etapa', async () => {
        const now = new Date('2026-03-28T12:00:00Z');
        jest.useFakeTimers().setSystemTime(now);

        const obsObj = { id: 'obs-1', apellido: 'Perez', nombre: 'Juan', activo: true, sexo: 'Masculino', eventual: false, tipoObservador: 'OBSERVADOR', tipoContrato: 'TITULAR' };
        mockPrismaService.observador.findMany.mockResolvedValue([obsObj]);

        mockPrismaService.marea.findMany.mockResolvedValue([
            {
                id: 'marea-1',
                nroMarea: 15,
                anioMarea: 2026,
                observadorPrincipalId: 'obs-1',
                buque: { nombreBuque: 'BUQUE DE MAREA' },
                pesqueria: { nombre: 'PESQUERIA MAREA' },
                estadoActual: { codigo: 'DESIGNADA' }
            }
        ]);

        mockPrismaService.mareaEtapa.findMany.mockResolvedValue([
            {
                mareaId: 'marea-1',
                nroEtapa: 1,
                fechaZarpada: new Date('2026-03-27'),
                marea: {
                    id: 'marea-1',
                    estadoActual: { codigo: 'DESIGNADA' },
                    buque: { nombreBuque: 'BUQUE DE MAREA' },
                    observadorPrincipalId: 'obs-1',
                    observadorPrincipal: obsObj // Importante para el loop
                },
                pesqueria: { nombre: 'PESQUERIA ETAPA' },
                observadores: [{ observador: obsObj }] // Importante para el loop
            }
        ]);
        
        mockPrismaService.systemStatus.findUnique.mockResolvedValue({ key: 'LAST_ALERT_CHECK', lastUpdate: now });

        const result = await service.getWorkforceStatus(2026);

        const obs = result.listDesignados[0];
        expect(obs.fishery).toBe('PESQUERIA ETAPA');

        jest.useRealTimers();
    });
});
