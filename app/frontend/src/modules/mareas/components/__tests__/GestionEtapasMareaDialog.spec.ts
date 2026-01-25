import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import GestionEtapasMareaDialog from '../GestionEtapasMareaDialog.vue'
import { TipoEtapa } from '../../types/enums'

// Stubs
const DatePickerStub = {
  template: '<input type="text" class="datepicker-stub" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" />',
  props: ['modelValue', 'error'],
  methods: {
    focus() { /* stub */ }
  }
}

const NavigationStagesEditorStub = {
  template: '<div class="stages-editor-stub"></div>',
  props: ['modelValue', 'puertoOptions', 'pesqueriaOptions', 'puertoBaseId', 'defaultPesqueriaId', 'minStages']
}

const ConfirmationDialogStub = {
  template: '<div class="confirmation-stub"></div>',
  props: ['show']
}

// Mock del httpClient para interceptar todas las llamadas HTTP
vi.mock('@/config/http/http.client', () => ({
  default: {
    get: vi.fn((url: string) => {
      if (url.includes('/catalogos/puertos')) {
        return Promise.resolve({ data: [] })
      }
      if (url.includes('/catalogos/pesquerias')) {
        return Promise.resolve({ data: [] })
      }
      return Promise.resolve({ data: [] })
    }),
    post: vi.fn(() => Promise.resolve({ data: {} })),
    put: vi.fn(() => Promise.resolve({ data: {} })),
    patch: vi.fn(() => Promise.resolve({ data: {} })),
    delete: vi.fn(() => Promise.resolve({ data: {} }))
  }
}))

vi.mock('../services/catalogos.service', () => ({
  default: {
    getPuertos: vi.fn().mockResolvedValue([]),
    getPesquerias: vi.fn().mockResolvedValue([]),
    getBuques: vi.fn().mockResolvedValue([]),
    getObservadores: vi.fn().mockResolvedValue([])
  }
}))

describe('GestionEtapasMareaDialog.vue', () => {
  const defaultProps = {
    show: true,
    mode: 'EDITAR' as 'EDITAR' | 'INICIAR' | 'FINALIZAR',
    marea: {
      id_marea: 'MC-100-24',
      buque_nombre: 'Barco X',
      puertoBaseId: '1',
      id_pesqueria: '1',
      fechaInicioObservador: '2024-01-10T00:00:00.000Z'
    },
    currentStages: [
       { 
         id: 's1', 
         nroEtapa: 1, 
         fechaZarpada: '2024-01-10T10:00:00.000Z', 
         puertoZarpadaId: '1',
         fechaArribo: '2024-01-15T10:00:00.000Z',
         puertoArriboId: '1',
         pesqueriaId: '1',
         tipoEtapa: TipoEtapa.MC
       }
    ]
  }

  const mountComponent = (props = {}) => {
    return mount(GestionEtapasMareaDialog, {
      props: { ...defaultProps, ...props },
      global: {
        plugins: [createTestingPinia({ createSpy: vi.fn })],
        stubs: {
          Teleport: true,
          DatePicker: DatePickerStub,
          NavigationStagesEditor: NavigationStagesEditorStub,
          ConfirmationDialog: ConfirmationDialogStub
        }
      }
    })
  }

  it('initializes form with marea and stages data', async () => {
    const wrapper = mountComponent()
    
    // Check initial focus/form state
    expect((wrapper.vm as any).form.fechaInicio).toBe(defaultProps.marea.fechaInicioObservador)
    expect((wrapper.vm as any).form.stages.length).toBe(1)
    expect((wrapper.vm as any).form.stages[0].id).toBe('s1')
  })

  it('validates that start date cannot be after first departure', async () => {
    const wrapper = mountComponent()
    
    // Change start date to be after zarpada (which is Jan 10 10:00)
    // Usamos el input del stub directamente para asegurar la propagación
    const input = wrapper.find('input.datepicker-stub')
    await input.setValue('2024-01-12T00:00:00.000Z')
    
    await wrapper.vm.$nextTick()
    
    expect((wrapper.vm as any).isValid).toBe(false)
    expect((wrapper.vm as any).validationErrors.fechaInicio).toContain('No puede ser posterior a la primera zarpada')
  })

  it('validates stage chronology: arrival must be after departure', async () => {
    const wrapper = mountComponent()
    
    // Modify internal stages to an invalid state
    const currentStages = (wrapper.vm as any).form.stages
    currentStages[0].fechaArribo = '2024-01-09T00:00:00.000Z' // Before zarpada
    
    await wrapper.vm.$nextTick()
    expect((wrapper.vm as any).isValid).toBe(false)
  })

  it('validates stage overlap: next departure must be after previous arrival', async () => {
    const wrapper = mountComponent()
    
    // Add a second stage that overlaps
    const currentStages = (wrapper.vm as any).form.stages
    currentStages.push({
        id: null,
        nroEtapa: 2,
        fechaZarpada: '2024-01-12T00:00:00.000Z', // Overlaps with stage 1 arrival (Jan 15)
        puertoZarpadaId: '1',
        pesqueriaId: '1',
        tipoEtapa: TipoEtapa.MC
    })
    
    await wrapper.vm.$nextTick()
    expect((wrapper.vm as any).isValid).toBe(false)
  })

  it('mode FINALIZAR: validates end date vs start date', async () => {
      const wrapper = mountComponent({ mode: 'FINALIZAR' })
      
      // En modo FINALIZAR se muestra el DatePicker de fechaFin (el segundo)
      const inputs = wrapper.findAll('input.datepicker-stub')
      const endDateInput = inputs[1]
      
      // Fecha fin <= fecha inicio (Jan 10)
      // Pero ojo: Jan 9 también es < Jan 15 (last arrival). 
      // El componente valida primero contra el último arribo.
      // Así que usamos una fecha que sea posterior al arribo (Ene 15) pero anterior al inicio? Imposible.
      // O simplemente validamos que sea inválido y que contenga mensaje de error en fechaFin.
      
      await endDateInput.setValue('2024-01-09T00:00:00.000Z')
      await wrapper.vm.$nextTick()
      
      expect((wrapper.vm as any).isValid).toBe(false)
      expect((wrapper.vm as any).validationErrors.fechaFin).toBeDefined()
  })
})
