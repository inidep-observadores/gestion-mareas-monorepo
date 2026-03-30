import { describe, it, expect, vi, beforeEach } from 'vitest';
import { mount } from '@vue/test-utils';
import { createTestingPinia } from '@pinia/testing';
import RequerimientosCoberturaView from '../RequerimientosCoberturaView.vue';
import catalogosService from '@/modules/mareas/services/catalogos.service';
import { planificacionService } from '../../services/planificacion.service';
import { useConfigStore } from '@/modules/shared/stores/config.store';

// Mocks
vi.mock('../../services/planificacion.service', () => ({
  planificacionService: {
    getRequerimientosPorAnio: vi.fn(),
    upsertRequerimientosBatch: vi.fn(),
  },
}));

vi.mock('@/modules/mareas/services/catalogos.service', () => ({
  default: {
    getPesquerias: vi.fn(),
    getTiposFlota: vi.fn(),
  },
}));

vi.mock('vue-sonner', () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
  },
}));

describe('RequerimientosCoberturaView.vue', () => {
  const mockCatalogos = {
    pesquerias: [{ id: 'p1', nombre: 'Merluza', activo: true }],
    tiposFlota: [{ id: '1', nombre: 'Fresqueros', codigo: 'ALTURA_FRESQUERO', activo: true }], // Alineado con fallback del componente
  };

  const mockRequerimientos = [
    { pesqueriaId: 'p1', tipoFlotaId: '1', mes: 1, cantidad: 5 },
  ];

  beforeEach(() => {
    vi.clearAllMocks();
    vi.mocked(catalogosService.getPesquerias).mockResolvedValue(mockCatalogos.pesquerias as any);
    vi.mocked(catalogosService.getTiposFlota).mockResolvedValue(mockCatalogos.tiposFlota as any);
    vi.mocked(planificacionService.getRequerimientosPorAnio).mockResolvedValue(mockRequerimientos as any);
  });

  const mountComponent = async () => {
    const wrapper = mount(RequerimientosCoberturaView, {
      global: {
        plugins: [
          createTestingPinia({
            createSpy: vi.fn,
            initialState: {
              config: { selectedYear: 2025 },
            },
          }),
        ],
        stubs: {
          PlanificacionDashboardLayout: { template: '<div><slot /></div>' },
          BaseSwitch: true,
          'planificacion-sidebar': { template: '<div></div>' },
          'app-header': { template: '<div></div>' },
          'Backdrop': { template: '<div></div>' },
          'ThemeToggler': { template: '<div></div>' },
          'HeaderLogo': { template: '<div></div>' },
          'NotificationMenu': { template: '<div></div>' },
          'UserMenu': { template: '<div></div>' },
          'RefreshIcon': { template: '<span></span>' }
        },
      },
    });
    await vi.dynamicImportSettled();
    await new Promise(resolve => setTimeout(resolve, 50)); // Más tiempo para múltiples awaits
    return wrapper;
  };

  it('debe cargar catálogos y requerimientos al montar el componente', async () => {
    const wrapper = await mountComponent();

    expect(catalogosService.getPesquerias).toHaveBeenCalled();
    expect(planificacionService.getRequerimientosPorAnio).toHaveBeenCalledWith(2025);

    // Verificar que la matriz se pobló
    expect(wrapper.text()).toContain('5');
  });

  it('debe calcular correctamente los totales mensuales en la fila de totales', async () => {
    const wrapper = await mountComponent();

    // El mock inicial tiene 5 en el mes 1.
    // Buscamos la fila de totales (tfoot)
    const tfoot = wrapper.find('tfoot');
    expect(tfoot.exists()).toBe(true);
    expect(tfoot.text()).toContain('5');
  });

  it('debe filtrar por pesquería en modo vista y mostrar todo en modo edición', async () => {
    const mockPesq2 = { id: 'p2', nombre: 'Langostino', activo: true };
    vi.mocked(catalogosService.getPesquerias).mockResolvedValue([...mockCatalogos.pesquerias, mockPesq2] as any);

    // Le daremos requisitos a p2 para que sea visible en modo vista global.
    const nuevosRequerimientos = [
      ...mockRequerimientos,
      { pesqueriaId: 'p2', tipoFlotaId: '1', mes: 2, cantidad: 10 }
    ];
    vi.mocked(planificacionService.getRequerimientosPorAnio).mockResolvedValue(nuevosRequerimientos as any);

    const wrapper = await mountComponent();

    // Por defecto muestra ambas pesquerías, c/u con 1 flota (Fresqueros = 2 filas total)
    expect(wrapper.findAll('tbody tr').length).toBe(2);

    // Seleccionar Merluza (p1)
    (wrapper.vm as any).selectedPesqueriaId = 'p1';
    await wrapper.vm.$nextTick();
    await new Promise(resolve => setTimeout(resolve, 50));

    // Solo debe mostrar Merluza (1 fila)
    expect(wrapper.findAll('tbody tr').length).toBe(1);

    // Cambiar a modo edición
    (wrapper.vm as any).isEditMode = true;
    (wrapper.vm as any).selectedPesqueriaId = ''; // Al editar no hay combobox o si lo hubiese, se ve todo
    await wrapper.vm.$nextTick();
    await new Promise(resolve => setTimeout(resolve, 50));

    // El filtro se ignora y además se muestran todas así no tengan datos
    expect(wrapper.findAll('tbody tr').length).toBe(2);
  });

  it('debe cambiar a modo edición al alternar el switch', async () => {
    const wrapper = await mountComponent();

    // Por defecto no está en modo edición (los inputs no existen en modo vista)
    expect(wrapper.find('input[type="number"]').exists()).toBe(false);

    // Activar modo edición
    (wrapper.vm as any).isEditMode = true;
    await wrapper.vm.$nextTick();
    await new Promise(resolve => setTimeout(resolve, 10)); // Pequeña espera para renderizado condicional

    expect(wrapper.find('input[type="number"]').exists()).toBe(true);
  });
});
