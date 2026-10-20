import { Test, TestingModule } from '@nestjs/testing';
import { BuquesService } from './buques.service';
import { PrismaService } from '../../prisma/prisma.service';
import { NotFoundException } from '@nestjs/common';

describe('BuquesService', () => {
    let service: BuquesService;
    let prisma: PrismaService;

    const mockPrismaService = {
        buque: {
            create: jest.fn(),
            findMany: jest.fn(),
            findUnique: jest.fn(),
            update: jest.fn(),
            delete: jest.fn(),
        },
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                BuquesService,
                { provide: PrismaService, useValue: mockPrismaService },
            ],
        }).compile();

        service = module.get<BuquesService>(BuquesService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    it('debe estar definido', () => {
        expect(service).toBeDefined();
    });

    describe('crear', () => {
        it('debe crear un buque', async () => {
            const dto = { nombreBuque: 'Test', matricula: 'MAT1', calificacion: 3 };
            mockPrismaService.buque.create.mockResolvedValue({ id: 'uuid', ...dto });

            const result = await service.crear(dto as any);
            expect(result).toEqual({ id: 'uuid', ...dto });
            expect(prisma.buque.create).toHaveBeenCalledWith({ data: dto });
        });

        it('debe lanzar BadRequestException si la calificacion es menor a 3 y no tiene observaciones', async () => {
            const dto = { nombreBuque: 'Test', matricula: 'MAT1', calificacion: 2, observaciones: '' };
            await expect(service.crear(dto as any)).rejects.toThrow('Para buques con calificación menor a 3 estrellas, es obligatorio ingresar un detalle en Observaciones');
        });

        it('debe permitir crear un buque con calificacion menor a 3 si tiene observaciones', async () => {
            const dto = { nombreBuque: 'Test', matricula: 'MAT1', calificacion: 1, observaciones: 'Problemas de habitabilidad' };
            mockPrismaService.buque.create.mockResolvedValue({ id: 'uuid', ...dto });

            const result = await service.crear(dto as any);
            expect(result).toEqual({ id: 'uuid', ...dto });
        });
    });

    describe('obtenerUno', () => {
        it('debe retornar un buque con sus relaciones', async () => {
            const buque = { id: 'uuid', nombreBuque: 'Test' };
            mockPrismaService.buque.findUnique.mockResolvedValue(buque);

            const result = await service.obtenerUno('uuid');
            expect(result).toEqual(buque);
            expect(prisma.buque.findUnique).toHaveBeenCalledWith(expect.objectContaining({
                where: { id: 'uuid' },
                include: expect.any(Object)
            }));
        });

        it('debe lanzar NotFoundException si no existe', async () => {
            mockPrismaService.buque.findUnique.mockResolvedValue(null);
            await expect(service.obtenerUno('non-existent'))
                .rejects.toThrow(NotFoundException);
        });
    });
});
