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

    const simuladorSoloPlanificadas = ref<boolean>(
        localStorage.getItem('simuladorSoloPlanificadas') === 'true'
    );

    const simuladorSelectedTypes = ref<string[]>(
        JSON.parse(localStorage.getItem('simuladorSelectedTypes') || '["OBSERVADOR"]')
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

    watch(simuladorSoloPlanificadas, (newVal) => {
        localStorage.setItem('simuladorSoloPlanificadas', newVal.toString());
    });

    watch(simuladorSelectedTypes, (newVal) => {
        localStorage.setItem('simuladorSelectedTypes', JSON.stringify(newVal));
    }, { deep: true });

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

    const setSimuladorSoloPlanificadas = (val: boolean) => {
        simuladorSoloPlanificadas.value = val;
    };

    const setSimuladorSelectedTypes = (val: string[]) => {
        simuladorSelectedTypes.value = val;
    };

    return {
        // State
        selectedYear,
        statsDetailViewMode,
        lastScenarioId,
        simuladorSoloPlanificadas,
        simuladorSelectedTypes,

        // Actions
        setSelectedYear,
        setStatsDetailViewMode,
        setLastScenarioId,
        setSimuladorSoloPlanificadas,
        setSimuladorSelectedTypes
    };
});
