import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import FinalizarProtocolizacionDialog from '../FinalizarProtocolizacionDialog.vue'

// Mocks
vi.mock('vue-sonner', () => ({
    toast: {
        error: vi.fn(),
        success: vi.fn()
    }
}))

// Stubs
const BaseModalStub = {
    template: '<div class="base-modal-stub"><h3>{{ title }}</h3><slot></slot></div>',
    props: ['show', 'title', 'loading']
}

const ShipIconStub = { template: '<div class="ship-icon-stub"></div>' }
const LoadingSpinnerStub = { template: '<div class="loading-spinner-stub"></div>' }
const DatePickerStub = {
    template: '<div class="date-picker-stub"><input type="text" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" /></div>',
    props: ['modelValue', 'showTime', 'placeholder', 'error']
}

describe('FinalizarProtocolizacionDialog.vue', () => {
    const defaultProps = {
        show: true,
        marea: {
            id: 'm1',
            id_marea: 'MC-100-24',
            buque_nombre: 'Barco de Prueba',
            observador: 'Juan Perez',
            estado: 'ESPERANDO_PROTOCOLIZACION'
        },
        loading: false
    }

    const mountComponent = (props = {}) => {
        return mount(FinalizarProtocolizacionDialog as any, {
            props: { ...defaultProps, ...props },
            global: {
                plugins: [createTestingPinia({ createSpy: vi.fn })],
                stubs: {
                    BaseModal: BaseModalStub,
                    ShipIcon: ShipIconStub,
                    LoadingSpinner: LoadingSpinnerStub,
                    DatePicker: DatePickerStub
                }
            }
        })
    }

    it('renders correctly with given props', () => {
        const wrapper = mountComponent()

        expect(wrapper.text()).toContain('Finalizar Protocolización')
        expect(wrapper.text()).toContain('MC-100-24')
        expect(wrapper.text()).toContain('Barco de Prueba')
        expect(wrapper.find('[data-test="nro-protocolo"]').exists()).toBe(true)
        expect(wrapper.findComponent(DatePickerStub).exists()).toBe(true)
    })

    it('validates required fields before emitting confirm and disables button', async () => {
        const wrapper = mountComponent()

        // Button should be disabled initially
        const confirmBtn = wrapper.find('[data-test="confirm-btn"]')
        expect(confirmBtn.attributes('disabled')).toBeDefined()

        // Fill fields but leave one empty
        await wrapper.find('[data-test="nro-protocolo"]').setValue(456)
        expect(confirmBtn.attributes('disabled')).toBeDefined()

        await wrapper.find('[data-test="anio-protocolo"]').setValue(2025)
        expect(confirmBtn.attributes('disabled')).toBeDefined()

        const datePicker = wrapper.findComponent(DatePickerStub)
        await datePicker.vm.$emit('update:modelValue', '2025-03-20')
        
        // Now it should be enabled
        expect(confirmBtn.attributes('disabled')).toBeUndefined()
    })

    it('shows error if protocolization date is before marea end date', async () => {
        const mareaWithEndDate = {
            ...defaultProps.marea,
            fechaFinObservador: '2025-03-25T10:00:00Z'
        }
        const wrapper = mountComponent({ marea: mareaWithEndDate })

        // Fill fields with date BEFORE marea end date
        await wrapper.find('[data-test="nro-protocolo"]').setValue(456)
        await wrapper.find('[data-test="anio-protocolo"]').setValue(2025)
        await wrapper.findComponent(DatePickerStub).vm.$emit('update:modelValue', '2025-03-20') // Before 25th

        const confirmBtn = wrapper.find('[data-test="confirm-btn"]')
        await confirmBtn.trigger('click')

        expect(wrapper.emitted('confirm')).toBeFalsy()
        // La clase border-error se aplica al input del nro/anio o al DatePicker (en el componente real)
        // En el stub de DatePicker, pasamos el prop 'error'
        expect(wrapper.findComponent(DatePickerStub).props('error')).not.toBe('')
    })

    it('emits confirm event with correct payload when valid', async () => {
        const mareaWithEndDate = {
            ...defaultProps.marea,
            fechaFinObservador: '2025-03-15T10:00:00Z'
        }
        const wrapper = mountComponent({ marea: mareaWithEndDate })

        // Fill fields
        await wrapper.find('[data-test="nro-protocolo"]').setValue(456)
        await wrapper.find('[data-test="anio-protocolo"]').setValue(2025)
        await wrapper.findComponent(DatePickerStub).vm.$emit('update:modelValue', '2025-03-20') // After 15th

        const textarea = wrapper.find('textarea')
        await textarea.setValue('Todo OK')

        const confirmBtn = wrapper.find('[data-test="confirm-btn"]')
        await confirmBtn.trigger('click')

        expect(wrapper.emitted('confirm')).toBeTruthy()
        expect(wrapper.emitted('confirm')?.[0][0]).toEqual({
            nroProtocolizacion: 456,
            anioProtocolizacion: 2025,
            fechaProtocolizacion: '2025-03-20',
            comentarios: 'Todo OK'
        })
    })

    it('emits close event when clicking cancel', async () => {
        const wrapper = mountComponent()

        const cancelBtn = wrapper.findAll('button').find(b => b.text().includes('Cancelar'))
        await cancelBtn?.trigger('click')

        expect(wrapper.emitted('close')).toBeTruthy()
    })
})
