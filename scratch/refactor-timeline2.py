
# coding=utf-8
import re

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "r", encoding="utf-8") as f:
    content = f.read()

# Replace the sidebar resource form logic

sidebar_old = """
        <!-- Panel derecho - Agregar recurso manual -->
        <div v-if="sidebarOpen" class="w-80 bg-white border-l border-gray-200 flex flex-col">
          <div class="p-4 border-b bg-gray-50 flex items-center justify-between">
            <h3 class="font-semibold text-text">Recursos de Mareas</h3>
            <button @click="abrirModalCrearRecurso" class="p-1 hover:bg-gray-200 rounded text-primary" title="Agregar requerimiento">
              <span class="icon-[mdi--plus-circle] text-2xl"></span>
            </button>
          </div>
          
          <div class="flex-1 overflow-y-auto p-4 bg-gray-50">
            <div v-if="recursosPendientes.length === 0" class="text-center text-gray-500 text-sm mt-8">
              No hay recursos pendientes.<br/>
              Haga clic en "+" para planificar una marea.
            </div>

            <div v-for="recurso in recursosPendientes" :key="recurso.id" 
                 class="recurso-draggable bg-white rounded-lg p-3 shadow-sm border-l-4 border-primary mb-3 cursor-grab active:cursor-grabbing hover:shadow-md transition-shadow relative group"
                 draggable="true" 
                 @dragstart="e => handleDragStartRecurso(e, recurso)">
              
              <!-- Botones de acción overlay -->
              <div class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity flex gap-1">
                <button @click.stop="abrirModalEditarRecurso(recurso)" class="text-gray-400 hover:text-primary">
                  <span class="icon-[mdi--pencil] text-base"></span>
                </button>
                <button @click.stop="eliminarRecurso(recurso.id)" class="text-gray-400 hover:text-error">
                  <span class="icon-[mdi--trash] text-base"></span>
                </button>
              </div>

              <div class="font-bold text-sm text-text mb-1 pr-12">{{ recurso.pesqueriaNombre }}</div>
              <div class="flex items-center gap-2 text-xs text-gray-600 mb-2">
                <span class="icon-[mdi--clock-outline]"></span>
                {{ recurso.diasEstimados }} días est.
              </div>
              <div class="flex items-center gap-2 text-xs">
                <span v-if="recurso.buqueId" class="px-2 py-0.5 bg-blue-50 text-blue-700 rounded-full font-medium flex items-center gap-1">
                  <span class="icon-[mdi--ferry] text-sm"></span>
                  {{ recurso.buqueNombre }}
                </span>
                <span v-else class="px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full italic">
                  Buque a definir
                </span>
              </div>
            </div>
          </div>
        </div>
"""

sidebar_new = """
        <!-- Panel derecho - Agregar recurso manual -->
        <div v-if="sidebarOpen" class="w-80 bg-white border-l border-gray-200 flex flex-col">
          <div class="p-4 border-b bg-gray-50 flex items-center justify-between">
            <h3 class="font-semibold text-text">Recursos ({{ activeTab === 'observador' ? 'Buques' : 'Observadores' }})</h3>
            <button @click="abrirModalCrearRecurso" class="p-1 hover:bg-gray-200 rounded text-primary" title="Agregar recurso">
              <span class="icon-[mdi--plus-circle] text-2xl"></span>
            </button>
          </div>
          
          <div class="flex-1 overflow-y-auto p-4 bg-gray-50">
            <div v-if="recursosVisibles.length === 0" class="text-center text-gray-500 text-sm mt-8">
              No hay recursos pendientes de tipo {{ activeTab === 'observador' ? 'Buque' : 'Observador' }}.<br/>
              Haga clic en "+" para planificar.
            </div>

            <div v-for="recurso in recursosVisibles" :key="recurso.id" 
                 class="recurso-draggable bg-white rounded-lg p-3 shadow-sm border-l-4 border-primary mb-3 cursor-grab active:cursor-grabbing hover:shadow-md transition-shadow relative group"
                 draggable="true" 
                 @dragstart="e => handleDragStartRecurso(e, recurso)">
              
              <!-- Botones de acción overlay -->
              <div class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity flex gap-1">
                <button @click.stop="abrirModalEditarRecurso(recurso)" class="text-gray-400 hover:text-primary">
                  <span class="icon-[mdi--pencil] text-base"></span>
                </button>
                <button @click.stop="eliminarRecurso(recurso.id)" class="text-gray-400 hover:text-error">
                  <span class="icon-[mdi--trash] text-base"></span>
                </button>
              </div>

              <div class="font-bold text-sm text-text mb-1 pr-12">
                {{ activeTab === 'observador' ? recurso.buqueNombre : recurso.observadorNombre }}
              </div>
              <div class="flex items-center gap-2 text-xs text-gray-600 mb-2">
                <span class="icon-[mdi--clock-outline]"></span>
                {{ recurso.diasEstimados }} días est.
              </div>
              <div v-if="activeTab === 'observador' && recurso.pesqueriaNombre" class="flex items-center gap-2 text-xs">
                <span class="px-2 py-0.5 bg-blue-50 text-blue-700 rounded-full font-medium">
                  {{ recurso.pesqueriaNombre }}
                </span>
              </div>
            </div>
          </div>
        </div>
"""

content = content.replace(sidebar_old, sidebar_new)

# Update Modal Recurso
modal_old = """
    <!-- Modal Agregar/Editar Recurso -->
    <div v-if="isResourceModalOpen" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md overflow-hidden">
        <div class="px-4 py-3 border-b flex justify-between items-center bg-gray-50">
          <h3 class="font-semibold text-text">{{ editingRecursoId ? 'Editar Marea Requerida' : 'Nueva Marea Requerida' }}</h3>
          <button @click="isResourceModalOpen = false" class="text-gray-400 hover:text-gray-600">
            <span class="icon-[mdi--close] text-xl"></span>
          </button>
        </div>
        <div class="p-4 space-y-4">
          <div>
            <label class="block text-sm font-medium mb-1">Pesquería <span class="text-error">*</span></label>
            <select ref="pesqueriaSelectRef" v-model="resourceForm.pesqueriaId" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option value="">-- Seleccionar Pesquería --</option>
              <option v-for="p in pesqueriaOptions" :key="p.value" :value="p.value">{{ p.label }}</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Buque (Opcional)</label>
            <select v-model="resourceForm.buqueId" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option :value="null">-- A definir luego --</option>
              <option v-for="b in buqueOptions" :key="b.value" :value="b.value">{{ b.label }}</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Días Estimados</label>
            <input type="number" v-model="resourceForm.diasEstimados" min="1" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Prioridad</label>
            <select v-model="resourceForm.prioridad" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option value="ALTA">Alta</option>
              <option value="MEDIA">Media</option>
              <option value="BAJA">Baja</option>
            </select>
          </div>
        </div>
        <div class="px-4 py-3 border-t bg-gray-50 flex justify-end gap-2">
          <button @click="isResourceModalOpen = false" class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded border">Cancelar</button>
          <button @click="guardarRecurso" :disabled="!resourceForm.pesqueriaId" class="px-4 py-2 text-sm font-medium text-white bg-primary hover:bg-primary-dark rounded disabled:opacity-50">
            {{ editingRecursoId ? 'Actualizar' : 'Agregar' }}
          </button>
        </div>
      </div>
    </div>
"""

modal_new = """
    <!-- Modal Agregar/Editar Recurso -->
    <div v-if="isResourceModalOpen" class="fixed inset-0 z-[100] flex items-center justify-center bg-black/50">
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md overflow-hidden">
        <div class="px-4 py-3 border-b flex justify-between items-center bg-gray-50">
          <h3 class="font-semibold text-text">{{ editingRecursoId ? 'Editar Recurso' : 'Nuevo Recurso' }}</h3>
          <button @click="isResourceModalOpen = false" class="text-gray-400 hover:text-gray-600">
            <span class="icon-[mdi--close] text-xl"></span>
          </button>
        </div>
        <div class="p-4 space-y-4">
          <div v-if="activeTab === 'observador'">
            <label class="block text-sm font-medium mb-1">Buque <span class="text-error">*</span></label>
            <select v-model="resourceForm.buqueId" @change="onBuqueResourceChange" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option value="">-- Seleccionar Buque --</option>
              <option v-for="b in buqueOptions" :key="b.value" :value="b.value">{{ b.label }}</option>
            </select>
          </div>
          <div v-if="activeTab === 'buque'">
            <label class="block text-sm font-medium mb-1">Observador <span class="text-error">*</span></label>
            <select v-model="resourceForm.observadorId" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option value="">-- Seleccionar Observador --</option>
              <option v-for="o in observadorOptions" :key="o.value" :value="o.value">{{ o.label }}</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Días Estimados</label>
            <input type="number" v-model="resourceForm.diasEstimados" min="1" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Prioridad</label>
            <select v-model="resourceForm.prioridad" class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
              <option value="ALTA">Alta</option>
              <option value="MEDIA">Media</option>
              <option value="BAJA">Baja</option>
            </select>
          </div>
        </div>
        <div class="px-4 py-3 border-t bg-gray-50 flex justify-end gap-2">
          <button @click="isResourceModalOpen = false" class="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded border">Cancelar</button>
          <button @click="guardarRecurso" :disabled="!isResourceFormValid" class="px-4 py-2 text-sm font-medium text-white bg-primary hover:bg-primary-dark rounded disabled:opacity-50">
            {{ editingRecursoId ? 'Actualizar' : 'Agregar' }}
          </button>
        </div>
      </div>
    </div>
"""
content = content.replace(modal_old, modal_new)

with open("app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue", "w", encoding="utf-8") as f:
    f.write(content)

print("Updated template")

