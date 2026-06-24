import httpClient from '@/config/http/http.client';

const presentismoExportService = {
  exportarAExcel: async (params: { year: number; month: number; ids?: string[] }): Promise<Blob> => {
    const { data } = await httpClient.post('/presentismo/export/excel', params, {
      responseType: 'blob'
    });
    return data;
  }
};

export default presentismoExportService;
