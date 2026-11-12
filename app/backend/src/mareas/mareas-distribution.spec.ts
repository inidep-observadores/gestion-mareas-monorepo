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
import { MareaEstado } from './mareas.constants';

describe('MareasService - getFleetDistributionByFishery', () => {
    let service: MareasService;

    const mockPrismaService = {
        marea: {
            findMany: jest.fn(),
        },
    };

    const mockBusinessRulesService = {
        getRules: jest.fn().mockReturnValue({}),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrismaService },
                { provide: BusinessRulesService, useValue: mockBusinessRulesService },
                { provide: MailService, useValue: {} },
                { provide: AlertsService, useValue: {} },
                { provide: ConfigService, useValue: { get: jest.fn() } },
                { provide: DriveStorageService, useValue: {} },
                { provide: JobQueueService, useValue: {} },
            ],
        }).compile();

        service = module.get<MareasService>(MareasService);
    });

    it('should determine fishery from the last stage when multiple stages exist', async () => {
        const mockMareas = [
            {
                id: 'marea-1',
                tipoMarea: 'MC',
                nroMarea: 123,
                anioMarea: 2025,
                estadoActual: { codigo: MareaEstado.EN_EJECUCION },
                buque: {
                    nombreBuque: 'BUQUE ALPHA',
                    tipoFlota: { codigo: 'FRESQUERO', nombre: 'Fresquero' },
                },
                pesqueria: { nombre: 'Pesqueria Marea' },
                etapas: [
                    { nroEtapa: 1, pesqueria: { nombre: 'Pesqueria Etapa 1' } },
                    { nroEtapa: 2, pesqueria: { nombre: 'Pesqueria Etapa 2' } },
                ],
            },
        ];

        mockPrismaService.marea.findMany.mockResolvedValue(mockMareas);

        const result = await service.getFleetDistributionByFishery(2025);

        // Al estar ordenadas por nroEtapa asc en el include (o al menos venir del mock asi), pickeamos la ultima
        expect(result.distribution).toHaveLength(1);
        expect(result.distribution[0].label).toBe('Pesqueria Etapa 2');
        expect(result.distribution[0].vessels[0].name).toBe('BUQUE ALPHA');
    });

    it('should fallback to marea fishery when no stages exist', async () => {
        const mockMareas = [
            {
                id: 'marea-2',
                tipoMarea: 'CI',
                nroMarea: 456,
                anioMarea: 2025,
                estadoActual: { codigo: MareaEstado.DESIGNADA },
                buque: {
                    nombreBuque: 'BUQUE BETA',
                    tipoFlota: { codigo: 'CONGELADOR', nombre: 'Congelador' },
                },
                pesqueria: { nombre: 'Pesqueria Marea' },
                etapas: [],
            },
        ];

        mockPrismaService.marea.findMany.mockResolvedValue(mockMareas);

        const result = await service.getFleetDistributionByFishery(2025);

        // Fallback a pesqueria de la marea
        expect(result.distribution).toHaveLength(1);
        expect(result.distribution[0].label).toBe('Pesqueria Marea');
        expect(result.distribution[0].vessels[0].name).toBe('BUQUE BETA');
    });

    it('should handle "Sin pesquería" when neither stages nor marea have a fishery', async () => {
        const mockMareas = [
            {
                id: 'marea-3',
                tipoMarea: 'MC',
                nroMarea: 789,
                anioMarea: 2025,
                estadoActual: { codigo: MareaEstado.EN_EJECUCION },
                buque: {
                    nombreBuque: 'BUQUE GAMMA',
                    tipoFlota: { codigo: 'FRESQUERO', nombre: 'Fresquero' },
                },
                pesqueria: null,
                etapas: [
                    { nroEtapa: 1, pesqueria: null },
                ],
            },
        ];

        mockPrismaService.marea.findMany.mockResolvedValue(mockMareas);

        const result = await service.getFleetDistributionByFishery(2025);

        expect(result.distribution[0].label).toBe('Sin pesquería');
    });

    it('should group multiple vessels by the same fishery correctly', async () => {
        const mockMareas = [
            {
                id: 'marea-1',
                tipoMarea: 'MC',
                nroMarea: 1,
                anioMarea: 2025,
                estadoActual: { codigo: MareaEstado.EN_EJECUCION },
                buque: {
                    nombreBuque: 'BUQUE A',
                    tipoFlota: { codigo: 'F', nombre: 'F' },
                },
                etapas: [{ nroEtapa: 1, pesqueria: { nombre: 'Langostino' } }],
            },
            {
                id: 'marea-2',
                tipoMarea: 'MC',
                nroMarea: 2,
                anioMarea: 2025,
                estadoActual: { codigo: MareaEstado.EN_EJECUCION },
                buque: {
                    nombreBuque: 'BUQUE B',
                    tipoFlota: { codigo: 'F', nombre: 'F' },
                },
                etapas: [{ nroEtapa: 1, pesqueria: { nombre: 'Langostino' } }],
            }
        ];

        mockPrismaService.marea.findMany.mockResolvedValue(mockMareas);

        const result = await service.getFleetDistributionByFishery(2025);

        expect(result.distribution).toHaveLength(1);
        expect(result.distribution[0].label).toBe('Langostino');
        expect(result.distribution[0].count).toBe(2);
    });
});
