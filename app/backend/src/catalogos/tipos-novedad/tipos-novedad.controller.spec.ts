import { Test, TestingModule } from '@nestjs/testing';
import { TiposNovedadController } from './tipos-novedad.controller';

describe('TiposNovedadController', () => {
  let controller: TiposNovedadController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TiposNovedadController],
    }).compile();

    controller = module.get<TiposNovedadController>(TiposNovedadController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
