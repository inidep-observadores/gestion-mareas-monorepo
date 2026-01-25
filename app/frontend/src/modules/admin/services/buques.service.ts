import httpClient from '@/config/http/http.client';
import type { Buque, TipoFlota, Puerto, Pesqueria, ArtePesca } from '../interfaces/buque.interface';

const buquesApi = {
    getBuques: async (): Promise<Buque[]> => {
        const { data } = await httpClient.get<Buque[]>('/catalogos/buques');
        return data;
    },

    getBuque: async (id: string): Promise<Buque> => {
        const { data } = await httpClient.get<Buque>(`/catalogos/buques/${id}`);
        return data;
    },

    createBuque: async (buque: Partial<Buque>): Promise<Buque> => {
        const { data } = await httpClient.post<Buque>('/catalogos/buques', buque);
        return data;
    },

    updateBuque: async (id: string, buque: Partial<Buque>): Promise<Buque> => {
        const { data } = await httpClient.patch<Buque>(`/catalogos/buques/${id}`, buque);
        return data;
    },

    deleteBuque: async (id: string): Promise<void> => {
        await httpClient.delete(`/catalogos/buques/${id}`);
    },

    // Catalog helpers
    getTiposFlota: async (): Promise<TipoFlota[]> => {
        const { data } = await httpClient.get<TipoFlota[]>('/catalogos/tipos-flota');
        return data;
    },

    getPuertos: async (): Promise<Puerto[]> => {
        const { data } = await httpClient.get<Puerto[]>('/catalogos/puertos');
        return data;
    },

    getPesquerias: async (): Promise<Pesqueria[]> => {
        const { data } = await httpClient.get<Pesqueria[]>('/catalogos/pesquerias');
        return data;
    },

    getArtesPesca: async (): Promise<ArtePesca[]> => {
        const { data } = await httpClient.get<ArtePesca[]>('/catalogos/artes-pesca');
        return data;
    }
};

export default buquesApi;
