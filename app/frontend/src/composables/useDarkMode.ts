import { ref, watch, onMounted } from 'vue'

/**
 * Composable para manejar el modo oscuro con persistencia en localStorage
 * Sigue las mejores prácticas de Tailwind CSS v4 para dark mode
 */
export function useDarkMode() {
  const isDark = ref(false)

  const toggle = () => {
    isDark.value = !isDark.value
  }

  const setDark = (value: boolean) => {
    isDark.value = value
  }

  // Sincronizar con DOM y localStorage
  watch(
    isDark,
    (dark) => {
      if (dark) {
        document.documentElement.classList.add('dark')
        localStorage.setItem('theme', 'dark')
      } else {
        document.documentElement.classList.remove('dark')
        localStorage.setItem('theme', 'light')
      }
    },
    { immediate: true },
  )

  // Inicializar desde localStorage o preferencia del sistema
  onMounted(() => {
    const savedTheme = localStorage.getItem('theme')
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches

    isDark.value = savedTheme === 'dark' || (!savedTheme && prefersDark)
  })

  return {
    isDark,
    toggle,
    setDark,
  }
}
