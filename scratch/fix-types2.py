# coding=utf-8
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    c = f.read()

# Fix null to undefined in assignments
c = c.replace("buqueId: removedItem.buqueId || null,", "buqueId: removedItem.buqueId || undefined,")
c = c.replace("observadorId: removedItem.observadorId || null,", "observadorId: removedItem.observadorId || undefined,")
c = c.replace("pesqueriaId: removedItem.pesqueriaId || null,", "pesqueriaId: removedItem.pesqueriaId || undefined,")
c = c.replace("pesqueriaNombre: removedItem.pesqueriaNombre || null,", "pesqueriaNombre: removedItem.pesqueriaNombre || undefined,")
c = c.replace("buqueNombre: removedItem.buqueNombre || null,", "buqueNombre: removedItem.buqueNombre || undefined,")

# Also the ones without || null
c = c.replace("buqueId: removedItem.buqueId,", "buqueId: removedItem.buqueId || undefined,")
c = c.replace("observadorId: removedItem.observadorId,", "observadorId: removedItem.observadorId || undefined,")
c = c.replace("pesqueriaId: removedItem.pesqueriaId,", "pesqueriaId: removedItem.pesqueriaId || undefined,")
c = c.replace("pesqueriaNombre: removedItem.pesqueriaNombre,", "pesqueriaNombre: removedItem.pesqueriaNombre || undefined,")
c = c.replace("buqueNombre: removedItem.buqueNombre,", "buqueNombre: removedItem.buqueNombre || undefined,")

# Remove remaining RecursoMareaPendiente
c = c.replace("recurso: RecursoMareaPendiente", "recurso: RecursoPendiente")
c = c.replace("RecursoMareaPendiente", "RecursoPendiente")

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(c)

