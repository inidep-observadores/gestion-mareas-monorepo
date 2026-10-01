# coding=utf-8
import re

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    content = f.read()

ts_old = """
const recursosPendientes = ref<RecursoMareaPendiente[]>([]);

// Catálogos
"""

ts_new = """
export interface RecursoPendiente {
  id: string;
  tipo: 'buque' | 'observador';
  buqueId?: string;
  buqueNombre?: string;
  pesqueriaId?: string;
  pesqueriaNombre?: string;
  observadorId?: string;
  observadorNombre?: string;
  diasEstimados: number;
  prioridad: string;
}

const recursosPendientes = ref<RecursoPendiente[]>([]);

// Catálogos
"""

content = content.replace(ts_old, ts_new)

old_guardar_recurso = """
const resourceForm = ref<{
  pesqueriaId: string;
  buqueId: string | null;
  diasEstimados: number;
  prioridad: string;
}>({
  pesqueriaId: '',
  buqueId: null,
  diasEstimados: 30,
  prioridad: 'MEDIA'
});

const isEditBlockModalOpen = ref(false);
const editingBlockData = ref<MareaSimuladaItem | null>(null);

const pesqueriaSelectRef = ref<any>(null);

const abrirModalCrearRecurso = () => {
  editingRecursoId.value = null;
  resourceForm.value = {
    pesqueriaId: '',
    buqueId: null,
    diasEstimados: 30,
    prioridad: 'MEDIA'
  };
  isResourceModalOpen.value = true;
  nextTick(() => {
    pesqueriaSelectRef.value?.focus();
  });
};

const abrirModalEditarRecurso = (recurso: RecursoMareaPendiente) => {
  editingRecursoId.value = recurso.id;
  resourceForm.value = {
    pesqueriaId: recurso.pesqueriaId || '',
    buqueId: recurso.buqueId || null,
    diasEstimados: recurso.diasEstimados,
    prioridad: recurso.prioridad || 'MEDIA'
  };
  isResourceModalOpen.value = true;
  nextTick(() => {
    pesqueriaSelectRef.value?.focus();
  });
};

const eliminarRecurso = (id: string) => {
  const idx = recursosPendientes.value.findIndex(r => r.id === id);
  if (idx !== -1) {
    recursosPendientes.value.splice(idx, 1);
    toast.success('Recurso eliminado');
  }
};

const guardarRecurso = () => {
  const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
  const p = pesquerias.value.find(x => x.id === resourceForm.value.pesqueriaId);
  
  if (!p) {
    toast.error('Debe seleccionar una pesquería');
    return;
  }

  if (editingRecursoId.value) {
    const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
    if (idx !== -1) {
      recursosPendientes.value[idx] = {
        ...recursosPendientes.value[idx],
        pesqueriaId: p.id,
        pesqueriaNombre: p.nombre,
        buqueId: b?.id || undefined,
        buqueNombre: b?.nombreBuque || undefined,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad as any
      };
      toast.success('Recurso actualizado');
    }
  } else {
    recursosPendientes.value.push({
      id: `rec-${Date.now()}`,
      pesqueriaId: p.id,
      pesqueriaNombre: p.nombre,
      buqueId: b?.id,
      buqueNombre: b?.nombreBuque,
      diasEstimados: resourceForm.value.diasEstimados,
      prioridad: resourceForm.value.prioridad as any,
      mesProyectado: 1
    });
    toast.success('Recurso agregado');
  }

  isResourceModalOpen.value = false;
};
"""

new_guardar_recurso = """
const resourceForm = ref<{
  buqueId: string | null;
  observadorId: string | null;
  diasEstimados: number;
  prioridad: string;
}>({
  buqueId: null,
  observadorId: null,
  diasEstimados: 30,
  prioridad: 'MEDIA'
});

const isEditBlockModalOpen = ref(false);
const editingBlockData = ref<MareaSimuladaItem | null>(null);

const observadorOptions = computed(() => {
  return observadoresBase.value.map(o => ({
    value: o.id,
    label: `${o.apellido}, ${o.nombre}`
  }));
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

const abrirModalCrearRecurso = () => {
  editingRecursoId.value = null;
  resourceForm.value = {
    buqueId: null,
    observadorId: null,
    diasEstimados: 30,
    prioridad: 'MEDIA'
  };
  isResourceModalOpen.value = true;
};

const abrirModalEditarRecurso = (recurso: RecursoPendiente) => {
  editingRecursoId.value = recurso.id;
  resourceForm.value = {
    buqueId: recurso.buqueId || null,
    observadorId: recurso.observadorId || null,
    diasEstimados: recurso.diasEstimados,
    prioridad: recurso.prioridad || 'MEDIA'
  };
  isResourceModalOpen.value = true;
};

const eliminarRecurso = (id: string) => {
  const idx = recursosPendientes.value.findIndex(r => r.id === id);
  if (idx !== -1) {
    recursosPendientes.value.splice(idx, 1);
    toast.success('Recurso eliminado');
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

  isResourceModalOpen.value = false;
};

const recursosVisibles = computed(() => {
  return recursosPendientes.value.filter(r => r.tipo === (activeTab.value === 'observador' ? 'buque' : 'observador'));
});
"""

content = content.replace(old_guardar_recurso, new_guardar_recurso)

handle_drop_old = """
const handleDropRecurso = (payload: { item: any, group: string, time: Date }) => {
  if (!draggedRecurso.value) return;

  const obsRow = datosSimulacion.value?.observadores.find(r => r.observador.id === payload.group);
  if (!obsRow && activeTab.value === 'observador') {
    toast.error('Grupo (observador) no encontrado.');
    return;
  }
  
  const rec = draggedRecurso.value;
  const startDate = payload.time;
  const endDate = new Date(startDate.getTime() + (rec.diasEstimados * 24 * 60 * 60 * 1000));

  const newSimulada: MareaSimuladaItem = {
    id: `sim-${Date.now()}`,
    tipoBloque: 'MAREA_SIMULADA',
    pesqueriaId: rec.pesqueriaId,
    pesqueriaNombre: rec.pesqueriaNombre,
    buqueId: rec.buqueId,
    buqueNombre: rec.buqueNombre,
    observadorId: payload.group,
    fechaZarpada: startDate,
    fechaArribo: endDate,
    diasEstimados: rec.diasEstimados,
    prioridad: rec.prioridad || 'MEDIA'
  };

  escenarioActual.value.items.push(newSimulada);
  
  // Eliminar el recurso de la lista
  const idx = recursosPendientes.value.findIndex(r => r.id === rec.id);
  if (idx !== -1) {
    recursosPendientes.value.splice(idx, 1);
  }

  draggedRecurso.value = null;
  toast.success('Marea simulada agregada al escenario');
};
"""

handle_drop_new = """
const handleDropRecurso = (payload: { item: any, group: string, time: Date }) => {
  if (!draggedRecurso.value) return;

  const rec = draggedRecurso.value as RecursoPendiente;
  const startDate = payload.time;
  const endDate = new Date(startDate.getTime() + (rec.diasEstimados * 24 * 60 * 60 * 1000));

  let obsId = "";
  let bId = rec.buqueId;
  let bNombre = rec.buqueNombre;
  let pId = rec.pesqueriaId;
  let pNombre = rec.pesqueriaNombre;
  
  if (activeTab.value === 'observador') {
    obsId = payload.group;
  } else {
    // payload.group es el buqueId
    bId = payload.group;
    obsId = rec.observadorId!;
    // Rellenar pesqueria si el buque existe en catalogo
    const bCatalog = buques.value.find(b => b.id === bId);
    if (bCatalog) {
       bNombre = bCatalog.nombreBuque;
       pId = bCatalog.pesqueriaHabitualId;
       pNombre = bCatalog.pesqueriaHabitual?.nombre;
    }
  }

  const newSimulada: MareaSimuladaItem = {
    id: `sim-${Date.now()}`,
    tipoBloque: 'MAREA_SIMULADA',
    pesqueriaId: pId,
    pesqueriaNombre: pNombre,
    buqueId: bId,
    buqueNombre: bNombre,
    observadorId: obsId,
    fechaZarpada: startDate,
    fechaArribo: endDate,
    diasEstimados: rec.diasEstimados,
    prioridad: rec.prioridad || 'MEDIA'
  };

  escenarioActual.value.items.push(newSimulada);
  
  // Eliminar el recurso de la lista
  const idx = recursosPendientes.value.findIndex(r => r.id === rec.id);
  if (idx !== -1) {
    recursosPendientes.value.splice(idx, 1);
  }

  draggedRecurso.value = null;
  toast.success('Marea simulada agregada al escenario');
};
"""

content = content.replace(handle_drop_old, handle_drop_new)

handle_drag_start_old = """
const handleDragStartRecurso = (e: DragEvent, recurso: RecursoMareaPendiente) => {
  draggedRecurso.value = recurso;
  if (e.dataTransfer) {
    e.dataTransfer.effectAllowed = 'copy';
    // Para Vis-Timeline
    e.dataTransfer.setData('text/plain', JSON.stringify({
      content: `Nueva Marea (${recurso.diasEstimados}d)`,
      className: 'vis-item-simulada'
    }));
  }
};
"""

handle_drag_start_new = """
const handleDragStartRecurso = (e: DragEvent, recurso: RecursoPendiente) => {
  draggedRecurso.value = recurso;
  if (e.dataTransfer) {
    e.dataTransfer.effectAllowed = 'copy';
    const label = recurso.tipo === 'buque' ? recurso.buqueNombre : recurso.observadorNombre;
    e.dataTransfer.setData('text/plain', JSON.stringify({
      content: `Nueva Marea: ${label} (${recurso.diasEstimados}d)`,
      className: 'vis-item-simulada'
    }));
  }
};
"""

content = content.replace(handle_drag_start_old, handle_drag_start_new)

devolver_recurso_old = """
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      pesqueriaId: removedItem.pesqueriaId,
      pesqueriaNombre: removedItem.pesqueriaNombre,
      buqueId: removedItem.buqueId,
      buqueNombre: removedItem.buqueNombre,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA',
      mesProyectado: 1
    });
"""

devolver_recurso_new = """
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      tipo: activeTab.value === 'observador' ? 'buque' : 'observador',
      pesqueriaId: removedItem.pesqueriaId,
      pesqueriaNombre: removedItem.pesqueriaNombre,
      buqueId: removedItem.buqueId,
      buqueNombre: removedItem.buqueNombre,
      observadorId: removedItem.observadorId,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA'
    });
"""

content = content.replace(devolver_recurso_old, devolver_recurso_new)

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(content)

print("Updated script logic")

