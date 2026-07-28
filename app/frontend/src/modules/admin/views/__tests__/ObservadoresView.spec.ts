import { describe, it, expect, vi, beforeEach } from 'vitest';
import { mount } from '@vue/test-utils';
import ObservadoresView from '../ObservadoresView.vue';
import { useObservadores } from '@/modules/admin/composables/useObservadores';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import { ref } from 'vue';

vi.mock('@/modules/admin/composables/useObservadores');
vi.mock('@/modules/auth/stores/auth.store');

const globalStubs = {
  AdminLayout: { template: '<div><slot></slot></div>' },
  BackButton: true,
  BaseDataList: { 
    template: '<div><slot name="header-actions"></slot><slot name="table-header"></slot><slot name="table-row" :item="items[0]" v-if="items.length"></slot></div>',
    props: ['items']
  },
  ObservadorDialog: true,
  ExportExcelButton: true,
  ChevronDownIcon: true,
  EditIcon: true,
  SearchIcon: true,
};

describe('ObservadoresView.vue', () => {
  const mockFetchObservadores = vi.fn();
  const mockOpenCreateModal = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
    (useAuthStore as any).mockReturnValue({
      user: { roles: ['admin'] }
    });

    (useObservadores as any).mockReturnValue({
      isLoading: ref(false),
      searchQuery: ref(''),
      showModal: ref(false),
      selectedObservador: ref(null),
      isSaving: ref(false),
      filteredObservadores: ref([
        { id: '1', codigoInterno: '123', nombre: 'Juan', apellido: 'Perez', tipoContrato: 'CONTRATADO', tipoObservador: 'TECNICO', activo: true, disponible: true }
      ]),
      fetchObservadores: mockFetchObservadores,
      openCreateModal: mockOpenCreateModal,
      openEditModal: vi.fn(),
      closeModal: vi.fn(),
      handleSave: vi.fn(),
      exportData: vi.fn()
    });
  });

  it('debe cargar y mostrar los observadores al montar', async () => {
    const wrapper = mount(ObservadoresView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();
    expect(mockFetchObservadores).toHaveBeenCalledWith(true);
    expect(wrapper.text()).toContain('Perez, Juan');
  });

  it('debe mostrar acciones de edicion si es admin', async () => {
    const wrapper = mount(ObservadoresView, { global: { stubs: globalStubs } });
    expect(wrapper.findComponent({ name: 'ExportExcelButton' }).exists()).toBe(true);
    expect(wrapper.text()).toContain('Editar');
  });

  it('NO debe mostrar acciones de edicion si no es admin/tecnico', async () => {
    (useAuthStore as any).mockReturnValue({ user: { roles: ['readonly'] } });
    const wrapper = mount(ObservadoresView, { global: { stubs: globalStubs } });
    expect(wrapper.findComponent({ name: 'ExportExcelButton' }).exists()).toBe(false);
    expect(wrapper.text()).not.toContain('Editar');
  });
});
