import { defineStore } from 'pinia'
import { ref, watch, onMounted } from 'vue'

export type ColorTheme = 'blue' | 'green' | 'orange'

export const useThemeStore = defineStore('theme', () => {
    // State
    const primaryColor = ref<ColorTheme>((localStorage.getItem('primary-color') as ColorTheme) || 'blue')
    const darkMode = ref<boolean>(localStorage.getItem('theme') === 'dark')

    // Actions
    const setPrimaryColor = (color: ColorTheme) => {
        primaryColor.value = color
    }

    const toggleDarkMode = () => {
        darkMode.value = !darkMode.value
    }

    // Side effects logic
    const updateDOM = () => {
        const root = document.documentElement

        // Dark Mode
        if (darkMode.value) {
            root.classList.add('dark')
            root.setAttribute('data-theme', 'dark')
        } else {
            root.classList.remove('dark')
            root.setAttribute('data-theme', 'soft')
        }

        // Color Themes
        root.classList.remove('theme-green', 'theme-orange')
        if (primaryColor.value !== 'blue') {
            root.classList.add(`theme-${primaryColor.value}`)
        }
    }

    // Watchers for persistence
    watch(primaryColor, (newColor) => {
        localStorage.setItem('primary-color', newColor)
        updateDOM()
    })

    watch(darkMode, (isDark) => {
        localStorage.setItem('theme', isDark ? 'dark' : 'light')
        updateDOM()
    })

    // Initial setup
    const init = () => {
        updateDOM()
    }

    return {
        // State
        primaryColor,
        darkMode,

        // Actions
        setPrimaryColor,
        toggleDarkMode,
        init
    }
})
