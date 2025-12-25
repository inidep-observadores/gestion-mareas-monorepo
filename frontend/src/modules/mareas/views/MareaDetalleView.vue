<template>
  <AdminLayout>
    <div class="max-w-4xl mx-auto pb-12">
      <!-- Header -->
      <div class="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <button
            @click="goBack"
            class="flex items-center gap-2 text-sm text-gray-500 hover:text-brand-500 transition-colors mb-2"
          >
            <ArrowLeftIcon class="w-4 h-4" />
            Volver al Flujo de Trabajo
          </button>
          <h1 class="text-3xl font-bold text-gray-800 dark:text-white/90">
            Detalle de Marea: <span class="text-brand-500">{{ marea.code }}</span>
          </h1>
          <p class="text-gray-500 dark:text-gray-400 mt-1">
            Editando información técnica y operativa de la marea.
          </p>
        </div>

        <div class="flex items-center gap-3">
          <button
            class="px-5 py-2.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-all shadow-sm"
            @click="goBack"
          >
            Cancelar
          </button>
          <button
            class="px-5 py-2.5 text-sm font-medium text-white bg-brand-500 rounded-xl hover:bg-brand-600 transition-all shadow-md shadow-brand-500/20"
            @click="saveChanges"
          >
            Guardar Cambios
          </button>
        </div>
      </div>

      <!-- Form Content -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Left Column: Main Form -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Card: General Information -->
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm"
          >
            <h2
              class="text-lg font-bold text-gray-800 dark:text-white mb-6 flex items-center gap-2"
            >
              <ShipIcon class="w-5 h-5 text-brand-500" />
              Información del Buque y Marea
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700 dark:text-gray-300"
                  >Nombre del Buque</label
                >
                <input
                  v-model="marea.vessel"
                  type="text"
                  placeholder="Ej. BP ARGENTINO I"
                  class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all outline-none"
                />
              </div>
              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700 dark:text-gray-300"
                  >Matrícula</label
                >
                <input
                  v-model="marea.registration"
                  type="text"
                  placeholder="Ej. 01234F"
                  class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all outline-none"
                />
              </div>
              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700 dark:text-gray-300"
                  >Fecha de Inicio</label
                >
                <input
                  v-model="marea.startDate"
                  type="date"
                  class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all outline-none"
                />
              </div>
              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700 dark:text-gray-300"
                  >Fecha Estimada de Arribo</label
                >
                <input
                  v-model="marea.endDate"
                  type="date"
                  class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all outline-none"
                />
              </div>
            </div>
          </div>

          <!-- Card: Scientific Details -->
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm"
          >
            <h2
              class="text-lg font-bold text-gray-800 dark:text-white mb-6 flex items-center gap-2"
            >
              <BeakerIcon class="w-5 h-5 text-blue-500" />
              Detalles Científicos y Notas
            </h2>

            <div class="space-y-6">
              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700 dark:text-gray-300"
                  >Objetivo de la Marea</label
                >
                <textarea
                  v-model="marea.objective"
                  rows="3"
                  placeholder="Describa el objetivo principal de esta campaña..."
                  class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all outline-none resize-none"
                ></textarea>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700 dark:text-gray-300"
                  >Observaciones Generales</label
                >
                <textarea
                  v-model="marea.notes"
                  rows="4"
                  placeholder="Notas adicionales sobre el equipamiento, condiciones, etc."
                  class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl focus:ring-2 focus:ring-brand-500/20 focus:border-brand-500 transition-all outline-none resize-none"
                ></textarea>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Column: Contextual Info & Actions -->
        <div class="space-y-6">
          <!-- Status Card -->
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm"
          >
            <h3 class="font-bold text-gray-800 dark:text-white mb-4">Estado y Asignación</h3>

            <div class="space-y-4">
              <div class="space-y-1.5">
                <label class="text-xs font-bold uppercase tracking-wider text-gray-500"
                  >Estado Actual</label
                >
                <div
                  class="flex items-center gap-2 p-3 bg-brand-50 dark:bg-brand-500/10 rounded-xl border border-brand-100 dark:border-brand-500/20 text-brand-700 dark:text-brand-400 font-medium"
                >
                  <div class="w-2 h-2 rounded-full bg-brand-500 animate-pulse"></div>
                  {{ marea.status }}
                </div>
              </div>

              <div class="space-y-2">
                <label class="text-xs font-bold uppercase tracking-wider text-gray-500"
                  >Observador</label
                >
                <div
                  class="flex items-center gap-3 p-3 bg-gray-50 dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700"
                >
                  <div
                    class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-bold"
                  >
                    JD
                  </div>
                  <div>
                    <div class="text-sm font-bold text-gray-800 dark:text-gray-200">Juan Díaz</div>
                    <div class="text-[11px] text-gray-500">Senior - ID 4521</div>
                  </div>
                </div>
              </div>

              <button
                class="w-full py-2.5 text-sm font-medium text-brand-600 dark:text-brand-400 bg-brand-50 dark:bg-brand-500/10 rounded-xl hover:bg-brand-100 transition-colors"
              >
                Reasignar Observador
              </button>
            </div>
          </div>

          <!-- Quick Stats -->
          <div
            class="bg-gradient-to-br from-gray-800 to-gray-900 rounded-2xl p-6 text-white shadow-lg"
          >
            <h3 class="font-bold mb-4 opacity-80">Métricas del Buque</h3>
            <div class="space-y-4">
              <div class="flex justify-between items-center">
                <span class="text-sm opacity-60">Última posición</span>
                <span class="text-sm font-mono">41.2°S, 57.8°W</span>
              </div>
              <div class="flex justify-between items-center">
                <span class="text-sm opacity-60">Velocidad actual</span>
                <span class="text-sm">9.5 nudos</span>
              </div>
              <div class="flex justify-between items-center border-t border-white/10 pt-4 mt-4">
                <span class="text-sm opacity-60 font-bold">Días en mar</span>
                <span class="text-lg font-bold">12</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { ArrowLeftIcon, ShipIcon, BeakerIcon } from '@/icons'

const route = useRoute()
const router = useRouter()

const mareaId = route.params.id

// Mock data
const marea = ref({
  id: mareaId,
  code: 'MA-00' + mareaId,
  vessel: 'BP ARGENTINO I',
  registration: '01234F',
  startDate: '2023-12-20',
  endDate: '2024-01-15',
  status: 'Designada',
  objective: 'Relevamiento de calamar Illex argentinus en la Zona Común de Pesca.',
  notes:
    'Buque con equipamiento de sonar actualizado. Se requiere especial atención a la captura incidental de condrictios.',
})

const goBack = () => {
  router.push({ name: 'MareasWorkflow' })
}

const saveChanges = () => {
  console.log('Guardando cambios marea:', marea.value)
  // Simulación de guardado
  alert('Se han guardado los cambios correctamente (Simulación)')
  goBack()
}

onMounted(() => {
  // Aquí se cargaría la marea por ID desde un store o API
  console.log('Cargando detalle de marea ID:', mareaId)
})
</script>

<style scoped>
/* Transiciones suaves para inputs */
input,
textarea {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>
