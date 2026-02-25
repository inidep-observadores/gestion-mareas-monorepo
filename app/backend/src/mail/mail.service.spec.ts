import { Test, TestingModule } from '@nestjs/testing';
import { MailService } from './mail.service';
import { MailerService } from '@nestjs-modules/mailer';
import { AuditService } from '../audit/services/audit.service';
import { AuditCategoria, AuditResultado } from '../audit/enums/audit.enums';

describe('MailService', () => {
    let service: MailService;
    let mailerService: MailerService;
    let auditService: AuditService;

    const mockMailerService = {
        sendMail: jest.fn(),
    };

    const mockAuditService = {
        logEvento: jest.fn(),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MailService,
                { provide: MailerService, useValue: mockMailerService },
                { provide: AuditService, useValue: mockAuditService },
            ],
        }).compile();

        service = module.get<MailService>(MailService);
        mailerService = module.get<MailerService>(MailerService);
        auditService = module.get<AuditService>(AuditService);
        jest.clearAllMocks();
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    it('should return true when mail is sent successfully', async () => {
        mockMailerService.sendMail.mockResolvedValueOnce({});
        const result = await service.sendMail('test@test.com', 'Subject', '<h1>Body</h1>');
        expect(result).toBe(true);
        expect(mockAuditService.logEvento).not.toHaveBeenCalled();
    });

    it('should return false and log audit event when mail fails', async () => {
        const error = new Error('SMTP Error');
        mockMailerService.sendMail.mockRejectedValueOnce(error);

        const result = await service.sendMail('test@test.com', 'Subject', '<h1>Body</h1>');

        expect(result).toBe(false);
        expect(mockAuditService.logEvento).toHaveBeenCalledWith(expect.objectContaining({
            tipoEvento: 'ERROR_ENVIO_EMAIL',
            categoria: AuditCategoria.SISTEMA,
            resultado: AuditResultado.ERROR,
            metadata: expect.objectContaining({
                error: 'SMTP Error',
                destinatario: 'test@test.com'
            })
        }));
    });
});
