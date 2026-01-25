import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import ObservadorDialog from '../ObservadorDialog.vue'

// Mocks
const BaseModalStub = {
  template: '<div><slot name="title"></slot><slot></slot></div>',
  props: ['show', 'title']
}

const SearchableSelectStub = {
  template: '<select></select>',
  props: ['options', 'modelValue', 'error']
}

const DatePickerStub = {
  template: '<input type="date" />',
  props: ['modelValue', 'error']
}

vi.mock('@/helpers/image.helper', () => ({
  getFullImageUrl: (url: string) => url || 'placeholder'
}))

vi.mock('../services/observadores.service', () => ({
  default: {
    uploadFoto: vi.fn().mockResolvedValue('uploaded-url')
  }
}))

vi.mock('vue-sonner', () => ({
  toast: {
    error: vi.fn(),
    success: vi.fn()
  }
}))

describe('ObservadorDialog.vue', () => {
  const defaultProps = {
    show: true,
    observador: null,
    isSaving: false
  }

  // Helper to mount component
  const mountComponent = (props = {}) => {
    return mount(ObservadorDialog, {
      props: { ...defaultProps, ...props },
      global: {
        stubs: {
          BaseModal: BaseModalStub,
          SearchableSelect: SearchableSelectStub,
          DatePicker: DatePickerStub
        }
      }
    })
  }

  it('renders correctly', () => {
    const wrapper = mountComponent()
    expect(wrapper.getComponent(BaseModalStub).props('title')).toBe('Nuevo Observador')
  })

  it('validates required fields', async () => {
    const { toast } = await import('vue-sonner')
    const wrapper = mountComponent()
    
    // Trigger submit empty
    await wrapper.find('form').trigger('submit')
    
    expect(toast.error).toHaveBeenCalledWith('Por favor, revise los errores en el formulario')
    
    // Validamos que aparezcan los mensajes de error (esto depende de cómo se renderizan los errores en el componente)
    // El componente usa <p v-if="fieldErrors.nombre">...</p>
    // Al fallar validate(), fieldErrors se llena.
    
    // Podemos verificar el estado interno si el componente lo expone, o buscar el texto en el DOM
    expect(wrapper.text()).toContain('El código interno es obligatorio')
    expect(wrapper.text()).toContain('El nombre es obligatorio')
    expect(wrapper.text()).toContain('El apellido es obligatorio')
  })

  it('validates email format', async () => {
    const wrapper = mountComponent()
    
    const emailInput = wrapper.find('input[type="email"]')
    await emailInput.setValue('invalid-email')
    
    await wrapper.find('form').trigger('submit')
    
    expect(wrapper.text()).toContain('El formato del email no es válido')
  })

  it('validates motivoImpedimento if conImpedimento is true', async () => {
    const wrapper = mountComponent()
    
    // Buscamos el checkbox "Con Impedimento". 
    // En el template es: input v-model="form.conImpedimento"
    // Hay 3 checkboxes. Una forma segura es buscar por el texto del label asociado.
    
    const labels = wrapper.findAll('label')
    const impedimentoLabel = labels.find(l => l.text().includes('Con Impedimento'))
    // Asumiendo que el input está dentro del label o asociado
    const checkbox = impedimentoLabel?.find('input[type="checkbox"]')
    
    expect(checkbox?.exists()).toBe(true)
    await checkbox?.setValue(true)
    
    // Ahora debería aparecer el input de motivo
    const motivoInput = wrapper.find('input[placeholder*="Describa el motivo"]')
    expect(motivoInput.exists()).toBe(true)
    
    await wrapper.find('form').trigger('submit')
    expect(wrapper.text()).toContain('El motivo de impedimento es obligatorio')
  })

  it('emits save if form is valid', async () => {
    const wrapper = mountComponent()
    
    // Llenar campos requeridos
    const inputs = wrapper.findAll('input')
    
    // Codigo Interno (number)
    // El primer input type=number suele ser codigoInterno
    const numberInput = wrapper.find('input[type="number"]')
    await numberInput.setValue(123)
    
    // Nombre y Apellido (text)
    // Buscamos inputs específicos
    // Un hack rápido es setear todos los requeridos si sabemos el orden, o por selectores aproximados
    // Pero mejor interactuar con el wrapper.vm o buscar por labels si fuera e2e.
    // Como es unit, buscaremos los inputs. 
    // CodigoInterno (ya seteado)
    // Email (opcional, dejamos vacio)
    // Nombre
    // Apellido
    
    // Nombre es el input después de email en el grid
    // Apellido el siguiente
    
    // En el template:
    // 1. Codigo Interno
    // 2. Email
    // 3. Nombre
    // 4. Apellido
    
    const textInputs = wrapper.findAll('input[type="text"]')
    // Segun template:
    // [0]: Nombre ? No, el type=number es codigo. Email es type=email.
    // Nombre es text. Apellido es text.
    
    if (textInputs.length >= 2) {
        await textInputs[0].setValue('Juan')
        await textInputs[1].setValue('Perez')
    }

    await wrapper.find('form').trigger('submit')
    
    // Verificar que NO hay errores
    expect(wrapper.find('.text-error').exists()).toBe(false)
    
    expect(wrapper.emitted('save')).toBeTruthy()
    expect(wrapper.emitted('save')?.[0][0]).toMatchObject({
        codigoInterno: 123,
        nombre: 'Juan',
        apellido: 'Perez'
    })
  })
})
