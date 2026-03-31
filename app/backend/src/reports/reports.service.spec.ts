import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from './reports.service';
import { StatsService } from '../stats/stats.service';
import { PrismaService } from '../prisma/prisma.service';
import { AuditReportBuilder } from './templates/audit-report.builder';

describe('ReportsService', () => {
  let service: ReportsService;
  let statsService: StatsService;
  let prismaService: PrismaService;
  let builder: AuditReportBuilder;

  const mockStatsService = {
    getDashboardStats: jest.fn(),
    getMareaDistribution: jest.fn(),
    getDashboardStatsDetail: jest.fn(),
  };

  const mockPrismaService = {
    observador: {
      count: jest.fn(),
    },
    marea: {
      findMany: jest.fn(),
    },
  };

  const mockAuditReportBuilder = {
    build: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportsService,
        { provide: StatsService, useValue: mockStatsService },
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AuditReportBuilder, useValue: mockAuditReportBuilder },
      ],
    }).compile();

    service = module.get<ReportsService>(ReportsService);
    statsService = module.get<StatsService>(StatsService);
    prismaService = module.get<PrismaService>(PrismaService);
    builder = module.get<AuditReportBuilder>(AuditReportBuilder);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('generateAuditReport', () => {
    it('should fetch all necessary data and call the builder', async () => {
      // Mock Data
      const mockStats = {
        totalMareas: 10,
        totalDaysNavigated: 100,
        fisheries: [],
        fleets: [],
        observers: [],
      };
      const mockDistribution = [{ mareaId: 'm1', id_marea: '2024-001', nroEtapa: 1 }];
      const mockDetails = [{ id: 'm1', id_marea: '2024-001', buque: 'Test', flota: 'Fleet', pesqueria: 'Fish', estado: 'Finalizada', diasCalendario: 10, diasTotales: 10 }];
      const mockDotacion = 50;
      const mockBuffer = Buffer.from('report content');

      mockStatsService.getDashboardStats.mockResolvedValue(mockStats);
      mockPrismaService.observador.count.mockResolvedValue(mockDotacion);
      mockPrismaService.marea.findMany.mockResolvedValue([]);
      mockStatsService.getMareaDistribution.mockResolvedValue(mockDistribution);
      mockStatsService.getDashboardStatsDetail.mockResolvedValue(mockDetails);
      mockAuditReportBuilder.build.mockResolvedValue(mockBuffer);

      const params = {
        year: 2024,
        mode: 'CALENDAR' as const,
        includeNonProtocolized: true,
      };

      const result = await service.generateAuditReport(params);

      // Verifications
      expect(statsService.getDashboardStats).toHaveBeenCalled();
      expect(prismaService.observador.count).toHaveBeenCalledWith({
        where: { activo: true, conImpedimento: false, tipoObservador: 'OBSERVADOR' }
      });
      expect(statsService.getMareaDistribution).toHaveBeenCalled();
      expect(statsService.getDashboardStatsDetail).toHaveBeenCalled();
      
      expect(builder.build).toHaveBeenCalledWith(expect.objectContaining({
        year: 2024,
        dotacionActiva: mockDotacion,
        stats: expect.objectContaining({
          totalMareas: 10,
          totalDaysNavigated: 100,
        }),
      }));

      expect(result).toBe(mockBuffer);
    });
  });
});
