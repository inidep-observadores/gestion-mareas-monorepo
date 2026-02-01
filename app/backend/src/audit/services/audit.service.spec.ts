import { Test, TestingModule } from '@nestjs/testing';
import { AuditService } from './audit.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ConfigService } from '@nestjs/config';
import { getQueueToken } from '@nestjs/bull';
import { AuditLevel, AuditCategoria, AuditResultado } from '../enums/audit.enums';

describe('AuditService', () => {
    let service: AuditService;
    let prisma: PrismaService;
    let auditQueue: any;

    const mockPrismaService = {
        auditoriaApi: { create: jest.fn() },
        auditoriaEvento: { create: jest.fn() },
        auditoriaEntidad: { create: jest.fn() }
    };

    const mockAuditQueue = {
        add: jest.fn()
    };

    const mockConfigService = {
        get: jest.fn()
    };

    beforeEach(async () => {
        mockConfigService.get.mockImplementation((key, defaultValue) => {
            if (key === 'audit.enabled') return true;
            if (key === 'audit.async') return true;
            if (key === 'audit.level') return AuditLevel.ALL;
            return defaultValue;
        });

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AuditService,
                { provide: PrismaService, useValue: mockPrismaService },
                { provide: ConfigService, useValue: mockConfigService },
                { provide: getQueueToken('audit'), useValue: mockAuditQueue }
            ],
        }).compile();

        service = module.get<AuditService>(AuditService);
        prisma = module.get<PrismaService>(PrismaService);
        auditQueue = module.get(getQueueToken('audit'));
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    describe('logApi', () => {
        const apiDto = {
            metodoHttp: 'GET',
            ruta: '/api/users',
            rutaBase: '/api',
            statusCode: 200,
            responseTimeMs: 50,
            categoria: AuditCategoria.USUARIOS,
            esError: false,
            esCritico: false,
            queryParams: { search: 'John' },
            requestBody: { some: 'data' }
        };

        it('should add job to queue when async is enabled', async () => {
            await service.logApi(apiDto as any);

            expect(mockAuditQueue.add).toHaveBeenCalledWith(
                'log-api',
                expect.objectContaining({
                    metodoHttp: 'GET',
                    queryParams: { search: 'John' }
                }),
                expect.anything()
            );
            expect(mockPrismaService.auditoriaApi.create).not.toHaveBeenCalled();
        });

        it('should sanitise sensitive data in requestBody', async () => {
            const dtoWithSensitive = {
                ...apiDto,
                requestBody: { password: 'secret', username: 'john' }
            };

            await service.logApi(dtoWithSensitive as any);

            expect(mockAuditQueue.add).toHaveBeenCalledWith(
                'log-api',
                expect.objectContaining({
                    requestBody: { password: '***REDACTED***', username: 'john' }
                }),
                expect.anything()
            );
        });

        it('should not log if disabled by config', async () => {
            // Mock config to return false for enabled
            mockConfigService.get.mockImplementation((key) => {
                if (key === 'audit.enabled') return false;
                return true;
            });

            // We need to re-instantiate service to pick up new config
            const moduleDisabled = await Test.createTestingModule({
                providers: [
                    AuditService,
                    { provide: PrismaService, useValue: mockPrismaService },
                    { provide: ConfigService, useValue: mockConfigService },
                    { provide: getQueueToken('audit'), useValue: mockAuditQueue }
                ],
            }).compile();
            const serviceDisabled = moduleDisabled.get<AuditService>(AuditService);

            await serviceDisabled.logApi(apiDto as any);
            expect(mockAuditQueue.add).not.toHaveBeenCalled();
        });
    });

    describe('logEvento', () => {
        const eventoDto = {
            tipoEvento: 'LOGIN_SUCCESS',
            categoria: AuditCategoria.AUTH,
            entidadPrincipal: { userId: '123' },
            descripcion: 'User logged in',
            resultado: AuditResultado.EXITO
        };

        it('should add job to queue', async () => {
            await service.logEvento(eventoDto as any);
            expect(mockAuditQueue.add).toHaveBeenCalledWith(
                'log-evento',
                expect.objectContaining({ tipoEvento: 'LOGIN_SUCCESS' }),
                expect.anything()
            );
        });
    });

    describe('logEntidad', () => {
        const entidadDto = {
            entidadTipo: 'User',
            entidadId: '123',
            operacion: 'UPDATE',
            valoresNuevos: { email: 'new@test.com' }
        };

        it('should add job to queue', async () => {
            await service.logEntidad(entidadDto as any);
            expect(mockAuditQueue.add).toHaveBeenCalledWith(
                'log-entidad',
                expect.objectContaining({ operacion: 'UPDATE' }),
                expect.anything()
            );
        });
    });
});
