import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable, throwError } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { AuditService } from '../services/audit.service';
import { AUDIT_EVENT_KEY, AuditEventMetadata } from '../decorators/audit-event.decorator';
import { AuditResultado } from '../enums/audit.enums';

@Injectable()
export class AuditEventInterceptor implements NestInterceptor {
    private readonly logger = new Logger(AuditEventInterceptor.name);

    constructor(
        private readonly reflector: Reflector,
        private readonly auditService: AuditService,
    ) { }

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const metadata = this.reflector.get<AuditEventMetadata>(AUDIT_EVENT_KEY, context.getHandler());

        if (!metadata) {
            return next.handle();
        }

        const request = context.getType() === 'http' ? context.switchToHttp().getRequest() : null;
        const user = request?.user;
        const ip = request?.ip;

        return next.handle().pipe(
            tap((result) => {
                try {
                    this.auditService.logEvento({
                        tipoEvento: metadata.tipoEvento,
                        categoria: metadata.categoria,
                        descripcion: metadata.descripcion,
                        ip: request?.ip,
                        usuarioId: user?.id,
                        usuarioEmail: user?.email,
                        entidadPrincipal: result, 
                        metadata: {
                            handler: context.getHandler().name,
                            controller: context.getClass().name,
                            body: request?.body,
                            params: request?.params,
                            query: request?.query,
                        },
                        resultado: AuditResultado.EXITO,
                        esCritico: metadata.esCritico
                    });
                } catch (auditError) {
                    this.logger.error(`Silent fail in AuditEventInterceptor (success): ${auditError.message}`);
                }
            }),
            catchError((err) => {
                try {
                    this.auditService.logEvento({
                        tipoEvento: metadata.tipoEvento,
                        categoria: metadata.categoria,
                        descripcion: metadata.descripcion || `Error en ejecución de ${context.getHandler().name}`,
                        resultado: AuditResultado.ERROR,
                        usuarioId: user?.id,
                        usuarioEmail: user?.email,
                        ip: ip,
                        entidadPrincipal: request?.params,
                        metadata: {
                            handler: context.getHandler().name,
                            controller: context.getClass().name,
                            body: request?.body,
                            params: request?.params,
                            query: request?.query,
                            error: err.message
                        },
                        esCritico: metadata.esCritico
                    });
                } catch (auditError) {
                    this.logger.error(`Silent fail in AuditEventInterceptor (error): ${auditError.message}`);
                }

                return throwError(() => err);
            })
        );
    }
}
