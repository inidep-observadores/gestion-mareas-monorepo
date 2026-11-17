import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import ReemplazarInformeDialog from '../ReemplazarInformeDialog.vue'

const BaseModalStub = {
  template: '<div class="base-modal-stub"><h3>{{ title }}</h3><slot></slot></div>',
  props: ['show', 'title', 'loading']
}

const ShipIconStub = { template: '<div class="ship-icon-stub"></div>' }
const WarningIconStub = { template: '<div class="warning-icon-stub"></div>' }
const RefreshIconStub = { template: '<div class="refresh-icon-stub"></div>' }
const DocsIconStub = { template: '<div class="docs-icon-stub"></div>' }
const LoadingSpinnerStub = { template: '<div class="loading-spinner-stub"></div>' }

describe('ReemplazarInformeDialog.vue', () => {
  const defaultProps = {
    show: true,
    marea: {
      id: 'm1',
      id_marea: 'MC-100-24',
      buque_nombre: 'Barco de Prueba',
      observador: 'Juan Perez',
      estado: 'Para Protocolizar',
      informeAprobado: {
        nombre: 'informe_original.docx'
      }
    },
    loading: false
  }

  const mountComponent = (props = {}) => {
    return mount(ReemplazarInformeDialog as any, {
      props: { ...defaultProps, ...props },
      global: {
        plugins: [createTestingPinia({ createSpy: vi.fn })],
        stubs: {
          BaseModal: BaseModalStub,
          ShipIcon: ShipIconStub,
          WarningIcon: WarningIconStub,
          RefreshIcon: RefreshIconStub,
          DocsIcon: DocsIconStub,
          LoadingSpinner: LoadingSpinnerStub
        },
        directives: {
          'form-nav': {}
        }
      }
    })
  }

  it('renderiza la información de la marea y el archivo actual', () => {
    const wrapper = mountComponent()

    expect(wrapper.text()).toContain('Reemplazar Informe de Marea')
    expect(wrapper.text()).toContain('MC-100-24')
    expect(wrapper.text()).toContain('Barco de Prueba')
    expect(wrapper.text()).toContain('informe_original.docx')
    expect(wrapper.find('textarea').exists()).toBe(true)
  })

  it('muestra error si se intenta confirmar sin adjuntar archivo ni motivo', async () => {
    const wrapper = mountComponent()

    const confirmBtn = wrapper.findAll('button').find(b => b.text().includes('Confirmar Reemplazo'))
    await confirmBtn?.trigger('click')

    expect(wrapper.text()).toContain('Debe adjuntar el nuevo archivo (.docx)')
    expect(wrapper.text()).toContain('Es obligatorio indicar el motivo')
    expect(wrapper.emitted('confirm')).toBeFalsy()
  })

  it('emite el evento confirm con archivo y motivo cuando ambos son provistos', async () => {
    const wrapper = mountComponent()

    const file = new File(['test content'], 'informe_corregido.docx', {
      type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    })

    const input = wrapper.find('input[type="file"]')
    Object.defineProperty(input.element, 'files', {
      value: [file]
    })
    await input.trigger('change')

    const textarea = wrapper.find('textarea')
    await textarea.setValue('Corrección de errores tipográficos')

    const confirmBtn = wrapper.findAll('button').find(b => b.text().includes('Confirmar Reemplazo'))
    await confirmBtn?.trigger('click')

    expect(wrapper.emitted('confirm')).toBeTruthy()
    expect(wrapper.emitted('confirm')?.[0]).toEqual([file, 'Corrección de errores tipográficos'])
  })

  it('emite el evento close al hacer clic en Cancelar', async () => {
    const wrapper = mountComponent()

    const cancelBtn = wrapper.findAll('button').find(b => b.text().includes('Cancelar'))
    await cancelBtn?.trigger('click')

    expect(wrapper.emitted('close')).toBeTruthy()
  })
})
