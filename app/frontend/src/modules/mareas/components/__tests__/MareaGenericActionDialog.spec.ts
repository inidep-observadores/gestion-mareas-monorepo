import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import MareaGenericActionDialog from '../MareaGenericActionDialog.vue'

// Stubs
const BaseModalStub = {
    template: '<div class="base-modal-stub"><h3>{{ title }}</h3><slot name="title"></slot><slot></slot><slot name="footer"></slot></div>',
    props: ['show', 'title', 'loading']
}

const ShipIconStub = { template: '<div class="ship-icon-stub"></div>' }
const WarningIconStub = { template: '<div class="warning-icon-stub"></div>' }
const LoadingSpinnerStub = { template: '<div class="loading-spinner-stub"></div>' }
const MareaContextDetailContentStub = {
    template: '<div class="marea-context-stub"></div>',
    props: ['marea', 'context', 'readOnly']
}

describe('MareaGenericActionDialog.vue', () => {
    const defaultProps = {
        show: true,
        marea: {
            id: 'm1',
            id_marea: 'MC-100-24',
            buque_nombre: 'Barco de Prueba',
            observador: 'Juan Perez',
            estado: 'DESIGNADA'
        },
        actionKey: 'REGISTRAR_INICIO',
        actionData: {
            label: 'Iniciar Marea',
            toStateName: 'En Ejecución',
            requiresNotes: true
        },
        loading: false
    }

    const mountComponent = (props = {}) => {
        return mount(MareaGenericActionDialog as any, {
            props: { ...defaultProps, ...props },
            global: {
                plugins: [createTestingPinia({ createSpy: vi.fn })],
                stubs: {
                    BaseModal: BaseModalStub,
                    ShipIcon: ShipIconStub,
                    WarningIcon: WarningIconStub,
                    LoadingSpinner: LoadingSpinnerStub,
                    MareaContextDetailContent: MareaContextDetailContentStub
                }
            }
        })
    }

    it('renders correctly with given props', () => {
        const wrapper = mountComponent()

        expect(wrapper.text()).toContain('Iniciar Marea')
        expect(wrapper.text()).toContain('DESIGNADA')
        expect(wrapper.text()).toContain('En Ejecución')
        expect(wrapper.find('textarea').exists()).toBe(true)
    })

    it('hides notes field if requiresNotes is false', () => {
        const wrapper = mountComponent({
            actionData: {
                ...defaultProps.actionData,
                requiresNotes: false
            }
        })

        expect(wrapper.find('textarea').exists()).toBe(false)
        expect(wrapper.text()).not.toContain('Notas / Observaciones')
    })

    it('shows error if confirmation is clicked without notes when required', async () => {
        const wrapper = mountComponent()

        const confirmBtn = wrapper.findAll('button').find(b => b.text().includes('Confirmar Acción'))
        await confirmBtn?.trigger('click')

        expect(wrapper.text()).toContain('Debe completar las notas')
        expect(wrapper.emitted('confirm')).toBeFalsy()
    })

    it('emits close event when clicking cancel', async () => {
        const wrapper = mountComponent()

        const cancelBtn = wrapper.findAll('button').find(b => b.text().includes('Cancelar'))
        await cancelBtn?.trigger('click')

        expect(wrapper.emitted('close')).toBeTruthy()
    })

    it('emits confirm event with payload when clicking confirm', async () => {
        const wrapper = mountComponent()

        const textarea = wrapper.find('textarea')
        await textarea.setValue('Nota importante')

        const confirmBtn = wrapper.findAll('button').find(b => b.text().includes('Confirmar Acción'))
        await confirmBtn?.trigger('click')

        expect(wrapper.emitted('confirm')).toBeTruthy()
        expect(wrapper.emitted('confirm')?.[0]).toEqual([{ comentarios: 'Nota importante' }])
    })

    it('shows loading state in confirm button', () => {
        const wrapper = mountComponent({ loading: true })

        expect(wrapper.findComponent(LoadingSpinnerStub).exists()).toBe(true)
        const confirmBtn = wrapper.findAll('button').find(b => b.attributes('disabled') !== undefined)
        expect(confirmBtn).toBeDefined()
    })
})
