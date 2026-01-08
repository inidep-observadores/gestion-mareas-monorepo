import { ref, computed } from 'vue';
import mareasService from '../services/mareas.service';
import type { MareaListItem, MareaContext } from '../services/mareas.service';

export function useMareas() {
    const loading = ref(false);
    const error = ref<string | null>(null);
    const kpis = ref<any[]>([]);
    const mareas = ref<MareaListItem[]>([]);
    const selectedMareaContext = ref<MareaContext | null>(null);
    const hiddenStates = ref<Set<string>>(new Set());
    const searchQuery = ref('');
    const sortBy = ref<string | null>(null);
    const sortOrder = ref<'asc' | 'desc'>('asc');

    const fetchDashboard = async () => {
        loading.value = true;
        error.value = null;
        try {
            const data = await mareasService.getDashboardOperativo();
            kpis.value = data.kpis;
            mareas.value = data.items;
        } catch (err: any) {
            error.value = err.message || 'Error al cargar el dashboard';
        } finally {
            loading.value = false;
        }
    };

    const fetchMareaContext = async (id: string) => {
        loading.value = true;
        try {
            selectedMareaContext.value = await mareasService.getMareaContext(id);
        } catch (err: any) {
            error.value = err.message || 'Error al cargar el contexto de la marea';
        } finally {
            loading.value = false;
        }
    };

    const executeAction = async (id: string, actionKey: string, payload: any = {}) => {
        try {
            await mareasService.executeAction(id, actionKey, payload);
            // Refrescar contexto después de la acción
            await fetchMareaContext(id);
            // Opcionalmente refrescar dashboard también
            await fetchDashboard();
        } catch (err: any) {
            error.value = err.message || 'Error al ejecutar la acción';
            throw err;
        }
    };

    const createMarea = async (mareaData: any) => {
        loading.value = true;
        try {
            const result = await mareasService.create(mareaData);
            return result;
        } catch (err: any) {
            error.value = err.message || 'Error al crear la marea';
            throw err;
        } finally {
            loading.value = false;
        }
    };

    const toggleStateVisibility = (codigo: string) => {
        const next = new Set(hiddenStates.value);
        if (next.has(codigo)) {
            next.delete(codigo);
        } else {
            next.add(codigo);
        }
        hiddenStates.value = next;
    };

    const setVisibleStates = (allowedCodes: string[]) => {
        const allowed = new Set(allowedCodes);
        const nextHidden = new Set<string>();
        kpis.value.forEach(k => {
            if (!allowed.has(k.codigo)) {
                nextHidden.add(k.codigo);
            }
        });
        hiddenStates.value = nextHidden;
    };

    const toggleSort = (key: string) => {
        if (sortBy.value === key) {
            sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
        } else {
            sortBy.value = key;
            sortOrder.value = 'asc';
        }
    };

    const filteredMareas = computed(() => {
        let result = mareas.value.filter(m => {
            const matchesState = !hiddenStates.value.has(m.estado_codigo);
            const query = searchQuery.value.toLowerCase().trim();
            if (!query) return matchesState;

            const matchesText = 
                m.buque_nombre.toLowerCase().includes(query) || 
                m.id_marea.toLowerCase().includes(query);
            
            return matchesState && matchesText;
        });

        if (sortBy.value) {
            result = [...result].sort((a, b) => {
                const key = sortBy.value as keyof MareaListItem;
                let valA: any = a[key];
                let valB: any = b[key];

                // Manejo especial para alertas (ordenar por cantidad)
                if (key === 'alertas') {
                    valA = a.alertas?.length || 0;
                    valB = b.alertas?.length || 0;
                }

                if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1;
                if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1;
                return 0;
            });
        }

        return result;
    });

    return {
        loading,
        error,
        kpis,
        mareas,
        selectedMareaContext,
        fetchDashboard,
        fetchMareaContext,
        executeAction,
        createMarea,
        hiddenStates,
        searchQuery,
        sortBy,
        sortOrder,
        filteredMareas,
        toggleStateVisibility,
        setVisibleStates,
        toggleSort
    };
}
