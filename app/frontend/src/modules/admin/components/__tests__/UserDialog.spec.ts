import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import UserDialog from '../UserDialog.vue'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

// Mocks
// Mock de componentes
const BaseModalStub = {
  template: '<div><slot name="title"></slot><slot></slot></div>',
  props: ['show', 'title']
}

// Mock de servicios/helpers
vi.mock('@/helpers/image.helper', () => ({
  getFullImageUrl: (url: string) => url || 'placeholder'
}))

vi.mock('../services/users.service', () => ({
  default: {
    uploadOnly: vi.fn().mockResolvedValue('uploaded-url')
  }
}))

vi.mock('vue-sonner', () => ({
  toast: {
    error: vi.fn(),
    success: vi.fn()
  }
}))

// Mock de constantes
vi.mock('../constants/roles.constants', () => ({
  ROLES: [
    { id: 'admin', name: 'Administrador' },
    { id: 'asistente_administrativo', name: 'Asistente' }
  ]
}))

describe('UserDialog.vue', () => {
  const defaultProps = {
    show: true,
    user: null,
    isSaving: false
  }

  it('renders "Nuevo Usuario" title when no user passed', () => {
    const wrapper = mount(UserDialog, {
      props: defaultProps,
      global: {
        stubs: { BaseModal: BaseModalStub }
      }
    })
    expect(wrapper.getComponent(BaseModalStub).props('title')).toBe('Nuevo Usuario')
  })

  it('renders "Editar Usuario" title when user passed', () => {
    const wrapper = mount(UserDialog, {
      props: {
        ...defaultProps,
        user: { 
           id: '1', fullName: 'John', email: 'j@d.com', roles: [ValidRoles.admin], isActive: true
        }
      },
      global: {
        stubs: { BaseModal: BaseModalStub }
      }
    })
    expect(wrapper.getComponent(BaseModalStub).props('title')).toBe('Editar Usuario')
  })

  it('requires password for new users', () => {
    const wrapper = mount(UserDialog, {
      props: defaultProps,
      global: {
        stubs: { BaseModal: BaseModalStub }
      }
    })
    const passwordInput = wrapper.find('input[type="password"]')
    expect(passwordInput.exists()).toBe(true)
    expect(passwordInput.attributes('required')).toBeDefined()
  })

  it('does not require password for existing users (optional)', () => {
      const wrapper = mount(UserDialog, {
        props: {
          ...defaultProps,
          user: { 
             id: '1', fullName: 'John', email: 'j@d.com', roles: [ValidRoles.admin], isActive: true
          }
        },
        global: {
          stubs: { BaseModal: BaseModalStub }
        }
      })
      // Por defecto no se muestra el input password en edición hasta que clickeas
      expect(wrapper.find('input[type="password"]').exists()).toBe(false)
      
      // Simulamos click en cambiar password
      wrapper.find('button.text-primary').trigger('click').then(() => {
          const passwordInput = wrapper.find('input[type="password"]')
          expect(passwordInput.exists()).toBe(true)
          // No debe ser required en edición
          expect(passwordInput.attributes('required')).toBeUndefined()
      })
  })

  it('validates at least one role is selected', async () => {
    const { toast } = await import('vue-sonner')
    const wrapper = mount(UserDialog, {
        props: defaultProps,
        global: {
          stubs: { BaseModal: BaseModalStub }
        }
    })

    // Desmarcamos todos los roles (asumiendo que inicia con uno)
    // El componente inicializa roles: [ValidRoles.asistente]
    // Usamos el value correcto del mock
    await wrapper.get('input[type="checkbox"][value="asistente_administrativo"]').setValue(false)
    
    // Submit
    await wrapper.find('form').trigger('submit')
    
    expect(toast.error).toHaveBeenCalledWith('Debe seleccionar al menos un rol')
    expect(wrapper.emitted('save')).toBeUndefined()
  })
})
