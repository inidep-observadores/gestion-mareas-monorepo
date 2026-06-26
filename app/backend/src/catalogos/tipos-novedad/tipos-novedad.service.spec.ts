import { Test, TestingModule } from '@nestjs/testing';
import { TiposNovedadService } from './tipos-novedad.service';

describe('TiposNovedadService', () => {
  let service: TiposNovedadService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TiposNovedadService],
    }).compile();

    service = module.get<TiposNovedadService>(TiposNovedadService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
