import httpClient from '@/config/http/http.client'

export interface FleetDistributionItem {
    label: string
    count: number
}

export interface FleetDistributionResponse {
    total: number
    distribution: FleetDistributionItem[]
}

const dashboardService = {
    async getFleetDistribution(): Promise<FleetDistributionResponse> {
        const { data } = await httpClient.get<FleetDistributionResponse>('/mareas/flota-por-pesqueria')
        return data
    }
}

export default dashboardService
