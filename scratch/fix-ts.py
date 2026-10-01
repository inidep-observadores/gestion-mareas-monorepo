# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

res_form_old = """const resourceForm = ref<{
  pesqueriaId: string;
  buqueId: string | null;
  diasEstimados: number;
  prioridad: string;
}>({
  pesqueriaId: '',
  buqueId: null,
  diasEstimados: 30,
  prioridad: 'MEDIA',
});"""

res_form_new = """const resourceForm = ref<{
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
  prioridad: 'MEDIA',
});

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
);"""

c = c.replace(res_form_old, res_form_new)

# Fix TS errors with undefined vs null in resourceForm assignments
c = c.replace("buqueId: b.id || undefined,", "buqueId: b.id || null,")
c = c.replace("observadorId: o.id || undefined,", "observadorId: o.id || null,")
c = c.replace("editingRecursoId.value = recurso.id || null;", "editingRecursoId.value = recurso.id || null;")

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)
print("Done!")

