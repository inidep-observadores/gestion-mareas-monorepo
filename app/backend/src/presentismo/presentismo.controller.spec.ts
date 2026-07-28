import { Test, TestingModule } from '@nestjs/testing';
import { PresentismoController } from './presentismo.controller';
import { PresentismoService } from './presentismo.service';
import { BadRequestException } from '@nestjs/common';
import { Response } from 'express';

describe('PresentismoController', () => {
  let controller: PresentismoController;
  let service: PresentismoService;

  const mockPresentismoService = {
    obtenerPlanillaMensual: jest.fn(),
    exportToExcel: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PresentismoController],
      providers: [
        { provide: PresentismoService, useValue: mockPresentismoService },
      ],
    }).compile();

    controller = module.get<PresentismoController>(PresentismoController);
    service = module.get<PresentismoService>(PresentismoService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('obtenerPlanillaMensual', () => {
    it('debe llamar a obtenerPlanillaMensual con defaults si no hay query', async () => {
      const expectedYear = new Date().getFullYear();
      const expectedMonth = new Date().getMonth() + 1;
      mockPresentismoService.obtenerPlanillaMensual.mockResolvedValue({});
      
      await controller.obtenerPlanillaMensual();
      
      expect(service.obtenerPlanillaMensual).toHaveBeenCalledWith(expectedYear, expectedMonth);
    });

    it('debe llamar a obtenerPlanillaMensual con queries parseadas', async () => {
      mockPresentismoService.obtenerPlanillaMensual.mockResolvedValue({});
      await controller.obtenerPlanillaMensual('2025', '12');
      expect(service.obtenerPlanillaMensual).toHaveBeenCalledWith(2025, 12);
    });

    it('debe lanzar BadRequestException si mes es invalido', async () => {
      await expect(controller.obtenerPlanillaMensual('2025', '13')).rejects.toThrow(BadRequestException);
      await expect(controller.obtenerPlanillaMensual('2025', 'abc')).rejects.toThrow(BadRequestException);
    });
  });

  describe('exportToExcel', () => {
    it('debe lanzar BadRequestException si falta anio o mes en el body', async () => {
      const mockRes = {} as Response;
      await expect(controller.exportToExcel({ year: 2025 } as any, mockRes)).rejects.toThrow(BadRequestException);
    });

    it('debe escribir en el response el excel generado', async () => {
      const mockWorkbook = {
        xlsx: { write: jest.fn().mockResolvedValue(true) }
      };
      mockPresentismoService.exportToExcel.mockResolvedValue(mockWorkbook);
      
      const mockRes = {
        setHeader: jest.fn(),
        end: jest.fn(),
      } as unknown as Response;

      await controller.exportToExcel({ year: 2025, month: 1, ids: ['1'] }, mockRes);
      
      expect(service.exportToExcel).toHaveBeenCalledWith(2025, 1, ['1']);
      expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      expect(mockRes.setHeader).toHaveBeenCalledWith('Content-Disposition', expect.stringContaining('PRESENTISMO_2025_01.xlsx'));
      expect(mockWorkbook.xlsx.write).toHaveBeenCalledWith(mockRes);
      expect(mockRes.end).toHaveBeenCalled();
    });
  });
});
