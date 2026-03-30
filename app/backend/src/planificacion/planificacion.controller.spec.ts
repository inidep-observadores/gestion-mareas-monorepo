import { Test, TestingModule } from '@nestjs/testing';
import { PlanificacionController } from './planificacion.controller';
import { PlanificacionService } from './planificacion.service';
import { PrismaService } from '../prisma/prisma.service';

describe('PlanificacionController', () => {
  let controller: PlanificacionController;
  let service: PlanificacionService;

  const mockService = {
    getRequerimientosPorAnio: jest.fn(),
    upsertRequerimientosBatch: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PlanificacionController],
      providers: [
        {
          provide: PlanificacionService,
          useValue: mockService,
        },
      ],
    }).compile();

    controller = module.get<PlanificacionController>(PlanificacionController);
    service = module.get<PlanificacionService>(PlanificacionService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getRequerimientos', () => {
    it('debe llamar al servicio con el año proporcionado', async () => {
      const anio = 2025;
      mockService.getRequerimientosPorAnio.mockResolvedValue([]);
      
      const result = await controller.getRequerimientos(anio);
      
      expect(service.getRequerimientosPorAnio).toHaveBeenCalledWith(anio);
      expect(result).toEqual([]);
    });
  });

  describe('upsertRequerimientos', () => {
    it('debe llamar al servicio con el DTO proporcionado', async () => {
      const dto = { anioOperativo: 2025, requerimientos: [] };
      mockService.upsertRequerimientosBatch.mockResolvedValue({ count: 0 });
      
      const result = await controller.upsertRequerimientos(dto);
      
      expect(service.upsertRequerimientosBatch).toHaveBeenCalledWith(dto);
      expect(result.count).toBe(0);
    });
  });
});
