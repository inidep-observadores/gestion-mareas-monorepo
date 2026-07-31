import { describe, it, expect, vi, beforeEach } from 'vitest';
import { mount, flushPromises } from '@vue/test-utils';
import PresentismoMatrizView from '../PresentismoMatrizView.vue';
import presentismoApi from '@/modules/admin/services/presentismo.service';
import presentismoExportService from '@/modules/admin/services/presentismo-export.service';

vi.mock('@/modules/admin/services/presentismo.service');
vi.mock('@/modules/admin/services/presentismo-export.service');
vi.mock('vue-router', () => ({
  useRoute: () => ({ name: 'PresentismoMatriz' }),
  useRouter: () => ({ push: vi.fn() }),
}));

const globalStubs = {
  AdminLayout: { template: '<div><slot></slot></div>' },
  BackButton: true,
  SearchInput: { 
    template: '<input :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" />',
    props: ['modelValue']
  },
  ChevronDownIcon: true,
  DownloadIcon: true,
};

describe('PresentismoMatrizView.vue', () => {
  const mockPlanillaResponse = {
    year: 2026,
    month: 1,
    diasMes: 31,
    feriados: { 1: 'Año Nuevo' },
    matriz: [
      {
        observador: { id: '1', nombre: 'Juan', apellido: 'Perez', codigoInterno: '123', tipoObservador: 'TECNICO', tipoContrato: 'CONTRATADO' },
        totales: { navegando: 5, puerto: 2, novedades: 0, libres: 24, feriadosFinSemana: 8, conflictos: 0, esperandoZarpada: 0 },
        dias: Array.from({length: 31}, (_, i) => ({ estado: 'LIBRE' })).reduce((acc, curr, i) => { acc[i+1] = curr; return acc; }, {} as any)
      },
      {
        observador: { id: '2', nombre: 'Ana', apellido: 'Gomez', codigoInterno: '456', tipoObservador: 'CIENTIFICO', tipoContrato: 'PLANTA' },
        totales: { navegando: 0, puerto: 0, novedades: 5, libres: 26, feriadosFinSemana: 8, conflictos: 0, esperandoZarpada: 0 },
        dias: Array.from({length: 31}, (_, i) => ({ estado: 'LIBRE' })).reduce((acc, curr, i) => { acc[i+1] = curr; return acc; }, {} as any)
      }
    ]
  };

  beforeEach(() => {
    vi.clearAllMocks();
    (presentismoApi.obtenerPlanillaMensual as any).mockResolvedValue(mockPlanillaResponse);
  });

  it('debe cargar la matriz al montar y mostrar los observadores', async () => {
    const wrapper = mount(PresentismoMatrizView, { global: { stubs: globalStubs } });
    await flushPromises();
    expect(presentismoApi.obtenerPlanillaMensual).toHaveBeenCalled();
    expect(wrapper.text()).toContain('Perez, Juan');
    expect(wrapper.text()).toContain('Gomez, Ana');
  });

  it('debe filtrar observadores usando el buscador', async () => {
    const wrapper = mount(PresentismoMatrizView, { global: { stubs: globalStubs } });
    await flushPromises();

    const input = wrapper.find('input');
    await input.setValue('Ana');
    await flushPromises();

    expect(wrapper.text()).not.toContain('Perez, Juan');
    expect(wrapper.text()).toContain('Gomez, Ana');
  });

  it('debe poder exportar a excel', async () => {
    (presentismoExportService.exportarAExcel as any).mockResolvedValue(new Blob());
    global.URL.createObjectURL = vi.fn(() => 'blob:url');
    global.URL.revokeObjectURL = vi.fn();

    const wrapper = mount(PresentismoMatrizView, { global: { stubs: globalStubs } });
    await flushPromises();

    const exportBtn = wrapper.findAll('button').find(b => b.text().includes('Exportar Excel'));
    await exportBtn?.trigger('click');
    await flushPromises();

    expect(presentismoExportService.exportarAExcel).toHaveBeenCalled();
  });
});
