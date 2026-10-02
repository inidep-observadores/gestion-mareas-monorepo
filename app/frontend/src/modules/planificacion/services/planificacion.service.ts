import httpClient from '@/config/http/http.client';
import type { 
  RequerimientoCobertura, BatchUpsertRequerimientosDto,
  ExperienciaObservador, BatchUpsertExperienciaDto,
  ExperienciaPorPesqueria
} from '../interfaces/planificacion.interfaces';
import type { 
  EscenarioSimulacionState, 
  CreateEscenarioDto, 
  UpdateEscenarioDto, 
  CloneEscenarioDto 
} from '../interfaces/simulador.interface';

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
   * Obtiene la experiencia de todos los observadores para una pesquería específica
   */
  async getExperienciaPorPesqueria(pesqueriaId: string): Promise<ExperienciaPorPesqueria[]> {
    const response = await httpClient.get<ExperienciaPorPesqueria[]>(`/planificacion/experiencia-observadores/pesqueria/${pesqueriaId}`);
    return response.data;
  },

  /**
   * Guarda o actualiza un lote completo de experiencias
   */
  async upsertExperienciaObservadoresBatch(dto: BatchUpsertExperienciaDto): Promise<{ count: number }> {
    const response = await httpClient.post<{ count: number }>('/planificacion/experiencia-observadores', dto);
    return response.data;
  },

  /**
   * Obtiene el detalle de mareas para una celda de experiencia
   */
  async getDetalleMareasExperiencia(observadorId: string, pesqueriaId: string): Promise<any[]> {
    const response = await httpClient.get<any[]>(`/planificacion/experiencia-observadores/${observadorId}/mareas`, {
      params: { pesqueriaId }
    });
    return response.data;
  },

  /**
   * Obtiene la matriz de eventos consolidados para el Simulador de Cobertura
   */
  async obtenerEventosSimulador(year: number, month: number, horizonMonths = 6): Promise<any> {
    const response = await httpClient.get<any>('/planificacion/simulador/eventos', {
      params: { year, month, horizonMonths }
    });
    return response.data;
  },

  async getEscenariosPorAnio(anio: number): Promise<EscenarioSimulacionState[]> {
    const response = await httpClient.get<EscenarioSimulacionState[]>(`/planificacion/simulador/escenarios/${anio}`);
    return response.data;
  },

  async getEscenario(id: string): Promise<EscenarioSimulacionState> {
    const response = await httpClient.get<EscenarioSimulacionState>(`/planificacion/simulador/escenario/${id}`);
    return response.data;
  },

  async createEscenario(dto: CreateEscenarioDto): Promise<EscenarioSimulacionState> {
    const response = await httpClient.post<EscenarioSimulacionState>('/planificacion/simulador/escenarios', dto);
    return response.data;
  },

  async updateEscenario(id: string, dto: UpdateEscenarioDto): Promise<EscenarioSimulacionState> {
    const response = await httpClient.put<EscenarioSimulacionState>(`/planificacion/simulador/escenarios/${id}`, dto);
    return response.data;
  },

  async cloneEscenario(id: string, dto: CloneEscenarioDto): Promise<EscenarioSimulacionState> {
    const response = await httpClient.post<EscenarioSimulacionState>(`/planificacion/simulador/escenarios/${id}/clonar`, dto);
    return response.data;
  },

  async deleteEscenario(id: string): Promise<void> {
    await httpClient.delete(`/planificacion/simulador/escenarios/${id}`);
  },

  async exportarEscenarioAExcel(id: string, filtros: { fechaDesde: string; fechaHasta: string; soloPlanificadas: boolean }): Promise<Blob> {
    const response = await httpClient.post<Blob>(
      `/planificacion/simulador/escenarios/${id}/export/excel`,
      filtros,
      { responseType: 'blob' }
    );
    return response.data;
  }
};

