import httpClient from '@/config/http/http.client';
import type { TransicionEstado, EstadoMareaResumen } from '../interfaces/transicion-estado.interface';

const transicionesEstadoApi = {
    getAll: async (): Promise<TransicionEstado[]> => {
        const { data } = await httpClient.get<TransicionEstado[]>('/catalogos/transiciones-estado');
        return data;
    },

    getOne: async (id: string): Promise<TransicionEstado> => {
        const { data } = await httpClient.get<TransicionEstado>(`/catalogos/transiciones-estado/${id}`);
        return data;
    },

    create: async (dto: Partial<TransicionEstado>): Promise<TransicionEstado> => {
        const { data } = await httpClient.post<TransicionEstado>('/catalogos/transiciones-estado', dto);
        return data;
    },

    update: async (id: string, dto: Partial<TransicionEstado>): Promise<TransicionEstado> => {
        const { data } = await httpClient.patch<TransicionEstado>(`/catalogos/transiciones-estado/${id}`, dto);
        return data;
    },

    delete: async (id: string): Promise<void> => {
        await httpClient.delete(`/catalogos/transiciones-estado/${id}`);
    },

    getEstados: async (): Promise<EstadoMareaResumen[]> => {
        const { data } = await httpClient.get<EstadoMareaResumen[]>('/catalogos/estados-marea');
        return data;
    },
};

export default transicionesEstadoApi;
