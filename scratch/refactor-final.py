# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

# 1. Add recursosVisibles computed
recursos_vis_old = "const recursosPendientes = ref<RecursoPendiente[]>([]);"
recursos_vis_new = """const recursosPendientes = ref<RecursoPendiente[]>([]);

const recursosVisibles = computed(() => {
  return recursosPendientes.value.filter(r => r.tipo === (activeTab.value === 'observador' ? 'buque' : 'observador'));
});"""
c = c.replace(recursos_vis_old, recursos_vis_new)

# 2. Update sidebar template
sidebar_old = """v-for="recurso in recursosPendientes"
              :key="recurso.id"
              draggable="true"
              @dragstart="onDragStartRecurso($event, recurso)"
              @dblclick="abrirModalEditarRecurso(recurso)"
              class="p-3.5 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all cursor-grab active:cursor-grabbing shadow-sm group relative"
            >
              <div class="flex items-center justify-between mb-1.5 pr-14 relative">
                <span class="text-xs font-extrabold text-primary group-hover:text-primary-hover transition-colors truncate pr-2">
                  {{ recurso.pesqueriaNombre }}
                </span>"""

sidebar_new = """v-for="recurso in recursosVisibles"
              :key="recurso.id"
              draggable="true"
              @dragstart="onDragStartRecurso($event, recurso)"
              @dblclick="abrirModalEditarRecurso(recurso)"
              class="p-3.5 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all cursor-grab active:cursor-grabbing shadow-sm group relative"
            >
              <div class="flex items-center justify-between mb-1.5 pr-14 relative">
                <span class="text-xs font-extrabold text-primary group-hover:text-primary-hover transition-colors truncate pr-2">
                  {{ activeTab === 'observador' ? recurso.buqueNombre : recurso.observadorNombre }}
                </span>"""
c = c.replace(sidebar_old, sidebar_new)

sidebar_icons_old = """<div class="text-xs text-text-muted space-y-1">
                <div v-if="recurso.buqueNombre" class="flex items-center gap-1">
                  <ShipIcon class="w-3.5 h-3.5 shrink-0" />
                  <span class="font-medium text-text">{{ recurso.buqueNombre }}</span>
                </div>
                <div class="flex items-center justify-between text-[11px]">"""

sidebar_icons_new = """<div class="text-xs text-text-muted space-y-1">
                <div v-if="activeTab === 'observador' && recurso.pesqueriaNombre" class="flex items-center gap-1">
                  <WaveIcon class="w-3.5 h-3.5 shrink-0" />
                  <span class="font-medium text-text">{{ recurso.pesqueriaNombre }}</span>
                </div>
                <div class="flex items-center justify-between text-[11px]">"""
c = c.replace(sidebar_icons_old, sidebar_icons_new)

# 3. Update Modal template (isResourceFormValid, onBuqueResourceChange, etc)
valid_comp = """const isResourceFormValid = computed(() => {
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
};"""

c = c.replace("// Funciones", valid_comp + "\n\n// Funciones")

# 4. Update guardarRecurso
guardar_old = """const guardarRecurso = () => {
  const p = pesquerias.value.find(p => p.id === resourceForm.value.pesqueriaId);
  if (!p) {
    toast.error('Debe seleccionar una pesquería');
    return;
  }
  
  const b = resourceForm.value.buqueId ? buques.value.find(b => b.id === resourceForm.value.buqueId) : undefined;
  
  if (editingRecursoId.value) {
    const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
    if (idx !== -1) {
      recursosPendientes.value[idx] = {
        ...recursosPendientes.value[idx],
        pesqueriaId: p.id,
        pesqueriaNombre: p.nombre,
        buqueId: b?.id,
        buqueNombre: b?.nombreBuque,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      };
      toast.success('Requerimiento actualizado');
    }
  } else {
    recursosPendientes.value.push({
      id: `rec-${Date.now()}`,
      tipo: 'buque',
      pesqueriaId: p.id,
      pesqueriaNombre: p.nombre,
      buqueId: b?.id,
      buqueNombre: b?.nombreBuque,
      diasEstimados: resourceForm.value.diasEstimados,
      prioridad: resourceForm.value.prioridad
    });
    toast.success('Requerimiento creado');
  }
  
  cerrarModalRecurso();
};"""

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

c = c.replace(guardar_old, guardar_new)

# 5. Fix form reset
form_reset_old = """const abrirModalCrearRecurso = () => {
  editingRecursoId.value = null;
  resourceForm.value = {
    pesqueriaId: '',
    buqueId: null,
    diasEstimados: 30,
    prioridad: 'MEDIA',
    observadorId: null,
  };
  isResourceModalOpen.value = true;
};"""

form_reset_new = """const abrirModalCrearRecurso = () => {
  editingRecursoId.value = null;
  resourceForm.value = {
    pesqueriaId: '',
    buqueId: null,
    diasEstimados: 30,
    prioridad: 'MEDIA',
    observadorId: null,
  };
  isResourceModalOpen.value = true;
};"""
c = c.replace(form_reset_old, form_reset_new)

# 6. handleDropRecurso
drop_old = """const handleDropRecurso = (payload: { recurso: any; group: string; date: Date }) => {
  const recursoArrastrado = payload.recurso;
  let fechaInicio = payload.date;
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (fechaInicio < today) {
    fechaInicio = today;
  }

  const fechaFin = new Date(fechaInicio.getTime() + recursoArrastrado.diasEstimados * 24 * 60 * 60 * 1000);

  const nuevoItemSimulado: MareaSimuladaItem = {
    id: `sim-${Date.now()}`,
    observadorId: activeTab.value === 'observador' ? payload.group : null,
    buqueId: activeTab.value === 'buque' ? payload.group : (recursoArrastrado.buqueId || null),
    pesqueriaId: recursoArrastrado.pesqueriaId,
    pesqueriaNombre: recursoArrastrado.pesqueriaNombre,
    buqueNombre: activeTab.value === 'buque' ? (timelineBuqueGroups.value.find(g => g.id === payload.group)?.value || recursoArrastrado.buqueNombre) : recursoArrastrado.buqueNombre,
    fechaZarpada: fechaInicio,
    fechaArribo: fechaFin,
    diasEstimados: recursoArrastrado.diasEstimados,
    estado: 'PENDIENTE',
    tipoBloque: 'MAREA_SIMULADA',
    prioridad: recursoArrastrado.prioridad
  };

  escenarioActual.value.items.push(nuevoItemSimulado);

  // Remover del sidebar pendiente
  const idxRec = recursosPendientes.value.findIndex(r => r.id === recursoArrastrado.id);
  if (idxRec !== -1) {
    recursosPendientes.value.splice(idxRec, 1);
    if (recursosPendientes.value.length === 0) {
      sidebarOpen.value = false;
    }
  }

  toast.success(`Marea simulada "${recursoArrastrado.pesqueriaNombre}" asignada`);
};"""

drop_new = """const handleDropRecurso = (payload: { recurso: any; group: string; date: Date }) => {
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

  escenarioActual.value.items.push(nuevoItemSimulado);

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
c = c.replace(drop_old, drop_new)

# 7. Edit Modal fields
modal_fields_old = """<div class="space-y-4" v-if="!loadingCatalogs">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Pesquería (obligatorio)</label>
            <SearchableSelect 
              ref="pesqueriaSelectRef"
              v-model="resourceForm.pesqueriaId" 
              :options="pesqueriaOptions" 
              :icon="WaveIcon" 
              placeholder="Seleccione pesquería..." 
            />
          </div>
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque (opcional)</label>
            <SearchableSelect 
              v-model="resourceForm.buqueId" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
              @change="handleBuqueChange"
            />
          </div>
          <div class="grid grid-cols-2 gap-4">"""

modal_fields_new = """<div class="space-y-4" v-if="!loadingCatalogs">
          <div class="space-y-1.5" v-if="activeTab === 'observador'">
            <label class="block text-xs font-bold text-text-muted">Buque (obligatorio)</label>
            <SearchableSelect 
              ref="buqueSelectRef"
              v-model="resourceForm.buqueId" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
              @change="onBuqueResourceChange"
            />
          </div>
          <div class="space-y-1.5" v-if="activeTab === 'buque'">
            <label class="block text-xs font-bold text-text-muted">Observador (obligatorio)</label>
            <SearchableSelect 
              ref="observadorSelectRef"
              v-model="resourceForm.observadorId" 
              :options="observadorOptions" 
              :icon="UserCircleIcon" 
              placeholder="Seleccione observador..." 
            />
          </div>
          <div class="grid grid-cols-2 gap-4">"""
c = c.replace(modal_fields_old, modal_fields_new)

btn_old = """<button @click="guardarRecurso" :disabled="loadingCatalogs" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Guardar</button>"""
btn_new = """<button @click="guardarRecurso" :disabled="loadingCatalogs || !isResourceFormValid" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Guardar</button>"""
c = c.replace(btn_old, btn_new)

# Add isAddBuqueModalOpen logic to template
tabs_old = """<button 
              @click="activeTab = 'buque'" 
              class="px-5 py-3 text-sm font-black uppercase tracking-wider border-b-2 transition-colors -mb-px flex items-center gap-2"
              :class="activeTab === 'buque' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
            >
              <ShipIcon class="w-4 h-4" />
              Por buque
            </button>
          </div>

          <!-- Loading State -->"""
tabs_new = """<button 
              @click="activeTab = 'buque'" 
              class="px-5 py-3 text-sm font-black uppercase tracking-wider border-b-2 transition-colors -mb-px flex items-center gap-2"
              :class="activeTab === 'buque' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
            >
              <ShipIcon class="w-4 h-4" />
              Por buque
            </button>
            <div class="ml-auto pr-4" v-if="activeTab === 'buque'">
              <button 
                @click="isAddBuqueModalOpen = true"
                class="px-3 py-1.5 text-xs font-bold text-primary border border-primary rounded hover:bg-primary hover:text-white transition-colors flex items-center gap-1"
              >
                <PlusIcon class="w-3.5 h-3.5" /> Agregar Buque
              </button>
            </div>
          </div>

          <!-- Loading State -->"""
c = c.replace(tabs_old, tabs_new)

# Add Modal Agregar Buque
add_modal_old = """</BaseModal>

    <!-- Modal Editar Bloque Simulado -->"""
add_modal_new = """</BaseModal>

    <!-- Modal Agregar Buque al Timeline -->
    <BaseModal 
      :show="isAddBuqueModalOpen" 
      @close="isAddBuqueModalOpen = false" 
      maxWidth="md" 
      title="Agregar Buque al Timeline"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div class="space-y-4">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque</label>
            <SearchableSelect 
              v-model="selectedBuqueToAdd" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
            />
          </div>
        </div>
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="isAddBuqueModalOpen = false" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">Cancelar</button>
          <button @click="addBuqueToTimeline" :disabled="!selectedBuqueToAdd" class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Aceptar</button>
        </div>
      </div>
    </BaseModal>

    <!-- Modal Editar Bloque Simulado -->"""
c = c.replace(add_modal_old, add_modal_new)

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)

print("Applied replacements")
