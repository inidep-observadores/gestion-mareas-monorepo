import type { DirectiveBinding } from 'vue'

interface ClickOutsideElement extends HTMLElement {
  _clickOutside?: (event: Event) => void
}

export const vClickOutside = {
  mounted(el: ClickOutsideElement, binding: DirectiveBinding) {
    el._clickOutside = (event: Event) => {
      // Check if the click was outside the element and its children
      if (!(el === event.target || el.contains(event.target as Node))) {
        binding.value(event)
      }
    }
    document.addEventListener('click', el._clickOutside)
  },
  unmounted(el: ClickOutsideElement) {
    if (el._clickOutside) {
      document.removeEventListener('click', el._clickOutside)
      delete el._clickOutside
    }
  },
}
