import httpClient from "@/config/http/http.client";
import type { TipoNovedad } from "../interfaces/tipo-novedad.interface";

const tiposNovedadApi = {
    getAll: async (): Promise<TipoNovedad[]> => {
        const { data } = await httpClient.get('/catalogos/tipos-novedad');
        return data;
    },

    getActivos: async (): Promise<TipoNovedad[]> => {
        const { data } = await httpClient.get('/catalogos/tipos-novedad/activos');
        return data;
    },
};

export default tiposNovedadApi;
