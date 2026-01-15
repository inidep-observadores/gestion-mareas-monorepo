import { defineStore } from 'pinia';
import { ref, watch } from 'vue';

export const useConfigStore = defineStore('config', () => {
    // State
    const selectedYear = ref<number>(
        Number(localStorage.getItem('selectedYear')) || new Date().getFullYear()
    );

    // Watch for changes and persist to localStorage
    watch(selectedYear, (newYear) => {
        localStorage.setItem('selectedYear', newYear.toString());
    });

    // Actions
    const setSelectedYear = (year: number) => {
        selectedYear.value = year;
    };

    return {
        // State
        selectedYear,

        // Actions
        setSelectedYear
    };
});
