import { ref, watch } from 'vue';
import mareasService from '../services/mareas.service';

export function useSpotlight() {
    const query = ref('');
    const results = ref<any[]>([]);
    const loading = ref(false);

    const search = async (q: string) => {
        if (!q || q.length < 2) {
            results.value = [];
            return;
        }

        loading.value = true;
        try {
            results.value = await mareasService.search(q);
        } catch (err) {
            console.error('Error searching spotlight:', err);
            results.value = [];
        } finally {
            loading.value = false;
        }
    };

    // Debounced search could be added here or in the component
    watch(query, (newQuery) => {
        search(newQuery);
    });

    return {
        query,
        results,
        loading,
        search
    };
}
