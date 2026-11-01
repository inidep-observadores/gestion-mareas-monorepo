import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import ObservadorAvatar from '../ObservadorAvatar.vue'
import ObservadorQuickModal from '@/modules/admin/components/ObservadorQuickModal.vue'
import observadoresApi from '@/modules/admin/services/observadores.service'

vi.mock('@/composables/useSidebar', () => ({
  useSidebar: () => ({
    isExpanded: { value: false },
    isHovered: { value: false },
    isMobileOpen: { value: false },
  })
}))

vi.mock('@/modules/admin/services/observadores.service', () => ({
  default: {
    getObservador: vi.fn(),
  }
}))

describe('ObservadorAvatar.vue', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renderiza avatar básico no clickeable cuando no tiene observador asignado', () => {
    const wrapper = mount(ObservadorAvatar, {
      props: {
        nombre: 'Sin asignar',
        fotoUrl: null,
      }
    })

    expect(wrapper.find('div').classes()).not.toContain('cursor-pointer')
    expect(wrapper.findComponent(ObservadorQuickModal).exists()).toBe(false)
  })

  it('hace clickeable el avatar si se pasa un observadorId y abre el modal al hacer clic', async () => {
    const wrapper = mount(ObservadorAvatar, {
      props: {
        nombre: 'Terrén, Darío Nicolás',
        observadorId: 'obs-123',
        size: 'lg'
      }
    })

    const avatarDiv = wrapper.find('div')
    expect(avatarDiv.classes()).toContain('cursor-pointer')

    // Al hacer clic, debe abrir el modal
    await avatarDiv.trigger('click')
    expect(wrapper.findComponent(ObservadorQuickModal).exists()).toBe(true)
    expect(wrapper.findComponent(ObservadorQuickModal).props('show')).toBe(true)
  })

  it('utiliza los datos pasados en la prop observador sin requerir fetch extra', async () => {
    const observadorData = {
      id: 'obs-456',
      codigoInterno: 9467,
      dni: '30.123.456',
      nombre: 'Pablo Julian',
      apellido: 'Miranda',
      numeroCedula: 12345,
      vencimientoCedula: '2026-12-31T00:00:00.000Z',
      vencimientoAptoMedico: '2026-11-30T00:00:00.000Z'
    }

    const wrapper = mount(ObservadorAvatar, {
      props: {
        nombre: 'Miranda, Pablo Julian',
        observador: observadorData,
        observadorId: observadorData.id
      }
    })

    await wrapper.find('div').trigger('click')
    const modal = wrapper.findComponent(ObservadorQuickModal)
    expect(modal.exists()).toBe(true)

    // El servicio no debe ser llamado porque ya tenemos datos completos
    expect(observadoresApi.getObservador).not.toHaveBeenCalled()
  })
})
