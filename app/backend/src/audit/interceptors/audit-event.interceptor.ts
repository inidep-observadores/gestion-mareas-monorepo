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
                this.auditService.logEvento({
                    tipoEvento: metadata.tipoEvento,
                    categoria: metadata.categoria,
                    descripcion: metadata.descripcion || `Ejecución exitosa de ${context.getHandler().name}`,
                    resultado: AuditResultado.EXITO,
                    usuarioId: user?.id,
                    usuarioEmail: user?.email,
                    ip: ip,
                    entidadPrincipal: result, // Agregamos el resultado como entidad principal
                    metadata: {
                        method: context.getHandler().name,
                        args: request?.body,
                        params: request?.params,
                    },
                    esCritico: metadata.esCritico
                }).catch(err => this.logger.error('Error logging audit event (success)', err));
            }),
            catchError((err) => {
                this.auditService.logEvento({
                    tipoEvento: metadata.tipoEvento,
                    categoria: metadata.categoria,
                    descripcion: metadata.descripcion || `Error en ejecución de ${context.getHandler().name}`,
                    resultado: AuditResultado.ERROR,
                    usuarioId: user?.id,
                    usuarioEmail: user?.email,
                    ip: ip,
                    entidadPrincipal: request?.params, // En caso de error, guardamos los params para identificar el objetivo
                    metadata: {
                        method: context.getHandler().name,
                        args: request?.body,
                        params: request?.params,
                        error: err.message
                    },
                    esCritico: metadata.esCritico
                }).catch(logErr => this.logger.error('Error logging audit event (failure)', logErr));

                return throwError(() => err);
            })
        );
    }
}
