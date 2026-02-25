import { Test, TestingModule } from '@nestjs/testing';
import { PlanificacionService } from './planificacion.service';
import { PrismaService } from '../prisma/prisma.service';

describe('PlanificacionService', () => {
  let service: PlanificacionService;
  let prisma: PrismaService;

  const mockPrisma = {
    requerimientoCobertura: {
      findMany: jest.fn(),
      deleteMany: jest.fn(),
      createMany: jest.fn(),
    },
    $transaction: jest.fn((cb) => cb(mockPrisma)),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PlanificacionService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<PlanificacionService>(PlanificacionService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getRequerimientosPorAnio', () => {
    it('debe llamar a findMany con los filtros correctos (año y cantidad > 0)', async () => {
      const anio = 2025;
      mockPrisma.requerimientoCobertura.findMany.mockResolvedValue([]);

      await service.getRequerimientosPorAnio(anio);

      expect(mockPrisma.requerimientoCobertura.findMany).toHaveBeenCalledWith({
        where: {
          anioOperativo: anio,
          cantidad: { gt: 0 },
        },
        include: {
          pesqueria: { select: { id: true, nombre: true } },
          tipoFlota: { select: { id: true, nombre: true } },
        },
      });
    });
  });

  describe('upsertRequerimientosBatch', () => {
    it('debe limpiar los registros previos y crear los nuevos en una transacción', async () => {
      const dto = {
        anioOperativo: 2025,
        requerimientos: [
          { mes: 1, cantidad: 5, pesqueriaId: 'p1', tipoFlotaId: 'f1', anioOperativo: 2025 },
          { mes: 2, cantidad: 0, pesqueriaId: 'p2', tipoFlotaId: 'f2', anioOperativo: 2025 }, // Debe filtrarse
        ],
      };

      mockPrisma.requerimientoCobertura.deleteMany.mockResolvedValue({ count: 1 });
      mockPrisma.requerimientoCobertura.createMany.mockResolvedValue({ count: 1 });

      const result = await service.upsertRequerimientosBatch(dto);

      expect(mockPrisma.$transaction).toHaveBeenCalled();
      expect(mockPrisma.requerimientoCobertura.deleteMany).toHaveBeenCalledWith({
        where: { anioOperativo: 2025 },
      });
      // Solo el que tiene cantidad > 0 debe persistirse
      expect(mockPrisma.requerimientoCobertura.createMany).toHaveBeenCalledWith({
        data: [
          {
            anioOperativo: 2025,
            mes: 1,
            cantidad: 5,
            pesqueriaId: 'p1',
            tipoFlotaId: 'f1',
          },
        ],
        skipDuplicates: true,
      });
      expect(result.count).toBe(1);
    });

    it('debe retornar count 0 y no insertar si no hay requerimientos activos', async () => {
      const dto = {
        anioOperativo: 2025,
        requerimientos: [
          { mes: 1, cantidad: 0, pesqueriaId: 'p1', tipoFlotaId: 'f1', anioOperativo: 2025 },
        ],
      };

      const result = await service.upsertRequerimientosBatch(dto);

      expect(mockPrisma.requerimientoCobertura.deleteMany).toHaveBeenCalled();
      expect(mockPrisma.requerimientoCobertura.createMany).not.toHaveBeenCalled();
      expect(result.count).toBe(0);
    });
  });
});
