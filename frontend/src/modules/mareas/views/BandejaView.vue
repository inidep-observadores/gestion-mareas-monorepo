<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">
            Bandeja de Entrada Centralizada
          </h1>
          <p class="text-gray-500 dark:text-gray-400">
            Punto único para gestionar eventos, movimientos y novedades de mareas.
          </p>
        </div>
        <div class="flex gap-3">
          <button
            class="flex items-center gap-2 px-4 py-2 bg-brand-500 text-white rounded-lg hover:bg-brand-600 transition-colors"
          >
            <PlusIcon class="w-5 h-5" />
            Registrar Evento
          </button>
          <button
            class="flex items-center gap-2 px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <DocsIcon class="w-5 h-5" />
            Buscar Marea
          </button>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-6">
        <!-- Main Inbox Table -->
        <div class="col-span-12 xl:col-span-8">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-xl overflow-hidden"
          >
            <div
              class="p-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between"
            >
              <div class="flex gap-4">
                <button class="text-brand-500 font-medium border-b-2 border-brand-500 pb-1">
                  Pendientes
                </button>
                <button
                  class="text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300"
                >
                  Mis asignaciones
                </button>
                <button
                  class="text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300"
                >
                  Alertas
                </button>
              </div>
            </div>
            <!-- Mock Table -->
            <div class="overflow-x-auto">
              <table class="w-full text-left">
                <thead
                  class="bg-gray-50 dark:bg-gray-800/50 text-xs uppercase text-gray-500 dark:text-gray-400"
                >
                  <tr>
                    <th class="px-6 py-3">Marea / Buque</th>
                    <th class="px-6 py-3">Tipo / Título</th>
                    <th class="px-6 py-3">Prioridad</th>
                    <th class="px-6 py-3">Estado</th>
                    <th class="px-6 py-3 text-right">Acciones</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
                  <tr
                    v-for="i in 5"
                    :key="i"
                    class="hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors cursor-pointer"
                  >
                    <td class="px-6 py-4">
                      <div class="font-medium text-gray-900 dark:text-white">AR-2023-00{{ i }}</div>
                      <div class="text-sm text-gray-500">Buque Pesquero {{ i }}</div>
                    </td>
                    <td class="px-6 py-4">
                      <span
                        class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400 mb-1"
                      >
                        Acción pendiente
                      </span>
                      <div class="text-sm text-gray-700 dark:text-gray-300">
                        Registrar arribo de marea
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <span
                        class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-orange-100 text-orange-800 dark:bg-orange-900/30 dark:text-orange-400"
                      >
                        Media
                      </span>
                    </td>
                    <td class="px-6 py-4">
                      <span
                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400"
                      >
                        Abierto
                      </span>
                    </td>
                    <td class="px-6 py-4 text-right">
                      <button class="text-brand-500 hover:text-brand-600 font-medium text-sm">
                        Gestionar
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Detail Sidebar (Inline) -->
        <div class="col-span-12 xl:col-span-4">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-xl p-6"
          >
            <h3 class="text-lg font-bold text-gray-800 dark:text-white mb-4">Detalle del Ítem</h3>
            <div class="space-y-4">
              <div class="p-4 bg-gray-50 dark:bg-gray-800 rounded-lg">
                <div class="text-xs text-gray-500 uppercase mb-1">Referencia</div>
                <div class="font-bold text-gray-800 dark:text-white">Marea AR-2023-001</div>
              </div>
              <div>
                <div class="text-xs text-gray-500 uppercase mb-1">Descripción</div>
                <p class="text-sm text-gray-600 dark:text-gray-400">
                  La marea ha cumplido el tiempo estimado de navegación. Se requiere el registro
                  formal del arribo a puerto para continuar con el proceso.
                </p>
              </div>
              <div class="pt-4 border-t border-gray-100 dark:border-gray-800">
                <h4 class="text-sm font-bold text-gray-800 dark:text-white mb-3">
                  Acciones Disponibles
                </h4>
                <div class="flex flex-col gap-2">
                  <button
                    class="w-full py-2 bg-brand-500 text-white rounded-lg text-sm font-medium"
                  >
                    Registrar Arribo
                  </button>
                  <button
                    class="w-full py-2 bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 rounded-lg text-sm font-medium"
                  >
                    Auto-asignarse
                  </button>
                  <button
                    class="w-full py-2 border border-red-200 text-red-600 rounded-lg text-sm font-medium hover:bg-red-50 transition-colors"
                  >
                    Descartar
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { PlusIcon, DocsIcon } from '@/icons'
</script>
