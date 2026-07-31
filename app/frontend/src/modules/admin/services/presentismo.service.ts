import httpClient from '@/config/http/http.client';
import type { PlanillaMensualResponse } from '../interfaces/planilla-mensual.interface';

const presentismoApi = {
  obtenerPlanillaMensual: async (year: number, month: number): Promise<PlanillaMensualResponse> => {
    const { data } = await httpClient.get<PlanillaMensualResponse>('/presentismo/mensual', {
      params: { 
        year, 
        month
      }
    });
    return data;
  }
};

export default presentismoApi;
