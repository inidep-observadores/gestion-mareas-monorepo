import httpClient from '@/config/http/http.client';
import type { DisponibilidadResponse } from '../interfaces/disponibilidad.interface';

const disponibilidadApi = {
  obtenerDisponibilidad: async (horizonte: number = 6): Promise<DisponibilidadResponse> => {
    const { data } = await httpClient.get<DisponibilidadResponse>('/presentismo/disponibilidad', {
      params: { horizonte },
    });
    return data;
  },

  exportarAExcel: async (params: {
    fechaDesde: string;
    fechaHasta: string;
    observadorIds?: string[];
  }): Promise<Blob> => {
    const { data } = await httpClient.post('/presentismo/disponibilidad/export/excel', params, {
      responseType: 'blob',
    });
    return data;
  },
};

export default disponibilidadApi;
