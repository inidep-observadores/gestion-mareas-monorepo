<template>
  <AdminDashboardLayout>
    <!-- Toggle vista -->
    <div class="flex items-center justify-between mb-4">
      <div></div>
      <div class="flex items-center gap-2">
        <span class="text-xs text-text-muted font-medium mr-1">Vista:</span>
        <div class="inline-flex rounded-lg border border-border bg-surface p-1 gap-1">
          <button
            @click="viewMode = 'tabla'"
            :class="[
              'flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-bold transition-colors',
              viewMode === 'tabla'
                ? 'bg-primary text-primary-fg shadow-sm'
                : 'text-text-muted hover:text-text hover:bg-surface-muted'
            ]"
          >
            <TableIcon class="w-3.5 h-3.5" />
            Tabla
          </button>
          <button
            @click="viewMode = 'diagrama'"
            :class="[
              'flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-bold transition-colors',
              viewMode === 'diagrama'
                ? 'bg-primary text-primary-fg shadow-sm'
                : 'text-text-muted hover:text-text hover:bg-surface-muted'
            ]"
          >
            <LayersIcon class="w-3.5 h-3.5" />
            Diagrama
          </button>
        </div>
      </div>
    </div>

    <!-- Vista: Tabla -->
    <BaseDataList
      v-if="viewMode === 'tabla'"
      title="Transiciones de Estado de Mareas"
      description="Configura los flujos permitidos entre estados y las acciones disponibles en cada etapa"
      :button-text="canEdit ? 'Nueva Transición' : undefined"
      :items="filteredTransiciones"
      :is-loading="isLoading"
      v-model:search="searchQuery"
      search-placeholder="Buscar por estado, acción o etiqueta..."
      @create="openCreateModal"
    >
      <!-- Tabla: cabeceras -->
      <template #table-header>
        <th scope="col" class="px-6 py-3">Origen</th>
        <th scope="col" class="px-6 py-3 text-center">→</th>
        <th scope="col" class="px-6 py-3">Destino</th>
        <th scope="col" class="px-6 py-3">Código de Acción</th>
        <th scope="col" class="px-6 py-3">Etiqueta</th>
        <th scope="col" class="px-6 py-3">Estilo</th>
        <th scope="col" class="px-6 py-3 text-center">Req. Obs.</th>
        <th scope="col" class="px-6 py-3 text-center">En Panel</th>
        <th scope="col" class="px-6 py-3 text-center">Estado</th>
        <th scope="col" class="px-6 py-3 text-right">Acciones</th>
      </template>

      <!-- Tabla: filas -->
      <template #table-row="{ item: t }">
        <td class="px-6 py-4">
          <div class="font-bold text-text text-sm leading-tight">{{ t.estadoOrigen?.nombre }}</div>
          <div class="text-[10px] font-mono text-text-muted mt-0.5">{{ t.estadoOrigen?.codigo }}</div>
        </td>
        <td class="px-6 py-4 text-center">
          <ArrowRightIcon class="w-4 h-4 text-primary mx-auto" />
        </td>
        <td class="px-6 py-4">
          <div class="font-bold text-text text-sm leading-tight">{{ t.estadoDestino?.nombre }}</div>
          <div class="text-[10px] font-mono text-text-muted mt-0.5">{{ t.estadoDestino?.codigo }}</div>
        </td>
        <td class="px-6 py-4">
          <span class="font-mono text-xs text-primary font-bold bg-primary/5 px-2 py-1 rounded">
            {{ t.accion }}
          </span>
        </td>
        <td class="px-6 py-4 font-medium text-sm">{{ t.etiqueta }}</td>
        <td class="px-6 py-4">
          <span :class="[btnBadgeClass(t.claseBoton), 'px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-tight']">
            {{ t.claseBoton || '—' }}
          </span>
        </td>
        <td class="px-6 py-4 text-center">
          <span :class="t.requiereObs ? 'text-warning' : 'text-text-muted/40'" class="text-base">
            {{ t.requiereObs ? '●' : '○' }}
          </span>
        </td>
        <td class="px-6 py-4 text-center">
          <span :class="t.mostrarEnPanel ? 'text-success' : 'text-text-muted/40'" class="text-base">
            {{ t.mostrarEnPanel ? '●' : '○' }}
          </span>
        </td>
        <td class="px-6 py-4 text-center">
          <span :class="[
            'px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-tight',
            t.activo ? 'bg-success/10 text-success' : 'bg-error/10 text-error'
          ]">
            {{ t.activo ? 'Activo' : 'Inactivo' }}
          </span>
        </td>
        <td class="px-6 py-4 text-right">
          <div class="flex items-center justify-end gap-3">
            <button v-if="canEdit" @click="openEditModal(t)"
              class="font-bold text-primary hover:underline text-sm">
              Editar
            </button>
            <button v-if="canEdit" @click="confirmDelete(t)"
              :disabled="isDeleting && deleteTargetId === t.id"
              class="font-bold text-error hover:underline text-sm disabled:opacity-40">
              {{ isDeleting && deleteTargetId === t.id ? '...' : 'Eliminar' }}
            </button>
            <button v-if="!canEdit" @click="openEditModal(t)"
              class="font-bold text-primary hover:underline text-sm">
              Ver Detalle
            </button>
          </div>
        </td>
      </template>

      <!-- Card móvil -->
      <template #card-item="{ item: t }">
        <div class="flex justify-between items-start mb-3">
          <div class="flex-1 min-w-0">
            <div class="font-black text-text text-base leading-tight mb-1">{{ t.etiqueta }}</div>
            <div class="font-mono text-xs text-primary bg-primary/5 px-2 py-0.5 rounded inline-block">
              {{ t.accion }}
            </div>
          </div>
          <span :class="[
            'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-widest ml-2 flex-shrink-0',
            t.activo ? 'bg-success/10 text-success' : 'bg-error/10 text-error'
          ]">{{ t.activo ? 'Activo' : 'Inactivo' }}</span>
        </div>

        <div class="flex items-center gap-2 my-3 p-3 bg-surface-muted rounded-xl border border-border">
          <div class="flex-1 min-w-0">
            <div class="text-[10px] text-text-muted uppercase font-black mb-0.5">Origen</div>
            <div class="text-xs font-bold text-text truncate">{{ t.estadoOrigen?.nombre }}</div>
          </div>
          <ArrowRightIcon class="w-4 h-4 text-primary flex-shrink-0" />
          <div class="flex-1 min-w-0 text-right">
            <div class="text-[10px] text-text-muted uppercase font-black mb-0.5">Destino</div>
            <div class="text-xs font-bold text-text truncate">{{ t.estadoDestino?.nombre }}</div>
          </div>
        </div>

        <div class="flex items-center gap-3 mb-3">
          <span :class="[btnBadgeClass(t.claseBoton), 'px-2.5 py-1 rounded-full text-[11px] font-bold uppercase']">
            {{ t.claseBoton || '—' }}
          </span>
          <span v-if="t.requiereObs" class="text-[10px] text-warning font-bold uppercase tracking-widest">
            Req. Obs.
          </span>
          <span v-if="!t.mostrarEnPanel" class="text-[10px] text-text-muted font-bold uppercase tracking-widest border border-border rounded px-1.5 py-0.5">
            Oculto en panel
          </span>
        </div>

        <div class="pt-3 border-t border-border flex gap-2">
          <button @click="openEditModal(t)"
            class="flex-1 py-2 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
            <EditIcon class="w-4 h-4" />
            {{ canEdit ? 'Editar' : 'Ver Detalle' }}
          </button>
          <button v-if="canEdit" @click="confirmDelete(t)"
            :disabled="isDeleting && deleteTargetId === t.id"
            class="px-3 py-2 text-sm font-bold text-error bg-error/10 rounded-lg hover:bg-error/20 transition-colors disabled:opacity-40">
            <TrashIcon class="w-4 h-4" />
          </button>
        </div>
      </template>
    </BaseDataList>

    <!-- Vista: Diagrama -->
    <div v-else class="bg-surface rounded-2xl border border-border shadow-theme-xs">
      <!-- Cabecera del diagrama -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 px-6 py-5 border-b border-border">
        <div>
          <h2 class="text-base font-black text-text">Diagrama de Flujo de Mareas</h2>
          <p class="text-xs text-text-muted mt-0.5">Ciclo de vida completo según las transiciones configuradas</p>
        </div>
        <div class="flex items-center gap-3 flex-wrap">
          <!-- Toggle layout -->
          <div class="inline-flex rounded-lg border border-border bg-surface-muted p-0.5 gap-0.5">
            <button
              @click="diagramLayout = 'hierarchical'"
              :class="[
                'flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-bold transition-all',
                diagramLayout === 'hierarchical'
                  ? 'bg-surface text-text shadow-sm'
                  : 'text-text-muted hover:text-text'
              ]"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="2" x2="12" y2="6"/><circle cx="12" cy="8" r="2"/><line x1="12" y1="10" x2="6" y2="14"/><line x1="12" y1="10" x2="18" y2="14"/><circle cx="6" cy="16" r="2"/><circle cx="18" cy="16" r="2"/>
              </svg>
              Jerárquico
            </button>
            <button
              @click="diagramLayout = 'adaptive'"
              :class="[
                'flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-bold transition-all',
                diagramLayout === 'adaptive'
                  ? 'bg-surface text-text shadow-sm'
                  : 'text-text-muted hover:text-text'
              ]"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="5" cy="12" r="2"/><circle cx="19" cy="5" r="2"/><circle cx="19" cy="19" r="2"/><line x1="7" y1="12" x2="17" y2="6"/><line x1="7" y1="12" x2="17" y2="18"/>
              </svg>
              Adaptativo
            </button>
          </div>

          <!-- Copiar código Mermaid -->
          <button
            @click="copyMermaid"
            :title="copied ? 'Copiado!' : 'Copiar código Mermaid'"
            :class="[
              'flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border text-xs font-medium transition-all',
              copied
                ? 'border-success/40 bg-success/10 text-success'
                : 'border-border text-text-muted hover:text-text hover:bg-surface-muted'
            ]"
          >
            <svg v-if="!copied" xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
            {{ copied ? 'Copiado' : 'Mermaid' }}
          </button>

          <!-- Toggle inactivas -->
          <label class="flex items-center gap-2 cursor-pointer select-none">
            <div
              @click="showInactive = !showInactive"
              :class="[
                'relative w-9 h-5 rounded-full transition-colors cursor-pointer',
                showInactive ? 'bg-primary' : 'bg-border'
              ]"
            >
              <span :class="[
                'absolute top-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform',
                showInactive ? 'translate-x-4' : 'translate-x-0.5'
              ]" />
            </div>
            <span class="text-xs font-medium text-text-muted">Mostrar inactivas</span>
          </label>
          <!-- Botón nueva transición -->
          <button
            v-if="canEdit"
            @click="openCreateModal"
            class="flex items-center gap-2 rounded-lg bg-primary px-3 py-2 text-xs font-semibold text-primary-fg hover:bg-primary/90 transition-colors"
          >
            + Nueva Transición
          </button>
        </div>
      </div>

      <!-- Diagrama Mermaid -->
      <div class="p-6">
        <div v-if="isLoading" class="flex items-center justify-center py-16 text-text-muted">
          <span class="w-5 h-5 border-2 border-primary border-t-transparent rounded-full animate-spin mr-3" />
          <span class="text-sm font-medium">Cargando transiciones...</span>
        </div>
        <template v-else-if="transiciones.length === 0">
          <p class="text-center text-sm text-text-muted py-12">
            No hay transiciones configuradas aún.
          </p>
        </template>
        <template v-else>
          <MermaidDiagram :definition="diagramDefinition" />
        </template>
      </div>

      <!-- Leyenda -->
      <div class="px-6 pb-5 flex flex-wrap items-center gap-x-5 gap-y-2">
        <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-1">Leyenda:</span>
        <div class="flex items-center gap-1.5">
          <div class="w-3 h-3 rounded bg-blue-100 border border-blue-400"></div>
          <span class="text-[11px] text-text-muted">Pendiente</span>
        </div>
        <div class="flex items-center gap-1.5">
          <div class="w-3 h-3 rounded bg-amber-100 border border-amber-400"></div>
          <span class="text-[11px] text-text-muted">En curso</span>
        </div>
        <div class="flex items-center gap-1.5">
          <div class="w-3 h-3 rounded bg-green-100 border border-green-500"></div>
          <span class="text-[11px] text-text-muted">Completado</span>
        </div>
        <div class="flex items-center gap-1.5">
          <div class="w-3 h-3 rounded bg-red-100 border border-red-400"></div>
          <span class="text-[11px] text-text-muted">Cancelado</span>
        </div>
        <div class="flex items-center gap-1.5">
          <div class="w-5 border-t-2 border-dashed border-text-muted/50"></div>
          <span class="text-[11px] text-text-muted">Transición inactiva</span>
        </div>
      </div>
    </div>

    <!-- Dialog -->
    <TransicionEstadoDialog
      :show="isModalOpen"
      :transicion="currentTransicion"
      :estados="estados"
      :is-saving="isSaving"
      @close="closeModal"
      @save="handleSave"
    />

    <!-- Confirmación eliminación -->
    <div v-if="showDeleteConfirm"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm">
      <div class="bg-surface rounded-2xl border border-border shadow-theme-lg p-6 max-w-sm w-full mx-4">
        <h3 class="text-base font-black text-text mb-2">¿Eliminar transición?</h3>
        <p class="text-sm text-text-muted mb-6">
          Se eliminará la transición
          <span class="font-bold text-text">{{ deleteTarget?.estadoOrigen?.nombre }} → {{ deleteTarget?.estadoDestino?.nombre }}</span>.
          Esta acción no se puede deshacer.
        </p>
        <div class="flex gap-3 justify-end">
          <button @click="cancelDelete"
            class="px-4 py-2 rounded-lg border border-border text-sm font-bold text-text-muted hover:bg-surface-muted transition-colors">
            Cancelar
          </button>
          <button @click="executeDelete"
            :disabled="isDeleting"
            class="px-4 py-2 rounded-lg bg-error text-white text-sm font-bold hover:bg-error/90 transition-colors disabled:opacity-50 flex items-center gap-2">
            <span v-if="isDeleting" class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
            {{ isDeleting ? 'Eliminando...' : 'Eliminar' }}
          </button>
        </div>
      </div>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { onMounted, computed, ref } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import BaseDataList from '@/components/common/BaseDataList.vue'
import TransicionEstadoDialog from '../components/TransicionEstadoDialog.vue'
import MermaidDiagram from '../components/MermaidDiagram.vue'
import { useTransicionesEstado } from '../composables/useTransicionesEstado'
import { ArrowRightIcon, EditIcon, TrashIcon, TableIcon, LayersIcon } from '@/icons'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'
import type { TransicionEstado } from '../interfaces/transicion-estado.interface'

const authStore = useAuthStore()
const canEdit = computed(() => {
  const roles = authStore.user?.roles || []
  return roles.includes(ValidRoles.admin)
})

const {
  isLoading,
  isSaving,
  isDeleting,
  deleteTargetId,
  searchQuery,
  isModalOpen,
  currentTransicion,
  estados,
  transiciones,
  filteredTransiciones,
  fetchTransiciones,
  fetchEstados,
  openCreateModal,
  openEditModal,
  closeModal,
  handleSave,
  handleDelete,
} = useTransicionesEstado()

// --- Vista ---
const viewMode = ref<'tabla' | 'diagrama'>('tabla')
const showInactive = ref(false)
const diagramLayout = ref<'hierarchical' | 'adaptive'>('hierarchical')
const copied = ref(false)

const copyMermaid = async () => {
  await navigator.clipboard.writeText(diagramDefinition.value)
  copied.value = true
  setTimeout(() => { copied.value = false }, 2000)
}

// --- Diagrama Mermaid ---
const CATEGORIA_CLASS: Record<string, string> = {
  PENDIENTE: 'pendiente',
  EN_CURSO: 'enCurso',
  COMPLETADO: 'completado',
  CANCELADO: 'cancelado',
}

const diagramDefinition = computed(() => {
  if (!transiciones.value.length) return ''

  const lines: string[] = [
    diagramLayout.value === 'adaptive'
      ? '%%{init: {"theme": "neutral", "layout": "elk", "elk": {"mergeEdges": false, "nodePlacementStrategy": "LINEAR_SEGMENTS"}, "flowchart": {"curve": "basis", "padding": 16}}}%%'
      : '%%{init: {"theme": "neutral", "flowchart": {"curve": "basis", "padding": 16, "rankSpacing": 55, "nodeSpacing": 40}}}%%',
    'flowchart TB',
    '  classDef pendiente fill:#dbeafe,stroke:#3b82f6,color:#1e40af,font-weight:bold',
    '  classDef enCurso fill:#fef3c7,stroke:#f59e0b,color:#92400e,font-weight:bold',
    '  classDef completado fill:#d1fae5,stroke:#10b981,color:#065f46,font-weight:bold',
    '  classDef cancelado fill:#fee2e2,stroke:#ef4444,color:#7f1d1d,font-weight:bold',
  ]

  // Solo incluir estados que aparecen en transiciones que se van a renderizar
  const visibleTransiciones = transiciones.value.filter(t => t.activo || showInactive.value)
  const statesMap = new Map<string, typeof transiciones.value[0]['estadoOrigen'] & {}>()
  visibleTransiciones.forEach(t => {
    if (t.estadoOrigen) statesMap.set(t.estadoOrigen.codigo, t.estadoOrigen)
    if (t.estadoDestino) statesMap.set(t.estadoDestino.codigo, t.estadoDestino)
  })
  const sortedStates = [...statesMap.values()].sort((a, b) => (a?.orden ?? 0) - (b?.orden ?? 0))

  // Node definitions
  sortedStates.forEach(e => {
    if (e) lines.push(`  ${e.codigo}["${e.nombre}"]`)
  })

  // Active transitions
  transiciones.value
    .filter(t => t.activo)
    .forEach(t => {
      const label = t.etiqueta.replace(/"/g, "'")
      lines.push(`  ${t.estadoOrigen!.codigo} -->|"${label}"| ${t.estadoDestino!.codigo}`)
    })

  // Inactive transitions (dashed), only if toggle is on
  if (showInactive.value) {
    transiciones.value
      .filter(t => !t.activo)
      .forEach(t => {
        const label = t.etiqueta.replace(/"/g, "'")
        lines.push(`  ${t.estadoOrigen!.codigo} -.->|"${label}"| ${t.estadoDestino!.codigo}`)
      })
  }

  // Apply category classes
  sortedStates.forEach(e => {
    if (e) {
      const cls = CATEGORIA_CLASS[e.categoria] ?? 'pendiente'
      lines.push(`  class ${e.codigo} ${cls}`)
    }
  })

  return lines.join('\n')
})

// --- Confirmación de eliminación ---
const showDeleteConfirm = ref(false)
const deleteTarget = ref<TransicionEstado | null>(null)

const confirmDelete = (t: TransicionEstado) => {
  deleteTarget.value = t
  showDeleteConfirm.value = true
}

const cancelDelete = () => {
  showDeleteConfirm.value = false
  deleteTarget.value = null
}

const executeDelete = async () => {
  if (!deleteTarget.value) return
  await handleDelete(deleteTarget.value.id)
  showDeleteConfirm.value = false
  deleteTarget.value = null
}

// --- Badge estilo botón ---
const btnBadgeClass = (clase?: string | null) => {
  const map: Record<string, string> = {
    primary: 'bg-primary/10 text-primary',
    secondary: 'bg-surface-muted text-text-muted border border-border',
    success: 'bg-success/10 text-success',
    warning: 'bg-warning/10 text-warning',
    error: 'bg-error/10 text-error',
  }
  return map[clase ?? ''] ?? 'bg-surface-muted text-text-muted'
}

onMounted(() => {
  fetchTransiciones()
  fetchEstados()
})
</script>
