import { Test, TestingModule } from '@nestjs/testing';
import { TiposFlotaService } from './tipos-flota.service';
import { PrismaService } from '../../prisma/prisma.service';
import { NotFoundException, BadRequestException } from '@nestjs/common';

describe('TiposFlotaService', () => {
    let service: TiposFlotaService;
    let prisma: PrismaService;

    const mockPrismaService = {
        tipoFlota: {
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
                TiposFlotaService,
                { provide: PrismaService, useValue: mockPrismaService },
            ],
        }).compile();

        service = module.get<TiposFlotaService>(TiposFlotaService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    it('debe estar definido', () => {
        expect(service).toBeDefined();
    });

    describe('crear', () => {
        it('debe crear un tipo de flota', async () => {
            const dto = { codigo_numerico: 100, codigo: 'COD1', nombre: 'Test' };
            mockPrismaService.tipoFlota.create.mockResolvedValue({ id: 'uuid', ...dto });

            const result = await service.crear(dto);
            expect(result).toEqual({ id: 'uuid', ...dto });
            expect(prisma.tipoFlota.create).toHaveBeenCalledWith({ data: dto });
        });

        it('debe lanzar BadRequestException si el código ya existe', async () => {
            mockPrismaService.tipoFlota.create.mockRejectedValue({ code: 'P2002' });
            await expect(service.crear({ codigo_numerico: 200, codigo: 'EXISTS', nombre: 'Test' }))
                .rejects.toThrow(BadRequestException);
        });
    });

    describe('obtenerUno', () => {
        it('debe retornar un tipo de flota si existe', async () => {
            const tipoFlota = { id: 'uuid', codigo: 'COD1', nombre: 'Test' };
            mockPrismaService.tipoFlota.findUnique.mockResolvedValue(tipoFlota);

            const result = await service.obtenerUno('uuid');
            expect(result).toEqual(tipoFlota);
        });

        it('debe lanzar NotFoundException si no existe', async () => {
            mockPrismaService.tipoFlota.findUnique.mockResolvedValue(null);
            await expect(service.obtenerUno('non-existent'))
                .rejects.toThrow(NotFoundException);
        });
    });
});
