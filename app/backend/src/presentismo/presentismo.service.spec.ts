import { Test, TestingModule } from '@nestjs/testing';
import { PresentismoService } from './presentismo.service';
import { PrismaService } from '../prisma/prisma.service';

describe('PresentismoService', () => {
  let service: PresentismoService;
  let prisma: PrismaService;

  const mockPrismaService = {
    observador: {
      findMany: jest.fn(),
    },
    feriado: {
      findMany: jest.fn(),
    },
    observadorNovedad: {
      findMany: jest.fn(),
    },
    marea: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PresentismoService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<PresentismoService>(PresentismoService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('obtenerPlanillaMensual', () => {
    it('debe retornar la planilla con todos los dias libres si no hay datos', async () => {
      mockPrismaService.observador.findMany.mockResolvedValue([{ id: 'obs1', nombre: 'Juan' }]);
      mockPrismaService.feriado.findMany.mockResolvedValue([]);
      mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
      mockPrismaService.marea.findMany.mockResolvedValue([]);

      const result = await service.obtenerPlanillaMensual(2025, 1);
      
      expect(result.year).toBe(2025);
      expect(result.month).toBe(1);
      expect(result.matriz).toHaveLength(1);
      expect(result.matriz[0].observador.id).toBe('obs1');
      // Todos los días del mes pasado deben ser LIBRES (enero 2025 tiene 31 dias)
      // Como estamos en un año futuro al que probamos (ej. 2026 actual es mayor a 2025), se calculan todos
      expect(Object.keys(result.matriz[0].dias).length).toBe(31);
    });

    it('debe identificar feriados y fines de semana', async () => {
      mockPrismaService.observador.findMany.mockResolvedValue([{ id: 'obs1', nombre: 'Juan' }]);
      // 1 de enero 2025 (Miercoles)
      mockPrismaService.feriado.findMany.mockResolvedValue([{ fecha: new Date('2025-01-01T00:00:00Z'), nombre: 'Año Nuevo' }]);
      mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
      mockPrismaService.marea.findMany.mockResolvedValue([]);

      const result = await service.obtenerPlanillaMensual(2025, 1);
      
      expect(result.matriz[0].dias[1].estado).toBe('FERIADO');
      // 4 y 5 de Enero de 2025 fueron fin de semana
      expect(result.matriz[0].dias[4].estado).toBe('FIN_SEMANA');
      expect(result.matriz[0].dias[5].estado).toBe('FIN_SEMANA');
    });

    it('debe identificar novedades', async () => {
      mockPrismaService.observador.findMany.mockResolvedValue([{ id: 'obs1', nombre: 'Juan' }]);
      mockPrismaService.feriado.findMany.mockResolvedValue([]);
      mockPrismaService.observadorNovedad.findMany.mockResolvedValue([{
        observadorId: 'obs1',
        fechaInicio: new Date('2025-01-10T00:00:00Z'),
        fechaFin: new Date('2025-01-12T23:59:59Z'),
        tipoNovedad: { afectaPresentismo: true, codigo: 'LICENCIA', descripcion: 'Licencia' }
      }]);
      mockPrismaService.marea.findMany.mockResolvedValue([]);

      const result = await service.obtenerPlanillaMensual(2025, 1);
      
      expect(result.matriz[0].dias[10].estado).toBe('NOVEDAD');
      expect(result.matriz[0].dias[11].estado).toBe('NOVEDAD');
      expect(result.matriz[0].dias[12].estado).toBe('NOVEDAD');
      expect(result.matriz[0].totales.novedades).toBeGreaterThan(0);
    });
  });

  describe('exportToExcel', () => {
    it('debe generar un workbook de Excel', async () => {
      mockPrismaService.observador.findMany.mockResolvedValue([{ id: 'obs1', nombre: 'Juan' }]);
      mockPrismaService.feriado.findMany.mockResolvedValue([]);
      mockPrismaService.observadorNovedad.findMany.mockResolvedValue([]);
      mockPrismaService.marea.findMany.mockResolvedValue([]);

      const workbook = await service.exportToExcel(2025, 1);
      
      expect(workbook).toBeDefined();
      expect(workbook.worksheets.length).toBeGreaterThan(0);
    });
  });
});
