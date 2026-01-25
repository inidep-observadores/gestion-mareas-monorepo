import httpClient from '@/config/http/http.client'
import type { BusinessRules } from '@/modules/shared/config/business-rules'

export const businessRulesService = {
  async getRules(): Promise<BusinessRules> {
    const { data } = await httpClient.get<BusinessRules>('/config/reglas')
    return data
  },
}
