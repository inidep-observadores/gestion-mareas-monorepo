# coding=utf-8
import re

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    content = f.read()

timeline_groups_old = """
const timelineBuqueGroups = computed(() => {
  if (!datosSimulacion.value) return [];
  
  const buquesMap = new Map<string, string>();
  
  // Extraer buques de mareas reales
  datosSimulacion.value.observadores.forEach(obsRow => {
    obsRow.eventos.forEach(ev => {
      if (ev.buqueId && ev.buqueNombre) {
        buquesMap.set(ev.buqueId, ev.buqueNombre);
      }
    });
  });
  
  // Extraer buques simulados
  escenarioActual.value.items.forEach(sim => {
    if (sim.buqueId && sim.buqueNombre) {
      buquesMap.set(sim.buqueId, sim.buqueNombre);
    }
  });

  const groups = Array.from(buquesMap.entries()).map(([id, nombre]) => ({
    id: id,
    content: `<div class="text-text font-bold text-xs flex items-center gap-1"><span class="text-sm mr-1">⛴</span> ${nombre}</div>`,
    value: nombre
  }));
  
  // Ordenar alfabéticamente por nombre
  groups.sort((a, b) => a.value.localeCompare(b.value));
  
  return groups;
});
"""

timeline_groups_new = """
const timelineBuqueGroups = computed(() => {
  if (!datosSimulacion.value) return [];
  
  const buquesMap = new Map<string, any>();
  
  // Extraer buques de mareas reales
  datosSimulacion.value.observadores.forEach(obsRow => {
    obsRow.eventos.forEach(ev => {
      if (ev.buqueId && ev.buqueNombre) {
        buquesMap.set(ev.buqueId, { id: ev.buqueId, nombre: ev.buqueNombre });
      }
    });
  });
  
  // Extraer buques simulados
  escenarioActual.value.items.forEach(sim => {
    if (sim.buqueId && sim.buqueNombre) {
      buquesMap.set(sim.buqueId, { id: sim.buqueId, nombre: sim.buqueNombre });
    }
  });

  // Agregar buques manuales
  buquesAdicionales.value.forEach(bId => {
     const bData = buques.value.find(b => b.id === bId);
     if (bData) {
        buquesMap.set(bId, { id: bId, nombre: bData.nombreBuque });
     }
  });

  const pesqueriasMap = new Map<string, { id: string, content: string, nestedGroups: string[], value: string, treeLevel: number }>();
  const buqueGroups: any[] = [];

  Array.from(buquesMap.values()).forEach((bInfo) => {
    const bCatalog = buques.value.find(b => b.id === bInfo.id);
    const pesqueriaId = bCatalog?.pesqueriaHabitualId || 'sin-pesqueria';
    const pesqueriaNombre = bCatalog?.pesqueriaHabitual?.nombre || 'Sin Pesquería Asignada';

    if (!pesqueriasMap.has(pesqueriaId)) {
      pesqueriasMap.set(pesqueriaId, {
        id: `pesqueria-${pesqueriaId}`,
        content: `<div class="text-text font-bold text-sm bg-gray-100 p-1 rounded-sm">${pesqueriaNombre}</div>`,
        nestedGroups: [],
        value: pesqueriaNombre,
        treeLevel: 1
      });
    }

    pesqueriasMap.get(pesqueriaId)!.nestedGroups.push(bInfo.id);

    buqueGroups.push({
      id: bInfo.id,
      content: `<div class="text-text font-bold text-xs flex items-center gap-1"><span class="text-sm mr-1">⛴</span> ${bInfo.nombre}</div>`,
      value: bInfo.nombre,
      treeLevel: 2
    });
  });

  // Ordenar alfabéticamente
  buqueGroups.sort((a, b) => a.value.localeCompare(b.value));
  const parentGroups = Array.from(pesqueriasMap.values()).sort((a, b) => a.value.localeCompare(b.value));

  return [...parentGroups, ...buqueGroups];
});
"""

content = content.replace(timeline_groups_old, timeline_groups_new)

# Add buquesAdicionales state
additional_state_old = """
// Datos de Simulación
const datosSimulacion = ref<DisponibilidadResponse | null>(null);
"""
additional_state_new = """
const isAddBuqueModalOpen = ref(false);
const selectedBuqueToAdd = ref('');
const buquesAdicionales = ref<string[]>([]);

const addBuqueToTimeline = () => {
  if (selectedBuqueToAdd.value && !buquesAdicionales.value.includes(selectedBuqueToAdd.value)) {
    buquesAdicionales.value.push(selectedBuqueToAdd.value);
  }
  isAddBuqueModalOpen.value = false;
  selectedBuqueToAdd.value = '';
};

// Datos de Simulación
const datosSimulacion = ref<DisponibilidadResponse | null>(null);
"""

content = content.replace(additional_state_old, additional_state_new)

# Apply fix-types replacements
content = content.replace("const draggedRecurso = ref<RecursoMareaPendiente | null>(null);", "const draggedRecurso = ref<RecursoPendiente | null>(null);")
content = content.replace("import type { MareaSimuladaItem, RecursoMareaPendiente, EscenarioSimulacionState }", "import type { MareaSimuladaItem, EscenarioSimulacionState }")

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(content)

print("Updated timeline groups and state")

