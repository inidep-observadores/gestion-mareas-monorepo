export interface AuditConfig {
    level: 'ALL' | 'CRITICAL';
    api: {
        enabled: boolean;
        includeRequestBody: boolean;
        includeResponseBody: boolean;
        maxBodySize: number;
        retentionDays: number;
    };
    navigation: {
        enabled: boolean;
        retentionDays: number;
    };
    entities: {
        enabled: boolean;
    };
    events: {
        enabled: boolean;
    };
    async: {
        enabled: boolean;
    };
}

export const auditConfig = (): AuditConfig => ({
    level: (process.env.AUDIT_LEVEL as 'ALL' | 'CRITICAL') || 'ALL',
    api: {
        enabled: process.env.AUDIT_API_ENABLED === 'true',
        includeRequestBody: process.env.AUDIT_API_INCLUDE_REQUEST_BODY === 'true',
        includeResponseBody: process.env.AUDIT_API_INCLUDE_RESPONSE_BODY === 'true',
        maxBodySize: parseInt(process.env.AUDIT_API_MAX_BODY_SIZE || '10000', 10),
        retentionDays: parseInt(process.env.AUDIT_API_RETENTION_DAYS || '90', 10),
    },
    navigation: {
        enabled: process.env.AUDIT_NAVIGATION_ENABLED === 'true',
        retentionDays: parseInt(process.env.AUDIT_NAVIGATION_RETENTION_DAYS || '30', 10),
    },
    entities: {
        enabled: process.env.AUDIT_ENTITIES_ENABLED === 'true',
    },
    events: {
        enabled: process.env.AUDIT_EVENTS_ENABLED === 'true',
    },
    async: {
        enabled: process.env.AUDIT_ASYNC_ENABLED === 'true',
    },
});
