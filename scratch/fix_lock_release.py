import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\frontend\src\modules\planificacion\composables\useSimuladorLock.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

replacement = """
  const releaseLock = (escenarioId?: string) => {
    if (heartbeatInterval) clearInterval(heartbeatInterval);
    const idToRelease = escenarioId || escenarioIdRef.value;
    if (!idToRelease || !isLockedByMe.value) return;

    const token = localStorage.getItem('auth-token');
    const url = `${import.meta.env.VITE_API_URL}/planificacion/simulador/escenarios/${idToRelease}/lock?tabId=${lockTabId.value}`;
    
    try {
      fetch(url, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        },
        keepalive: true
      });
    } catch (e) {
      console.error('Error releasing lock', e);
    }
    
    isLockedByMe.value = false;
  };
"""

content = re.sub(
    r"const releaseLock = \(\) => \{.*?\};\n\n  const handleBeforeUnload",
    replacement.strip() + "\n\n  const handleBeforeUnload",
    content,
    flags=re.DOTALL
)

content = content.replace("return {\n    isLockedByMe,", "return {\n    isLockedByMe,\n    releaseLock,")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
