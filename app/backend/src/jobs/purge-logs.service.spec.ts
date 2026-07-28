import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { PurgeLogsService } from './purge-logs.service';

describe('PurgeLogsService', () => {
  let service: PurgeLogsService;
  let configService: ConfigService;
  let prismaService: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PurgeLogsService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn(),
          },
        },
        {
          provide: PrismaService,
          useValue: {
            novedadesEmailLog: {
              deleteMany: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<PurgeLogsService>(PurgeLogsService);
    configService = module.get<ConfigService>(ConfigService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('purgeIgnoredEmails', () => {
    it('debe saltar la purga si EMAIL_LOGS_RETENTION_DAYS no está definido', async () => {
      // Arrange
      (configService.get as jest.Mock).mockReturnValue(undefined);

      // Act
      await service.purgeIgnoredEmails();

      // Assert
      expect(prismaService.novedadesEmailLog.deleteMany).not.toHaveBeenCalled();
    });

    it('debe saltar la purga si EMAIL_LOGS_RETENTION_DAYS es 0', async () => {
      // Arrange
      (configService.get as jest.Mock).mockReturnValue('0');

      // Act
      await service.purgeIgnoredEmails();

      // Assert
      expect(prismaService.novedadesEmailLog.deleteMany).not.toHaveBeenCalled();
    });

    it('debe ejecutar deleteMany con la fecha límite correcta si está configurado', async () => {
      // Arrange
      (configService.get as jest.Mock).mockReturnValue('90');
      (prismaService.novedadesEmailLog.deleteMany as jest.Mock).mockResolvedValue({ count: 5 });

      // Act
      await service.purgeIgnoredEmails();

      // Assert
      expect(prismaService.novedadesEmailLog.deleteMany).toHaveBeenCalledTimes(1);
      
      const callArgs = (prismaService.novedadesEmailLog.deleteMany as jest.Mock).mock.calls[0][0];
      expect(callArgs.where.estado).toEqual({ in: ['IGNORADO', 'SIN_NOVEDAD'] });
      expect(callArgs.where.fechaProcesamiento.lt).toBeInstanceOf(Date);
    });

    it('no debe arrojar error si deleteMany falla', async () => {
      // Arrange
      (configService.get as jest.Mock).mockReturnValue('30');
      (prismaService.novedadesEmailLog.deleteMany as jest.Mock).mockRejectedValue(new Error('DB Error'));

      // Act
      await expect(service.purgeIgnoredEmails()).resolves.not.toThrow();

      // Assert
      expect(prismaService.novedadesEmailLog.deleteMany).toHaveBeenCalledTimes(1);
    });
  });
});
