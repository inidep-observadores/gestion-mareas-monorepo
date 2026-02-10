
import { Test, TestingModule } from '@nestjs/testing';
import { AlertAutomationService } from './alert-automation.service';
import { PrismaService } from '../prisma/prisma.service';
import { MareasService } from '../mareas/mareas.service';
import { forwardRef } from '@nestjs/common';

describe('AlertAutomationService', () => {
    let service: AlertAutomationService;
    let prisma: any;
    let mareasService: any;

    const mockSystemUser = { id: 'admin-id', roles: ['admin'] };

    // Mocks for dependencies
    const mockPrisma = {
        alerta: {
            findUnique: jest.fn(),
            findMany: jest.fn(),
            update: jest.fn(),
        },
        marea: {
            findUnique: jest.fn(),
        },
        user: {
            findFirst: jest.fn().mockResolvedValue(mockSystemUser),
        },
        alertaEvento: {
            create: jest.fn().mockResolvedValue({ id: 'ae1' }),
        }
    };

    const mockMareasService = {
        executeAction: jest.fn().mockResolvedValue(true),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AlertAutomationService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: MareasService, useValue: mockMareasService },
            ],
        }).compile();

        service = module.get<AlertAutomationService>(AlertAutomationService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    describe('processAlertAutomation', () => {
        it('should return SKIPPED for non-pending alerts', async () => {
            mockPrisma.alerta.findUnique.mockResolvedValue({ id: 'a1', estado: 'RESUELTA' });
            const result = await service.processAlertAutomation('a1');
            expect(result).toEqual({ status: 'SKIPPED', reason: 'Alerta no encontrada o no está en estado PENDIENTE' });
            expect(mockPrisma.marea.findUnique).not.toHaveBeenCalled();
        });

        it('should process RECOMENDACION_FIN_MAREA with single source (Tracking)', async () => {
            const alert = {
                id: 'a1',
                tipo: 'RECOMENDACION_FIN_MAREA',
                estado: 'PENDIENTE',
                fechaDetectada: new Date(),
                referenciaId: 'm1',
                referenciaTipo: 'MAREA',
                metadata: {
                    sources: [{ name: 'TRACKING_CSV', data: {} }]
                }
            };

            const marea = {
                id: 'm1',
                estadoActual: { codigo: 'EN_EJECUCION' },
                etapas: [{ nroEtapa: 1, puertoArriboId: null }]
            };

            mockPrisma.alerta.findUnique.mockResolvedValue(alert);
            mockPrisma.marea.findUnique.mockResolvedValue(marea);

            const result = await service.processAlertAutomation('a1');

            expect(mockMareasService.executeAction).toHaveBeenCalledWith(
                'm1',
                'REGISTRAR_FINALIZACION',
                mockSystemUser,
                expect.anything()
            );
            expect(mockPrisma.alerta.update).toHaveBeenCalledWith(expect.objectContaining({
                where: { id: 'a1' },
                data: expect.objectContaining({ estado: 'RESUELTA' })
            }));
            expect(result).toEqual({ status: 'CONFIRMED', reason: 'Acción ejecutada correctamente' });
        });

        it('should ignore regular ARRIBO with single source', async () => {
            const alert = {
                id: 'a2',
                tipo: 'ARRIBO',
                estado: 'PENDIENTE',
                referenciaId: 'm1',
                referenciaTipo: 'MAREA',
                metadata: {
                    sources: [{ name: 'TRACKING_CSV' }] // Only 1 source
                }
            };
            const marea = { id: 'm1', estadoActual: { codigo: 'EN_EJECUCION' } };

            mockPrisma.alerta.findUnique.mockResolvedValue(alert);
            mockPrisma.marea.findUnique.mockResolvedValue(marea);

            const result = await service.processAlertAutomation('a2');

            expect(mockMareasService.executeAction).not.toHaveBeenCalled();
            expect(result).toEqual({ status: 'SKIPPED', reason: 'Fuentes insuficientes (< 2)' });
        });

        it('should process ARRIBO with multiple sources', async () => {
            const alert = {
                id: 'a3',
                tipo: 'ARRIBO',
                estado: 'PENDIENTE',
                fechaDetectada: new Date(),
                referenciaId: 'm1',
                referenciaTipo: 'MAREA',
                metadata: {
                    sources: [{ name: 'TRACKING_CSV' }, { name: 'API_PNA' }] // 2 sources
                }
            };
            const marea = {
                id: 'm1',
                estadoActual: { codigo: 'EN_EJECUCION' },
                etapas: [{ nroEtapa: 1 }]
            };

            mockPrisma.alerta.findUnique.mockResolvedValue(alert);
            mockPrisma.marea.findUnique.mockResolvedValue(marea);

            const result = await service.processAlertAutomation('a3');

            expect(mockMareasService.executeAction).toHaveBeenCalled();
            expect(result.status).toBe('CONFIRMED');
        });

        it('should create a NEW STAGE for EN_EJECUCION tide when last stage is finished', async () => {
            const alert = {
                id: 'a4',
                tipo: 'ZARPADA',
                estado: 'PENDIENTE',
                fechaDetectada: new Date(),
                referenciaId: 'm1',
                referenciaTipo: 'MAREA',
                metadata: {
                    sources: [{ name: 'TRACKING_CSV' }, { name: 'API_PNA' }]
                }
            };
            const marea = {
                id: 'm1',
                estadoActual: { codigo: 'EN_EJECUCION' },
                fechaInicioObservador: new Date('2024-01-01'),
                etapas: [{
                    id: 's1',
                    nroEtapa: 1,
                    fechaZarpada: new Date('2024-01-01'),
                    fechaArribo: new Date('2024-01-05') // Terminado
                }]
            };

            mockPrisma.alerta.findUnique.mockResolvedValue(alert);
            mockPrisma.marea.findUnique.mockResolvedValue(marea);

            const result = await service.processAlertAutomation('a4');

            expect(mockMareasService.executeAction).toHaveBeenCalledWith(
                'm1',
                'EDITAR_ETAPAS',
                mockSystemUser,
                expect.objectContaining({
                    etapas: expect.arrayContaining([
                        expect.objectContaining({ id: 's1' }), // Mantiene la existente
                        expect.objectContaining({ nroEtapa: 2 }) // Añade la nueva
                    ])
                })
            );
            expect(result.status).toBe('CONFIRMED');
        });
    });

    describe('processBatch', () => {
        it('should include RECOMENDACION_FIN_MAREA in query and return details', async () => {
            mockPrisma.alerta.findMany.mockResolvedValue([]);

            const result = await service.processBatch();

            expect(mockPrisma.alerta.findMany).toHaveBeenCalledWith(expect.objectContaining({
                where: expect.objectContaining({
                    tipo: { in: expect.arrayContaining(['RECOMENDACION_FIN_MAREA', 'POSIBLE_ZARPADA']) }
                })
            }));

            expect(result).toHaveProperty('details');
            expect(result.details).toEqual([]);
        });
    });
});
