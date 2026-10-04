import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\frontend\src\modules\planificacion\views\SimuladorCoberturaView.vue"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()


modal_ui = """
    <!-- Modal de Bloqueo Pesimista -->
    <BaseModal :show="showLockedModal" title="Escenario Bloqueado" icon="warning">
      <div class="space-y-4">
        <p class="text-sm text-text">
          La planificación está siendo editada actualmente por <span class="font-bold text-primary">{{ lockedByOtherUser }}</span>.
        </p>
        <p class="text-xs text-text-muted">
          Para evitar conflictos de datos, has ingresado en modo de solo lectura. No podrás modificar ni guardar cambios hasta que el otro usuario termine de trabajar.
        </p>
        <div class="flex justify-end pt-4">
          <button @click="showLockedModal = false" class="px-6 py-2 bg-primary text-white rounded text-xs font-bold uppercase hover:bg-primary-hover">
            Entendido
          </button>
        </div>
      </div>
    </BaseModal>
"""
if "Modal de Bloqueo Pesimista" not in content:
    content = content.replace("  </PlanificacionDashboardLayout>", modal_ui + "\n  </PlanificacionDashboardLayout>")


setup_lock = """
const showLockedModal = ref(false);

const handleLockFailed = (user: string) => {
  showLockedModal.value = true;
};

const { isLockedByMe, lockedByOtherUser, lockTabId, tryAcquireLock } = useSimuladorLock(selectedEscenarioId);

watch(selectedEscenarioId, async (newVal) => {
  if (newVal) {
    await tryAcquireLock(handleLockFailed);
  }
});
"""

if "const showLockedModal = ref(false);" not in content:
    content = content.replace(
        "const showConfirmChangeScenario = ref(false);",
        "const showConfirmChangeScenario = ref(false);\n" + setup_lock
    )


# Modify guardarEscenario to send tabId
content = re.sub(
    r"const dto: UpdateEscenarioDto = \{\s*items: escenarioActual\.value\.items\s*\};",
    "const dto: UpdateEscenarioDto = {\n      items: escenarioActual.value.items,\n      tabId: lockTabId.value\n    };",
    content
)


content = content.replace(
    "<SimuladorTimeline",
    "<SimuladorTimeline\n            :readonly=\"!isLockedByMe\""
)


content = content.replace(
    "@click=\"abrirModalCrearBloque()\"",
    ":disabled=\"!isLockedByMe\"\n                  @click=\"abrirModalCrearBloque()\""
)


with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
