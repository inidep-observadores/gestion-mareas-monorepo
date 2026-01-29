
import { Test, TestingModule } from '@nestjs/testing';
import { AlertsService } from './alerts.service';
import { PrismaService } from '../prisma/prisma.service';
import { DateUtils } from '../common/utils/date.utils';
import { AlertaEstado, AlertaPrioridad } from './alerts.enums';

describe('AlertsService', () => {
    let service: AlertsService;
    let prisma: PrismaService;

    const mockPrisma = {
        alerta: {
            findUnique: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            findMany: jest.fn(),
        },
        alertaEvento: {
            create: jest.fn(),
        }
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AlertsService,
                { provide: PrismaService, useValue: mockPrisma },
            ],
        }).compile();

        service = module.get<AlertsService>(AlertsService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    describe('create', () => {
        it('should use DateUtils.getNow(true) for fechaDetectada', async () => {
            const fixedNow = new Date('2024-07-20T10:30:00Z');
            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            mockPrisma.alerta.findUnique.mockResolvedValue(null); // Not existing
            mockPrisma.alerta.create.mockResolvedValue({ id: 'alert-1' });

            const dto = {
                codigoUnico: 'alert-code',
                tipo: 'FATIGA',
                descripcion: 'Test alert',
                prioridad: AlertaPrioridad.ALTA,
                referenciaId: 'ref-1',
                origen: 'SYSTEM'
            };

            await service.create(dto as any);

            expect(getNowSpy).toHaveBeenCalledWith(true);
            expect(mockPrisma.alerta.create).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    fechaDetectada: fixedNow
                })
            }));

            getNowSpy.mockRestore();
        });
    });

    describe('update', () => {
        it('should use DateUtils.getNow(true) for fechaCierre when resolved', async () => {
            const fixedNow = new Date('2024-07-21T10:30:00Z');
            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            mockPrisma.alerta.findUnique.mockResolvedValue({ id: 'a1', estado: AlertaEstado.PENDIENTE });
            mockPrisma.alerta.update.mockResolvedValue({ id: 'a1' });

            await service.update('a1', { estado: AlertaEstado.RESUELTA, comment: 'Fixed' } as any, { id: 'u1' });

            expect(getNowSpy).toHaveBeenCalledWith(true);
            expect(mockPrisma.alerta.update).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    fechaCierre: fixedNow
                })
            }));

            getNowSpy.mockRestore();
        });
    });
});
