
import re

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add "Agregar Buque" modal to template
modal_agregar_buque = """
    <!-- Modal Agregar Buque al Timeline -->
    <div v-if="isAddBuqueModalOpen" class="fixed inset-0 z-[100] flex items-center justify-center bg-black/50">
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md overflow-hidden">
        <div class="px-4 py-3 border-b flex justify-between items-center bg-gray-50">
          <h3 class="font-semibold text-text">Agregar Buque al Timeline</h3>
          <button @click="isAddBuqueModalOpen = false" class="text-gray-400 hover:text-gray-600">
            <span class="icon-[mdi--close] text-xl"></span>
          </button>
        </div>
        <div class="p-4">
          <div class="mb-4">
            <label class="block text-sm font-medium mb-1">Seleccionar Buque</label>
            <select v-model="selectedBuqueToAdd" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option value="">-- Seleccionar Buque --</option>
              <option v-for="b in buqueOptions" :key="b.value" :value="b.value">
                {{ b.label }}
              </option>
            </select>
          </div>
        </div>
        <div class="px-4 py-3 border-t bg-gray-50 flex justify-end gap-2">
          <button @click="isAddBuqueModalOpen = false" class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded border">Cancelar</button>
          <button @click="addBuqueToTimeline" :disabled="!selectedBuqueToAdd" class="px-4 py-2 text-sm font-medium text-white bg-primary hover:bg-primary-dark rounded disabled:opacity-50">Agregar</button>
        </div>
      </div>
    </div>
"""

content = content.replace("</template>", modal_agregar_buque + "\n</template>")

# 2. Add Button to add Buque
add_buque_btn = """
          <!-- Agregar Buque (Solo en Tab 2) -->
          <button v-if="activeTab === 'buque'" @click="isAddBuqueModalOpen = true" class="flex items-center gap-1.5 px-3 py-1.5 bg-white border border-gray-200 rounded-md text-sm font-medium text-text hover:bg-gray-50 hover:text-primary transition-colors shadow-sm">
            <span class="icon-[mdi--ship-wheel] text-lg"></span>
            Agregar Buque
          </button>
"""
# find place to insert
content = content.replace("""<!-- Panel Central - Timeline -->""", """<!-- Panel Central - Timeline -->""" + add_buque_btn)

# Write back
with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(content)

