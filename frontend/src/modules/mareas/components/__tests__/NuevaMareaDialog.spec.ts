import { describe, it, expect, vi } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import NuevaMareaDialog from '../NuevaMareaDialog.vue'
import { TipoMarea } from '../../types/enums'
import { nextTick, ref } from 'vue'

// Stubs
const DatePickerStub = {
  template: '<input type="text" class="datepicker-stub" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" />',
  props: ['modelValue', 'error'],
  methods: {
    focus() { /* stub */ }
  }
}

const SearchableSelectStub = {
  template: '<select class="select-stub" :value="modelValue" @change="$emit(\'update:modelValue\', $event.target.value)"><slot></slot></select>',
  props: ['options', 'modelValue', 'error', 'placeholder'],
  methods: {
    focus() { /* stub */ }
  }
}

const NavigationStagesEditorStub = {
  template: '<div class="stages-editor-stub"></div>',
  props: ['modelValue']
}

const BaseModalStub = {
    template: `
      <div v-if="show" class="modal-stub">
        <div class="modal-title"><slot name="title">{{ title }}</slot></div>
        <div class="modal-content"><slot /></div>
      </div>
    `,
    props: ['show', 'maxWidth', 'title']
}

const ConfirmationDialogStub = {
  template: '<div v-if="show" class="confirmation-stub"></div>',
  props: ['show', 'title', 'message', 'confirmText']
}

const LoadingSpinnerStub = {
  template: '<div class="loading-spinner-stub"></div>',
  props: ['size']
}

// Mock del httpClient para interceptar todas las llamadas HTTP
vi.mock('@/config/http/http.client', () => ({
  default: {
    get: vi.fn((url: string) => {
      if (url.includes('/catalogos/buques')) {
        return Promise.resolve({ data: [{ id: '1', nombreBuque: 'Barco A', pesqueriaHabitualId: '1' }] })
      }
      if (url.includes('/catalogos/pesquerias')) {
        return Promise.resolve({ data: [{ id: '1', nombre: 'Pesqueria A' }] })
      }
      if (url.includes('/catalogos/observadores')) {
        return Promise.resolve({ data: [{ id: '1', nombre: 'Obs', apellido: 'A' }] })
      }
      if (url.includes('/catalogos/artes-pesca')) {
        return Promise.resolve({ data: [{ id: '1', nombre: 'Arte A' }] })
      }
      if (url.includes('/catalogos/puertos')) {
        return Promise.resolve({ data: [{ id: '1', nombre: 'Puerto A' }] })
      }
      return Promise.resolve({ data: [] })
    }),
    post: vi.fn((url: string, data: any) => {
      if (url.includes('/mareas')) {
        return Promise.resolve({ data: { id: 'new-id', id_marea: 'MC-100-25', ...data } })
      }
      return Promise.resolve({ data: {} })
    }),
    put: vi.fn(() => Promise.resolve({ data: {} })),
    patch: vi.fn(() => Promise.resolve({ data: {} })),
    delete: vi.fn(() => Promise.resolve({ data: {} }))
  }
}))

// Mock de servicios
vi.mock('../services/catalogos.service', () => ({
  default: {
    getBuques: vi.fn(() => Promise.resolve([{ id: '1', nombreBuque: 'Barco A', id_pesqueria_habitual: '1' }])),
    getPesquerias: vi.fn(() => Promise.resolve([{ id: '1', nombre: 'Pesqueria A' }])),
    getObservadores: vi.fn(() => Promise.resolve([{ id: '1', nombre: 'Obs', apellido: 'A' }])),
    getArtesPesca: vi.fn(() => Promise.resolve([{ id: '1', nombre: 'Arte A' }])),
    getPuertos: vi.fn(() => Promise.resolve([{ id: '1', nombre: 'Puerto A' }]))
  }
}))

vi.mock('../services/mareas.service', () => ({
    default: {
        create: vi.fn().mockImplementation((data) => Promise.resolve({ id: 'new-id', id_marea: 'MC-100-24', ...data })),
        getDashboardOperativo: vi.fn().mockResolvedValue({ kpis: [], items: [] }),
        getMareaContext: vi.fn().mockResolvedValue({})
    }
}))

// Mock de useMareas
vi.mock('../composables/useMareas', () => ({
    useMareas: vi.fn(() => ({
        createMarea: vi.fn().mockResolvedValue({ id: 'new-id', id_marea: 'MC-100-24' }),
        loading: ref(false),
        error: ref(null)
    }))
}))

vi.mock('vue-router', () => ({
  useRouter: vi.fn(() => ({
    push: vi.fn()
  }))
}))

vi.mock('@/modules/alerts/services/alerts.service', () => ({
  alertsService: {
    getOne: vi.fn().mockResolvedValue({}),
    update: vi.fn().mockResolvedValue({})
  }
}))

vi.mock('vue-sonner', () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
    info: vi.fn()
  }
}))

vi.mock('@/icons', () => ({
  ChevronRightIcon: { template: '<span></span>' },
  ChevronLeftIcon: { template: '<span></span>' },
  CheckIcon: { template: '<span></span>' },
  DocsIcon: { template: '<span></span>' },
  RefreshIcon: { template: '<span></span>' },
  MapPinIcon: { template: '<span></span>' },
  ShipIcon: { template: '<span></span>' },
  InfoIcon: { template: '<span></span>' },
  WaveIcon: { template: '<span></span>' },
  SettingsIcon: { template: '<span></span>' },
  BeakerIcon: { template: '<span></span>' },
  CalenderIcon: { template: '<span></span>' },
  HistoryIcon: { template: '<span></span>' },
  WarningIcon: { template: '<span></span>' },
  TrashIcon: { template: '<span></span>' },
  ArrowLeftIcon: { template: '<span></span>' }
}))

describe('NuevaMareaDialog.vue', () => {
  const defaultProps = {
    show: true,
    initFromAlert: false
  }

  const mountComponent = async (props = {}) => {
    const pinia = createTestingPinia({ 
        createSpy: vi.fn,
        initialState: {
            config: { selectedYear: 2025 }
        }
    })
    
    const wrapper = mount(NuevaMareaDialog, {
      props: { ...defaultProps, ...props },
      global: {
        plugins: [pinia],
        stubs: {
          Teleport: true,
          BaseModal: BaseModalStub,
          DatePicker: DatePickerStub,
          SearchableSelect: SearchableSelectStub,
          NavigationStagesEditor: NavigationStagesEditorStub,
          ConfirmationDialog: ConfirmationDialogStub,
          LoadingSpinner: LoadingSpinnerStub
        }
      }
    })
    
    await flushPromises()
    if ((wrapper.vm as any).loadingCatalogs) {
        (wrapper.vm as any).loadingCatalogs = false
        await nextTick()
    }
    
    return wrapper
  }

  it('renders Step 1 initially', async () => {
    const wrapper = await mountComponent()
    expect(wrapper.text()).toContain('Identificación')
    expect(wrapper.text()).toContain('Siguiente Paso')
  })

  it('blocks navigation to Step 2 if Step 1 is invalid', async () => {
    const wrapper = await mountComponent()
    const nextBtn = wrapper.findAll('button').find(b => b.text().includes('Siguiente Paso'))
    await nextBtn?.trigger('click')
    await flushPromises()
    expect(wrapper.text()).toContain('El buque es obligatorio')
  })

  it('navigates to Step 2 when Step 1 is valid', async () => {
    const wrapper = await mountComponent()
    
    Object.assign((wrapper.vm as any).form, {
        buqueId: '1',
        anioMarea: 2025,
        nroMarea: 100
    })
    
    const nextBtn = wrapper.findAll('button').find(b => b.text().includes('Siguiente Paso'))
    await nextBtn?.trigger('click')
    await flushPromises()
    expect(wrapper.text()).toContain('Configuración Operativa')
  })

  it('navigates through all steps and emits success', async () => {
    const wrapper = await mountComponent()
    
    Object.assign((wrapper.vm as any).form, {
        buqueId: '1',
        anioMarea: 2025,
        nroMarea: 100,
        pesqueriaId: '1',
        observadorId: '1',
        arteId: '1',
        fechaZarpadaEstimada: '2025-01-10T00:00:00.000Z',
        tipoMarea: TipoMarea.MC,
        etapas: []
    })
    
    ;(wrapper.vm as any).currentStep = 4
    await nextTick()
    await flushPromises()

    expect(wrapper.text()).toContain('Verificar y Registrar')
    
    // Al usar currentStep = 4 y llamar a nextStep(), se ejecuta el submit final
    console.log('Current Step before nextStep:', (wrapper.vm as any).currentStep)
    await (wrapper.vm as any).nextStep()
    await flushPromises()
    
    console.log('Emitted success:', wrapper.emitted('success'))
    expect(wrapper.emitted('success')).toBeTruthy()
  })
})
