import httpClient from "@/config/http/http.client";

export interface PaginatedResponse<T> {
    total: number;
    data: T[];
    page: number;
    limit: number;
}

export interface AuditApiLog {
    id: string;
    timestamp: string;
    usuarioId?: string;
    usuarioEmail?: string;
    metodo: string;
    ruta: string;
    queryParams?: any;
    requestBody?: any;
    responseBody?: any;
    statusCode: number;
    duracionMs: number;
    ip?: string;
    userAgent?: string;
    esCritico: boolean;
    esError: boolean;
    mensajeError?: string;
    usuario?: {
        fullName: string;
        email: string;
    };
}

export interface AuditEntityLog {
    id: string;
    timestamp: string;
    usuarioId?: string;
    entidadTipo: string;
    entidadId: string;
    operacion: 'INSERT' | 'UPDATE' | 'DELETE';
    valoresAnteriores?: any;
    valoresNuevos?: any;
    contexto?: any;
    usuario?: {
        fullName: string;
        email: string;
    };
}

export interface AuditEventLog {
    id: string;
    timestamp: string;
    usuarioId?: string;
    usuarioEmail?: string;
    tipoEvento: string;
    categoria: string;
    descripcion: string;
    entidadPrincipal?: any;
    entidadesRelacionadas?: any;
    metadata?: any;
    resultado: 'EXITO' | 'ERROR';
    mensajeError?: string;
    ip?: string;
    esCritico: boolean;
    usuario?: {
        fullName: string;
        email: string;
    };
}

export interface AuditNavigationLog {
    id: string;
    timestamp: string;
    usuarioId?: string;
    sessionId: string;
    rutaOrigen?: string;
    rutaDestino: string;
    parametros?: any;
    tiempoVistaMs?: number;
    usuario?: {
        fullName: string;
        email: string;
    };
}

export interface AuditQueryParams {
    page?: number;
    limit?: number;
    desde?: string;
    hasta?: string;
    usuarioId?: string;
    categoria?: string;
    tipo?: string;
    entidadId?: string;
    soloErrores?: boolean;
    busqueda?: string;
}

const auditApi = {
    getApiLogs: async (params: AuditQueryParams): Promise<PaginatedResponse<AuditApiLog>> => {
        const { data } = await httpClient.get<PaginatedResponse<AuditApiLog>>('/audit/api', { params });
        return data;
    },

    getEntityLogs: async (params: AuditQueryParams): Promise<PaginatedResponse<AuditEntityLog>> => {
        const { data } = await httpClient.get<PaginatedResponse<AuditEntityLog>>('/audit/entidades', { params });
        return data;
    },

    getEventLogs: async (params: AuditQueryParams): Promise<PaginatedResponse<AuditEventLog>> => {
        const { data } = await httpClient.get<PaginatedResponse<AuditEventLog>>('/audit/eventos', { params });
        return data;
    },

    getNavigationLogs: async (params: AuditQueryParams): Promise<PaginatedResponse<AuditNavigationLog>> => {
        const { data } = await httpClient.get<PaginatedResponse<AuditNavigationLog>>('/audit/navegacion', { params });
        return data;
    },

    logNavigation: async (payload: { sessionId: string, rutaDestino: string, rutaOrigen?: string, parametros?: any, tiempoVistaMs?: number }): Promise<void> => {
        await httpClient.post('/audit/navigation', payload);
    }
};

export default auditApi;
