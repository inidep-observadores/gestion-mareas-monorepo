import httpClient from '@/config/http/http.client';

export interface Buque {
    id: string;
    nombreBuque: string;
    matricula?: string;
}

export interface Pesqueria {
    id: string;
    nombre: string;
}

export interface Observador {
    id: string;
    fullName: string;
}

export interface ArtePesca {
    id: string;
    nombre: string;
}

const catalogosService = {
    getBuques: async (): Promise<Buque[]> => {
        const { data } = await httpClient.get<Buque[]>('/catalogos/buques');
        return data;
    },

    getPesquerias: async (): Promise<Pesqueria[]> => {
        const { data } = await httpClient.get<Pesqueria[]>('/catalogos/pesquerias');
        return data;
    },

    getObservadores: async (): Promise<Observador[]> => {
        const { data } = await httpClient.get<Observador[]>('/catalogos/observadores');
        return data;
    },

    getArtesPesca: async (): Promise<ArtePesca[]> => {
        const { data } = await httpClient.get<ArtePesca[]>('/catalogos/artes-pesca');
        return data;
    }
};

export default catalogosService;
