import { ref, computed, watch, type Ref } from 'vue';
import type { MareaSimuladaItem } from '../interfaces/simulador.interface';

export interface SimuladorSnapshot {
  timestamp: number;
  items: MareaSimuladaItem[];
  recursosPendientes: any[];
}

export function useSimuladorHistory(escenarioId: Ref<string | null>) {
  const MAX_HISTORY = 20;
  
  const past = ref<SimuladorSnapshot[]>([]);
  const future = ref<SimuladorSnapshot[]>([]);

  const getStorageKey = () => {
    if (!escenarioId.value) return null;
    let userId = 'default';
    try {
      const auth = localStorage.getItem('auth-store');
      if (auth) {
        const parsed = JSON.parse(auth);
        if (parsed.user && parsed.user.id) userId = parsed.user.id;
      }
    } catch(e) {}

    return `simulador_history_${userId}_${escenarioId.value}`;
  };

  const loadHistory = () => {
    past.value = [];
    future.value = [];
    const key = getStorageKey();
    if (!key) return;

    try {
      const stored = localStorage.getItem(key);
      if (stored) {
        const parsed = JSON.parse(stored);
        if (parsed.past && Array.isArray(parsed.past)) past.value = parsed.past;
        if (parsed.future && Array.isArray(parsed.future)) future.value = parsed.future;
      }
    } catch (e) {
      console.error('Error loading history', e);
    }
  };

  const saveHistory = () => {
    const key = getStorageKey();
    if (!key) return;
    localStorage.setItem(key, JSON.stringify({
      past: past.value,
      future: future.value
    }));
  };

  watch(escenarioId, () => {
    loadHistory();
  }, { immediate: true });

  const takeSnapshot = (currentItems: MareaSimuladaItem[], currentRecursos: any[]) => {
    if (!escenarioId.value) return;
    
    const currentItemsJson = JSON.stringify(currentItems);
    const currentRecursosJson = JSON.stringify(currentRecursos);

    if (past.value.length > 0) {
      const last = past.value[past.value.length - 1];
      const lastItemsJson = JSON.stringify(last.items);
      const lastRecursosJson = JSON.stringify(last.recursosPendientes);
      if (currentItemsJson === lastItemsJson && currentRecursosJson === lastRecursosJson) return; // No changes
    }

    const snapshot: SimuladorSnapshot = {
      timestamp: Date.now(),
      items: JSON.parse(currentItemsJson),
      recursosPendientes: JSON.parse(currentRecursosJson)
    };
    
    past.value.push(snapshot);
    if (past.value.length > MAX_HISTORY) {
      past.value.shift();
    }
    
    future.value = [];
    saveHistory();
  };

  const undo = (currentItems: MareaSimuladaItem[], currentRecursos: any[]): SimuladorSnapshot | null => {
    if (past.value.length === 0 || !escenarioId.value) return null;
    
    future.value.push({
      timestamp: Date.now(),
      items: JSON.parse(JSON.stringify(currentItems)),
      recursosPendientes: JSON.parse(JSON.stringify(currentRecursos))
    });
    
    const previousState = past.value.pop()!;
    saveHistory();
    return previousState;
  };

  const redo = (currentItems: MareaSimuladaItem[], currentRecursos: any[]): SimuladorSnapshot | null => {
    if (future.value.length === 0 || !escenarioId.value) return null;
    
    past.value.push({
      timestamp: Date.now(),
      items: JSON.parse(JSON.stringify(currentItems)),
      recursosPendientes: JSON.parse(JSON.stringify(currentRecursos))
    });
    
    const nextState = future.value.pop()!;
    saveHistory();
    return nextState;
  };

  const clearHistory = () => {
    past.value = [];
    future.value = [];
    const key = getStorageKey();
    if (key) localStorage.removeItem(key);
  };

  return {
    past,
    future,
    takeSnapshot,
    undo,
    redo,
    clearHistory,
    canUndo: computed(() => past.value.length > 0),
    canRedo: computed(() => future.value.length > 0)
  };
}
