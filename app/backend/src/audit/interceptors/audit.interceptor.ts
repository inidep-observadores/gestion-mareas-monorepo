import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { AuditService } from '../services/audit.service';
import { AuditCategoria } from '../enums/audit.enums';
import { UserContext } from '../../common/middlewares/user-context.middleware';

@Injectable()
export class AuditInterceptor implements NestInterceptor {
    private readonly logger = new Logger(AuditInterceptor.name);
    private readonly IGNORED_ROUTES = ['/health', '/metrics', '/api/health', '/favicon.ico'];

    constructor(private readonly auditService: AuditService) { }

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        if (context.getType() !== 'http') {
            return next.handle();
        }

        const request = context.switchToHttp().getRequest();
        const { method, url, body, query, ip } = request;

        // Poblamos el contexto del usuario para que Prisma y los triggers lo vean
        const user = request.user;
        const store = UserContext.getStore();

        if (store && user) {
            store.userId = user.id;
            store.userEmail = user.email;
        }

        // Skip ignored routes
        if (this.IGNORED_ROUTES.some(route => url.includes(route))) {
            return next.handle();
        }

        const startTime = Date.now();

        return next.handle().pipe(
            tap({
                next: (data) => {
                    const response = context.switchToHttp().getResponse();
                    const statusCode = response.statusCode;
                    const duration = Date.now() - startTime;
                    const user = request.user; // Get user AFTER Guard/Controller has run
                    const cookies = request.cookies || {};
                    const sessionId = cookies['connect.sid'] || cookies['io'] || request.headers['x-session-id'] || request.headers['x-request-id'] || null;

                    this.auditService.logApi({
                        metodoHttp: method,
                        ruta: url.split('?')[0],
                        rutaBase: url,
                        statusCode,
                        responseTimeMs: duration,
                        categoria: this.determineCategory(url),
                        usuarioId: user?.id || null,
                        usuarioEmail: user?.email || null,
                        sessionId: sessionId,
                        ip,
                        userAgent: request.get('user-agent'),
                        requestBody: body,
                        responseBody: undefined,
                        queryParams: query,
                        esError: statusCode >= 400,
                        esCritico: statusCode >= 500
                    }).catch(err => this.logger.error('Error logging audit API', err));
                },
                error: (error) => {
                    const duration = Date.now() - startTime;
                    const statusCode = error.status || 500;
                    const user = request.user;
                    const cookies = request.cookies || {};
                    const sessionId = cookies['connect.sid'] || cookies['io'] || request.headers['x-session-id'] || request.headers['x-request-id'] || null;

                    this.auditService.logApi({
                        metodoHttp: method,
                        ruta: url.split('?')[0],
                        rutaBase: url,
                        statusCode,
                        responseTimeMs: duration,
                        categoria: this.determineCategory(url),
                        usuarioId: user?.id || null,
                        usuarioEmail: user?.email || null,
                        sessionId: sessionId,
                        ip,
                        userAgent: request.get('user-agent'),
                        requestBody: body,
                        errorMessage: error.message,
                        queryParams: query,
                        esError: true,
                        esCritico: statusCode >= 500
                    }).catch(err => this.logger.error('Error logging audit API (error case)', err));
                }
            })
        );
    }

    private determineCategory(url: string): AuditCategoria {
        // Simple heuristic mapping based on URL segments
        if (url.includes('/auth')) return AuditCategoria.AUTH;
        if (url.includes('/users') || url.includes('/usuarios')) return AuditCategoria.USUARIOS;
        if (url.includes('/mareas')) return AuditCategoria.MAREAS;
        if (url.includes('/reportes')) return AuditCategoria.REPORTES;
        if (url.includes('/config')) return AuditCategoria.SISTEMA;
        return AuditCategoria.SISTEMA; // Default
    }
}
