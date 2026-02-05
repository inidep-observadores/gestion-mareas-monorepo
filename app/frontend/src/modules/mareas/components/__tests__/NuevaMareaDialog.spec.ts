import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import NuevaMareaDialog from '../NuevaMareaDialog.vue'
import { TipoMarea } from '../../types/enums'
import { nextTick, ref } from 'vue'
import { useConfigStore } from '../../../shared/stores/config.store'
import { useWorkflowStore } from '../../../shared/stores/workflow.store'
import mareasService from '../../services/mareas.service'
import catalogosService from '../../services/catalogos.service'

// Stubs
const DatePickerStub = {
  template: '<div class="datepicker-stub-container"><input type="text" class="datepicker-stub" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" /><span v-if="error" class="error-msg">{{ error }}</span></div>',
  props: ['modelValue', 'error'],
  methods: {
    focus() { /* stub */ }
  }
}

const SearchableSelectStub = {
  template: '<div class="select-stub-container"><select class="select-stub" :value="modelValue" @change="$emit(\'update:modelValue\', $event.target.value)"><slot></slot></select><span v-if="error" class="error-msg">{{ error }}</span></div>',
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

// Mock de servicios
vi.mock('../../services/catalogos.service', () => ({
  default: {
    getBuques: vi.fn(),
    getPesquerias: vi.fn(),
    getObservadores: vi.fn(),
    getArtesPesca: vi.fn(),
    getPuertos: vi.fn()
  }
}))

vi.mock('../../services/mareas.service', () => ({
  default: {
    create: vi.fn(),
    getDashboardOperativo: vi.fn(),
    getMareaContext: vi.fn(),
    validateVesselAvailability: vi.fn(),
    validateObserverAvailability: vi.fn(),
    getNextMareaNumber: vi.fn()
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

  beforeEach(() => {
    vi.clearAllMocks()

    // Mocks de servicios con valores por defecto
    vi.mocked(catalogosService.getBuques).mockResolvedValue([{ id: '1', nombreBuque: 'Barco A', pesqueriaHabitualId: '1', matricula: '123' }] as any)
    vi.mocked(catalogosService.getPesquerias).mockResolvedValue([{ id: '1', nombre: 'Pesqueria A' }])
    vi.mocked(catalogosService.getObservadores).mockResolvedValue([{ id: '1', nombre: 'Obs', apellido: 'A', conImpedimento: false }])
    vi.mocked(catalogosService.getArtesPesca).mockResolvedValue([{ id: '1', nombre: 'Arte A' }])
    vi.mocked(catalogosService.getPuertos).mockResolvedValue([{ id: '1', nombre: 'Puerto A' }])

    vi.mocked(mareasService.getNextMareaNumber).mockResolvedValue(100)
    vi.mocked(mareasService.validateVesselAvailability).mockResolvedValue({ available: true, marea: null })
    vi.mocked(mareasService.validateObserverAvailability).mockResolvedValue({ available: true, marea: null })
    vi.mocked(mareasService.getDashboardOperativo).mockResolvedValue({ kpis: [], items: [] })
    vi.mocked(mareasService.getMareaContext).mockResolvedValue({ marea: {} as any, actions: {}, lastEvents: [] })
    vi.mocked(mareasService.create).mockResolvedValue({ id: 'new-id', id_marea: 'MC-100-24' })
  })

  const mountComponent = async (props = {}) => {
    const pinia = createTestingPinia({
      createSpy: vi.fn,
      initialState: {
        config: { selectedYear: 2025 }
      },
      stubActions: false
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
    const vm = wrapper.vm as any
    if (vm.loadingCatalogs) {
      vm.loadingCatalogs = false
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
    const vm = wrapper.vm as any

    vm.form.buqueId = ''
    vm.form.anioMarea = 2025
    vm.form.nroMarea = null

    await vm.nextStep()
    await flushPromises()
    await nextTick()

    expect(vm.fieldErrors.buqueId).toBeTruthy()
    expect(vm.currentStep).toBe(1)
  })

  it('navigates to Step 2 when Step 1 is valid', async () => {
    const wrapper = await mountComponent()
    const vm = wrapper.vm as any

    // Forzar valores en el store y el form
    const configStore = useConfigStore()
    configStore.selectedYear = 2025
    vm.form.anioMarea = 2025
    vm.form.tipoMarea = TipoMarea.MC
    vm.form.buqueId = '1'
    vm.form.nroMarea = 100

    await flushPromises()
    await nextTick()

    await vm.nextStep()

    // Esperar a que TODAS las promesas se resuelvan (incluyendo las de validateStep)
    await flushPromises()
    await nextTick()
    await flushPromises()
    await nextTick()

    expect(vm.currentStep).toBe(2)
  })

  it('navigates through all steps and emits success', async () => {
    const wrapper = await mountComponent()
    const vm = wrapper.vm as any

    const configStore = useConfigStore()
    configStore.selectedYear = 2025

    Object.assign(vm.form, {
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

    await flushPromises()
    await nextTick()

    vm.currentStep = 4
    await nextTick()
    await flushPromises()

    await vm.nextStep()
    await flushPromises()
    await nextTick()
    await flushPromises()

    expect(wrapper.emitted('success')).toBeTruthy()
  })
})
