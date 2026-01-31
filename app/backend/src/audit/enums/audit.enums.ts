export enum AuditLevel {
    ALL = 'ALL',         // Todo (GET, POST, etc.)
    WRITE = 'WRITE',     // Solo cambios (POST, PUT, DELETE, PATCH)
    CRITICAL = 'CRITICAL', // Solo acciones marcadas como críticas
    NONE = 'NONE'        // Desactivado
}

export enum AuditCategoria {
    AUTH = 'AUTH',
    USUARIOS = 'USUARIOS',
    MAREAS = 'MAREAS',
    OBSERVADORES = 'OBSERVADORES',
    SISTEMA = 'SISTEMA',
    IMPORTACION = 'IMPORTACION',
    REPORTES = 'REPORTES',
    BUQUES = 'BUQUES',
    ESPECIES = 'ESPECIES',
    DESCONOCIDO = 'DESCONOCIDO'
}

export enum AuditResultado {
    EXITO = 'EXITO',
    ERROR = 'ERROR',
    PARCIAL = 'PARCIAL',
    DENEGADO = 'DENEGADO'
}

export enum AuditAction {
    CREATE = 'CREATE',
    READ = 'READ',
    UPDATE = 'UPDATE',
    DELETE = 'DELETE',
    LOGIN = 'LOGIN',
    LOGOUT = 'LOGOUT',
    UPLOAD = 'UPLOAD',
    DOWNLOAD = 'DOWNLOAD',
    IMPORT = 'IMPORT',
    EXPORT = 'EXPORT',
    EXECUTE = 'EXECUTE'
}
