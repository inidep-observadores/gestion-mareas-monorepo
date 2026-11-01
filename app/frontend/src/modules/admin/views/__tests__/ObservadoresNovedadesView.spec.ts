import { describe, it, expect, vi, beforeEach } from 'vitest';
import { mount } from '@vue/test-utils';
import ObservadoresNovedadesView from '../ObservadoresNovedadesView.vue';
import { novedadesService } from '@/modules/admin/services/novedades.service';
import tiposNovedadApi from '@/modules/admin/services/tipos-novedad.service';
import { toast } from 'vue-sonner';

// Mocks
vi.mock('@/modules/admin/services/novedades.service');
vi.mock('@/modules/admin/services/tipos-novedad.service', () => ({
  default: {
    getAll: vi.fn(),
    getActivos: vi.fn()
  }
}));
vi.mock('vue-sonner', () => ({ toast: { success: vi.fn(), error: vi.fn() } }));
vi.mock('vue-router', () => ({
  useRoute: () => ({ name: 'ObservadoresNovedades', query: {} }),
  useRouter: () => ({ push: vi.fn() }),
}));

const globalStubs = {
  AdminLayout: { template: '<div><slot></slot></div>' },
  BackButton: true,
  BaseDataList: { 
    template: '<div><slot name="table-header"></slot><slot name="table-row" :item="items[0]" v-if="items.length"></slot></div>',
    props: ['items']
  },
  NovedadDialog: true,
  ConfirmationDialog: true,
  NovedadSidePanel: true,
  NovedadContextDetailContent: true,
  TrashIcon: true,
  EditIcon: true,
  ChevronDownIcon: true,
  DatePicker: true,
  SearchInput: true
};

describe('ObservadoresNovedadesView.vue', () => {
  const mockNovedades = [
    {
      id: '1',
      tipoNovedadId: 't1',
      observador: { nombre: 'Juan', apellido: 'Perez', codigoInterno: '123' },
      tipoNovedad: { id: 't1', descripcion: 'LICENCIA' },
      estadoAprobacion: 'APROBADA',
      origen: 'MANUAL',
      fechaCreacion: '2025-01-01T08:00:00Z',
      fechaInicio: '2025-01-01T00:00:00Z'
    },
    {
      id: '2',
      tipoNovedadId: 't2',
      observador: { nombre: 'Ana', apellido: 'Gomez', codigoInterno: '456' },
      tipoNovedad: { id: 't2', descripcion: 'FRANCO' },
      estadoAprobacion: 'PENDIENTE',
      origen: 'MANUAL',
      fechaCreacion: '2025-02-01T08:00:00Z',
      fechaInicio: '2025-02-01T00:00:00Z'
    }
  ];

  const mockTiposNovedad = [
    { id: 't1', codigo: 'LICENCIA', descripcion: 'LICENCIA' },
    { id: 't2', codigo: 'FRANCO', descripcion: 'FRANCO' }
  ];

  beforeEach(() => {
    vi.clearAllMocks();
    (novedadesService.getAll as any).mockResolvedValue(mockNovedades);
    (tiposNovedadApi.getAll as any).mockResolvedValue(mockTiposNovedad);
  });

  it('debe cargar y mostrar las novedades al montar', async () => {
    const wrapper = mount(ObservadoresNovedadesView, {
      global: { stubs: globalStubs }
    });

    await new Promise(r => setTimeout(r, 0));
    await wrapper.vm.$nextTick();

    expect(novedadesService.getAll).toHaveBeenCalled();
    expect(tiposNovedadApi.getAll).toHaveBeenCalled();
    expect(wrapper.text()).toContain('Perez, Juan');
  });

  it('debe alternar entre pestañas Historial y Pendientes', async () => {
    const wrapper = mount(ObservadoresNovedadesView, {
      global: { stubs: globalStubs }
    });
    
    await new Promise(r => setTimeout(r, 0));
    await wrapper.vm.$nextTick();

    const buttons = wrapper.findAll('button');
    const btnPendientes = buttons.find(b => b.text().includes('Bandeja de Pendientes'));
    
    await btnPendientes?.trigger('click');
    expect((wrapper.vm as any).activeTab).toBe('pendientes');
    expect((wrapper.vm as any).filteredNovedades.length).toBe(1);
    expect((wrapper.vm as any).filteredNovedades[0].estadoAprobacion).toBe('PENDIENTE');
  });

  it('debe filtrar novedades por tipo de novedad', async () => {
    const wrapper = mount(ObservadoresNovedadesView, {
      global: { stubs: globalStubs }
    });
    
    await new Promise(r => setTimeout(r, 0));
    await wrapper.vm.$nextTick();

    // En historial solo se ve 'APROBADA' (id: 1) por defecto
    expect((wrapper.vm as any).filteredNovedades.length).toBe(1);

    // Filtramos por tipo t1 (LICENCIA)
    (wrapper.vm as any).filterTipoNovedad = 't1';
    expect((wrapper.vm as any).filteredNovedades.length).toBe(1);
    expect((wrapper.vm as any).filteredNovedades[0].id).toBe('1');

    // Filtramos por tipo inexistente o t2 (que es PENDIENTE y está en otra pestaña)
    (wrapper.vm as any).filterTipoNovedad = 't2';
    expect((wrapper.vm as any).filteredNovedades.length).toBe(0);

    // Limpiar filtro
    (wrapper.vm as any).clearFilters();
    expect((wrapper.vm as any).filterTipoNovedad).toBe('');
    expect((wrapper.vm as any).filteredNovedades.length).toBe(1);
  });

  it('debe ordenar por fechaCreacion al activar el sort de Registrado', async () => {
    const wrapper = mount(ObservadoresNovedadesView, {
      global: { stubs: globalStubs }
    });
    await new Promise(r => setTimeout(r, 0));
    await wrapper.vm.$nextTick();

    (wrapper.vm as any).handleSort('fechaCreacion');
    expect((wrapper.vm as any).sortKey).toBe('fechaCreacion');
    expect((wrapper.vm as any).sortOrder).toBe('asc');

    (wrapper.vm as any).handleSort('fechaCreacion');
    expect((wrapper.vm as any).sortOrder).toBe('desc');
  });

  it('debe llamar a create cuando se guarda una nueva novedad', async () => {
    const wrapper = mount(ObservadoresNovedadesView, {
      global: { stubs: globalStubs }
    });
    await new Promise(r => setTimeout(r, 0));

    (novedadesService.create as any).mockResolvedValue({ id: '3' });
    await (wrapper.vm as any).handleSave({ motivo: 'Nueva Novedad' });

    expect(novedadesService.create).toHaveBeenCalledWith({ motivo: 'Nueva Novedad' });
    expect(toast.success).toHaveBeenCalledWith('Novedad creada exitosamente');
    expect(novedadesService.getAll).toHaveBeenCalledTimes(2); // Al montar y despues de guardar
  });

  it('debe confirmar eliminacion y llamar a delete', async () => {
    const wrapper = mount(ObservadoresNovedadesView, {
      global: { stubs: globalStubs }
    });
    await new Promise(r => setTimeout(r, 0));

    (wrapper.vm as any).novedadToDelete = mockNovedades[0];
    (novedadesService.delete as any).mockResolvedValue(true);
    
    await (wrapper.vm as any).confirmDelete();

    expect(novedadesService.delete).toHaveBeenCalledWith('1');
    expect(toast.success).toHaveBeenCalledWith('Novedad eliminada correctamente');
  });
});
