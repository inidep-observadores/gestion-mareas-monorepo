import type { Directive } from 'vue'

/**
 * Directiva v-form-nav
 * 
 * Gestiona la navegación avanzada en formularios:
 * - ENTER: Salta al siguiente campo (evita activar botones sin data-allow-enter).
 * - FLECHA DERECHA: Salta al siguiente campo si el cursor está al final.
 * - FLECHA IZQUIERDA: Salta al campo anterior si el cursor está al inicio.
 * - Los botones se activan normalmente con ESPACIO o CLICK.
 * 
 * Uso: <div v-form-nav> ... campos ... </div>
 */
export const vFormNav: Directive = {
  mounted(el: HTMLElement) {
    el.addEventListener('keydown', (e: KeyboardEvent) => {
      const target = e.target as HTMLElement
      const isInput = target.tagName === 'INPUT' || target.tagName === 'SELECT' || target.tagName === 'TEXTAREA'
      const isButton = target.tagName === 'BUTTON'
      
      // Solo actuar en elementos de formulario
      if (!isInput && !isButton) return

      /**
       * Mueve el foco al siguiente elemento
       */
      const focusNext = () => {
        const focusables = getFocusables(el)
        const currentIndex = focusables.indexOf(target)
        if (currentIndex > -1 && currentIndex < focusables.length - 1) {
          e.preventDefault()
          const nextElement = focusables[currentIndex + 1]
          nextElement.focus()
          
          if (nextElement instanceof HTMLInputElement && ['text', 'number', 'email', 'tel', 'url'].includes(nextElement.type)) {
            nextElement.select()
          }
        }
      }

      /**
       * Mueve el foco al elemento anterior
       */
      const focusPrev = () => {
        const focusables = getFocusables(el)
        const currentIndex = focusables.indexOf(target)
        if (currentIndex > 0) {
          e.preventDefault()
          const prevElement = focusables[currentIndex - 1]
          prevElement.focus()
          
          if (prevElement instanceof HTMLInputElement && ['text', 'number', 'email', 'tel', 'url'].includes(prevElement.type)) {
            prevElement.select()
          }
        }
      }

      // Lógica según la tecla presionada
      if (e.key === 'Enter') {
        if (target.tagName === 'TEXTAREA') return
        
        const allowsEnter = target.hasAttribute('data-allow-enter') || !!target.closest('[data-allow-enter]')
        
        if (isButton && !allowsEnter) {
          e.preventDefault()
          focusNext()
        } else if (!isButton) {
          e.preventDefault()
          focusNext()
        }
        // Si es un botón con data-allow-enter, dejamos que actúe normalmente
      } 
      else if (e.key === 'ArrowRight') {
        if (shouldMoveRight(target)) {
          focusNext()
        }
      } 
      else if (e.key === 'ArrowLeft') {
        if (shouldMoveLeft(target)) {
          focusPrev()
        }
      }
    })
  }
}

/**
 * Obtiene todos los elementos enfocables, visibles y no deshabilitados
 */
function getFocusables(el: HTMLElement): HTMLElement[] {
  return Array.from(
    el.querySelectorAll<HTMLElement>(
      'input:not([disabled]):not([type="hidden"]):not([tabindex="-1"]), select:not([disabled]):not([tabindex="-1"]), textarea:not([disabled]):not([tabindex="-1"]), button:not([disabled]):not([tabindex="-1"])'
    )
  ).filter(element => {
    return !!(element.offsetWidth || element.offsetHeight || element.getClientRects().length)
  })
}

/**
 * Verifica si el foco debe saltar a la derecha basado en la posición del cursor
 */
function shouldMoveRight(el: HTMLElement): boolean {
  if (el instanceof HTMLInputElement) {
    // Tipos de input que no usan cursor de texto permiten saltar siempre
    if (['radio', 'checkbox', 'range', 'color', 'file'].includes(el.type)) return true
    
    try {
      // Para inputs de texto, saltamos solo si el cursor está al final
      // Nota: browsers como Chrome lanzan error al acceder a selectionStart en input type="number"
      return el.selectionStart === el.value.length && el.selectionEnd === el.value.length
    } catch {
      // Fallback para inputs tipo number/date/etc
      return true 
    }
  }
  if (el instanceof HTMLTextAreaElement) {
    return el.selectionStart === el.value.length && el.selectionEnd === el.value.length
  }
  return true // Botones, Selects, etc.
}

/**
 * Verifica si el foco debe saltar a la izquierda basado en la posición del cursor
 */
function shouldMoveLeft(el: HTMLElement): boolean {
  if (el instanceof HTMLInputElement) {
    if (['radio', 'checkbox', 'range', 'color', 'file'].includes(el.type)) return true
    
    try {
      return el.selectionStart === 0 && el.selectionEnd === 0
    } catch {
      return true
    }
  }
  if (el instanceof HTMLTextAreaElement) {
    return el.selectionStart === 0 && el.selectionEnd === 0
  }
  return true
}
