import { Test, TestingModule } from '@nestjs/testing';
import { AuditController } from './audit.controller';
import { AuditService } from '../services/audit.service';
import { AuditQueryDto } from '../dto/audit-query.dto';
import { PassportModule } from '@nestjs/passport';

describe('AuditController', () => {
    let controller: AuditController;
    let service: AuditService;

    const mockAuditService = {
        findApiLogs: jest.fn().mockResolvedValue({ total: 0, data: [] }),
        findEntityLogs: jest.fn().mockResolvedValue({ total: 0, data: [] }),
        findEventLogs: jest.fn().mockResolvedValue({ total: 0, data: [] }),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            imports: [PassportModule.register({ defaultStrategy: 'jwt' })],
            controllers: [AuditController],
            providers: [
                { provide: AuditService, useValue: mockAuditService },
            ],
        }).compile();

        controller = module.get<AuditController>(AuditController);
        service = module.get<AuditService>(AuditService);
    });

    it('should be defined', () => {
        expect(controller).toBeDefined();
    });

    it('should call findApiLogs', async () => {
        const query = new AuditQueryDto();
        await controller.getApiLogs(query);
        expect(service.findApiLogs).toHaveBeenCalledWith(query);
    });

    it('should call findEntityLogs', async () => {
        const query = new AuditQueryDto();
        await controller.getEntityLogs(query);
        expect(service.findEntityLogs).toHaveBeenCalledWith(query);
    });

    it('should call findEventLogs', async () => {
        const query = new AuditQueryDto();
        await controller.getEventLogs(query);
        expect(service.findEventLogs).toHaveBeenCalledWith(query);
    });
});
