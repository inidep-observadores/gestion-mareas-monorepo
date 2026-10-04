import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\frontend\src\modules\planificacion\views\SimuladorCoberturaView.vue"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add import
import_statement = "import { useSimuladorHistory } from '../composables/useSimuladorHistory';\n"
content = content.replace("import { planificacionService } from '../services/planificacion.service';", 
                          "import { planificacionService } from '../services/planificacion.service';\n" + import_statement)

# 2. Add history init in setup (around line 900)
history_init = """
const { 
  canUndo, 
  canRedo, 
  takeSnapshot, 
  undo, 
  redo 
} = useSimuladorHistory(selectedEscenarioId);

const handleUndo = () => {
  if (!escenarioActual.value) return;
  const previous = undo(escenarioActual.value.items, recursosPendientes.value);
  if (previous) {
    escenarioActual.value.items = previous.items;
    recursosPendientes.value = previous.recursosPendientes;
    hasUnsavedChanges.value = true;
    guardarEscenario();
  }
};

const handleRedo = () => {
  if (!escenarioActual.value) return;
  const next = redo(escenarioActual.value.items, recursosPendientes.value);
  if (next) {
    escenarioActual.value.items = next.items;
    recursosPendientes.value = next.recursosPendientes;
    hasUnsavedChanges.value = true;
    guardarEscenario();
  }
};
"""

content = content.replace("const showConfirmNoObserver = ref(false);", 
                          history_init + "\nconst showConfirmNoObserver = ref(false);")


# 3. Add UI buttons
ui_buttons = """                <!-- History Buttons -->
                <div class="flex items-center gap-1 bg-surface-muted rounded-lg border border-border p-1 shadow-sm h-9">
                  <button 
                    @click="handleUndo" 
                    :disabled="!canUndo"
                    class="p-1.5 rounded text-text-muted hover:bg-surface hover:text-text disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                    title="Deshacer"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7v6h6"/><path d="M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13"/></svg>
                  </button>
                  <div class="w-px h-4 bg-border"></div>
                  <button 
                    @click="handleRedo" 
                    :disabled="!canRedo"
                    class="p-1.5 rounded text-text-muted hover:bg-surface hover:text-text disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                    title="Rehacer"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 7v6h-6"/><path d="M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7"/></svg>
                  </button>
                </div>"""

content = content.replace("""                <ExportExcelButton
                  label="EXPORTAR\"""", 
                          ui_buttons + "\n                <ExportExcelButton\n                  label=\"EXPORTAR\"")

# 4. Inject takeSnapshot
content = content.replace(
    "escenarioActual.value.items.push({ ...newBlockData.value! });",
    "takeSnapshot(escenarioActual.value.items, recursosPendientes.value);\n      escenarioActual.value.items.push({ ...newBlockData.value! });"
)

content = content.replace(
    "escenarioActual.value!.items[idx] = { ...editingBlockData.value };",
    "takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);\n    escenarioActual.value!.items[idx] = { ...editingBlockData.value };"
)

content = content.replace(
    "const removedItem = escenarioActual.value!.items[idx];\n    escenarioActual.value!.items.splice(idx, 1);",
    "takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);\n    const removedItem = escenarioActual.value!.items[idx];\n    escenarioActual.value!.items.splice(idx, 1);"
)

content = content.replace(
    "sim.fechaZarpada = payload.start;\n    sim.fechaArribo = payload.end;",
    "takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);\n    sim.fechaZarpada = payload.start;\n    sim.fechaArribo = payload.end;"
)

content = content.replace(
    "escenarioActual.value!.items.push(nuevoItemSimulado);",
    "takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);\n    escenarioActual.value!.items.push(nuevoItemSimulado);"
)

# Global keyboard shortcuts
on_mounted_patch = """
onMounted(async () => {
  await Promise.all([cargarCatalogos(), cargarEscenarios()]);
  
  // Shortcuts
  window.addEventListener('keydown', handleGlobalKeydown);
});

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleGlobalKeydown);
});

const handleGlobalKeydown = (e: KeyboardEvent) => {
  // Solo interceptar si no estamos en un input/textarea
  if (['INPUT', 'TEXTAREA'].includes((e.target as HTMLElement).tagName)) return;

  if (e.ctrlKey || e.metaKey) {
    if (e.key === 'z') {
      if (e.shiftKey) {
        if (canRedo.value) handleRedo();
      } else {
        if (canUndo.value) handleUndo();
      }
      e.preventDefault();
    }
    if (e.key === 'y') {
      if (canRedo.value) handleRedo();
      e.preventDefault();
    }
  }
};
"""

content = content.replace(
    "onMounted(async () => {\n  await Promise.all([cargarCatalogos(), cargarEscenarios()]);\n});",
    on_mounted_patch
)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
