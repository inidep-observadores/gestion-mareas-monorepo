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

    systemStatus: {
      findUnique: jest.fn(),
      upsert: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },

    user: {
      findUnique: jest.fn().mockResolvedValue({ id: 'u1', fullName: 'Test User' }),
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

  describe('Pessimistic Locking (Simulador)', () => {
    beforeEach(() => {
      jest.useFakeTimers();
      jest.setSystemTime(new Date('2026-10-03T12:00:00Z'));
    });

    afterEach(() => {
      jest.useRealTimers();
    });

    it('debe adquirir el lock si está libre', async () => {
      mockPrisma.systemStatus.findUnique.mockResolvedValue(null);
      mockPrisma.systemStatus.upsert.mockResolvedValue({});

      const result = await service.adquirirLock('esc1', 'user1', 'Juan', 'tab1');
      
      expect(result.success).toBe(true);
      expect(mockPrisma.systemStatus.upsert).toHaveBeenCalled();
    });

    it('debe renovar el lock si pertenece al mismo usuario y tab', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });
      mockPrisma.systemStatus.update.mockResolvedValue({});

      const result = await service.adquirirLock('esc1', 'user1', 'Juan', 'tab1');
      
      expect(result.success).toBe(true);
      expect(mockPrisma.systemStatus.update).toHaveBeenCalled();
    });

    it('debe robar el lock si expiró por inactividad (> 2 mins)', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 3 * 60000), // Hace 3 minutos
      });
      mockPrisma.systemStatus.upsert.mockResolvedValue({});

      const result = await service.adquirirLock('esc1', 'user2', 'Maria', 'tab2');
      
      expect(result.success).toBe(true);
      expect(mockPrisma.systemStatus.upsert).toHaveBeenCalled();
    });

    it('debe rechazar adquirir el lock si está en uso por otro', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });

      const result = await service.adquirirLock('esc1', 'user2', 'Maria', 'tab2');
      
      expect(result.success).toBe(false);
      expect(result.lockedBy).toBe('Juan');
    });

    it('validateLockForUpdate debe lanzar NotFoundException si pertenece a otro', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });

      await expect(service.validateLockForUpdate('esc1', 'user2', 'tab2')).rejects.toThrow(
        'El escenario está siendo modificado por Juan.'
      );
    });

    it('validateLockForUpdate no debe lanzar error si el lock pertenece al usuario', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });

      await expect(service.validateLockForUpdate('esc1', 'user1', 'tab1')).resolves.not.toThrow();
    });
  });

});
