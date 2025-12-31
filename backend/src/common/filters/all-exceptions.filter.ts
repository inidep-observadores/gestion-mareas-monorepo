import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    HttpStatus,
    Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ErrorLogsService } from '../error-logs/error-logs.service';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
    private readonly logger = new Logger('AllExceptionsFilter');

    constructor(private readonly errorLogsService: ErrorLogsService) { }

    async catch(exception: any, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest<Request>();

        const status =
            exception instanceof HttpException
                ? exception.getStatus()
                : HttpStatus.INTERNAL_SERVER_ERROR;

        const message = exception.message || 'Error interno del servidor';
        const stack = exception.stack;

        // Extraer información del usuario si está autenticado
        const user = (request as any).user;

        // Registrar el error en la DB
        await this.errorLogsService.create({
            level: status >= 500 ? 'CRITICAL' : 'ERROR',
            source: 'BACKEND',
            context: 'GlobalExceptionFilter',
            userId: user?.id,
            userEmail: user?.email,
            message,
            stack,
            detail: {
                exception: exception.response || exception,
                body: request.body,
                query: request.query,
                params: request.params,
            },
            path: request.url,
            method: request.method,
            ip: request.ip,
        });

        // Respuesta simplificada para el usuario
        let userMessage = 'Se ha producido un error inesperado. Por favor, contacte al administrador.';
        let validationErrors = null;

        if (status === HttpStatus.BAD_REQUEST) {
            const exceptionResponse: any = exception.getResponse ? exception.getResponse() : null;
            if (exceptionResponse && Array.isArray(exceptionResponse.message)) {
                userMessage = 'Error de validación';
                validationErrors = exceptionResponse.message;
            } else {
                userMessage = message;
            }
        } else if (status < 500) {
            userMessage = message;
        }

        // Log por consola también para desarrollo
        this.logger.error(`${request.method} ${request.url} - Status: ${status} - Message: ${message}`);

        response.status(status).json({
            statusCode: status,
            timestamp: new Date().toISOString(),
            path: request.url,
            message: validationErrors || userMessage,
            error: status >= 500 ? 'Internal Server Error' : (exception.name || 'Error'),
        });
    }
}
