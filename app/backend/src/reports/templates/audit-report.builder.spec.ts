import { Test, TestingModule } from '@nestjs/testing';
import { AuditReportBuilder, AuditReportData } from './audit-report.builder';
import { DocxChartService } from '../docx/docx-charts';
import { Packer } from 'docx';

describe('AuditReportBuilder', () => {
  let builder: AuditReportBuilder;
  let chartService: DocxChartService;

  const mockChartService = {
    renderDoughnutChart: jest.fn().mockResolvedValue(Buffer.from('chart')),
    renderBarChart: jest.fn().mockResolvedValue(Buffer.from('chart')),
    renderHorizontalBarChart: jest.fn().mockResolvedValue(Buffer.from('chart')),
    renderLineChart: jest.fn().mockResolvedValue(Buffer.from('chart')),
    renderSigmaLogo: jest.fn().mockResolvedValue(Buffer.from('logo')),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuditReportBuilder,
        { provide: DocxChartService, useValue: mockChartService },
      ],
    }).compile();

    builder = module.get<AuditReportBuilder>(AuditReportBuilder);
    chartService = module.get<DocxChartService>(DocxChartService);

    // Mock Packer.toBuffer para evitar el procesamiento real pesado
    jest.spyOn(Packer, 'toBuffer').mockImplementation(() => Promise.resolve(Buffer.from('mock docx content')) as any);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(builder).toBeDefined();
  });

  describe('build', () => {
    it('should process data and return a buffer from Packer', async () => {
      const mockData: AuditReportData = {
        year: 2024,
        mode: 'CALENDAR',
        includeCampaigns: true,
        stats: {
          totalMareas: 5,
          totalDaysNavigated: 50,
          avgDaysPerMarea: 10,
          fisheries: [{ name: 'Langostino', mareas: 3, days: 30 }],
          fleets: [{ name: 'Costeros', mareas: 2, days: 20 }],
          observers: [{ id: '1', name: 'Juan Perez', mareas: 2, days: 20, active: true }],
        },
        dotacionActiva: 45,
        detailItems: [
          {
            id: 'm1',
            id_marea: '2024-001',
            anioMarea: 2024,
            buque: 'Don Pedro',
            flota: 'Costeros',
            pesqueria: 'Langostino',
            observador: 'Juan Perez',
            estado: 'Finalizada',
            diasCalendario: 10,
            diasTotales: 10,
            fechaInicio: new Date('2024-01-01'),
            fechaFin: new Date('2024-01-11'),
          }
        ],
        distribution: [{ mareaId: 'm1', id_marea: '2024-001', nroEtapa: 1 }],
      };

      const result = await builder.build(mockData);

      expect(Packer.toBuffer).toHaveBeenCalled();
      expect(result).toEqual(Buffer.from('mock docx content'));
    });

    it('should correctly preprocess data internally (tested via build)', async () => {
        const mockData: AuditReportData = {
          year: 2024,
          mode: 'TOTAL',
          includeCampaigns: false,
          stats: {
            totalMareas: 0,
            totalDaysNavigated: 0,
            avgDaysPerMarea: 0,
            fisheries: [],
            fleets: [],
            observers: [],
          },
          dotacionActiva: 0,
          detailItems: [],
          distribution: [],
        };
  
        const result = await builder.build(mockData);
        expect(result).toBeDefined();
    });
  });
});
