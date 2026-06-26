import httpClient from "@/config/http/http.client";

const novedadesAdminApi = {
    getConfig: async (): Promise<any> => {
        const { data } = await httpClient.get('/mail-admin/config');
        return data;
    },

    updateConfig: async (config: any): Promise<void> => {
        await httpClient.post('/mail-admin/config', config);
    },

    syncManual: async (): Promise<any> => {
        const { data } = await httpClient.post('/mail-admin/sync-manual');
        return data;
    }
};

export default novedadesAdminApi;
