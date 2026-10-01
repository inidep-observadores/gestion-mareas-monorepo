# coding=utf-8
import re

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

# 1. resourceForm definition
c = re.sub(
    r"const resourceForm = ref<\{[^\}]+\}>\(\{.*?\}\);",
    """const resourceForm = ref<{
  pesqueriaId: string;
  buqueId: string | null;
  observadorId?: string | null;
  diasEstimados: number;
  prioridad: string;
}>({
  pesqueriaId: '',
  buqueId: null,
  observadorId: null,
  diasEstimados: 30,
  prioridad: 'MEDIA'
});""",
    c,
    flags=re.DOTALL
)

# 2. guardarRecurso
start_idx = c.find("const guardarRecurso = () => {")
end_idx = c.find("};\n", start_idx) + 2
if start_idx != -1 and end_idx != 1:
    guardar_new = """const guardarRecurso = () => {
  if (activeTab.value === 'observador') {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (!b) return;
    
    if (editingRecursoId.value) {
      const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
      if (idx !== -1) {
        recursosPendientes.value[idx] = {
          ...recursosPendientes.value[idx],
          buqueId: b.id,
          buqueNombre: b.nombreBuque,
          pesqueriaId: b.pesqueriaHabitualId,
          pesqueriaNombre: b.pesqueriaHabitual?.nombre,
          diasEstimados: resourceForm.value.diasEstimados,
          prioridad: resourceForm.value.prioridad
        };
        toast.success('Recurso actualizado');
      }
    } else {
      recursosPendientes.value.push({
        id: `rec-${Date.now()}`,
        tipo: 'buque',
        buqueId: b.id,
        buqueNombre: b.nombreBuque,
        pesqueriaId: b.pesqueriaHabitualId,
        pesqueriaNombre: b.pesqueriaHabitual?.nombre,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      });
      toast.success('Recurso agregado');
    }
  } else {
    const o = observadoresBase.value.find(x => x.id === resourceForm.value.observadorId);
    if (!o) return;
    
    if (editingRecursoId.value) {
      const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
      if (idx !== -1) {
        recursosPendientes.value[idx] = {
          ...recursosPendientes.value[idx],
          observadorId: o.id,
          observadorNombre: `${o.apellido}, ${o.nombre}`,
          diasEstimados: resourceForm.value.diasEstimados,
          prioridad: resourceForm.value.prioridad
        };
        toast.success('Recurso actualizado');
      }
    } else {
      recursosPendientes.value.push({
        id: `rec-${Date.now()}`,
        tipo: 'observador',
        observadorId: o.id,
        observadorNombre: `${o.apellido}, ${o.nombre}`,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      });
      toast.success('Recurso agregado');
    }
  }
  
  cerrarModalRecurso();
};"""
    c = c[:start_idx] + guardar_new + c[end_idx:]

# 3. Add computed properties at the end of script setup
if "isResourceFormValid" not in c:
    script_end_idx = c.find("</script>")
    if script_end_idx != -1:
        extras = """
const isResourceFormValid = computed(() => {
  if (activeTab.value === 'observador') return !!resourceForm.value.buqueId;
  return !!resourceForm.value.observadorId;
});

const onBuqueResourceChange = () => {
  if (resourceForm.value.buqueId) {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (b && b.diasMareaEstimada) {
      resourceForm.value.diasEstimados = b.diasMareaEstimada;
    }
  }
};

const observadorOptions = computed(() => 
  observadoresBase.value.map(o => ({
    value: o.id,
    label: `${o.apellido}, ${o.nombre}`
  }))
);
"""
        c = c[:script_end_idx] + extras + "\n" + c[script_end_idx:]

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)

print("Applied replacements via python")
