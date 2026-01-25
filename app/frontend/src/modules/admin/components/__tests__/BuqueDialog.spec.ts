import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import BuqueDialog from '../BuqueDialog.vue'

// Mock de componentes secundarios para aislar la prueba
const BaseModalStub = {
  template: '<div><slot name="title"></slot><slot></slot></div>',
  props: ['show', 'title']
}

const SearchableSelectStub = {
  template: '<select></select>',
  props: ['options', 'modelValue']
}

describe('BuqueDialog.vue', () => {
  const defaultProps = {
    show: true,
    tiposFlota: [{ id: '1', nombre: 'Flota A' }],
    puertos: [{ id: '1', nombre: 'Puerto A' }],
    pesquerias: [{ id: '1', nombre: 'Pesqueria A' }],
    artesPesca: [{ id: '1', nombre: 'Arte A' }],
    isSaving: false,
    buque: null
  }

  it('renders correct title for new buque', () => {
    const wrapper = mount(BuqueDialog, {
      props: defaultProps,
      global: {
        stubs: {
          BaseModal: BaseModalStub,
          SearchableSelect: SearchableSelectStub
        }
      }
    })

    // Como BaseModal está stubbed, buscamos en el contenido renderizado
    // El componente original pasa el título como prop al BaseModal
    expect(wrapper.getComponent(BaseModalStub).props('title')).toBe('Nuevo Buque')
  })

  it('renders correct title for editing buque', () => {
    const wrapper = mount(BuqueDialog, {
      props: {
        ...defaultProps,
        buque: { id: '123', nombreBuque: 'Barco Test', matricula: 'XYZ', activo: true }
      },
      global: {
        stubs: {
          BaseModal: BaseModalStub,
          SearchableSelect: SearchableSelectStub
        }
      }
    })

    expect(wrapper.getComponent(BaseModalStub).props('title')).toBe('Editar Buque')
  })

  it('disables submit button when isSaving is true', async () => {
    const wrapper = mount(BuqueDialog, {
      props: {
        ...defaultProps,
        isSaving: true
      },
      global: {
        stubs: {
          BaseModal: BaseModalStub,
          SearchableSelect: SearchableSelectStub
        }
      }
    })

    const saveButton = wrapper.find('button[type="submit"]')
    expect(saveButton.exists()).toBe(true)
    expect(saveButton.attributes('disabled')).toBeDefined()
    expect(saveButton.text()).toBe('Guardando...')
  })

  it('validates required fields logic', async () => {
    // Nota: La validación HTML5 no es fácil de probar con jsdom sin disparar eventos submit reales
    // y verificar checkValidity(), pero podemos verificar que los atributos existan.
    
    const wrapper = mount(BuqueDialog, {
      props: defaultProps,
      global: {
        stubs: {
          BaseModal: BaseModalStub,
          SearchableSelect: SearchableSelectStub
        }
      }
    })

    const nombreInput = wrapper.find('input[type="text"]') 
    // Buscamos inputs específicos. El primero suele ser nombreBuque en el layout
    // Mejor usaremos selectores más específicos si es posible o verificamos por v-model (que no se ve en DOM compilado fácil)
    // Verificamos por proximidad o suposición de orden del template:
    // 1. Nombre Buque
    // 2. Matrícula
    
    // Una estrategia mejor buscar por labels si tuvieran 'for', pero aquí buscaremos todos los inputs
    const inputs = wrapper.findAll('input[type="text"]')
    const nombreBuqueInput = inputs[0] // Asumiendo orden del template
    
    expect(nombreBuqueInput.attributes('required')).toBeDefined()
  })
})
