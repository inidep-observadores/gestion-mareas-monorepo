import httpClient from '@/config/http/http.client'
import { useConfigStore } from '@/modules/shared/stores/config.store'

export interface FleetDistributionItem {
    label: string
    count: number
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

const dashboardService = {
    async getFleetDistribution(): Promise<FleetDistributionResponse> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<FleetDistributionResponse>(`/mareas/flota-por-pesqueria?year=${selectedYear}`)
        return data
    },

    async getFatigueAlerts(): Promise<FatigueAlert[]> {
        const { selectedYear } = useConfigStore()
        const { data } = await httpClient.get<FatigueAlert[]>(`/mareas/alertas/personal-fatiga?year=${selectedYear}`)
        return data
    }
}

export default dashboardService
