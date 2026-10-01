# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

script_end_idx = c.find("</script>")
if script_end_idx != -1 and "const isResourceFormValid = computed" not in c:
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

