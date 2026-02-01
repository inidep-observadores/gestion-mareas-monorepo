export enum AuditLevel {
    ALL = 'ALL',           // Auditar todas las peticiones
    CRITICAL = 'CRITICAL'  // Solo operaciones críticas (POST, PUT, DELETE, PATCH)
}
