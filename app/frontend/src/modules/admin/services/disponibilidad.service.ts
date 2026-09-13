import httpClient from '@/config/http/http.client';
import type { DisponibilidadResponse } from '../interfaces/disponibilidad.interface';

const disponibilidadApi = {
  obtenerDisponibilidad: async (horizonte: number = 6): Promise<DisponibilidadResponse> => {
    const { data } = await httpClient.get<DisponibilidadResponse>('/presentismo/disponibilidad', {
      params: { horizonte },
    });
    return data;
  },
};

export default disponibilidadApi;
