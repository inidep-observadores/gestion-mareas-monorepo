import { Test, TestingModule } from '@nestjs/testing';
import { NovedadesService } from './novedades.service';
import { PrismaService } from '../../prisma/prisma.service';
import { DriveStorageService } from '../../files/drive-storage.service';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { User } from '@prisma/client';

describe('NovedadesService', () => {
  let service: NovedadesService;
  let prisma: PrismaService;

  const mockPrismaService = {
    observadorNovedad: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    observador: {
      findUnique: jest.fn(),
    },
    tipoNovedad: {
      findUnique: jest.fn(),
    },
    marea: {
      findMany: jest.fn(),
      update: jest.fn(),
    },
  };

  const mockUser = { id: 'u1' } as User;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NovedadesService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: DriveStorageService, useValue: {} },
      ],
    }).compile();

    service = module.get<NovedadesService>(NovedadesService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findAll', () => {
    it('debe retornar novedades activas y filtrar por observador y estado', async () => {
      mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
      
      await service.findAll('obs1', 'APROBADA');
      
      expect(prisma.observadorNovedad.findMany).toHaveBeenCalledWith(expect.objectContaining({
        where: { observadorId: 'obs1', estadoAprobacion: 'APROBADA' }
      }));
    });
  });

  describe('findOne', () => {
    it('debe lanzar NotFoundException si no existe o no esta activa', async () => {
      mockPrismaService.observadorNovedad.findUnique.mockResolvedValue(null);
      await expect(service.findOne('id')).rejects.toThrow(NotFoundException);

      mockPrismaService.observadorNovedad.findUnique.mockResolvedValue({ activo: false });
      await expect(service.findOne('id')).rejects.toThrow(NotFoundException);
    });

    it('debe retornar la novedad si existe y esta activa', async () => {
      const mockNov = { id: 'nov1', activo: true };
      mockPrismaService.observadorNovedad.findUnique.mockResolvedValue(mockNov);
      const res = await service.findOne('nov1');
      expect(res).toEqual(mockNov);
    });
  });

  describe('create', () => {
    it('debe lanzar NotFoundException si el observador no existe', async () => {
      mockPrismaService.observador.findUnique.mockResolvedValue(null);
      await expect(service.create({ observadorId: '1', tipoNovedadId: '2', fechaInicio: '2025-01-01' }))
        .rejects.toThrow(NotFoundException);
    });

    it('debe lanzar BadRequestException si el tipo de novedad no esta activo', async () => {
      mockPrismaService.observador.findUnique.mockResolvedValue({ id: '1' });
      mockPrismaService.tipoNovedad.findUnique.mockResolvedValue({ id: '2', activo: false });
      await expect(service.create({ observadorId: '1', tipoNovedadId: '2', fechaInicio: '2025-01-01' }))
        .rejects.toThrow(BadRequestException);
    });

    it('debe lanzar BadRequestException si hay solapamiento de fechas', async () => {
      mockPrismaService.observador.findUnique.mockResolvedValue({ id: '1' });
      mockPrismaService.tipoNovedad.findUnique.mockResolvedValue({ id: '2', activo: true });
      mockPrismaService.observadorNovedad.findFirst.mockResolvedValue({ id: 'nov-solapada' });

      await expect(service.create({ observadorId: '1', tipoNovedadId: '2', fechaInicio: '2025-01-01' }))
        .rejects.toThrow(BadRequestException);
    });

    it('debe crear la novedad y auto-cerrar si es VIAJE_INICIO', async () => {
      mockPrismaService.observador.findUnique.mockResolvedValue({ id: '1' });
      mockPrismaService.tipoNovedad.findUnique.mockResolvedValue({ id: '2', activo: true, codigo: 'VIAJE_INICIO' });
      mockPrismaService.observadorNovedad.findFirst.mockResolvedValue(null);
      mockPrismaService.observadorNovedad.create.mockResolvedValue({ id: 'new-nov', estadoAprobacion: 'APROBADA', fechaInicio: new Date('2025-01-01T00:00:00Z'), tipoNovedad: { codigo: 'VIAJE_INICIO' } });
      mockPrismaService.marea.findMany.mockResolvedValue([]); // Para procesarAutoValidacionMarea

      const res = await service.create({ observadorId: '1', tipoNovedadId: '2', fechaInicio: '2025-01-01' }, mockUser);
      
      expect(prisma.observadorNovedad.create).toHaveBeenCalled();
      expect(res.id).toEqual('new-nov');
    });
  });

  describe('update', () => {
    it('debe lanzar BadRequestException si hay solapamiento al editar fechas', async () => {
      const existing = { id: 'nov1', observadorId: '1', tipoNovedadId: '2', fechaInicio: new Date('2025-01-01'), activo: true, tipoNovedad: { codigo: 'OTRA' } };
      jest.spyOn(service, 'findOne').mockResolvedValue(existing as any);
      mockPrismaService.observadorNovedad.findFirst.mockResolvedValue({ id: 'solapamiento' });

      await expect(service.update('nov1', { fechaInicio: '2025-01-02' })).rejects.toThrow(BadRequestException);
    });

    it('debe actualizar la novedad correctamente', async () => {
      const existing = { id: 'nov1', observadorId: '1', tipoNovedadId: '2', fechaInicio: new Date('2025-01-01'), activo: true, tipoNovedad: { codigo: 'OTRA' } };
      jest.spyOn(service, 'findOne').mockResolvedValue(existing as any);
      mockPrismaService.observadorNovedad.findFirst.mockResolvedValue(null);
      mockPrismaService.observadorNovedad.update.mockResolvedValue({ id: 'nov1', estadoAprobacion: 'APROBADA' });
      mockPrismaService.marea.findMany.mockResolvedValue([]); 

      const res = await service.update('nov1', { estadoAprobacion: 'APROBADA' }, mockUser);
      expect(prisma.observadorNovedad.update).toHaveBeenCalled();
      expect(res.id).toEqual('nov1');
    });
  });

  describe('remove', () => {
    it('debe hacer un borrado logico', async () => {
      const existing = { id: 'nov1', estadoAprobacion: 'APROBADA' };
      jest.spyOn(service, 'findOne').mockResolvedValue(existing as any);
      mockPrismaService.observadorNovedad.update.mockResolvedValue({ id: 'nov1', activo: false });

      await service.remove('nov1', mockUser);
      expect(prisma.observadorNovedad.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: 'nov1' },
        data: expect.objectContaining({ activo: false })
      }));
    });
  });
});
