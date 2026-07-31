import { Test, TestingModule } from '@nestjs/testing';
import { TiposNovedadService } from './tipos-novedad.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('TiposNovedadService', () => {
  let service: TiposNovedadService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TiposNovedadService,
        {
          provide: PrismaService,
          useValue: {
            tipoNovedad: {
              findMany: jest.fn(),
              findUnique: jest.fn(),
              create: jest.fn(),
              update: jest.fn(),
              delete: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<TiposNovedadService>(TiposNovedadService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
