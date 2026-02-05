import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import AlertManagementDialog from '../AlertManagementDialog.vue'
import { nextTick, ref } from 'vue'

// Usar vi.hoisted para variables que necesitamos en vi.mock
const { mockIcon } = vi.hoisted(() => ({
  mockIcon: { template: '<span />' }
}))

// Stubs que no necesitan ser hoisted si se usan en mount() pero sí si se usan en vi.mock de componentes
const BaseModalStub = {
  template: '<div v-if="show" class="modal-stub"><slot name="title" /><slot /></div>',
  props: ['show', 'title']
}

const BadgeStub = {
  template: '<span class="badge-stub"><slot /></span>',
  props: ['color', 'variant', 'size']
}

const ButtonStub = {
  template: '<button class="button-stub" :disabled="disabled" @click="$emit(\'click\')"><slot /></button>',
  props: ['variant', 'size', 'disabled', 'title']
}

const AlertTimelineStub = {
  template: '<div class="timeline-stub" />',
  props: ['eventos']
}

const ConfirmationDialogStub = {
  template: '<div v-if="show" class="conf-stub"><button @click="$emit(\'confirm\')">Confirm</button></div>',
  props: ['show', 'title', 'message']
}

const NuevaMareaDialogStub = {
  template: '<div v-if="show" class="nueva-marea-stub" />',
  props: ['show']
}

const ReclamoEntregaDialogStub = {
  template: '<div v-if="show" class="reclamo-stub" />',
  props: ['show', 'data']
}

const GestionEtapasMareaDialogStub = {
  template: '<div v-if="show" class="etapas-stub" />',
  props: ['show', 'mode', 'marea', 'etapas']
}

// Mocks de servicios con fábricas que no dependen de variables externas no hoisted
vi.mock('../../services/alerts.service', () => ({
  alertsService: {
    getOne: vi.fn(),
    update: vi.fn()
  }
}))

vi.mock('../../../mareas/services/mareas.service', () => ({
  default: {
    getById: vi.fn(),
    getMareaContext: vi.fn(),
    update: vi.fn(),
    executeAction: vi.fn()
  }
}))

vi.mock('../../../dashboard/services/dashboard.service', () => ({
  dashboardService: {
    sendClaim: vi.fn()
  }
}))

vi.mock('../../../admin/services/users.service', () => ({
  default: {
    getUsers: vi.fn()
  }
}))

vi.mock('vue-router', () => ({
  useRouter: vi.fn(() => ({
    push: vi.fn()
  }))
}))

vi.mock('vue-sonner', () => ({
  toast: {
    success: vi.fn(),
    error: vi.fn(),
    info: vi.fn()
  }
}))

vi.mock('@/icons', () => ({
  ChevronRightIcon: mockIcon,
  ChevronLeftIcon: mockIcon,
  CheckIcon: mockIcon,
  DocsIcon: mockIcon,
  RefreshIcon: mockIcon,
  MapPinIcon: mockIcon,
  ShipIcon: mockIcon,
  InfoIcon: mockIcon,
  WaveIcon: mockIcon,
  SettingsIcon: mockIcon,
  BeakerIcon: mockIcon,
  CalenderIcon: mockIcon,
  HistoryIcon: mockIcon,
  WarningIcon: mockIcon,
  TrashIcon: mockIcon,
  ArrowLeftIcon: mockIcon,
  ChevronDownIcon: mockIcon
}))

describe('AlertManagementDialog.vue', () => {
  let pinia: any
  let alertsService: any
  let mareasService: any
  let usersService: any

  const mockAlertData = {
    id: 'alert-123',
    titulo: 'Alerta Test',
    prioridad: 'ALTA',
    estado: 'PENDIENTE',
    tipo: 'POSIBLE_ZARPADA',
    referenciaTipo: 'MAREA',
    referenciaId: 'marea-1',
    descripcion: 'Descripción de prueba',
    fechaDetectada: '2024-01-20T10:00:00Z',
    metadata: {
      mareaCode: 'MC-100-24'
    },
    asignadoA: { id: 'u1', fullName: 'User 1' }
  }

  beforeEach(async () => {
    vi.clearAllMocks()

    // Importar servicios mockeados
    const alertsModule = await import('../../services/alerts.service')
    alertsService = alertsModule.alertsService

    const mareasModule = await import('../../../mareas/services/mareas.service')
    mareasService = mareasModule.default

    const usersModule = await import('../../../admin/services/users.service')
    usersService = usersModule.default

    pinia = createTestingPinia({
      createSpy: vi.fn,
      initialState: {
        businessRules: {
          rules: {
            PLAZO_RECHECK_CORTO: 3,
            PLAZO_RECHECK_MEDIO: 7,
            PLAZO_RECHECK_LARGO: 15
          }
        },
        workflow: {
          activeAlertData: null
        },
        config: {
          availableUsers: [
            { id: 'u1', fullName: 'User 1' },
            { id: 'u2', fullName: 'User 2' }
          ]
        }
      }
    })

    alertsService.getOne.mockResolvedValue(mockAlertData)
    mareasService.getById.mockResolvedValue({ id: 'marea-1', etapas: [] })
    mareasService.getMareaContext.mockResolvedValue({ marea: { observador: 'Obs 1' } })
    usersService.getUsers.mockResolvedValue([
      { id: 'u1', fullName: 'User 1', isActive: true, roles: ['coordinador'] },
      { id: 'u2', fullName: 'User 2', isActive: true, roles: ['tecnico_datos'] }
    ])
  })

  const mountComponent = (props = {}) => {
    return mount(AlertManagementDialog, {
      props: {
        isOpen: true,
        alert: mockAlertData,
        ...props
      },
      global: {
        plugins: [pinia],
        stubs: {
          Teleport: true,
          BaseModal: BaseModalStub,
          Badge: BadgeStub,
          Button: ButtonStub,
          AlertTimeline: AlertTimelineStub,
          ConfirmationDialog: ConfirmationDialogStub,
          NuevaMareaDialog: NuevaMareaDialogStub,
          ReclamoEntregaDialog: ReclamoEntregaDialogStub,
          GestionEtapasMareaDialog: GestionEtapasMareaDialogStub
        }
      }
    })
  }

  it('renders alert details correctly', async () => {
    const wrapper = mountComponent()
    await flushPromises()

    expect(wrapper.text()).toContain('Alerta Test')
    expect(wrapper.text()).toContain('Descripción de prueba')
    expect(wrapper.text()).toContain('User 1')
  })

  it('requires a comment for Seguimiento action', async () => {
    const wrapper = mountComponent()
    await flushPromises()

    const followUpBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Seguimiento'))
    await followUpBtn?.trigger('click')

    const { toast } = await import('vue-sonner')
    expect(toast.error).toHaveBeenCalledWith('Debe ingresar una nota de gestión para continuar.')
  })

  it('allows Seguimiento with a comment', async () => {
    const wrapper = mountComponent()
    await flushPromises()

    // Set comment
    const textarea = wrapper.find('textarea')
    await textarea.setValue('Mi nota de seguimiento')
    // A veces setValue no dispara el evento input necesario para v-model en stubs complejos
    await textarea.trigger('input')
    await flushPromises()

    const followUpBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Seguimiento'))
    await followUpBtn?.trigger('click')
    await flushPromises()

    // El diálogo de confirmación es el SEGUNDO BaseModal en el componente
    const modals = wrapper.findAllComponents(BaseModalStub)
    const confModal = modals.find(m => m.props('title') === 'Confirmar acción')
    expect(confModal?.props('show')).toBe(true)

    // Confirmar pulsando el botón dentro del modal de confirmación
    // El botón de confirmar es el que tiene variant="primary"
    const confirmBtn = confModal?.findAllComponents(ButtonStub).find(b => b.props('variant') === 'primary')
    await confirmBtn?.trigger('click')
    await flushPromises()

    expect(alertsService.update).toHaveBeenCalledWith('alert-123', expect.objectContaining({
      estado: 'SEGUIMIENTO'
    }))
  })

  it('handles assignment change', async () => {
    const wrapper = mountComponent()
    await flushPromises()

    // Click Assign/Change
    const changeBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Cambiar'))
    await changeBtn?.trigger('click')
    await nextTick()

    // Select user u2
    const select = wrapper.find('select')
    await select.setValue('u2')
    await flushPromises()

    // Confirm assignment
    const confirmBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Confirmar'))
    await confirmBtn?.trigger('click')
    await flushPromises()

    expect(alertsService.update).toHaveBeenCalledWith('alert-123', expect.objectContaining({
      asignadoId: 'u2'
    }))
  })

  it('triggers Reclamo dialog for RETRASO_DATOS', async () => {
    const delayAlert = { ...mockAlertData, tipo: 'RETRASO_DATOS' }
    alertsService.getOne.mockResolvedValue(delayAlert)

    const wrapper = mountComponent({ alert: delayAlert })
    await flushPromises()

    const claimBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Enviar Reclamo'))
    expect(claimBtn?.exists()).toBe(true)

    await claimBtn?.trigger('click')
    await flushPromises()

    const reclamoDialog = wrapper.findComponent(ReclamoEntregaDialogStub)
    expect(reclamoDialog.props('show')).toBe(true)
  })

  it('triggers NUEVA_MAREA smart action', async () => {
    const mareaAlert = { ...mockAlertData, metadata: { subTipo: 'NUEVA_MAREA' } }
    alertsService.getOne.mockResolvedValue(mareaAlert)

    const wrapper = mountComponent({ alert: mareaAlert })
    await flushPromises()

    const smartBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Registrar Marea'))
    expect(smartBtn?.exists()).toBe(true)

    await smartBtn?.trigger('click')
    await nextTick()

    const mareaDialog = wrapper.findComponent(NuevaMareaDialogStub)
    expect(mareaDialog.props('show')).toBe(true)
  })

  it('triggers INCONGRUENCIA smart action', async () => {
    const diffAlert = {
      ...mockAlertData,
      tipo: 'ERROR_REGISTRO_PUERTO',
      metadata: { subTipo: 'INCONGRUENCIA', nroEtapa: 1, externalData: { fechaArribo: '2024-01-21' } }
    }
    alertsService.getOne.mockResolvedValue(diffAlert)

    const wrapper = mountComponent({ alert: diffAlert })
    await flushPromises()

    const smartBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Conciliar Datos'))
    expect(smartBtn?.exists()).toBe(true)

    await smartBtn?.trigger('click')
    await flushPromises()

    const stagesDialog = wrapper.findComponent(GestionEtapasMareaDialogStub)
    expect(stagesDialog.props('show')).toBe(true)
    expect(mareasService.getById).toHaveBeenCalledWith('marea-1')
  })

  it('calls executeAction instead of update when confirming stages from alerts', async () => {
    const diffAlert = {
      ...mockAlertData,
      tipo: 'ERROR_REGISTRO_PUERTO',
      metadata: { subTipo: 'INCONGRUENCIA', nroEtapa: 1 }
    }
    alertsService.getOne.mockResolvedValue(diffAlert)

    const wrapper = mountComponent({ alert: diffAlert })
    await flushPromises()

    // Activar el diálogo de etapas
    const smartBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Gestionar Etapas'))
    await smartBtn?.trigger('click')
    await flushPromises()

    // Simular el evento 'confirm' del diálogo de etapas
    const stagesDialog = wrapper.findComponent(GestionEtapasMareaDialogStub)
    expect(stagesDialog.exists()).toBe(true)

    const testData = {
      fechaInicioObservador: '2024-01-20T08:00:00Z',
      fechaFinObservador: null,
      etapas: [{ id: 'e1', nroEtapa: 1, fechaZarpada: '2024-01-20T10:00:00Z' }]
    }

    await stagesDialog.vm.$emit('confirm', testData)
    await flushPromises()

    // VERIFICACIÓN CRÍTICA: Debe llamar a executeAction con EDITAR_ETAPAS y el payload correcto
    expect(mareasService.executeAction).toHaveBeenCalledWith(
      'marea-1',
      'EDITAR_ETAPAS',
      expect.objectContaining(testData)
    )
    // No debe llamar a update para acciones de negocio
    expect(mareasService.update).not.toHaveBeenCalled()
  })

  it('calls executeAction with REGISTRAR_INICIO when in INICIAR mode', async () => {
    const startAlert = {
      ...mockAlertData,
      tipo: 'POSIBLE_ZARPADA',
      metadata: { subTipo: 'ZARPADA' }
    }
    mareasService.getById.mockResolvedValue({
      id: 'marea-1',
      estadoActual: { codigo: 'DESIGNADA' },
      etapas: [],
      buque: { nombreBuque: 'Test Buque' }
    })

    const wrapper = mountComponent({ alert: startAlert })
    await flushPromises()
    await flushPromises() // Segunda vez para asegurar carga de mareaData

    const smartBtn = wrapper.findAll('.button-stub').find(b => b.text().includes('Registrar Inicio'))
    expect(smartBtn?.exists()).toBe(true)
    await smartBtn?.trigger('click')
    await flushPromises()

    const stagesDialog = wrapper.findComponent(GestionEtapasMareaDialogStub)
    await stagesDialog.vm.$emit('confirm', { fechaInicioObservador: '2024-01-20', etapas: [] })
    await flushPromises()

    expect(mareasService.executeAction).toHaveBeenCalledWith(
      'marea-1',
      'REGISTRAR_INICIO',
      expect.any(Object)
    )
  })
})
