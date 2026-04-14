import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from './reports.service';
import { StatsService } from '../stats/stats.service';
import { PrismaService } from '../prisma/prisma.service';
import { AuditReportBuilder } from './templates/audit-report.builder';
import { ConversionService } from './conversion.service';

describe('ReportsService', () => {
  let service: ReportsService;
  let statsService: StatsService;
  let prismaService: PrismaService;
  let builder: AuditReportBuilder;
  let conversionService: ConversionService;

  const mockStatsService = {
    getDashboardStats: jest.fn(),
    getMareaDistribution: jest.fn(),
    getDashboardStatsDetail: jest.fn(),
    getSecondaryObserverStats: jest.fn(),
    getAuditSpecialCases: jest.fn(),
    getProtocolizationTimeline: jest.fn(),
  };
  const mockPrismaService = {
    observador: {
      count: jest.fn(),
      findMany: jest.fn(),
    },
    marea: {
      findMany: jest.fn(),
    },
    mareaMovimiento: {
      findMany: jest.fn(),
    },
    pesqueria: {
      findMany: jest.fn(),
    },
  };

  const mockConversionService = {
    convertDocxToPdf: jest.fn(),
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
        { provide: ConversionService, useValue: mockConversionService },
      ],
    }).compile();

    service = module.get<ReportsService>(ReportsService);
    statsService = module.get<StatsService>(StatsService);
    prismaService = module.get<PrismaService>(PrismaService);
    builder = module.get<AuditReportBuilder>(AuditReportBuilder);
    conversionService = module.get<ConversionService>(ConversionService);
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
      const mockDotacion = 1;
      const mockBuffer = Buffer.from('report content');

      mockStatsService.getDashboardStats.mockResolvedValue(mockStats);
      mockPrismaService.observador.findMany.mockResolvedValue([
        { id: '1', nombre: 'Juan', apellido: 'Perez' }
      ]);
      mockPrismaService.marea.findMany.mockResolvedValue([]);
      mockPrismaService.mareaMovimiento.findMany.mockResolvedValue([]);
      mockPrismaService.pesqueria.findMany.mockResolvedValue([]);
      mockStatsService.getMareaDistribution.mockResolvedValue(mockDistribution);
      mockStatsService.getDashboardStatsDetail.mockResolvedValue(mockDetails);
      mockStatsService.getSecondaryObserverStats.mockResolvedValue([]);
      mockStatsService.getAuditSpecialCases.mockResolvedValue({
        canceladas: [],
        desestimadas: [],
        esperandoEntrega: [],
        pendientesDeInforme: [],
        delegadasExternas: [],
        informesPendientesEnvio: [],
        esperandoProtocolizacion: [],
      });
      mockStatsService.getProtocolizationTimeline.mockResolvedValue({
        totalProtocolizadas: 0,
        totalEnviadas: 0,
        totalEnPeriodo: 0,
        sinProtocolizar: 0,
        tipo: 'MONTHLY' as const,
        promedioDiasLatencia: null,
        maxDiasLatencia: null,
        promedioDiasLatenciaTramite: null,
        maxDiasLatenciaTramite: null,
        distribucionMensual: [],
        protocolizadasDetalle: [],
      });
      mockAuditReportBuilder.build.mockResolvedValue(mockBuffer);

      const params = {
        year: 2024,
        mode: 'CALENDAR' as const,
        includeNonProtocolized: true,
      };

      const result = await service.generateAuditReport(params);

      // Verifications
      expect(statsService.getDashboardStats).toHaveBeenCalled();
      expect(prismaService.observador.findMany).toHaveBeenCalled();
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
