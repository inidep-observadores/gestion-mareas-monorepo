import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import RecibirArchivosDialog from '../RecibirArchivosDialog.vue'

// Component Stubs
const DatePickerStub = {
  template: '<input type="text" class="datepicker-stub" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" />',
  props: ['modelValue', 'error']
}

// ConfirmationDialog uses a Teleport which is tricky, we stub it to render in place or just ignore if we don't open it
const ConfirmationDialogStub = {
  template: '<div class="confirmation-stub"></div>',
  props: ['show']
}

describe('RecibirArchivosDialog.vue', () => {
  const defaultProps = {
    show: true,
    marea: {
      id_marea: 'MC-100-24',
      buque_nombre: 'Barco X',
      etapas: [
        { fechaZarpada: '2024-01-10T00:00:00.000Z', puertoZarpada: 'MdP' },
        { fechaArribo: '2024-01-20T00:00:00.000Z', puertoArribo: 'MdP' }
      ]
    }
  }

  const mountComponent = (props = {}) => {
    return mount(RecibirArchivosDialog, {
      props: { ...defaultProps, ...props },
      global: {
        plugins: [createTestingPinia({ createSpy: vi.fn })],
        stubs: {
          DatePicker: DatePickerStub,
          ConfirmationDialog: ConfirmationDialogStub,
          // Icons stubs
          CloudUploadIcon: true,
          PlusIcon: true,
          DocsIcon: true,
          TrashIcon: true,
          HistoryIcon: true,
          SearchIcon: true,
          CheckIcon: true,
          ChatIcon: true,
          CalenderIcon: true
        }
      }
    })
  }

  it('validates start date vs first departure', async () => {
    const wrapper = mountComponent()

    const inputs = wrapper.findAllComponents(DatePickerStub)
    const startDateInput = inputs[0] 

    await (startDateInput.vm as any).$emit('update:modelValue', '2024-01-15T00:00:00.000Z')
    
    // Access computed to trigger side-effect validation
    const _ = (wrapper.vm as any).isValid
    await wrapper.vm.$nextTick()
    
    expect(startDateInput.props('error')).toBeDefined()
    expect(startDateInput.props('error')).toContain('Debe ser <= zarpada')
  })

  it('validates end date vs last arrival', async () => {
    const wrapper = mountComponent()

    const inputs = wrapper.findAllComponents(DatePickerStub)
    const endDateInput = inputs[1]

    await (endDateInput.vm as any).$emit('update:modelValue', '2024-01-15T00:00:00.000Z')
    const _ = (wrapper.vm as any).isValid
    await wrapper.vm.$nextTick()

    expect(endDateInput.props('error')).toContain('Debe ser >= arribo')
  })

  it('validates otolitos range', async () => {
    const wrapper = mountComponent()
    
    const input = wrapper.find('input[type="number"]')
    
    await input.setValue(10)
    const _ = (wrapper.vm as any).isValid
    await wrapper.vm.$nextTick()
    expect(wrapper.text()).not.toContain('La cantidad de otolitos debe estar entre')

    await input.setValue(35)
    const __ = (wrapper.vm as any).isValid
    await wrapper.vm.$nextTick()
    expect(wrapper.text()).toContain('La cantidad de otolitos debe estar entre 1 y 30')
  })

  it('enables button when valid', async () => {
    const wrapper = mountComponent()
    
    const inputs = wrapper.findAllComponents(DatePickerStub)
    
    await (inputs[0].vm as any).$emit('update:modelValue', '2024-01-10T00:00:00.000Z')
    await (inputs[1].vm as any).$emit('update:modelValue', '2024-01-20T00:00:00.000Z')
    await (inputs[2].vm as any).$emit('update:modelValue', '2024-01-21T00:00:00.000Z')
    
    const _ = (wrapper.vm as any).isValid
    await wrapper.vm.$nextTick()
    
    const confirmBtn = wrapper.findAll('button').find(b => b.text().includes('Confirmar'))
    expect(confirmBtn?.attributes('disabled')).toBeUndefined()
  })
})
