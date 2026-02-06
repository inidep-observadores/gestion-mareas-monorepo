import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import MareaDetalleView from '../MareaDetalleView.vue'
import mareasService from '../../services/mareas.service'
import catalogosService from '../../services/catalogos.service'
import { TipoCalculoZonaAustral } from '../../types/marea.types'

// Stubs y Mocks
vi.mock('vue-router', () => ({
    useRoute: () => ({ params: { id: 'marea-1' } }),
    useRouter: () => ({ back: vi.fn() })
}))

vi.mock('vue-sonner', () => ({
    toast: { success: vi.fn(), error: vi.fn() }
}))

vi.mock('../../services/mareas.service', () => ({
    default: {
        getById: vi.fn(),
        getZonaAustralDays: vi.fn(),
        update: vi.fn()
    }
}))

vi.mock('../../services/catalogos.service', () => ({
    default: {
        getBuques: vi.fn().mockResolvedValue([]),
        getPesquerias: vi.fn().mockResolvedValue([]),
        getArtesPesca: vi.fn().mockResolvedValue([]),
        getObservadores: vi.fn().mockResolvedValue([]),
        getPuertos: vi.fn().mockResolvedValue([])
    }
}))

vi.mock('@/icons', () => ({
    ArrowLeftIcon: { template: '<span></span>' },
    ShipIcon: { template: '<span></span>' },
    BeakerIcon: { template: '<span></span>' },
    DocsIcon: { template: '<span></span>' },
    CheckIcon: { template: '<span></span>' },
    CalenderIcon: { template: '<span></span>' },
    PlusIcon: { template: '<span></span>' },
    SettingsIcon: { template: '<span></span>' },
    UserCircleIcon: { template: '<span></span>' },
    HistoryIcon: { template: '<span></span>' },
    MapPinIcon: { template: '<span></span>' },
    FileTextIcon: { template: '<span></span>' },
    InfoIcon: { template: '<span></span>' },
    RefreshIcon: { template: '<span></span>' },
    InfoCircleIcon: { template: '<span></span>' },
    BellIcon: { template: '<span></span>' },
    EditIcon: { template: '<span></span>' }
}))

const ZonaAustralDetalleStub = {
    template: '<div class="zona-austral-detalle-stub"></div>',
    props: ['data']
}

describe('MareaDetalleView.vue - Zona Austral Logic', () => {
    const mareaBackendMock = {
        id: 'marea-1',
        anioMarea: 2024,
        nroMarea: 100,
        buqueId: 'b1',
        pesqueriaId: 'p1',
        diasZonaAustral: 8, // CamelCase from API
        tipoCalculoZonaAustral: TipoCalculoZonaAustral.AUTOMATICO,
        etapas: []
    }

    const zonaAustralDataMock = {
        mareaId: 'marea-1',
        totalDiasMarea: 8,
        diasDetectadosMarea: [],
        etapas: []
    }

    beforeEach(() => {
        vi.clearAllMocks()
        vi.mocked(mareasService.getById).mockResolvedValue(mareaBackendMock)
        vi.mocked(mareasService.getZonaAustralDays).mockResolvedValue(zonaAustralDataMock)
    })

    const mountComponent = async () => {
        const wrapper = mount(MareaDetalleView, {
            global: {
                plugins: [createTestingPinia({ createSpy: vi.fn })],
                stubs: {
                    AdminLayout: { template: '<div><slot></slot></div>' },
                    SearchableSelect: { template: '<div></div>' },
                    DatePicker: { template: '<div></div>' },
                    ZonaAustralDetalle: ZonaAustralDetalleStub,
                    ConfirmationDialog: { template: '<div></div>' },
                    AlertHistoryTab: { template: '<div></div>' },
                    GestionEtapasMareaDialog: { template: '<div></div>' },
                    NavigationStagesEditor: { template: '<div></div>' }
                }
            }
        })
        await vi.dynamicImportSettled()
        await new Promise(resolve => setTimeout(resolve, 0))
        return wrapper
    }

    it('correctly maps backend camelCase to local snake_case', async () => {
        const wrapper = await mountComponent()

        expect((wrapper.vm as any).marea.dias_zona_austral).toBe(8)
        expect((wrapper.vm as any).marea.tipo_calculo_zona_austral).toBe(TipoCalculoZonaAustral.AUTOMATICO)
    })

    it('detects MANUAL mode when dias_zona_austral is changed', async () => {
        const wrapper = await mountComponent()

            ; (wrapper.vm as any).marea.dias_zona_austral = 12
            ; (wrapper.vm as any).checkManualMode()

        expect((wrapper.vm as any).marea.tipo_calculo_zona_austral).toBe(TipoCalculoZonaAustral.MANUAL)
    })

    it('resets to AUTOMATICO and updates value on recalculate', async () => {
        const wrapper = await mountComponent()

            // Set to manual
            ; (wrapper.vm as any).marea.dias_zona_austral = 12
            ; (wrapper.vm as any).marea.tipo_calculo_zona_austral = TipoCalculoZonaAustral.MANUAL

        // Mock new calc
        const newCalc = { ...zonaAustralDataMock, totalDiasMarea: 10 }
        vi.mocked(mareasService.getZonaAustralDays).mockResolvedValue(newCalc)

        await (wrapper.vm as any).loadZonaAustralData()

        expect((wrapper.vm as any).marea.dias_zona_austral).toBe(10)
        expect((wrapper.vm as any).marea.tipo_calculo_zona_austral).toBe(TipoCalculoZonaAustral.AUTOMATICO)
    })
})
