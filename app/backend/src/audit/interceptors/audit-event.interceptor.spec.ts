import { Test, TestingModule } from '@nestjs/testing';
import { AuditEventInterceptor } from './audit-event.interceptor';
import { AuditService } from '../services/audit.service';
import { Reflector } from '@nestjs/core';
import { ExecutionContext, CallHandler } from '@nestjs/common';
import { of, throwError } from 'rxjs';
import { AuditCategoria, AuditResultado } from '../enums/audit.enums';
import { AUDIT_EVENT_KEY } from '../decorators/audit-event.decorator';

describe('AuditEventInterceptor', () => {
    let interceptor: AuditEventInterceptor;
    let auditService: AuditService;
    let reflector: Reflector;

    const mockAuditService = {
        logEvento: jest.fn().mockResolvedValue(true)
    };

    const mockReflector = {
        get: jest.fn()
    };

    const mockExecutionContext = {
        getHandler: jest.fn().mockReturnValue({ name: 'testMethod' }),
        getArgs: jest.fn().mockReturnValue([]),
        getType: jest.fn().mockReturnValue('http'),
        switchToHttp: jest.fn().mockReturnValue({
            getRequest: jest.fn().mockReturnValue({ user: { id: 'u-1' }, ip: '127.0.0.1' })
        })
    };

    const mockCallHandler: CallHandler = {
        handle: jest.fn().mockReturnValue(of('success'))
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AuditEventInterceptor,
                { provide: AuditService, useValue: mockAuditService },
                { provide: Reflector, useValue: mockReflector }
            ]
        }).compile();

        interceptor = module.get<AuditEventInterceptor>(AuditEventInterceptor);
        auditService = module.get<AuditService>(AuditService);
        reflector = module.get<Reflector>(Reflector);

        jest.clearAllMocks();
    });

    it('should be defined', () => {
        expect(interceptor).toBeDefined();
    });

    it('should skip if no metadata is present', () => {
        mockReflector.get.mockReturnValue(undefined);

        interceptor.intercept(mockExecutionContext as unknown as ExecutionContext, mockCallHandler);

        expect(auditService.logEvento).not.toHaveBeenCalled();
    });

    it('should log event on success', (done) => {
        const metadata = {
            tipoEvento: 'TEST_EVENT',
            categoria: AuditCategoria.SISTEMA,
            descripcion: 'Test Description'
        };
        mockReflector.get.mockReturnValue(metadata);

        interceptor.intercept(mockExecutionContext as unknown as ExecutionContext, mockCallHandler).subscribe({
            next: (val) => {
                expect(val).toBe('success');
                expect(auditService.logEvento).toHaveBeenCalledWith(expect.objectContaining({
                    tipoEvento: 'TEST_EVENT',
                    categoria: AuditCategoria.SISTEMA,
                    resultado: AuditResultado.EXITO,
                    usuarioId: 'u-1',
                    ip: '127.0.0.1'
                }));
                done();
            }
        });
    });

    it('should log event on error and rethrow', (done) => {
        const metadata = {
            tipoEvento: 'TEST_EVENT_ERROR',
            categoria: AuditCategoria.SISTEMA
        };
        mockReflector.get.mockReturnValue(metadata);

        const error = new Error('Kaboom');
        const mockErrorCallHandler = {
            handle: jest.fn().mockReturnValue(throwError(() => error))
        };

        interceptor.intercept(mockExecutionContext as unknown as ExecutionContext, mockErrorCallHandler).subscribe({
            error: (err) => {
                expect(err).toBe(error);
                expect(auditService.logEvento).toHaveBeenCalledWith(expect.objectContaining({
                    tipoEvento: 'TEST_EVENT_ERROR',
                    resultado: AuditResultado.ERROR,
                    metadata: expect.objectContaining({
                        error: 'Kaboom'
                    })
                }));
                done();
            }
        });
    });
});
