import api from '@/api/axios';
import type { Novedad, CreateNovedadDto, UpdateNovedadDto } from '../interfaces/novedad.interface';

const API_URL = '/presentismo/novedades';

export const novedadesService = {
  async getAll(observadorId?: string): Promise<Novedad[]> {
    const params = observadorId ? { observadorId } : undefined;
    const response = await api.get<Novedad[]>(API_URL, { params });
    return response.data;
  },

  async getById(id: string): Promise<Novedad> {
    const response = await api.get<Novedad>(`${API_URL}/${id}`);
    return response.data;
  },

  async create(data: CreateNovedadDto): Promise<Novedad> {
    const response = await api.post<Novedad>(API_URL, data);
    return response.data;
  },

  async update(id: string, data: UpdateNovedadDto): Promise<Novedad> {
    const response = await api.put<Novedad>(`${API_URL}/${id}`, data);
    return response.data;
  },

  async delete(id: string): Promise<void> {
    await api.delete(`${API_URL}/${id}`);
  }
};
