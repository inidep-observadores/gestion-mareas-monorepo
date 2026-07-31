import httpClient from '@/config/http/http.client';
import type { Novedad, CreateNovedadDto, UpdateNovedadDto } from '../interfaces/novedad.interface';

const API_URL = '/presentismo/novedades';

export const novedadesService = {
  async getAll(observadorId?: string): Promise<Novedad[]> {
    const params = observadorId ? { observadorId } : undefined;
    const response = await httpClient.get<Novedad[]>(API_URL, { params });
    return response.data;
  },

  async getById(id: string): Promise<Novedad> {
    const response = await httpClient.get<Novedad>(`${API_URL}/${id}`);
    return response.data;
  },

  async create(data: CreateNovedadDto): Promise<Novedad> {
    const response = await httpClient.post<Novedad>(API_URL, data);
    return response.data;
  },

  async update(id: string, data: UpdateNovedadDto): Promise<Novedad> {
    const response = await httpClient.put<Novedad>(`${API_URL}/${id}`, data);
    return response.data;
  },

  async delete(id: string): Promise<void> {
    await httpClient.delete(`${API_URL}/${id}`);
  }
};
