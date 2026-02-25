import httpClient from '@/config/http/http.client';
import type { RequerimientoCobertura, BatchUpsertRequerimientosDto } from '../interfaces/planificacion.interfaces';

export const planificacionService = {
  /**
   * Obtiene la matriz de requerimientos para un año específico
   */
  async getRequerimientosPorAnio(anio: number): Promise<RequerimientoCobertura[]> {
    const response = await httpClient.get<RequerimientoCobertura[]>(`/planificacion/requerimientos/${anio}`);
    return response.data;
  },

  /**
   * Guarda o actualiza un lote completo de requerimientos para un año
   */
  async upsertRequerimientosBatch(dto: BatchUpsertRequerimientosDto): Promise<{ count: number }> {
    const response = await httpClient.post<{ count: number }>('/planificacion/requerimientos', dto);
    return response.data;
  }
};
