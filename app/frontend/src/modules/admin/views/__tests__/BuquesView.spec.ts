import { describe, it, expect, vi, beforeEach } from 'vitest';
import { mount } from '@vue/test-utils';
import BuquesView from '../BuquesView.vue';
import { useBuques } from '../../composables/useBuques';
import { useAuthStore } from '../../../auth/stores/auth.store';
import { ref } from 'vue';

vi.mock('../../composables/useBuques');
vi.mock('../../../auth/stores/auth.store');
vi.mock('../../services/JobQueueService', () => ({
  jobQueueService: {
    triggerJob: vi.fn(),
  },
}));

const globalStubs = {
  AdminLayout: { template: '<div><slot></slot></div>' },
  BaseDataList: {
    template: '<div><slot name="filters"></slot><slot name="header-actions"></slot><slot name="table-header"></slot><div v-for="item in items" :key="item.id"><slot name="table-row" :item="item"></slot></div></div>',
    props: ['items'],
  },
  BuqueDialog: true,
  ChevronDownIcon: true,
  DownloadIcon: true,
  RefreshIcon: true,
  EditIcon: true,
  SearchIcon: true,
};

describe('BuquesView.vue', () => {
  const mockFetchBuques = vi.fn();
  const mockFetchCatalogs = vi.fn();

  const mockBuquesList = [
    {
      id: '1',
      nombreBuque: 'Buque Uno',
      matricula: 'MAT-1',
      calificacion: 5,
      habitabilidadFemeninaApta: true,
      activo: true,
    },
    {
      id: '2',
      nombreBuque: 'Buque Dos',
      matricula: 'MAT-2',
      calificacion: 2,
      habitabilidadFemeninaApta: false,
      activo: true,
    },
    {
      id: '3',
      nombreBuque: 'Buque Tres',
      matricula: 'MAT-3',
      calificacion: 4,
      habitabilidadFemeninaApta: false,
      activo: false,
    },
  ];

  beforeEach(() => {
    vi.clearAllMocks();
    (useAuthStore as any).mockReturnValue({
      user: { roles: ['admin'] },
    });

    (useBuques as any).mockReturnValue({
      isLoading: ref(false),
      isSaving: ref(false),
      isExporting: ref(false),
      searchQuery: ref(''),
      isModalOpen: ref(false),
      currentBuque: ref(null),
      filteredBuques: ref(mockBuquesList),
      tiposFlota: ref([]),
      puertos: ref([]),
      pesquerias: ref([]),
      artesPesca: ref([]),
      fetchBuques: mockFetchBuques,
      fetchCatalogs: mockFetchCatalogs,
      openCreateModal: vi.fn(),
      openEditModal: vi.fn(),
      closeModal: vi.fn(),
      handleSave: vi.fn(),
      exportDbf: vi.fn(),
    });
  });

  it('debe renderizar todos los buques cuando el filtro de calificación está en todas', async () => {
    const wrapper = mount(BuquesView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();

    expect(wrapper.text()).toContain('Buque Uno');
    expect(wrapper.text()).toContain('Buque Dos');
    expect(wrapper.text()).toContain('Buque Tres');
  });

  it('debe filtrar correctamente con el filtro de calificación mayor o igual (gte)', async () => {
    const wrapper = mount(BuquesView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();

    // Cambiar modo a 'gte' y límite a 4
    (wrapper.vm as any).filtroModoCalificacion = 'gte';
    (wrapper.vm as any).filtroLimiteCalificacion = 4;
    await wrapper.vm.$nextTick();

    expect(wrapper.text()).toContain('Buque Uno'); // calif 5
    expect(wrapper.text()).toContain('Buque Tres'); // calif 4
    expect(wrapper.text()).not.toContain('Buque Dos'); // calif 2
  });

  it('debe filtrar correctamente con el filtro de calificación menor o igual (lte)', async () => {
    const wrapper = mount(BuquesView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();

    // Cambiar modo a 'lte' y límite a 3
    (wrapper.vm as any).filtroModoCalificacion = 'lte';
    (wrapper.vm as any).filtroLimiteCalificacion = 3;
    await wrapper.vm.$nextTick();

    expect(wrapper.text()).toContain('Buque Dos'); // calif 2
    expect(wrapper.text()).not.toContain('Buque Uno'); // calif 5
    expect(wrapper.text()).not.toContain('Buque Tres'); // calif 4
  });

  it('debe filtrar solo buques con habitabilidad femenina apta', async () => {
    const wrapper = mount(BuquesView, { global: { stubs: globalStubs } });
    await wrapper.vm.$nextTick();

    (wrapper.vm as any).filtroSoloMujeres = true;
    await wrapper.vm.$nextTick();

    expect(wrapper.text()).toContain('Buque Uno'); // apto
    expect(wrapper.text()).not.toContain('Buque Dos'); // no apto
    expect(wrapper.text()).not.toContain('Buque Tres'); // no apto
  });
});
