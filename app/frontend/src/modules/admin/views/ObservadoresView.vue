<template>
    <AdminLayout>
        <div class="sticky top-[56px] lg:top-[72px] z-30 bg-surface pt-2 pb-3 -mx-4 px-4 sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8 border-b border-border mb-6 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <BackButton routeName="SistemaObservadores" label="Regresar al Panel" />
            <SearchInput
                v-model="searchQuery"
                placeholder="Buscar observadores..."
                class="w-full sm:max-w-xs"
            />
        </div>

        <div class="flex flex-col xl:flex-row items-start gap-6 relative">
            <div class="flex-1 min-w-0 w-full">
                <BaseDataList 
                    title="Gestión de Observadores" 
                    description="Administra el personal de observación y técnicos"
                    :button-text="canEdit ? 'Nuevo Observador' : undefined" 
                    :items="filteredObservadores"
                    :is-loading="isLoading" 
                    :show-search="false"
                    @create="openCreateModal"
                >
                    <template #header-actions>
                        <ExportExcelButton 
                            v-if="canEdit"
                            :loading="isLoading"
                            title="Exportar a Excel"
                            @click="exportData"
                            class="bg-success/10 border border-success/20"
                        />
                    </template>
                    <template #table-header>
                        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('codigoInterno')">
                            <div class="flex items-center gap-2">
                                Código
                                <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                                    sortKey === 'codigoInterno' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                                    sortKey === 'codigoInterno' && sortOrder === 'asc' ? 'rotate-180' : ''
                                ]" />
                            </div>
                        </th>
                        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('apellido')">
                            <div class="flex items-center gap-2">
                                Nombre
                                <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                                    sortKey === 'apellido' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                                    sortKey === 'apellido' && sortOrder === 'asc' ? 'rotate-180' : ''
                                ]" />
                            </div>
                        </th>
                        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('tipoObservador')">
                            <div class="flex items-center gap-2">
                                Tipo
                                <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                                    sortKey === 'tipoObservador' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                                    sortKey === 'tipoObservador' && sortOrder === 'asc' ? 'rotate-180' : ''
                                ]" />
                            </div>
                        </th>
                        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('activo')">
                            <div class="flex items-center gap-2">
                                Estado
                                <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                                    sortKey === 'activo' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                                    sortKey === 'activo' && sortOrder === 'asc' ? 'rotate-180' : ''
                                ]" />
                            </div>
                        </th>
                        <th scope="col" class="px-6 py-3 text-right">Acciones</th>
                    </template>

                    <template #table-row="{ item: obs }">
                        <td class="px-6 py-4 font-mono font-bold text-primary cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(obs)">
                            {{ obs.codigoInterno }}
                        </td>
                        <td class="px-6 py-4 font-medium text-text whitespace-nowrap cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(obs)">
                            <div class="flex items-center gap-3">
                                <img :src="getFullImageUrl(obs.fotoUrl)"
                                    class="w-8 h-8 rounded-full object-cover shadow-sm border border-border" alt="Foto">
                                <div>
                                    <div class="font-semibold">{{ obs.apellido }}, {{ obs.nombre }}</div>
                                    <div class="text-[11px] text-text-muted font-medium">{{
                                        TIPO_CONTRATO_LABELS[obs.tipoContrato] }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(obs)">
                            <span
                                class="bg-info/10 text-info text-[11px] font-bold px-2 py-0.5 rounded-full border border-info/20 uppercase tracking-tighter">
                                {{ TIPO_OBSERVADOR_LABELS[obs.tipoObservador] }}
                            </span>
                        </td>
                        <td class="px-6 py-4 cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(obs)">
                            <div class="flex flex-col gap-1">
                                <span :class="[
                                    'text-[10px] font-bold px-2 py-0.5 rounded-full w-fit uppercase tracking-wider',
                                    obs.activo ? 'bg-success/10 text-success' : 'bg-error/10 text-error'
                                ]">
                                    {{ obs.activo ? 'Activo' : 'Inactivo' }}
                                </span>
                                <span v-if="obs.activo" :class="[
                                    'text-[10px] font-bold px-2 py-0.5 rounded-full w-fit uppercase tracking-wider',
                                    obs.disponible ? 'bg-primary/10 text-primary' : 'bg-warning/10 text-warning'
                                ]">
                                    {{ obs.disponible ? 'Disponible' : 'No disponible' }}
                                </span>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <button @click="openEditModal(obs)" class="font-bold text-primary hover:underline">
                                {{ canEdit ? 'Editar' : 'Ver Detalle' }}
                            </button>
                        </td>
                    </template>

                    <template #card-item="{ item: obs }">
                        <div class="cursor-pointer hover:bg-surface-muted/30 transition-colors rounded-xl -mx-2 -mt-2 p-2" @click="openSidePanel(obs)">
                            <div class="flex items-start gap-4 mb-4">
                                <img :src="getFullImageUrl(obs.fotoUrl)"
                                    class="w-16 h-16 rounded-xl object-cover shadow-sm border border-border" alt="Foto">
                                <div class="flex-1 min-w-0">
                                    <div class="flex items-center gap-2 mb-1.5">
                                        <span class="text-[10px] font-black bg-info/10 text-info px-2 py-0.5 rounded-md uppercase">
                                            ID {{ obs.codigoInterno }}
                                        </span>
                                        <span :class="[
                                            'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-widest',
                                            obs.activo ? 'bg-success/10 text-success' : 'bg-error/10 text-error'
                                        ]">
                                            {{ obs.activo ? 'Activo' : 'Inactivo' }}
                                        </span>
                                    </div>
                                    <div class="font-extrabold text-text text-base truncate">{{ obs.apellido }}, {{ obs.nombre }}
                                    </div>
                                    <div class="text-xs text-text-muted font-medium truncate">{{
                                        TIPO_CONTRATO_LABELS[obs.tipoContrato] }}</div>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-3 mb-4 p-3 bg-surface-muted rounded-xl border border-border">
                                <div>
                                    <div class="text-[10px] text-text-muted uppercase font-black mb-1">Categoría</div>
                                    <div class="text-xs font-bold text-text uppercase tracking-tight">
                                        {{ TIPO_OBSERVADOR_LABELS[obs.tipoObservador] }}
                                    </div>
                                </div>
                                <div v-if="obs.activo">
                                    <div class="text-[10px] text-text-muted uppercase font-black mb-1">Estado Actual</div>
                                    <div :class="[
                                        'text-xs font-bold uppercase tracking-tight',
                                        obs.disponible ? 'text-primary' : 'text-warning'
                                    ]">
                                        {{ obs.disponible ? 'Disponible' : 'En Marea' }}
                                    </div>
                                </div>
                            </div>

                            <div class="pt-3 border-t border-border">
                                <button @click.stop="openEditModal(obs)"
                                    class="w-full py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
                                    <component :is="canEdit ? EditIcon : SearchIcon" class="w-4 h-4" />
                                    {{ canEdit ? 'Gestionar Registro' : 'Ver Registro' }}
                                </button>
                            </div>
                        </div>
                    </template>
                </BaseDataList>
            </div>

            <!-- PANEL DE DETALLE LATERAL PERSISTENTE -->
            <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="translate-x-4 opacity-0"
                enter-to-class="translate-x-0 opacity-100" leave-active-class="transition duration-200 ease-in"
                leave-from-class="translate-x-0 opacity-100" leave-to-class="translate-x-4 opacity-0">
                <div v-if="showSidePanel && sidePanelObservador"
                    class="w-full xl:w-[350px] 2xl:w-[450px] shrink-0 sticky top-24 h-[calc(100vh-7rem)] flex flex-col bg-surface border border-border rounded-2xl shadow-sm overflow-hidden self-start z-10 hidden xl:block">
                    <ObservadorDetailContent
                        :observador="sidePanelObservador"
                        @close="closeSidePanel"
                    />
                </div>
            </Transition>
        </div>

        <!-- ObservadorDetailContent (Mobile Modal) -->
        <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="opacity-0" 
            enter-to-class="opacity-100" leave-active-class="transition duration-200 ease-in" leave-from-class="opacity-100" 
            leave-to-class="opacity-0">
            <div v-if="showSidePanel && sidePanelObservador !== null" class="fixed inset-0 z-50 xl:hidden">
                <!-- Backdrop -->
                <div class="fixed inset-0 bg-black/25 backdrop-blur-sm" @click="closeSidePanel"></div>
                <!-- Contenido -->
                <div class="fixed inset-0 overflow-y-auto pointer-events-none">
                    <div class="flex min-h-full items-center justify-center p-4 text-center">
                        <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="opacity-0 scale-95" 
                            enter-to-class="opacity-100 scale-100" leave-active-class="transition duration-200 ease-in" 
                            leave-from-class="opacity-100 scale-100" leave-to-class="opacity-0 scale-95">
                            <div v-if="showSidePanel && sidePanelObservador !== null" class="w-full max-w-md transform overflow-hidden rounded-2xl bg-surface text-left align-middle shadow-xl transition-all pointer-events-auto flex flex-col h-[90vh] max-h-[90vh]">
                                <ObservadorDetailContent
                                    :observador="sidePanelObservador"
                                    @close="closeSidePanel"
                                    class="flex-1 min-h-0"
                                />
                            </div>
                        </Transition>
                    </div>
                </div>
            </div>
        </Transition>

        <ObservadorDialog :show="showModal" :observador="selectedObservador" :is-saving="isSaving" :read-only="!canEdit"
            @close="closeModal" @save="handleSave" />
    </AdminLayout>
</template>

<script setup lang="ts">
import { onMounted, computed, ref } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BackButton from '@/components/common/BackButton.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import { EditIcon, SearchIcon, ChevronDownIcon, DownloadIcon } from '@/icons';
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue';
import ObservadorDialog from '../components/ObservadorDialog.vue'
import ObservadorDetailContent from '../components/ObservadorDetailContent.vue'
import BaseDataList from '@/components/common/BaseDataList.vue'
import { useObservadores } from '../composables/useObservadores'
import { TIPO_OBSERVADOR_LABELS, TIPO_CONTRATO_LABELS } from '../constants/observador.constants'
import { getFullImageUrl } from '@/helpers/image.helper'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

const authStore = useAuthStore()
const canEdit = computed(() => {
    const roles = authStore.user?.roles || []
    return roles.includes(ValidRoles.admin) || roles.includes(ValidRoles.tecnico)
})

const {
    isLoading,
    searchQuery,
    showModal,
    selectedObservador,
    isSaving,
    filteredObservadores: baseFilteredObservadores,
    fetchObservadores,
    openCreateModal,
    openEditModal,
    closeModal,
    handleSave,
    exportData
} = useObservadores()

// Sorting Logic
const sortKey = ref<string>('apellido')
const sortOrder = ref<'asc' | 'desc'>('asc')

const handleSort = (key: string) => {
    if (sortKey.value === key) {
        sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
    } else {
        sortKey.value = key
        sortOrder.value = 'asc'
    }
}

const getSortIcon = () => ChevronDownIcon

const filteredObservadores = computed(() => {
    const items = [...baseFilteredObservadores.value]

    items.sort((a: any, b: any) => {
        const valA = a[sortKey.value]
        const valB = b[sortKey.value]

        if (typeof valA === 'string') {
            return sortOrder.value === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA)
        }

        return sortOrder.value === 'asc' ? (valA > valB ? 1 : -1) : (valA < valB ? 1 : -1)
    })

    return items
})

// LOGICA DEL PANEL LATERAL
const showSidePanel = ref(false)
const sidePanelObservador = ref<any>(null)

const openSidePanel = (obs: any) => {
    sidePanelObservador.value = obs
    showSidePanel.value = true
}

const closeSidePanel = () => {
    showSidePanel.value = false
    setTimeout(() => { sidePanelObservador.value = null }, 300)
}

onMounted(() => {
    fetchObservadores(true)
})
</script>
