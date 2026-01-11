import { ExceptionFilter, ArgumentsHost } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ErrorLogsService } from '../error-logs/error-logs.service';
export declare class AllExceptionsFilter implements ExceptionFilter {
    private readonly errorLogsService;
    private readonly jwtService;
    private readonly logger;
    constructor(errorLogsService: ErrorLogsService, jwtService: JwtService);
    catch(exception: any, host: ArgumentsHost): Promise<void>;
}
