import { Test, TestingModule } from '@nestjs/testing';
import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';
import { Response } from 'express';

describe('ReportsController', () => {
  let controller: ReportsController;
  let service: ReportsService;

  const mockReportsService = {
    generateAuditReport: jest.fn(),
  };

  const mockResponse = {
    setHeader: jest.fn(),
    send: jest.fn(),
  } as unknown as Response;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ReportsController],
      providers: [
        {
          provide: ReportsService,
          useValue: mockReportsService,
        },
      ],
    }).compile();

    controller = module.get<ReportsController>(ReportsController);
    service = module.get<ReportsService>(ReportsService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('getAuditReport', () => {
    it('should call reportsService.generateAuditReport with correct parameters', async () => {
      const mockBuffer = Buffer.from('test buffer');
      mockReportsService.generateAuditReport.mockResolvedValue(mockBuffer);

      const query = {
        year: '2024',
        mode: 'CALENDAR',
        includeNonProtocolized: 'true',
        includeProtocolizedOutOfPeriod: 'false',
        includeCampaigns: 'true',
      };

      await controller.getAuditReport(mockResponse, query as any);

      expect(service.generateAuditReport).toHaveBeenCalledWith({
        year: 2024,
        mode: 'CALENDAR',
        includeNonProtocolized: true,
        includeProtocolizedOutOfPeriod: false,
        includeCampaigns: true,
        startDate: undefined,
        endDate: undefined,
        protocolizationStartDate: undefined,
        protocolizationEndDate: undefined,
      });

      expect(mockResponse.setHeader).toHaveBeenCalledWith(
        'Content-Type',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      );
      expect(mockResponse.send).toHaveBeenCalledWith(mockBuffer);
    });

    it('should use custom filename if provided', async () => {
      mockReportsService.generateAuditReport.mockResolvedValue(Buffer.from(''));
      
      const query = {
        year: '2024',
        customFilename: 'Custom_Report',
      };

      await controller.getAuditReport(mockResponse, query as any);

      expect(mockResponse.setHeader).toHaveBeenCalledWith(
        'Content-Disposition',
        'attachment; filename=Custom_Report.docx',
      );
    });
  });
});
