import { defineStore } from 'pinia'
import { ref, watch, onMounted, computed } from 'vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'

export type ColorTheme = 'blue' | 'green' | 'orange' | 'red' | 'purple' | 'cyan' | 'slate' | 'gold'

export const useThemeStore = defineStore('theme', () => {
    const authStore = useAuthStore()

    // Prefix for localStorage keys based on userID
    const userPrefix = computed(() => {
        const userId = authStore.user?.id || 'guest'
        return `user:${userId}`
    })

    // State - Initialize from specific user key
    const primaryColor = ref<ColorTheme>('blue')
    const darkMode = ref<boolean>(false)

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

        // Color Themes - Remove all theme classes first
        const themeClasses = Array.from(root.classList).filter(c => c.startsWith('theme-'))
        themeClasses.forEach(c => root.classList.remove(c))

        if (primaryColor.value !== 'blue') {
            root.classList.add(`theme-${primaryColor.value}`)
        }
    }

    // Load preferences for the current context (guest or specific user)
    const loadPreferences = () => {
        const savedColor = localStorage.getItem(`${userPrefix.value}:primary-color`) as ColorTheme
        const savedTheme = localStorage.getItem(`${userPrefix.value}:theme`)

        primaryColor.value = savedColor || 'blue'
        darkMode.value = savedTheme === 'dark'

        updateDOM()
    }

    // Watchers for persistence - they now depend on userPrefix
    watch(primaryColor, (newColor) => {
        localStorage.setItem(`${userPrefix.value}:primary-color`, newColor)
        updateDOM()
    })

    watch(darkMode, (isDark) => {
        localStorage.setItem(`${userPrefix.value}:theme`, isDark ? 'dark' : 'light')
        updateDOM()
    })

    // Watch for auth changes to reload themes
    watch(() => authStore.user?.id, () => {
        loadPreferences()
    })

    // Initial setup
    const init = () => {
        loadPreferences()
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
