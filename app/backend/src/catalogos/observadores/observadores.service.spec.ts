import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { ObservadoresService } from './observadores.service';
import { PrismaService } from '../../prisma/prisma.service';
import { BadRequestException, NotFoundException } from '@nestjs/common';

describe('ObservadoresService', () => {
    let service: ObservadoresService;
    let prisma: PrismaService;

    const mockPrisma = {
        observador: {
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
                ObservadoresService,
                { provide: PrismaService, useValue: mockPrisma },
            ],
        }).compile();

        service = module.get<ObservadoresService>(ObservadoresService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    describe('crear', () => {
        it('debería convertir un email vacío en null', async () => {
            const dto = {
                codigoInterno: 1,
                nombre: 'Juan',
                apellido: 'Perez',
                tipoObservador: 'OBSERVADOR',
                tipoContrato: 'LEY MARCO',
                email: '   ' // espacios en blanco
            } as any;

            mockPrisma.observador.create.mockResolvedValue({ id: 'uuid', ...dto });

            await service.crear(dto);

            expect(mockPrisma.observador.create).toHaveBeenCalledWith({
                data: expect.objectContaining({
                    email: null
                })
            });
        });

        it('debería lanzar error si está disponible y tiene impedimento', async () => {
            const dto = {
                disponible: true,
                conImpedimento: true,
            } as any;

            await expect(service.crear(dto)).rejects.toThrow(BadRequestException);
        });
    });

    describe('actualizar', () => {
        it('debería convertir un email vacío en null al actualizar', async () => {
            const id = 'uuid-1';
            const dto = { email: '' };

            mockPrisma.observador.findUnique.mockResolvedValue({ id, email: 'viejo@test.com' });
            mockPrisma.observador.update.mockResolvedValue({ id, email: null });

            await service.actualizar(id, dto as any);

            expect(mockPrisma.observador.update).toHaveBeenCalledWith({
                where: { id },
                data: expect.objectContaining({
                    email: null
                })
            });
        });

        it('debería lanzar NotFoundException si el observador no existe', async () => {
            mockPrisma.observador.findUnique.mockResolvedValue(null);
            await expect(service.actualizar('id-inexistente', {})).rejects.toThrow(NotFoundException);
        });
    });
});
