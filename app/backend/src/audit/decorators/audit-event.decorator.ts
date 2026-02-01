import { SetMetadata } from '@nestjs/common';
import { AuditCategoria } from '../enums/audit.enums';

export const AUDIT_EVENT_KEY = 'audit_event';

export interface AuditEventMetadata {
    tipoEvento: string;
    categoria: AuditCategoria;
    descripcion?: string; // Si no se provee, se usará el nombre del método o lógica ad-hoc
    esCritico?: boolean;
}

export const AuditEvent = (metadata: AuditEventMetadata) => SetMetadata(AUDIT_EVENT_KEY, metadata);
