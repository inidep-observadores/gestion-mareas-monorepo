import { Test, TestingModule } from '@nestjs/testing';
import { AlertAutomationService } from './alert-automation.service';
import { PrismaService } from '../prisma/prisma.service';
import { MareasService } from '../mareas/mareas.service';

describe('AlertAutomationService', () => {
    let service: AlertAutomationService;
    let prisma: any;
    let mareasService: any;

    const mockSystemUser = { id: 'admin-id', roles: ['admin'] };
    const fixedDate = new Date('2024-01-01T12:00:00Z');

    const mockPrisma = {
        alerta: { findUnique: jest.fn(), findMany: jest.fn(), update: jest.fn() },
        marea: { findUnique: jest.fn() },
        user: { findFirst: jest.fn() },
        alertaEvento: { create: jest.fn() }
    };

    const mockMareasService = { executeAction: jest.fn() };

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
        mareasService = module.get<MareasService>(MareasService);

        jest.resetAllMocks();

        // Default success mocks
        mockPrisma.user.findFirst.mockResolvedValue(mockSystemUser);
        mockPrisma.alertaEvento.create.mockResolvedValue({ id: 'ae-id' });
        mockPrisma.alerta.update.mockResolvedValue({ id: 'a-id' });
        mockMareasService.executeAction.mockResolvedValue(true);
    });

    describe('processAlertAutomation', () => {
        it('should return SKIPPED for non-pending alerts', async () => {
            mockPrisma.alerta.findUnique.mockResolvedValue({ id: 'a1', estado: 'RESUELTA' });
            const result = await service.processAlertAutomation('a1');
            expect(result.status).toBe('SKIPPED');
        });

        it('should process trusted RECOMENDACION_FIN_MAREA with single source', async () => {
            mockPrisma.alerta.findUnique.mockResolvedValue({
                id: 'a1', tipo: 'RECOMENDACION_FIN_MAREA', estado: 'PENDIENTE',
                fechaDetectada: fixedDate, referenciaId: 'm1', referenciaTipo: 'MAREA',
                metadata: { sources: [{ name: 'TRK' }] }
            });
            mockPrisma.marea.findUnique.mockResolvedValue({
                id: 'm1', estadoActual: { codigo: 'EN_EJECUCION' },
                etapas: [{ nroEtapa: 1, fechaArribo: null }]
            });

            const result = await service.processAlertAutomation('a1');
            expect(result.status).toBe('CONFIRMED');
            expect(mockMareasService.executeAction).toHaveBeenCalledWith(
                'm1', 'REGISTRAR_FINALIZACION', mockSystemUser, expect.anything()
            );
        });

        it('should skip standard ARRIBO with < 2 sources', async () => {
            mockPrisma.alerta.findUnique.mockResolvedValue({
                id: 'a1', tipo: 'ARRIBO', estado: 'PENDIENTE',
                fechaDetectada: fixedDate, referenciaId: 'm1', referenciaTipo: 'MAREA',
                metadata: { sources: [{ name: 'TRK' }] }
            });
            mockPrisma.marea.findUnique.mockResolvedValue({ id: 'm1', estadoActual: { codigo: 'EN_EJECUCION' } });

            const result = await service.processAlertAutomation('a1');
            expect(result.status).toBe('SKIPPED');
            expect(result.reason).toContain('Fuentes insuficientes');
        });

        it('should return ERROR if system user not found', async () => {
            mockPrisma.alerta.findUnique.mockResolvedValue({
                id: 'a1', estado: 'PENDIENTE', tipo: 'RECOMENDACION_FIN_MAREA',
                fechaDetectada: fixedDate, referenciaId: 'm1', referenciaTipo: 'MAREA',
                metadata: { sources: [{ name: 'TRK' }] }
            });
            mockPrisma.marea.findUnique.mockResolvedValue({ id: 'm1', estadoActual: { codigo: 'EN_EJECUCION' }, etapas: [{ nroEtapa: 1, fechaArribo: null }] });

            // Explicitly force null for this test
            mockPrisma.user.findFirst.mockResolvedValue(null);

            const result = await service.processAlertAutomation('a1');
            expect(result.status).toBe('ERROR');
            expect(result.reason).toBe('No se encontró usuario de sistema para ejecutar la acción');
        });

        it('should skip ZARPADA in EN_EJECUCION if last stage is NOT finished', async () => {
            mockPrisma.alerta.findUnique.mockResolvedValue({
                id: 'a1', tipo: 'ZARPADA', estado: 'PENDIENTE',
                fechaDetectada: fixedDate, referenciaId: 'm1', referenciaTipo: 'MAREA',
                metadata: { sources: [{ name: 'TRK' }, { name: 'PNA' }] }
            });
            mockPrisma.marea.findUnique.mockResolvedValue({
                id: 'm1', estadoActual: { codigo: 'EN_EJECUCION' },
                etapas: [{ id: 's1', nroEtapa: 1, fechaArribo: null }] // Not finished
            });

            const result = await service.processAlertAutomation('a1');
            expect(result.status).toBe('SKIPPED');
            expect(result.reason).toContain('no permite esta acción automática');
        });

        it('should handle batch processing errors gracefully', async () => {
            mockPrisma.alerta.findMany.mockResolvedValue([{ id: 'a1', titulo: 'Alerta 1' }]);
            mockPrisma.alerta.findUnique.mockRejectedValue(new Error('Batch Fail'));

            const result = await service.processBatch();
            expect(result.details[0].status).toBe('ERROR');
            expect(result.details[0].reason).toContain('Batch Fail');
        });
    });
});
