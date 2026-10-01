# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

start = c.find("const abrirModalEditarRecurso = (recurso: RecursoPendiente) => {")
end = c.find("};", start) + 2

c = c[:start] + """const abrirModalEditarRecurso = (recurso: RecursoPendiente) => {
  editingRecursoId.value = recurso.id || null;
  resourceForm.value = {
    pesqueriaId: recurso.pesqueriaId || '',
    buqueId: recurso.buqueId || null,
    observadorId: recurso.observadorId || null,
    diasEstimados: recurso.diasEstimados || 30,
    prioridad: recurso.prioridad || 'MEDIA'
  };
  isResourceModalOpen.value = true;
};""" + c[end:]

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)

