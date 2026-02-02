import { Test, TestingModule } from '@nestjs/testing';
import { AuditQueueProcessor } from './audit.processor';
import { PrismaService } from '../../prisma/prisma.service';
import { Job } from 'bull';

describe('AuditQueueProcessor', () => {
    let processor: AuditQueueProcessor;
    let prisma: PrismaService;

    const mockPrismaService = {
        auditoriaApi: { create: jest.fn() },
        auditoriaEvento: { create: jest.fn() },
        auditoriaEntidad: { create: jest.fn() }
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AuditQueueProcessor,
                { provide: PrismaService, useValue: mockPrismaService }
            ],
        }).compile();

        processor = module.get<AuditQueueProcessor>(AuditQueueProcessor);
        prisma = module.get<PrismaService>(PrismaService);
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    it('should be defined', () => {
        expect(processor).toBeDefined();
    });

    describe('handleLogApi', () => {
        it('should create auditoriaApi record via Prisma', async () => {
            const job = { data: { ruta: '/test', metodo: 'GET' } } as Job;
            await processor.handleLogApi(job);
            expect(mockPrismaService.auditoriaApi.create).toHaveBeenCalledWith({
                data: job.data
            });
        });

        it('should throw error if prisma fails (triggering Bull retry)', async () => {
            const loggerSpy = jest.spyOn((processor as any).logger, 'error').mockImplementation(() => { });
            mockPrismaService.auditoriaApi.create.mockRejectedValue(new Error('DB Error'));
            const job = { data: {} } as Job;
            await expect(processor.handleLogApi(job)).rejects.toThrow('DB Error');
            loggerSpy.mockRestore();
        });
    });

    describe('handleLogEvento', () => {
        it('should create auditoriaEvento record', async () => {
            const job = { data: { tipoEvento: 'TEST' } } as Job;
            await processor.handleLogEvento(job);
            expect(mockPrismaService.auditoriaEvento.create).toHaveBeenCalled();
        });
    });

    describe('handleLogEntidad', () => {
        it('should create auditoriaEntidad record', async () => {
            const job = { data: { entidadTipo: 'User' } } as Job;
            await processor.handleLogEntidad(job);
            expect(mockPrismaService.auditoriaEntidad.create).toHaveBeenCalled();
        });
    });
});
