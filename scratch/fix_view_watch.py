import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\frontend\src\modules\planificacion\views\SimuladorCoberturaView.vue"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(
    "const { isLockedByMe, lockedByOtherUser, lockTabId, tryAcquireLock } = useSimuladorLock(selectedEscenarioId);",
    "const { isLockedByMe, lockedByOtherUser, lockTabId, tryAcquireLock, releaseLock } = useSimuladorLock(selectedEscenarioId);"
)

old_watch = """watch(selectedEscenarioId, async (newVal) => {
  if (newVal) {
    await tryAcquireLock(handleLockFailed);
  }
});"""

new_watch = """watch(selectedEscenarioId, async (newVal, oldVal) => {
  if (oldVal && oldVal !== 'new') {
    releaseLock(oldVal);
  }
  if (newVal && newVal !== 'new') {
    await tryAcquireLock(handleLockFailed);
  }
}, { immediate: true });"""

content = content.replace(old_watch, new_watch)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
