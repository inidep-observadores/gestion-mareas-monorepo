import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import BatchProcessDialog from '../BatchProcessDialog.vue'

describe('BatchProcessDialog.vue', () => {
    const mockResults = {
        total: 3,
        processed: 2,
        details: [
            { id: '1', titulo: 'Alerta OK', status: 'CONFIRMED' },
            { id: '2', titulo: 'Alerta Skip', status: 'SKIPPED', reason: 'Fuentes insuficientes' },
            { id: '3', titulo: 'Alerta Error', status: 'ERROR', reason: 'Fallo DB' }
        ]
    }

    const mountComponent = (props = {}) => {
        return mount(BatchProcessDialog, {
            props: {
                visible: true,
                isProcessing: false,
                results: null,
                ...props
            },
            global: {
                stubs: {
                    ConfirmationDialog: {
                        template: '<div v-if="show"><slot /><slot name="footer" /></div>',
                        props: ['show']
                    },
                    RefreshIcon: true,
                    SuccessIcon: true,
                    WarningIcon: true,
                    XIcon: true,
                    ChevronDownIcon: true
                }
            }
        })
    }

    it('renders processing state correctly', () => {
        const wrapper = mountComponent({ isProcessing: true })
        expect(wrapper.text()).toContain('analizando las alertas')
    })

    it('renders results summary when processing finished', () => {
        const wrapper = mountComponent({ isProcessing: false, results: mockResults })

        // Check summary stats (2 confirmed, 1 skipped/error)
        expect(wrapper.text()).toContain('2')
        expect(wrapper.text()).toContain('1')
    })

    it('toggles details visibility', async () => {
        const wrapper = mountComponent({ isProcessing: false, results: mockResults })

        // Find toggle button
        const toggleBtn = wrapper.findAll('button').find(b => b.text().includes('Ver Detalles'))
        expect(toggleBtn).toBeDefined()

        // Click toggle button
        await toggleBtn!.trigger('click')

        // verify text appearance instead of visibility style
        expect(wrapper.text()).toContain('Alerta OK')
        expect(toggleBtn!.text()).toContain('Ocultar Detalles')
    })

    it('emits close event when clicking Entendido', async () => {
        const wrapper = mountComponent({ isProcessing: false, results: mockResults })

        // The "Entendido" button is the last button in the footer
        const closeBtn = wrapper.find('button.bg-primary')
        await closeBtn.trigger('click')

        expect(wrapper.emitted('close')).toBeTruthy()
    })
})
