import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import ObservadoresSecundariosEditor from '../ObservadoresSecundariosEditor.vue'
import catalogosService from '../../services/catalogos.service'
import { nextTick } from 'vue'

// Stubs
const SearchableSelectStub = {
  template: '<div class="select-stub-container"><select class="select-stub" :value="modelValue" @change="$emit(\'update:modelValue\', $event.target.value)"><slot></slot></select></div>',
  props: ['options', 'modelValue', 'placeholder', 'icon']
}

vi.mock('../../services/catalogos.service', () => ({
  default: {
    getObservadores: vi.fn()
  }
}))

describe('ObservadoresSecundariosEditor.vue', () => {
  const sampleOptions = [
    { value: 'obs-1', label: 'Perez, Juan' },
    { value: 'obs-2', label: 'Gomez, Maria' },
    { value: 'obs-3', label: 'Lopez, Carlos' }
  ]

  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(catalogosService.getObservadores).mockResolvedValue([
      { id: 'obs-1', nombre: 'Juan', apellido: 'Perez' },
      { id: 'obs-2', nombre: 'Maria', apellido: 'Gomez' },
      { id: 'obs-3', nombre: 'Carlos', apellido: 'Lopez' }
    ] as any)
  })

  const mountComponent = (props = {}) => {
    return mount(ObservadoresSecundariosEditor, {
      props: {
        modelValue: [],
        observadorOptions: sampleOptions,
        observadorPrincipalId: 'obs-1',
        ...props
      },
      global: {
        stubs: {
          SearchableSelect: SearchableSelectStub
        }
      }
    })
  }

  it('filters out principal observer from available options', async () => {
    const wrapper = mountComponent({ observadorPrincipalId: 'obs-1' })
    await flushPromises()
    const vm = wrapper.vm as any

    expect(vm.availableObserverOptions.map((o: any) => o.value)).toEqual(['obs-2', 'obs-3'])
  })

  it('filters out already selected secondary observers from options', async () => {
    const wrapper = mountComponent({
      observadorPrincipalId: 'obs-1',
      modelValue: [{ observadorId: 'obs-2', etapaDesde: 1, etapaHasta: null }]
    })
    await flushPromises()
    const vm = wrapper.vm as any

    expect(vm.availableObserverOptions.map((o: any) => o.value)).toEqual(['obs-3'])
  })

  it('rejects saving if secondary observer is identical to principal observer', async () => {
    const wrapper = mountComponent({ observadorPrincipalId: 'obs-1' })
    const vm = wrapper.vm as any

    vm.openAddForm()
    vm.newEntry.observadorId = 'obs-1'
    vm.saveObservador()
    await nextTick()

    expect(vm.formError).toContain('El observador secundario no puede ser el mismo que el observador principal')
    expect(wrapper.emitted('update:modelValue')).toBeUndefined()
  })

  it('rejects saving if secondary observer is duplicate', async () => {
    const wrapper = mountComponent({
      observadorPrincipalId: 'obs-1',
      modelValue: [{ observadorId: 'obs-2', etapaDesde: 1, etapaHasta: null }]
    })
    const vm = wrapper.vm as any

    vm.openAddForm()
    vm.newEntry.observadorId = 'obs-2'
    vm.saveObservador()
    await nextTick()

    expect(vm.formError).toContain('El observador ya se encuentra en la lista de secundarios')
    expect(wrapper.emitted('update:modelValue')).toBeUndefined()
  })

  it('emits update:modelValue with new secondary observer when data is valid', async () => {
    const wrapper = mountComponent({ observadorPrincipalId: 'obs-1' })
    const vm = wrapper.vm as any

    vm.openAddForm()
    vm.newEntry.observadorId = 'obs-2'
    vm.newEntry.etapaDesde = 1
    vm.hastaFinDeMarea = true
    vm.saveObservador()
    await nextTick()

    expect(vm.formError).toBe('')
    expect(wrapper.emitted('update:modelValue')).toBeTruthy()
    expect(wrapper.emitted('update:modelValue')![0][0]).toEqual([
      { observadorId: 'obs-2', etapaDesde: 1, etapaHasta: null, notas: undefined }
    ])
  })
})
