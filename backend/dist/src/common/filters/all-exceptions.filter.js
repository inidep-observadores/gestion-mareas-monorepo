"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AllExceptionsFilter = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const error_logs_service_1 = require("../error-logs/error-logs.service");
let AllExceptionsFilter = class AllExceptionsFilter {
    constructor(errorLogsService, jwtService) {
        this.errorLogsService = errorLogsService;
        this.jwtService = jwtService;
        this.logger = new common_1.Logger('AllExceptionsFilter');
    }
    async catch(exception, host) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse();
        const request = ctx.getRequest();
        const status = exception instanceof common_1.HttpException
            ? exception.getStatus()
            : common_1.HttpStatus.INTERNAL_SERVER_ERROR;
        const message = exception.message || 'Error interno del servidor';
        const stack = exception.stack;
        let user = request.user;
        if (!user) {
            const authHeader = request.headers.authorization;
            if (authHeader && authHeader.startsWith('Bearer ')) {
                const token = authHeader.split(' ')[1];
                try {
                    user = this.jwtService.decode(token);
                }
                catch (e) {
                }
            }
        }
        const ip = request.headers['x-forwarded-for'] || request.ip || request.connection.remoteAddress;
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
            ip,
        });
        let userMessage = 'Se ha producido un error inesperado. Por favor, contacte al administrador.';
        let validationErrors = null;
        if (status === common_1.HttpStatus.BAD_REQUEST) {
            const exceptionResponse = exception.getResponse ? exception.getResponse() : null;
            if (exceptionResponse && Array.isArray(exceptionResponse.message)) {
                userMessage = 'Error de validación';
                validationErrors = exceptionResponse.message;
            }
            else {
                userMessage = message;
            }
        }
        else if (status < 500) {
            userMessage = message;
        }
        this.logger.error(`${request.method} ${request.url} - Status: ${status} - Message: ${message}`);
        response.status(status).json({
            statusCode: status,
            timestamp: new Date().toISOString(),
            path: request.url,
            message: validationErrors || userMessage,
            error: status >= 500 ? 'Internal Server Error' : (exception.name || 'Error'),
        });
    }
};
exports.AllExceptionsFilter = AllExceptionsFilter;
exports.AllExceptionsFilter = AllExceptionsFilter = __decorate([
    (0, common_1.Catch)(),
    __metadata("design:paramtypes", [error_logs_service_1.ErrorLogsService,
        jwt_1.JwtService])
], AllExceptionsFilter);
//# sourceMappingURL=all-exceptions.filter.js.map