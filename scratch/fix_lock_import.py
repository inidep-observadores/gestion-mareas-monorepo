import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\frontend\src\modules\planificacion\composables\useSimuladorLock.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Fix import
content = content.replace("import { api } from '@/config/api';", "import httpClient from '@/config/http/http.client';")
content = content.replace("await api.post(", "await httpClient.post(")
content = content.replace("await api.delete(", "await httpClient.delete(")

# We need to export a way to release a specific lock, or just release the current one when changing
# I'll update the watch logic in SimuladorCoberturaView.vue too, but first let's fix useSimuladorLock.ts

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
