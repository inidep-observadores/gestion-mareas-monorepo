import { defineStore } from 'pinia';
import { ref, watch } from 'vue';

export const useConfigStore = defineStore('config', () => {
    // State
    const selectedYear = ref<number>(
        Number(localStorage.getItem('selectedYear')) || new Date().getFullYear()
    );

    const statsDetailViewMode = ref<'cards' | 'table'>(
        (localStorage.getItem('statsDetailViewMode') as 'cards' | 'table') || 'cards'
    );

    const lastScenarioId = ref<string>(
        localStorage.getItem('lastScenarioId') || ''
    );

    // Watch for changes and persist to localStorage
    watch(selectedYear, (newYear) => {
        localStorage.setItem('selectedYear', newYear.toString());
    });

    watch(statsDetailViewMode, (newMode) => {
        localStorage.setItem('statsDetailViewMode', newMode);
    });

    watch(lastScenarioId, (newId) => {
        localStorage.setItem('lastScenarioId', newId);
    });

    // Actions
    const setSelectedYear = (year: number) => {
        selectedYear.value = year;
    };

    const setStatsDetailViewMode = (mode: 'cards' | 'table') => {
        statsDetailViewMode.value = mode;
    };

    const setLastScenarioId = (id: string) => {
        lastScenarioId.value = id;
    };

    return {
        // State
        selectedYear,
        statsDetailViewMode,
        lastScenarioId,

        // Actions
        setSelectedYear,
        setStatsDetailViewMode,
        setLastScenarioId
    };
});
