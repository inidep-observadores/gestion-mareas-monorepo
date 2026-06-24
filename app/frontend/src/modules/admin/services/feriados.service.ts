import httpClient from '@/config/http/http.client';
import type { Feriado, CreateFeriadoDto, SyncFeriadosResponse } from '../interfaces/feriados.interface';

const feriadosApi = {
  getFeriados: async (anio?: number): Promise<Feriado[]> => {
    const url = anio ? `/feriados?anio=${anio}` : '/feriados';
    const { data } = await httpClient.get<Feriado[]>(url);
    return data;
  },

  createFeriado: async (feriado: CreateFeriadoDto): Promise<Feriado> => {
    const { data } = await httpClient.post<Feriado>('/feriados', feriado);
    return data;
  },

  updateFeriado: async (fecha: string, feriado: Partial<CreateFeriadoDto>): Promise<Feriado> => {
    const { data } = await httpClient.put<Feriado>(`/feriados/${fecha}`, feriado);
    return data;
  },

  deleteFeriado: async (fecha: string): Promise<void> => {
    await httpClient.delete(`/feriados/${fecha}`);
  },

  sincronizarConApi: async (anio: number): Promise<SyncFeriadosResponse> => {
    const { data } = await httpClient.post<SyncFeriadosResponse>(`/feriados/sincronizar/${anio}`);
    return data;
  }
};

export default feriadosApi;
