# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

old_code = """const handleBuqueChange = () => {
  const buque = buques.value.find(b => b.id === resourceForm.value.buqueId);
  if (buque) {
    if (buque.pesqueriaHabitualId && !resourceForm.value.pesqueriaId) {
      resourceForm.value.pesqueriaId = buque.pesqueriaHabitualId;
    }
    if (buque.diasMareaEstimada) {
      resourceForm.value.diasEstimados = buque.diasMareaEstimada;
    }
  }
};

const guardarRecurso = () => {
  if (!resourceForm.value.pesqueriaId) {
    toast.error('Debe seleccionar una pesquería');
    return;
  }
  
  const pesqueria = pesquerias.value.find(p => p.id === resourceForm.value.pesqueriaId);
  const buque = buques.value.find(b => b.id === resourceForm.value.buqueId);
  
  if (editingRecursoId.value) {
    // Editar existente
    const recurso = recursosPendientes.value.find(r => r.id === editingRecursoId.value);
    if (recurso) {
      recurso.pesqueriaId = resourceForm.value.pesqueriaId;
      recurso.pesqueriaNombre = pesqueria?.nombre || '';
      recurso.buqueId = resourceForm.value.buqueId || undefined;
      recurso.buqueNombre = buque?.nombreBuque || '';
      recurso.diasEstimados = resourceForm.value.diasEstimados;
      recurso.prioridad = resourceForm.value.prioridad as any;
      toast.success('Requerimiento actualizado exitosamente');
    }
  } else {
    // Crear nuevo
    recursosPendientes.value.push({
      id: `rec-custom-${Date.now()}`,
      pesqueriaId: resourceForm.value.pesqueriaId,
      pesqueriaNombre: pesqueria?.nombre || '',
      buqueId: resourceForm.value.buqueId || undefined,
      buqueNombre: buque?.nombreBuque || '',
      diasEstimados: resourceForm.value.diasEstimados || 30,
      puertoSugerido: buque?.puertoBase?.nombre || '',
      prioridad: (resourceForm.value.prioridad as 'ALTA' | 'MEDIA' | 'BAJA') || 'MEDIA',
      mesProyectado: 1
    } as any);
    toast.success('Requerimiento creado exitosamente');
  }
  
  cerrarModalRecurso();
};"""

new_code = """const onBuqueResourceChange = () => {
  if (resourceForm.value.buqueId) {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (b && b.diasMareaEstimada) {
      resourceForm.value.diasEstimados = b.diasMareaEstimada;
    }
  }
};

const guardarRecurso = () => {
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

c = c.replace(old_code, new_code)
# Fallback replace if exact match fails
c = c.replace("""puertoSugerido: buque?.puertoBase?.nombre || '',""", "")
c = c.replace("""mesProyectado: 1""", "")

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)

