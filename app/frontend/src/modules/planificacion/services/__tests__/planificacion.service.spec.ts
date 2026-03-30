import { describe, it, expect, vi, beforeEach } from 'vitest';
import httpClient from '@/config/http/http.client';
import { planificacionService } from '../planificacion.service';

vi.mock('@/config/http/http.client', () => ({
  default: {
    get: vi.fn(),
    post: vi.fn(),
  },
}));

describe('planificacionService (Frontend)', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('getRequerimientosPorAnio', () => {
    it('debe realizar una solicitud GET con el año correcto', async () => {
      const anio = 2025;
      const mockData = [{ id: '1', mes: 1, cantidad: 10 }];
      vi.mocked(httpClient.get).mockResolvedValue({ data: mockData });

      const result = await planificacionService.getRequerimientosPorAnio(anio);

      expect(httpClient.get).toHaveBeenCalledWith(`/planificacion/requerimientos/${anio}`);
      expect(result).toEqual(mockData);
    });
  });

  describe('upsertRequerimientosBatch', () => {
    it('debe realizar una solicitud POST con el DTO correcto', async () => {
      const dto = { anioOperativo: 2025, requerimientos: [] };
      const mockResponse = { count: 5 };
      vi.mocked(httpClient.post).mockResolvedValue({ data: mockResponse });

      const result = await planificacionService.upsertRequerimientosBatch(dto);

      expect(httpClient.post).toHaveBeenCalledWith('/planificacion/requerimientos', dto);
      expect(result).toEqual(mockResponse);
    });
  });
});
