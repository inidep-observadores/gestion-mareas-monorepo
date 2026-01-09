import httpClient from '@/config/http/http.client';

export interface AlertEvent {
    id: string
    fechaHora: string
    tipoEvento: 'CREACION' | 'CAMBIO_ESTADO' | 'ASIGNACION' | 'COMENTARIO' | 'AUTO_RESOLUCION' | 'ESCALADO'
    detalle?: string
    usuario?: { fullName: string }
}

export interface Alerta {
    id: string
    codigoUnico: string
    titulo: string
    descripcion: string
    tipo: 'FATIGA' | 'RETRASO_DATOS' | 'RETRASO_INFORME' | 'GENERICO'
    estado: 'PENDIENTE' | 'SEGUIMIENTO' | 'RESUELTA' | 'DESCARTADA' | 'VENCIDA'
    prioridad: 'ALTA' | 'MEDIA' | 'BAJA'
    fechaDetectada: string
    fechaVencimiento?: string
    fechaCierre?: string
    referenciaId?: string
    referenciaTipo?: string
    metadata?: Record<string, any>
    eventos?: AlertEvent[]
    asignadoA?: { fullName: string; avatarUrl?: string }
}

export const alertsService = {
    getAll: async (params: { refId?: string; status?: string; userId?: string }): Promise<Alerta[]> => {
        const { data } = await httpClient.get<Alerta[]>('/alerts', { params })
        return data
    },

    getOne: async (id: string): Promise<Alerta> => {
        const { data } = await httpClient.get<Alerta>(`/alerts/${id}`)
        return data
    },

    update: async (id: string, payload: { estado?: string; prioridad?: string; fechaVencimiento?: string; comment?: string; asignadoId?: string }): Promise<Alerta> => {
        const { data } = await httpClient.patch<Alerta>(`/alerts/${id}`, payload)
        return data
    }
}
