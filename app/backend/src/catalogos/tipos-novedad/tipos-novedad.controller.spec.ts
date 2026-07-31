import { Test, TestingModule } from '@nestjs/testing';
import { TiposNovedadController } from './tipos-novedad.controller';
import { TiposNovedadService } from './tipos-novedad.service';

describe('TiposNovedadController', () => {
  let controller: TiposNovedadController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TiposNovedadController],
      providers: [
        {
          provide: TiposNovedadService,
          useValue: {
            findAll: jest.fn(),
            findOne: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            remove: jest.fn(),
          },
        },
      ],
    }).compile();

    controller = module.get<TiposNovedadController>(TiposNovedadController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
