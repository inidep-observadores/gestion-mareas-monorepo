import { Test, TestingModule } from '@nestjs/testing';
import { NovedadesController } from './novedades.controller';
import { NovedadesService } from './novedades.service';
import { User } from '@prisma/client';

describe('NovedadesController', () => {
  let controller: NovedadesController;
  let service: NovedadesService;

  const mockNovedadesService = {
    create: jest.fn(),
    findAll: jest.fn(),
    findOne: jest.fn(),
    update: jest.fn(),
    remove: jest.fn(),
  };

  const mockUser = { id: 'user1' } as User;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [NovedadesController],
      providers: [
        { provide: NovedadesService, useValue: mockNovedadesService },
      ],
    }).compile();

    controller = module.get<NovedadesController>(NovedadesController);
    service = module.get<NovedadesService>(NovedadesService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('create', () => {
    it('debe llamar a create en el servicio', async () => {
      const dto = { observadorId: '1', tipoNovedadId: '2', fechaInicio: '2025-01-01' };
      mockNovedadesService.create.mockResolvedValue({ id: 'nov1' });
      const res = await controller.create(dto, mockUser);
      expect(service.create).toHaveBeenCalledWith(dto, mockUser);
      expect(res).toEqual({ id: 'nov1' });
    });
  });

  describe('findAll', () => {
    it('debe llamar a findAll en el servicio con queries', async () => {
      mockNovedadesService.findAll.mockResolvedValue([]);
      await controller.findAll('obs1', 'APROBADA');
      expect(service.findAll).toHaveBeenCalledWith('obs1', 'APROBADA');
    });
  });

  describe('findOne', () => {
    it('debe llamar a findOne en el servicio', async () => {
      mockNovedadesService.findOne.mockResolvedValue({ id: 'nov1' });
      await controller.findOne('nov1');
      expect(service.findOne).toHaveBeenCalledWith('nov1');
    });
  });

  describe('update', () => {
    it('debe llamar a update en el servicio', async () => {
      const dto = { motivo: 'cambio' };
      mockNovedadesService.update.mockResolvedValue({ id: 'nov1' });
      await controller.update('nov1', dto, mockUser);
      expect(service.update).toHaveBeenCalledWith('nov1', dto, mockUser);
    });
  });

  describe('remove', () => {
    it('debe llamar a remove en el servicio', async () => {
      mockNovedadesService.remove.mockResolvedValue({ id: 'nov1', activo: false });
      await controller.remove('nov1', mockUser);
      expect(service.remove).toHaveBeenCalledWith('nov1', mockUser);
    });
  });
});
