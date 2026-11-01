import { describe, it, expect, vi, beforeEach } from 'vitest';
import { mount } from '@vue/test-utils';
import ObservadoresDisponibilidadView from '../ObservadoresDisponibilidadView.vue';
import disponibilidadApi from '@/modules/admin/services/disponibilidad.service';
import { toast } from 'vue-sonner';

// Mocks
vi.mock('@/modules/admin/services/disponibilidad.service', () => ({
  default: {
    obtenerDisponibilidad: vi.fn(),
    exportarAExcel: vi.fn(),
  },
}));

vi.mock('vue-sonner', () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

vi.mock('vue-router', () => ({
  useRoute: () => ({ query: {} }),
  useRouter: () => ({ push: vi.fn() }),
}));

// Mock vis-timeline & vis-data
vi.mock('vis-timeline/standalone', () => ({
  Timeline: class {
    destroy = vi.fn();
    setGroups = vi.fn();
    setItems = vi.fn();
    setWindow = vi.fn();
    getWindow = vi.fn().mockReturnValue({
      start: new Date('2026-11-01T00:00:00'),
      end: new Date('2026-11-30T23:59:59'),
    });
  },
}));

vi.mock('vis-data', () => ({
  DataSet: class {
    constructor(public data?: any[]) {}
  },
}));

const globalStubs = {
  AdminLayout: { template: '<div><slot></slot></div>' },
  BackButton: true,
  SearchInput: true,
  DatePicker: true,
  DoubleRangeSlider: true,
  ChevronDownIcon: true,
  DownloadIcon: true,
};

describe('ObservadoresDisponibilidadView.vue', () => {
  const mockResponse = {
    fechaInicio: '2026-11-01',
    fechaFin: '2027-04-30',
    fechaHoy: '2026-11-01',
    observadores: [
      {
        observador: {
          id: 'obs-1',
          nombre: 'Juan',
          apellido: 'Perez',
          codigoInterno: 101,
          tipoObservador: 'OBSERVADOR',
          tipoContrato: '1109',
          conImpedimento: false,
          disponible: true,
        },
        eventos: [
          {
            id: 'ev-1',
            startDate: '2026-11-01',
            endDate: '2026-11-10',
            estado: 'DISPONIBLE' as const,
          },
        ],
      },
    ],
  };

  beforeEach(() => {
    vi.clearAllMocks();
    (disponibilidadApi.obtenerDisponibilidad as any).mockResolvedValue(mockResponse);
    (disponibilidadApi.exportarAExcel as any).mockResolvedValue(new Blob(['test'], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }));
    window.URL.createObjectURL = vi.fn().mockReturnValue('blob:test');
    window.URL.revokeObjectURL = vi.fn();
  });

  it('debe cargar los datos al montar y renderizar el botón Exportar Excel', async () => {
    const wrapper = mount(ObservadoresDisponibilidadView, {
      global: { stubs: globalStubs },
    });

    await new Promise((r) => setTimeout(r, 0));
    await wrapper.vm.$nextTick();

    expect(disponibilidadApi.obtenerDisponibilidad).toHaveBeenCalled();
    const exportBtn = wrapper.findComponent({ name: 'ExportExcelButton' });
    expect(exportBtn.exists()).toBe(true);
  });

  it('debe ejecutar exportToExcel con el rango del timeline y observadores filtrados', async () => {
    const wrapper = mount(ObservadoresDisponibilidadView, {
      global: { stubs: globalStubs },
    });

    await new Promise((r) => setTimeout(r, 0));
    await wrapper.vm.$nextTick();

    const exportBtn = wrapper.findComponent({ name: 'ExportExcelButton' });
    await exportBtn.trigger('click');

    expect(disponibilidadApi.exportarAExcel).toHaveBeenCalledWith(
      expect.objectContaining({
        observadorIds: ['obs-1'],
        fechaDesde: '2026-11-01',
      })
    );
    expect(toast.success).toHaveBeenCalledWith('Planilla de disponibilidad exportada a Excel correctamente');
  });
});

