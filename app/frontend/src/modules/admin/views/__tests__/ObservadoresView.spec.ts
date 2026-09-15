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
  ObservadorDocumentacionBadge: true,
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
        { id: '1', codigoInterno: '123', nombre: 'Juan', apellido: 'Perez', tipoContrato: 'PLANTA PERMANENTE', tipoObservador: 'TECNICO', activo: true, disponible: true },
        { id: '2', codigoInterno: '124', nombre: 'Carlos', apellido: 'Inactivo', tipoContrato: 'LEY MARCO', tipoObservador: 'OBSERVADOR', activo: false, disponible: true },
        { id: '3', codigoInterno: '125', nombre: 'Mario', apellido: 'NoDisponible', tipoContrato: 'MONOTRIBUTISTA', tipoObservador: 'OBSERVADOR', activo: true, disponible: false },
      ]),
      fetchObservadores: mockFetchObservadores,
      openCreateModal: mockOpenCreateModal,
      openEditModal: vi.fn(),
      closeModal: vi.fn(),
      handleSave: vi.fn(),
      exportData: vi.fn()
    });
  });

  it('debe cargar y mostrar los observadores al montar (solo activos y disponibles por defecto)', async () => {
    const wrapper = mount(ObservadoresView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();
    expect(mockFetchObservadores).toHaveBeenCalledWith(true);
    // Solo Juan Perez (activo y disponible) se muestra por defecto
    expect(wrapper.text()).toContain('Perez, Juan');
    expect(wrapper.text()).not.toContain('Inactivo, Carlos');
    expect(wrapper.text()).not.toContain('NoDisponible, Mario');
  });

  it('debe mostrar inactivos al activar el boton de Inactivos', async () => {
    const wrapper = mount(ObservadoresView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();

    const botonInactivos = wrapper.findAll('button').find(b => b.text().includes('Inactivos'));
    expect(botonInactivos).toBeDefined();
    await botonInactivos!.trigger('click');

    expect(wrapper.text()).toContain('Inactivo, Carlos');
  });

  it('debe mostrar no disponibles al activar el boton de No Disponibles', async () => {
    const wrapper = mount(ObservadoresView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();

    const botonNoDisp = wrapper.findAll('button').find(b => b.text().includes('No Disponibles'));
    expect(botonNoDisp).toBeDefined();
    await botonNoDisp!.trigger('click');

    expect(wrapper.text()).toContain('NoDisponible, Mario');
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
