import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import CollapsibleSection from '../CollapsibleSection.vue'

describe('CollapsibleSection.vue', () => {
    const defaultProps = {
        title: 'Test Section'
    }

    it('renders title and remains collapsed by default', () => {
        const wrapper = mount(CollapsibleSection, {
            props: { ...defaultProps, initialOpen: false },
            slots: {
                default: '<div class="content">Content</div>'
            }
        })

        expect(wrapper.text()).toContain('Test Section')
        const contentDiv = wrapper.find('.collapsible-content')
        expect(contentDiv.classes()).not.toContain('is-open')
    })

    it('expands when clicked', async () => {
        const wrapper = mount(CollapsibleSection, {
            props: { ...defaultProps, initialOpen: false },
            slots: {
                default: '<div class="content">Content</div>'
            }
        })

        // El click es en el header (primer div hijo directo que no es el contenedor principal)
        // O mejor buscamos el div con @click="toggle"
        await wrapper.find('.cursor-pointer').trigger('click')

        const contentDiv = wrapper.find('.collapsible-content')
        expect(contentDiv.classes()).toContain('is-open')
    })


    it('renders actions and icon slots', () => {
        const wrapper = mount(CollapsibleSection, {
            props: defaultProps,
            slots: {
                icon: '<span class="icon-stub">Icon</span>',
                actions: '<button class="action-btn">Action</button>'
            }
        })

        expect(wrapper.find('.icon-stub').exists()).toBe(true)
        expect(wrapper.find('.action-btn').exists()).toBe(true)
    })

    it('emits update:modelValue event when toggled', async () => {
        const wrapper = mount(CollapsibleSection, {
            props: defaultProps
        })

        await wrapper.find('.cursor-pointer').trigger('click')
        expect(wrapper.emitted('update:modelValue')).toBeTruthy()
        expect(wrapper.emitted('update:modelValue')![0]).toEqual([true])
    })
})
