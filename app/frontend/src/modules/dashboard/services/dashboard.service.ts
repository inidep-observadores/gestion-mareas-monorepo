import httpClient from '@/config/http/http.client'
import { useConfigStore } from '@/modules/shared/stores/config.store'

export interface FleetDistributionItem {
    label: string
    count: number
    stats?: Record<string, { count: number, nombre: string }>
    vessels: Array<{
        id: string; // UUID de la marea
        name: string;
        mareaCode: string;
        status: string;
        tipoFlota?: {
            codigo: string;
            nombre: string;
        }
    }>
}

export interface FleetDistributionResponse {
    total: number
    distribution: FleetDistributionItem[]
}

export interface FatigueTrip {
    mareaCode: string
    vessel: string
    departure: string | null
    arrival: string | null
    inExecution: boolean
    navigatedDays: number
}

export interface FatigueAlert {
    id: string
    name: string
    days: number
    lastArrival: string | null
    trips: FatigueTrip[]
}

export interface CriticalDelay {
    id: string
    mareaId: string
    vesselName: string
    obs: string
    arrivalDate: string
    days: number
}

export interface WorkforceStatus {
    totalActivos: number
    navegando: number
    descanso: number
    disponibles: number
    licencia: number
    impedidos: number
    topDry: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode?: string; vesselName?: string; fishery?: string; tipoObservador: string; observaciones?: string }>
    listNavegando: Array<{ id: string; name: string; days: number; vessel: string; mareaCode?: string; fishery?: string; enTierra?: boolean; startDate: string; tipoObservador: string, stageCount?: number; observaciones?: string }>
    listDescanso: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode?: string; vesselName?: string; fishery?: string; tipoObservador: string; observaciones?: string }>
    listDisponibles: Array<{ id: string; name: string; days: number; lastArrival: string; mareaCode?: string; vesselName?: string; fishery?: string; tipoObservador: string; observaciones?: string }>
    listImpedidos: Array<{ id: string; name: string; motivo: string; tipoObservador: string; observaciones?: string }>
}

export interface MovementAlert {
    id: string
    tipo: 'ZARPADA' | 'ARRIBO' | 'POSIBLE_ZARPADA' | 'POSIBLE_ARRIBO' | 'RECOMENDACION_FIN_MAREA'
    titulo: string
    descripcion: string
    fechaDetectada: string
    referenciaId: string
    metadata: {
        mareaCode: string
        vesselName: string
        observerName: string
        portName: string
        eventDate: string
        type: 'ZARPADA' | 'ARRIBO'
        sources: Array<{
            name: string
            detectedAt: string
            data?: any
        }>
        [key: string]: any
    }
}

const dashboardService = {
    async getFleetDistribution(): Promise<FleetDistributionResponse> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<FleetDistributionResponse>(`/mareas/flota-por-pesqueria?year=${selectedYear}`)
        return data
    },

    async getCriticalDelays(): Promise<CriticalDelay[]> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<CriticalDelay[]>(`/mareas/alertas/retrasos-criticos?year=${selectedYear}`)
        return data
    },

    async getReportDelays(): Promise<CriticalDelay[]> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<CriticalDelay[]>(`/mareas/alertas/informes-demorados?year=${selectedYear}`)
        return data
    },

    async getFatigueAlerts(): Promise<FatigueAlert[]> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<FatigueAlert[]>(`/mareas/alertas/personal-fatiga?year=${selectedYear}`)
        return data
    },

    async getWorkforceStatus(): Promise<WorkforceStatus> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<WorkforceStatus>(`/mareas/workforce/status?year=${selectedYear}`)
        return data
    },

    async getMovementAlerts(): Promise<MovementAlert[]> {
        // Filtrar por los tipos confirmados de zarpada y arribo (PNA, Tracking y Recomendaciones)
        const types = 'ZARPADA,ARRIBO,POSIBLE_ZARPADA,POSIBLE_ARRIBO,RECOMENDACION_FIN_MAREA'
        const { data } = await httpClient.get<MovementAlert[]>(`/alerts?type=${types}&status=PENDIENTE`)
        return data
    },

    async sendClaim(payload: { to: string; body: string; mareaId: string }): Promise<void> {
        await httpClient.post('/mareas/claim', payload)
    }
}

export default dashboardService
