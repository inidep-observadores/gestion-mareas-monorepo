import httpClient from '@/config/http/http.client'
import { useConfigStore } from '@/modules/shared/stores/config.store'

export interface FleetDistributionItem {
    label: string
    count: number
    vessels: Array<{ name: string; mareaCode: string; status: string }>
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
    topDry: Array<{ id: string; name: string; days: number; lastArrival: string }>
    listNavegando: Array<{ id: string; name: string; days: number; vessel: string; startDate: string }>
    listDescanso: Array<{ id: string; name: string; days: number; lastArrival: string }>
    listDisponibles: Array<{ id: string; name: string; days: number; lastArrival: string }>
    listImpedidos: Array<{ id: string; name: string; motivo: string }>
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
    }
}

export default dashboardService
