import sys

def modify_vue_file():
    with open('app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue', 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Add ConfirmationDialog import
    if "import ConfirmationDialog" not in content:
        content = content.replace(
            "import SimuladorTimeline from '../components/SimuladorTimeline.vue';",
            "import SimuladorTimeline from '../components/SimuladorTimeline.vue';\nimport ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';"
        )

    # 2. Add ConfirmationDialog to template
    dialogs = """
    <ConfirmationDialog
      :show="showConfirmChangeScenario"
      title="Cambios sin guardar"
      message="Tiene cambios sin guardar en el escenario actual. ¿Desea continuar y perder los cambios?"
      confirmText="Sí, descartar cambios"
      cancelText="Cancelar"
      confirmButtonClass="bg-error hover:bg-error-hover shadow-error/20"
      @confirm="handleConfirmChangeScenario"
      @close="handleCancelChangeScenario"
    />

    <ConfirmationDialog
      :show="showConfirmDeleteScenario"
      title="Eliminar escenario"
      message="¿Seguro que desea eliminar el escenario actual? Esta acción no se puede deshacer."
      confirmText="Sí, eliminar"
      cancelText="Cancelar"
      confirmButtonClass="bg-error hover:bg-error-hover shadow-error/20"
      @confirm="handleConfirmDeleteScenario"
      @close="showConfirmDeleteScenario = false"
    />
  </PlanificacionDashboardLayout>"""
    if "showConfirmChangeScenario" not in content:
        content = content.replace("  </PlanificacionDashboardLayout>", dialogs)

    # 3. Add dialog refs and methods
    script_additions = """
const showConfirmChangeScenario = ref(false);
const showConfirmDeleteScenario = ref(false);
const pendingEscenarioId = ref('');

const handleConfirmChangeScenario = () => {
  showConfirmChangeScenario.value = false;
  selectedEscenarioId.value = pendingEscenarioId.value;
  performScenarioChange();
};

const handleCancelChangeScenario = () => {
  showConfirmChangeScenario.value = false;
  selectedEscenarioId.value = escenarioActual.value?.id || '';
};

const handleConfirmDeleteScenario = async () => {
  showConfirmDeleteScenario.value = false;
  if (!escenarioActual.value) return;
  try {
    await planificacionService.deleteEscenario(escenarioActual.value.id);
    toast.success('Escenario eliminado');
    await cargarEscenarios();
    if (listaEscenarios.value.length > 0) {
      selectedEscenarioId.value = listaEscenarios.value[0].id;
      await performScenarioChange();
    } else {
      escenarioActual.value = null;
      selectedEscenarioId.value = '';
    }
  } catch (error) {
    toast.error('Error al eliminar');
  }
};
"""
    if "const showConfirmChangeScenario" not in content:
        content = content.replace("const isEscenarioModalOpen = ref(false);", script_additions + "\nconst isEscenarioModalOpen = ref(false);")

    # 4. Modify onEscenarioChange and add performScenarioChange
    old_onEscenarioChange = """const onEscenarioChange = async () => {
  if (hasUnsavedChanges.value && escenarioActual.value) {
    if (!confirm('Tiene cambios sin guardar en el escenario actual. ¿Desea continuar y perder los cambios?')) {
      // Revertir el dropdown al valor original
      selectedEscenarioId.value = escenarioActual.value.id;
      return;
    }
  }

  if (selectedEscenarioId.value === 'new') {"""

    new_onEscenarioChange = """const onEscenarioChange = async () => {
  if (hasUnsavedChanges.value && escenarioActual.value) {
    pendingEscenarioId.value = selectedEscenarioId.value;
    selectedEscenarioId.value = escenarioActual.value.id;
    showConfirmChangeScenario.value = true;
    return;
  }
  await performScenarioChange();
};

const performScenarioChange = async () => {
  if (selectedEscenarioId.value === 'new') {"""
    content = content.replace(old_onEscenarioChange, new_onEscenarioChange)

    # 5. Modify eliminarEscenario
    old_eliminarEscenario = """const eliminarEscenario = async () => {
  if (!escenarioActual.value) return;
  if (!confirm('¿Seguro que desea eliminar el escenario actual?')) return;

  try {
    await planificacionService.deleteEscenario(escenarioActual.value.id);
    toast.success('Escenario eliminado');
    await cargarEscenarios();
    if (listaEscenarios.value.length > 0) {
      selectedEscenarioId.value = listaEscenarios.value[0].id;
      await onEscenarioChange();
    } else {
      escenarioActual.value = null;
      selectedEscenarioId.value = '';
    }
  } catch (error) {
    toast.error('Error al eliminar');
  }
};"""
    
    new_eliminarEscenario = """const eliminarEscenario = () => {
  if (!escenarioActual.value) return;
  showConfirmDeleteScenario.value = true;
};"""
    
    if "const eliminarEscenario = async () => {" in content:
        content = content.replace(old_eliminarEscenario, new_eliminarEscenario)
        # If the replace failed because of some whitespace difference, try simpler logic:
    
    # 6. Change `await onEscenarioChange();` to `await performScenarioChange();` in places that don't need confirmation
    # Wait, in the setup code, we call `onEscenarioChange()` initially. Is that safe?
    # Yes, hasUnsavedChanges is false initially.
    # But `eliminarEscenario` uses `await onEscenarioChange()` which we already replaced inside `handleConfirmDeleteScenario` above!

    with open('app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue', 'w', encoding='utf-8') as f:
        f.write(content)

modify_vue_file()
