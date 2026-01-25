import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useWorkflowStore = defineStore('workflow', () => {
    const activeAlertData = ref<any>(null)
    const isInternalNavigation = ref(false)

    const setAlertData = (data: any) => {
        activeAlertData.value = data
        isInternalNavigation.value = true
    }

    const clearAlertData = () => {
        activeAlertData.value = null
        isInternalNavigation.value = false
    }

    return {
        activeAlertData,
        isInternalNavigation,
        setAlertData,
        clearAlertData
    }
})
