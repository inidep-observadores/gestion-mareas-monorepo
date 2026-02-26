import httpClient from '@/config/http/http.client';
import type { 
  RequerimientoCobertura, BatchUpsertRequerimientosDto,
  ExperienciaObservador, BatchUpsertExperienciaDto
} from '../interfaces/planificacion.interfaces';

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
  },

  /**
   * Obtiene la matriz de experiencia entre observadores y pesquerías
   */
  async getExperienciaObservadores(): Promise<ExperienciaObservador[]> {
    const response = await httpClient.get<ExperienciaObservador[]>('/planificacion/experiencia-observadores');
    return response.data;
  },

  /**
   * Guarda o actualiza un lote completo de experiencias
   */
  async upsertExperienciaObservadoresBatch(dto: BatchUpsertExperienciaDto): Promise<{ count: number }> {
    const response = await httpClient.post<{ count: number }>('/planificacion/experiencia-observadores', dto);
    return response.data;
  }
};
