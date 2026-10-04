import sys

def modify_vue_file():
    with open('app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue', 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Add ConfirmationDialog to template
    dialogs = """
    <ConfirmationDialog
      :show="showConfirmNoObserver"
      title="Planificar sin observador"
      message="¿Seguro que desea planificar esta marea simulada sin asignarle un observador? Se mostrará en el sistema como 'Sin observador'."
      confirmText="Sí, planificar"
      cancelText="Cancelar"
      @confirm="confirmarSinObservador"
      @cancel="cancelarSinObservador"
    />
  </PlanificacionDashboardLayout>"""
    if "showConfirmNoObserver" not in content:
        content = content.replace("  </PlanificacionDashboardLayout>", dialogs)

    # 2. Add dialog refs and methods
    script_additions = """
const showConfirmNoObserver = ref(false);
let pendingNoObserverAction: (() => void) | null = null;

const confirmarSinObservador = () => {
  if (pendingNoObserverAction) {
    pendingNoObserverAction();
    pendingNoObserverAction = null;
  }
  showConfirmNoObserver.value = false;
};

const cancelarSinObservador = () => {
  pendingNoObserverAction = null;
  showConfirmNoObserver.value = false;
};
"""
    if "showConfirmNoObserver = ref(false);" not in content:
        content = content.replace("const showConfirmDeleteScenario = ref(false);", script_additions + "\nconst showConfirmDeleteScenario = ref(false);")

    # 3. Update isResourceFormValid
    old_valid = """const isResourceFormValid = computed(() => {
  if (activeTab.value === 'observador') return !!resourceForm.value.buqueId;
  return !!resourceForm.value.observadorId;
});"""
    new_valid = """const isResourceFormValid = computed(() => {
  if (activeTab.value === 'observador') return !!resourceForm.value.buqueId;
  return true; // Ya no es obligatorio el observador
});"""
    content = content.replace(old_valid, new_valid)

    # 4. Modify guardarCreacionBloque
    old_guardar = """const guardarCreacionBloque = () => {
  if (!newBlockData.value) return;
  
  if (!newBlockData.value.observadorId) {
    toast.error('Debe seleccionar un observador');
    return;
  }
  if (!newBlockData.value.buqueId) {
    toast.error('Debe seleccionar un buque');
    return;
  }

  const buque = buques.value.find(b => b.id === newBlockData.value?.buqueId);
  if (buque) {
    newBlockData.value.buqueNombre = buque.nombreBuque;
    newBlockData.value.pesqueriaId = buque.pesqueriaHabitualId;
    newBlockData.value.pesqueriaNombre = buque.pesqueriaHabitual?.nombre || '';
    
    // Agregar el buque al timeline si no estaba
    if (!buquesAdicionales.value.includes(buque.id)) {
      buquesAdicionales.value.push(buque.id);
    }
  }

  const obsData = datosSimulacion.value?.observadores.find(o => o.observador.id === newBlockData.value!.observadorId)?.observador;
  if (obsData) {
    newBlockData.value.observadorNombre = `${obsData.apellido}, ${obsData.nombre}`;
  }

  const fechaZarpada = new Date(newBlockData.value.fechaZarpada);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (fechaZarpada < today) {
    toast.error('No se pueden proyectar mareas en fechas pasadas');
    return;
  }

  if (escenarioActual.value) {
    escenarioActual.value.items.push({ ...newBlockData.value });
    hasUnsavedChanges.value = true;
    guardarEscenario();
    toast.success('Marea planificada creada correctamente');
  } else {
    toast.error('No hay escenario actual seleccionado');
  }
  
  cerrarModalCrearBloque();
};"""
    
    new_guardar = """const guardarCreacionBloque = () => {
  if (!newBlockData.value) return;
  
  if (!newBlockData.value.buqueId) {
    toast.error('Debe seleccionar un buque');
    return;
  }

  const processSave = () => {
    const buque = buques.value.find(b => b.id === newBlockData.value?.buqueId);
    if (buque) {
      newBlockData.value!.buqueNombre = buque.nombreBuque;
      newBlockData.value!.pesqueriaId = buque.pesqueriaHabitualId;
      newBlockData.value!.pesqueriaNombre = buque.pesqueriaHabitual?.nombre || '';
      
      // Agregar el buque al timeline si no estaba
      if (!buquesAdicionales.value.includes(buque.id)) {
        buquesAdicionales.value.push(buque.id);
      }
    }

    if (newBlockData.value!.observadorId) {
      const obsData = datosSimulacion.value?.observadores.find(o => o.observador.id === newBlockData.value!.observadorId)?.observador;
      if (obsData) {
        newBlockData.value!.observadorNombre = `${obsData.apellido}, ${obsData.nombre}`;
      }
    } else {
      newBlockData.value!.observadorNombre = undefined;
    }

    const fechaZarpada = new Date(newBlockData.value!.fechaZarpada);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (fechaZarpada < today) {
      toast.error('No se pueden proyectar mareas en fechas pasadas');
      return;
    }

    if (escenarioActual.value) {
      escenarioActual.value.items.push({ ...newBlockData.value! });
      hasUnsavedChanges.value = true;
      guardarEscenario();
      toast.success('Marea planificada creada correctamente');
    } else {
      toast.error('No hay escenario actual seleccionado');
    }
    
    cerrarModalCrearBloque();
  };

  if (!newBlockData.value.observadorId) {
    pendingNoObserverAction = processSave;
    showConfirmNoObserver.value = true;
  } else {
    processSave();
  }
};"""
    content = content.replace(old_guardar, new_guardar)

    # 5. Modify handleDropRecurso
    old_drop = """const handleDropRecurso = (payload: { recurso: any; group: string; date: Date }) => {
  const recursoArrastrado = payload.recurso;
  let fechaInicio = payload.date;
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (fechaInicio < today) {
    fechaInicio = today;
  }

  const fechaFin = new Date(fechaInicio.getTime() + recursoArrastrado.diasEstimados * 24 * 60 * 60 * 1000);

  let obsId = undefined;
  let bId = recursoArrastrado.buqueId;
  let bNombre = recursoArrastrado.buqueNombre;
  let pId = recursoArrastrado.pesqueriaId;
  let pNombre = recursoArrastrado.pesqueriaNombre;
  
  if (activeTab.value === 'observador') {
    obsId = payload.group;
  } else {
    // payload.group es el buqueId
    bId = payload.group;
    obsId = recursoArrastrado.observadorId!;
    // Rellenar pesqueria si el buque existe en catalogo
    const bCatalog = buques.value.find(b => b.id === bId);
    if (bCatalog) {
       bNombre = bCatalog.nombreBuque;
       pId = bCatalog.pesqueriaHabitualId;
       pNombre = bCatalog.pesqueriaHabitual?.nombre;
    }
  }

  const nuevoItemSimulado: MareaSimuladaItem = {
    id: `sim-${Date.now()}`,
    tipoBloque: 'MAREA_SIMULADA',
    pesqueriaId: pId,
    pesqueriaNombre: pNombre,
    buqueId: bId,
    buqueNombre: bNombre,
    observadorId: obsId,
    fechaZarpada: fechaInicio,
    fechaArribo: fechaFin,
    diasEstimados: recursoArrastrado.diasEstimados,
    estado: 'PENDIENTE',
    prioridad: recursoArrastrado.prioridad || 'MEDIA'
  };

  escenarioActual.value!.items.push(nuevoItemSimulado);
  hasUnsavedChanges.value = true;
  guardarEscenario();

  // Remover del sidebar pendiente
  const idxRec = recursosPendientes.value.findIndex(r => r.id === recursoArrastrado.id);
  if (idxRec !== -1) {
    recursosPendientes.value.splice(idxRec, 1);
    if (recursosPendientes.value.length === 0) {
      sidebarOpen.value = false;
    }
  }

  toast.success('Marea simulada asignada');
};"""

    new_drop = """const handleDropRecurso = (payload: { recurso: any; group: string; date: Date }) => {
  const recursoArrastrado = payload.recurso;
  let fechaInicio = payload.date;
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (fechaInicio < today) {
    fechaInicio = today;
  }

  const fechaFin = new Date(fechaInicio.getTime() + recursoArrastrado.diasEstimados * 24 * 60 * 60 * 1000);

  let obsId = undefined;
  let bId = recursoArrastrado.buqueId;
  let bNombre = recursoArrastrado.buqueNombre;
  let pId = recursoArrastrado.pesqueriaId;
  let pNombre = recursoArrastrado.pesqueriaNombre;
  
  if (activeTab.value === 'observador') {
    obsId = payload.group;
  } else {
    // payload.group es el buqueId
    bId = payload.group;
    obsId = recursoArrastrado.observadorId || undefined;
    // Rellenar pesqueria si el buque existe en catalogo
    const bCatalog = buques.value.find(b => b.id === bId);
    if (bCatalog) {
       bNombre = bCatalog.nombreBuque;
       pId = bCatalog.pesqueriaHabitualId;
       pNombre = bCatalog.pesqueriaHabitual?.nombre;
    }
  }

  const processDrop = () => {
    const nuevoItemSimulado: MareaSimuladaItem = {
      id: `sim-${Date.now()}`,
      tipoBloque: 'MAREA_SIMULADA',
      pesqueriaId: pId,
      pesqueriaNombre: pNombre,
      buqueId: bId,
      buqueNombre: bNombre,
      observadorId: obsId,
      fechaZarpada: fechaInicio,
      fechaArribo: fechaFin,
      diasEstimados: recursoArrastrado.diasEstimados,
      estado: 'PENDIENTE',
      prioridad: recursoArrastrado.prioridad || 'MEDIA'
    };

    escenarioActual.value!.items.push(nuevoItemSimulado);
    hasUnsavedChanges.value = true;
    guardarEscenario();

    // Remover del sidebar pendiente
    const idxRec = recursosPendientes.value.findIndex(r => r.id === recursoArrastrado.id);
    if (idxRec !== -1) {
      recursosPendientes.value.splice(idxRec, 1);
      if (recursosPendientes.value.length === 0) {
        sidebarOpen.value = false;
      }
    }

    toast.success('Marea simulada asignada');
  };

  if (!obsId) {
    pendingNoObserverAction = processDrop;
    showConfirmNoObserver.value = true;
  } else {
    processDrop();
  }
};"""
    content = content.replace(old_drop, new_drop)

    # 6. Change "Sin Asignar" to "Sin observador"
    content = content.replace('let obsNombre = "Sin Asignar";', 'let obsNombre = "Sin observador";')

    with open('app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue', 'w', encoding='utf-8') as f:
        f.write(content)

modify_vue_file()
