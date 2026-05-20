import { Test, TestingModule } from '@nestjs/testing';
import { HttpException, HttpStatus, ArgumentsHost } from '@nestjs/common';
import { AllExceptionsFilter } from './all-exceptions.filter';
import { ErrorLogsService } from '../error-logs/error-logs.service';
import { JwtService } from '@nestjs/jwt';

describe('AllExceptionsFilter', () => {
    let filter: AllExceptionsFilter;
    let errorLogsService: ErrorLogsService;

    const mockErrorLogsService = {
        create: jest.fn().mockResolvedValue({}),
    };

    const mockJwtService = {
        decode: jest.fn(),
    };

    const mockResponse = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockReturnThis(),
    };

    const mockRequest = {
        url: '/test-path',
        method: 'POST',
        headers: {},
        ip: '127.0.0.1',
        connection: { remoteAddress: '127.0.0.1' },
        body: {},
        query: {},
        params: {},
    };

    const mockArgumentsHost = {
        switchToHttp: jest.fn().mockReturnValue({
            getRequest: () => mockRequest,
            getResponse: () => mockResponse,
        }),
    } as unknown as ArgumentsHost;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AllExceptionsFilter,
                { provide: ErrorLogsService, useValue: mockErrorLogsService },
                { provide: JwtService, useValue: mockJwtService },
            ],
        }).compile();

        filter = module.get<AllExceptionsFilter>(AllExceptionsFilter);
        errorLogsService = module.get<ErrorLogsService>(ErrorLogsService);
        jest.clearAllMocks();
    });

    it('should be defined', () => {
        expect(filter).toBeDefined();
    });

    it('should sanitize sensitive data (like password) in request.body before saving to logs', async () => {
        mockRequest.body = {
            email: 'test@user.com',
            password: 'secretPassword123',
            sensitiveField: 'someValue',
        };

        const exception = new HttpException('Test Exception', HttpStatus.BAD_REQUEST);

        await filter.catch(exception, mockArgumentsHost);

        expect(mockErrorLogsService.create).toHaveBeenCalled();
        const createArgs = mockErrorLogsService.create.mock.calls[0][0];

        // El body original en request.body no debería haber sido alterado o al menos el guardado en log debe estar sanitizado
        expect(createArgs.detail.body.password).toBe('***REDACTED***');
        expect(createArgs.detail.body.email).toBe('test@user.com');
        
        expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
        expect(mockResponse.json).toHaveBeenCalled();
    });

    it('should handle body without sensitive data without changing it', async () => {
        mockRequest.body = {
            username: 'normal_user',
            age: 30,
        };

        const exception = new HttpException('Test Exception', HttpStatus.INTERNAL_SERVER_ERROR);

        await filter.catch(exception, mockArgumentsHost);

        expect(mockErrorLogsService.create).toHaveBeenCalled();
        const createArgs = mockErrorLogsService.create.mock.calls[0][0];

        expect(createArgs.detail.body).toEqual({
            username: 'normal_user',
            age: 30,
        });
    });
});
