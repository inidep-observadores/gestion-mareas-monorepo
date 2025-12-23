<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">
          Panel Operativo de Mareas
        </h1>
        <p class="text-gray-500 dark:text-gray-400">
          Monitoreo en tiempo real de las operaciones activas.
        </p>
      </div>

      <!-- Operational KPIs -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <div
          class="bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800"
        >
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm text-gray-500 dark:text-gray-400">Navegando</span>
            <div class="p-1.5 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
              <RefreshIcon class="w-5 h-5 text-blue-500" />
            </div>
          </div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">12</div>
        </div>
        <div
          class="bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800"
        >
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm text-gray-500 dark:text-gray-400">Designadas</span>
            <div class="p-1.5 bg-brand-50 dark:bg-brand-900/20 rounded-lg">
              <PlusIcon class="w-5 h-5 text-brand-500" />
            </div>
          </div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">5</div>
        </div>
        <div
          class="bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800"
        >
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm text-gray-500 dark:text-gray-400">En Revisión</span>
            <div class="p-1.5 bg-orange-50 dark:bg-orange-900/20 rounded-lg">
              <DocsIcon class="w-5 h-5 text-orange-500" />
            </div>
          </div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">8</div>
        </div>
        <div
          class="bg-white dark:bg-gray-900 p-4 rounded-xl border border-gray-200 dark:border-gray-800"
        >
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm text-gray-500 dark:text-gray-400">Bloqueadas</span>
            <div class="p-1.5 bg-red-50 dark:bg-red-900/20 rounded-lg">
              <WarningIcon class="w-5 h-5 text-red-500" />
            </div>
          </div>
          <div class="text-2xl font-bold text-gray-800 dark:text-white">2</div>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-6">
        <!-- Main Flight Board -->
        <div class="col-span-12">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-xl overflow-hidden"
          >
            <div
              class="p-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between"
            >
              <h2 class="font-bold text-gray-800 dark:text-white">Mareas Activas / Operativas</h2>
              <div class="flex gap-2">
                <input
                  type="text"
                  placeholder="Buscar buque..."
                  class="text-sm px-3 py-1.5 border border-gray-200 dark:border-gray-700 rounded-lg bg-gray-50 dark:bg-gray-800"
                />
              </div>
            </div>
            <div class="overflow-x-auto">
              <table class="w-full text-left">
                <thead
                  class="bg-gray-50 dark:bg-gray-800/50 text-xs uppercase text-gray-500 dark:text-gray-400"
                >
                  <tr>
                    <th class="px-6 py-3">Buque</th>
                    <th class="px-6 py-3">ID Marea</th>
                    <th class="px-6 py-3">Estado Operativo</th>
                    <th class="px-6 py-3">Zarpada</th>
                    <th class="px-6 py-3">Progreso</th>
                    <th class="px-6 py-3">Alertas</th>
                    <th class="px-6 py-3 text-right">Acciones</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
                  <tr
                    v-for="i in 8"
                    :key="i"
                    class="hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
                  >
                    <td class="px-6 py-4 font-medium text-gray-900 dark:text-white">
                      BP PESCADOR {{ i }}
                    </td>
                    <td class="px-6 py-4 text-gray-500 font-mono text-xs">MA-23-0{{ i }}55</td>
                    <td class="px-6 py-4">
                      <span
                        :class="[
                          'px-2 py-0.5 rounded text-xs font-medium',
                          i % 3 === 0
                            ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
                            : i % 4 === 0
                              ? 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
                              : 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400',
                        ]"
                      >
                        {{ i % 3 === 0 ? 'Navegando' : i % 4 === 0 ? 'Bloqueada' : 'Arribada' }}
                      </span>
                    </td>
                    <td class="px-6 py-4 text-sm text-gray-500">2023-12-{{ 10 + i }}</td>
                    <td class="px-6 py-4">
                      <div
                        class="w-24 h-1.5 bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden"
                      >
                        <div
                          class="h-full bg-brand-500"
                          :style="{ width: 20 + i * 10 + '%' }"
                        ></div>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <span v-if="i % 4 === 0" class="flex items-center text-red-500 gap-1">
                        <WarningIcon class="w-4 h-4" />
                        <span class="text-xs font-bold">Crítica</span>
                      </span>
                      <span v-else class="text-gray-400 text-xs">-</span>
                    </td>
                    <td class="px-6 py-4 text-right">
                      <button
                        class="p-1 hover:bg-gray-100 dark:hover:bg-gray-800 rounded text-gray-500"
                      >
                        <DocsIcon class="w-5 h-5" />
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { RefreshIcon, PlusIcon, DocsIcon, WarningIcon } from '@/icons'
</script>
