<template>
    <AdminLayout>
        <BaseDataList title="Gestión de Observadores" description="Administra el personal de observación y técnicos"
            :button-text="canEdit ? 'Nuevo Observador' : undefined" :items="filteredObservadores"
            :is-loading="isLoading" v-model:search="searchQuery" search-placeholder="Buscar observadores..."
            @create="openCreateModal">
            <template #header-actions>
                <button v-if="canEdit" @click="exportData"
                    class="flex items-center justify-center gap-2 rounded-lg bg-success/10 px-4 py-2.5 text-sm font-semibold text-success hover:bg-success/20 transition-colors border border-success/20"
                    title="Exportar a Excel">
                    <DownloadIcon class="w-4 h-4" />
                    <span class="hidden md:inline">Exportar Excel</span>
                </button>
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
                <td class="px-6 py-4 font-mono font-bold text-primary">
                    {{ obs.codigoInterno }}
                </td>
                <td class="px-6 py-4 font-medium text-text whitespace-nowrap">
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
                <td class="px-6 py-4">
                    <span
                        class="bg-info/10 text-info text-[11px] font-bold px-2 py-0.5 rounded-full border border-info/20 uppercase tracking-tighter">
                        {{ TIPO_OBSERVADOR_LABELS[obs.tipoObservador] }}
                    </span>
                </td>
                <td class="px-6 py-4">
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
                    <button @click="openEditModal(obs)"
                        class="w-full py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
                        <component :is="canEdit ? EditIcon : SearchIcon" class="w-4 h-4" />
                        {{ canEdit ? 'Gestionar Registro' : 'Ver Registro' }}
                    </button>
                </div>
            </template>
        </BaseDataList>

        <ObservadorDialog :show="showModal" :observador="selectedObservador" :is-saving="isSaving" :read-only="!canEdit"
            @close="closeModal" @save="handleSave" />
    </AdminLayout>
</template>

<script setup lang="ts">
import { onMounted, computed, ref } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { EditIcon, SearchIcon, ChevronDownIcon, DownloadIcon } from '@/icons';
import ObservadorDialog from '../components/ObservadorDialog.vue'
import BaseDataList from '@/components/common/BaseDataList.vue'
import { useObservadores } from '../composables/useObservadores'
import { TIPO_OBSERVADOR_LABELS, TIPO_CONTRATO_LABELS } from '../constants/observador.constants'
import { getFullImageUrl } from '@/helpers/image.helper'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

const authStore = useAuthStore()
const canEdit = computed(() => {
    const roles = authStore.user?.roles || []
    return roles.includes(ValidRoles.admin) || roles.includes(ValidRoles.coordinador)
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
        let valA = a[sortKey.value]
        let valB = b[sortKey.value]

        if (typeof valA === 'string') {
            return sortOrder.value === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA)
        }

        return sortOrder.value === 'asc' ? (valA > valB ? 1 : -1) : (valA < valB ? 1 : -1)
    })

    return items
})

onMounted(() => {
    fetchObservadores()
})
</script>
