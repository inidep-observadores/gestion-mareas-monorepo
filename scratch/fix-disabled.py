# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

c = c.replace(':disabled="loadingCatalogs || !isResourceFormValid"', ':disabled="loadingCatalogs"')
c = c.replace(':disabled="!selectedBuqueToAdd"', '')

c = c.replace("""const guardarRecurso = () => {
  if (activeTab.value === 'observador') {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (!b) return;""", """const guardarRecurso = () => {
  if (activeTab.value === 'observador') {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (!b) {
      toast.error('Debe seleccionar un buque');
      return;
    }""")

c = c.replace("""  } else {
    const o = observadoresBase.value.find(x => x.id === resourceForm.value.observadorId);
    if (!o) return;""", """  } else {
    const o = observadoresBase.value.find(x => x.id === resourceForm.value.observadorId);
    if (!o) {
      toast.error('Debe seleccionar un observador');
      return;
    }""")

c = c.replace("""const addBuqueToTimeline = () => {
  if (selectedBuqueToAdd.value) {""", """const addBuqueToTimeline = () => {
  if (!selectedBuqueToAdd.value) {
    toast.error('Debe seleccionar un buque');
    return;
  }
  if (selectedBuqueToAdd.value) {""")

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)

