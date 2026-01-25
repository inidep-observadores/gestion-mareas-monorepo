import { ref, readonly } from 'vue'

const title = ref('')
const description = ref('')

export function usePageHeader() {
    const setHeader = (newTitle: string, newDescription: string = '') => {
        title.value = newTitle
        description.value = newDescription
    }

    const clearHeader = (currentTitle?: string) => {
        // Only clear if the title being cleared is the one currently displayed.
        // This prevents the old component from clearing the title set by the new component during navigation.
        if (!currentTitle || title.value === currentTitle) {
            title.value = ''
            description.value = ''
        }
    }

    return {
        title: readonly(title),
        description: readonly(description),
        setHeader,
        clearHeader
    }
}
