import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import EditarMareaView from '../EditarMareaView.vue'
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
    EditIcon: { template: '<span></span>' },
    ArrowLeftIcon: { template: '<span></span>' },
    RefreshIcon: { template: '<span></span>' },
    SettingsIcon: { template: '<span></span>' },
    UserGroupIcon: { template: '<span></span>' }
}))

const ZonaAustralDetalleStub = {
    template: '<div class="zona-austral-detalle-stub"></div>',
    props: ['data']
}

describe('EditarMareaView.vue - Zona Austral Logic', () => {
    const mareaMock = {
        id: 'marea-1',
        idMarea: 'MC-100-24',
        nroMarea: 100,
        anioMarea: 2024,
        tipoCalculoZonaAustral: TipoCalculoZonaAustral.AUTOMATICO,
        diasZonaAustral: 10,
        buqueId: 'b1',
        pesqueriaId: 'p1',
        etapas: []
    }

    const zonaAustralDataMock = {
        mareaId: 'marea-1',
        totalDiasMarea: 10,
        diasDetectadosMarea: [],
        etapas: []
    }

    beforeEach(() => {
        vi.clearAllMocks()
        vi.mocked(mareasService.getById).mockResolvedValue(mareaMock)
        vi.mocked(mareasService.getZonaAustralDays).mockResolvedValue(zonaAustralDataMock)
    })

    const mountComponent = async () => {
        const wrapper = mount(EditarMareaView, {
            global: {
                plugins: [createTestingPinia({ createSpy: vi.fn })],
                stubs: {
                    AdminLayout: { template: '<div><slot></slot></div>' },
                    SearchableSelect: { template: '<div></div>' },
                    ZonaAustralDetalle: ZonaAustralDetalleStub,
                    ConfirmationDialog: { template: '<div></div>' }
                }
            }
        })
        // Esperar a que onMounted cargue los datos
        await vi.dynamicImportSettled()
        await new Promise(resolve => setTimeout(resolve, 0))
        return wrapper
    }

    it('detects MANUAL mode when diasZonaAustral is changed from calculated value', async () => {
        const wrapper = await mountComponent()

            // Change value directly in form (simulating input)
            ; (wrapper.vm as any).form.diasZonaAustral = 15
            ; (wrapper.vm as any).checkManualMode()

        expect((wrapper.vm as any).form.tipoCalculoZonaAustral).toBe(TipoCalculoZonaAustral.MANUAL)
    })

    it('detects AUTOMATICO mode if manual change matches calculated value', async () => {
        const wrapper = await mountComponent()

            // Change to manual first
            ; (wrapper.vm as any).form.diasZonaAustral = 15
            ; (wrapper.vm as any).checkManualMode()
        expect((wrapper.vm as any).form.tipoCalculoZonaAustral).toBe(TipoCalculoZonaAustral.MANUAL)

            // Change back to original calculated value
            ; (wrapper.vm as any).form.diasZonaAustral = 10
            ; (wrapper.vm as any).checkManualMode()
        expect((wrapper.vm as any).form.tipoCalculoZonaAustral).toBe(TipoCalculoZonaAustral.AUTOMATICO)
    })

    it('resets to AUTOMATICO and updates value when loadZonaAustralData is called (Recalcular)', async () => {
        const wrapper = await mountComponent()

            // Simulate manual state
            ; (wrapper.vm as any).form.diasZonaAustral = 15
            ; (wrapper.vm as any).form.tipoCalculoZonaAustral = TipoCalculoZonaAustral.MANUAL

        // Mock new calculation result
        const newCalculation = { ...zonaAustralDataMock, totalDiasMarea: 12 }
        vi.mocked(mareasService.getZonaAustralDays).mockResolvedValue(newCalculation)

        // Execute recalculate
        await (wrapper.vm as any).loadZonaAustralData()

        expect((wrapper.vm as any).form.diasZonaAustral).toBe(12)
        expect((wrapper.vm as any).form.tipoCalculoZonaAustral).toBe(TipoCalculoZonaAustral.AUTOMATICO)
    })
})
